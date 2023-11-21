public with sharing class FunnelApplicationSettingController {

    public Application_Setting__c appSetting{get;set;}
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    
    
    public FunnelApplicationSettingController(){
        try{
            List<String> fldList = new List<String>{prefix+'Header_Image__c'};
                
            Boolean readAccess = true;
            
            Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(prefix+'Application_Setting__c').getDescribe().fields.getMap();
             
            for(String fldName: fldList){
                if(!fieldMap.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            }
            
            if(readAccess){ 
                List<Application_Setting__c> asList = [select id,Probability__c,Qualified_Percentage__c,Implementation_Date__c,Leads_used__c from Application_Setting__c limit 1];
                appSetting = new Application_Setting__c();
                
                if(asList == null || (asList != null && asList.size()<1)){
                    
                    List<String> fldList1 = new List<String>{prefix+'Header_Image__c '};
                    
                    Boolean updateAccess = true;
                                
                    Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Application_Setting__c').getDescribe().fields.getMap();
                    
                    for(String fldName: fldList1){
                        if(!fieldMap1.get(fldName).getDescribe().isUpdateable()){
                          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                          updateAccess = false;
                        }
                        if(!fieldMap1.get(fldName).getDescribe().isCreateable()){
                          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                          updateAccess = false;
                        }                
                    } 
                    if(updateAccess){         
                        Organization org  = [select id, InstanceName from Organization limit 1];
                        Document doc = [SELECT Id FROM Document where DeveloperName='FM_email_logo' limit 1];
                        String headerUrl = 'https://'+org.instanceName+'.salesforce.com/servlet/servlet.ImageServer?id='+doc.id+'&oid='+org.id;
                        appSetting.Header_Image__c = headerUrl ;
                
                    }  
                       
                }
                else{                        
                   
                    appSetting = asList[0];
                       
                }
                
                
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelNotificationController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
        
        
             
    
    }
    
    public void save() {
        try{        
            if(Schema.getGlobalDescribe().get(prefix+'Application_Setting__c').getDescribe().isCreateable() && Schema.getGlobalDescribe().get(prefix+'Application_Setting__c').getDescribe().isUpdateable()){
                upsert appSetting ;
            }    
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelNotificationController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
    }

}