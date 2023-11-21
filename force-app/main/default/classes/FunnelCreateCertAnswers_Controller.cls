/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelCreateCertAnswers_Controller{
    
    public static void deleteAndCreateCertAnswers(Set<Id> deleteList, Set<Id> createList, String scenario){        
        
        if(deleteList != null && deleteList.size() > 0){
        
            List<Certification__c> deleteCerts = [SELECT id FROM Certification__c WHERE Sales_Rep_Profile__c IN : deleteList];
            
            //List<Certification_Answer__c> ansList = [SELECT Id, Certifcation__c, Rating_Score__c FROM Certification_Answer__c WHERE Rating_Score__c = null AND Certifcation_Rating__r.Assessment_type__c='Qualitative' AND Certifcation__c IN :deleteCerts];        
            //List<Certification_Answer__c> ansList = [SELECT Id, Certifcation__c, Rating_Score__c FROM Certification_Answer__c WHERE Due_Date__c >= Today AND Certifcation_Rating__r.Assessment_type__c='Qualitative' AND Certifcation__c IN :deleteCerts];
              List<Certification_Answer__c> ansList = [SELECT Id,Name,Due_Date__c, Certifcation__c, Rating_Score__c FROM Certification_Answer__c WHERE Rating_Score__c = null AND Certifcation_Rating__r.Assessment_type__c='Qualitative' AND Certifcation__c IN :deleteCerts];
            system.debug(' deleted ans '+ansList);
            
            //if(Schema.sObjectType.Certification_Answer__c.isDeletable()){ 
                DELETE ansList;
            //}
        }
        
        List<Certification__c> certs = [SELECT id, Sales_Rep_Profile__r.Rep_Staus__c, Sales_Rep_Profile__r.Role__c FROM Certification__c WHERE Sales_Rep_Profile__c IN : createList AND Sales_Rep_Profile__r.Placeholder__c=false];
        
        Integer noOfDays = Date.daysInMonth(Date.today().year(),Date.today().month());
        
        Notification_Setting__c ns = [SELECT Id, Enable_Notifications__c, Advance_Reminders__c, Notification_Frequency__c, Escalation__c,Last_Date_for_submit__c FROM Notification_Setting__c LIMIT 1];
        
        List<Certification_Answer__c> createAnsRecords = new List<Certification_Answer__c>();

        //Creating certification answers for monthly ratings
        List<Certification_Rating__c> certiRating = [SELECT Id, X0LevelHigh__c, X0LevelLow__c,X1LevelHigh__c,X1LevelLow__c,X2LevelHigh__c,X2LevelLow__c,
                                                 X3LevelHigh__c,X3LevelLow__c,X4LevelHigh__c,X4LevelLow__c,Deactivated__c,Roles_enabled__c,Numeric_Weight__c,
                                                 Field_Name__c,name,User_Type__c  FROM Certification_Rating__c where Assessment_type__c='Qualitative' 
                                                 AND Deactivated__c = false And Timing__c='End of month' ];        
            
        if(certiRating != null && certiRating.size() > 0 ){                            
              
              for(Certification__c s: certs){
                  system.debug(' s '+s);                  
                  for(Certification_Rating__c cr : certiRating){
                      
                      system.debug(' cr '+cr); 
                      
                      Set<String> rolesSet = new Set<String>();
                    
                      if(cr.Roles_enabled__c != null){
                            List<String> rolesList = cr.Roles_enabled__c.split(';');
                            for(String r:rolesList){
                                rolesSet.add(r);
                            }
                      }
                                            
                      if(cr.Roles_enabled__c != null  && (s.Sales_Rep_Profile__r.Rep_Staus__c == cr.User_Type__c  || cr.User_Type__c =='Both') && s.Sales_Rep_Profile__r.Role__c != null && rolesSet.contains(s.Sales_Rep_Profile__r.Role__c)){
                          
                          system.debug(' condition matched ');
                          
                          Certification_Answer__c ca= new Certification_Answer__c();
                          ca.Name = cr.name;
                          if(!Test.isRunningTest()){
                             ca.Rating_name_picklist__c = cr.name;
                            }
                          ca.Certifcation__c = s.id;
                          ca.Certifcation_Rating__c = cr.id;
                          ca.Sales_Rep_Profile__c=s.Sales_Rep_Profile__c;                                                    

                          ca.Due_Date__c = Date.newInstance(Date.today().year(),Date.today().month(),noOfDays);
                          ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                          
                          if(ns.Enable_Notifications__c ){
                          
                                if(ns.Advance_Reminders__c == '1 day prior'){
                                    ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-1);
                                //    ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-1);
                                }
                                else if(ns.Advance_Reminders__c == '3 days prior'){
                                    ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-3);
                                //    ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-3);
                                }
                                else if(ns.Advance_Reminders__c == '7 days prior'){
                                    ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-7);
                                //    ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                                }
                                
                                if(ns.Escalation__c == '1 day prior'){
                                    ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 1);
                                }
                                else if(ns.Escalation__c == '2 days prior'){
                                    ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 2);
                                }
                                else if(ns.Escalation__c == '3 days prior'){
                                    ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 3);
                                }
                                else if(ns.Escalation__c == '4 days prior'){
                                    ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 4);
                                }
                                else if(ns.Escalation__c == '5 days prior'){
                                    ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 5);
                                }
                          }
                    
                          createAnsRecords.add(ca);                                          
                          
                      }
                                                                
                  }
                                    
              }
              
        } 
        
        //Creating certification answers for quarterly ratings
        
        Date dueDate = FunnelCalculationHelper.getQuarterEndInDateFormat(Date.today());
        
        //Find the months for which quarterly, bi-annual and annual ratings should be created
        DateTime Fyear1 = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        Integer mon1 = Fyear1.monthGMT();
        system.debug(mon1);
        Set<Integer> quarterlyMon = new Set<Integer>();
        Set<Integer> biAnnMon = new Set<Integer>();
        Set<Integer> annMon = new Set<Integer>();
        
        for(Integer i =1; i<5; i++){
            if(mon1 > 12){
                mon1 =  mon1 - 12;                    
            }
            
            quarterlyMon.add(mon1);
            
            if(i == 1 || i == 3){
                biAnnMon.add(mon1);
            }
            
            if(i == 1){
                annMon.add(mon1);
            }
            
            mon1 = mon1 + 3;
        }
        
        if(quarterlyMon.contains(System.today().month()) || scenario == 'trigger'){                   

              
            certiRating = [SELECT Id, X0LevelHigh__c, X0LevelLow__c,X1LevelHigh__c,X1LevelLow__c,X2LevelHigh__c,X2LevelLow__c,
                             X3LevelHigh__c,X3LevelLow__c,X4LevelHigh__c,X4LevelLow__c,Deactivated__c,Roles_enabled__c,Numeric_Weight__c,
                             Field_Name__c,name,User_Type__c  FROM Certification_Rating__c where Assessment_type__c='Qualitative' 
                             AND Deactivated__c = false And Timing__c='End of quarter' ];        
                
            if(certiRating != null && certiRating.size() > 0 ){
                
                  for(Certification__c s: certs){
                                        
                      for(Certification_Rating__c cr : certiRating){                  
                          
                          Set<String> rolesSet = new Set<String>();
                        
                          if(cr.Roles_enabled__c != null){
                                List<String> rolesList = cr.Roles_enabled__c.split(';');
                                for(String r:rolesList){
                                    rolesSet.add(r);
                                }
                          }
                                                
                          if(cr.Roles_enabled__c != null  && (s.Sales_Rep_Profile__r.Rep_Staus__c == cr.User_Type__c  || cr.User_Type__c =='Both') && s.Sales_Rep_Profile__r.Role__c != null && rolesSet.contains(s.Sales_Rep_Profile__r.Role__c)){                      
                              
                              system.debug(' condition matched ');
                              
                              Certification_Answer__c ca= new Certification_Answer__c();
                              ca.Name = cr.name;
                              if(!Test.isRunningTest()){
                                 ca.Rating_name_picklist__c = cr.name;
                                }
                              ca.Certifcation__c = s.id;
                              ca.Certifcation_Rating__c = cr.id;
                              ca.Sales_Rep_Profile__c=s.Sales_Rep_Profile__c;                                                    
    
                              ca.Due_Date__c = dueDate;
                              ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                              
                              if(ns.Enable_Notifications__c ){
                              
                                    if(ns.Advance_Reminders__c == '1 day prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-1);
                                      //  ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-1);
                                    }
                                    else if(ns.Advance_Reminders__c == '3 days prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-3);
                                      //  ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-3);
                                    }
                                    else if(ns.Advance_Reminders__c == '7 days prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-7);
                                      //  ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                                    }
                                    
                                     if(ns.Escalation__c == '1 day prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 1);
                                    }
                                    else if(ns.Escalation__c == '2 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 2);
                                    }
                                    else if(ns.Escalation__c == '3 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 3);
                                    }
                                    else if(ns.Escalation__c == '4 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 4);
                                    }
                                    else if(ns.Escalation__c == '5 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 5);
                                    }
                              }
                        
                              createAnsRecords.add(ca);                                          
                              
                          }
                                                                    
                      }
                                        
                  }
                                
            } 
        
        }
        //Creating certification answers for bi-annual ratings
        
        DateTime Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        
        if(biAnnMon.contains(System.today().month()) || scenario == 'trigger'){                   
        
            DateTime month6Start = Fyear.addMonths(5);
            
            noOfDays = Date.daysInMonth(month6Start.yearGMT(),month6Start.monthGMT());
            
            dueDate = Date.newInstance(month6Start.yearGMT(),month6Start.monthGMT(),noOfDays);
            
            if(Date.today() > dueDate){
                dueDate = dueDate.addMonths(6);
                noOfDays = Date.daysInMonth(dueDate.year(),dueDate.month());
                dueDate = Date.newInstance(dueDate.year(),dueDate.month(),noOfDays);
            }
                    
            certiRating = [SELECT Id, X0LevelHigh__c, X0LevelLow__c,X1LevelHigh__c,X1LevelLow__c,X2LevelHigh__c,X2LevelLow__c,
                             X3LevelHigh__c,X3LevelLow__c,X4LevelHigh__c,X4LevelLow__c,Deactivated__c,Roles_enabled__c,Numeric_Weight__c,
                             Field_Name__c,name,User_Type__c  FROM Certification_Rating__c where Assessment_type__c='Qualitative' 
                             AND Deactivated__c = false And Timing__c='Bi-annual'];        
                
            if(certiRating != null && certiRating.size() > 0 ){
                
                  for(Certification__c s: certs){
                                        
                      for(Certification_Rating__c cr : certiRating){                  
                          
                          Set<String> rolesSet = new Set<String>();
                        
                          if(cr.Roles_enabled__c != null){
                                List<String> rolesList = cr.Roles_enabled__c.split(';');
                                for(String r:rolesList){
                                    rolesSet.add(r);
                                }
                          }
                                                
                          if(cr.Roles_enabled__c != null  && (s.Sales_Rep_Profile__r.Rep_Staus__c == cr.User_Type__c  || cr.User_Type__c =='Both') && s.Sales_Rep_Profile__r.Role__c != null && rolesSet.contains(s.Sales_Rep_Profile__r.Role__c)){                      
                          
                              system.debug(' condition matched ');
                              
                              Certification_Answer__c ca= new Certification_Answer__c();
                              ca.Name = cr.name;
                              if(!Test.isRunningTest()){
                                 ca.Rating_name_picklist__c = cr.name;
                                }
                              ca.Certifcation__c = s.id;
                              ca.Certifcation_Rating__c = cr.id;
                              ca.Sales_Rep_Profile__c=s.Sales_Rep_Profile__c;                                                    
    
                              ca.Due_Date__c = dueDate;
                              ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                              
                              if(ns.Enable_Notifications__c ){
                              
                                    if(ns.Advance_Reminders__c == '1 day prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-1);
                                      //  ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-1);
                                    }
                                    else if(ns.Advance_Reminders__c == '3 days prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-3);
                                      //  ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-3);
                                    }
                                    else if(ns.Advance_Reminders__c == '7 days prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-7);
                                     //   ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                                    }
                                    
                                     if(ns.Escalation__c == '1 day prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 1);
                                    }
                                    else if(ns.Escalation__c == '2 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 2);
                                    }
                                    else if(ns.Escalation__c == '3 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 3);
                                    }
                                    else if(ns.Escalation__c == '4 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 4);
                                    }
                                    else if(ns.Escalation__c == '5 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 5);
                                    }
                              }
                        
                              createAnsRecords.add(ca);                                          
                              
                          }
                                                                    
                      }
                                        
                  }
                                
            }
        }
        //Creating certification answers for annual ratings
        
        Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        DateTime month12Start = Fyear.addMonths(11);
        
        if(annMon.contains(System.today().month()) || scenario == 'trigger'){                   

            noOfDays = Date.daysInMonth(month12Start.yearGMT(),month12Start.monthGMT());
            
            dueDate = Date.newInstance(month12Start.yearGMT(),month12Start.monthGMT(),noOfDays);
                    
            certiRating = [SELECT Id, X0LevelHigh__c, X0LevelLow__c,X1LevelHigh__c,X1LevelLow__c,X2LevelHigh__c,X2LevelLow__c,
                             X3LevelHigh__c,X3LevelLow__c,X4LevelHigh__c,X4LevelLow__c,Deactivated__c,Roles_enabled__c,Numeric_Weight__c,
                             Field_Name__c,name,User_Type__c  FROM Certification_Rating__c where Assessment_type__c='Qualitative' 
                             AND Deactivated__c = false And Timing__c='Annual'];        
                
            if(certiRating != null && certiRating.size() > 0 ){
                
                  for(Certification__c s: certs){
                                        
                      for(Certification_Rating__c cr : certiRating){                  
                          
                          Set<String> rolesSet = new Set<String>();
                        
                          if(cr.Roles_enabled__c != null){
                                List<String> rolesList = cr.Roles_enabled__c.split(';');
                                for(String r:rolesList){
                                    rolesSet.add(r);
                                }
                          }
                                                
                          if(cr.Roles_enabled__c != null  && (s.Sales_Rep_Profile__r.Rep_Staus__c == cr.User_Type__c  || cr.User_Type__c =='Both') && s.Sales_Rep_Profile__r.Role__c != null && rolesSet.contains(s.Sales_Rep_Profile__r.Role__c)){                      
                              
                              system.debug(' condition matched ');
                              
                              Certification_Answer__c ca= new Certification_Answer__c();
                              ca.Name = cr.name;
                              if(!Test.isRunningTest()){
                                 ca.Rating_name_picklist__c = cr.name;
                                }
                              ca.Certifcation__c = s.id;
                              ca.Certifcation_Rating__c = cr.id;
                              ca.Sales_Rep_Profile__c=s.Sales_Rep_Profile__c;                                                    
    
                              ca.Due_Date__c = dueDate;
                              ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                              
                              if(ns.Enable_Notifications__c ){
                              
                                    if(ns.Advance_Reminders__c == '1 day prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-1);
                                 //       ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-1);
                                    }
                                    else if(ns.Advance_Reminders__c == '3 days prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-3);
                                 //       ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-3);
                                    }
                                    else if(ns.Advance_Reminders__c == '7 days prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-7);
                                  //      ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                                    }
                                    
                                     if(ns.Escalation__c == '1 day prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 1);
                                    }
                                    else if(ns.Escalation__c == '2 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 2);
                                    }
                                    else if(ns.Escalation__c == '3 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 3);
                                    }
                                    else if(ns.Escalation__c == '4 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 4);
                                    }
                                    else if(ns.Escalation__c == '5 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 5);
                                    }
                              }
                        
                              createAnsRecords.add(ca);                                          
                              
                          }
                                                                    
                      }
                                        
                  }
                                
            }
        }
        
        if(certs != null && certs.size()>0){
            certs[0].Total_Quantitative_Weight__c = createAnsRecords.size();
            update certs[0];
        }
        system.debug(' ans records created '+createAnsRecords);
        insert createAnsRecords;
    }
    
    public static void createCerts(Set<Id> createCertList){
        
        List<Certification__c> certs = [SELECT id, Sales_Rep_Profile__c FROM Certification__c WHERE Sales_Rep_Profile__c IN :createCertList AND Sales_rep_profile__r.Active__c = TRUE];
        
        List<Sales_Rep_Profile__c> sreps = [SELECT id, name FROM Sales_Rep_Profile__c WHERE id IN :createCertList AND Active__c = TRUE];
        
        Map<id,Sales_Rep_Profile__c> srMap = new Map<id,Sales_Rep_Profile__c> ();
        
        for(Sales_Rep_Profile__c s: sreps){
            srMap.put(s.id,s);    
        }
        
        for(Certification__c c: certs){
            if(createCertList != null && createCertList.contains(c.Sales_Rep_Profile__c)){
                createCertList.remove(c.Sales_Rep_Profile__c);
            }    
        } 
        
        List<Certification__c> certsLi = new List<Certification__c>();
        
        for(Id i : createCertList){
            Certification__c c = new Certification__c();
            c.name = srMap.get(i).name + ' Cert';
            c.Sales_Rep_Profile__c = i;
            certsLi.add(c);
        }
        
        insert certsLi;      
    }  

     public static void deleteAndCreateCertAnswersAppSetup(Set<Id> CertId  , Boolean createAns , Boolean deleteAns, String Role){    
     
         system.debug('CertId--'+CertId);    
         List<String> groupRoles = Role.split(';');
         system.debug('groupRoles --'+groupRoles );  
         
        if(CertId != null && CertId.size() > 0 && deleteAns){
        
            List<Certification_Answer__c> ansList = new List<Certification_Answer__c>();
            
            if(Role == 'All'){
                //ansList = [SELECT Id, Certifcation__c, Rating_Score__c FROM Certification_Answer__c WHERE Due_Date__c >= Today AND Certifcation_Rating__r.Assessment_type__c='Qualitative' AND Certifcation_Rating__c IN :CertId];
                ansList = [SELECT Id, Certifcation__c, Rating_Score__c FROM Certification_Answer__c WHERE Rating_Score__c = null AND Certifcation_Rating__r.Assessment_type__c='Qualitative' AND Certifcation_Rating__c IN :CertId];
            }else{
                //ansList = [SELECT Id, Certifcation__c, Rating_Score__c FROM Certification_Answer__c WHERE Due_Date__c >= Today AND Certifcation_Rating__r.Assessment_type__c='Qualitative' AND Certifcation_Rating__c IN :CertId AND Sales_Rep_Profile__r.Role__c = :Role];
                ansList = [SELECT Id,name,Due_Date__c, Certifcation__c, Rating_Score__c FROM Certification_Answer__c WHERE Rating_Score__c = null AND Certifcation_Rating__r.Assessment_type__c='Qualitative' AND Certifcation_Rating__c IN :CertId AND Sales_Rep_Profile__r.Role__c IN :groupRoles];
                system.debug(' deleted ans '+'SELECT Id, Certifcation__c, Rating_Score__c FROM Certification_Answer__c WHERE Rating_Score__c = null AND Certifcation_Rating__r.Assessment_type__c=Qualitative AND Certifcation_Rating__c IN '+CertId+' AND Sales_Rep_Profile__r.Role__c IN :'+groupRoles);
            }
                
            system.debug(' deleted ans '+ansList);
            
            //if(Schema.sObjectType.Certification_Answer__c.isDeletable()){ 
            if(ansList != null && ansList.size()>0){
                DELETE ansList;
                }
            //}
        }
        
         
        Set<String> roles = new Set<String>();
        for(Certification_Rating__c c : [Select id, Roles_enabled__c from Certification_Rating__c where Id IN :CertId]){
            if(c.Roles_enabled__c != null){
                    List<String> rolesList = c.Roles_enabled__c.split(';');
                    for(String r:rolesList){
                        roles.add(r);
                    }
              }
        }
        
        
        
        List<Certification__c> certs = new List<Certification__c>();
        
        if(Role == 'All'){
            certs =[SELECT id, Sales_Rep_Profile__r.Rep_Staus__c, Sales_Rep_Profile__r.Role__c FROM Certification__c WHERE Sales_Rep_Profile__r.Role__c IN : roles AND Sales_Rep_Profile__r.Placeholder__c=false];
        }else{
            certs =[SELECT id, Sales_Rep_Profile__r.Rep_Staus__c, Sales_Rep_Profile__r.Role__c FROM Certification__c WHERE Sales_Rep_Profile__r.Role__c IN :groupRoles AND Sales_Rep_Profile__r.Placeholder__c=false];
        }
        
        Set<id> cId = new Set<Id>();
        cId = new Map<Id, Certification__c>(certs).keySet(); 
         
        
        if(certs != null && certs.size() > 0 && !roles.isEmpty() && createAns){
            Integer noOfDays = Date.daysInMonth(Date.today().year(),Date.today().month());
            
            Notification_Setting__c ns = [SELECT Id, Enable_Notifications__c, Advance_Reminders__c, Notification_Frequency__c, Escalation__c,Last_Date_for_submit__c FROM Notification_Setting__c LIMIT 1];
            
            List<Certification_Answer__c> createAnsRecords = new List<Certification_Answer__c>();
    
            //Creating certification answers for monthly ratings
            List<Certification_Rating__c> certiRating = [SELECT Id, X0LevelHigh__c, X0LevelLow__c,X1LevelHigh__c,X1LevelLow__c,X2LevelHigh__c,X2LevelLow__c,
                                                     X3LevelHigh__c,X3LevelLow__c,X4LevelHigh__c,X4LevelLow__c,Deactivated__c,Roles_enabled__c,Numeric_Weight__c,
                                                     Field_Name__c,name,User_Type__c  FROM Certification_Rating__c where Assessment_type__c='Qualitative' 
                                                     AND Deactivated__c = false And Timing__c='End of month'  AND Id IN :CertId];        
            
            system.debug('certiRatingM--'+certiRating ); 
            
            List<Certification_Answer__c> certAnsMonth = new List<Certification_Answer__c>();
            certAnsMonth = [Select id ,Certifcation__c ,Due_Date__c,Rating_Start_Date__c,Manager_Email_Date__c,Escalation_Email_Date__c from Certification_Answer__c Where Certifcation__c IN :cId AND Rating_Score__c = null  AND Certifcation_Rating__r.Timing__c = 'End of month' AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative' AND Sales_rep_profile__r.Active__c = TRUE Order By Createddate Desc];
            Map<id,Certification_Answer__c> certAnsMonthMap = new Map<id,Certification_Answer__c>();
            for(Certification_Answer__c c : certAnsMonth){
                if(!certAnsMonthMap.keySet().contains(c.Certifcation__c )){
                    certAnsMonthMap.put(c.Certifcation__c ,c);
                }
                
            }
            
            if(certiRating != null && certiRating.size() > 0 ){                            
                  
                  for(Certification__c s: certs){
                      system.debug(' s '+s);                  
                      for(Certification_Rating__c cr : certiRating){
                          
                          system.debug(' cr '+cr); 
                          
                          Set<String> rolesSet = new Set<String>();
                        
                          if(cr.Roles_enabled__c != null){
                                List<String> rolesList = cr.Roles_enabled__c.split(';');
                                for(String r:rolesList){
                                    rolesSet.add(r);
                                }
                          }
                                                
                          if(cr.Roles_enabled__c != null  && (s.Sales_Rep_Profile__r.Rep_Staus__c == cr.User_Type__c  || cr.User_Type__c =='Both') && s.Sales_Rep_Profile__r.Role__c != null && rolesSet.contains(s.Sales_Rep_Profile__r.Role__c)){
                              
                              system.debug(' condition matched ');
                              
                              Certification_Answer__c ca= new Certification_Answer__c();
                              ca.Name = cr.name;
                              if(!Test.isRunningTest()){
                                 ca.Rating_name_picklist__c = cr.name;
                                }
                              ca.Certifcation__c = s.id;
                              ca.Certifcation_Rating__c = cr.id;
                              ca.Sales_Rep_Profile__c=s.Sales_Rep_Profile__c;                                                    
    
                              ca.Due_Date__c = Date.newInstance(Date.today().year(),Date.today().month(),noOfDays);
                              ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                              
                              if(ns.Enable_Notifications__c ){
                              
                                    if(ns.Advance_Reminders__c == '1 day prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-1);
                              //          ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-1);
                                    }
                                    else if(ns.Advance_Reminders__c == '3 days prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-3);
                               //         ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-3);
                                    }
                                    else if(ns.Advance_Reminders__c == '7 days prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-7);
                               //         ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                                    }
                                    
                                     if(ns.Escalation__c == '1 day prior'){
                                    ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 1);
                                }
                                else if(ns.Escalation__c == '2 days prior'){
                                    ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 2);
                                }
                                else if(ns.Escalation__c == '3 days prior'){
                                    ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 3);
                                }
                                else if(ns.Escalation__c == '4 days prior'){
                                    ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 4);
                                }
                                else if(ns.Escalation__c == '5 days prior'){
                                    ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 5);
                                }
                              }
                              
                              if(certAnsMonthMap != null && certAnsMonthMap.keySet().contains(s.id)){
                                  Certification_Answer__c cm = certAnsMonthMap.get(s.id);
                                  ca.Due_Date__c = cm.Due_Date__c;
                                  ca.Manager_Email_Date__c = cm.Manager_Email_Date__c;
                                  ca.Rating_Start_Date__c = cm.Rating_Start_Date__c;
                                  ca.Escalation_Email_Date__c = cm.Escalation_Email_Date__c;
                              }
                        
                              createAnsRecords.add(ca);                                          
                              
                          }
                                                                    
                      }
                                        
                  }
                  
            } 
            
            //Creating certification answers for quarterly ratings
            /*DateTime quarterEnd = FunnelCalculationHelper.getQuarterEndDate(Date.today());
            system.debug(' quart end date '+quarterEnd);    
            Date quarterEndDate = Date.newInstance(quarterEnd.yearGmt(), quarterEnd.monthGmt(),quarterEnd.dayGmt());
            
            DateTime quarStartDateTime = FunnelCalculationHelper.getQuarterStartDate();
            quarStartDateTime = quarStartDateTime.addMonths(2);
                            
            noOfDays = Date.daysInMonth(quarStartDateTime.year(),quarStartDateTime.month());
                           
            Date dueDate = Date.newInstance(quarStartDateTime.year(),quarStartDateTime.month(),noOfDays);*/

            Date dueDate = FunnelCalculationHelper.getQuarterEndInDateFormat(Date.today());
                   
            certiRating = [SELECT Id, X0LevelHigh__c, X0LevelLow__c,X1LevelHigh__c,X1LevelLow__c,X2LevelHigh__c,X2LevelLow__c,
                             X3LevelHigh__c,X3LevelLow__c,X4LevelHigh__c,X4LevelLow__c,Deactivated__c,Roles_enabled__c,Numeric_Weight__c,
                             Field_Name__c,name,User_Type__c  FROM Certification_Rating__c where Assessment_type__c='Qualitative' 
                             AND Deactivated__c = false And Timing__c='End of quarter' AND Id IN :CertId];        
            
            system.debug('certiRatingQ--'+certiRating ); 

            List<Certification_Answer__c> certAnsQuarter = new List<Certification_Answer__c>();
            certAnsQuarter = [Select id ,Certifcation__c ,Due_Date__c,Rating_Start_Date__c,Manager_Email_Date__c,Escalation_Email_Date__c from Certification_Answer__c Where Certifcation__c IN :cId AND Rating_Score__c = null  AND Certifcation_Rating__r.Timing__c = 'End of quarter' AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative' AND Sales_rep_profile__r.Active__c = TRUE Order By Createddate Desc];
            System.debug('certAnsQuarter -->'+certAnsQuarter );
            Map<id,Certification_Answer__c> certAnsQuarterMap = new Map<id,Certification_Answer__c>();
            for(Certification_Answer__c c : certAnsQuarter){
                if(!certAnsQuarterMap.keySet().contains(c.Certifcation__c)){
                    certAnsQuarterMap.put(c.Certifcation__c,c);
                     
                }
                
            }
            System.debug('certAnsQuarterMap-->'+certAnsQuarterMap);
                        
            if(certiRating != null && certiRating.size() > 0 ){
                
                  for(Certification__c s: certs){
                                        
                      for(Certification_Rating__c cr : certiRating){                  
                          
                          Set<String> rolesSet = new Set<String>();
                        
                          if(cr.Roles_enabled__c != null){
                                List<String> rolesList = cr.Roles_enabled__c.split(';');
                                for(String r:rolesList){
                                    rolesSet.add(r);
                                }
                          }
                                                
                          if(cr.Roles_enabled__c != null  && (s.Sales_Rep_Profile__r.Rep_Staus__c == cr.User_Type__c  || cr.User_Type__c =='Both') && s.Sales_Rep_Profile__r.Role__c != null && rolesSet.contains(s.Sales_Rep_Profile__r.Role__c)){                      
                              
                              system.debug(' condition matched ');
                              
                              Certification_Answer__c ca= new Certification_Answer__c();
                              ca.Name = cr.name;
                              if(!Test.isRunningTest()){
                                 ca.Rating_name_picklist__c = cr.name;
                                }
                              ca.Certifcation__c = s.id;
                              ca.Certifcation_Rating__c = cr.id;
                              ca.Sales_Rep_Profile__c=s.Sales_Rep_Profile__c;                                                    
    
                              ca.Due_Date__c = dueDate;
                              ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                              
                              if(ns.Enable_Notifications__c ){
                              
                                    if(ns.Advance_Reminders__c == '1 day prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-1);
                             //           ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-1);
                                    }
                                    else if(ns.Advance_Reminders__c == '3 days prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-3);
                              //          ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-3);
                                    }
                                    else if(ns.Advance_Reminders__c == '7 days prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-7);
                              //          ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                                    }
                                    
                                     if(ns.Escalation__c == '1 day prior'){
                                    ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 1);
                                    }
                                    else if(ns.Escalation__c == '2 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 2);
                                    }
                                    else if(ns.Escalation__c == '3 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 3);
                                    }
                                    else if(ns.Escalation__c == '4 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 4);
                                    }
                                    else if(ns.Escalation__c == '5 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 5);
                                    }
                              }
                                
                              
                              if(certAnsQuarterMap!= null && certAnsQuarterMap.keySet().contains(s.id)){
                                  Certification_Answer__c cq = certAnsQuarterMap.get(s.id);
                                  ca.Due_Date__c = cq.Due_Date__c;
                                  ca.Manager_Email_Date__c = cq.Manager_Email_Date__c;
                                  ca.Rating_Start_Date__c = cq.Rating_Start_Date__c;
                                  ca.Escalation_Email_Date__c = cq.Escalation_Email_Date__c;
                              }
                              
                              createAnsRecords.add(ca);                                          
                              
                          }
                                                                    
                      }
                                        
                  }
                                
            } 
            
            //Creating certification answers for bi-annual ratings
            
            DateTime Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
                    
            DateTime month6Start = Fyear.addMonths(5);
            
            noOfDays = Date.daysInMonth(month6Start.yearGMT(),month6Start.monthGMT());
            
            dueDate = Date.newInstance(month6Start.yearGMT(),month6Start.monthGMT(),noOfDays);
            
            if(Date.today() > dueDate){
                dueDate = dueDate.addMonths(6);
                noOfDays = Date.daysInMonth(dueDate.year(),dueDate.month());
                dueDate = Date.newInstance(dueDate.year(),dueDate.month(),noOfDays);
            }
                    
            certiRating = [SELECT Id, X0LevelHigh__c, X0LevelLow__c,X1LevelHigh__c,X1LevelLow__c,X2LevelHigh__c,X2LevelLow__c,
                             X3LevelHigh__c,X3LevelLow__c,X4LevelHigh__c,X4LevelLow__c,Deactivated__c,Roles_enabled__c,Numeric_Weight__c,
                             Field_Name__c,name,User_Type__c  FROM Certification_Rating__c where Assessment_type__c='Qualitative' 
                             AND Deactivated__c = false And Timing__c='Bi-annual' AND Id IN :CertId];        
             
            List<Certification_Answer__c> certAnsBiAannual = new List<Certification_Answer__c>();
            certAnsBiAannual = [Select id ,Certifcation__c ,Due_Date__c,Rating_Start_Date__c,Manager_Email_Date__c,Escalation_Email_Date__c from Certification_Answer__c Where Certifcation__c IN :cId AND  Rating_Score__c = null  AND Certifcation_Rating__r.Timing__c = 'Bi-annual' AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative' AND Sales_rep_profile__r.Active__c = TRUE Order By Createddate Desc];
            
            Map<id,Certification_Answer__c> certAnsBiAannualMap = new Map<id,Certification_Answer__c>();
            for(Certification_Answer__c c : certAnsBiAannual){
                if(!certAnsBiAannualMap.keySet().contains(c.Certifcation__c )){
                    certAnsBiAannualMap.put(c.Certifcation__c ,c);
                }
                
            }
             
            if(certiRating != null && certiRating.size() > 0 ){
                
                  for(Certification__c s: certs){
                                        
                      for(Certification_Rating__c cr : certiRating){                  
                          
                          Set<String> rolesSet = new Set<String>();
                        
                          if(cr.Roles_enabled__c != null){
                                List<String> rolesList = cr.Roles_enabled__c.split(';');
                                for(String r:rolesList){
                                    rolesSet.add(r);
                                }
                          }
                                                
                          if(cr.Roles_enabled__c != null  && (s.Sales_Rep_Profile__r.Rep_Staus__c == cr.User_Type__c  || cr.User_Type__c =='Both') && s.Sales_Rep_Profile__r.Role__c != null && rolesSet.contains(s.Sales_Rep_Profile__r.Role__c)){                      
                          
                              system.debug(' condition matched ');
                              
                              Certification_Answer__c ca= new Certification_Answer__c();
                              ca.Name = cr.name;
                              if(!Test.isRunningTest()){
                                 ca.Rating_name_picklist__c = cr.name;
                                }
                              ca.Certifcation__c = s.id;
                              ca.Certifcation_Rating__c = cr.id;
                              ca.Sales_Rep_Profile__c=s.Sales_Rep_Profile__c;                                                    
    
                              ca.Due_Date__c = dueDate;
                              ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                              
                              if(ns.Enable_Notifications__c ){
                              
                                    if(ns.Advance_Reminders__c == '1 day prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-1);
                               //         ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-1);
                                    }
                                    else if(ns.Advance_Reminders__c == '3 days prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-3);
                                //        ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-3);
                                    }
                                    else if(ns.Advance_Reminders__c == '7 days prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-7);
                               //         ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                                    }
                                    
                                     if(ns.Escalation__c == '1 day prior'){
                                    ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 1);
                                    }
                                    else if(ns.Escalation__c == '2 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 2);
                                    }
                                    else if(ns.Escalation__c == '3 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 3);
                                    }
                                    else if(ns.Escalation__c == '4 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 4);
                                    }
                                    else if(ns.Escalation__c == '5 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 5);
                                    }
                              }
                              
                              if(certAnsBiAannualMap != null && certAnsBiAannualMap.keySet().contains(s.id)){
                                  Certification_Answer__c cb = certAnsBiAannualMap.get(s.id);
                                  ca.Due_Date__c = cb.Due_Date__c;
                                  ca.Manager_Email_Date__c = cb.Manager_Email_Date__c;
                                  ca.Rating_Start_Date__c = cb.Rating_Start_Date__c;
                                  ca.Escalation_Email_Date__c = cb.Escalation_Email_Date__c;
                              }
                              
                              createAnsRecords.add(ca);                                          
                              
                          }
                                                                    
                      }
                                        
                  }
                                
            }
            
            //Creating certification answers for annual ratings
            
            Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
            DateTime month12Start = Fyear.addMonths(11);
            
            noOfDays = Date.daysInMonth(month12Start.yearGMT(),month12Start.monthGMT());
            
            dueDate = Date.newInstance(month12Start.yearGMT(),month12Start.monthGMT(),noOfDays);
                    
            certiRating = [SELECT Id, X0LevelHigh__c, X0LevelLow__c,X1LevelHigh__c,X1LevelLow__c,X2LevelHigh__c,X2LevelLow__c,
                             X3LevelHigh__c,X3LevelLow__c,X4LevelHigh__c,X4LevelLow__c,Deactivated__c,Roles_enabled__c,Numeric_Weight__c,
                             Field_Name__c,name,User_Type__c  FROM Certification_Rating__c where Assessment_type__c='Qualitative' 
                             AND Deactivated__c = false And Timing__c='Annual' AND Id IN :CertId];        
            
            List<Certification_Answer__c> certAnsAannual = new List<Certification_Answer__c>();
            certAnsAannual = [Select id,Certifcation__c  ,Due_Date__c,Rating_Start_Date__c,Manager_Email_Date__c,Escalation_Email_Date__c from Certification_Answer__c Where  Certifcation__c IN :cId AND  Rating_Score__c = null  AND Certifcation_Rating__r.Timing__c = 'Annual' AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative' AND Sales_rep_profile__r.Active__c = TRUE Order By Createddate Desc];
            Map<id,Certification_Answer__c> certAnsAannualMap = new Map<id,Certification_Answer__c>();
            for(Certification_Answer__c c : certAnsAannual ){
                if(!certAnsAannualMap.keySet().contains(c.Certifcation__c )){
                    certAnsAannualMap.put(c.Certifcation__c ,c);
                }
                
            } 
             
            if(certiRating != null && certiRating.size() > 0 ){
                
                  for(Certification__c s: certs){
                                        
                      for(Certification_Rating__c cr : certiRating){                  
                          
                          Set<String> rolesSet = new Set<String>();
                        
                          if(cr.Roles_enabled__c != null){
                                List<String> rolesList = cr.Roles_enabled__c.split(';');
                                for(String r:rolesList){
                                    rolesSet.add(r);
                                }
                          }
                                                
                          if(cr.Roles_enabled__c != null  && (s.Sales_Rep_Profile__r.Rep_Staus__c == cr.User_Type__c  || cr.User_Type__c =='Both') && s.Sales_Rep_Profile__r.Role__c != null && rolesSet.contains(s.Sales_Rep_Profile__r.Role__c)){                      
                              
                              system.debug(' condition matched ');
                              
                              Certification_Answer__c ca= new Certification_Answer__c();
                              ca.Name = cr.name;
                              if(!Test.isRunningTest()){
                                 ca.Rating_name_picklist__c = cr.name;
                                }
                              ca.Certifcation__c = s.id;
                              ca.Certifcation_Rating__c = cr.id;
                              ca.Sales_Rep_Profile__c=s.Sales_Rep_Profile__c;                                                    
    
                              ca.Due_Date__c = dueDate;
                              ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                              
                              if(ns.Enable_Notifications__c ){
                              
                                    if(ns.Advance_Reminders__c == '1 day prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-1);
                              //          ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-1);
                                    }
                                    else if(ns.Advance_Reminders__c == '3 days prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-3);
                             //           ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-3);
                                    }
                                    else if(ns.Advance_Reminders__c == '7 days prior'){
                                        ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-7);
                             //           ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                                    }
                                    
                                     if(ns.Escalation__c == '1 day prior'){
                                    ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 1);
                                    }
                                    else if(ns.Escalation__c == '2 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 2);
                                    }
                                    else if(ns.Escalation__c == '3 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 3);
                                    }
                                    else if(ns.Escalation__c == '4 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 4);
                                    }
                                    else if(ns.Escalation__c == '5 days prior'){
                                        ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 5);
                                    }
                              }
                              if(certAnsAannualMap != null && certAnsAannualMap.keySet().contains(s.id)){
                                  Certification_Answer__c caa= certAnsAannualMap.get(s.id);
                                  ca.Due_Date__c = caa.Due_Date__c;
                                  ca.Manager_Email_Date__c = caa.Manager_Email_Date__c;
                                  ca.Rating_Start_Date__c = caa.Rating_Start_Date__c;
                                  ca.Escalation_Email_Date__c = caa.Escalation_Email_Date__c;
                              }
                              
                              createAnsRecords.add(ca);                                          
                              
                          }
                                                                    
                      }
                                        
                  }
                                
            }
            
           // certs[0].Total_Quantitative_Weight__c = createAnsRecords.size();
           // update certs[0];
            system.debug(' ans records created '+createAnsRecords);
            insert createAnsRecords;
        }
    }
}