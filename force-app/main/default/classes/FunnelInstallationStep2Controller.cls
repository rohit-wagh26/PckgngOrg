public with sharing class FunnelInstallationStep2Controller {

    public String getAppsetup() {
        return null;
    }

    
    public list<Notification_Setting__c>  noti{get;set;}
    public Notification_Setting__c insertnoti {get;set;}
    public String orgwideEmailMtd{get;set;}
    public String adminEmailMtd{get;set;}
    public String copyadminEmailMtd{get;set;}
    public List<Funnel_Org_Wide_Address__mdt> orgWideMdt = new List<Funnel_Org_Wide_Address__mdt>();
    public List<FM_Admins__mdt> adminMdt = new List<FM_Admins__mdt>();
    
    
    public FunnelInstallationStep2Controller(){
        orgwideEmailMtd = '';
        adminEmailMtd = '';
         
        noti = [select id,name,Advance_Reminders__c,Last_Date_for_submit__c,Enable_Notifications__c,Escalation__c,Notification_Frequency__c,On_boarding_period__c from  Notification_Setting__c ORDER BY createddate DESC limit 1 ];
        insertnoti = new Notification_Setting__c();
        
        if(noti == null || (noti != null && noti.size()<1)){
            
            insertnoti.name ='Notification';
            insertnoti.Enable_Notifications__c = false;
            insertnoti.Advance_Reminders__c = '7 days prior';
            insertnoti.Notification_Frequency__c = 'Daily';
            //insertnoti.Escalation__c= '10 days overdue';
            insertnoti.On_boarding_Period__c= 90;
            insertnoti.Last_Date_for_submit__c= 7;
         }else{                        
            insertnoti = noti[0];
         }
         
         orgWideMdt = [SELECT label FROM Funnel_Org_Wide_Address__mdt LIMIT 1];
         for(Funnel_Org_Wide_Address__mdt ow: orgWideMdt ){
                orgwideEmailMtd=ow.label;
          }
         
          adminMdt = [SELECT label FROM FM_Admins__mdt LIMIT 500];
          for(FM_Admins__mdt ow: adminMdt ){
                if(adminEmailMtd == ''){
                    adminEmailMtd = ow.label;
                }else{
                    adminEmailMtd += ';'+ow.label;
                }
                
          }
          copyadminEmailMtd =  adminEmailMtd ;     
    }
    public void save(){
        FunnelInstallationHelper.saveStep('2'); 
        
        if((insertnoti.Last_Date_for_submit__c != null && insertnoti.Last_Date_for_submit__c  <= 0) || insertnoti.Last_Date_for_submit__c == null){
            insertnoti.Last_Date_for_submit__c = 0;
         }
         upsert insertnoti ;
         
         if(orgwideEmailMtd != ''){
             List<String> orgwideEmailMtdList = orgwideEmailMtd.split(';');
             if(orgwideEmailMtdList != null && orgwideEmailMtdList.size()>0){
                 FunnelInstallationHelper.createOrgEmail(orgwideEmailMtdList[0]);
                 //Map<String, Object> maptest = new Map<String, Object>();
                 //FMCreateUpdateMetadataUtils.createUpdateMetadata('FunnelMetrics__Funnel_Org_Wide_Address.FunnelMetrics__noReply_FM_com',orgwideEmailMtdList[0],maptest);
             }
         }
         
         if(adminEmailMtd != ''){
             FunnelInstallationHelper.createAdminEmail(adminEmailMtd ,copyadminEmailMtd,UserInfo.getSessionId() );
             
           /*  if(adminMdt != null && adminMdt.size()>0 && adminEmailMtd != copyadminEmailMtd ){
                MetadataService.MetadataPort service = new  MetadataService.MetadataPort();
                service.SessionHeader = new MetadataService.SessionHeader_element();
                service.SessionHeader.sessionId = UserInfo.getSessionId();
                List<String> recordsToDelete = new List<String>();
                for(FM_Admins__mdt admtd : [SELECT DeveloperName , label FROM FM_Admins__mdt]){
                    String s = 'FunnelMetrics__Funnel_Org_Wide_Address.FunnelMetrics__'+admtd.DeveloperName ;
                    recordsToDelete.add(s);
                }
                
                service.deleteMetadata('CustomMetadata', recordsToDelete);
             }
             
             List<String> adminEmailMtdList = adminEmailMtd.split(';');
             if(adminEmailMtdList != null && adminEmailMtdList.size()>0){
                 integer count = 1;
                 for(String e : adminEmailMtdList ){
                     Map<String, Object> maptest = new Map<String, Object>();
                     String s = 'FunnelMetrics__FM_Admins.FunnelMetrics__admin_'+String.valueOf(count );
                     FMCreateUpdateMetadataUtils.createUpdateMetadata(s,e,maptest);
                     count ++;
                } 
             } */
         }
         
        
    }
     public PageReference navigateToStep1(){
        save();
        return FunnelInstallationHelper.navigateToStep1();
    
    }
    
    public PageReference navigateToStep3a(){
        save();
        return FunnelInstallationHelper.navigateToStep3a();
    
    }

    public PageReference saveAndExit(){
        save();
        return FunnelInstallationHelper.navigateToChecklist();
    }

}