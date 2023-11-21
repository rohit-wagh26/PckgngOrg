/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelUpdateAnswersOnImplementation implements Database.Batchable<sobject>, Database.Stateful{
    
    Date triggerDate;
    Boolean chainBatch;
    Boolean histVal;
    Boolean errorVal = false;
    
    Map<id,Sales_Rep_Profile__c> ownerProfMap = new Map<id,Sales_Rep_Profile__c>();
        
    Map<Id,Integer> mapCal = new Map<Id,Integer>();
    
    public FunnelUpdateAnswersOnImplementation (){
        
    }
            
    public Database.QueryLocator start(Database.BatchableContext con){
        
        String query = 'SELECT id FROM Sales_rep_profile__c';
        return Database.getQueryLocator(query);
    }                
    
    public void execute(Database.BatchableContext con, List<Sales_rep_profile__c> profs){     
        
        List<id> profIds = new List<id>();
        
        for(Sales_rep_profile__c s: profs){
            profIds.add(s.id);   
        }                            
        
        try{
            List<Application_Setting__c> appSet = [SELECT Implementation_Date__c FROM Application_Setting__c LIMIT 1];
                        
            Date impDt = appSet[0].Implementation_Date__c;
            system.debug(' impDt '+impDt);
            
            Integer noOfDays = Date.daysInMonth(impDt.year(),impDt.month());                
            Date endDate = Date.newInstance(impDt.year(),impDt.month(),noOfDays);
                   
            List<Certification_Answer__c> answerRecs = [SELECT Id, Due_Date__c, Rating_Start_Date__c FROM Certification_Answer__c WHERE Sales_rep_profile__c IN :profIds AND Certifcation_Rating__r.Assessment_type__c = 'Qualitative']; 

            Notification_Setting__c ns = [SELECT Id, Enable_Notifications__c, Advance_Reminders__c, Notification_Frequency__c, Escalation__c FROM Notification_Setting__c LIMIT 1];
        
            for(Certification_Answer__c ca: answerRecs){
                
                ca.Rating_Start_Date__c = impDt;
                ca.Due_Date__c =  endDate;                                   
            
                if(ns.Enable_Notifications__c ){
                    if(ns.Advance_Reminders__c == '1 day prior'){
                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-1);
                        //ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-1);
                    }
                    else if(ns.Advance_Reminders__c == '3 days prior'){
                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-3);
                        //ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-3);
                    }
                    else if(ns.Advance_Reminders__c == '7 days prior'){
                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-7);
                        //ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                    }
                    
                    if(ns.Escalation__c == '2 days overdue'){
                        ca.Escalation_Email_Date__c = ca.Due_Date__c + 2;
                    }
                    else if(ns.Escalation__c == '7 days overdue'){
                        ca.Escalation_Email_Date__c = ca.Due_Date__c + 7;
                    }
                    else if(ns.Escalation__c == '10 days overdue'){
                        ca.Escalation_Email_Date__c = ca.Due_Date__c + 10;
                    }
                }
            }
            
            update answerRecs;
        }
        catch(Exception ex){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelUpdateAnswersOnImplementation '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());  
        }                                            
    }        
    
    public void finish(Database.BatchableContext con){                
        
    }            
    
}