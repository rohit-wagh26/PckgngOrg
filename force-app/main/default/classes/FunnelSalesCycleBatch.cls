/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelSalesCycleBatch implements Database.Batchable<sobject>, Database.Stateful{
    
    Date triggerDate;
    Boolean chainBatch;
    Boolean histVal;

    Boolean errorVal = false;
    
    Map<id,Sales_Rep_Profile__c> ownerProfMap = new Map<id,Sales_Rep_Profile__c>();
        
    Map<Id,avgWrapper> mapCal = new Map<Id,avgWrapper>();
    
    Boolean updateAccess;
    
    public static String prefix{ get{return 'FunnelMetrics__';} set; }    
    
    public FunnelSalesCycleBatch(Date scheduleDate,Boolean chain, Boolean historical){
        triggerDate = scheduleDate;
        chainBatch = chain;
        histVal = historical;
    }
            
    public Database.QueryLocator start(Database.BatchableContext con){
        
        List<Sales_Rep_Profile__c> sp = [SELECT id, User_Record_Name__c, X12_Month_Rolling_Average_Sales_Cycle__c FROM Sales_Rep_Profile__c WHERE Active__c = TRUE LIMIT 5000];
                
        for(Sales_Rep_Profile__c s: sp){
            if(s.User_Record_Name__c != null)
                ownerProfMap.put(s.User_Record_Name__c,s);
        }                
                
        Date startDate = triggerDate.addMonths(-12);
        String startDt = String.valueOf(startDate);
        String endDt = String.valueOf(triggerDate);
        String dateStartDate = startDt.substring(0,10);
        String dateEndDate = endDt.substring(0,10);        
        system.debug('dateStartDate '+dateStartDate );       
        system.debug('dateEndDate '+dateEndDate );          
        
        updateAccess = true;
        
        String omit = 'Omitted';
        
        /*
        List<String> fldList1 = new List<String>{prefix+'X12_Month_Rolling_Average_Sales_Cycle__c'};                    
            
        Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile__c').getDescribe().fields.getMap();
        
        for(String fldName: fldList1){
            
            if(!fieldMap1.get(fldName).getDescribe().isUpdateable()){
                system.debug(' fldName '+fldName);
                updateAccess = false;
            }                           
        }*/
            
        //String query = 'SELECT id, name, CreatedDate, CloseDate, Ownerid FROM Opportunity WHERE StageName = '+'\''+'Closed Won'+'\''+' AND CloseDate > '+dateStartDate+' AND CloseDate <= '+dateEndDate;
        String query = 'SELECT id, name, CreatedDate, CloseDate, Ownerid FROM Opportunity WHERE ForecastCategoryName !=: omit And IsClosed = true AND CloseDate > '+dateStartDate+' AND CloseDate <= '+dateEndDate;
        return Database.getQueryLocator(query);
    }        
    
    class avgWrapper{
        Integer count;
        Integer daysToClose;
    }
    
    public void execute(Database.BatchableContext con, List<Opportunity> opps){                
        try{
            if(updateAccess){    
                system.debug(opps);
                for(Opportunity o: opps){
                    system.debug('created '+o.CreatedDate.date());
                    system.debug('closed '+o.CloseDate);
                    system.debug('name '+o.name);
                    if(mapCal.keySet() == null || (!mapCal.keyset().contains(o.ownerId))){
                        avgWrapper a = new avgWrapper();
                        a.count = 1;
                        a.daysToClose = o.CreatedDate.date().daysBetween(o.CloseDate);
                        mapCal.put(o.ownerId,a);                
                    }
                    else{                
                        mapCal.get(o.ownerid).count++;
                        mapCal.get(o.ownerid).daysToClose = mapCal.get(o.ownerid).daysToClose + o.CreatedDate.date().daysBetween(o.CloseDate);   
                    }
                } 
            }  
        }
        catch(Exception ex){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelSalesCycleBatch '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber());
        } 
                                      
    }        
    
    public void finish(Database.BatchableContext con){
        try{
            //FunnelTriggerBatchHelper.sendErrorMail(' FunnelSalesCycleBatch finish method');    
            if(updateAccess){    
                if(!errorVal){
                    
                    //FunnelTriggerBatchHelper.sendErrorMail(' FunnelSalesCycleBatch finish method no error '); 
                    
                    system.debug(' ownerProfMap '+ownerProfMap);
                    system.debug(' chainBatch '+chainBatch);
                    
                    for(Id i: ownerProfMap.keySet()){
                        if(mapCal.get(i) != null){
                            ownerProfMap.get(i).X12_Month_Rolling_Average_Sales_Cycle__c = mapCal.get(i).daysToClose/mapCal.get(i).count;
                        }
                        else{
                            ownerProfMap.get(i).X12_Month_Rolling_Average_Sales_Cycle__c = 0;
                        }
                    }
                    
                    //if(Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile__c').getDescribe().isUpdateable()){
                        update ownerProfMap.values();
                    //}
                    if(chainBatch){
                        system.debug(' histDateVal '+triggerDate);

                        FunnelYTDSalesCycleBatch myBatchObject = new FunnelYTDSalesCycleBatch(triggerDate,chainBatch,histVal); 
                        Id batchId = Database.executeBatch(myBatchObject);
                    }
               }
            
           }
       } 
       catch(Exception ex){
           System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
           FunnelTriggerBatchHelper.sendErrorMail(' FunnelSalesCycleBatch '+ex.getMessage()+' '+ex.getStackTraceString()+' line number: '+ex.getLineNumber()); 
       }           
   } 
}