/*
    Author:  Carine DMello
    Created On: 7/13/2018
    This trigger creates a Sales Profile every time a new user record is created - Old functionality
    Activate and deactivate Sales Profile based on User record - Current functioncality
*/

trigger FunnelUserTrigger on User (after insert, after update) {    
        
    List<Id> deactivatedRecs = new List<Id>();

    List<Id> activatedRecs = new List<Id>();
    
    string checkmng ;
   
    New_Data_load_setting__mdt[] mtDt = [SELECT Bypass__c FROM New_Data_load_setting__mdt LIMIT 1];
    Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues('Current_Year');
    
    if((fy != null  && mtDt != null && mtDt.size() > 0 &&  !mtDt[0].Bypass__c ) || (mtDt == NULL && fy != null ) ){
    
        try{
            /* 
            List<Sales_Rep_Profile__c> sReps = [select id, User_Record_Name__c from Sales_Rep_Profile__c limit 5000];    
            
            Map<Id,Id> userProfMap = new Map<Id,Id>();
            
            for(Sales_Rep_Profile__c s: sReps){
                userProfMap.put(s.User_Record_Name__c,s.id);
            }
            
              
            List<User> userRecs = [SELECT id,name,Username,ManagerId FROM User LIMIT 5000];
            
            Map<id,String> userloginNameMap = new Map<id,String>();
            
            for(User u: userRecs){
                userloginNameMap.put(u.id,u.Username );
            }*/
            
            for(User u : Trigger.new){    
                            
                checkmng = null;     
                            
                if(trigger.isUpdate && trigger.isAfter && !u.IsActive){
                    deactivatedRecs.add(u.id);
                } 
                
                if(trigger.isUpdate && trigger.isAfter && u.IsActive && !Trigger.oldMap.get(u.id).IsActive){
                    activatedRecs.add(u.id);
                }             
                              
            }
        
        }
        catch(Exception ex){
            System.debug('FunnelUserTrigger Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(ex.getMessage()+' '+ex.getStackTraceString()); 
        }   
        
        try{
            
            if(deactivatedRecs.size() > 0){
                FunnelTriggerBatchHelper.updateSalesProfsInactive(deactivatedRecs);
            }
            
            if(activatedRecs.size() > 0){
                FunnelTriggerBatchHelper.updateSalesProfsActive(activatedRecs);
            }
        
        }
        catch(Exception ex){
            System.debug('FunnelUserTrigger Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(ex.getMessage()+' '+ex.getStackTraceString()); 
        }
    }
}