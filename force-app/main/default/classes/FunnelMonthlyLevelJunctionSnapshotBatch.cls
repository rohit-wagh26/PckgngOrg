/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelMonthlyLevelJunctionSnapshotBatch implements Database.Batchable<sobject>, Database.Stateful{
    
    Date triggerDate;
    
    public Boolean createAccess = true;
    
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    Boolean chainBatch;
    Boolean histVal;

    Boolean errorVal = false;
        
    Map<id,id> salesProfSnapshotMap = new Map<id,id>();
    
    Map<id,id> certSnapshotMap = new Map<id,id>();
    
    Map<id,id> compLevelSnapshotMap = new Map<id,id>();

    public FunnelMonthlyLevelJunctionSnapshotBatch(Date scheduleDate,Boolean chain,Boolean historical){
        triggerDate = scheduleDate;
        chainBatch = chain;
        histVal = historical;
    }
        
    public Database.QueryLocator start(Database.BatchableContext con){
        
        /*
        List<String> fldList1 = new List<String>{prefix+'snapshot_scheduled_date__c',prefix+'sales_rep_profile__c',prefix+'sales_profile_company_level_junction__c',prefix+'company_level__c'};

        Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Company_Level_Junction_snapshot__c').getDescribe().fields.getMap();
        
        for(String fldName: fldList1){
            if(!fieldMap1.get(fldName).getDescribe().isCreateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              createAccess = false;
              break;
            }                
        }*/
        
        List<Sales_Rep_Profile_Snapshot__c> spSnapShots = [SELECT id, name, Sales_Rep_Profile__c FROM Sales_Rep_Profile_Snapshot__c WHERE Snapshot_Scheduled_Date__c = :triggerDate];
        
        for(Sales_Rep_Profile_Snapshot__c ss: spSnapShots){
            salesProfSnapshotMap.put(ss.Sales_Rep_Profile__c,ss.id);
        }
        
        List<Certification_Snapshot__c> certSnapShots = [SELECT id, Sales_Rep_Profile__c FROM Certification_Snapshot__c WHERE Snapshot_Scheduled_Date__c = :triggerDate];
        
        for(Certification_Snapshot__c s: certSnapShots){
            certSnapshotMap.put(s.Sales_Rep_Profile__c,s.id);
        }
        
        List<Company_Levels_snapshot__c> clSnapShots = [SELECT id, Company_Level__c FROM Company_Levels_snapshot__c WHERE Snapshot_Scheduled_Date__c = :triggerDate];
        
        for(Company_Levels_snapshot__c cl: clSnapShots){
            compLevelSnapshotMap.put(cl.Company_Level__c,cl.id);
        }
        
        return Database.getQueryLocator('SELECT Id, name, Company_Level__c,Sales_Rep_Profile__c FROM Sales_Profile_Company_Level_Junction__c WHERE (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_quota_amount__c > 0)');
    }
    
    public void execute(Database.BatchableContext con, List<Sales_Profile_Company_Level_Junction__c> levels){
        try{    
        List<Company_Level_Junction_snapshot__c> snapshotRecsToBeInserted = new List<Company_Level_Junction_snapshot__c>();   
        
        if(createAccess){
                             
            for(Sales_Profile_Company_Level_Junction__c cl : levels){
            
                Company_Level_Junction_snapshot__c cs = new Company_Level_Junction_snapshot__c();
                    cs.name = cl.name;
                cs.Company_Level__c = cl.Company_Level__c;
                    
                    if(compLevelSnapshotMap != null && compLevelSnapshotMap.containsKey(cl.Company_Level__c)){
                        cs.Company_Levels_snapshot__c = compLevelSnapshotMap.get(cl.Company_Level__c);
                    }
                                    
                cs.Sales_Rep_Profile__c = cl.Sales_Rep_Profile__c;
                    
                    if(salesProfSnapshotMap != null && salesProfSnapshotMap.containsKey(cl.Sales_Rep_Profile__c)){
                        cs.Sales_Rep_Profile_Snapshot__c = salesProfSnapshotMap.get(cl.Sales_Rep_Profile__c);
                    }
                    
                    if(certSnapshotMap != null && certSnapshotMap.containsKey(cl.Sales_Rep_Profile__c)){
                        cs.Certification_Snapshot__c = certSnapshotMap.get(cl.Sales_Rep_Profile__c);
                    }
                    
                cs.Sales_Profile_Company_Level_Junction__c = cl.id;
                 //   cs.Company_Level_Picklist__c = cl.Company_Level_Picklist__c;
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
        
            //if(Schema.sObjectType.Company_Level_Junction_snapshot__c.isCreateable())
            //if(Schema.getGlobalDescribe().get(prefix+'Company_Level_Junction_snapshot__c').getDescribe().isCreateable()){   
            insert snapshotRecsToBeInserted;
            //}
        
            system.debug(' junction snapshot inserted successfully '+snapshotRecsToBeInserted);        
        }
        catch(Exception e){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelMonthlyLevelJunctionSnapshotBatch '+e.getMessage()+' '+e.getStackTraceString()+' '+e.getLineNumber());
        }    
    }
    
    public void finish(Database.BatchableContext con){
        if(!errorVal){ 
            if(chainBatch){    
                
                
               DateTime Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
               DateTime eleventhMonth = Fyear.addMonths(11);
               Date eleventhMonthDate = Date.newInstance(eleventhMonth.yearGmt(),eleventhMonth.monthGmt(),eleventhMonth.dayGmt());
               
               Integer noOfDays = Date.daysInMonth(eleventhMonth.yearGmt(),eleventhMonth.monthGmt());
               
               Date yearEndDate = Date.newInstance(eleventhMonth.yearGmt(),eleventhMonth.monthGmt(),noOfDays);
               
               /*DateTime yearEndDateTime = FunnelCalculationHelper.getQuarterEndDate(eleventhMonthDate);
           
               Date yearEndDate = Date.newInstance(yearEndDateTime.yearGmt(),yearEndDateTime.monthGmt(),yearEndDateTime.dayGmt());
               yearEndDate = yearEndDate.addDays(-1);*/
               system.debug(' yearEndDate  '+yearEndDate);
               system.debug(' triggerDate '+triggerDate);
               
               if(yearEndDate == triggerDate){
                   FunnelGoalBatch fm = new FunnelGoalBatch(triggerDate,chainBatch,histVal);
                   Database.executeBatch(fm);
               }else{
                   if(!histVal){ 
                      // FunnelTriggerBatchHelper.sendErrorMail(' All batches completed '+triggerDate);
                   }
                    /*Automation*/
           
                   Date tDNM = triggerDate.addMonths(1);
                   Date triggerDateNextmonth =  Date.newinstance(tDNM.year(),tDNM.month(),date.daysInMonth(tDNM.year(),tDNM.month()));
                   
                  // Date imptestDate =  Date.newinstance(2018,12,6);
                   if((triggerDateNextmonth  < Date.today() )&& histVal ){
                   
                 //  if((triggerDateNextmonth  < imptestDate )&& histVal ){
                       FunnelCalculateYTDFieldsBatch fq = new FunnelCalculateYTDFieldsBatch(triggerDateNextmonth,true,true);
                       Database.executeBatch(fq);   
                   }else if(histVal){
                       FunnelTriggerBatchHelper.schActivateTrigger();
                       
                        Date d = Date.newInstance(Date.today().year(),Date.today().month(), date.daysInMonth(Date.today().year(), Date.today().month()));  
            
                        Funnel12MonthBatch fbc = new Funnel12MonthBatch(d,false,true);
                        Database.executebatch(fbc); 
                        
                        Funnel12MonthBatchPart2 fbc2 = new Funnel12MonthBatchPart2 (d,false,true);
                        Database.executebatch(fbc2); 
                        
                        Batch_CreateOpprtunityTracking otb = new Batch_CreateOpprtunityTracking();       
                        Database.executeBatch(otb);
                        
                        FunnelTriggerBatchHelper.installationMail('Funnelocity installation completed','Funnelocity installation has been completed. '); 
                       
                        
                   } 
                   
               }
        
            }
        }                       
    }
}