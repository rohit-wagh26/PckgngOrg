/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelScorecard1{
    //added by abhay
    Transient public date fromDate{set;get;}
    Transient public date todate{set;get;}
    Transient public string dashboardname{set;get;}
    public string selectedType{set;get;}
    MAP<Id, String> OppMap = new MAP<Id, String>();
    Transient MAP<Id, String> OppMap1 = new MAP<Id, String>();
    MAP<Id, Integer> OppMap11 = new MAP<Id, Integer>();
    Transient MAP<Id, String> OppMap2= new MAP<Id, String>();
    Transient MAP<Id, String> OppMap3 = new MAP<Id, String>();
    Transient MAP<Id, String> OppMap4 = new MAP<Id, String>();
    Transient MAP<Id, String> OppMap5 = new MAP<Id, String>();
    Transient List<Opportunity> opplist1 = new List<Opportunity>();
    Transient List<String> opplist2 = new List<String>();
    Transient List<Integer> opplist3 = new List<Integer>();
    list<Opportunity> listaggregate = new list<Opportunity>();
    Transient List<OpportunityTrackingHistory__c> oplisttracking = new List<OpportunityTrackingHistory__c>();
    List<Funnel_Opp_Stage_Order__mdt> orderMetadata = new List<Funnel_Opp_Stage_Order__mdt>();
    
    
    Transient public static String prefix{ get{return 'FunnelMetrics__';} set; }
    
    
    Transient public Boolean LeadUsed  {get;set;}
    Transient public Boolean MeetingUsed  {get;set;} 
    
    
    Sales_Rep_Profile__c srpcal = new Sales_Rep_Profile__c();
    Transient List<AggregateResult> srpteam = new list<AggregateResult>();
   	public string username ;
    public Sales_Rep_Profile__c srp{get;set;}
    Transient public Id srpid{get;set;}
    
    
    Transient public String curentPipeline{get;set;}
    Transient public String activeopp{get;set;}
    Transient public String ytdWin{get;set;}
    Transient public String winNeedToMakeQuota{get;set;}
    
    
    public string salesRepName{get;set;}
    
    /* Filters */    
    public FunnelFilterWrapper fw {get; set;}
    
    //Variable that indicates if logged in user is a manager
   	private Boolean mgr;
    
    public Boolean isMgr{
        get{
            return mgr;
        }
        set{
            mgr = value;
        }
    }
    
    //Variable that indicates reset button has been clicked
    public boolean isReset {get; set;}
    
    //Variables to store the parameters passed in the URL
    private String label1;
    private String label2;
    private String label3;
    private String selectedLevel1;
    private String selectedLevel2;
    private String selectedLevel3;
    private String selectedLevel4;
    
    public String defaultBreadCrumb{get; set;}
    public String crumValue{get;set;}
    public String levelValue{get;set;}
    /* Filters */
    
    Transient private String roleVal;
    Transient private List<Certification_rating__c> ratingRecs;
    Transient private Set<id> ratings;
    Transient private List<Important_Rating__c> rats = new List<Important_Rating__c>();
    Transient private List<Certification_rating__c> ratingRecsQual;
    Transient private Set<id> ratingsQual;
    Transient private List<Important_Rating__c> ratsQual = new List<Important_Rating__c>();
    public String sname{get;set;}
    
    private FunnelSalesProfileWrapper displayWrapperValue = new FunnelSalesProfileWrapper();
    
    public FunnelSalesProfileWrapper displayWrapper{
        
        get{
            return displayWrapperValue;
        }
        set{
            displayWrapperValue = value;
        }
    }
    
    
    
    public Boolean RoleOverlay{get;set;}
    public Boolean RepOverlay{get;set;}
     
    Boolean readAccess;
   
    
    public FunnelScorecard1(){
        try{ 
            
            selectedType = 'OppCountByStage';
            List<Sales_rep_profile_snapshot__c> snap = [Select id from Sales_rep_profile_snapshot__c Limit 1]; 
            system.debug('snap :: '+snap);
            if(snap != null && snap .size()>0){
                
                List<Application_Setting__c> aps = [Select Leads_used__c,Meetings_used__c From Application_Setting__c Limit 1];
                if(aps != null && aps.size() > 0){
                    LeadUsed = aps[0].Leads_used__c;
                    MeetingUsed = aps[0].Meetings_used__c ;
                    
                }
                
                readAccess = true;
                
                List<String> fldList1 = new List<String>{prefix+'User_Record_name__c',prefix+'name',prefix+'Annual_Quota_Amount__c',prefix+'Sales_Manager__c',prefix+'YTD_Revenue__c',prefix+'YTD_Average_Sales_Cycle__c',prefix+'X12_Month_Rolling_Opptys_Won__c',prefix+'YTD_Opportunity_Close_Rate__c',prefix+'X12_Month_QO_added__c',prefix+'YTD_Lead_Conversion_rate__c',prefix+'YTD_Average_win_size__c',prefix+'User_Record_Name__c',prefix+'X12_Month_Leads_Added__c',prefix+'Goal_12m_Avg_Selling_Price__c',prefix+'Goal_12m_Lead_To_Opp_Conv_Rate__c',prefix+'Goal_12m_length_of_sales_cycle__c',prefix+'Goal_12m_rolling_close_rate__c',prefix+'Monthly_QO_added__c',prefix+'Quarterly_QO_added__c',prefix+'Ytd_QO_added__c',prefix+'Monthly_Lead_Added__c',prefix+'Quarterly_Lead_Added__c',prefix+'YTD_Leads_Added__c',prefix+'Monthly_Quota_Revenue__c',prefix+'Quarterly_Quota_Revenue__c'};                    
                    
                    Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile__c').getDescribe().fields.getMap();
                
                for(String fldName: fldList1){
                    
                    if(!fieldMap1.get(fldName).getDescribe().isAccessible()){
                        system.debug(' fldName '+fldName);
                        readAccess = false;
                    }                           
                }
                
                List<String> fldList2 = new List<String>{prefix+'Overall_Rating__c'};                    
                    
                    Map <String, Schema.SObjectField> fieldMap2 = Schema.getGlobalDescribe().get(prefix+'Certification__c').getDescribe().fields.getMap();
                
                for(String fldName: fldList2){
                    if(!fieldMap2.get(fldName).getDescribe().isAccessible()){
                        system.debug(' fldName '+fldName);
                        readAccess = false;
                    }                           
                }
                
                List<String> fldList3 = new List<String>{prefix+'Sales_Rep_Profile__c',prefix+'Level_Value__c',prefix+'Level_Name__c'};
                    
                    Map <String, Schema.SObjectField> fieldMap3 = Schema.getGlobalDescribe().get(prefix+'Company_Level__c').getDescribe().fields.getMap();
                
                for(String fldName: fldList3){
                    
                    if(!fieldMap3.get(fldName).getDescribe().isAccessible()){
                        system.debug(' fldName '+fldName);
                        readAccess = false;
                    }                           
                }
                
                List<String> fldList4 = new List<String>{prefix+'Sales_Rep_Profile__c',prefix+'Company_Level__c'};
                    
                    Map <String, Schema.SObjectField> fieldMap4 = Schema.getGlobalDescribe().get(prefix+'Sales_Profile_Company_Level_Junction__c').getDescribe().fields.getMap();
                
                for(String fldName: fldList4){
                    
                    if(!fieldMap4.get(fldName).getDescribe().isAccessible()){
                        system.debug(' fldName '+fldName);
                        readAccess = false;
                    }                           
                } 
                if(readAccess){
                    
                    
                    
                    /*filters*/
                    label1 = ApexPages.currentPage().getParameters().get('labelOne');
                    label2 = ApexPages.currentPage().getParameters().get('labelTwo');
                    label3 = ApexPages.currentPage().getParameters().get('labelThree');
                    selectedLevel1 = ApexPages.currentPage().getParameters().get('selectOne');
                    selectedLevel2 = ApexPages.currentPage().getParameters().get('selectTwo');
                    selectedLevel3 = ApexPages.currentPage().getParameters().get('selectThree');
                    selectedLevel4 = ApexPages.currentPage().getParameters().get('selectFour');                    
                    System.debug('selectedLevel4=='+selectedLevel4);
                    fw = new FunnelFilterWrapper();
                    
                    fw.userId = UserInfo.getUserId();
                    
                    FunnelFilterHelper.populateFilters(fw, 
                                                       label1, label2, label3,
                                                       selectedLevel1, selectedLevel2, selectedLevel3);
                    
                    
                    
                    fw.labelFour = 'Filter By Representative';
                    fw.levelFour = FunnelFilterHelper.populateLevelFour(fw,'');
                    system.debug('in constructor :: '+fw.levelFour);
                    System.debug('line 250:::'+fw);
                    /*filters*/
                    
                    
                    if(selectedLevel4 != null && selectedLevel4 != '' && selectedLevel4 != 'ALL'){
                        fw.SelectedLevelFour  = selectedLevel4;
                    }
                    if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All' && fw.selectedLevelTwo != null && fw.selectedLevelTwo != '' && fw.selectedLevelTwo != 'null'){
                        fw.selectedLevelTwo = 'All';
                        fw.disableLevelThree = false;
                    }
                    
                    username = UserInfo.getUserId();
                    
                    system.debug('readaccess before showupdate :: '+readAccess);
                    //showUpdated();
                    
                    
                    defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw); 
                    
                    system.debug('fw.selectedLevelFour :: '+fw.selectedLevelFour);
                    system.debug('fw.levelFour :: '+fw.levelFour);
                    system.debug(' defaultBreadCrumb '+defaultBreadCrumb);
                    
                }
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());                
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelScorecard '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
        
        
    }
    
    
    /*Filters*/
    //Method called when reset button is selected
    public PageReference reset(){
        
        
        return FunnelNavigationHelper.navigateToCalculator('','','','','',''); 
        
    }
    /*Filters*/ 
    
    
    
    //Action method when level one is changed
    public void levelOneAction(){
        if(readAccess){
            try{
                FunnelFilterHelper.levelOneAction(fw);
                fw.SelectedLevelFour='All';
                defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw); 
            }
            catch(Exception ex){
                System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
                FunnelTriggerBatchHelper.sendErrorMail(' FunnelScorecard '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            }
        } 
    }
    
    //Action method when level two is changed
    public void levelTwoAction(){
        if(readAccess){
            try{
                FunnelFilterHelper.levelTwoAction(fw);
                fw.SelectedLevelFour='All';
                defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw);
            }
            catch(Exception ex){
                System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
                FunnelTriggerBatchHelper.sendErrorMail(' FunnelScorecard '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            } 
        }
    }
    
    /*Navigation*/
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToCertification(){
        
        //return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToDashboard(){
        
        //return FunnelNavigationHelper.navigateToDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    //Method called on clicking Performance Dashboard on header
    public PageReference navigateToCalculator(){
        
        return FunnelNavigationHelper.navigateToCalculator(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    //Method called on clicking Home on header    
    public PageReference navigateToHomePage(){
        
        return FunnelNavigationHelper.navigateToHomePage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
        
    }
    
    //Method called on clicking Reporting on header    
    public PageReference navigateToReportsPage(){
        
        //return FunnelNavigationHelper.navigateToReportsPage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToReportsPage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
        
    }
    
    //Method called on clicking App Setup on header    
    public PageReference navigateToAppSetup(){
        
        return FunnelNavigationHelper.navigateToAppSetupPage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToCertificateReports(){
        
        return FunnelNavigationHelper.navigateToCertificateReports(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    } 
    
    public PageReference navigateToAnalytics(){
        
        return FunnelNavigationHelper.navigateToAnalytics(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    } 
    
    public PageReference navigateToFunnelAnalyticQualitative(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToTrendingByRep(){
        
        return FunnelNavigationHelper.navigateToTrendingByRep(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToTrendingBySkill(){
        
        return FunnelNavigationHelper.navigateToTrendingBySkill(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToFunnelAnalytic(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    public PageReference navigateToAnnualizationDashboard(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToFunnelReviewGoals(){
        
        return FunnelNavigationHelper.navigateToFunnelReviewGoals(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToFunnelSetup(){
        
        return FunnelNavigationHelper.navigateToFunnelSetup(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToFunnelAddEditSRP(){
        
        return FunnelNavigationHelper.navigateToFunnelAddEditSrp(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToGoals(){
        
        return FunnelNavigationHelper.navigateToGoalsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    //Added for Help Menu - Rohit
    public PageReference navigateToHelpMenu(){
        
        return FunnelNavigationHelper.navigateToHelpMenu();
        
    }
    
    /*Navigation*/
       
    
    public void breadCrumClick(){
        
        fw = new FunnelFilterWrapper();
        fw.labelFour = 'Filter By Representative';
        FunnelFilterHelper.onclickpopulateFilters(crumValue,fw);
    } 
    
    
    
    /* Gap tabel methods*/
    
    Decimal highPerfScore;
    Decimal lowPerfScore;
    
    Decimal highPerfScoreQual;
    Decimal lowPerfScoreQual;
    
    public class tableWrapper implements Comparable{
        public id metricId {get; set;}
        public Integer rank {get; set;}
        public Decimal rankingScore {get; set;}
        public String metricName {get; set;}
        public Decimal imporCoeff {get; set;}
        public Decimal teamScore {get; set;}
        public Decimal lowPerfScore {get; set;}
        public Decimal avgPerfScore {get; set;}
        public Decimal highPerfScore {get; set;}
        public Decimal gap {get; set;} 
        
        
        public Integer compareTo(Object objToCompare) {
            System.debug('line1716:::'+rankingScore);
            
            if(rankingScore != null && objToCompare != null){
                if(rankingScore > ((tableWrapper)objToCompare).rankingScore){
                    return -1;
                }
                if(rankingScore == ((tableWrapper)objToCompare).rankingScore){
                    return 0;
                }
                return 1;
            }
            return 0;
        }
    }
    
    
    private List<id> metricIds = new List<id>();
    private List<id> metricIdsQual = new List<id>();
    
    public List<tableWrapper> tableVals {get; set;}
    public List<tableWrapper> tableValsQual {get; set;} 
    
    Map<String, tableWrapper> metricRowMap = new Map<String, tableWrapper>(); 
    Map<String, tableWrapper> metricRowMapQual = new Map<String, tableWrapper>(); 
    
    //List to store all sales profiles in the selected level
    List<id> profs = new List<id>();
    
    
    Map<Id,Important_Rating__c> certMap = new Map<Id,Important_Rating__c>();
    Map<Id,Important_Rating__c> certMapQual = new Map<Id,Important_Rating__c>();
    
    
    /*Table methods*/      
    
    /*Display of CM */ 
    public class CustomMetricWrapper{
        public   String fieldLable{get;set;}
        public   String name{get;set;}
        public   String fieldApiName{get;set;}
        public   String fieldDes{get;set;}
        public   Decimal fieldValue{get;set;}
        public   Decimal fieldGoal{get;set;}
        public   String ratingType{get;set;}
    }
    public List<CustomMetricWrapper> CustomMetricWrapperList{get;set;}
    /*Display of CM */    
    public String selectedId {get; set;}
    public PageReference navigateToDetailPage(){        
        
        PageReference redirect;
        
        if(fw.labelOne != null && fw.labelOne != '')
            redirect = new PageReference('/apex/FunnelCerificationDetail?id='+selectedId+'&labelOne='+fw.labelOne+'&labelTwo='+fw.labelTwo+'&labelThree='+fw.labelThree+'&selectOne='+fw.selectedLevelOne+'&selectTwo='+fw.selectedLevelTwo+'&selectThree='+fw.selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelCerificationDetail?id='+selectedId); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }     
    
    public PageReference checkAndNavigateHome(){        
        
        PageReference redirect = null;
        
        List<Installation_status__mdt> mdtLst = [SELECT Completed__c FROM Installation_status__mdt  WHERE MasterLabel = 'Complete installation wizard'];         
        
        Date todayDate = Date.today();
        Date snapDate = Date.newinstance(todayDate.year(), todayDate.month(), 1);
        snapDate =  snapDate.addDays(-3);
        
        List<Sales_rep_profile_snapshot__c> snap = [Select id from Sales_rep_profile_snapshot__c where Snapshot_Scheduled_Date__c > :snapDate]; 
        Boolean hisPresnt = false;
        if(snap != null && snap.size()>0 ){
            hisPresnt = true;
        }
        
        if(mdtLst != null && mdtLst.size() > 0 && !mdtLst[0].Completed__c && !hisPresnt){
            
            mdtLst = [SELECT Completed__c FROM Installation_status__mdt  WHERE MasterLabel = 'Hide Checklist'];
            
            if(mdtLst != null && mdtLst.size() > 0 && !mdtLst[0].Completed__c){
                
                redirect = new PageReference('/apex/FunnelInstallationChecklist'); 
            }
        }
        
        return redirect;      
        
    }  
    public Static Date getFiscalYearDate(String recName){
    
        Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues(recName);
        
        if(fy != null)
            return fy.Start_Date__c;
        else
            return null;
    }
    
    public List<Data> getData() {
        List<Data> data = new List<Data>();
        system.debug('listaggregate');
        integer data365 = 0;
        integer data365to200 = 0;
        integer data200to120 = 0;
        integer data120to60 = 0;
        integer data160 = 0;
        integer Qualdata365 = 0;
        integer Qualdata365to200 = 0;
        integer Qualdata200to120 = 0;
        integer Qualdata120to60 = 0;
        integer Qualdata160 = 0;
        Decimal data365_1;
        Decimal data365to200_1;
        Decimal data200to120_1;
        Decimal data120to60_1;
        Decimal data160_1;
        Decimal Qualdata365_1;
        Decimal Qualdata365to200_1;
        Decimal Qualdata200to120_1;
        Decimal Qualdata120to60_1;
        Decimal Qualdata160_1;
        Sales_Rep_Profile__c salesrep;
        if(fw.selectedLevelFour != 'All'){
            salesrep = [select id,User_Record_Name__c from Sales_Rep_Profile__c where id = : fw.selectedLevelFour];
        }
        List<Sales_Profile_Company_Level_Junction__c> cmpnyLvl = new List<Sales_Profile_Company_Level_Junction__c>();
        List<String> username = new List<String>();
        List<String> srp1 = new List<String>();
        List<Sales_Rep_Profile__c> srp = new List<Sales_Rep_Profile__c>();
        if(fw.selectedLevelThree == 'All' && fw.selectedLevelFour == 'All'){
            cmpnyLvl = [select Sales_Rep_Profile__c, Company_Level__r.Level_Value__c from Sales_Profile_Company_Level_Junction__c where Company_Level__r.Level_Value__c = :fw.SelectedLevelOne];
            for(Sales_Profile_Company_Level_Junction__c c: cmpnyLvl){
                srp1.add(c.Sales_Rep_Profile__c);
            }
            srp = [select id,User_Record_Name__c from Sales_Rep_Profile__c where id IN : srp1];
            for(Sales_Rep_Profile__c s :srp){
                username.add(s.User_Record_Name__c);
            }
        }else if(fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
            cmpnyLvl = [select Sales_Rep_Profile__c, Company_Level__r.Level_Value__c from Sales_Profile_Company_Level_Junction__c where Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c =: fw.selectedLevelThree];
            for(Sales_Profile_Company_Level_Junction__c c: cmpnyLvl){
                srp1.add(c.Sales_Rep_Profile__c);
            }
            srp = [select id,User_Record_Name__c from Sales_Rep_Profile__c where id IN : srp1];
            for(Sales_Rep_Profile__c s :srp){
                username.add(s.User_Record_Name__c);
            }
        }
        Date currentFiscalYear = getFiscalYearDate('Current_Year');
        system.debug('username :: '+username);
        system.debug('currentFiscalYear ' +currentFiscalYear);
        orderMetadata = [Select Id, Stage_Name__c, Stage_Order__c From Funnel_Opp_Stage_Order__mdt Order by Stage_Order__c];
        system.debug('orderMetadata :: '+orderMetadata);
        if(orderMetadata.size()>0){
            for(Funnel_Opp_Stage_Order__mdt so : orderMetadata){
                system.debug('Stage_Name__c1 :: '+ so.Stage_Name__c);
                data365 = 0;
                data365to200 = 0;
                data200to120 = 0;
                data120to60 = 0;
                data160 = 0;    
                data365_1 = null;
                data365to200_1 = null;
                data200to120_1 = null;
                data120to60_1 = null;
                data160_1 = null; 
                OppMap.clear();
                OppMap11.clear();
                if(fw.selectedLevelFour == 'All'){
                    listaggregate = [Select id, name, stagename,amount,CloseDate from Opportunity where ForecastCategoryName != 'Omitted' And stagename = : so.Stage_Name__c AND OwnerId IN: username];
                }else{
                    listaggregate = [Select id, name, stagename,amount,CloseDate from Opportunity where ForecastCategoryName != 'Omitted' And stagename = : so.Stage_Name__c AND OwnerId =: salesrep.User_Record_Name__c];
                }
                //listaggregate = [Select id, stagename, Amount from Opportunity where stagename = 'Prospecting'];
                system.debug('listaggregate' +listaggregate.size());
                if(listaggregate.size() > 0){
                    for(Opportunity o :listaggregate){
                        system.debug('listaggregate1 :: '+ o.stagename);
                        system.debug('stageName :: '+ o.CloseDate);
                        if(o.stagename.Contains('Close')){
                            if(o.CloseDate >= currentFiscalYear){ 
                                system.debug('inside if');
                                OppMap.put(o.Id,o.stagename);
                                OppMap11.put(o.Id,(Integer)o.amount);
                            }
                        }else{
                            system.debug('inside else');
                            OppMap.put(o.Id,o.stagename);
                            OppMap11.put(o.Id,(Integer)o.amount);
                        }
                    }
                    system.debug('OppMap11' +OppMap11);
                    system.debug('OppMap' +OppMap);
                    system.debug('mapsize :: '+ OppMap.size());
                    oplisttracking = [Select Id, OwnerId, Opportunity__c, Opportunity__r.name, IsDeleted, Name, Opportunity_Age__c, OldValue__c, NewValue__c from OpportunityTrackingHistory__c where opportunity__c IN : OppMap.keyset()];
                    system.debug('oplisttracking' + oplisttracking.size());
                    if(oplisttracking.size() > 0){
                        for(OpportunityTrackingHistory__c c : oplisttracking){
                            system.debug('Opportunity__r.name :: '+ c.Opportunity__r.name);
                            if(c.Name == 'Stage' && c.NewValue__c == OppMap.get(c.Opportunity__c) && OppMap.containsKey(c.Opportunity__c)){
                                system.debug('trak :: '+c);
                                if(selectedType == 'OppCountByStage'){
                                    dashboardname = 'Number of Opportunities';
                                    //opplist3.add((Integer)c.Opportunity_Age__c); 
                                    if((Integer)c.Opportunity_Age__c > 365){
                                        data365 = data365+1;
                                    }else if((Integer)c.Opportunity_Age__c < 365 && (Integer)c.Opportunity_Age__c > 200){
                                        data365to200 = data365to200+1;
                                    }else if((Integer)c.Opportunity_Age__c < 200 && (Integer)c.Opportunity_Age__c > 120){
                                        data200to120 = data200to120+1;
                                    }else if((Integer)c.Opportunity_Age__c < 120 && (Integer)c.Opportunity_Age__c > 60){
                                        data120to60 = data120to60+1;
                                    }else if((Integer)c.Opportunity_Age__c < 60){
                                        data160 = data160+1;
                                    }           
                                }else{
                                    dashboardname = 'Expected Value of Opportunities';
                                    if((Integer)c.Opportunity_Age__c > 365 && OppMap11.get(c.Opportunity__c) != null){
                                        data365 = data365+OppMap11.get(c.Opportunity__c);
                                    }else if((Integer)c.Opportunity_Age__c < 365 && (Integer)c.Opportunity_Age__c > 200 && OppMap11.get(c.Opportunity__c) != null){
                                        data365to200 = data365to200+OppMap11.get(c.Opportunity__c);
                                    }else if((Integer)c.Opportunity_Age__c < 200 && (Integer)c.Opportunity_Age__c > 120 && OppMap11.get(c.Opportunity__c) != null){
                                        data200to120 = data200to120+OppMap11.get(c.Opportunity__c);
                                    }else if((Integer)c.Opportunity_Age__c < 120 && (Integer)c.Opportunity_Age__c > 60 && OppMap11.get(c.Opportunity__c) != null){
                                        data120to60 = data120to60+OppMap11.get(c.Opportunity__c);
                                    }else if((Integer)c.Opportunity_Age__c < 60 && OppMap11.get(c.Opportunity__c) != null){
                                        data160 = data160+OppMap11.get(c.Opportunity__c);
                                    }
                                }
                            }
                        }
                        // system.debug('sum of ' + (Integer.valueof(data160)+Integer.valueof(data120to60)+Integer.valueof(data200to120)+Integer.valueof(data365to200)+Integer.valueof(data365)));
                        if(selectedType == 'OppCountByStage'){
                            //data.add(new Data('Prospecting/Target', (Integer.valueof(data160)+Integer.valueof(data120to60)+Integer.valueof(data200to120)+Integer.valueof(data365to200)+Integer.valueof(data365))));
                            data.add(new Data(so.Stage_Name__c, data160, data120to60, data200to120,data365to200,data365));
                        }else{
                            data365_1 = Decimal.valueof(data365);
                            data120to60_1 = Decimal.valueof(data120to60);
                            data200to120_1 = Decimal.valueof(data200to120);
                            data365to200_1 = Decimal.valueof(data365to200);
                            data160_1 = Decimal.valueof(data160);
                            //data.add(new Data('Prospecting/Target',I.valueOf(data160_1+data120to60_1+data200to120_1+data365to200_1+data365_1)));
                            data.add(new Data(so.Stage_Name__c, data160_1, data120to60_1, data200to120_1,data365to200_1,data365_1)); 
                        }
                    }else{
                        if(selectedType == 'OppCountByStage'){
                            data.add(new Data(so.Stage_Name__c, 0,0,0,0,0));
                        }else{
                            data.add(new Data(so.Stage_Name__c, 0.00,0.00,0.00,0.00,0.00)); 
                        }
                    }
                }else{
                    if(selectedType == 'OppCountByStage'){
                        data.add(new Data(so.Stage_Name__c, 0,0,0,0,0));
                    }else{
                        data.add(new Data(so.Stage_Name__c, 0.00,0.00,0.00,0.00,0.00)); 
                    } 
                }
            }
        }
        /*if(fw.selectedLevelFour == 'All'){
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename = 'Prospecting'];
        }else{
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename = 'Prospecting' AND OwnerId =: salesrep.User_Record_Name__c];
        }
        //listaggregate = [Select id, stagename, Amount from Opportunity where stagename = 'Prospecting'];
        system.debug('listaggregate' +listaggregate);
        if(listaggregate.size() > 0){
            for(Opportunity o :listaggregate){
                OppMap.put(o.Id,o.stagename);
                OppMap11.put(o.Id,(Integer)o.amount);
            }
            system.debug('OppMap11' +OppMap11);
            system.debug('OppMap' +OppMap);
            oplisttracking = [Select Id, OwnerId, Opportunity__c, IsDeleted, Name, Opportunity_Age__c, OldValue__c, NewValue__c from OpportunityTrackingHistory__c where opportunity__c IN : OppMap.keyset()];
            system.debug('oplisttracking' + oplisttracking.size());
            if(oplisttracking.size() > 0){
                for(OpportunityTrackingHistory__c c : oplisttracking){
                    if(c.Name == 'Stage' && c.NewValue__c == OppMap.get(c.Opportunity__c) && OppMap.containsKey(c.Opportunity__c)){
                        if(selectedType == 'OppCountByStage'){
                            dashboardname = 'Number of Opportunities';
                            //opplist3.add((Integer)c.Opportunity_Age__c); 
                            if((Integer)c.Opportunity_Age__c > 365){
                                data365 = data365+1;
                            }else if((Integer)c.Opportunity_Age__c < 365 && (Integer)c.Opportunity_Age__c > 200){
                                data365to200 = data365to200+1;
                            }else if((Integer)c.Opportunity_Age__c < 200 && (Integer)c.Opportunity_Age__c > 120){
                                data200to120 = data200to120+1;
                            }else if((Integer)c.Opportunity_Age__c < 120 && (Integer)c.Opportunity_Age__c > 60){
                                data120to60 = data120to60+1;
                            }else if((Integer)c.Opportunity_Age__c < 60){
                                data160 = data160+1;
                            }           
                        }else{
                            dashboardname = 'Expected Value of Opportunities';
                            if((Integer)c.Opportunity_Age__c > 365 && OppMap11.get(c.Opportunity__c) != null){
                                data365 = data365+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 365 && (Integer)c.Opportunity_Age__c > 200 && OppMap11.get(c.Opportunity__c) != null){
                                data365to200 = data365to200+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 200 && (Integer)c.Opportunity_Age__c > 120 && OppMap11.get(c.Opportunity__c) != null){
                                data200to120 = data200to120+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 120 && (Integer)c.Opportunity_Age__c > 60 && OppMap11.get(c.Opportunity__c) != null){
                                data120to60 = data120to60+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 60 && OppMap11.get(c.Opportunity__c) != null){
                                data160 = data160+OppMap11.get(c.Opportunity__c);
                            }
                        }
                    }
                }
                // system.debug('sum of ' + (Integer.valueof(data160)+Integer.valueof(data120to60)+Integer.valueof(data200to120)+Integer.valueof(data365to200)+Integer.valueof(data365)));
                if(selectedType == 'OppCountByStage'){
                    //data.add(new Data('Prospecting/Target', (Integer.valueof(data160)+Integer.valueof(data120to60)+Integer.valueof(data200to120)+Integer.valueof(data365to200)+Integer.valueof(data365))));
                    data.add(new Data('Prospecting/Target', data160, data120to60, data200to120,data365to200,data365));
                }else{
                    data365_1 = Decimal.valueof(data365).divide(1000000, 2);
                    data120to60_1 = Decimal.valueof(data120to60).divide(1000000, 2);
                    data200to120_1 = Decimal.valueof(data200to120).divide(1000000, 2);
                    data365to200_1 = Decimal.valueof(data365to200).divide(1000000, 2);
                    data160_1 = Decimal.valueof(data160).divide(1000000, 2);
                    //data.add(new Data('Prospecting/Target',I.valueOf(data160_1+data120to60_1+data200to120_1+data365to200_1+data365_1)));
                    data.add(new Data('Prospecting/Target', data160_1, data120to60_1, data200to120_1,data365to200_1,data365_1)); 
                }
            }else{
                if(selectedType == 'OppCountByStage'){
                    data.add(new Data('Prospecting/Target', 0,0,0,0,0));
                }else{
                    data.add(new Data('Prospecting/Target', 0.00,0.00,0.00,0.00,0.00)); 
                }
            }
        }else{
            if(selectedType == 'OppCountByStage'){
                data.add(new Data('Prospecting/Target', 0,0,0,0,0));
            }else{
                data.add(new Data('Prospecting/Target', 0.00,0.00,0.00,0.00,0.00)); 
            } 
        }
        system.debug('data365' +data365);
        if(fw.selectedLevelFour == 'All'){
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Qualification','Needs Analysis')];
        }else{
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Qualification','Needs Analysis') AND OwnerId =: salesrep.User_Record_Name__c];
        }
        if(listaggregate.size() > 0){
            OppMap1.clear();
            OppMap11.clear();
            for(Opportunity o :listaggregate){
                OppMap1.put(o.Id,o.stagename);
                OppMap11.put(o.Id,(Integer)o.amount);
            }
            oplisttracking = [Select Id, OwnerId, Opportunity__c, IsDeleted, Name, Opportunity_Age__c, OldValue__c, NewValue__c from OpportunityTrackingHistory__c where opportunity__c IN: OppMap1.keyset()];
            if(oplisttracking.size() > 0){
                for(OpportunityTrackingHistory__c c : oplisttracking){
                    if(c.Name == 'Stage' && c.NewValue__c == OppMap1.get(c.Opportunity__c) && OppMap1.containsKey(c.Opportunity__c)){
                        if(selectedType == 'OppCountByStage'){
                            if((Integer)c.Opportunity_Age__c > 365){
                                Qualdata365 = Qualdata365+1;
                            }else if((Integer)c.Opportunity_Age__c < 365 && (Integer)c.Opportunity_Age__c > 200){
                                Qualdata365to200 = Qualdata365to200+1;
                            }else if((Integer)c.Opportunity_Age__c < 200 && (Integer)c.Opportunity_Age__c > 120){
                                Qualdata200to120 = Qualdata200to120+1;
                            }else if((Integer)c.Opportunity_Age__c < 120 && (Integer)c.Opportunity_Age__c > 60){
                                Qualdata120to60 = Qualdata120to60+1;
                            }else if((Integer)c.Opportunity_Age__c < 60){
                                Qualdata160 = Qualdata160+1;
                            }
                        }else{
                            if((Integer)c.Opportunity_Age__c > 365 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata365 = Qualdata365+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 365 && (Integer)c.Opportunity_Age__c > 200 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata365to200 = Qualdata365to200+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 200 && (Integer)c.Opportunity_Age__c > 120 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata200to120 = Qualdata200to120+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 120 && (Integer)c.Opportunity_Age__c > 60 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata120to60 = Qualdata120to60+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 60 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata160 = Qualdata160+OppMap11.get(c.Opportunity__c);
                            }
                        }
                    }
                }
                if(selectedType == 'OppCountByStage'){
                    data.add(new Data('Qualify/Needs Analysis', Qualdata160, Qualdata120to60, Qualdata200to120,Qualdata365to200,Qualdata365));
                }else{
                    Qualdata365_1 = Decimal.valueof(Qualdata365).divide(1000000, 2);
                    Qualdata120to60_1 = Decimal.valueof(Qualdata120to60).divide(1000000, 2);
                    Qualdata200to120_1 = Decimal.valueof(Qualdata200to120).divide(1000000, 2);
                    Qualdata365to200_1 = Decimal.valueof(Qualdata365to200).divide(1000000, 2);
                    Qualdata160_1 = Decimal.valueof(Qualdata160).divide(1000000, 2);
                    data.add(new Data('Qualify/Needs Analysis', Qualdata160_1, Qualdata120to60_1, Qualdata200to120_1,Qualdata365to200_1,Qualdata365_1)); 
                }
            }else{
                if(selectedType == 'OppCountByStage'){
                    data.add(new Data('Qualify/Needs Analysis', 0,0,0,0,0));
                }else{
                    data.add(new Data('Qualify/Needs Analysis', 0.00,0.00,0.00,0.00,0.00)); 
                } 
            }
        }else{
            if(selectedType == 'OppCountByStage'){
                data.add(new Data('Qualify/Needs Analysis', 0,0,0,0,0));
            }else{
                data.add(new Data('Qualify/Needs Analysis', 0.00,0.00,0.00,0.00,0.00)); 
            } 
        }
        
        if(fw.selectedLevelFour == 'All'){
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Proposal/Price Quote')];
        }else{
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Proposal/Price Quote') AND OwnerId =: salesrep.User_Record_Name__c];
        }
        if(listaggregate.size() > 0){
            OppMap1.clear();
            OppMap11.clear();
            for(Opportunity o :listaggregate){
                OppMap1.put(o.Id,o.stagename);
                OppMap11.put(o.Id,(Integer)o.amount);
            }
            Qualdata365 = 0;
            Qualdata365to200 = 0;
            Qualdata200to120 = 0;
            Qualdata120to60 = 0;
            Qualdata160 = 0;    
            Qualdata365_1 = null;
            Qualdata365to200_1 = null;
            Qualdata200to120_1 = null;
            Qualdata120to60_1 = null;
            Qualdata160_1 = null;  
            oplisttracking = [Select Id, OwnerId, Opportunity__c, IsDeleted, Name, Opportunity_Age__c, OldValue__c, NewValue__c from OpportunityTrackingHistory__c where opportunity__c IN: OppMap1.keyset()];
            if(oplisttracking.size() > 0){
                for(OpportunityTrackingHistory__c c : oplisttracking){
                    if(c.Name == 'Stage' && c.NewValue__c == OppMap1.get(c.Opportunity__c) && OppMap1.containsKey(c.Opportunity__c)){
                        if(selectedType == 'OppCountByStage'){
                            if((Integer)c.Opportunity_Age__c > 365){
                                Qualdata365 = Qualdata365+1;
                            }else if((Integer)c.Opportunity_Age__c < 365 && (Integer)c.Opportunity_Age__c > 200){
                                Qualdata365to200 = Qualdata365to200+1;
                            }else if((Integer)c.Opportunity_Age__c < 200 && (Integer)c.Opportunity_Age__c > 120){
                                Qualdata200to120 = Qualdata200to120+1;
                            }else if((Integer)c.Opportunity_Age__c < 120 && (Integer)c.Opportunity_Age__c > 60){
                                Qualdata120to60 = Qualdata120to60+1;
                            }else if((Integer)c.Opportunity_Age__c < 60){
                                Qualdata160 = Qualdata160+1;
                            }
                        }else{
                            if((Integer)c.Opportunity_Age__c > 365 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata365 = Qualdata365+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 365 && (Integer)c.Opportunity_Age__c > 200 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata365to200 = Qualdata365to200+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 200 && (Integer)c.Opportunity_Age__c > 120 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata200to120 = Qualdata200to120+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 120 && (Integer)c.Opportunity_Age__c > 60 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata120to60 = Qualdata120to60+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 60 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata160 = Qualdata160+OppMap11.get(c.Opportunity__c);
                            }
                        }
                    }
                }
                if(selectedType == 'OppCountByStage'){
                    data.add(new Data('Under Proposal', Qualdata160, Qualdata120to60, Qualdata200to120,Qualdata365to200,Qualdata365));
                }else{
                    Qualdata365_1 = Decimal.valueof(Qualdata365).divide(1000000, 2);
                    Qualdata120to60_1 = Decimal.valueof(Qualdata120to60).divide(1000000, 2);
                    Qualdata200to120_1 = Decimal.valueof(Qualdata200to120).divide(1000000, 2);
                    Qualdata365to200_1 = Decimal.valueof(Qualdata365to200).divide(1000000, 2);
                    Qualdata160_1 = Decimal.valueof(Qualdata160).divide(1000000, 2);
                    data.add(new Data('Under Proposal', Qualdata160_1, Qualdata120to60_1, Qualdata200to120_1,Qualdata365to200_1,Qualdata365_1)); 
                }
            }else{
                if(selectedType == 'OppCountByStage'){
                    data.add(new Data('Under Proposal', 0,0,0,0,0));
                }else{
                    data.add(new Data('Under Proposal', 0.00,0.00,0.00,0.00,0.00)); 
                } 
            }
        }else{
            if(selectedType == 'OppCountByStage'){
                data.add(new Data('Under Proposal', 0,0,0,0,0));
            }else{
                data.add(new Data('Under Proposal', 0.00,0.00,0.00,0.00,0.00)); 
            } 
        }
        if(fw.selectedLevelFour == 'All'){
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Negotiation/Review')];
        }else{
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Negotiation/Review') AND OwnerId =: salesrep.User_Record_Name__c];
        }
        if(listaggregate.size() > 0){
            OppMap1.clear();
            OppMap11.clear();
            for(Opportunity o :listaggregate){
                OppMap1.put(o.Id,o.stagename);
                OppMap11.put(o.Id,(Integer)o.amount);
            }
            Qualdata365 = 0;
            Qualdata365to200 = 0;
            Qualdata200to120 = 0;
            Qualdata120to60 = 0;
            Qualdata160 = 0;    
            Qualdata365_1 = null;
            Qualdata365to200_1 = null;
            Qualdata200to120_1 = null;
            Qualdata120to60_1 = null;
            Qualdata160_1 = null;   
            oplisttracking = [Select Id, OwnerId, Opportunity__c, IsDeleted, Name, Opportunity_Age__c, OldValue__c, NewValue__c from OpportunityTrackingHistory__c where opportunity__c IN: OppMap1.keyset()];
            if(oplisttracking.size() > 0){
                for(OpportunityTrackingHistory__c c : oplisttracking){
                    if(c.Name == 'Stage' && c.NewValue__c == OppMap1.get(c.Opportunity__c) && OppMap1.containsKey(c.Opportunity__c)){
                        if(selectedType == 'OppCountByStage'){
                            if((Integer)c.Opportunity_Age__c > 365){
                                Qualdata365 = Qualdata365+1;
                            }else if((Integer)c.Opportunity_Age__c < 365 && (Integer)c.Opportunity_Age__c > 200){
                                Qualdata365to200 = Qualdata365to200+1;
                            }else if((Integer)c.Opportunity_Age__c < 200 && (Integer)c.Opportunity_Age__c > 120){
                                Qualdata200to120 = Qualdata200to120+1;
                            }else if((Integer)c.Opportunity_Age__c < 120 && (Integer)c.Opportunity_Age__c > 60){
                                Qualdata120to60 = Qualdata120to60+1;
                            }else if((Integer)c.Opportunity_Age__c < 60){
                                Qualdata160 = Qualdata160+1;
                            }
                        }else{
                            if((Integer)c.Opportunity_Age__c > 365 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata365 = Qualdata365+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 365 && (Integer)c.Opportunity_Age__c > 200 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata365to200 = Qualdata365to200+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 200 && (Integer)c.Opportunity_Age__c > 120 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata200to120 = Qualdata200to120+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 120 && (Integer)c.Opportunity_Age__c > 60 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata120to60 = Qualdata120to60+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 60 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata160 = Qualdata160+OppMap11.get(c.Opportunity__c);
                            }
                        }
                    }
                }
                if(selectedType == 'OppCountByStage'){
                    data.add(new Data('Negotiation/Review', Qualdata160, Qualdata120to60, Qualdata200to120,Qualdata365to200,Qualdata365));
                }else{
                    Qualdata365_1 = Decimal.valueof(Qualdata365).divide(1000000, 2);
                    Qualdata120to60_1 = Decimal.valueof(Qualdata120to60).divide(1000000, 2);
                    Qualdata200to120_1 = Decimal.valueof(Qualdata200to120).divide(1000000, 2);
                    Qualdata365to200_1 = Decimal.valueof(Qualdata365to200).divide(1000000, 2);
                    Qualdata160_1 = Decimal.valueof(Qualdata160).divide(1000000, 2);
                    data.add(new Data('Negotiation/Review', Qualdata160_1, Qualdata120to60_1, Qualdata200to120_1,Qualdata365to200_1,Qualdata365_1)); 
                }
            }else{
                if(selectedType == 'OppCountByStage'){
                    data.add(new Data('Negotiation/Review', 0,0,0,0,0));
                }else{
                    data.add(new Data('Negotiation/Review', 0.00,0.00,0.00,0.00,0.00)); 
                } 
            }
        }else{
            if(selectedType == 'OppCountByStage'){
                data.add(new Data('Negotiation/Review', 0,0,0,0,0));
            }else{
                data.add(new Data('Negotiation/Review', 0.00,0.00,0.00,0.00,0.00)); 
            } 
        }
        if(fw.selectedLevelFour == 'All'){
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Closed Won')];
        }else{
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Closed Won') AND OwnerId =: salesrep.User_Record_Name__c];
        }
        if(listaggregate.size() > 0){
            OppMap1.clear();
            OppMap11.clear();
            for(Opportunity o :listaggregate){
                OppMap1.put(o.Id,o.stagename);
                OppMap11.put(o.Id,(Integer)o.amount);
            }
            Qualdata365 = 0;
            Qualdata365to200 = 0;
            Qualdata200to120 = 0;
            Qualdata120to60 = 0;
            Qualdata160 = 0;    
            Qualdata365_1 = null;
            Qualdata365to200_1 = null;
            Qualdata200to120_1 = null;
            Qualdata120to60_1 = null;
            Qualdata160_1 = null;   
            oplisttracking = [Select Id, OwnerId, Opportunity__c, IsDeleted, Name, Opportunity_Age__c, OldValue__c, NewValue__c from OpportunityTrackingHistory__c where opportunity__c IN: OppMap1.keyset()];
            if(oplisttracking.size() > 0){
                for(OpportunityTrackingHistory__c c : oplisttracking){
                    if(c.Name == 'Stage' && c.NewValue__c == OppMap1.get(c.Opportunity__c) && OppMap1.containsKey(c.Opportunity__c)){
                        if(selectedType == 'OppCountByStage'){
                            if((Integer)c.Opportunity_Age__c > 365){
                                Qualdata365 = Qualdata365+1;
                            }else if((Integer)c.Opportunity_Age__c < 365 && (Integer)c.Opportunity_Age__c > 200){
                                Qualdata365to200 = Qualdata365to200+1;
                            }else if((Integer)c.Opportunity_Age__c < 200 && (Integer)c.Opportunity_Age__c > 120){
                                Qualdata200to120 = Qualdata200to120+1;
                            }else if((Integer)c.Opportunity_Age__c < 120 && (Integer)c.Opportunity_Age__c > 60){
                                Qualdata120to60 = Qualdata120to60+1;
                            }else if((Integer)c.Opportunity_Age__c < 60){
                                Qualdata160 = Qualdata160+1;
                            }
                        }else{
                            if((Integer)c.Opportunity_Age__c > 365 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata365 = Qualdata365+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 365 && (Integer)c.Opportunity_Age__c > 200 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata365to200 = Qualdata365to200+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 200 && (Integer)c.Opportunity_Age__c > 120 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata200to120 = Qualdata200to120+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 120 && (Integer)c.Opportunity_Age__c > 60 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata120to60 = Qualdata120to60+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 60 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata160 = Qualdata160+OppMap11.get(c.Opportunity__c);
                            }
                        }
                    }
                }
                if(selectedType == 'OppCountByStage'){
                    data.add(new Data('Closed Won', Qualdata160, Qualdata120to60, Qualdata200to120,Qualdata365to200,Qualdata365));
                }else{
                    Qualdata365_1 = Decimal.valueof(Qualdata365).divide(1000000, 2);
                    Qualdata120to60_1 = Decimal.valueof(Qualdata120to60).divide(1000000, 2);
                    Qualdata200to120_1 = Decimal.valueof(Qualdata200to120).divide(1000000, 2);
                    Qualdata365to200_1 = Decimal.valueof(Qualdata365to200).divide(1000000, 2);
                    Qualdata160_1 = Decimal.valueof(Qualdata160).divide(1000000, 2);
                    data.add(new Data('Closed Won', Qualdata160_1, Qualdata120to60_1, Qualdata200to120_1,Qualdata365to200_1,Qualdata365_1)); 
                }
            }else{
                if(selectedType == 'OppCountByStage'){
                    data.add(new Data('Closed Won', 0,0,0,0,0));
                }else{
                    data.add(new Data('Closed Won', 0.00,0.00,0.00,0.00,0.00)); 
                } 
            }
        }else{
            if(selectedType == 'OppCountByStage'){
                data.add(new Data('Closed Won', 0,0,0,0,0));
            }else{
                data.add(new Data('Closed Won', 0.00,0.00,0.00,0.00,0.00)); 
            } 
        }
        if(fw.selectedLevelFour == 'All'){
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Hold')];
        }else{
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Hold') AND OwnerId =: salesrep.User_Record_Name__c];
        }
        if(listaggregate.size() > 0){
            OppMap1.clear();
            OppMap11.clear();
            for(Opportunity o :listaggregate){
                OppMap1.put(o.Id,o.stagename);
                OppMap11.put(o.Id,(Integer)o.amount);
            }
            Qualdata365 = 0;
            Qualdata365to200 = 0;
            Qualdata200to120 = 0;
            Qualdata120to60 = 0;
            Qualdata160 = 0;    
            Qualdata365_1 = null;
            Qualdata365to200_1 = null;
            Qualdata200to120_1 = null;
            Qualdata120to60_1 = null;
            Qualdata160_1 = null;   
            oplisttracking = [Select Id, OwnerId, Opportunity__c, IsDeleted, Name, Opportunity_Age__c, OldValue__c, NewValue__c from OpportunityTrackingHistory__c where opportunity__c IN: OppMap1.keyset()];
            if(oplisttracking.size() > 0){
                for(OpportunityTrackingHistory__c c : oplisttracking){
                    if(c.Name == 'Stage' && c.NewValue__c == OppMap1.get(c.Opportunity__c) && OppMap1.containsKey(c.Opportunity__c)){
                        if(selectedType == 'OppCountByStage'){
                            if((Integer)c.Opportunity_Age__c > 365){
                                Qualdata365 = Qualdata365+1;
                            }else if((Integer)c.Opportunity_Age__c < 365 && (Integer)c.Opportunity_Age__c > 200){
                                Qualdata365to200 = Qualdata365to200+1;
                            }else if((Integer)c.Opportunity_Age__c < 200 && (Integer)c.Opportunity_Age__c > 120){
                                Qualdata200to120 = Qualdata200to120+1;
                            }else if((Integer)c.Opportunity_Age__c < 120 && (Integer)c.Opportunity_Age__c > 60){
                                Qualdata120to60 = Qualdata120to60+1;
                            }else if((Integer)c.Opportunity_Age__c < 60){
                                Qualdata160 = Qualdata160+1;
                            }
                        }else{
                            if((Integer)c.Opportunity_Age__c > 365 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata365 = Qualdata365+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 365 && (Integer)c.Opportunity_Age__c > 200 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata365to200 = Qualdata365to200+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 200 && (Integer)c.Opportunity_Age__c > 120 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata200to120 = Qualdata200to120+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 120 && (Integer)c.Opportunity_Age__c > 60 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata120to60 = Qualdata120to60+OppMap11.get(c.Opportunity__c);
                            }else if((Integer)c.Opportunity_Age__c < 60 && OppMap11.get(c.Opportunity__c) != null){
                                Qualdata160 = Qualdata160+OppMap11.get(c.Opportunity__c);
                            }
                        }
                    }
                }
                if(selectedType == 'OppCountByStage'){
                    data.add(new Data('Hold', Qualdata160, Qualdata120to60, Qualdata200to120,Qualdata365to200,Qualdata365));
                }else{
                    Qualdata365_1 = Decimal.valueof(Qualdata365).divide(1000000, 2);
                    Qualdata120to60_1 = Decimal.valueof(Qualdata120to60).divide(1000000, 2);
                    Qualdata200to120_1 = Decimal.valueof(Qualdata200to120).divide(1000000, 2);
                    Qualdata365to200_1 = Decimal.valueof(Qualdata365to200).divide(1000000, 2);
                    Qualdata160_1 = Decimal.valueof(Qualdata160).divide(1000000, 2);
                    data.add(new Data('Hold', Qualdata160_1, Qualdata120to60_1, Qualdata200to120_1,Qualdata365to200_1,Qualdata365_1)); 
                }
            }else{
                if(selectedType == 'OppCountByStage'){
                    data.add(new Data('Hold', 0,0,0,0,0));
                }else{
                    data.add(new Data('Hold', 0.00,0.00,0.00,0.00,0.00)); 
                } 
            }
        }else{
            if(selectedType == 'OppCountByStage'){
                data.add(new Data('Hold', 0,0,0,0,0));
            }else{
                data.add(new Data('Hold', 0.00,0.00,0.00,0.00,0.00)); 
            } 
        }*/
        return data;
        
    }
    
    public List<Data> getOpportunityCount() {
        List<Data> data = new List<Data>();
        integer data365 = 0;
        integer data365to200 = 0;
        integer data200to120 = 0;
        integer data120to60 = 0;
        integer data160 = 0;
        integer Qualdata365 = 0;
        integer Qualdata365to200 = 0;
        integer Qualdata200to120 = 0;
        integer Qualdata120to60 = 0;
        integer Qualdata160 = 0;
        Sales_Rep_Profile__c salesrep;
        Date currentFiscalYear = getFiscalYearDate('Current_Year');
        orderMetadata = [Select Id, Stage_Name__c, Stage_Order__c From Funnel_Opp_Stage_Order__mdt Order by Stage_Order__c desc];
        system.debug('fw.selectedLevelFour :: '+fw.selectedLevelFour);
        if(fw.selectedLevelFour != 'All' && fw.selectedLevelFour != null && fw.selectedLevelFour != ''){
            salesrep = [select id,User_Record_Name__c from Sales_Rep_Profile__c where id = : fw.selectedLevelFour];
        }
        List<Sales_Profile_Company_Level_Junction__c> cmpnyLvl = new List<Sales_Profile_Company_Level_Junction__c>();
        List<String> username = new List<String>();
        List<String> srp1 = new List<String>();
        List<Sales_Rep_Profile__c> srp = new List<Sales_Rep_Profile__c>();
        if(fw.selectedLevelThree == 'All' && fw.selectedLevelFour == 'All'){
            cmpnyLvl = [select Sales_Rep_Profile__c, Company_Level__r.Level_Value__c from Sales_Profile_Company_Level_Junction__c where Company_Level__r.Level_Value__c = :fw.SelectedLevelOne];
            for(Sales_Profile_Company_Level_Junction__c c: cmpnyLvl){
                srp1.add(c.Sales_Rep_Profile__c);
            }
            srp = [select id,User_Record_Name__c from Sales_Rep_Profile__c where id IN : srp1];
            for(Sales_Rep_Profile__c s :srp){
                username.add(s.User_Record_Name__c);
            }
        }else if(fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
            cmpnyLvl = [select Sales_Rep_Profile__c, Company_Level__r.Level_Value__c from Sales_Profile_Company_Level_Junction__c where Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c =: fw.selectedLevelThree];
            for(Sales_Profile_Company_Level_Junction__c c: cmpnyLvl){
                srp1.add(c.Sales_Rep_Profile__c);
            }
            srp = [select id,User_Record_Name__c from Sales_Rep_Profile__c where id IN : srp1];
            for(Sales_Rep_Profile__c s :srp){
                username.add(s.User_Record_Name__c);
            }
        }
        List<Opportunity> oppList = new List<Opportunity>();
        if(orderMetadata.size()>0){
            for(Funnel_Opp_Stage_Order__mdt so : orderMetadata){
                
                
                If(listaggregate.size() !=0){
                listaggregate.clear();
                }
                if(fw.selectedLevelFour == 'All'){
                    oppList = [Select id, stagename,CloseDate,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename = : so.Stage_Name__c AND OwnerId IN : username];
                }else{
                    System.debug('test inside');
                    oppList = [Select id, stagename,CloseDate,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename = : so.Stage_Name__c AND OwnerId =: salesrep.User_Record_Name__c];
                }
                for(Opportunity o : oppList){
                    if(o.stagename.Contains('Closed')){
                        if(o.CloseDate >= currentFiscalYear){
                            listaggregate.add(o);
                        }
                    }else{
                        listaggregate.add(o);
                    }
                }
                system.debug('listaggregatesize :: '+ listaggregate.size());
                if(selectedType == 'OppCountByStage'){
                    data365 = 0;
                    data.add(new Data(so.Stage_Name__c, listaggregate.size()));
                }else if(selectedType != 'OppCountByStage' && listaggregate.size() > 0){
                    data365 = 0;
                    for(Opportunity o : listaggregate){
                        if((Integer)o.amount != null)
                            data365 = data365+(Integer)o.amount; 
                    }
                    data.add(new Data(so.Stage_Name__c, Decimal.valueof(data365))); 
                }else if(selectedType != 'OppCountByStage' && listaggregate.size() == 0){
                    data.add(new Data(so.Stage_Name__c, 0.00)); 
                }
            }
        }
        /*if(fw.selectedLevelFour == 'All'){
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename = 'Prospecting'];
        }else{
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename = 'Prospecting' AND OwnerId =: salesrep.User_Record_Name__c];
        }
        if(selectedType == 'OppCountByStage'){
            data365 = 0;
            data.add(new Data('Prospecting/Target', listaggregate.size()));
        }else if(selectedType != 'OppCountByStage' && listaggregate.size() > 0){
            data365 = 0;
            for(Opportunity o : listaggregate){
                if((Integer)o.amount != null)
                    data365 = data365+(Integer)o.amount; 
            }
            data.add(new Data('Prospecting/Target', Decimal.valueof(data365).divide(1000000, 2))); 
        }else if(selectedType != 'OppCountByStage' && listaggregate.size() == 0){
            data.add(new Data('Prospecting/Target', 0.00)); 
        }
        if(fw.selectedLevelFour == 'All'){
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Qualification','Needs Analysis')];
        }else{
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Qualification','Needs Analysis') AND OwnerId =: salesrep.User_Record_Name__c];
        }
        if(selectedType == 'OppCountByStage'){
            data365 = 0;
            data.add(new Data('Qualify/Needs Analysis', listaggregate.size()));
        }else if(selectedType != 'OppCountByStage' && listaggregate.size() > 0){
            data365 = 0;
            for(Opportunity o : listaggregate){
                if((Integer)o.amount != null)
                    data365 = data365+(Integer)o.amount; 
            }
            data.add(new Data('Qualify/Needs Analysis', Decimal.valueof(data365).divide(1000000, 2))); 
        }else if(selectedType != 'OppCountByStage' && listaggregate.size() == 0){
            data.add(new Data('Qualify/Needs Analysis', 0.00)); 
        }
        if(fw.selectedLevelFour == 'All'){
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Proposal/Price Quote')];
        }else{
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Proposal/Price Quote') AND OwnerId =: salesrep.User_Record_Name__c];
        }
        if(selectedType == 'OppCountByStage'){
            data365 = 0;
            data.add(new Data('Under Proposal', listaggregate.size()));
        }else if(selectedType != 'OppCountByStage' && listaggregate.size() > 0){
            data365 = 0;
            for(Opportunity o : listaggregate){
                if((Integer)o.amount != null)
                    data365 = data365+(Integer)o.amount; 
            }
            data.add(new Data('Under Proposal', Decimal.valueof(data365).divide(1000000, 2))); 
        }else if(selectedType != 'OppCountByStage' && listaggregate.size() == 0){
            data.add(new Data('Under Proposal', 0.00)); 
        }
        if(fw.selectedLevelFour == 'All'){
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Negotiation/Review')];
        }else{
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Negotiation/Review') AND OwnerId =: salesrep.User_Record_Name__c];
        }
        if(selectedType == 'OppCountByStage'){
            data365 = 0;
            data.add(new Data('Under Negotiation', listaggregate.size()));
        }else if(listaggregate.size() > 0){
            data365 = 0;
            for(Opportunity o : listaggregate){
                if((Integer)o.amount != null)
                    data365 = data365+(Integer)o.amount; 
            }
            data.add(new Data('Under Negotiation', Decimal.valueof(data365).divide(1000000, 2))); 
        }else if(selectedType != 'OppCountByStage' && listaggregate.size() == 0){
            data.add(new Data('Closed Won', 0.00)); 
        }
        if(fw.selectedLevelFour == 'All'){
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Closed Won')];
        }else{
            system.debug('sales rep name ' +fw.selectedLevelFour);
            listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Closed Won') AND OwnerId =: salesrep.User_Record_Name__c];
        }
        if(selectedType == 'OppCountByStage'){
            data365 = 0;
            data.add(new Data('Closed Won', listaggregate.size()));
        }else if(selectedType != 'OppCountByStage' && listaggregate.size() > 0){
            data365 = 0;
            for(Opportunity o : listaggregate){
                if((Integer)o.amount != null)
                    data365 = data365+(Integer)o.amount; 
            }
            data.add(new Data('Closed Won', Decimal.valueof(data365).divide(1000000, 2))); 
        }else if(selectedType != 'OppCountByStage' && listaggregate.size() == 0){
            data.add(new Data('Closed Won', 0.00)); 
        }
        listaggregate = [Select id, stagename,amount from Opportunity where ForecastCategoryName != 'Omitted' And stagename IN ('Hold')];
        if(selectedType == 'OppCountByStage'){
            data365 = 0;
            data.add(new Data('Hold', listaggregate.size()));
        }else if(selectedType != 'OppCountByStage' && listaggregate.size() > 0){
            data365 = 0;
            for(Opportunity o : listaggregate){
                if((Integer)o.amount != null)
                    data365 = data365+(Integer)o.amount; 
            }
            data.add(new Data('Hold', Decimal.valueof(data365).divide(1000000, 2))); 
        }else if(selectedType != 'OppCountByStage' && listaggregate.size() == 0){
            data.add(new Data('Hold', 0.00)); 
        }*/
        
        return data;
        
    }
    
    // Wrapper class
    
    public class Data {
        
        public String name { get; set; }
        
        public Integer data1 { get; set; }
        
        public Integer data2 { get; set; }
        
        public Integer data3 { get; set; }
        public Integer data4 { get; set; }
        public Integer data5 { get; set; }
        public Integer data6 { get; set; }
        
        public String data7 { get; set; }
        
        public String data8 { get; set; }
        
        public String data9 { get; set; }
        public String data10 { get; set; }
        public String data11 { get; set; }
        
        public String data13 { get; set; }         
        public Decimal data12 { get; set; }
        public String dolr {get; set;}
        public String data14 { get; set; }
        public String data15 { get; set; }
        public Decimal data16 { get; set; }
        public Integer data17 { get; set; }
        public Integer data18 { get; set; }
        public Integer data19 { get; set; }
        public Integer data20 { get; set; }
        public Integer data21 { get; set; }
        public Integer data22 { get; set; }
        
        public Data(String name, Integer data1, Integer data2, Integer data3,Integer data4, Integer data5) {
            
            this.name = name;
            
            this.data1 = data1;
            
            this.data2 = data2;
            
            this.data3 = data3;
            this.data4 = data4;
            
            this.data5 = data5;
            this.data6 = data1+data2+data3+data4+data5;
            
            //this.data6 = data6;
            
        }
        public Data(String name, Decimal data7, Decimal data8, Decimal data9,Decimal data10, Decimal data11) {
            
            this.name = name;
            this.dolr = '$';
            
            this.data7 = String.valueOf(data7);
            
            this.data8 = String.valueOf(data8);
            
            this.data9 = String.valueOf(data9);
            this.data10 = String.valueOf(data10);
            this.data11 = String.valueOf(data11);
            
            this.data12 = data7+data8+data9+data10+data11;
            system.debug('this.data12 :: '+this.data12);
            if(this.data12 >= 1000000){
                this.data12 =  Math.round(this.data12/1000000);
                this.data14 = '$'+String.valueOf(this.data12)+'M';
            }else if(this.data12 >= 1000){
                this.data12 = Math.round(this.data12/1000);
                this.data14 = '$'+String.valueOf(this.data12)+'K';
            }else{
                this.data12 = Math.round(this.data12);
                this.data14 = '$'+String.valueOf(this.data12);
            }
            //this.data6 = data6;
            system.debug('data7 :: '+ data7);
            system.debug('data7 :: '+ data8);
            system.debug('data7 :: '+ data9);
            system.debug('data7 :: '+ data10);
            system.debug('data7 :: '+ data11);
            this.data18 = Integer.valueOf(data7);
            this.data19 = Integer.valueOf(data8);
            this.data20 = Integer.valueOf(data9);
            this.data21 = Integer.valueOf(data10);
            this.data22 = Integer.valueOf(data11);
            
        }
        public Data(String name, Integer data1) {
            
            this.name = name;
            
            this.data1 = data1;
            
            this.data17 = 0;
            
            
        }
        public Data(String name, Decimal data13) {
            
            this.name = name;
            this.data16 = data13;
            if(data13 >= 1000000){
                data13 = Math.round(data13/1000000);
                this.data13 = String.valueOf(data13);
                this.data15 = '$'+String.valueOf(data13)+'M';     
            }else if (data13 >= 1000){
                data13 = Math.round(data13/1000);
                this.data13 = String.valueOf(data13);
                this.data15 = '$'+String.valueOf(data13)+'K';  
            }else{
                data13 = Math.round(data13);
                this.data13 = String.valueOf(data13);
                this.data15 = '$'+String.valueOf(data13); 
            }
        }
        
    }
    
    
    
}