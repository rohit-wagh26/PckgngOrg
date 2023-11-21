/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelMonthlyCompanyLevelSnapshotBatch implements Database.Batchable<sobject>, Database.Stateful{
    
    Date triggerDate;
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    public Boolean createAccess = true;
    
    Boolean chainBatch;
    Boolean histVal;

    Boolean errorVal = false;
    
    Map<id,id> salesProfSnapshotMap = new Map<id,id>();        

    Map<id,id> certSnapshotMap = new Map<id,id>();
    
    public FunnelMonthlyCompanyLevelSnapshotBatch(Date scheduleDate,Boolean chain,Boolean historical){
        triggerDate = scheduleDate;
        chainBatch = chain;
        histVal = historical;
    }
        
    
    public Database.QueryLocator start(Database.BatchableContext con){
        
        /*
        List<String> fldList1 = new List<String>{prefix+'snapshot_scheduled_date__c',prefix+'sales_rep_profile__c',prefix+'level_value__c',prefix+'level_name__c',prefix+'company_level__c'};

        Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Company_Levels_snapshot__c').getDescribe().fields.getMap();
        
        for(String fldName: fldList1){
            if(!fieldMap1.get(fldName).getDescribe().isCreateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              createAccess = false;
              break;
            }                
        }*/
        
        List<Sales_Rep_Profile_Snapshot__c> spSnapShots = [SELECT id, Sales_Rep_Profile__c FROM Sales_Rep_Profile_Snapshot__c WHERE Snapshot_Scheduled_Date__c = :triggerDate];
        
        for(Sales_Rep_Profile_Snapshot__c ss: spSnapShots){
            salesProfSnapshotMap.put(ss.Sales_Rep_Profile__c,ss.id);
        }                
        
        List<Certification_Snapshot__c> certSnapShots = [SELECT id, Sales_Rep_Profile__c FROM Certification_Snapshot__c WHERE Snapshot_Scheduled_Date__c = :triggerDate];
        
        for(Certification_Snapshot__c s: certSnapShots){
            certSnapshotMap.put(s.Sales_Rep_Profile__c,s.id);
        }
       
        return Database.getQueryLocator('SELECT Id, Level_Name__c, Level_Value__c, Sales_Rep_Profile__c FROM Company_Level__c WHERE (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_quota_amount__c > 0)');
    }
    
    public void execute(Database.BatchableContext con, List<Company_Level__c> levels){
        try{    
        List<Company_Levels_snapshot__c> snapshotRecsToBeInserted = new List<Company_Levels_snapshot__c>();   
        
        if(createAccess){
                             
            for(Company_Level__c cl : levels){
            
                Company_Levels_snapshot__c cs = new Company_Levels_snapshot__c();
                cs.Level_Name__c = cl.Level_Name__c;
                cs.Level_Value__c = cl.Level_Value__c;
                cs.Sales_Rep_Profile__c = cl.Sales_Rep_Profile__c;
                    
                    if(salesProfSnapshotMap != null && salesProfSnapshotMap.containsKey(cl.Sales_Rep_Profile__c)){
                        cs.Sales_Rep_Profile_Snapshot__c = salesProfSnapshotMap.get(cl.Sales_Rep_Profile__c);
                    }
                    
                    if(certSnapshotMap != null && certSnapshotMap.containsKey(cl.Sales_Rep_Profile__c)){
                        cs.Certification_Snapshot__c = certSnapshotMap.get(cl.Sales_Rep_Profile__c);
                    }
                    
                cs.Company_Level__c = cl.id;
                
                /*
                if(date.today().day() >= 1 && date.today().day() <= 27){
                    Date newDate = date.today() - 27;   
                    Integer dayVal = Date.daysInMonth(newDate.year(), newDate.month());
                    Date snapDate = Date.newInstance(newDate.year(), newDate.month(), dayVal);
                    cs.Snapshot_Scheduled_Date__c = snapDate;
                    
                    DateTime actualDateTime = snapDate;
             
                    actualDateTime = actualDateTime.addHours(actualDateTime.hour());
                    actualDateTime = actualDateTime.addMinutes(actualDateTime.minute());
                    actualDateTime = actualDateTime.addSeconds(actualDateTime.second());
                    cs.CreatedDate = actualDateTime;
                }*/
                
                //DateTime todaysDateTime = Date.today();
                /*DateTime todaysDateTime = Date.newInstance(2017,12,31);
                
                todaysDateTime = todaysDateTime.addHours(todaysDateTime.hour());
                todaysDateTime = todaysDateTime.addMinutes(todaysDateTime.minute());
                todaysDateTime = todaysDateTime.addSeconds(todaysDateTime.second());
                cs.CreatedDate = todaysDateTime;
                    
                cs.Snapshot_Scheduled_Date__c = Date.newInstance(2017,12,31);*/
                
                cs.Snapshot_Scheduled_Date__c = triggerDate; 
                
                snapshotRecsToBeInserted.add(cs);  
                                          
            }
        }
        
        //if(Schema.sObjectType.Company_Levels_snapshot__c.isCreateable())
         //if(Schema.getGlobalDescribe().get(prefix+'Company_Levels_snapshot__c').getDescribe().isCreateable()){   
                insert snapshotRecsToBeInserted;
            //}
            
        system.debug(' company level snaphsot inserted successfully '+snapshotRecsToBeInserted);        
        }
        catch(Exception e){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelMonthlyCompanyLevelSnapshotBatch '+e.getMessage()+' '+e.getStackTraceString()+' '+e.getLineNumber());
        }
        
    }
    
    public void finish(Database.BatchableContext con){
        if(!errorVal){      
            if(chainBatch){        
                FunnelMonthlyLevelJunctionSnapshotBatch juncBatch = new FunnelMonthlyLevelJunctionSnapshotBatch(triggerDate,chainBatch,histVal);
                Database.executeBatch(juncBatch);   
            }
        }
    }
}