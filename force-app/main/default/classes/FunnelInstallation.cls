/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelInstallation{

    public FunnelInstallation(FunnelCertificationDetailv1 controller) {

    }

    
    public Help_page__c help{get;set;}
    public Boolean displayPopup {get;set;}
    public String popClose{get;set;}
    
     

    public FunnelInstallation(FunnelCalculator controller) {
        populateVars();
        fetchhelp('Funnel Calculator');
    }


    public FunnelInstallation(FunnelAddEditRole controller) {
        populateVars();
    }


    public FunnelInstallation(FunnelAddEditCompanyLevel controller) {
        populateVars();
    }


    public FunnelInstallation(FunnelAddEditSrp controller) {
        populateVars();
    }


    public FunnelInstallation(FunnelUpdateRatings_Controller controller) {
        populateVars();
    }


    public FunnelInstallation(FunnelRepStatusUpdateController controller) {
        populateVars();
    }


    public FunnelInstallation(FunnelScorecard controller) {
        populateVars();
        fetchhelp('Score Card');
    }
    
    //added by abhay
    public FunnelInstallation(FunnelScorecard1 controller) {
        populateVars();
        fetchhelp('Funnelocity Sales Pipeline');
    }
    public FunnelInstallation(SalesScorecardController controller) {
        populateVars();
        fetchhelp('Funnelocity Analytics');
    }
        
    public FunnelInstallation(qualitativeAnalysisController controller) {
        populateVars();
        fetchhelp('Score Card');
    }

    public FunnelInstallation(FunnelCertificationDetail controller) {
        populateVars();
    }


    public FunnelInstallation(FunnelCertificationUpdate controller) {
        populateVars();
    }


    public FunnelInstallation(FunnelRoleGroupingController controller) {
        populateVars();
    }


    public FunnelInstallation(FunnelNotificationController controller) {
        populateVars();
    }


    public FunnelInstallation(FunnelSetupController controller) {
        populateVars();
    }


    public FunnelInstallation(FunnelManagerUpdate_Controller controller) {
        populateVars();
    }


    public FunnelInstallation(FunnelReviewGoals_Controller controller) {
        populateVars();
    }


    public FunnelInstallation(FunnelEvaluationGuidelinesController controller) {
        populateVars();
    }


    public FunnelInstallation(FunnelAssignRoleController controller) {
        populateVars();
    }


    public FunnelInstallation(FunnelCertificationRatingCustom controller) {
        populateVars();
    }


    public FunnelInstallation(FunnelAnalyticQualitativeController controller) {
        populateVars();
    }
    
    public FunnelInstallation(FunnelAnalyticScreenController controller) {
        populateVars();
    }
    
    //for U8117
    public FunnelInstallation(FunnelTrendingByRepController controller) {
        populateVars();
        fetchhelp('Trending by Rep Dashboard');
    }
    
    public FunnelInstallation(FunnelTrendingBySkillController controller) {
        populateVars();
        fetchhelp('Trending by Metric/Skill  Dashboard');
    }


    public FunnelInstallation(FunnelAnalyticController controller) {
        populateVars();
        fetchhelp('Funnelocity Quantitative Scoring');
    }


    public FunnelInstallation(FunnelAnnualizationDashboardController controller) {
        populateVars();
        fetchhelp('Tenured and New Hire Dashboard');
    }


    public FunnelInstallation(FunnelReporting_Controller controller) {
        populateVars();
        fetchhelp('Sales Management Reports');
         
    }


    public FunnelInstallation(FunnelCertificationReportsController controller) {
        populateVars();
        fetchhelp('Funnelocity Reports');
    }

    /*public FunnelInstallation(FunnelCertificationReportsControllerQu controller) {
        populateVars();
    }*/
    
    public FunnelInstallation(FunnelCertificationTable controller) {
        populateVars();
        fetchhelp('Funnelocity Scoring');
              
    }


    public FunnelInstallation(FunnelSalesDashboard_Controller controller) {
        populateVars();
        fetchhelp('Performance Dashboard');
    }


    public FunnelInstallation(FunnelCertificationRating_Controller controller) {
        populateVars();
    }


    public String getUpdateMetadata() {
        return null;
    }


    //public String defaultBreadCrumb { get; set; }

    public PageReference navigateToAppSetupTab() {
        return FunnelNavigationHelper.navigateToAppSetupPage('','','','','','');
    }


    public PageReference navigateToFunnelAnalyticQualitativeTab() {
        //return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative('','','','','','');
        return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative('','','','','','','');
    }


    public PageReference navigateToFunnelAnalyticTab() {
        //return FunnelNavigationHelper.navigateToFunnelAnalytic('','','','','','');
                return FunnelNavigationHelper.navigateToFunnelAnalytic('','','','','','','');
    }


    public PageReference navigateToAnnualizationDashboardTab() {
        //return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard('','','','','','');
                return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard('','','','','','','');
    }


    public PageReference navigateToReportsPageTab() {
        //return FunnelNavigationHelper.navigateToReportsPage('','','','','','');
                return FunnelNavigationHelper.navigateToReportsPage('','','','','','','');
    }


    public PageReference navigateToCertificateReportsTab() {
        return FunnelNavigationHelper.navigateToCertificateReports('','','','','','');

    }


    public PageReference navigateToDashboardTab() {
        //return FunnelNavigationHelper.navigateToDashboard('','','','','','');
                return FunnelNavigationHelper.navigateToDashboard('','','','','','','');
    }


    


   
    
    
     public PageReference navigateToHomePageTab() {
        return FunnelNavigationHelper.navigateToHomePage('','','','','','');

    }
    
     
    public PageReference navigateToCertificationTab() {
        //return FunnelNavigationHelper.navigateToCertification('','','','','','');
        return FunnelNavigationHelper.navigateToCertification('','','','','','','');
    }
    
    public PageReference navigateToTrendingByRep(){
        
        return FunnelNavigationHelper.navigateToTrendingByRep('','','','','','');
        
    }
    
    public PageReference navigateToTrendingBySkill(){
        
        return FunnelNavigationHelper.navigateToTrendingBySkill('','','','','','');
        
    }
    
    public PageReference navigateToChecklistPage() {
        return FunnelNavigationHelper.navigateToChecklistPage();

    }
    
    public PageReference navigateToFunnelReviewGoals(){
        
        return FunnelNavigationHelper.navigateToFunnelReviewGoals('','','','','','');
    
    }
    
    public PageReference navigateToFunnelSetup(){
        
        return FunnelNavigationHelper.navigateToFunnelSetup('','','','','','');
    
    }
    
    public PageReference navigateToFunnelAddEditSRP(){
        
        return FunnelNavigationHelper.navigateToFunnelAddEditSrp('','','','','','');
    
    }
    
    public PageReference navigateToAppSetup(){
            
        return FunnelNavigationHelper.navigateToAppSetupPage('','','','','','');
         
    }
        
    public Boolean admin {get;set;}

    public Boolean isManager {get;set;}
    
    public Boolean adminUser {get;set;}
    
    public Boolean wizardComp {get;set;}
    public Boolean displayMetricCalculator {get;set;}
    

    public Boolean checkListComp {get;set;}
    
    public String appsetup {get;set;}
    
    public List<Installation_status__mdt> md {get; set;}
    public List<Installation_status__mdt> md2 {get; set;}
    
    public String updateLabel {get; set;}

    public Boolean updateVal {get; set;}
    
    public Installation_status__mdt  mdWix {get; set;}

    public Installation_status__mdt  od {get; set;}
    
    public FunnelInstallation(){
    
         
        String pageName = ApexPages.currentPage().getUrl().substringAfter('/apex/').substringBefore('?');
       
        System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
       System.debug('pageName '+pageName );
        if(pageName.containsIgnoreCase('FunnelInstallationChecklist')){
        System.debug('pageName '+pageName );
             populateVars();
             populateList();
         }
       
        System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
         
                 
    }
    
    public void fetchhelp(String pageName){
        List<Help_page__c > hList = FunnelHelpPageHelper.fetchHelpPage(pageName);
        if(hList != null && hList.size()>0){
            help =hList[0];
        }
    }
    
    public void populateVars(){
    
        displayPopup = false; 
        help = new Help_page__c(); // Added for helppage

        admin = false;
        
        wizardComp = false;
        displayMetricCalculator = false;
         
        Id profileId=userinfo.getProfileId();
        
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
        if (profileName == 'System Administrator'){
            admin = true;
        }
        //Add admin = true if user have Appsetup and updateSrpupdate permission
        else{
            
            List<AggregateResult> lst = [SELECT count(Id) c FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND (PermissionSet.Name = 'FunnelSalesProfileUpdateAccess' OR PermissionSet.Name = 'Funnel_App_Setup')];

            if(lst != null && lst.size() > 0 && (Integer)lst[0].get('c') > 0 ){
                admin = true;
            }
        
        }
        
        List<Module__mdt> moMdt = [SELECT MasterLabel, Display__c FROM Module__mdt WHERE MasterLabel = 'Metric Calculator']; 
        
        if (moMdt != null && moMdt .size() > 0 && moMdt [0].Display__c ){
            displayMetricCalculator = true;
        }
        
        List<Installation_status__mdt> mdtLst = [SELECT MasterLabel, Completed__c FROM Installation_status__mdt WHERE MasterLabel = 'Complete installation wizard']; 
        
        if (mdtLst != null && mdtLst.size() > 0 && mdtLst[0].Completed__c){
            wizardComp = true;
        }
        
        mdtLst = [SELECT MasterLabel, Completed__c FROM Installation_status__mdt WHERE MasterLabel = 'Hide Checklist']; 
        
        if (mdtLst != null && mdtLst.size() > 0 && mdtLst[0].Completed__c){
            checkListComp = true;
        }    
        
        List<AggregateResult> asperm = [SELECT count(Id) c FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = 'Funnel_App_Setup'];
        if((asperm != null && asperm.size() > 0 && asperm[0].get('c') != null && (Integer)asperm[0].get('c') > 0)   ){
            adminUser = true;
        }else{
            adminUser = false;
        }
        
        isManager = FunnelTriggerBatchHelper.isManager(UserInfo.getUserId());
        if((asperm != null && asperm.size() > 0 && asperm[0].get('c') != null && (Integer)asperm[0].get('c') > 0) || isManager  ){
            appsetup ='';
        }else{
            appsetup ='none';
        }
    }
    
    public void populateList(){

        md = [SELECT MasterLabel, Description__c, Details__c, Completed__c, Updated_date_time__c, Order__c, Updated_by__c FROM Installation_status__mdt WHERE MasterLabel != 'Hide Checklist' AND  MasterLabel != 'Complete installation wizard' AND MasterLabel != 'Obtain customer deliverables' AND Order__c < 8 ORDER By Order__c ASC]; 
        md2 = [SELECT MasterLabel, Description__c, Details__c, Completed__c, Updated_date_time__c, Order__c, Updated_by__c FROM Installation_status__mdt WHERE MasterLabel != 'Hide Checklist' AND  MasterLabel != 'Complete installation wizard' AND MasterLabel != 'Obtain customer deliverables' AND Order__c > 8  ORDER By Order__c ASC]; 
        
        mdWix = [SELECT MasterLabel, Description__c, Details__c, Completed__c, Updated_date_time__c, Order__c, Updated_by__c FROM Installation_status__mdt WHERE MasterLabel = 'Complete installation wizard']; 

        od = [SELECT MasterLabel, Description__c, Details__c, Completed__c, Updated_date_time__c, Order__c, Updated_by__c FROM Installation_status__mdt WHERE MasterLabel = 'Obtain customer deliverables']; 
        
        system.debug(' list '+md);
    
    }
    
    public void updateMetadata(){
    
        List<Installation_status__mdt> mdtLst = [SELECT MasterLabel, DeveloperName, Completed__c, Updated_date_time__c, Updated_by__c FROM Installation_status__mdt WHERE MasterLabel = :updateLabel]; 
        
        if(mdtLst != null && mdtLst.size() > 0){

            mdtLst[0].Completed__c = !updateVal;
            if(mdtLst[0].Completed__c){
                mdtLst[0].Updated_by__c = UserInfo.getName(); 
                mdtLst[0].Updated_date_time__c = System.now();
                
                Map<String, Object> maptest = new Map<String, Object>();
                maptest.put('FunnelMetrics__Updated_by__c',UserInfo.getName());
                maptest.put('FunnelMetrics__Updated_date_time__c',System.now());
                maptest.put('FunnelMetrics__Completed__c',true);
                    
                if(!test.isRunningTest())                    
                    FMCreateUpdateMetadataUtils.createUpdateMetadata('FunnelMetrics__Installation_status.FunnelMetrics__'+mdtLst[0].DeveloperName,updateLabel,maptest);
            }
            else{
                mdtLst[0].Updated_by__c = ''; 
                mdtLst[0].Updated_date_time__c = null;
                system.debug(' nullified ');
                Map<String, Object> maptest = new Map<String, Object>();
                maptest.put('FunnelMetrics__Updated_by__c','');
                maptest.put('FunnelMetrics__Updated_date_time__c',null);
                maptest.put('FunnelMetrics__Completed__c',false);
                
                if(!test.isRunningTest())
                    FMCreateUpdateMetadataUtils.createUpdateMetadata('FunnelMetrics__Installation_status.FunnelMetrics__'+mdtLst[0].DeveloperName,updateLabel,maptest);
            }
            //String jobId2 = MetaDataUtility.upsertMetadata(mdtLst[0]);
        }
    }    
    
    public PageReference checkAndNavigate(){        
           
        PageReference redirect = null;
                
        List<Installation_status__mdt> mdtLst = [SELECT Completed__c FROM Installation_status__mdt  WHERE MasterLabel = 'Hide checklist'];         
        
            if(mdtLst != null && mdtLst.size() > 0 && mdtLst[0].Completed__c){
            
                redirect = new PageReference('/apex/FunnelHomePage'); 
                
            }
                     
        return redirect;
         
    }  
    
    public PageReference hideChecklist(){        
           
        PageReference redirect = null;
                
        List<Installation_status__mdt> md = [SELECT MasterLabel, Description__c, Details__c, Completed__c, Updated_date_time__c, Updated_by__c FROM Installation_status__mdt WHERE MasterLabel != 'Hide Checklist']; 
       
        for(Installation_status__mdt m:md){
        
            if(!m.Completed__c){
                String msg = 'You have not completed all items in the checklist.';                      
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,msg);
                ApexPages.addMessage(myMsg);
                return redirect; 
                
            }
            
        }
        
        List<Installation_status__mdt> mdtLst = [SELECT MasterLabel, DeveloperName, Completed__c, Updated_date_time__c, Updated_by__c FROM Installation_status__mdt WHERE MasterLabel = 'Hide Checklist']; 
        mdtLst[0].Completed__c = true;
        mdtLst[0].Updated_by__c = UserInfo.getName(); 
        mdtLst[0].Updated_date_time__c = System.now();
        
        
        Map<String, Object> maptest = new Map<String, Object>();
        maptest.put('FunnelMetrics__Updated_by__c',UserInfo.getName());
        maptest.put('FunnelMetrics__Updated_date_time__c',System.now());
        maptest.put('FunnelMetrics__Completed__c',true);
        if (!test.isRunningTest())
        FMCreateUpdateMetadataUtils.createUpdateMetadata('FunnelMetrics__Installation_status.FunnelMetrics__'+mdtLst[0].DeveloperName,'Hide Checklist',maptest);
            
        //String jobId2 = MetaDataUtility.upsertMetadata(mdtLst[0]);
        
        redirect = new PageReference('/apex/FunnelHomePage');            
        return redirect;
         
    } 
    
    
    public PageReference navigateToIntro(){  
    
        return FunnelInstallationHelper.navigateToIntroFromWiz();
    }
    public PageReference navigateToGoals(){
        
        return FunnelNavigationHelper.navigateToGoalsPage('','','','','','');
    
    }
    
    //Added for Help Menu - Rohit
    public PageReference navigateToHelpMenu(){
        
        return FunnelNavigationHelper.navigateToHelpMenu();
    
    }
    
    public void popup(){
    
        if(popClose == 'pop'){
            displayPopup = true;
        }else if(popClose == 'close'){
            displayPopup = false;
        }
     
    }    
        
}