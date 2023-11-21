/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelCertificationsDailyBatch implements Database.Batchable<sobject>, Database.Stateful{
    
    Map<String,Set<String>> emailProfileMap = new Map<String,Set<String>>();             
    
    Map<String,Set<String>> firstEmailProfileMap = new Map<String,Set<String>>(); 
    
    Map<String,Set<String>> escalationEmailMap = new Map<String,Set<String>>(); 
    Set<String> escalationManagerName= new Set<String>(); 
        
    Map<String,String> emailEscMgrEmailMap = new Map<String,String>();
    
    Map<String,String> emailLevelMap  = new Map<String,String>();
        
    Boolean firstDay = false;
    
    Boolean thirdDay = false;
   
    public static String prefix{ get{return '';} set; }
        
    public FunnelCertificationsDailyBatch(){
          
    }
    
    public Database.QueryLocator start(Database.BatchableContext con){
                  
         String query;
         integer dayOne = 1;
         integer dayThree = 3;
         
         List<Notification_Setting__c> noti = [select Last_Date_for_submit__c  from  Notification_Setting__c ORDER BY createddate DESC limit 1 ];
         if(noti != null && noti.size()>0){
             if(noti[0].Last_Date_for_submit__c !=null && noti[0].Last_Date_for_submit__c == 0){
                 dayThree = 1;
                 dayOne = Date.daysInMonth(Date.today().year(), Date.today().month()) -1;
             
             }else if(noti[0].Last_Date_for_submit__c !=null && noti[0].Last_Date_for_submit__c == 1){
                 dayThree = Integer.valueOf(noti[0].Last_Date_for_submit__c) + 1;
                 dayOne = Date.daysInMonth(Date.today().year(), Date.today().month());
             
             }else if(noti[0].Last_Date_for_submit__c !=null && noti[0].Last_Date_for_submit__c > 0){
                 dayThree = Integer.valueOf(noti[0].Last_Date_for_submit__c)  + 1;
                 dayOne = Integer.valueOf(noti[0].Last_Date_for_submit__c) - 1;
             }
         
         }
         System.debug('dayOne =='+Date.today().day() +' '+Date.today().day()+' '+Date.today().day());
         if(Date.today().day() == dayOne  || Date.today().day() == Date.today().day()){
             query = 'SELECT Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.Name,Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__c,Certifcation__r.Sales_Rep_Profile__r.Name, Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__r.Email, Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__c , Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.Name, Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Name, Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email,Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.User_Record_Name__r.Email, Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__c, Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__c, Certifcation__r.Sales_Rep_Profile__r.Interim_Manager__r.Sales_Manager__c, Due_Date__c, Manager_Email_Date__c, Escalation_Email_Date__c, Rating_Score__c, Rating_start_date__c, Certifcation__r.Name, name FROM Certification_Answer__c WHERE Rating_Score__c = NULL AND (Due_date__c <= TODAY OR Escalation_Email_Date__c = TODAY) AND Sales_rep_profile__r.Active__c = TRUE';
             
             if(Date.today().day() == dayOne  ){
                 firstDay = true;
             }
             
             if(Date.today().day() == dayThree ){
                 thirdDay = true;
             }
             
             If(Test.isRunningTest()){
                 firstDay = true;
                 thirdDay = true;
             }
         }
         else{
             query = 'SELECT Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.Name,Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__c,Certifcation__r.Sales_Rep_Profile__r.Name, Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__r.Email, Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__c , Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.Name, Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Name, Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email,Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.User_Record_Name__r.Email, Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__c, Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__c, Certifcation__r.Sales_Rep_Profile__r.Interim_Manager__r.Sales_Manager__c, Due_Date__c, Manager_Email_Date__c, Escalation_Email_Date__c, Rating_Score__c, Rating_start_date__c, Certifcation__r.Name, name FROM Certification_Answer__c WHERE Rating_Score__c = NULL AND( Manager_email_date__c = TODAY OR Escalation_Email_Date__c = TODAY) AND Sales_rep_profile__r.Active__c = TRUE';
         }
         
         System.debug(' query '+query);         
         return Database.getQueryLocator(query);
    }
        
    List<Notification_Setting__c> noti = [SELECT Id, Notification_Frequency__c, Enable_Notifications__c FROM Notification_Setting__c LIMIT 1];
    
    List<Certification_Answer__c> ansUpdateList = new List<Certification_Answer__c>();
        
    public void execute(Database.BatchableContext con, List<Certification_Answer__c> ca){
        try{    
                
            if(noti != null && noti.size() > 0 && noti[0].Enable_Notifications__c){
                
                Map<String,Id> emailMgrIdMap = new Map<String,Id>();
                
                Set<Id> mgrIds = new Set<Id>();
                
                Boolean answerUpdated = false;
                                                    
                for(Certification_Answer__c s:ca){                                                
                    system.debug(' ans '+s.Name);
                    system.debug(' prof '+s.Certifcation__r.Name);
                    system.debug(' prof '+s.Certifcation__r.Sales_Rep_Profile__r.Name);
                    
                                                                                                                                                          
                    if(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__c != null && s.Due_Date__c  <= Date.today() && ( firstDay || thirdDay)){
                        
                        system.debug(' prof '+s.Certifcation__r.Sales_Rep_Profile__r.Name);
                        
                        Set<String> salesRepNames = new Set<String>();
                        if(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.User_Record_Name__c != null && !emailProfileMap.keySet().contains(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.User_Record_Name__r.Email)){                                                                    
                            
                            if(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__c != null)
                                salesRepNames.add(s.Certifcation__r.Sales_Rep_Profile__r.Name);
                            
                            system.debug(' salesRepNames '+salesRepNames);
                            
                            emailProfileMap.put(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.User_Record_Name__r.Email,salesRepNames);
                           
                            mgrIds.add(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__c);
                            //emailMgrIdMap.put(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.User_Record_Name__r.Email,s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__c);
                        }
                        else if(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.User_Record_Name__c != null && emailProfileMap.keySet().contains(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.User_Record_Name__r.Email)){
                            emailProfileMap.get(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.User_Record_Name__r.Email).add(s.Certifcation__r.Sales_Rep_Profile__r.Name);
                        }                                                                
                                                        
                        if(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__c != null && s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__c != null && s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__c != null && s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email != null && !emailProfileMap.keySet().contains(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email)){
                            emailProfileMap.put(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email,salesRepNames);
                            mgrIds.add(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__c);
                        
                            //emailMgrIdMap.put(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email,s.Certifcation__r.Sales_Rep_Profile__r.Interim_Manager__r.Sales_Manager__c);
                            
                        }else if(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__c != null && s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__c != null && s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__c != null && s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email != null && emailProfileMap.keySet().contains(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email) ){
                            emailProfileMap.get(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email).add(s.Certifcation__r.Sales_Rep_Profile__r.Name);
                        }
                    } 
                    
                    else if(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__c != null && s.Manager_Email_Date__c == Date.today() && !firstDay && !thirdDay){
                        Set<String> salesRepNames = new Set<String>();
                        if(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.User_Record_Name__c != null && !firstEmailProfileMap.keySet().contains(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.User_Record_Name__r.Email)){                                                                    
                            
                            if(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__c != null)
                                salesRepNames.add(s.Certifcation__r.Sales_Rep_Profile__r.Name);
                            
                            system.debug(' salesRepNames '+salesRepNames);
                            
                            firstEmailProfileMap.put(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.User_Record_Name__r.Email,salesRepNames);
                           
                            mgrIds.add(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__c);
                            //emailMgrIdMap.put(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.User_Record_Name__r.Email,s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__c);
                        }
                        else if(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.User_Record_Name__c != null && firstEmailProfileMap.keySet().contains(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.User_Record_Name__r.Email)){
                            firstEmailProfileMap.get(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.User_Record_Name__r.Email).add(s.Certifcation__r.Sales_Rep_Profile__r.Name);
                        }                                                                
                                                        
                        if(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__c != null && s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__c != null && s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__c !=null && s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email != null && !firstEmailProfileMap.keySet().contains(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email)){
                            firstEmailProfileMap.put(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email,salesRepNames);
                            mgrIds.add(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__c);
                        
                            //emailMgrIdMap.put(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email,s.Certifcation__r.Sales_Rep_Profile__r.Interim_Manager__r.Sales_Manager__c);
                            
                        }else if(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__c != null && s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__c != null && s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__c !=null && s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email != null && firstEmailProfileMap.keySet().contains(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email) ){
                            firstEmailProfileMap.get(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email).add(s.Certifcation__r.Sales_Rep_Profile__r.Name);
                        }
                    } 
                    
                    if(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__c != null && s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__c !=null && s.Escalation_Email_Date__c == Date.today()){
                    
                        if(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__c != null && s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__r.Email != null){
                            
                            system.debug(' s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__r.Email '+s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__r.Email);
                            
                            if(!escalationEmailMap.keySet().contains(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__r.Email)){
                                
                                Set<String> mrgNames = new Set<String>();
                                
                                if(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__c != null)
                                    mrgNames.add(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Name);
                                
                                system.debug(' mrgNames '+mrgNames);
                                escalationManagerName.add(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Name);
                                escalationEmailMap.put(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__r.Email,mrgNames);
                            }
                            else if(escalationEmailMap.keySet().contains(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__r.Email)){
                                escalationEmailMap.get(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__r.Email).add(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Name);
                                escalationManagerName.add(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Name);
                                system.debug(' escalationEmailMap.get(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__r.Email) '+escalationEmailMap.get(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__r.Email));
                            }
                            
                            if(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__c != null && escalationEmailMap.keySet().contains(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__r.Email)){
                                escalationEmailMap.get(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__r.Email).add(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.Name);
                                escalationManagerName.add(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Interim_Manager__r.Name);
                               system.debug(' escalationEmailMap.get(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__r.Email) '+escalationEmailMap.get(s.Certifcation__r.Sales_Rep_Profile__r.Sales_Manager__r.Sales_Manager__r.User_Record_Name__r.Email));
                            }
                            
                        } 
                    }
                    
                    system.debug(' emailProfileMap '+emailProfileMap);
                
                    system.debug(' firstEmailProfileMap  '+firstEmailProfileMap);
                                                                                                                                       
                    if(noti[0].Notification_Frequency__c == 'Daily'){
                        s.Manager_Email_Date__c = s.Manager_Email_Date__c +1;    
                    }
                    else if(noti[0].Notification_Frequency__c == 'Every Other Day'){
                        s.Manager_Email_Date__c = s.Manager_Email_Date__c +2;
                    }
                                            
                    answerUpdated = true;
                                                            
                }
                
                if(answerUpdated){
                    update ca;
                }                     
                
                List<Sales_rep_profile__c> repWithMgrs = [SELECT id, Sales_manager__c, User_record_name__r.Email, Sales_manager__r.User_record_name__r.Email FROM Sales_rep_profile__c WHERE id IN :mgrIds];
                
                for(Sales_rep_profile__c s: repWithMgrs){
                    if(s.User_record_name__c != null && s.Sales_manager__r.User_record_name__c !=null)
                    emailEscMgrEmailMap.put(s.User_record_name__r.Email,s.Sales_manager__r.User_record_name__r.Email);
                }
                
                //emailLevelMap = new Map<String,String>();
                List<Company_level__c> levelWithMgrs = [SELECT id, Level_Name__c, Level_value__c, Sales_rep_profile__r.User_record_name__r.Email FROM Company_level__c WHERE Sales_rep_profile__c IN :mgrIds];
                
                for(Company_level__c c: levelWithMgrs){
                    emailLevelMap.put(c.Sales_rep_profile__r.User_record_name__r.Email,c.Level_Name__c+' : '+c.Level_value__c);
                }
                
                system.debug(' emailProfileMap '+emailProfileMap);
                
                system.debug(' firstEmailProfileMap  '+firstEmailProfileMap);
                
                system.debug(' emailEscMgrEmailMap '+emailEscMgrEmailMap);  
                
                system.debug(' emailLevelMap '+emailLevelMap);                                                                           
            }
                                
             
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelCertificationsDailyBatch '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }              
    }        
    
    public void finish(Database.BatchableContext cont){
    
        try{
            
            List<Funnel_Org_Wide_Address__mdt> owMd = [SELECT label FROM Funnel_Org_Wide_Address__mdt LIMIT 1];
            system.debug(owMd);
                            
            String headerURL = '';
            List<Application_Setting__c> prob = [SELECT Id, Header_Image__c FROM Application_Setting__c limit 1];
            if(prob != null && prob.size()>0){
                headerURL = prob[0].Header_Image__c;
            }                    
            
            Id owEmailId;
            
            if(owMd != null && owMd.size() > 0){
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :owMd[0].label];
                if(owea != null && owea.size() > 0){
                    owEmailId = owea[0].id;
                }
            }
            
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            List<String> emailsList;
            
            if(emailProfileMap != null && emailProfileMap.size() > 0){
                emailsList = new List<String>();
                emailsList.addAll(emailProfileMap.keySet());
            }                
            
            if(firstDay || thirdDay){
            
                for (Integer i=0; i<emailProfileMap.size(); i++) {
                
                    // Step 1: Create a new Email
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    // Step 2: Set list of people who should get the email
                    List<String> sendTo = new List<String>();
                    
                    sendTo.add(emailsList[i]);
                    //sendTo.add('carine.dmello@azularc.com');
                    
                    List<String> emails = new List<String> (emailProfileMap.keySet());
                    List<String> profs = new List<String>();
                    profs.addAll(emailProfileMap.get(emails[i]));
                    
                    mail.setToAddresses(sendTo);
                    
                    sendTo = new List<String>();
                    sendTo.add(emailEscMgrEmailMap.get(emailsList[i]));
                                        
                    if(sendTo != null && sendTo.size() > 0 && emailEscMgrEmailMap.get(emailsList[i]) != null){
                        mail.setCcAddresses(sendTo);
                    }
                                    
                    if (owEmailId != null) {
                        mail.setOrgWideEmailAddressId(owEmailId);
                    }            
                    
                    system.debug(' owEmailId '+owEmailId);                                                                                        
                    
                    String body;
                    
                    if(firstDay){
                    
                        mail.setSubject('Final Notice: Funnelocity Ratings are due');
                        
                        if(profs.size() > 1)
                            body = 'You have Funnelocity Ratings that are now due. The following employees need updates by end of day tomorrow to have an accurate score.'+'<br/>';
                        else
                            body = 'You have Funnelocity Ratings that are now due. The following employee needs updates by end of day tomorrow to have an accurate score.'+'<br/>';
                     }
                     else if (thirdDay) {
                         
                        mail.setSubject('Funnelocity Ratings have not been updated');
                        
                        if(profs.size() > 1)
                            body = 'Please be advised, the following people on your team do not have an updated score since the ratings were not completed by the deadline.'+'<br/>'+'<br/>';
                        else
                            body = 'Please be advised, the following person on your team does not have an updated score since the ratings were not completed by the deadline.'+'<br/>'+'<br/>';                                                                   
                        
                     }                                                  
        
                     for(Integer j=0; j<profs.size(); j++){
                        if(j==(profs.size() - 1)){
                            body += profs[j] +'<br/>';
                        }
                        else{
                            body += profs[j] +'<br/>';
                        }
                     } 
                     
                     if(firstDay){
                        body += '<br/>'+'Please click on the following link to login and update your team:'+'<br/>';                              
                        body += 'https://'+URL.getSalesforceBaseUrl().getHost()+'/apex/FunnelMetrics__FunnelCertificationupdate?source=email';                                  
                     }
                   
                     mail.setHtmlBody('<html><body><img src="' +headerURL+ '"/><br/>'+body+'</body></html>');  
                        
                     system.debug(' mail added '+mail);
                     
                     // Step 5. Add your email to the master list
                     mails.add(mail);                                               
                    
                }
            } 
            else if(emailProfileMap != null && emailProfileMap.size() > 0){
            
                 for (Integer i=0; i<emailProfileMap.size(); i++) {
    
                    // Step 1: Create a new Email
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                                                
                    
                    List<String> emails = new List<String> (emailProfileMap.keySet());
                    
                    Set<String> profs = emailProfileMap.get(emails[i]);                        
                    
                    // Step 2: Set list of people who should get the email
                    List<String> sendTo = new List<String>();
                    
                    sendTo.add(emailsList[i]);
                    //sendTo.add('carine.dmello@azularc.com');
                    //sendTo.add('irfan.shaikh@azularc.com');
                    mail.setToAddresses(sendTo);
                    
                    if (owEmailId != null) {
                        mail.setOrgWideEmailAddressId(owEmailId);
                    }            
                    
                    system.debug(' owEmailId '+owEmailId);                        
                                
                    mail.setSubject('Reminder: Funnelocity Ratings are due');
                    
                    String body;
                                            
                    body = 'You still have Funnelocity Ratings that are due. Failing to update these will result in inaccurate scores. Please click on the following link to login and update your team: ';
                       
                    body += 'https://'+URL.getSalesforceBaseUrl().getHost()+'/apex/FunnelMetrics__FunnelCertificationupdate?source=email';                                  
                    
                    mail.setHtmlBody('<html><body><img src="' +headerURL+ '"/><br/>'+body+'</body></html>');  
                                            
                    system.debug(' mail added '+mail);
                    
                    // Step 5. Add your email to the master list
                    mails.add(mail);
                    
                }
            
            }
            
            if(firstEmailProfileMap != null && firstEmailProfileMap.size() > 0){
                 
                 emailsList = new List<String>();
                 emailsList.addAll(firstEmailProfileMap.keySet());
                
                 for (Integer i=0; i<firstEmailProfileMap.size(); i++) {
    
                    // Step 1: Create a new Email
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    // Step 2: Set list of people who should get the email
                    List<String> sendTo = new List<String>();
                    
                    sendTo.add(emailsList[i]);
                    //sendTo.add('carine.dmello@azularc.com');
                    
                    List<String> emails = new List<String> (firstEmailProfileMap.keySet());
                    
                    Set<String> profs = firstEmailProfileMap.get(emailsList[i]);
                    mail.setToAddresses(sendTo);
                    
                    if (owEmailId != null) {
                        mail.setOrgWideEmailAddressId(owEmailId);
                    }            
                    
                    system.debug(' owEmailId '+owEmailId);                        
                                
                    mail.setSubject('Funnelocity Ratings are due soon');
                    
                    String body;
                                            
                    body = 'You have Funnelocity Ratings that are due. Please click on the following link to login and update your team:';
                       
                    body += 'https://'+URL.getSalesforceBaseUrl().getHost()+'/apex/FunnelMetrics__FunnelCertificationupdate?source=email';                                  
                    
                    mail.setHtmlBody('<html><body><img src="' +headerURL+ '"/><br/>'+body+'</body></html>');  
                                            
                    system.debug(' mail added '+mail);
                    
                    // Step 5. Add your email to the master list
                    mails.add(mail);
                    
                }
            
            }
            
            
            if(thirdDay && emailProfileMap != null && emailProfileMap.size() > 0){
                
                emailsList = new List<String>();
                emailsList.addAll(emailProfileMap.keySet());                    
    
                // Step 1: Create a new Email
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                // Step 2: Set list of people who should get the email
                List<String> sendTo = new List<String>();
                
                List<FM_Admins__mdt> adminMdt = [SELECT label FROM FM_Admins__mdt LIMIT 500];
                
                for(FM_Admins__mdt md: adminMdt){
                    sendTo.add(md.label);
                     
                }
                
                //sendTo.add('carine.dmello@azularc.com');
                //sendTo.add('irfan.shaikh@azularc.com');
                
                mail.setToAddresses(sendTo);                                                                                                                                                
                                                                 
                if (owEmailId != null) {
                    mail.setOrgWideEmailAddressId(owEmailId);
                }            
                
                system.debug(' owEmailId '+owEmailId);                        
                            
                mail.setSubject('Funnelocity Ratings have not been updated ');
                
                String body;
                                        
                body = 'Please be advised, the following people in your company do not have an updated score since the ratings were not completed by the deadline.'+'<br/>';
                
                List<String> emails = new List<String> (emailProfileMap.keySet());                        
                
                for (Integer i=0; i<emailProfileMap.size(); i++) {
                    
                    List<String> profs = new List<String>();
                    profs.addAll(emailProfileMap.get(emails[i]));
                
                    body += '<br/>'+emailLevelMap.get(emails[i]) +'<br/>';                                                                                      
                    
                    for(Integer j=0; j<profs.size(); j++){
                        if(j==(profs.size() - 1)){
                            body += profs[j] +'<br/>';
                        }
                        else{
                            body += profs[j] +'<br/>';
                        }
                    } 
                }
                mail.setHtmlBody('<html><body><img src="'+headerURL+'"/><br/>'+body+'</body></html>');  
                                        
                system.debug(' mail added '+mail);
                
                // Step 5. Add your email to the master list
                mails.add(mail);                        
                
            } 

            if(escalationEmailMap != null && escalationEmailMap.size() > 0){
                 
                 emailsList = new List<String>();
                 emailsList.addAll(escalationEmailMap.keySet());
                
                 for (Integer i=0; i<escalationEmailMap.size(); i++) {
    
                    // Step 1: Create a new Email
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    // Step 2: Set list of people who should get the email
                    List<String> sendTo = new List<String>();
                    
                    sendTo.add(emailsList[i]);
                    mail.setToAddresses(sendTo);
                    //sendTo.add('carine.dmello@azularc.com');
                    
                    List<String> emails = new List<String> (escalationEmailMap.keySet());
                    
                    Set<String> profs = escalationEmailMap.get(emailsList[i]);
                    
                    
                    if (owEmailId != null) {
                        mail.setOrgWideEmailAddressId(owEmailId);
                    }            
                    
                    system.debug(' owEmailId '+owEmailId);                        
                                
                    mail.setSubject('Funnelocity Ratings Pending Escalation Notification');
                    
                    String body;
                                            
                    body = 'The following managers have not submitted the ratings yet:'+'<br/>';
                    for(String ls: profs){
                        body += ls +'<br/>';
                    }   
                                                     
                    
                    mail.setHtmlBody('<html><body><img src="' +headerURL+ '"/><br/>'+body+'</body></html>');  
                                            
                    system.debug(' mail added '+mail);
                    
                    // Step 5. Add your email to the master list
                    mails.add(mail);
                    
                }
            
            }
            
            if(escalationEmailMap != null && escalationEmailMap.size() > 0){
                
                emailsList = new List<String>();
                emailsList.addAll(escalationEmailMap.keySet());                    
    
                // Step 1: Create a new Email
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                // Step 2: Set list of people who should get the email
                List<String> sendTo = new List<String>();
                
                List<FM_Admins__mdt> adminMdt = [SELECT label FROM FM_Admins__mdt LIMIT 500];
                
                for(FM_Admins__mdt md: adminMdt){
                    sendTo.add(md.label);
                     
                }
                
                //sendTo.add('carine.dmello@azularc.com');
                //sendTo.add('irfan.shaikh@azularc.com');
                
                mail.setToAddresses(sendTo);                                                                                                                                                
                                                                 
                if (owEmailId != null) {
                    mail.setOrgWideEmailAddressId(owEmailId);
                }            
                
                system.debug(' owEmailId '+owEmailId);                        
                            
                mail.setSubject('Funnelocity Ratings Pending Escalation Notification');
                
                String body;
                                        
                body = 'Please be advised, the following people managers have not submitted the ratings yet :'+'<br/>';
                
                for(String ls: escalationManagerName){
                        body += ls +'<br/>';
                }
                 
                mail.setHtmlBody('<html><body><img src="'+headerURL+'"/><br/>'+body+'</body></html>');  
                                        
                system.debug(' mail added '+mail);
                
                // Step 5. Add your email to the master list
                mails.add(mail);                        
                
            } 
            
            system.debug(' mails '+mails);                                        
            
            try{
                Messaging.sendEmail(mails);
            }
            catch(Exception ex){
                System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
                FunnelTriggerBatchHelper.sendErrorMail(' FunnelCertificationsDailyBatch '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());  
                
            }     
            
            //Messaging.sendEmail(mails[mails.size()-1]);
            
            if(thirdDay){
            
                Set<id> profIds = new Set<id>();
                List<AggregateResult> ars = [SELECT Sales_rep_profile__c sr FROM Certification_Answer__c WHERE Rating_Score__c = null AND Due_Date__c <= TODAY AND Sales_rep_profile__r.Active__c = TRUE GROUP BY Sales_rep_profile__c];
                
                for(AggregateResult ar: ars){
                  profIds.add((Id)ar.get('sr'));
                }
                
                system.debug(' profIds '+profIds);
                FunnelUpdateBlankAnswers m = new FunnelUpdateBlankAnswers(profIds);      
                database.executebatch(m,100);
            }
                            
            //update ansUpdateList;                
        
            FunnelRepTransitionDailyBatch m = new FunnelRepTransitionDailyBatch();      
            database.executebatch(m);                                
                                                      
       }
       
       catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelCertificationsDailyBatch '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());  
       }
    }                  
      
}