public with sharing class FunnelInstallationStep9Controller {

    public void FinishInsatallation(){
        
        FunnelUpdateAnswersOnImplementation  fc = new FunnelUpdateAnswersOnImplementation ();
        Database.executeBatch(fc,50);
            
       /* List<Organization> org = [SELECT IsSandbox FROM Organization LIMIT 1];
    
        if(!org[0].isSandbox){
            List<CronTrigger> cornListMon = new List<CronTrigger>();
            cornListMon =[SELECT Id, CronJobDetail.name, State FROM CronTrigger where CronJobDetail.name='FM Monthly batch'];
            if(cornListMon != null && cornListMon.size()>0){
                //schMonBatch= false;
            }else{
                FunnelScheduleSnapshotBatches sb = new FunnelScheduleSnapshotBatches();
                String sch = '0 0 23 L * ?';
                system.schedule('FM Monthly batch', sch, sb);
            }
            
            List<CronTrigger> cornListDay = new List<CronTrigger>();
            cornListDay =[SELECT Id, CronJobDetail.name, State FROM CronTrigger where CronJobDetail.name='FM Daily batch'];
            if(cornListDay != null && cornListDay.size()>0){
                //schDayBatch= false;
            }else{
                FunnelScheduleCertificationEmails sb = new FunnelScheduleCertificationEmails();
                String sch = '0 0 6 * * ?';
                system.schedule('FM Daily batch', sch, sb);
            }
            
            List<CronTrigger> cornListpull = new List<CronTrigger>();
            cornListpull =[SELECT Id, CronJobDetail.name, State FROM CronTrigger where CronJobDetail.name='FM Model Score Data Pull'];
            if(cornListpull != null && cornListpull .size()>0){
                //schDataPullBatch = false;
            }else{
                 integer pullday = 4;
                 List<Notification_Setting__c> noti = [select Last_Date_for_submit__c  from  Notification_Setting__c ORDER BY createddate DESC limit 1 ];
                 if(noti != null && noti.size()>0 && noti[0].Last_Date_for_submit__c !=null){
                     pullday = Integer.valueOf(noti[0].Last_Date_for_submit__c)  + 1;
                 }
                 
                FunnelScheduleDataPull sb = new FunnelScheduleDataPull();
                String sch = '0 0 23 '+pullday +' * ?';
                //String sch = '0 1 0 '+pullday +' * ?';
                 
                system.schedule('FM Model Score Data Pull', sch, sb);
                
                
                       
                FunnelScheduleQualDataPull sb1 = new FunnelScheduleQualDataPull();
                sch = '0 0 23 '+pullday +' * ?';
                system.schedule('FM Model Qual Data Pull', sch, sb1);
                
                FunnelScheduleQuantDataPull sb2 = new FunnelScheduleQuantDataPull();
                sch = '0 0 23 '+pullday +' * ?';
                system.schedule('FM Model Quant Data Pull', sch, sb2);
                
                FMScheduledUpdateManagerFSQS sb3 = new FMScheduledUpdateManagerFSQS();
                sch = '0 50 23 '+pullday +' * ?';
                system.schedule('FM Model Update Manager Score', sch, sb3);
            }
            
        }*/
        FunnelInstallationHelper.saveStep('9'); 
        
        Map<String, Object> maptest = new Map<String, Object>();
        maptest.put('FunnelMetrics__Updated_by__c',UserInfo.getName());
        maptest.put('FunnelMetrics__Updated_date_time__c',System.now());
        maptest.put('FunnelMetrics__Completed__c',true);
         if (!test.isRunningTest())
        FMCreateUpdateMetadataUtils.createUpdateMetadata('FunnelMetrics__Installation_status.FunnelMetrics__Complete_installation_wizard','Complete installation wizard',maptest);
        //return FunnelInstallationHelper.navigateToChecklist();
    }
    
    public PageReference saveAndExit(){
       
        FunnelUpdateAnswersOnImplementation  fc = new FunnelUpdateAnswersOnImplementation ();
        Database.executeBatch(fc,50);
        
        FunnelInstallationHelper.saveStep('9'); 
        return FunnelInstallationHelper.navigateToChecklist();
    }
    
    public PageReference checkThemeAndNavigateStep9(){        
        
        String source = ApexPages.currentPage().getParameters().get('source');
        system.debug(' source '+source);
        system.debug(' UserInfo.getUiThemeDisplayed() '+UserInfo.getUiThemeDisplayed());
        
        User u = [SELECT Name, UserPreferencesLightningExperiencePreferred FROM User WHERE id = :UserInfo.getUserId()];
        
        if(source == 'email' && u.UserPreferencesLightningExperiencePreferred  == true){            
            PageReference p = new PageReference('/one/one.app#/alohaRedirect/apex/FunnelMetrics__FunnelInstallationStep9');
            return p;
        }
        else{
            return null;
        }
    }
}