global with sharing class FunnelCreateCertAnswersBatch implements Database.Batchable<sobject>, Database.Stateful{
    
        
    public FunnelCreateCertAnswersBatch(){
    }
       
    public Database.QueryLocator start(Database.BatchableContext con){
         String query = 'SELECT id,Sales_Rep_Profile__c,Sales_Rep_Profile__r.Role__c,Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Rep_Staus__c from Certification__c';
         return Database.getQueryLocator(query);
    }        
    
    //List<Certification_Rating__c> certiRating = [SELECT Id,Deactivated__c,Roles_enabled__c,name,User_Type__c,Timing__c FROM Certification_Rating__c where Assessment_type__c='Qualitative' AND Deactivated__c = false];
    
    //List<Certification_Answer__c> createAnsRecords = new List<Certification_Answer__c>();            
    
    //Notification_Setting__c ns = [SELECT Id, Enable_Notifications__c, Advance_Reminders__c, Notification_Frequency__c, Escalation__c FROM Notification_Setting__c LIMIT 1];
    
    public void execute(Database.BatchableContext con, List<Certification__c> c){                
        /*
        if(certiRating != null && certiRating.size() > 0){
            
            for(Certification__c s: c){
                  
                for(Certification_Rating__c cr : certiRating){
                    
                    Set<String> rolesSet = new Set<String>();
                    
                    if(cr.Roles_enabled__c != null){
                        List<String> rolesList = cr.Roles_enabled__c.split(';');
                        for(String r:rolesList){
                            rolesSet.add(r);
                        }
                    }
                    
                    system.debug(' rolesSet '+rolesSet);
                    system.debug(' s.Sales_Rep_Profile__r.Role__c '+s.Sales_Rep_Profile__r.Role__c);
                    system.debug(' s.Sales_Rep_Profile__r.Rep_Staus__c '+s.Sales_Rep_Profile__r.Rep_Staus__c);
                    system.debug(' cr.User_Type__c '+cr.User_Type__c);
                      
                    if(cr.Roles_enabled__c != null  && s.Sales_Rep_Profile__r.Role__c != null && rolesSet.contains(s.Sales_Rep_Profile__r.Role__c) && (s.Sales_Rep_Profile__r.Rep_Staus__c == cr.User_Type__c  || cr.User_Type__c =='Both') ){
                    
                        system.debug(' cert answer created ');                                                
                    
                        Certification_Answer__c insertAns = new Certification_Answer__c();
                        insertAns.Name = cr.name;
                        insertAns.Certifcation__c = s.id;
                        insertAns.Certifcation_Rating__c = cr.id;
                        insertAns.Rating_name_picklist__c = cr.name;                                                                                                
                        insertAns.Sales_Rep_Profile__c = s.Sales_Rep_Profile__c;
                        
                        Date dueDate;
                        
                        Integer noOfDays;
                        
                        DateTime Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');                                                
                        
                        if(cr.Timing__c == 'End of month'){
                            noOfDays = Date.daysInMonth(Date.today().year(),Date.today().month());                
                            dueDate = Date.newInstance(Date.today().year(),Date.today().month(),noOfDays);     
                        }
                        else if(cr.Timing__c == 'End of quarter'){
                            DateTime quarStartDateTime = FunnelCalculationHelper.getQuarterStartDate();
                            quarStartDateTime = quarStartDateTime.addMonths(2);                                
                            noOfDays = Date.daysInMonth(quarStartDateTime.year(),quarStartDateTime.month());                                           
                            dueDate = Date.newInstance(quarStartDateTime.year(),quarStartDateTime.month(),noOfDays);    
                        }
                        else if(cr.Timing__c == 'Bi-annual'){
                            DateTime month6Start = Fyear.addMonths(5);                            
                            noOfDays = Date.daysInMonth(month6Start.year(),month6Start.month());                            
                            dueDate = Date.newInstance(month6Start.year(),month6Start.month(),noOfDays);
                            
                            if(Date.today() > dueDate){
                                dueDate = dueDate.addMonths(6);
                                noOfDays = Date.daysInMonth(dueDate.year(),dueDate.month());
                                dueDate = Date.newInstance(dueDate.year(),dueDate.month(),noOfDays);
                            }
                        }
                        else if(cr.Timing__c == 'Annual'){
                            DateTime month12Start = Fyear.addMonths(11);                            
                            noOfDays = Date.daysInMonth(month12Start.year(),month12Start.month());                            
                            dueDate = Date.newInstance(month12Start.year(),month12Start.month(),noOfDays);                                                        
                        }
                        
                        insertAns.Due_Date__c = dueDate;
                        
                        if(ns.Enable_Notifications__c ){
                            if(ns.Advance_Reminders__c == '1 day prior'){
                                insertAns.Manager_Email_Date__c = insertAns.Due_Date__c.addDays(-1);
                                insertAns.Rating_Start_Date__c = insertAns.Due_Date__c.addDays(-1);
                            }
                            else if(ns.Advance_Reminders__c == '3 days prior'){
                                insertAns.Manager_Email_Date__c = insertAns.Due_Date__c.addDays(-3);
                                insertAns.Rating_Start_Date__c = insertAns.Due_Date__c.addDays(-3);
                            }
                            else if(ns.Advance_Reminders__c == '7 days prior'){
                                insertAns.Manager_Email_Date__c = insertAns.Due_Date__c.addDays(-7);
                                insertAns.Rating_Start_Date__c = insertAns.Due_Date__c.addDays(-7);
                            }
                            
                            if(ns.Escalation__c == '2 days overdue'){
                                insertAns.Escalation_Email_Date__c = insertAns.Due_Date__c + 2;
                            }
                            else if(ns.Escalation__c == '7 days overdue'){
                                insertAns.Escalation_Email_Date__c = insertAns.Due_Date__c + 7;
                            }
                            else if(ns.Escalation__c == '10 days overdue'){
                                insertAns.Escalation_Email_Date__c = insertAns.Due_Date__c + 10;
                            }
                        }
                    
                        createAnsRecords.add(insertAns);
                                                
                    }
                                                    
                }
                 
            }
              
        }
        
        system.debug(' createAnsRecords '+createAnsRecords);
        insert createAnsRecords;
        */                   
    }        
    
    public void finish(Database.BatchableContext con){                                      
        
    }         
    
}