public with sharing class FunnelManagerUpdate_Controller {
    
    public List<Id> reps{get; set;}
    
    public Map<Id,Sales_rep_profile__c> repMap {get; set;}
    
    public Map<Id,Sales_rep_profile_snapshot__c> snaps {get; set;}

    public Map<Id,FunnelDisplayWrapper> repMapWr {get; set;}
    
    public Map<Id,FunnelDisplayWrapper> snapsWr {get; set;}
        
    public Sales_rep_profile__c goalRec{ get; set;} 

    public boolean editable {get; set;}

    public String recordId{ get; set;}
    
    public Decimal quotaAmt {get; set;} 
    
    public Application_Setting__c managerUpdate{ get; set;} 
    
     
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
    
    public FunnelManagerUpdate_Controller(){
      
       managerUpdate = [Select Enable_Manger_Goal_Update__c from Application_Setting__c Limit 1]; 
       
       
       List<AggregateResult> asperm = [SELECT count(Id) c FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = 'Funnel_App_Setup'];
        if((asperm != null && asperm.size() > 0 && asperm[0].get('c') != null && (Integer)asperm[0].get('c') > 0)   ){
            adminPer= true;
        }else{
            adminPer= false;
        }
        
        
        fetchGoals();
        /*filters*/
            label1 = ApexPages.currentPage().getParameters().get('labelOne');
            label2 = ApexPages.currentPage().getParameters().get('labelTwo');
            label3 = ApexPages.currentPage().getParameters().get('labelThree');
            selectedLevel1 = ApexPages.currentPage().getParameters().get('selectOne');
            selectedLevel2 = ApexPages.currentPage().getParameters().get('selectTwo');
            selectedLevel3 = ApexPages.currentPage().getParameters().get('selectThree'); 
        	
    }
    
    public void fetchGoals(){
         Map<String,Yearly_goals_by_Role__c> roleGoals = new Map<String, Yearly_goals_by_Role__c>();

        repMap = new Map<Id,Sales_rep_profile__c>();

        snaps = new Map<Id,Sales_rep_profile_snapshot__c>();
       
        Map<Id,Sales_Profile_Company_Level_Junction__c> prevYrRecs = new Map<Id,Sales_Profile_Company_Level_Junction__c>();
        
        List<String> roles = new List<String>();
        
        reps = new List<Id>();
        
        List<Sales_Rep_Profile__c> sr = [select id, User_Record_Name__c, Name, Sales_Manager__c from Sales_Rep_Profile__c where User_Record_Name__c =:UserInfo.getUserId() AND Active__c = TRUE limit 1];
        system.debug(' snapshot '+sr);
        
        List<Company_Level__c> cl = new List<Company_Level__c>();
        if(adminPer){
              cl = [Select Level_Name__c,Level_Value__c from Company_Level__c WHERE Sales_Rep_Profile__r.Sales_Manager__c = '' AND Sales_Rep_Profile__r.Active__c = TRUE LIMIT 1];
        
        }else{
              cl = [Select Level_Name__c,Level_Value__c from Company_Level__c WHERE Sales_Rep_Profile__c = :String.escapeSingleQuotes(sr[0].id) AND Sales_Rep_Profile__r.Active__c = TRUE LIMIT 1];
        
        }
        //List<Company_Level__c> cl = [Select Level_Name__c,Level_Value__c from Company_Level__c WHERE Sales_Rep_Profile__c = 'a0C1H000014znVk' AND Sales_Rep_Profile__r.Active__c = TRUE LIMIT 1];
        
        system.debug(' level '+cl);
        
        //List<Sales_Profile_Company_Level_Junction__c> sj = [SELECT id, Sales_Rep_Profile__c, Sales_Rep_Profile__r.Role__c, Company_Level__r.Level_Value__c,Company_Level__r.Level_Name__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :String.escapeSingleQuotes(cl[0].Level_Value__c) AND Sales_Rep_Profile__r.Active__c = TRUE AND Sales_Rep_Profile__r.Sales_Manager__c = :sr[0].id];
        
        if(cl != null && cl.size() > 0){
        
            //List<Sales_Profile_Company_Level_Junction__c> sj = [SELECT id, Sales_Rep_Profile__c, Sales_Rep_Profile__r.Role__c, Company_Level__r.Level_Value__c,Company_Level__r.Level_Name__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :String.escapeSingleQuotes(cl[0].Level_Value__c) AND Sales_Rep_Profile__r.Active__c = TRUE AND Sales_Rep_Profile__r.Sales_Manager__c = 'a0C1H000014znVk'];
            List<Sales_Profile_Company_Level_Junction__c> sj  = new List<Sales_Profile_Company_Level_Junction__c>();
            
            if(adminPer){
                 sj = [SELECT id, Sales_Rep_Profile__c, Sales_Rep_Profile__r.Role__c, Company_Level__r.Level_Value__c,Company_Level__r.Level_Name__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :String.escapeSingleQuotes(cl[0].Level_Value__c) AND Sales_Rep_Profile__r.Active__c = TRUE  AND Sales_Rep_Profile__r.Annual_quota_amount__c > 0 ];
            }else{
                  sj = [SELECT id, Sales_Rep_Profile__c, Sales_Rep_Profile__r.Role__c, Company_Level__r.Level_Value__c,Company_Level__r.Level_Name__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :String.escapeSingleQuotes(cl[0].Level_Value__c) AND Sales_Rep_Profile__r.Active__c = TRUE AND Sales_Rep_Profile__r.Sales_Manager__c = :sr[0].id];
            }
            
            
                    
            for(Sales_Profile_Company_Level_Junction__c s:sj){
                roles.add(s.Sales_Rep_Profile__r.Role__c);
                reps.add(s.Sales_Rep_Profile__c);
            }
            
            //List<Yearly_goals_by_Role__c> yrlyGoals = [SELECT Id, Annual_quota_amount__c, X12_month_avg_selling_price__c, X12_month_rolling_lead_to_opp_conv_rate__c, Role__c, X12_month_rolling_opp_close_rate__c, X12_month_rolling_amt_close_rate__c, X12_month_rolling_avg_sales_cycle__c, Number_of_monthly_meetings__c FROM Yearly_goals_by_Role__c WHERE Role__c IN :roles];
            List<Yearly_goals_by_Role__c> yrlyGoals = [SELECT Id, X12_month_avg_selling_price__c, X12_month_rolling_lead_to_opp_conv_rate__c, Role__c, X12_month_rolling_opp_close_rate__c, X12_month_rolling_amt_close_rate__c, X12_month_rolling_avg_sales_cycle__c, Number_of_monthly_meetings__c FROM Yearly_goals_by_Role__c WHERE Role__c IN :roles];
    
            for(Yearly_goals_by_Role__c y:yrlyGoals){
                roleGoals.put(y.Role__c, y);
            }        
        }
        
        Date fiscalYr =  FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        Date prevYr = fiscalYr.addYears(-1);
        Date lstMonth = prevYr.addMonths(11);
        Integer daysInMonth = Date.daysInMonth(lstMonth.year(),lstMonth.month());
        
        Date schDate = Date.newInstance (lstMonth.year(),lstMonth.month(),daysInMonth);
        system.debug(' schDate '+schDate);            
        
        List<Sales_rep_profile__c> profs = [SELECT id, name, Annual_quota_amount__c, Goal_12m_Avg_Selling_Price__c, Goal_12m_Lead_To_Opp_Conv_Rate__c, Goal_12m_rolling_close_rate__c, Goal_12m_rolling_amt_close_rate__c, Goal_12m_length_of_sales_cycle__c, Goal_of_monthly_meetings__c, Goal_Average_Deal_Size__c FROM Sales_rep_profile__c WHERE id IN :reps];        
        repMapWr = new Map<Id,FunnelDisplayWrapper>();
        for(Sales_rep_profile__c s: profs){
            repMap.put(s.id,s);
            
            FunnelDisplayWrapper dw = new FunnelDisplayWrapper();
            dw.name = s.name;
            dw.quotaAmt = convert(s.Annual_quota_amount__c);
            dw.sellPrice = convert(s.Goal_12m_Avg_Selling_Price__c);
            
            if(s.Goal_12m_Lead_To_Opp_Conv_Rate__c != null){
                dw.convRate = (s.Goal_12m_Lead_To_Opp_Conv_Rate__c).setScale(2, RoundingMode.HALF_UP);
            }
            if(s.Goal_12m_rolling_close_rate__c!= null){
                dw.closeRate = s.Goal_12m_rolling_close_rate__c.setScale(2, RoundingMode.HALF_UP);
            }
            if(s.Goal_12m_rolling_amt_close_rate__c!= null){
                 dw.amtCloseRate = s.Goal_12m_rolling_amt_close_rate__c.setScale(2, RoundingMode.HALF_UP);
            }
            
           
            dw.salesCycle = convert(s.Goal_12m_length_of_sales_cycle__c);
            dw.monthlyMeetings = convert(s.Goal_of_monthly_meetings__c);
            dw.dealSize = convert(s.Goal_Average_Deal_Size__c);
            repMapWr.put(s.id,dw);
        }
        system.debug(' repMap '+repMap);
        
        List<Sales_rep_profile_snapshot__c> ss = [SELECT id,Name, Sales_rep_profile__c,  YTD_Revenue__c, Goal_12m_Avg_Selling_Price__c, X12_Month_Average_Selling_Price__c, X12_Month_Lead_Conv_for_1_oppty__c, Lead_to_Opportunity_Conversion_Rate__c, Goal_12m_rolling_amt_close_rate__c, X12_Month_Rolling_Close_Rate__c, Goal_12m_rolling_close_rate__c, X12_Month_Rolling_Opportunity_Close_Rate__c, Goal_12m_length_of_sales_cycle__c, X12_Month_Rolling_Average_Sales_Cycle__c, Goal_of_monthly_meetings__c, Number_of_meetings_per_month__c, Goal_Average_Deal_Size__c, Average_Deal_Size__c FROM Sales_rep_profile_snapshot__c WHERE Snapshot_scheduled_date__c = :schDate AND Sales_rep_profile__c IN :reps];
        system.debug(' snapshot '+ss);
        
        snapsWr = new Map<Id,FunnelDisplayWrapper>();
        
        for(Sales_rep_profile_snapshot__c s: ss){
            
            snaps.put(s.Sales_rep_profile__c, s);
            
            FunnelDisplayWrapper dw = new FunnelDisplayWrapper();
            dw.name = s.name;
            dw.quotaAmt = convert(s.YTD_Revenue__c);
            dw.sellPrice = convert(s.X12_Month_Average_Selling_Price__c);
            
            if(s.X12_Month_Lead_Conv_for_1_oppty__c!= null){
                dw.convRate = s.X12_Month_Lead_Conv_for_1_oppty__c.setScale(2, RoundingMode.HALF_UP);
            }
            if(s.X12_Month_Rolling_Opportunity_Close_Rate__c!= null){
                dw.closeRate = s.X12_Month_Rolling_Opportunity_Close_Rate__c.setScale(2, RoundingMode.HALF_UP);  
            }
            if(s.X12_Month_Rolling_Close_Rate__c != null){
                dw.amtCloseRate = s.X12_Month_Rolling_Close_Rate__c.setScale(2, RoundingMode.HALF_UP);
            }          
            
           
            dw.salesCycle = convert(s.X12_Month_Rolling_Average_Sales_Cycle__c);
            dw.monthlyMeetings = convert(s.Number_of_meetings_per_month__c);
            dw.dealSize = convert(s.Average_Deal_Size__c);
            snapsWr.put(s.Sales_rep_profile__c,dw);
        }
        
        for(Id i:reps){
            if(!snaps.containsKey(i)){
                snaps.put(i, new Sales_Rep_Profile_Snapshot__c());
                snapsWr.put(i,new FunnelDisplayWrapper());
            }
        }
        system.debug(' snaps '+snaps);
    }
    
    public void displayModal(){
         
        editable = true;
        system.debug(' inside edit ');
        
        goalRec = [SELECT Role__c, Annual_Quota_Amount__c, Goal_12m_Avg_Selling_Price__c, X12_Month_Average_Selling_Price__c, Goal_12m_Lead_To_Opp_Conv_Rate__c, Lead_to_Opportunity_Conversion_Rate__c, Goal_12m_rolling_amt_close_rate__c, X12_Month_Rolling_Close_Rate__c, Goal_12m_rolling_close_rate__c, X12_Month_Rolling_Opportunity_Close_Rate__c, Goal_12m_length_of_sales_cycle__c, X12_Month_Rolling_Average_Sales_Cycle__c, Goal_of_monthly_meetings__c, Number_of_meetings_per_month__c, Goal_Average_Deal_Size__c, Average_Deal_Size__c  FROM Sales_rep_profile__c WHERE id = :recordId];
        quotaAmt = goalRec.Annual_Quota_Amount__c;
        system.debug(' goal rec '+goalRec);
    
    }
    
    public void saveUpdate(){
        
        Decimal monthlyQuota = (quotaAmt/12);
        goalRec.Month_1_Quota_Amount__c = monthlyQuota;
        goalRec.Month_2_Quota_Amount__c = monthlyQuota;
        goalRec.Month_3_Quota_Amount__c = monthlyQuota;
        goalRec.Month_4_Quota_Amount__c = monthlyQuota;
        goalRec.Month_5_Quota_Amount__c = monthlyQuota;
        goalRec.Month_6_Quota_Amount__c = monthlyQuota;
        goalRec.Month_7_Quota_Amount__c = monthlyQuota;
        goalRec.Month_8_Quota_Amount__c = monthlyQuota;
        goalRec.Month_9_Quota_Amount__c = monthlyQuota;
        goalRec.Month_10_Quota_Amount__c = monthlyQuota;
        goalRec.Month_11_Quota_Amount__c = monthlyQuota;
        goalRec.Month_12_Quota_Amount__c = monthlyQuota;
        update goalRec;
        
        fetchGoals();
        system.debug(' updated ');
        
    }
    
    public class FunnelDisplayWrapper{
        public id recId{get;set;}
        public String name{get;set;}
        public String quotaAmt{get;set;}
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
            PageReference p = new PageReference('/one/one.app#/alohaRedirect/apex/FunnelMetrics__FunnelManagerUpdate');
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
        
        return FunnelNavigationHelper.navigateToTrendingByRep(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToTrendingBySkill(){
        
        return FunnelNavigationHelper.navigateToTrendingBySkill(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
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
    public PageReference navigateToGoals(){
        
        return FunnelNavigationHelper.navigateToGoalsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    //Added for Help Menu - Rohit
    public PageReference navigateToHelpMenu(){
        
        return FunnelNavigationHelper.navigateToHelpMenu();
    
    }
    /*Navigation*/
}