public with sharing class FunnelMonthlyCertiAnswerSnapshotBatch implements Database.Batchable<sobject>, Database.Stateful{
    
    Date triggerDate;
    
    public Boolean createAccess = true;
    
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    
    public FunnelMonthlyCertiAnswerSnapshotBatch (Date scheduleDate){
        triggerDate = scheduleDate;
     }   
        
      public Database.QueryLocator start(Database.BatchableContext con){
        
        /*List<String> fldList1 = new List<String>{prefix+'weighted_score__c',prefix+'tenatative_rating_score__c',prefix+'snapshot_scheduled_date__c',prefix+'rating_start_date__c',prefix+'rating_score__c',prefix+'manager_email_date__c',prefix+'escalation_email_date__c',prefix+'due_date__c',prefix+'certification__c',prefix+'certification_rating__c',prefix+'certification_answer__c'};

        Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Certification_Answer_Snapshot__c').getDescribe().fields.getMap();
        
        for(String fldName: fldList1){
            if(!fieldMap1.get(fldName).getDescribe().isCreateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              createAccess = false;
              break;
            }                
        }*/ 
         
         return Database.getQueryLocator('SELECT Id, Certifcation__c, Certifcation_Rating__c, Due_Date__c, Escalation_Email_Date__c, Manager_Email_Date__c, Rating_Score__c, Rating_Start_Date__c, Tenatative_rating_score__c, Weighted_Score__c FROM Certification_Answer__c');
    }
    
    public void execute(Database.BatchableContext con, List<Certification_Answer__c> answers){
        
        List<Certification_Answer_Snapshot__c> snapshotRecsToBeInserted = new List<Certification_Answer_Snapshot__c>();   
        
        if(createAccess){
                             
            for(Certification_Answer__c ca : answers){
            
                Certification_Answer_Snapshot__c cs = new Certification_Answer_Snapshot__c();
                cs.Certification__c = ca.Certifcation__c;
                cs.Certification_Rating__c = ca.Certifcation_Rating__c;
                cs.Due_Date__c = ca.Due_Date__c;
                cs.Escalation_Email_Date__c = ca.Escalation_Email_Date__c;
                cs.Manager_Email_Date__c = ca.Manager_Email_Date__c;
                cs.Rating_Score__c = ca.Rating_Score__c;
                cs.Rating_Start_Date__c = ca.Rating_Start_Date__c;
                cs.Tenatative_rating_score__c = ca.Tenatative_rating_score__c;
                cs.Weighted_Score__c = ca.Weighted_Score__c;
                cs.Certification_Answer__c = ca.id;
                
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
        
        //if(Schema.sObjectType.Certification_Answer_Snapshot__c.isCreateable())
            insert snapshotRecsToBeInserted;
            
        system.debug(' certification answer snapshot inserted successfully '+snapshotRecsToBeInserted);        
        
    }
    
    public void finish(Database.BatchableContext con){
        DateTime Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        DateTime eleventhMonth = Fyear.addMonths(11);
        Date eleventhMonthDate = Date.newInstance(eleventhMonth.yearGmt(),eleventhMonth.monthGmt(),eleventhMonth.dayGmt());
        
        DateTime yearEndDateTime = FunnelCalculationHelper.getQuarterEndDate(eleventhMonthDate);
        
        Date yearEndDate = Date.newInstance(yearEndDateTime.yearGmt(),yearEndDateTime.monthGmt(),yearEndDateTime.dayGmt());
        
        /*
        if(yearEndDate == triggerDate){
           FunnelYearlyBatch fm = new FunnelYearlyBatch(triggerDate);
           Database.executeBatch(fm);
        }*/                                            
    }
}