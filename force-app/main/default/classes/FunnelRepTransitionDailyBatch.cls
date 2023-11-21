/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelRepTransitionDailyBatch implements Database.Batchable<sobject>, Database.Stateful{

    public Database.QueryLocator start(Database.BatchableContext con){
         String query = 'SELECT Sales_Manager__r.User_Record_Name__r.Email, Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email, Sales_Manager__r.Interim_Manager__c FROM Sales_Rep_Profile__c WHERE Rep_Staus__c = '+'\''+'New'+'\''+' AND On_boarding_Date__c = '+String.valueOf(System.today())+' AND Sales_Manager__c != null AND Active__c = TRUE';
         System.debug(' query '+query);         
         return Database.getQueryLocator(query);
    }
    
    Map<String,Integer> emailProfileMap = new Map<String,Integer>();    
        
    List<Notification_Setting__c> noti = [SELECT Id, Notification_Frequency__c, Enable_Notifications__c FROM Notification_Setting__c LIMIT 1];    
    
    public void execute(Database.BatchableContext con, List<Sales_Rep_Profile__c> sr){
        try{     
            if(noti != null && noti.size() > 0 && noti[0].Enable_Notifications__c){
                                                    
                for(Sales_Rep_Profile__c s:sr){
                    
                    if(s.Sales_Manager__r.User_Record_Name__c != null && !emailProfileMap.keySet().contains(s.Sales_Manager__r.User_Record_Name__r.Email)){    
                        emailProfileMap.put(s.Sales_Manager__r.User_Record_Name__r.Email,1);        
                    }
                    else if(s.Sales_Manager__r.User_Record_Name__c != null){
                        Integer count = emailProfileMap.get(s.Sales_Manager__r.User_Record_Name__r.Email);
                        count++;
                        emailProfileMap.put(s.Sales_Manager__r.User_Record_Name__r.Email,count);
                    } 
                    
                    if(s.Sales_Manager__r.Interim_Manager__c != null && s.Sales_Manager__r.Interim_Manager__r.User_Record_Name__c != null && s.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email != null && !emailProfileMap.keySet().contains(s.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email)){
                        emailProfileMap.put(s.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email,1);
                    }else if(s.Sales_Manager__r.Interim_Manager__c != null && s.Sales_Manager__r.Interim_Manager__r.User_Record_Name__c != null && s.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email != null && emailProfileMap.keySet().contains(s.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email) ){
                        Integer count = emailProfileMap.get(s.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email);
                        count++;
                        emailProfileMap.put(s.Sales_Manager__r.Interim_Manager__r.User_Record_Name__r.Email,count);
                    }                  
                } 
            }
            
            system.debug(' emailProfileMap '+emailProfileMap);    
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelRepTransitionDailyBatch '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()); 
        }       
    }        
    
    public void finish(Database.BatchableContext con){
        
        try{    
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            List<String> emailsList;                        
            
            String headerURL = '';
            List<Application_Setting__c> prob = [SELECT Id, Header_Image__c FROM Application_Setting__c limit 1];
            if(prob != null && prob.size()>0){
                headerURL = prob[0].Header_Image__c;
            }
            //system.debug('headerURL --'+headerURL );
            //EmailTemplate et=[Select id from EmailTemplate where Name= 'FM Email'];
            
            List<Funnel_Org_Wide_Address__mdt> owMd = [SELECT label FROM Funnel_Org_Wide_Address__mdt LIMIT 1];
            
            Id owEmailId;
            
            if(owMd != null && owMd.size() > 0){
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :owMd[0].label];
                if(owea != null && owea.size() > 0){
                    owEmailId = owea[0].id;
                }
            }                
            
            if(emailProfileMap != null && emailProfileMap.size() > 0){
                emailsList = new List<String>();
                emailsList.addAll(emailProfileMap.keySet());
            }
            
            for (Integer i=0; i<emailProfileMap.size(); i++) {
            
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                List<String> sendTo = new List<String>();
                
                sendTo.add(emailsList[i]);
                //sendTo.add('carine.dmello@azularc.com');
                                        
                mail.setToAddresses(sendTo);
                
                if (owEmailId != null) {
                    mail.setOrgWideEmailAddressId(owEmailId);
                }
                            
                mail.setSubject('Onboarding period complete');
                
                String body = 'On boarding period has been completed for some of the sales reps. Please click on the following link and login to access the list of reps and update them: ';
                
                body += 'https://'+URL.getSalesforceBaseUrl().getHost()+'/apex/FunnelMetrics__FunnelRepStatusUpdate?source=email';     
                                        
                mail.setHtmlBody('<html><body><img src="' +headerURL+ '"/><br/>'+body+'</body></html>');            
                // Create Email and Send            
                //mail.setTemplateId(et.id);
                
                system.debug(' mail added '+mail);
                //mail.setTargetObjectId(cont.Id);
                //mail.setSaveAsActivity(false);                       
                mails.add(mail);
                
            }                
            
            system.debug(' mails: '+mails);
            
            // Step 6: Send all emails in the master list
            Messaging.sendEmail(mails);
            
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelRepTransitionDailyBatch '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()); 
        }
    }            
    
}