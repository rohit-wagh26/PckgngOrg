global with sharing class FunnelYTDSalesCycleBatch implements Database.Batchable<sobject>, Database.Stateful{
    
    Date triggerDate;
    Boolean chainBatch;
    Boolean histVal;

    Boolean errorVal = false;
    
    Map<id,Sales_Rep_Profile__c> ownerProfMap = new Map<id,Sales_Rep_Profile__c>();
        
    Map<Id,avgWrapper> mapCal = new Map<Id,avgWrapper>();
    
    public FunnelYTDSalesCycleBatch(Date scheduleDate,Boolean chain,Boolean historical){
        triggerDate = scheduleDate;
        chainBatch = chain;
        histVal = historical;
    }
            
    public Database.QueryLocator start(Database.BatchableContext con){
        
        List<Sales_Rep_Profile__c> sp = [SELECT id, User_Record_Name__c,YTD_Average_Sales_Cycle__c  FROM Sales_Rep_Profile__c WHERE (Active__c = TRUE OR Annual_Quota_Amount__c > 0) LIMIT 5000];
                
        for(Sales_Rep_Profile__c s: sp){
            if(s.User_Record_Name__c != null)
                ownerProfMap.put(s.User_Record_Name__c,s);
        }                
                
        Date startDate = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        String startDt = String.valueOf(startDate);
        String endDt = String.valueOf(triggerDate);
        String dateStartDate = startDt.substring(0,10);
        String dateEndDate = endDt.substring(0,10);
		String omit = 'Omitted';        
        system.debug('dateStartDate '+dateStartDate );       
        system.debug('dateEndDate '+dateEndDate );          
        
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
        catch(Exception ex){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelYTDSalesCycleBatch '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()); 
        }                                    
    }        
    
    public void finish(Database.BatchableContext con){
        //FunnelTriggerBatchHelper.sendErrorMail(' FunnelYTDSalesCycleBatch finish method');
        if(!errorVal){   
            //FunnelTriggerBatchHelper.sendErrorMail(' FunnelYTDSalesCycleBatch finish method no error ');  
            system.debug(' ownerProfMap '+ownerProfMap);
            system.debug(' mapCal '+mapCal);
            
            for(Id i: ownerProfMap.keySet()){
                if(mapCal.get(i) != null){
                    ownerProfMap.get(i).YTD_Average_Sales_Cycle__c = mapCal.get(i).daysToClose/mapCal.get(i).count;
                }
                else{
                    ownerProfMap.get(i).YTD_Average_Sales_Cycle__c = 0;
                }
            }        
            
            update ownerProfMap.values();                
            system.debug(ownerProfMap.values());
            
            if(chainBatch){
                system.debug(' histDateVal '+triggerDate);
                //Funnel12MonthBatch m = new Funnel12MonthBatch(triggerDate,chainBatch,histVal);
                FunnelRevenueBatch m = new FunnelRevenueBatch(triggerDate,chainBatch,histVal);
                database.executebatch(m);
            }
        }
    }            
    
}