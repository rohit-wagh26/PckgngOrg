public with sharing class FunnelSetupController {

    public FunnelSetupController(FunnelInstallationStep8Controller controller) {
        checksrpAndHisjob();
        batchNotstarted= true;
    }

    public boolean timerS {get; set;}
    
    public String label1{get; set;}
    public String label2{get; set;}
    public String label3{get; set;}
    public String selectedLevel1{get; set;}
    public String selectedLevel2{get; set;}
    public String selectedLevel3{get; set;}
    
    public Boolean adminPer{get;set;}
    public Boolean isManger{get;set;}
    
    public Boolean createSrp{get;set;}
    public Boolean createHisSrp{get;set;}
    public Boolean createHisSrpMid{get;set;}
    
    public Date goalDateValue{ get; set; }
    
    
    public Boolean batchNotstarted{get;set;}
      
    
    public FunnelSetupController(){
    
        label1 = ApexPages.currentPage().getParameters().get('labelOne');
        label2 = ApexPages.currentPage().getParameters().get('labelTwo');
        label3 = ApexPages.currentPage().getParameters().get('labelThree');
        selectedLevel1 = ApexPages.currentPage().getParameters().get('selectOne');
        selectedLevel2 = ApexPages.currentPage().getParameters().get('selectTwo');
        selectedLevel3 = ApexPages.currentPage().getParameters().get('selectThree');
        
        List<AggregateResult> asperm = [SELECT count(Id) c FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = 'Funnel_App_Setup'];
        if((asperm != null && asperm.size() > 0 && asperm[0].get('c') != null && (Integer)asperm[0].get('c') > 0)   ){
            adminPer= true;
        }else{
            adminPer= false;
        }
        
        isManger = FunnelTriggerBatchHelper.isManager(UserInfo.getUserId()); 
        
        
        //displayNext= false;
        
        checksrpAndHisjob();
        
        
    }
    public void checksrpAndHisjob(){
        
        List<Sales_Rep_Profile__c> srp   = new List<Sales_Rep_Profile__c>();
        srp  = [Select id from Sales_Rep_Profile__c Limit 1];
        if(srp  != null && srp .size()>0){
            createSrp = false;
        }else{
            createSrp = true;
        }
        
        List<Sales_Rep_Profile_Snapshot__c> srps   = new List<Sales_Rep_Profile_Snapshot__c>();
        srps  = [Select id from Sales_Rep_Profile_Snapshot__c Limit 1];
        if(srps  != null && srps .size()>0){
            createHisSrp= false;
        }else{
            createHisSrp= true;
        }
        
        List<CronTrigger> cornList = new List<CronTrigger>();
        cornList =[SELECT Id, CronJobDetail.name, State FROM CronTrigger where CronJobDetail.name='FM Historical Data'];
        if(cornList != null && cornList.size()>0){
            createHisSrpMid = false;
        }else{
            createHisSrpMid = true;
        }
    }
    public void CreateSalesprofile(){
        try{
            List<User> licensedUsers = [SELECT id ,Name FROM User WHERE Id in ( SELECT UserId  FROM UserPackageLicense  WHERE (PackageLicense.NamespacePrefix = 'FunnelMetrics'))];
            List<Sales_Rep_Profile__c> srpList = new List<Sales_Rep_Profile__c>();
             
              
            if(licensedUsers != null && licensedUsers.size() > 0){
               
                for(User u : licensedUsers ){
                    Sales_Rep_Profile__c s = new Sales_Rep_Profile__c(); 
                    s.Name = u.Name;
                    s.User_Record_Name__c = u.id;
                    srpList.add(s);
                }
               
                insert srpList;
               
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Created successfully!');
               ApexPages.addMessage(myMsg);
               timerOnS();
              
              //Create customer in LP
            /*    FunnelPostAPIs fp = new FunnelPostAPIs();
                fp.createCustomer(); */
               
            } 
        }catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(myMsg);
        }
        
    }
    
    public void CreateHD(){
        try{
            updateHeader();
            
            Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues('Current_Year');
           
            if(fy != null){
             
             /* Anblick
                FunnelPostAPIs fp = new FunnelPostAPIs();
                fp.createQuantRating();
                fp.createQualRating();
             */   
                Date fyd  = fy.Start_Date__c;
                Date histDateValue = Date.newinstance(fyd.year(), fyd.month(), date.daysInMonth(fyd.year(), fyd.month()));
                FunnelQuotaUpdateBatch fq = new FunnelQuotaUpdateBatch(histDateValue,true,true);
                Database.executeBatch(fq);
                
                batchNotstarted = false;
                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Creation of historical data has started. You will receive an email after it\'s completed');
                ApexPages.addMessage(myMsg);
                
                timerOnS();
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Fiscal year not set');
                ApexPages.addMessage(myMsg);
            }
            
           
        }catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
    
    public void CreateHDMidnight(){
        try{
            updateHeader();
            Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues('Current_Year');
           
            if(fy != null){
                
                Date todayDate = Date.today();
                todayDate = todayDate.addDays(1);
                
                Integer day = todayDate.day();
                Integer month= todayDate.month();
                Integer year= todayDate.year();

                
                FunnelScheduleMidnightImp sb = new FunnelScheduleMidnightImp();
                String sch = '0 0 0 '+day+' '+month+ ' ? '+year;
                system.schedule('FM Historical Data', sch, sb);
                
                batchNotstarted = false;
        
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Creation of historical data will start at midnight. You will receive an email after it\'s completed');
                ApexPages.addMessage(myMsg);
                timerOnS();
                
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Fiscal year not set');
                ApexPages.addMessage(myMsg);
                timerOnS();
            }
            
           
        }catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
    
    public void clearMessage(){
        ApexPages.getMessages().clear();

    }

    public void timerOnS(){
        timerS = true;
    }

    public void timerOffS(){
        timerS = false;
    }
    
    public void updateHeader(){
        Organization org  = [select id, InstanceName from Organization limit 1];
        List<Document> doc = [SELECT Id FROM Document where DeveloperName='FM_email_logo' limit 1];
      
        if(doc != null && doc.size()>0){
            String headerUrl = 'https://'+org.instanceName+'.salesforce.com/servlet/servlet.ImageServer?id='+doc[0].id+'&oid='+org.id;
            List<Application_Setting__c> asList = [select id,Probability__c,Qualified_Percentage__c,Implementation_Date__c,Leads_used__c from Application_Setting__c limit 1];
            asList[0].Header_Image__c = headerUrl ;
            update asList ;
        }
        
    }
    
    public void createGoals() {
        try{
             
            
            FunnelGoalBatch fb = new FunnelGoalBatch(goalDateValue,false,false);        
            Database.executeBatch(fb);
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Creating Goals');
            ApexPages.addMessage(myMsg);
            
            timerOnS();
        }
        catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        }
    }

 //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToCertification(){
        
        //return FunnelNavigationHelper.navigateToCertification(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        return FunnelNavigationHelper.navigateToCertification(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToDashboard(){
        
        //return FunnelNavigationHelper.navigateToDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        return FunnelNavigationHelper.navigateToDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    //Method called on clicking Performance Dashboard on header
    public PageReference navigateToCalculator(){
        
        return FunnelNavigationHelper.navigateToCalculator(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    //Method called on clicking Home on header    
    public PageReference navigateToHomePage(){
        
        return FunnelNavigationHelper.navigateToHomePage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    //Method called on clicking Reporting on header    
    public PageReference navigateToReportsPage(){
        
        //return FunnelNavigationHelper.navigateToReportsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        return FunnelNavigationHelper.navigateToReportsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    //Method called on clicking App Setup on header    
    public PageReference navigateToAppSetup(){
        
        return FunnelNavigationHelper.navigateToAppSetupPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToCertificateReports(){
        
        return FunnelNavigationHelper.navigateToCertificateReports(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }  
    
    public PageReference navigateToRatings(){
        
        return FunnelNavigationHelper.navigateToCreateEditRatings(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToAssignRole(){
        
        return FunnelNavigationHelper.navigateToAssignRole(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);    
        
    }
    public PageReference navigateToCustomMetric(){
        
        return FunnelNavigationHelper.navigateToCustomMetric(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);    
        
    }
    
    public PageReference navigateToCategories(){
        
        return FunnelNavigationHelper.navigateToCategories(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    }
    
    public PageReference navigateToAnalytics(){
        
        return FunnelNavigationHelper.navigateToAnalytics(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    public PageReference navigateToFunnelAnalyticQualitative(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    } 
    
    public PageReference navigateToSalesPipeline(){
        
        return FunnelNavigationHelper.navigateToSalesPipeline(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    public PageReference navigateToTrendingByRep(){
        
        return FunnelNavigationHelper.navigateToTrendingByRep(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToTrendingBySkill(){
        
        return FunnelNavigationHelper.navigateToTrendingBySkill(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToFunnelAnalytic(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalytic(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        return FunnelNavigationHelper.navigateToFunnelAnalytic(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    public PageReference navigateToNotifications(){
        
        return FunnelNavigationHelper.navigateToNotifications(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    }
    public PageReference navigateToAnnualizationDashboard(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    public PageReference navigateToFunnelEvaluationGuidelines(){
        
        return FunnelNavigationHelper.navigateToFunnelEvaluationGuidelines(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
     }
     
     public PageReference navigateToFunnelReviewGoals(){
        
        return FunnelNavigationHelper.navigateToFunnelReviewGoals(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    public PageReference navigateToFunnelManagerUpdate(){
        
        return FunnelNavigationHelper.navigateToFunnelManagerUpdate(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    public PageReference navigateToFunnelAddEditSRP(){
        
        return FunnelNavigationHelper.navigateToFunnelAddEditSrp(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    public PageReference navigateToFunnelSetup(){
        
        return FunnelNavigationHelper.navigateToFunnelSetup(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    public PageReference navigateToGoals(){
        
        return FunnelNavigationHelper.navigateToGoalsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    //Added for Help Menu - Rohit
    public PageReference navigateToHelpMenu(){
        
        return FunnelNavigationHelper.navigateToHelpMenu();
    
    }
    /*Navigation*/
    
 
}