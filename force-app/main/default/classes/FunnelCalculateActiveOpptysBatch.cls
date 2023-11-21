/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelCalculateActiveOpptysBatch implements Database.Batchable<sobject>, Database.Stateful{
    
    Date triggerDate;
    Boolean chainBatch;
    Boolean histVal;
    Boolean errorVal = false;
    
    Map<id,Sales_Rep_Profile__c> ownerProfMap = new Map<id,Sales_Rep_Profile__c>();
        
    Map<Id,Integer> mapCal = new Map<Id,Integer>();
    
    public FunnelCalculateActiveOpptysBatch(Date scheduleDate,Boolean chain, Boolean historical){
        
        triggerDate = scheduleDate;
        system.debug(' triggerDate '+triggerDate);
        chainBatch = chain;
        histVal = historical;
    }
            
    public Database.QueryLocator start(Database.BatchableContext con){
        
        List<Sales_Rep_Profile__c> sp = [SELECT id, User_Record_Name__c,YTD_Average_Sales_Cycle__c FROM Sales_Rep_Profile__c WHERE (Active__c = TRUE OR Annual_Quota_Amount__c > 0) LIMIT 5000];
                
        for(Sales_Rep_Profile__c s: sp){
            if(s.User_Record_Name__c != null)
                ownerProfMap.put(s.User_Record_Name__c,s);
        }                
                
        String triggerDt = String.valueOf(triggerDate);
        String dateTriggerDate = triggerDt.substring(0,10);        
        system.debug(' dateTriggerDate '+dateTriggerDate);  
        
        Datetime dateTimeVal = triggerDate;
        dateTimeVal = dateTimeVal.addDays(1);
        String dateTm = dateTimeVal.formatGMT('yyyy-MM-dd');
        dateTm = dateTm+'T00:00:00Z';
        system.debug(' dateTm '+dateTm);
        String omit = 'Omitted';
        
        List<FunnelMetrics__Funnel_Opp_Stage_Order__mdt> oppStageOrderList = [SELECT id,FunnelMetrics__Stage_Name__c from FunnelMetrics__Funnel_Opp_Stage_Order__mdt];
        Set<String> stages = new Set<String>();
        For(FunnelMetrics__Funnel_Opp_Stage_Order__mdt os : oppStageOrderList){
            stages.add(os.FunnelMetrics__Stage_Name__c);
        }
        /*
        DateTime triggerDtTm = DateTime.newInstanceGmt(triggerDate.year(),triggerDate.month(),triggerDate.day(),0,0,0);
        system.debug(' triggerDtTm '+triggerDtTm); 
        triggerDtTm = triggerDtTm.addDays(1); 
        system.debug(' triggerDtTm '+triggerDtTm);
        String dateTimeFormat = triggerDtTm.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'','GMT');
        system.debug(' dateTimeFormat '+dateTimeFormat);   */   
        //String query = 'SELECT id, name, CreatedDate, CloseDate, Ownerid FROM Opportunity WHERE StageName = '+'\''+'Closed Won'+'\''+' AND CloseDate > '+dateStartDate+' AND CloseDate <= '+dateEndDate;
        String query = 'SELECT id, name, CreatedDate, CloseDate, Ownerid FROM Opportunity WHERE (ForecastCategoryName !=: omit OR StageName in :stages) And CreatedDate < '+dateTm+' AND CloseDate > '+dateTriggerDate;        
        System.debug('query == '+query);
        return Database.getQueryLocator(query);
    }                
    
    public void execute(Database.BatchableContext con, List<Opportunity> opps){                
        
        try{
            system.debug(opps);
            for(Opportunity o: opps){
                if(mapCal.keySet() == null || (!mapCal.keyset().contains(o.ownerId))){
                    mapCal.put(o.ownerId,1);                
                }
                else{ 
                    Integer count = mapCal.get(o.ownerid);
                    count++;
                    mapCal.put(o.ownerid,count);
                }
            } 
        }
        catch(Exception ex){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelCalculateActiveOpptysBatch '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        }                                            
    }        
    
    public void finish(Database.BatchableContext con){
        //FunnelTriggerBatchHelper.sendErrorMail(' FunnelCalculateActiveOpptysBatch finish method');
        if(!errorVal){     
            //FunnelTriggerBatchHelper.sendErrorMail(' FunnelCalculateActiveOpptysBatch finish method no error ');   
            system.debug(' ownerProfMap '+ownerProfMap);
            system.debug(' mapCal '+mapCal);
            
            for(Id i: ownerProfMap.keySet()){
                if(mapCal.get(i) != null){
                    ownerProfMap.get(i).Current_Active_Opportunities__c = mapCal.get(i);
                }
                else{
                    ownerProfMap.get(i).Current_Active_Opportunities__c = 0;
                }
            }        
            
            system.debug(' ownerProfMap.values() '+ownerProfMap.values());
            update ownerProfMap.values();                        
            system.debug(' triggerDate '+triggerDate);

            if(histVal){        
                FunnelCalculateHistoricalDataBatch  fb3 = new FunnelCalculateHistoricalDataBatch(triggerDate,true);
                Database.executeBatch(fb3);
            }
       }
        
    }            
    
}