public with sharing class FunnelReviewGoals_Controller {

    public FunnelReviewGoals_Controller(FunnelInstallationStep9Controller controller) {
        defaultConstructor();
    }

    
    public List<Yearly_goals_by_Role__c> goalsLst{ get; set;} 
    
    public List<FunnelDisplayWrapper> wrList {get; set;}
    
    public boolean editable {get; set;}
        
    public String recordId{ get; set;} 
    
    public Yearly_goals_by_Role__c goalRec{ get; set;} 
    
    public Application_Setting__c managerUpdate{ get; set;} 
        
    Public boolean applyAll{get;set;}
    Public boolean applyAll12MonthAvgSellingPrice{get;set;}
    Public boolean applyAll12MonthLeadToOpp{get;set;}
    Public boolean applyAll12MonthOppCloserate{get;set;}
    Public boolean applyAll12MonthAmtCloserate{get;set;}
    Public boolean applyAll12MonthSalesCycle{get;set;}
    Public boolean applyAllNumberOFMonthlyMeeting{get;set;}
    Public boolean applyAll12MonthAvgDealSize{get;set;}
    
    Public boolean sp{get;set;}
    Public boolean lc{get;set;}
    Public boolean ocr{get;set;}
    Public boolean acr{get;set;}
    Public boolean alsc{get;set;}
    Public boolean nm{get;set;}
    Public boolean ads{get;set;}
    
    Public String gval{get;set;}
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
    
       
    //Variables to store the parameters passed in the URL
    public String label1{get; set;}
    public String label2{get; set;}
    public String label3{get; set;}
    public String selectedLevel1{get; set;}
    public String selectedLevel2{get; set;}
    public String selectedLevel3{get; set;}
    
    public Boolean adminPer{get;set;}
    public Boolean isManger{get;set;}
    
    public FunnelReviewGoals_Controller (){
       defaultConstructor();
    }
    
    public void defaultConstructor(){
         applyAll12MonthAvgSellingPrice = false ;
        applyAll12MonthLeadToOpp = false ;
        applyAll12MonthOppCloserate = false ;
        applyAll12MonthAmtCloserate = false ;
        applyAll12MonthSalesCycle = false ;
        applyAllNumberOFMonthlyMeeting = false ;
        applyAll12MonthAvgDealSize = false ;
        
        sp = false ;
        lc = false ;
        ocr = false ;
        acr = false ;
        alsc = false ;
        nm = false ;
        ads  = false ;
    
        isManger = FunnelTriggerBatchHelper.isManager(UserInfo.getUserId());
        
        //To fetch the most recent year for which goals have been determined
        List<Yearly_goals_by_Role__c> latestYr = [SELECT Year__c FROM Yearly_goals_by_Role__c ORDER BY Year__c DESC LIMIT 1];
        
        if(latestYr != null && latestYr.size() > 0){
            goalsLst = [SELECT id, Role__c, Year__c, X12_month_avg_selling_price__c, X12_month_rolling_lead_to_opp_conv_rate__c, X12_month_rolling_avg_deal_size__c, X12_month_rolling_opp_close_rate__c, X12_month_rolling_amt_close_rate__c, X12_month_rolling_avg_sales_cycle__c, Number_of_monthly_meetings__c FROM Yearly_goals_by_Role__c WHERE Year__c = :latestYr[0].Year__c];
       
           wrList = new List<FunnelDisplayWrapper>();
        
            for(Yearly_goals_by_Role__c y: goalsLst){
                FunnelDisplayWrapper fw = new FunnelDisplayWrapper();
                fw.recId = y.id;
                fw.role = y.Role__c;
                fw.sellPrice = convert(y.X12_month_avg_selling_price__c);
                fw.convRate = y.X12_month_rolling_lead_to_opp_conv_rate__c;
                fw.closeRate = y.X12_month_rolling_opp_close_rate__c;
                fw.amtCloseRate = y.X12_month_rolling_amt_close_rate__c;
                fw.salesCycle = convert(y.X12_month_rolling_avg_sales_cycle__c);
                fw.monthlyMeetings = convert(y.Number_of_monthly_meetings__c);
                fw.dealSize = convert(y.X12_month_rolling_avg_deal_size__c);
                
                wrList.add(fw);
            }
        }
        
        
        
        managerUpdate = [Select Enable_Manger_Goal_Update__c from Application_Setting__c Limit 1];
        
        editable = false;
        
         /*filters*/
            label1 = ApexPages.currentPage().getParameters().get('labelOne');
            label2 = ApexPages.currentPage().getParameters().get('labelTwo');
            label3 = ApexPages.currentPage().getParameters().get('labelThree');
            selectedLevel1 = ApexPages.currentPage().getParameters().get('selectOne');
            selectedLevel2 = ApexPages.currentPage().getParameters().get('selectTwo');
            selectedLevel3 = ApexPages.currentPage().getParameters().get('selectThree'); 
    }
    
    public void activedeactiveUpate(){
        
        Integer firstMonth =  FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year').Month();
        Integer Month = Date.Today().Month();
        
        if(managerUpdate.Enable_Manger_Goal_Update__c == false){
            managerUpdate.Enable_Manger_Goal_Update__c = true;
            
            if(firstMonth == Month ){
                FunnelTriggerBatchHelper.ManagerUpdateMail();
            }
            
        }else{
            managerUpdate.Enable_Manger_Goal_Update__c = false;
        }
        update managerUpdate ;
        managerUpdate = [Select Enable_Manger_Goal_Update__c from Application_Setting__c Limit 1];
        
    }
    public void onEdit(){
        applyAll12MonthAvgSellingPrice = false ;
        applyAll12MonthLeadToOpp = false ;
        applyAll12MonthOppCloserate = false ;
        applyAll12MonthAmtCloserate = false ;
        applyAll12MonthSalesCycle = false ;
        applyAllNumberOFMonthlyMeeting = false ;
        applyAll12MonthAvgDealSize = false ;
        
        editable = true;
        system.debug(' inside edit ');
        system.debug(' goal rec '+goalRec);
    }
    
    public void displayModal(){
        applyAll12MonthAvgSellingPrice = false ;
        applyAll12MonthLeadToOpp = false ;
        applyAll12MonthOppCloserate = false ;
        applyAll12MonthAmtCloserate = false ;
        applyAll12MonthSalesCycle = false ;
        applyAllNumberOFMonthlyMeeting = false ;
        applyAll12MonthAvgDealSize = false ;
        editable = true;
        system.debug(' inside edit ');
        
        sp = false ;
        lc = false ;
        ocr = false ;
        acr = false ;
        alsc = false ;
        nm = false ;
        ads  = false ;
        
        if(gval == 'sp'){
            sp = true;
        }else if(gval == 'lc'){
            lc = true;
        }else if(gval == 'ocr'){
            ocr = true;
        }else if(gval == 'acr'){
            acr = true;
        }else if(gval == 'alsc'){
            alsc = true;
        }else if(gval == 'nm'){
            nm = true;
        }else if(gval == 'ads'){
            ads = true;
        }
        
        goalRec = [SELECT Role__c, Year__c, X12_month_avg_selling_price__c, X12_month_rolling_lead_to_opp_conv_rate__c, X12_month_rolling_avg_deal_size__c, X12_month_rolling_opp_close_rate__c, X12_month_rolling_amt_close_rate__c, X12_month_rolling_avg_sales_cycle__c, Number_of_monthly_meetings__c FROM Yearly_goals_by_Role__c WHERE id = :recordId];
        system.debug(' goal rec '+goalRec);
    
    }
    
    public void saveUpdate(){
        update goalRec;
         
        List<Sales_Rep_Profile__c> srp = [SELECT Id,Role__c, User_Record_Name__c, Goal_of_monthly_meetings__c,Goal_12m_Avg_Selling_Price__c,Goal_12m_Lead_To_Opp_Conv_Rate__c,Goal_12m_length_of_sales_cycle__c,Goal_12m_rolling_amt_close_rate__c,Goal_12m_rolling_close_rate__c,Goal_Average_Deal_Size__c FROM Sales_Rep_Profile__c Where Active__c = TRUE AND Role__c = :goalRec.Role__c];
        for(Sales_Rep_Profile__c s : srp){
           
           if(((s.Goal_of_monthly_meetings__c != null && s.Goal_of_monthly_meetings__c < goalRec.Number_of_monthly_meetings__c) || applyAllNumberOFMonthlyMeeting) && nm){
               s.Goal_of_monthly_meetings__c = goalRec.Number_of_monthly_meetings__c;
           } 
           
           if(((s.Goal_12m_Avg_Selling_Price__c != null && s.Goal_12m_Avg_Selling_Price__c < goalRec.X12_month_avg_selling_price__c) || applyAll12MonthAvgSellingPrice) && sp){
               s.Goal_12m_Avg_Selling_Price__c = goalRec.X12_month_avg_selling_price__c;
           }  
           
           if(((s.Goal_12m_Lead_To_Opp_Conv_Rate__c != null && s.Goal_12m_Lead_To_Opp_Conv_Rate__c < goalRec.X12_month_rolling_lead_to_opp_conv_rate__c) || applyAll12MonthLeadToOpp) && lc){
               s.Goal_12m_Lead_To_Opp_Conv_Rate__c = goalRec.X12_month_rolling_lead_to_opp_conv_rate__c;
           } 
           
           if(((s.Goal_12m_length_of_sales_cycle__c != null && s.Goal_12m_length_of_sales_cycle__c > goalRec.X12_month_rolling_avg_sales_cycle__c) || applyAll12MonthSalesCycle) && alsc){
               s.Goal_12m_length_of_sales_cycle__c = goalRec.X12_month_rolling_avg_sales_cycle__c;
           } 
           
           if(((s.Goal_12m_rolling_amt_close_rate__c != null && s.Goal_12m_rolling_amt_close_rate__c < goalRec.X12_month_rolling_amt_close_rate__c) || applyAll12MonthAmtCloserate) && acr){
               s.Goal_12m_rolling_amt_close_rate__c = goalRec.X12_month_rolling_amt_close_rate__c;
           } 
           
           if(((s.Goal_12m_rolling_close_rate__c!= null && s.Goal_12m_rolling_close_rate__c < goalRec.X12_month_rolling_opp_close_rate__c) || applyAll12MonthOppCloserate) && ocr){
               s.Goal_12m_rolling_close_rate__c= goalRec.X12_month_rolling_opp_close_rate__c;
           } 
           
           if(((s.Goal_Average_Deal_Size__c != null && s.Goal_Average_Deal_Size__c < goalRec.X12_month_rolling_avg_deal_size__c) || applyAll12MonthAvgDealSize) && ads){
               s.Goal_Average_Deal_Size__c = goalRec.X12_month_rolling_avg_deal_size__c;
           }   
        }
        
        update srp;
         
        
        List<Yearly_goals_by_Role__c> latestYr = [SELECT Year__c FROM Yearly_goals_by_Role__c ORDER BY Year__c DESC LIMIT 1];
        goalsLst = [SELECT Role__c, Year__c, X12_month_avg_selling_price__c, X12_month_rolling_lead_to_opp_conv_rate__c, X12_month_rolling_avg_deal_size__c, X12_month_rolling_opp_close_rate__c, X12_month_rolling_amt_close_rate__c, X12_month_rolling_avg_sales_cycle__c, Number_of_monthly_meetings__c FROM Yearly_goals_by_Role__c WHERE Year__c = :latestYr[0].Year__c];
        
        wrList = new List<FunnelDisplayWrapper>();
        
        for(Yearly_goals_by_Role__c y: goalsLst){
            FunnelDisplayWrapper fw = new FunnelDisplayWrapper();
            fw.recId = y.id;
            fw.role = y.Role__c;
            fw.sellPrice = convert(y.X12_month_avg_selling_price__c);
            fw.convRate = y.X12_month_rolling_lead_to_opp_conv_rate__c;
            fw.closeRate = y.X12_month_rolling_opp_close_rate__c;
            fw.amtCloseRate = y.X12_month_rolling_amt_close_rate__c;
            fw.salesCycle = convert(y.X12_month_rolling_avg_sales_cycle__c);
            fw.monthlyMeetings = convert(y.Number_of_monthly_meetings__c);
            fw.dealSize = convert(y.X12_month_rolling_avg_deal_size__c);
            
            wrList.add(fw);
        }
    }

    public class FunnelDisplayWrapper{
        public id recId{get;set;}
        public String role{get;set;}
        public String sellPrice{get;set;}
        public Decimal convRate{get;set;}
        public Decimal closeRate{get;set;}
        public Decimal amtCloseRate{get;set;}
        public String salesCycle{get;set;}
        public String monthlyMeetings{get;set;}
        public String dealSize{get;set;}          
              
    }

    public String convert (Decimal d){
        List<String> args = new String[]{'0','number','###,###,###,###,###,##0.00'};
        
        if(d != null){
            d = d.setScale(0, RoundingMode.HALF_UP);
            Integer i = d.intValue();
            String s = d.format();
            return s;
        }
        else{
            return '';
        }
    }
    
    
    public PageReference checkThemeAndNavigate(){        
        
        String source = ApexPages.currentPage().getParameters().get('source');
        system.debug(' source '+source);
        system.debug(' UserInfo.getUiThemeDisplayed() '+UserInfo.getUiThemeDisplayed());
        
        User u = [SELECT Name, UserPreferencesLightningExperiencePreferred FROM User WHERE id = :UserInfo.getUserId()];
        
        if(source == 'email' && u.UserPreferencesLightningExperiencePreferred  == true){            
            PageReference p = new PageReference('/one/one.app#/alohaRedirect/apex/FunnelMetrics__FunnelReviewGoals');
            return p;
        }
        else{
            return null;
        }
    }
    /*Navigation*/
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
    
    public PageReference navigateToAssignRole(){
        
        return FunnelNavigationHelper.navigateToAssignRole(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);    
        
    }
    public PageReference navigateToCustomMetric(){
        
        return FunnelNavigationHelper.navigateToCustomMetric(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);    
        
    }
    
    public PageReference navigateToNotifications(){
        
        return FunnelNavigationHelper.navigateToNotifications(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
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
    public PageReference navigateToFunnelEvaluationGuidelines(){
        
        return FunnelNavigationHelper.navigateToFunnelEvaluationGuidelines(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    public PageReference navigateToAnnualizationDashboard(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    public PageReference navigateToFunnelSetup(){
        
        return FunnelNavigationHelper.navigateToFunnelSetup(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    public PageReference navigateToFunnelReviewGoals(){
        
        return FunnelNavigationHelper.navigateToFunnelReviewGoals(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    public PageReference navigateToFunnelManagerUpdate(){
        
        return FunnelNavigationHelper.navigateToFunnelManagerUpdate(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
     
     public PageReference navigateToRatings(){
        
        return FunnelNavigationHelper.navigateToCreateEditRatings(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
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
    
}