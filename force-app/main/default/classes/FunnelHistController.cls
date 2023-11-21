/*
Copyright: Funnel Metrics, LLC
*/
    public with sharing class FunnelHistController {

    public Boolean schMonBatch{get;set;}
    public Boolean schDayBatch{get;set;}
    public Boolean schDataPullBatch{get;set;}
    
    public FunnelHistController(FunnelSetupController controller) {
         srpsSnap =[SELECT COUNT(id) c, Sales_rep_profile__c o FROM Sales_rep_profile_snapshot__c WHERE Monthly_Quota_Revenue__c >0  GROUP BY Sales_rep_profile__c HAVING Count(Id) >= 2];
        Set<id> srIds= new Set<id>();
        for( AggregateResult r : srpsSnap ){
            srIds.add((Id)r.get('o'));
        }
        srps = [SELECT id FROM Sales_rep_profile__c WHERE Active__c = TRUE  AND Dont_send_to_model__c = False   AND YTD_Quota__c > 0 AND Profile_Type__c != 'Overlay' AND Tenure__c > 1  AND Rep_Staus__c = 'Tenured' AND ID IN :srIds];
        checkSchjob();
    }
    
    public void checkSchjob(){
        
        List<CronTrigger> cornListMon = new List<CronTrigger>();
        cornListMon =[SELECT Id, CronJobDetail.name, State FROM CronTrigger where CronJobDetail.name='FM Monthly batch'];
        if(cornListMon != null && cornListMon.size()>0){
            schMonBatch= false;
        }else{
            schMonBatch= true;
        }
        
        List<CronTrigger> cornListDay = new List<CronTrigger>();
        cornListDay =[SELECT Id, CronJobDetail.name, State FROM CronTrigger where CronJobDetail.name='FM Daily batch'];
        if(cornListDay != null && cornListDay.size()>0){
            schDayBatch= false;
        }else{
            schDayBatch= true;
        }
        
        List<CronTrigger> cornListpull = new List<CronTrigger>();
        cornListpull =[SELECT Id, CronJobDetail.name, State FROM CronTrigger where CronJobDetail.name='FM Model Score Data Pull' OR CronJobDetail.name='FM Model Qual Data Pull' OR CronJobDetail.name='FM Model Quant Data Pull' OR CronJobDetail.name='FM Model Update Manager Score'];
        if(cornListpull != null && cornListpull .size()>0){
            schDataPullBatch = false;
        }else{
            schDataPullBatch = true;
        }
    }

    public boolean timer {get; set;}
    
    List<Sales_rep_profile__c> srps = new List<Sales_rep_profile__c>();
    List<AggregateResult> srpsSnap = new List<AggregateResult>();
    
    public FunnelHistController (){
        srpsSnap =[SELECT COUNT(id) c, Sales_rep_profile__c o FROM Sales_rep_profile_snapshot__c WHERE Monthly_Quota_Revenue__c >0  GROUP BY Sales_rep_profile__c HAVING Count(Id) >= 2];
        Set<id> srIds= new Set<id>();
        for( AggregateResult r : srpsSnap ){
            srIds.add((Id)r.get('o'));
        }
        srps = [SELECT id FROM Sales_rep_profile__c WHERE Active__c = TRUE  AND Dont_send_to_model__c = False   AND YTD_Quota__c > 0 AND Profile_Type__c != 'Overlay' AND Tenure__c > 1  AND Rep_Staus__c = 'Tenured' AND ID IN :srIds];
    }
    
    public PageReference createHistData() {
        try{
            system.debug(' histDateValue '+histDateValue);
            //srps = [SELECT id FROM Sales_rep_profile__c];
            
            List<AsyncApexJob> a = new List<AsyncApexJob>();
            a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email, ExtendedStatus
            from AsyncApexJob WHERE (Status = 'Holding' OR Status = 'Queued' OR Status = 'Preparing' OR Status = 'Processing') AND JobType = 'BatchApex'];
            
            if(a.size() > 0 ){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Another batch in progress');
                ApexPages.addMessage(myMsg);
            }
            else{
                List<Sales_rep_profile_snapshot__c> ss = new List<Sales_rep_profile_snapshot__c>();
                ss = [SELECT id FROM Sales_rep_profile_snapshot__c WHERE Snapshot_scheduled_date__c = :histDateValue];
                
                if(ss.size() > 0 ){
                
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Snapshots already exist for this date');
                    ApexPages.addMessage(myMsg);            
                    
                }
                else{
                    FunnelCalculateYTDFieldsBatch fb = new FunnelCalculateYTDFieldsBatch(histDateValue,true,false);
                    //Funnel12MonthBatch fb = new Funnel12MonthBatch(histDateValue,false,false);        
                    Database.executeBatch(fb);
                    
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Batch is executing. Please monitor the status under Apex Jobs before running the next cycle.');
                    ApexPages.addMessage(myMsg);
                    
                    timerOn();
                }
            }
        }catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        }
            return null;
            
    }
    
    public void scheduleMonthlyBatch() {
        try{
            FunnelScheduleSnapshotBatches sb = new FunnelScheduleSnapshotBatches();
            String sch = '0 0 23 L * ?';
            //String sch = '0 59 23 * * ?';
            system.schedule('FM Monthly batch', sch, sb);
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Monthly Batch Scheduled');
            ApexPages.addMessage(myMsg);
            checkSchjob();
            timerOn();
        }catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        }

    }
    
    public void scheduleDailyBatch() {
        try{
            FunnelScheduleCertificationEmails sb = new FunnelScheduleCertificationEmails();
            String sch = '0 0 6 * * ?';
            system.schedule('FM Daily batch', sch, sb);
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Daily Batch Scheduled');
            ApexPages.addMessage(myMsg);
            
            checkSchjob();
            timerOn();
        }catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        }

    }       
    
    public void updateQualAnswers() {
        try{
            FunnelUpdateAnswersOnImplementation  fc = new FunnelUpdateAnswersOnImplementation ();
            Database.executeBatch(fc,50);
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Qualitative measures setup completed');
            ApexPages.addMessage(myMsg);
            
            timerOn();
        }catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        }
    
    }
    
    /*public void createCustomer() {
        
        //FunnelPostAPIs fp = new FunnelPostAPIs();
        
        //fp.getAccessToken();
        
       // fp.createCustomer();
        
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Customer created');
        ApexPages.addMessage(myMsg);
        
        timerOn();
        
        //FunnelCreateCertAnswersBatch fc = new FunnelCreateCertAnswersBatch ();
        //Database.executeBatch(fc);

    }
    
    public void pushDefinitions() {
        
        //FunnelPostAPIs fp = new FunnelPostAPIs();
        
        //fp.getAccessToken();
        
        //fp.createCustomer();
        
        //fp.createQuantRating();
        //fp.createQualRating();
        
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Qualitative and Quantitative definitions pushed');
        ApexPages.addMessage(myMsg);
        
        timerOn();
        //FunnelCreateCertAnswersBatch fc = new FunnelCreateCertAnswersBatch ();
        //Database.executeBatch(fc);

    }
    
    public void pushQuantData() {
        try{
            //system.debug(' srps '+srps);
            //FunnelPostAPIs fp = new FunnelPostAPIs();
            //fp.getAccessToken();
            
            //fp.dtSnapShot = quantDateValue;
            //fp.createQuantMetric(srps);
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Quantitative data pushed');
            ApexPages.addMessage(myMsg);
            
            timerOn();
        }
        catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        }
    }
    
    public void pushQualData() {
        try{
            //FunnelPostAPIs fp = new FunnelPostAPIs();
            //fp.getAccessToken();
            
            //fp.dtSnapShot = qualDateValue;
            //fp.createQualMetric(srps);
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Qualitative data pushed');
            ApexPages.addMessage(myMsg);
            
            timerOn();
            }catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        }

    }*/
    
     public static PageReference navigateToUserReport(){
        
        PageReference redirect;
        
        redirect = new PageReference('/apex/FunnelMetrics__FunnelUserReport'); 
 
        redirect.setRedirect(true);  
           
        return redirect;
    
    }
    
    public static PageReference navigateToGoalInput(){
        
        PageReference redirect;
        
        redirect = new PageReference('/apex/FunnelMetrics__FunnelAssignGoal'); 
 
        redirect.setRedirect(true);  
           
        return redirect;
    
    }
    
    public void scheduleDataPush() {
        try{
            /*
            FunnelScheduleDataPush sb = new FunnelScheduleDataPush();
            String sch = '0 0 23 3 * ?';
            system.schedule('FM Model Data Push', sch, sb);*/
            
            FunnelScheduleAnswerUpdates sb = new FunnelScheduleAnswerUpdates();
            String sch = '0 0 23 3 * ?';
            system.schedule('FM Model Data Push', sch, sb);
        }catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        }

    }
    
    public void scheduleDataPull() {
        try{
             integer pullday = 4;
             List<Notification_Setting__c> noti = [select Last_Date_for_submit__c  from  Notification_Setting__c ORDER BY createddate DESC limit 1 ];
             if(noti != null && noti.size()>0 && noti[0].Last_Date_for_submit__c !=null){
                 pullday = Integer.valueOf(noti[0].Last_Date_for_submit__c)  + 1;
             }
             String sch = '';
            /*FunnelScheduleDataPull sb = new FunnelScheduleDataPull();
            String sch = '0 0 23 '+pullday +' * ?';
            //String sch = '0 1 0 '+pullday +' * ?';*/
             
            //system.schedule('FM Model Score Data Pull', sch, sb);
            
            checkSchjob();
                   
            /*FunnelScheduleQualDataPull sb1 = new FunnelScheduleQualDataPull();
            sch = '0 0 23 '+pullday +' * ?';
            system.schedule('FM Model Qual Data Pull', sch, sb1);*/
            
            /*FunnelScheduleQuantDataPull sb2 = new FunnelScheduleQuantDataPull();
            sch = '0 0 23 '+pullday +' * ?';
            system.schedule('FM Model Quant Data Pull', sch, sb2);*/
            
            FMScheduledUpdateManagerFSQS sb3 = new FMScheduledUpdateManagerFSQS();
            sch = '0 50 23 '+pullday +' * ?';
            system.schedule('FM Model Update Manager Score', sch, sb3);
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Data pull Scheduled');
            ApexPages.addMessage(myMsg);
            
            timerOn();
        }catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        }

    }

    public Date histDateValue{ get; set; }
    
    public Date quantDateValue{ get; set; }
    
    public Date qualDateValue{ get; set; }
    
    public Date emailDateValue{ get; set; }
    
    public Date custMetDateValue{ get; set; }
    
    /*public void cm(){
        system.debug('inside cm');
        custommetric.updatecustomMetric();
    }*/
    
    /*public void pullScores(){
        try{
            FunnelGetApis fp = new FunnelGetApis();
            fp.getAccessToken();
              
            fp.getandUpdateFSQS();
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Scores pulled');
            ApexPages.addMessage(myMsg);
        
            timerOn();
        }
        catch(Exception ex){
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelHistController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        }
    }
    
    public void pullQualRatings(){
        try{
            FunnelGetApis fp = new FunnelGetApis();
            fp.getAccessToken();
              
            fp.getAndUpdateQualStats();
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Importanted Qualitative measures pulled');
            ApexPages.addMessage(myMsg);
        
            timerOn();
        }
        catch(Exception ex){
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelHistController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        }
    }
    
    public void pullQuantRatings(){
        try{    
            FunnelGetApis fp = new FunnelGetApis();
            fp.getAccessToken();
              
            fp.getAndUpdateQuantStats();
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Importanted Quantitative ratings pulled');
            ApexPages.addMessage(myMsg);
        
            timerOn();
        }
        catch(Exception ex){
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelHistController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
    }*/
    
    public void executeEmailBatch(){
        try{    
            FunnelCertificationsDailyBatch m = new FunnelCertificationsDailyBatch();      
            database.executebatch(m);    
        }
        catch(Exception ex){
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelHistController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
    }
    
    
                
    public void executeCustomMetricBatch(){
        try{    
            FunnelCustomMetricBatch fb = new FunnelCustomMetricBatch(custMetDateValue,false,false);
            //Funnel12MonthBatch fb = new Funnel12MonthBatch(histDateValue,false,false);        
            Database.executeBatch(fb);
        }
        catch(Exception ex){
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelHistController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
    }
                
    public void executeOppyBatch(){
        try{    
            Batch_CreateOpprtunityTracking otb = new Batch_CreateOpprtunityTracking();       
            Database.executeBatch(otb);
        }
        catch(Exception ex){
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelHistController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
    } 
        
    public void scheduleUpdatePickBatch(){
        try{    
            System.schedule('Funnel Update Global Picklist',  '0 00 * * * ?', new FunnelScheduleUpdateGlobalPicklist());
        }
        catch(Exception ex){
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelHistController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
    }
    
    public date leadDt {get; set;}
    public void executeLeadsBatch(){
            
        FunnelCalculateYTDFieldsBatch fb = new FunnelCalculateYTDFieldsBatch(leadDt,false,true);
        Database.executeBatch(fb);
                
    }
    
    public date mbDt {get; set;}
    public void executeMonthlyBatch(){
            
        Funnel12MonthBatch fb = new Funnel12MonthBatch(mbDt,false,true);
        Database.executeBatch(fb);
                 
    }
    
    public date csDt {get; set;}
    public void changeCSDt(){
        try{
            Fiscal_Year_Setting__c fy = FunnelTriggerBatchHelper.getFiscalYearRecord('Current_Year');
            fy.Start_Date__c = csDt;
            update fy;  
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Fiscal year updated');
            ApexPages.addMessage(myMsg);
            
            timerOn();
        }catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        }
         
    }
    
     public void createMT(){
         try{
            Map<String, Object> maptest = new Map<String, Object>();
            maptest.put('FunnelMetrics__Bypass__c',false);
            FMCreateUpdateMetadataUtils.createUpdateMetadata('FunnelMetrics__New_Data_load_setting.FunnelMetrics__Trigger','Bypass Funnel opp & lead triggers',maptest);
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Triggers Activated');
            ApexPages.addMessage(myMsg);
            
            timerOn();
        }catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        }
    }
    
    public void deactiveTrigger(){
        try{
            Map<String, Object> maptest = new Map<String, Object>();
            maptest.put('FunnelMetrics__Bypass__c',true);
            FMCreateUpdateMetadataUtils.createUpdateMetadata('FunnelMetrics__New_Data_load_setting.FunnelMetrics__Trigger','Bypass Funnel opp & lead triggers',maptest);
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Triggers Deactivated');
            ApexPages.addMessage(myMsg);
            
            timerOn();
        }catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        }
    } 
    
     public void deleteS3Folder(){
        try{
            
            //FunnelPostApis fp = new FunnelPostApis();
            //fp.getAccessToken();
            //fp.deleteS3();  
             
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'S3 folder Deleted');
            ApexPages.addMessage(myMsg);
            
            timerOn();
        }catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        }
    }
    
    public void sendRolesToS3(){
        try{
            
            //FunnelPostApis fp = new FunnelPostApis();
            //fp.getAccessToken();
            //fp.sendRoles();  
             
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Roles sent ');
            ApexPages.addMessage(myMsg);
            
            timerOn();
        }catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        }
    } 
    
    public void deleteHistoricalData(){
        try{
            
            List<FunnelMetrics__Certification_answer__c> ca = [SELECT id, FunnelMetrics__Due_date__c, CreatedDate FROM FunnelMetrics__Certification_answer__C WHERE FunnelMetrics__Certifcation_rating__r.FunnelMetrics__assessment_Type__c = 'Quantitative' LIMIT 5700];
            DELETE ca;
            
            List<FunnelMetrics__Sales_rep_profile_snapshot__C > ss =[ SELECT id FROM FunnelMetrics__Sales_rep_profile_snapshot__C Limit 500];
            DELETE ss;
             
            List< FunnelMetrics__Certification_snapshot__C > cs = [SELECT id FROM FunnelMetrics__Certification_snapshot__C Limit 500];
            DELETE cs;
            
            List< FunnelMetrics__Company_levels_snapshot__C > cls = [SELECT id FROM FunnelMetrics__Company_levels_snapshot__C Limit 100];
            DELETE cls;
            
            
            List< FunnelMetrics__Company_level_junction_snapshot__C > cl = [SELECT id FROM FunnelMetrics__Company_level_junction_snapshot__C LIMIT 2400];
            DELETE cl;
            
            List< Yearly_goals_by_Role__c > cr = [SELECT id FROM FunnelMetrics__Yearly_goals_by_Role__c Limit 80];
            DELETE cr;
            
            List<FunnelMetrics__Sales_Rep_Profile__c > srpList =[SELECT Id,FunnelMetrics__Goal_of_monthly_meetings__c ,FunnelMetrics__Goal_12m_Avg_Selling_Price__c ,FunnelMetrics__Goal_12m_Lead_To_Opp_Conv_Rate__c ,FunnelMetrics__Goal_12m_rolling_amt_close_rate__c,FunnelMetrics__Goal_12m_rolling_close_rate__c,FunnelMetrics__Goal_Average_Deal_Size__c ,FunnelMetrics__Goal_12m_length_of_sales_cycle__c  FROM FunnelMetrics__Sales_Rep_Profile__c Limit 5000];
            for(FunnelMetrics__Sales_Rep_Profile__c s: srpList){
            s.FunnelMetrics__Goal_of_monthly_meetings__c = null;
            s.FunnelMetrics__Goal_12m_Avg_Selling_Price__c  = null;
            s.FunnelMetrics__Goal_12m_Lead_To_Opp_Conv_Rate__c  = null;
            s.FunnelMetrics__Goal_12m_rolling_amt_close_rate__c  = null;
            s.FunnelMetrics__Goal_12m_rolling_close_rate__c  = null;
            s.FunnelMetrics__Goal_Average_Deal_Size__c  = null;
            s.FunnelMetrics__Goal_12m_length_of_sales_cycle__c  = null;
            
            s.Close_rate_Quarterly_opp_amount__c = 0;
            s.Close_rate_Quarterly_opp_count__c= 0;
            s.Close_rate_monthly_opp_amount__c= 0;
            s.Close_rate_monthly_opp_count__c= 0;
            s.Close_rate_YTD_opp_amount__c= 0;
            s.Close_rate_YTD_opp_count__c = 0;
            }
            update srpList;
            
            List<FunnelMetrics__Certification_answer__c> cas = [SELECT id, FunnelMetrics__Due_date__c, CreatedDate FROM FunnelMetrics__Certification_answer__C WHERE FunnelMetrics__Certifcation_rating__r.FunnelMetrics__assessment_Type__c = 'Quantitative' LIMIT 5900];
            List<FunnelMetrics__Sales_rep_profile_snapshot__C > sss =[ SELECT id FROM FunnelMetrics__Sales_rep_profile_snapshot__C Limit 500];
            List< FunnelMetrics__Certification_snapshot__C > css = [SELECT id FROM FunnelMetrics__Certification_snapshot__C Limit 500];
            List< FunnelMetrics__Company_levels_snapshot__C > clss = [SELECT id FROM FunnelMetrics__Company_levels_snapshot__C Limit 100];
            List< FunnelMetrics__Company_level_junction_snapshot__C > clls = [SELECT id FROM FunnelMetrics__Company_level_junction_snapshot__C LIMIT 2900];
            List< Yearly_goals_by_Role__c > crs = [SELECT id FROM Yearly_goals_by_Role__c Limit 80];
            
            if((cas != null && cas.size()>0)||(sss != null && sss.size()>0)||(css != null && css.size()>0)||(clss != null && clss.size()>0)||(clls != null && clls.size()>0)||(crs != null && crs.size()>0)  ){
            
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Re-run the script');
                ApexPages.addMessage(myMsg);
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Delete successfully');
                ApexPages.addMessage(myMsg);
            }
            
            timerOn();
        }catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        }
    } 
    
    public void syncData(){
        try{
            
            Date d = Date.newInstance(Date.today().year(),Date.today().month(), date.daysInMonth(Date.today().year(), Date.today().month()));  
            Funnel12MonthBatch fb = new Funnel12MonthBatch(d,false,true);
            Database.executebatch(fb); 
            
            Funnel12MonthBatchPart2 fb2 = new Funnel12MonthBatchPart2 (d,false,true);
            Database.executebatch(fb2); 
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Sync Completed');
            ApexPages.addMessage(myMsg);
            
            timerOn();
        }catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        }
    }  
    
    public void clearMessage(){
      ApexPages.getMessages().clear();

    }

    public void timerOn(){
        timer = true;
    }

    public void timerOff(){
         timer = false;
    }
}