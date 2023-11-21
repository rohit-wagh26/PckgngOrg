/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelReporting_Controller{
    
    Public Map<String,String> managemenetReports{get;set;}
    
    public List<String> chartLabels {get;set;}  
    public List<Decimal> chartData {get;set;}
    public List<Decimal> chartDataQuota{get;set;}
    
    public List<Decimal> YtdCloseRate {get;set;}
    public List<Decimal> YtdCloseRateGoal {get;set;}
    
    public List<Decimal> YtdOppWon {get;set;}
    public List<Decimal> YtdOppWonGoal {get;set;}
    
    public List<Decimal> QuotaPercentage{get;set;}
    public List<Decimal> OppPercentage{get;set;}
    
    public List<String> chartLabelsbelow {get;set;}  
    public List<Decimal> chartDatabelow {get;set;}
    public List<Decimal> chartDataQuotabelow{get;set;}
    
    public List<Decimal> YtdCloseRatebelow {get;set;}
    public List<Decimal> YtdCloseRateGoalbelow {get;set;}
    
    public List<Decimal> YtdOppWonbelow {get;set;}
    public List<Decimal> YtdOppWonGoalbelow {get;set;}
    
    public List<Decimal> QuotaPercentagebelow{get;set;}
    public List<Decimal> OppPercentagebelow{get;set;}
     
    public Boolean RoleOverlay{get;set;}
    public Boolean RepOverlay{get;set;}
    
    private FunnelSalesProfileWrapper displayWrapperValue = new FunnelSalesProfileWrapper();
    
    public FunnelSalesProfileWrapper displayWrapper{
    
        get{
            return displayWrapperValue;
        }
        set{
            displayWrapperValue = value;
        }
    }
    
         
        
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
     
    public FunnelReporting_Controller() {
    
        try{    
            
            
             /*filters*/
            label1 = ApexPages.currentPage().getParameters().get('labelOne');
            label2 = ApexPages.currentPage().getParameters().get('labelTwo');
            label3 = ApexPages.currentPage().getParameters().get('labelThree');
            selectedLevel1 = ApexPages.currentPage().getParameters().get('selectOne');
            selectedLevel2 = ApexPages.currentPage().getParameters().get('selectTwo');
            selectedLevel3 = ApexPages.currentPage().getParameters().get('selectThree');
            selectedLevel4 = ApexPages.currentPage().getParameters().get('selectFour');                  
            
            system.debug('------->'+label2 );
            system.debug('------->'+label1 );
            fw = new FunnelFilterWrapper();
            
            fw.userId = UserInfo.getUserId();
            
            FunnelFilterHelper.populateFilters(fw, 
            label1, label2, label3,
            selectedLevel1, selectedLevel2, selectedLevel3);
            
            /*FunnelFilterHelper.populateFilters1(fw, 
            label1, label2, label3,
            selectedLevel1, selectedLevel2, selectedLevel3, selectedLevel4);*/
            
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            system.debug('------->label2 '+label2 );
            /*  filters*/  
            
            if(selectedLevel4 != null && selectedLevel4 != '' && selectedLevel4 != 'ALL'){
                fw.SelectedLevelFour  = selectedLevel4;
            }
            
            showUpdated();
            
            
            fw.labelFour = 'Filter By Representative';
            fw.levelFour = FunnelFilterHelper.populateLevelFour(fw,'');
            system.debug('in constructor :: '+fw.levelFour);
            
            defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw); 

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            //fetchTableData();
            managemenetReports = new Map<String,String>();
            
            //User u = [SELECT Name, UserPreferencesLightningExperiencePreferred FROM User WHERE id = :UserInfo.getUserId()];
            
            String currentTheme = UserInfo.getUiThemeDisplayed();
            
            List<String> dashList = new List<String>();
            Map<String,String> dashMap = new Map<String,String>();
            
            Dashboard_detail__mdt [] dl = new List<Dashboard_detail__mdt>();
            
            Set<String> allDash = new Set<String>();
            
            if (currentTheme == 'Theme2' || currentTheme == 'Theme3'){
                dl = [SELECT Display_name__c, Classic_ID__c FROM Dashboard_detail__mdt WHERE Display_name__c = 'Sales Management Dashboard'];
                
                for(Dashboard_detail__mdt d: dl){
                    dashList.add(d.Classic_ID__c);
                    dashMap.put(d.Classic_ID__c,d.Display_name__c);
                    allDash.add(d.Display_name__c);
                }
                currentTheme = 'classic';
            }
            else{
                dl = [SELECT Display_name__c, Lightning_ID__c FROM Dashboard_detail__mdt WHERE Display_name__c = 'Sales Management Dashboard'];
                
                for(Dashboard_detail__mdt d: dl){
                    dashList.add(d.Lightning_ID__c);
                    dashMap.put(d.Lightning_ID__c,d.Display_name__c);
                    allDash.add(d.Display_name__c);
                }
                currentTheme = 'lightning';
            }
                                                
            managemenetReports = FunnelNavigationHelper.fetchDashboards(dashList,dashMap,currentTheme);
            
            for(String s : allDash){
                if(!managemenetReports.containsKey(s)){
                    managemenetReports.put(s,'/apex/FunnelNoReport');
                }
            }
            
            //managemenetReports = FunnelNavigationHelper.fetchDashboards(dashList,u);
            
            /*List<Report> reportList = [SELECT id, name,developerName FROM Report WHERE developerName IN ('Current_Yr_YTD_Oppty_Win_Report','X12_Month_Funnel_Win_Rate','Lead_Analysis',
                                      'Lead_conversion_report','Sales_Rep_Quota_YTD_Attainment','X12_Month_Average_Win_Size','X12_Month_Opportunities_Added_to_Funnel',
                                      'X12_Month_Average_Sales_Cycle','X12_Month_Funnel_by_Lead_Source','Current_Yr_YTD_Oppty_Wins_by_Lead_Source','New_Leads_Added_by_Month',
                                      'Quarterly_Funnel_Report','X12_Month_Funnel_Report','Opportunities_Added_by_Rep_qtr','Sales_Revenue_by_Fiscal_Period','Monthly_Funnel_Report','Opportunity_Win_Report') ];
            
            List<String> dashList = new List<String>();
            dashList.add('DoXUfevXYIvViBKzMxFjcYVzyuTDMv');
            dashList.add('mXaDybYGcSDujlyIRRJQxUrUEqXiFe');
            
            */
                            
            /*List<Report> reportList = [SELECT id, name,developerName FROM Report WHERE developerName IN ('X12_Mo_Opptys_added_to_funnel_SRP_Snapsho_73d',    'X12_Mo_SRP_Snapshots_Opptys_Added_tTS',    
            'X12_Month_Funnel_Report',  'X12_Month_Funnel_Win_Rate_m3a',    'X12_Month_Funnel_by_Lead_Source',  'Monthly_Funnel_Report',    'Opportunities_Added_by_Rep_qtr',   
            'Opportunity_Win_Report',   'Quarterly_Funnel_Report',  'SRP_Lead_Conversion_Rate_by_Month_2MH',    'SRP_Snapshot_Sales_Cycle_ALc', 'SRP_Snapshot_12_Mo_Win_Size_iuS',  
            'X12_Mo_SRP_Snapshot_Mnthly_Opptys_Added_Wnh',  'SRP_Snapshot_Monthly_Leads_Added_xB3', 'Copy_of_SRP_Snapshot_Mnthly_Opptys_Added_7aQ', 
            'X12_Mo_SRP_Snapshot_Mnthly_Opptys_Added_Wnh1', 'YTD_Win_Report_jWK1',  'Sales_Rep_Quota_YTD_Attainment',   'YTD_Win_Report_jWK',   
            'Current_Yr_YTD_Oppty_Wins_by_Lead_Source')];*/
             
             List<Report> reportList = FunnelNavigationHelper.fetchReports();                         
            //List<Dashboard> dashList = [SELECT Id, DeveloperName FROM Dashboard WHERE DeveloperName IN ('DoXUfevXYIvViBKzMxFjcYVzyuTDMv')];                
            
            if(currentTheme == 'lightning'){
                /*for(Dashboard r : dashList){
                    managemenetReports.put(r.developerName,'/one/one.app#/alohaRedirect/'+(String)r.id);
                }*/
                
                for(Report r : reportList){
                    managemenetReports.put(r.developerName,'/one/one.app#/alohaRedirect/'+(String)r.id);
                }
            }else{
            
                /*for(Dashboard r : dashList){
                    managemenetReports.put(r.developerName,'/'+(String)r.id);
                }*/
                
                for(Report r : reportList){
                    managemenetReports.put(r.developerName,'/'+(String)r.id);
                }
            
            }
            
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());

            List<String> reportName = new List<String>();
            reportName.add('X12_Mo_SRP_Snapshots_Opptys_Added_tTS');
            reportName.add('X12_Month_Funnel_Report');
            reportName.add('X12_Month_Funnel_Win_Rate_m3a');
            reportName.add('X12_Month_Funnel_by_Lead_Source');
            reportName.add('Monthly_Funnel_Report');
            reportName.add('Opportunities_Added_by_Rep_qtr');
            reportName.add('Opportunity_Win_Report');
            reportName.add('Quarterly_Funnel_Report');
            reportName.add('SRP_Lead_Conversion_Rate_by_Month_2MH');
            reportName.add('SRP_Snapshot_Sales_Cycle_ALc');
            reportName.add('SRP_Snapshot_12_Mo_Win_Size_iuS');
            reportName.add('SRP_Snapshot_Monthly_Leads_Added_xB3');
            reportName.add('Copy_of_SRP_Snapshot_Mnthly_Opptys_Added_7aQ');
            reportName.add('X12_Mo_SRP_Snapshot_Mnthly_Opptys_Added_Wnh1');
            reportName.add('YTD_Win_Report_jWK1');
            reportName.add('Sales_Rep_Quota_YTD_Attainment');   
            reportName.add('YTD_Win_Report_jWK');
            reportName.add('Current_Yr_YTD_Oppty_Wins_by_Lead_Source');
            reportName.add('DoXUfevXYIvViBKzMxFjcYVzyuTDMv');
            
            for(String s : reportName ){
                if(!managemenetReports.containsKey(s)){
                managemenetReports.put(s,'FunnelNoReport');
                }
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelReporting_Controller '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
        
    }             
    
     public String getData() {
       
        return JSON.serialize(chartLabels);
    }
    
    public String getQuotas() {
        return JSON.serialize(chartDataQuota);
    }
    
    public String getQuotaPercentage() {
        return JSON.serialize(QuotaPercentage);
    }
    
    public String getRevenues() {
        return JSON.serialize(chartData);
    }
    
    
    public String getYtdCloseRates() {
        return JSON.serialize(YtdCloseRate);
    } 
    
    public String getYtdCloseRatesGoals() {
        return JSON.serialize(YtdCloseRateGoal);
    }     
   
    public String getYtdOppWins() {
        return JSON.serialize(YtdOppWon);
    }
    
    public String getYtdOppWinsGoals() {
        return JSON.serialize(YtdOppWonGoal);
    } 
   
    public String getOppPercentage() {
        return JSON.serialize(OppPercentage);
    } 
    
     public String getDatabelow() {
       
        return JSON.serialize(chartLabelsbelow);
    }
    
    public String getQuotasbelow() {
        return JSON.serialize(chartDataQuotabelow);
    }
    
    public String getQuotaPercentagebelow() {
        return JSON.serialize(QuotaPercentagebelow);
    }
    
    public String getRevenuesbelow() {
        return JSON.serialize(chartDatabelow);
    }
    
    
    public String getYtdCloseRatesbelow() {
        return JSON.serialize(YtdCloseRatebelow);
    } 
    
    public String getYtdCloseRatesGoalsbelow() {
        return JSON.serialize(YtdCloseRateGoalbelow);
    }     
   
    public String getYtdOppWinsbelow() {
        return JSON.serialize(YtdOppWonbelow);
    }
    
    public String getYtdOppWinsGoalsbelow() {
        return JSON.serialize(YtdOppWonGoalbelow);
    } 
   
    public String getOppPercentagebelow() {
        return JSON.serialize(OppPercentagebelow);
    } 
   
  
    public void showUpdated(){
        try{ 
             RoleOverlay = false;
             RepOverlay =false;
             fw.labelFour = 'Filter By Representative';   
             chartLabels = new list<String>();
             chartData = new list<Decimal>();
             chartDataQuota = new list<Decimal>();
             QuotaPercentage = new list<Decimal>();
             
             YtdCloseRate = new list<Decimal>();
             YtdCloseRateGoal = new list<Decimal>();
    
             YtdOppWon = new list<Decimal>();
             YtdOppWonGoal = new list<Decimal>();
             OppPercentage = new list<Decimal>();
             
             chartLabelsbelow = new list<String>();
             chartDatabelow = new list<Decimal>();
             chartDataQuotabelow = new list<Decimal>();
             QuotaPercentagebelow = new list<Decimal>();
             
             YtdCloseRatebelow = new list<Decimal>();
             YtdCloseRateGoalbelow = new list<Decimal>();
    
             YtdOppWonbelow = new list<Decimal>();
             YtdOppWonGoalbelow = new list<Decimal>();
             OppPercentagebelow = new list<Decimal>();

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
             
             system.debug(' fw.selectedLevelThree '+fw.selectedLevelThree);
            //Aggregates of a particular level value need to be done
            if(fw.selectedLevelThree == 'All' && fw.selectedLevelFour == 'All'){
                //Fetch the sales profile record associated with that level
                List<Company_Level__c> cl = [SELECT Sales_Rep_Profile__c FROM Company_Level__c WHERE Level_Value__c = : fw.selectedLevelOne LIMIT 1];

                System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
                
                aggregate(cl[0].Sales_Rep_Profile__c);

                System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());

                mgr = true;
                fetchData('team');
                
                System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
                
            }
            //A particular rep has been selected and his values need to be displayed
            else if((fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All') || (fw.selectedLevelFour!='All' && fw.selectedLevelFour != null && fw.selectedLevelFour!='')){
                if(fw.selectedLevelFour != 'All' && fw.selectedLevelFour != ''){
                    singleRep(fw.selectedLevelFour,null); 
                    fetchTableDataForRep(fw.selectedLevelFour);
                }else{
                    singleRep(fw.selectedLevelTwo,null);   
                    mgr = false; 
                    fetchTableDataForRep(fw.selectedLevelTwo);     
                }          
            }
            //A particular role has been selected 
            else if (fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
                system.debug('role aggregates');
                mgr = true;
                aggregateOnRole();
                fetchData('role');
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelReporting_Controller '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
     }  
     
     //Aggregation needs to be done based on the role
     private void aggregateOnRole(){ 
        
         Boolean isOverlay = true;
        //Fetch the company level record associated with the particular level
        List<Company_Level__c> cl = [SELECT id,Sales_Rep_Profile__c, Sales_Rep_Profile__r.name FROM Company_Level__c WHERE Level_Value__c = :fw.SelectedLevelOne];
        
        //Level below
        List<Company_Level__c> c2=[select id, Level_Value__c FROM Company_Level__c WHERE Sales_Rep_Profile__r.Sales_Manager__c = :cl[0].Sales_Rep_Profile__c AND (Sales_Rep_Profile__r.Active__c = TRUE OR Sales_Rep_Profile__r.Annual_quota_amount__c > 0)];
        system.debug('c2--->'+c2);
        set<string> levelnm = new set<string>();
        
        for(Company_Level__c c :c2){
            levelnm.add(c.Level_Value__c);
        }
        system.debug('levelnm--->'+levelnm);
        displayWrapper = new FunnelSalesProfileWrapper();
        displayWrapper.Name = cl[0].Sales_Rep_Profile__r.name;
        
        //Fetch the records at the selected level and role
        List<Sales_Profile_Company_Level_Junction__c> sReps = [SELECT Sales_Rep_Profile__c,Sales_Rep_Profile__r.Profile_Type__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree AND (Sales_Rep_Profile__r.Active__c = TRUE OR Sales_Rep_Profile__r.Annual_quota_amount__c > 0)];                
        
        Set<String> levels = new Set<String>();
        
        //List to store the ids of the reps to be aggregated
        Set<ID> aggregateIds = new Set<Id>();
        
        Set<ID> profIds = new Set<Id>();
        
        //Store the profile ids of the managers
        for(Sales_Profile_Company_Level_Junction__c s: sReps){
            profIds.add(s.Sales_Rep_Profile__c);
            aggregateIds.add(s.Sales_Rep_Profile__c);
             if(s.Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' ){
                    isOverlay = false;
                  }
        }
        
        //Fetch the company levels associated with the sales profiles
        cl = [SELECT id, Level_Value__c FROM Company_Level__c WHERE Sales_Rep_Profile__c IN :profIds AND (Sales_Rep_Profile__r.Active__c = TRUE OR Sales_Rep_Profile__r.Annual_quota_amount__c > 0)];
        
        levels.clear();
        
        //Store all the levels associated with the managers
        for(Company_Level__c c: cl){
            levels.add(c.Level_Value__c);
        }
        
        //Fetch the sales profiles associated with the levels
        sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Profile_Type__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels AND (Sales_Rep_Profile__r.Active__c = TRUE OR Sales_Rep_Profile__r.Annual_quota_amount__c > 0)];
                
        //Add the sales profiles to the ids to be aggregated        
        for(Sales_Profile_Company_Level_Junction__c s: sReps){
            aggregateIds.add(s.Sales_Rep_Profile__c);
            if(s.Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' ){
                    isOverlay = false;
              }
        }
        RoleOverlay = isOverlay ;   
        //Aggregate the results
        List<AggregateResult> r = new List<AggregateResult>();
        if(RoleOverlay ){
            r = [Select SUM(YTD_Revenue__c) ytdrev, SUM(YTD_Quota__c) ytdquo,AVG(YTD_Opportunity_Close_Rate__c) ytdocr ,AVG(Goal_12m_rolling_close_rate__c) gytdocr,SUM(YTD_Opportunities_won__c) ytdow,
                SUM(Goal_of_wins_to_achieve_monthly_quota__c) gytdow,AVG(Current_Fiscal_Months__c) cfy from Sales_Rep_Profile__c where id IN :aggregateIds AND  Annual_Quota_Amount__c > 0 AND Profile_Type__c = 'Overlay'];
        }else{
            r = [Select SUM(YTD_Revenue__c) ytdrev, SUM(YTD_Quota__c) ytdquo,AVG(YTD_Opportunity_Close_Rate__c) ytdocr ,AVG(Goal_12m_rolling_close_rate__c) gytdocr,SUM(YTD_Opportunities_won__c) ytdow,
                SUM(Goal_of_wins_to_achieve_monthly_quota__c) gytdow,AVG(Current_Fiscal_Months__c) cfy from Sales_Rep_Profile__c where id IN :aggregateIds AND  Annual_Quota_Amount__c > 0 AND Profile_Type__c != 'Overlay'];
        }     
        
        if(profIds != null && profIds.size() > 0)
            displayWrapper.score = FunnelCalculationHelper.findAggregateScore(profIds);
            
        
        //Populate the wrapper
        if(r != null && r.size() > 0){   
            
            chartLabels.add(String.escapeSingleQuotes((String)fw.SelectedLevelOne));
            
            
            if(r[0].get('ytdrev') != null){
                    chartData.add((Decimal)r[0].get('ytdrev'));
                } else{
                    chartData.add(0);
                }
                
            if(r[0].get('ytdquo') != null){
                    chartDataQuota.add((Decimal)r[0].get('ytdquo'));
                } else{
                    chartDataQuota.add(0);
                }
                
            if(r[0].get('ytdocr') != null){
                    YtdCloseRate.add((Decimal)r[0].get('ytdocr'));
                } else{
                    YtdCloseRate.add(0);
                }
                
            if(r[0].get('gytdocr') != null){
                    YtdCloseRateGoal.add((Decimal)r[0].get('gytdocr'));
                } else{
                    YtdCloseRateGoal.add(0);
                }
                
            if(r[0].get('ytdow') != null){
                    YtdOppWon.add((Decimal)r[0].get('ytdow'));
                } else{
                    YtdOppWon.add(0);
                }
                
            if(r[0].get('gytdow') != null ){
                    YtdOppWonGoal.add((Decimal)r[0].get('gytdow') * (Decimal)r[0].get('cfy'));
                } else{
                    YtdOppWonGoal.add(0);
                }
                
            if(r[0].get('ytdquo') != null && r[0].get('ytdrev') != null && (Decimal)r[0].get('ytdquo') != 0){
                    QuotaPercentage.add(((Decimal)r[0].get('ytdrev') *100)/ (Decimal)r[0].get('ytdquo'));
                } else{
                    QuotaPercentage.add(0);
                }
                
            if(r[0].get('gytdow') != null && r[0].get('ytdow') != null  && (Decimal)r[0].get('gytdow') != 0){
                    OppPercentage.add(((Decimal)r[0].get('ytdow') *100)/ ((Decimal)r[0].get('gytdow') * (Decimal)r[0].get('cfy') ));
                } else{
                    OppPercentage.add(0);
                }
        }  

        //Fetch the company level record associated with the particular level
        
        
        //Fetch the records at the selected level and role
        List<Sales_Profile_Company_Level_Junction__c> sRepsbelow = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levelnm AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree AND (Sales_Rep_Profile__r.Active__c = TRUE OR Sales_Rep_Profile__r.Annual_quota_amount__c > 0)];                
        system.debug('levelnm--->'+levelnm);
        system.debug('sRepsbelow --->'+sRepsbelow );
        Set<String> levelsbelow = new Set<String>();
        
        //List to store the ids of the reps to be aggregated
        Set<ID> aggregateIdsbelow = new Set<Id>();
        
        Set<ID> profIdsbelow = new Set<Id>();
        
        //Store the profile ids of the managers
        for(Sales_Profile_Company_Level_Junction__c sbelow : sRepsbelow){
            profIdsbelow.add(sbelow.Sales_Rep_Profile__c);
            aggregateIdsbelow.add(sbelow.Sales_Rep_Profile__c);
        }
        
        //Fetch the company levels associated with the sales profiles
        c2 = [SELECT id, Level_Value__c FROM Company_Level__c WHERE Sales_Rep_Profile__c IN :profIdsbelow AND (Sales_Rep_Profile__r.Active__c = TRUE OR Sales_Rep_Profile__r.Annual_quota_amount__c > 0)];
        
        levelsbelow.clear();
        
        //Store all the levels associated with the managers
        for(Company_Level__c cbelow : c2){
            levelsbelow.add(cbelow.Level_Value__c);
        }
        system.debug('levelsbelow--->'+levelsbelow);
        //Fetch the sales profiles associated with the levels
        sRepsbelow = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levelsbelow AND (Sales_Rep_Profile__r.Active__c = TRUE OR Sales_Rep_Profile__r.Annual_quota_amount__c > 0)];
                
        //Add the sales profiles to the ids to be aggregated        
        for(Sales_Profile_Company_Level_Junction__c sbelow: sRepsbelow){
            aggregateIdsbelow.add(sbelow.Sales_Rep_Profile__c);
        }
           
        //Aggregate the results
        if(levelnm != null && levelnm.size() > 0){
        
        List<AggregateResult> rbelow = new  List<AggregateResult>();
        if(RoleOverlay){
            rbelow = [Select Company_Level__r.Level_Value__c c, SUM(Sales_Rep_Profile__r.YTD_Revenue__c) ytdrev, SUM(Sales_Rep_Profile__r.YTD_Quota__c) ytdquo,AVG(Sales_Rep_Profile__r.YTD_Opportunity_Close_Rate__c) ytdocr ,AVG(Sales_Rep_Profile__r.Goal_12m_rolling_close_rate__c) gytdocr,
                SUM(Sales_Rep_Profile__r.YTD_Opportunities_won__c) ytdow,SUM(Sales_Rep_Profile__r.Goal_of_wins_to_achieve_monthly_quota__c) gytdow,AVG(Sales_Rep_Profile__r.Current_Fiscal_Months__c) cfy from Sales_Profile_Company_Level_Junction__c where Sales_Rep_Profile__c IN :aggregateIdsbelow AND  Sales_Rep_Profile__r.Annual_Quota_Amount__c > 0 AND Sales_Rep_Profile__r.Profile_Type__c = 'Overlay' AND Company_Level__r.Level_Value__c IN :levelnm group by Company_Level__r.Level_Value__c];
        }else{
            rbelow = [Select Company_Level__r.Level_Value__c c, SUM(Sales_Rep_Profile__r.YTD_Revenue__c) ytdrev, SUM(Sales_Rep_Profile__r.YTD_Quota__c) ytdquo,AVG(Sales_Rep_Profile__r.YTD_Opportunity_Close_Rate__c) ytdocr ,AVG(Sales_Rep_Profile__r.Goal_12m_rolling_close_rate__c) gytdocr,
                SUM(Sales_Rep_Profile__r.YTD_Opportunities_won__c) ytdow,SUM(Sales_Rep_Profile__r.Goal_of_wins_to_achieve_monthly_quota__c) gytdow,AVG(Sales_Rep_Profile__r.Current_Fiscal_Months__c) cfy from Sales_Profile_Company_Level_Junction__c where Sales_Rep_Profile__c IN :aggregateIdsbelow AND  Sales_Rep_Profile__r.Annual_Quota_Amount__c > 0 AND Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' AND Company_Level__r.Level_Value__c IN :levelnm group by Company_Level__r.Level_Value__c];
        }
        
           
        
        //Populate the wrapper
        for(AggregateResult rb: rbelow){   
            
            //chartLabelsbelow.add(String.escapeSingleQuotes((String)fw.SelectedLevelThree));
            if(rb.get('c') != null){
                    chartLabelsbelow.add(String.escapeSingleQuotes((String)rb.get('c')));
                } else{
                    chartLabelsbelow.add(String.escapeSingleQuotes(' '));
                }
            
            if(rb.get('ytdrev') != null){
                    chartDatabelow.add((Decimal)rb.get('ytdrev'));
                } else{
                    chartDatabelow.add(0);
                }
                
            if(rb.get('ytdquo') != null){
                    chartDataQuotabelow.add((Decimal)rb.get('ytdquo'));
                } else{
                    chartDataQuotabelow.add(0);
                }
                
            if(rb.get('ytdocr') != null){
                    YtdCloseRatebelow.add((Decimal)rb.get('ytdocr'));
                } else{
                    YtdCloseRatebelow.add(0);
                }
                
            if(rb.get('gytdocr') != null){
                    YtdCloseRateGoalbelow.add((Decimal)rb.get('gytdocr'));
                } else{
                    YtdCloseRateGoalbelow.add(0);
                }
                
            if(rb.get('ytdow') != null){
                    YtdOppWonbelow.add((Decimal)rb.get('ytdow'));
                } else{
                    YtdOppWonbelow.add(0);
                }
                
            if(rb.get('gytdow') != null ){
                    YtdOppWonGoalbelow.add(((Decimal)rb.get('gytdow') * (Decimal)rb.get('cfy')).setScale(0, RoundingMode.HALF_UP));
                } else{
                    YtdOppWonGoalbelow.add(0);
                }
                
            if(rb.get('ytdquo') != null && rb.get('ytdrev') != null && (Decimal)rb.get('ytdquo') != 0){
                    QuotaPercentagebelow.add(((Decimal)rb.get('ytdrev') *100)/ (Decimal)rb.get('ytdquo'));
                } else{
                    QuotaPercentagebelow.add(0);
                }
                
            if(rb.get('gytdow') != null && rb.get('ytdow') != null  && (Decimal)rb.get('gytdow') != 0){
                    OppPercentagebelow.add(((Decimal)rb.get('ytdow') *100)/ ((Decimal)rb.get('gytdow') * (Decimal)rb.get('cfy') ).setScale(0, RoundingMode.HALF_UP));
                } else{
                    OppPercentagebelow.add(0);
                }
        }   
        for(string ls: levelnm ){
          if(!chartLabelsbelow.contains(ls)){
              chartLabelsbelow.add(ls);
              chartDatabelow.add(0);
              chartDataQuotabelow.add(0);
              YtdCloseRatebelow.add(0);
              YtdCloseRateGoalbelow.add(0);
              YtdOppWonbelow.add(0);
              YtdOppWonGoalbelow.add(0);
              QuotaPercentagebelow.add(0);
              OppPercentagebelow.add(0);
              
          }
      
      } 
        }else if(fw.labelTwo == 'Rep'){
            List<Sales_Profile_Company_Level_Junction__c> rbelow = [Select Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.YTD_Revenue__c ,  Sales_Rep_Profile__r.YTD_Quota__c , Sales_Rep_Profile__r.YTD_Opportunity_Close_Rate__c  , Sales_Rep_Profile__r.Goal_12m_rolling_close_rate__c ,
                                             Sales_Rep_Profile__r.YTD_Opportunities_won__c , Sales_Rep_Profile__r.Goal_of_wins_to_achieve_monthly_quota__c , Sales_Rep_Profile__r.Current_Fiscal_Months__c  from Sales_Profile_Company_Level_Junction__c where Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c =:fw.selectedLevelThree AND (Sales_Rep_Profile__r.Active__c = TRUE OR Sales_Rep_Profile__r.Annual_quota_amount__c > 0)];
            
            for(Sales_Profile_Company_Level_Junction__c rb: rbelow){   
                
                //chartLabelsbelow.add(String.escapeSingleQuotes((String)fw.SelectedLevelThree));
                 
                chartLabelsbelow.add(rb.Sales_Rep_Profile__r.name);
                chartDatabelow.add(rb.Sales_Rep_Profile__r.YTD_Revenue__c);
                chartDataQuotabelow.add(rb.Sales_Rep_Profile__r.YTD_Quota__c);
                YtdCloseRatebelow.add(rb.Sales_Rep_Profile__r.YTD_Opportunity_Close_Rate__c);
                YtdCloseRateGoalbelow.add(rb.Sales_Rep_Profile__r.Goal_12m_rolling_close_rate__c);
                YtdOppWonbelow.add(rb.Sales_Rep_Profile__r.YTD_Opportunities_won__c);
                YtdOppWonGoalbelow.add((rb.Sales_Rep_Profile__r.Goal_of_wins_to_achieve_monthly_quota__c * rb.Sales_Rep_Profile__r.Current_Fiscal_Months__c).setScale(0, RoundingMode.HALF_UP));
                
                if(rb.Sales_Rep_Profile__r.YTD_Quota__c != 0){
                    QuotaPercentagebelow.add((rb.Sales_Rep_Profile__r.YTD_Revenue__c *100)/ rb.Sales_Rep_Profile__r.YTD_Quota__c);
                }else{
                    QuotaPercentagebelow.add(0);
                }
                if(rb.Sales_Rep_Profile__r.Goal_of_wins_to_achieve_monthly_quota__c != 0){
                    OppPercentagebelow.add((rb.Sales_Rep_Profile__r.YTD_Opportunities_won__c *100)/ (rb.Sales_Rep_Profile__r.Goal_of_wins_to_achieve_monthly_quota__c * rb.Sales_Rep_Profile__r.Current_Fiscal_Months__c ).setScale(0, RoundingMode.HALF_UP));
                }else{
                    OppPercentagebelow.add(0);
                } 
            }           
        }
    }
    
    private void singleRep(Id sr, Id ur){
        
        displayWrapper = new FunnelSalesProfileWrapper();
        Set<Id> aggregateIds = new Set<Id>();
        aggregateIds.add(sr);
        if(aggregateIds != null && aggregateIds.size() >0  )
            displayWrapper.score = FunnelCalculationHelper.findAggregateScore(aggregateIds);
         
               
                     
        Sales_Rep_Profile__c s = new  Sales_Rep_Profile__c();
          
        if(sr != null){
            s =[Select id,Profile_Type__c,User_Record_Name__r.name,User_Record_Name__r.title,User_Record_Name__r.CreatedDate,YTD_Quota__c,Tenure_in_current_role__c,Role__c,name,Sales_Rep_Start_Date__c,Territory__c,Annual_Quota_Amount__c,Sales_Manager__c,YTD_Opportunity_Close_Rate__c,YTD_Revenue__c,Goal_12m_rolling_close_rate__c,YTD_Opportunities_won__c,Goal_of_wins_to_achieve_monthly_quota__c,Current_Fiscal_Months__c,User_Record_Name__c,Sales_Manager__r.name from Sales_Rep_Profile__c  where id = :String.escapeSingleQuotes(sr) limit  1];
        }
        
        if(s != null){ 
           
            if(s.Profile_Type__c != null && s.Profile_Type__c == 'Overlay'){
                     
                RepOverlay =true;
            }
                
            displayWrapper.salesManager = s.Sales_Manager__r.Name ;
            displayWrapper.title = s.User_Record_Name__r.title;
            displayWrapper.role = s.Role__c;
            displayWrapper.Name = s.name;
            displayWrapper.territory = s.Territory__c;
            displayWrapper.tenure = s.Tenure_in_current_role__c;
               
            chartLabels.add(String.escapeSingleQuotes(s.name));
                
                if( s.YTD_Quota__c != null){
                    chartDataQuota.add(s.YTD_Quota__c);
                }else{
                    chartDataQuota.add(0);
                }
                
                if(s.YTD_Quota__c != null && s.YTD_Quota__c != 0){
                     QuotaPercentage.add(s.YTD_Revenue__c*100/s.YTD_Quota__c);
                }else{
                    QuotaPercentage.add(0);
                }
               
                if(s.YTD_Opportunity_Close_Rate__c != null){
                    YtdCloseRate.add(s.YTD_Opportunity_Close_Rate__c); 
                }else{
                    YtdCloseRate.add(0); 
                }
                
                if(s.Goal_12m_rolling_close_rate__c != null){
                    YtdCloseRateGoal.add(s.Goal_12m_rolling_close_rate__c); 
                }else{
                    YtdCloseRateGoal.add(0); 
                }
                
               if(s.YTD_Opportunities_won__c != null){
                   YtdOppWon.add(s.YTD_Opportunities_won__c); 
               }else{
                   YtdOppWon.add(0); 
               }
                 
                if(s.Goal_of_wins_to_achieve_monthly_quota__c != null && s.Current_Fiscal_Months__c != null){
                    YtdOppWonGoal.add(s.Goal_of_wins_to_achieve_monthly_quota__c*s.Current_Fiscal_Months__c);  
                }else{
                    YtdOppWonGoal.add(0);
                }
                
                if(s.Goal_of_wins_to_achieve_monthly_quota__c != null && s.Goal_of_wins_to_achieve_monthly_quota__c != 0 && s.YTD_Opportunities_won__c != null){
                    OppPercentage.add(s.YTD_Opportunities_won__c*100/(s.Goal_of_wins_to_achieve_monthly_quota__c*s.Current_Fiscal_Months__c));
                }else{
                    OppPercentage.add(0);
                }
                
                if(s.YTD_Revenue__c != null){
                    chartData.add(s.YTD_Revenue__c);
                    
                }else{
                    chartData.add(0);
                }
            } 
            
            
    }
    
    //Aggregates under a manager    
    public void aggregate(Id mgrId){
            
        List<Sales_Rep_Profile__c> sRep = new List<Sales_Rep_Profile__c>();
        
        sRep = [Select id,User_Record_Name__c, name from Sales_Rep_Profile__c where id =:mgrId];
        
        displayWrapper = new FunnelSalesProfileWrapper();
        displayWrapper.salesManager = sRep[0].Name ;
        displayWrapper.name = sRep[0].Name ;
        set<id> mgridset = new set<id>();
        mgridset.add(mgrId);
        displayWrapper.score = FunnelCalculationHelper.findAggregateScore(mgridset);
        
        List<Company_Level__c> cl = [SELECT id, Level_Value__c FROM Company_Level__c WHERE Level_Value__c = :fw.SelectedLevelOne];
        List<Sales_Profile_Company_Level_Junction__c> spCLJun = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :cl[0].Level_Value__c AND (Sales_Rep_Profile__r.Active__c = TRUE OR Sales_Rep_Profile__r.Annual_quota_amount__c > 0)];
        
        Set<Id> sr = new Set<Id>();
        
        for(Sales_Profile_Company_Level_Junction__c sj: spCLJun){
             sr.add(sj.Sales_Rep_Profile__c);
        }
           
     //   if(sr != null && sr.size() > 0)
     //    displayWrapper.score = FunnelCalculationHelper.findAggregateScore(sr);        
            
       
        //Aggregate the results
        List<AggregateResult> r = [Select SUM(YTD_Revenue__c) ytdrev, SUM(YTD_Quota__c) ytdquo,AVG(YTD_Opportunity_Close_Rate__c) ytdocr ,AVG(Goal_12m_rolling_close_rate__c) gytdocr,SUM(YTD_Opportunities_won__c) ytdow,
                                    SUM(Goal_of_wins_to_achieve_monthly_quota__c) gytdow,AVG(Current_Fiscal_Months__c) cfy from Sales_Rep_Profile__c where id IN :sr AND  Annual_Quota_Amount__c > 0 AND Profile_Type__c != 'Overlay'];
        
        
            
        //Populate the wrapper
        if(r != null && r.size() > 0){                            
            chartLabels.add(String.escapeSingleQuotes((String)fw.SelectedLevelOne));
            
            if(r[0].get('ytdrev') != null){
                    chartData.add((Decimal)r[0].get('ytdrev'));
                } else{
                    chartData.add(0);
                }
                
            if(r[0].get('ytdquo') != null){
                    chartDataQuota.add((Decimal)r[0].get('ytdquo'));
                } else{
                    chartDataQuota.add(0);
                }
                
           if(r[0].get('ytdocr') != null){
                    YtdCloseRate.add((Decimal)r[0].get('ytdocr'));
                } else{
                    YtdCloseRate.add(0);
                }
                
            if(r[0].get('gytdocr') != null){
                    YtdCloseRateGoal.add((Decimal)r[0].get('gytdocr'));
                } else{
                    YtdCloseRateGoal.add(0);
                } 
                
            if(r[0].get('ytdow') != null){
                    YtdOppWon.add((Decimal)r[0].get('ytdow'));
                } else{
                    YtdOppWon.add(0);
                }
                
            if(r[0].get('gytdow') != null ){
                    YtdOppWonGoal.add(((Decimal)r[0].get('gytdow') * (Decimal)r[0].get('cfy')).setScale(0, RoundingMode.HALF_UP));
                } else{
                    YtdOppWonGoal.add(0);
                }
                
            if(r[0].get('ytdquo') != null && r[0].get('ytdrev') != null && (Decimal)r[0].get('ytdquo') != 0){
                    QuotaPercentage.add(((Decimal)r[0].get('ytdrev') *100)/ (Decimal)r[0].get('ytdquo'));
                } else{
                    QuotaPercentage.add(0);
                }
                
            if(r[0].get('gytdow') != null && r[0].get('ytdow') != null  && (Decimal)r[0].get('gytdow') != 0){
                    OppPercentage.add(((Decimal)r[0].get('ytdow') *100)/ ((Decimal)r[0].get('gytdow') * (Decimal)r[0].get('cfy')).setScale(0, RoundingMode.HALF_UP));
                } else{
                    OppPercentage.add(0);
                }
        }
        
         if(mgrId != null && fw.labelTwo != 'Rep'){
            
            
            List<Sales_Rep_Profile__c >srplevel = [Select id,name,Sales_Manager__c,YTD_Revenue__c,X12_Month_Rolling_Win_Percentage__c,User_Record_Name__c,Sales_Manager__r.name from Sales_Rep_Profile__c  where Sales_Manager__c = :mgrId AND (Active__c = TRUE OR Annual_quota_amount__c > 0)];
            
            set<id> srplevelId = (new Map<Id,Sales_Rep_Profile__c>(srplevel)).keySet();
            List<Company_Level__c> complevel =[select id,Level_Value__c,Sales_Rep_Profile__c from Company_Level__c where Sales_Rep_Profile__c IN :srplevelId AND (Sales_Rep_Profile__r.Active__c = TRUE OR Sales_Rep_Profile__r.Annual_quota_amount__c > 0)] ;
           
           for(Company_Level__c s:  complevel ){
                chartLabelsbelow.add(String.escapeSingleQuotes(s.Level_Value__c));
            }
            
            List<AggregateResult> arList=[Select Company_Level__r.Level_Value__c c, Sum(Sales_Rep_Profile__r.YTD_Revenue__c) ytdrev, Sum(Sales_Rep_Profile__r.YTD_Quota__c) ytdquo,AVG(Sales_Rep_Profile__r.YTD_Opportunity_Close_Rate__c) ytdocr ,AVG(Sales_Rep_Profile__r.Goal_12m_rolling_close_rate__c) gytdocr,SUM(Sales_Rep_Profile__r.YTD_Opportunities_won__c) ytdow,SUM(Sales_Rep_Profile__r.Goal_of_wins_to_achieve_monthly_quota__c) gytdow,AVG(Sales_Rep_Profile__r.Current_Fiscal_Months__c) cfy From Sales_Profile_Company_Level_Junction__c where Company_Level__r.Level_Value__c IN : chartLabelsbelow AND  Sales_Rep_Profile__r.Annual_Quota_Amount__c > 0  AND Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' group by Company_Level__r.Level_Value__c];
            
            chartLabelsbelow.clear();
            for(AggregateResult rb : arList){
                
                if(rb.get('c') != null){
                    chartLabelsbelow.add(String.escapeSingleQuotes((String)rb.get('c')));
                } else{
                    chartLabelsbelow.add(String.escapeSingleQuotes(' '));
                }
                if(rb.get('ytdrev') != null){
                    chartDatabelow.add((Decimal)rb.get('ytdrev'));
                } else{
                    chartDatabelow.add(0);
                }
                if(rb.get('ytdquo') != null){
                    chartDataQuotabelow.add((Decimal)rb.get('ytdquo'));
                } else{
                    chartDataQuotabelow.add(0);
                }
                if(rb.get('ytdocr') != null){
                    YtdCloseRatebelow.add((Decimal)rb.get('ytdocr'));
                } else{
                    YtdCloseRatebelow.add(0);
                }
                if(rb.get('gytdocr') != null){
                    YtdCloseRateGoalbelow.add((Decimal)rb.get('gytdocr'));
                } else{
                    YtdCloseRateGoalbelow.add(0);
                }
                if(rb.get('ytdow') != null){
                    YtdOppWonbelow.add((Decimal)rb.get('ytdow'));
                } else{
                    YtdOppWonbelow.add(0);
                }
                if(rb.get('gytdow') != null && rb.get('cfy')!= null ){
                    YtdOppWonGoalbelow.add(((Decimal)rb.get('gytdow') * (Decimal)rb.get('cfy')).setScale(0, RoundingMode.HALF_UP));
                } else{
                    YtdOppWonGoalbelow.add(0);
                }
                if(rb.get('ytdquo') != null && rb.get('ytdrev') != null && (Decimal)rb.get('ytdquo') != 0){
                    QuotaPercentagebelow.add(((Decimal)rb.get('ytdrev') *100)/ (Decimal)rb.get('ytdquo'));
                } else{
                    QuotaPercentagebelow.add(0);
                }
                if(rb.get('gytdow') != null && rb.get('ytdow') != null  && (Decimal)rb.get('gytdow') != 0){
                    OppPercentagebelow.add(((Decimal)rb.get('ytdow') *100)/ ((Decimal)rb.get('gytdow')* (Decimal)rb.get('cfy')).setScale(0, RoundingMode.HALF_UP) );
                } else{
                    OppPercentagebelow.add(0);
                }
                    
                
            }
             
        }else if(mgrId != null && fw.labelTwo == 'Rep'){
             system.debug(' lowest level ');
          
                
            List<Sales_Rep_Profile__c>  srplevellist  = new   List<Sales_Rep_Profile__c>();
            srplevellist  = [Select id,name,Annual_Quota_Amount__c,Sales_Manager__c,YTD_Quota__c,YTD_Opportunity_Close_Rate__c,YTD_Revenue__c,Goal_12m_rolling_close_rate__c,YTD_Opportunities_won__c,Current_Fiscal_Months__c,Goal_of_wins_to_achieve_monthly_quota__c,User_Record_Name__c,Sales_Manager__r.name from Sales_Rep_Profile__c  where Sales_Manager__c = :String.escapeSingleQuotes(mgrId) AND (Active__c = TRUE OR Annual_quota_amount__c > 0) limit 5000  ];
            
           
            for(Sales_Rep_Profile__c s:  srplevellist){
                
                if(s.name != null){
                    chartLabelsbelow.add(String.escapeSingleQuotes(s.name));
                }else{
                    chartLabelsbelow.add(String.escapeSingleQuotes(''));
                }
                
                if(s.YTD_Quota__c != null){
                    chartDataQuotabelow.add(s.YTD_Quota__c);
                }else{
                    chartDataQuotabelow.add(0);
                }
                
                if(s.YTD_Quota__c !=null && s.YTD_Revenue__c  != null && s.YTD_Quota__c != 0){
                   QuotaPercentagebelow.add(s.YTD_Revenue__c*100/s.YTD_Quota__c); // Revenue divide by Quota
                } else{
                   QuotaPercentagebelow.add(0);
                }
               
               if(s.YTD_Opportunity_Close_Rate__c != null){
                   YtdCloseRatebelow.add(s.YTD_Opportunity_Close_Rate__c); 
                }else{
                   YtdCloseRatebelow.add(0); 
                }
               
                if(s.Goal_12m_rolling_close_rate__c != null){
                    YtdCloseRateGoalbelow.add(s.Goal_12m_rolling_close_rate__c); 
                }else{
                    YtdCloseRateGoalbelow.add(0); 
                }
                
                if(s.YTD_Opportunities_won__c != null){
                    YtdOppWonbelow.add(s.YTD_Opportunities_won__c);  
                }else{
                    YtdOppWonbelow.add(0);  
                }
                
                
                if(s.Goal_of_wins_to_achieve_monthly_quota__c != null && s.Current_Fiscal_Months__c != null){
                    YtdOppWonGoalbelow.add((s.Goal_of_wins_to_achieve_monthly_quota__c * s.Current_Fiscal_Months__c).setScale(0, RoundingMode.HALF_UP));  
                }else{
                    YtdOppWonGoalbelow.add(0);
                }
                    
                
                if(s.Goal_of_wins_to_achieve_monthly_quota__c != null && s.Goal_of_wins_to_achieve_monthly_quota__c != 0 && s.YTD_Opportunities_won__c != null){
                   OppPercentagebelow.add(s.YTD_Opportunities_won__c*100/(s.Goal_of_wins_to_achieve_monthly_quota__c * s.Current_Fiscal_Months__c).setScale(0, RoundingMode.HALF_UP) );
               } else{
                   OppPercentagebelow.add(0);
               }
               
                if(s.YTD_Revenue__c != null){
                    chartDatabelow.add(s.YTD_Revenue__c);
                }else{
                    chartDatabelow.add(0);
                }
                 
            }
            
          
               
        }
    } 
    
    public boolean disableLevelThree {get; set;}
        
   
    
    
    public PageReference reset(){
        
        //return FunnelNavigationHelper.navigateToReportsPage('','','','','','');
        return FunnelNavigationHelper.navigateToReportsPage('','','','','','','');
    }
    
    //Action method when level one is changed
    public void levelOneAction(){
        FunnelFilterHelper.levelOneAction(fw);
        defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw);
    }
    
    //Action method when level two is changed
    public void levelTwoAction(){
        FunnelFilterHelper.levelTwoAction(fw);
        defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw);
    }
        
    /*Navigation*/
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToDashboard(){
        
        //return FunnelNavigationHelper.navigateToDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToCalculator(){
        
        return FunnelNavigationHelper.navigateToCalculator(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToHomePage(){
        
         return FunnelNavigationHelper.navigateToHomePage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
        
    }
    
    //Method called on clicking Reporting on header    
    public PageReference navigateToReportsPage(){
        
        //return FunnelNavigationHelper.navigateToReportsPage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToReportsPage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToCertification(){
        
        //return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
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
    
    public PageReference navigateToSalesPipeline(){
        
        return FunnelNavigationHelper.navigateToSalesPipeline(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToTrendingByRep(){
        
        return FunnelNavigationHelper.navigateToTrendingByRep(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToTrndngRep(){
        
        return FunnelNavigationHelper.navigateToTrndngRep(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
        
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
    
    public PageReference navigateToGoals(){
        
        return FunnelNavigationHelper.navigateToGoalsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    //Added for Help Menu - Rohit
    public PageReference navigateToHelpMenu(){
        
        return FunnelNavigationHelper.navigateToHelpMenu();
    
    }
    /*Navigation*/ 
    
    /*Code for table*/
    
    /*public void showUpdated(){        
             
        system.debug('selectedLevelThree -----'+fw.selectedLevelThree );
        system.debug('label2 -----'+fw.labelTwo);
        //Aggregates of a particular level value need to be done
        if(fw.selectedLevelThree == 'All' && fw.labelTwo != 'Rep'){
            system.debug('Data1-----'  );
            //Fetch the sales profile record associated with that level
            List<Company_Level__c> cl = [SELECT Sales_Rep_Profile__c   FROM Company_Level__c WHERE Level_Value__c = : String.escapeSingleQuotes(fw.selectedLevelOne) LIMIT 1];
            
            system.debug('Sales_Rep_Profile__c '+cl);
            System.debug('Total Number of SOQL Queries allowed in this apex code context: ' + Limits.getQueries());
            mgr = true;
            Data(cl[0].Sales_Rep_Profile__c,'');
            
            System.debug('Total Number of SOQL Queries allowed in this apex code context: ' + Limits.getQueries());
            
            system.debug(' fetch table data for team ');
            fetchData('team');
            
            System.debug('Total Number of SOQL Queries allowed in this apex code context: ' + Limits.getQueries());
            
        }
        //A particular rep has been selected and his values need to be displayed
        //else if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All'){
        else if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo == 'All'){
            system.debug('Data2-----'  );
            //list<Sales_Rep_Profile__c> names = querySalesProfileAndPopulateWrapper(fw.selectedLevelTwo,null);   
            List<Company_Level__c> cl = [SELECT Sales_Rep_Profile__c FROM Company_Level__c WHERE Level_Value__c = : String.escapeSingleQuotes(fw.selectedLevelOne) LIMIT 1];
            System.debug('Total Number of SOQL Queries allowed in this apex code context: ' + Limits.getQueries());
            mgr = true;   
            Data(cl[0].Sales_Rep_Profile__c,'');
            
            System.debug('Total Number of SOQL Queries allowed in this apex code context: ' + Limits.getQueries());
            system.debug(' fetch table data for team ');
            fetchData('team');
            
            System.debug('Total Number of SOQL Queries allowed in this apex code context: ' + Limits.getQueries());
                     
        }else if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All'){
            system.debug('Data3-----'  );
            //list<Sales_Rep_Profile__c> names = querySalesProfileAndPopulateWrapper(fw.selectedLevelTwo,null);   
            List<Company_Level__c> cl = [SELECT Sales_Rep_Profile__c FROM Company_Level__c WHERE Level_Value__c = : String.escapeSingleQuotes(fw.selectedLevelOne) LIMIT 1];
            mgr = false;
            
            System.debug('Total Number of SOQL Queries allowed in this apex code context: ' + Limits.getQueries());
            
            Data(cl[0].Sales_Rep_Profile__c,fw.selectedLevelTwo);
            
            System.debug('Total Number of SOQL Queries allowed in this apex code context: ' + Limits.getQueries());
            
            system.debug(' single sales rep fetch table data ');
            fetchTableDataForRep(cl[0].Sales_Rep_Profile__c);     
            
            System.debug('Total Number of SOQL Queries allowed in this apex code context: ' + Limits.getQueries());        
        }
        //A particular role has been selected 
        else if (fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
            system.debug('role aggregates');
            mgr = true;
            
            fetchData('role');
            //aggregateOnRole();
        }
               
    }*/
    
    List<FunnelReportingTableWrapper> rows = new List<FunnelReportingTableWrapper>();
    
    public FunnelReportingTableWrapper header {get; set;}
            
    public FunnelReportingTableWrapper wins {get; set;}
    
    public FunnelReportingTableWrapper lost {get; set;}
    
    public FunnelReportingTableWrapper leads {get; set;}
    
    public FunnelReportingTableWrapper monthlyOppsAdded {get; set;}
    
    public FunnelReportingTableWrapper rollingOppsAdded {get; set;}
        
    public FunnelReportingTableWrapper rollingSalesCycle {get; set;}
    
    public FunnelReportingTableWrapper rollingWinSize {get; set;}
    
    Set<Id> teamIds = new Set<Id>();
                
    /*private void fetchData(String scenario){
        
        header = new FunnelReportingTableWrapper();
        wins = new FunnelReportingTableWrapper();
        lost = new FunnelReportingTableWrapper();
        leads = new FunnelReportingTableWrapper();
        monthlyOppsAdded = new FunnelReportingTableWrapper();
        rollingOppsAdded = new FunnelReportingTableWrapper();
        rollingSalesCycle = new FunnelReportingTableWrapper();
        rollingWinSize = new FunnelReportingTableWrapper();

        System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
        
        List<Company_Level_Junction_snapshot__c> spCLJun = [SELECT Snapshot_Scheduled_Date__c FROM Company_Level_Junction_snapshot__c  ORDER BY Snapshot_Scheduled_Date__c DESC LIMIT 1];
        
        if(spCLJun != null && spCLJun.size() > 0){
        
            Date schedDate;
            if(spCLJun != null && spCLJun.size() > 0){
                schedDate = spCLJun[0].Snapshot_Scheduled_Date__c;
            }

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            //Date schedDate = Date.today().addmonths(-1);        
            //Integer lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());        
            //schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay);        
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,1);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,1);    
            }

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            schedDate = schedDate.addMonths(-1);
            Integer lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,2);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,2);
            }

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,3);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,3);
            }

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,4);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,4);
            }

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
                        
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,5);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,5);
            }
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,6);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,6);
            }
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,7);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,7);
            }
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,8);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,8);
            }
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,9);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,9);
            }
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,10);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,10);
            }
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,11);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,11);
            }
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,12);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,12);
            }
                    
            Decimal avg = fetchAverage(wins);
            if(wins.decm1 == avg){
                wins.trend = 'equal';
            }
            else if(wins.decm1 > avg){
                wins.trend = 'up';
            }
            else{
                wins.trend = 'down';
            }
            
            avg = fetchAverage(monthlyOppsAdded);
            if(monthlyOppsAdded.decm1 == avg){
                monthlyOppsAdded.trend = 'equal';
            }
            else if(monthlyOppsAdded.decm1 > avg){
                monthlyOppsAdded.trend = 'up';
            }
            else{
                monthlyOppsAdded.trend = 'down';
            }
            
            avg = fetchAverage(rollingOppsAdded);
            if(rollingOppsAdded.decm1 == avg){
                rollingOppsAdded.trend = 'equal';
            }
            else if(rollingOppsAdded.decm1 > avg){
                rollingOppsAdded.trend = 'up';
            }
            else{
                rollingOppsAdded.trend = 'down';
            }
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            avg = fetchAverage(rollingSalesCycle);
            system.debug(' rollingSalesCycle.decm1  '+rollingSalesCycle.decm1);
            system.debug(' avg '+avg);

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(rollingSalesCycle.decm1 == avg){
                rollingSalesCycle.trend = 'equal';
            }
            else if(rollingSalesCycle.decm1 > avg){
                rollingSalesCycle.trend = 'up';
            }
            else{
                rollingSalesCycle.trend = 'down';
            }
            
            avg = fetchAverage(rollingWinSize);
            
            
            if(rollingWinSize.decm1 == avg){
                rollingWinSize.trend = 'equal';
            }
            else if(rollingWinSize.decm1 > avg){
                rollingWinSize.trend = 'up';
            }
            else{
                rollingWinSize.trend = 'down';
            }

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            avg = fetchAverage(leads);
            if(leads.decm1 == avg){
                leads.trend = 'equal';
            }
            else if(leads.decm1 > avg){
                leads.trend = 'up';
            }
            else{
                leads.trend = 'down';
            }        

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
           
            avg = fetchAverage(lost);
            if(lost.decm1 == avg){
                lost.trend = 'equal';
            }
            else if(lost.decm1 > avg){
                lost.trend = 'up';
            }
            else{
                lost.trend = 'down';
            }  

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            system.debug(' wins '+wins);
            system.debug(' monthlyOppsAdded '+monthlyOppsAdded);
            system.debug(' rollingOppsAdded '+rollingOppsAdded);
            system.debug(' rollingSalesCycle '+rollingSalesCycle);
            system.debug(' rollingWinSize '+rollingWinSize);
            system.debug(' leads '+leads);
            system.debug(' lost '+lost);
        }
    }
    
    
    private void fetchTableDataForTeam(Date scheduleDate, Integer month){
        
        String level = String.escapeSingleQuotes(fw.selectedLevelOne);
        List<Company_Level_Junction_snapshot__c> spCLJun = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Company_Level_Junction_snapshot__c  WHERE Snapshot_Scheduled_Date__c = :scheduleDate AND Company_Level__r.Level_Value__c = :level AND (Sales_rep_profile_snapshot__r.Active__c = TRUE OR Sales_rep_profile_snapshot__r.Annual_quota_amount__c > 0)];
        system.debug('scheduleDate '+scheduleDate);
        system.debug(' spCLJun '+spCLJun);

        //List<Company_Level_Junction_snapshot__c> spCLJunc = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c, Snapshot_Scheduled_Date__c,Company_Level__r.Level_Value__c, Sales_rep_profile_snapshot__c FROM Company_Level_Junction_snapshot__c];
        //system.debug(' spCLJunc '+spCLJunc);

        Set<id> srIds = new Set<id>();
        
        for(Company_Level_Junction_snapshot__c sj: spCLJun){
             srIds.add(sj.Sales_Rep_Profile__c);
        }
        
        AggregateResult result = [SELECT SUM(Monthly_opp_won__c) mw, SUM(Monthly_opp_lost__c) mo, SUM(Monthly_Lead_Added__c) la, SUM(Monthly_QO_added_Quantitative__c) ma, SUM(X12_Month_QO_added__c) mf, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Average_Selling_Price__c) sp, COUNT(id) cnt FROM Sales_Rep_Profile_Snapshot__c WHERE Snapshot_Scheduled_Date__c = :scheduleDate AND Sales_Rep_Profile__c IN : srIds AND Annual_quota_amount__c > 0 AND Profile_Type__c != 'Overlay'];
        
        system.debug(' aggregated result '+result);
        if(result != null && result.get('cnt') != null && (Integer)result.get('cnt') > 0)
            populateRowWrapperForAggregates(result,month,scheduleDate);
    }
    
    private void fetchTableDataForRole(Date scheduleDate, Integer month){
        
        system.debug(' fw.SelectedLevelOne '+fw.SelectedLevelOne);
        system.debug(' fw.SelectedLevelThree '+fw.SelectedLevelThree);
        system.debug(' scheduleDate '+scheduleDate);                
        
        //Fetch the records at the selected level and role
        List<Company_Level_Junction_snapshot__c> sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Company_Level_Junction_snapshot__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree AND Snapshot_Scheduled_Date__c = :scheduleDate AND (Sales_rep_profile_snapshot__r.Active__c = TRUE OR Sales_rep_profile_snapshot__r.Annual_quota_amount__c > 0)];                
        
        system.debug(' sReps '+sReps);
        
        Set<String> levels = new Set<String>();
        
        //List to store the ids of the reps to be aggregated
        Set<ID> aggregateIds = new Set<Id>();
        
        Set<ID> profIds = new Set<Id>();
        
        //Store the profile ids of the managers
        for(Company_Level_Junction_snapshot__c s: sReps){
            profIds.add(s.Sales_Rep_Profile__c);
            aggregateIds.add(s.Sales_Rep_Profile__c);
        }
                
        levels.clear();
        //Fetch the company levels associated with the sales profiles
        if(profIds != null && profIds.size()>0){
            List<Company_Levels_snapshot__c> cl = [SELECT id, Level_Value__c FROM Company_Levels_snapshot__c WHERE Sales_Rep_Profile__c IN :profIds AND Snapshot_Scheduled_Date__c = :scheduleDate];
            
            //Store all the levels associated with the managers
            for(Company_Levels_snapshot__c c: cl){
                levels.add(c.Level_Value__c);
            }
        }
        //Fetch the sales profiles associated with the levels
        if(levels != null && levels.size()>0){
            sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Company_Level_Junction_snapshot__c WHERE Company_Level__r.Level_Value__c IN :levels AND Snapshot_Scheduled_Date__c = :scheduleDate];
                    
            //Add the sales profiles to the ids to be aggregated        
            for(Company_Level_Junction_snapshot__c s: sReps){
                aggregateIds.add(s.Sales_Rep_Profile__c);
            }                
        }
        system.debug(' aggregateIds '+aggregateIds);
        if(aggregateIds != null && aggregateIds.size()>0){
        
            AggregateResult result;
            if(RoleOverlay){
              result = [SELECT SUM(Monthly_opp_won__c) mw, SUM(Monthly_opp_lost__c) mo, SUM(Monthly_Lead_Added__c) la, SUM(Monthly_QO_added_Quantitative__c) ma, SUM(X12_Month_QO_added__c) mf, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Average_Selling_Price__c) sp, COUNT(id) cnt FROM Sales_Rep_Profile_Snapshot__c WHERE Snapshot_Scheduled_Date__c = :scheduleDate AND Sales_Rep_Profile__c IN : aggregateIds AND Annual_quota_amount__c > 0  ];
            }else{
                result = [SELECT SUM(Monthly_opp_won__c) mw, SUM(Monthly_opp_lost__c) mo, SUM(Monthly_Lead_Added__c) la, SUM(Monthly_QO_added_Quantitative__c) ma, SUM(X12_Month_QO_added__c) mf, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Average_Selling_Price__c) sp, COUNT(id) cnt FROM Sales_Rep_Profile_Snapshot__c WHERE Snapshot_Scheduled_Date__c = :scheduleDate AND Sales_Rep_Profile__c IN : aggregateIds AND Annual_quota_amount__c > 0  AND Profile_Type__c != 'Overlay'];
            }
            
            
            system.debug(' aggregated result '+result);
            if(result != null && result.get('cnt') != null && (Integer)result.get('cnt') > 0)
                populateRowWrapperForAggregates(result,month,scheduleDate);
        }
    }*/
    
    Date schedDate;    
    Date schedDate0;        
    Date schedDate1;
    Date schedDate2;
    Date schedDate3;
    Date schedDate4;
    Date schedDate5;
    Date schedDate6;
    Date schedDate7;
    Date schedDate8;
    Date schedDate9;
    Date schedDate10;
    Date schedDate11;
    Map<Date,Set<id>> profDateMap = new Map<Date,Set<id>>();
    
    private void fetchData(String scenario){
        
        header = new FunnelReportingTableWrapper();
        wins = new FunnelReportingTableWrapper();
        lost = new FunnelReportingTableWrapper();
        leads = new FunnelReportingTableWrapper();
        monthlyOppsAdded = new FunnelReportingTableWrapper();
        rollingOppsAdded = new FunnelReportingTableWrapper();
        rollingSalesCycle = new FunnelReportingTableWrapper();
        rollingWinSize = new FunnelReportingTableWrapper();
        
        List<Company_Level_Junction_snapshot__c> spCLJun = [SELECT Snapshot_Scheduled_Date__c FROM Company_Level_Junction_snapshot__c  ORDER BY Snapshot_Scheduled_Date__c DESC LIMIT 1];
        
        if(spCLJun != null && spCLJun.size() > 0){
            
            schedDate = spCLJun[0].Snapshot_Scheduled_Date__c;
        
            schedDate0 = schedDate;
            
            schedDate = schedDate.addMonths(-1);
            Integer lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            schedDate1 = schedDate;
    
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            schedDate2 = schedDate;
            
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
    
            schedDate3 = schedDate;
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            schedDate4 = schedDate;
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            schedDate5 = schedDate;
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            schedDate6 = schedDate;
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            schedDate7 = schedDate;
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            schedDate8 = schedDate;
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            schedDate9 = schedDate;
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            schedDate10 = schedDate;
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            schedDate11 = schedDate;
                
            Set<String> levels = new Set<String>();
            
            //List to store the ids of the reps to be aggregated
            Set<ID> aggregateIds = new Set<Id>();
            Set<ID> aggregateIds1 = new Set<Id>();
            Set<ID> aggregateIds2 = new Set<Id>();
            Set<ID> aggregateIds3 = new Set<Id>();
            Set<ID> aggregateIds4 = new Set<Id>();
            Set<ID> aggregateIds5 = new Set<Id>();
            Set<ID> aggregateIds6 = new Set<Id>();
            Set<ID> aggregateIds7 = new Set<Id>();
            Set<ID> aggregateIds8 = new Set<Id>();
            Set<ID> aggregateIds9 = new Set<Id>();
            Set<ID> aggregateIds10 = new Set<Id>();
            Set<ID> aggregateIds11 = new Set<Id>();
            
            Set<ID> profIds = new Set<Id>();
            Set<ID> profIds1 = new Set<Id>();
            Set<ID> profIds2 = new Set<Id>();
            Set<ID> profIds3 = new Set<Id>();
            Set<ID> profIds4 = new Set<Id>();
            Set<ID> profIds5 = new Set<Id>();
            Set<ID> profIds6 = new Set<Id>();
            Set<ID> profIds7 = new Set<Id>();
            Set<ID> profIds8 = new Set<Id>();
            Set<ID> profIds9 = new Set<Id>();
            Set<ID> profIds10 = new Set<Id>();
            Set<ID> profIds11 = new Set<Id>();
                        
            Set<ID> profIdsT = new Set<Id>();
            Set<ID> profIds1T = new Set<Id>();
            Set<ID> profIds2T = new Set<Id>();
            Set<ID> profIds3T = new Set<Id>();
            Set<ID> profIds4T = new Set<Id>();
            Set<ID> profIds5T = new Set<Id>();
            Set<ID> profIds6T = new Set<Id>();
            Set<ID> profIds7T = new Set<Id>();
            Set<ID> profIds8T = new Set<Id>();
            Set<ID> profIds9T = new Set<Id>();
            Set<ID> profIds10T = new Set<Id>();
            Set<ID> profIds11T = new Set<Id>();
            
            if(scenario == 'role'){
                
                system.debug(' fw.SelectedLevelOne '+fw.SelectedLevelOne);
                system.debug(' fw.SelectedLevelThree '+fw.SelectedLevelThree);
                system.debug(' schedDate0 '+schedDate0);
                system.debug(' schedDate1 '+schedDate1);
                system.debug(' schedDate2 '+schedDate2);
                
                //Fetch the records at the selected level and role
                List<Company_Level_Junction_snapshot__c> sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c, Snapshot_Scheduled_Date__c FROM Company_Level_Junction_snapshot__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree 
                AND (Snapshot_Scheduled_Date__c = :schedDate0 OR Snapshot_Scheduled_Date__c = :schedDate1 OR Snapshot_Scheduled_Date__c = :schedDate2 OR Snapshot_Scheduled_Date__c = :schedDate3 OR Snapshot_Scheduled_Date__c = :schedDate4 OR Snapshot_Scheduled_Date__c = :schedDate5 OR Snapshot_Scheduled_Date__c = :schedDate6 OR Snapshot_Scheduled_Date__c = :schedDate7 OR Snapshot_Scheduled_Date__c = :schedDate8 OR Snapshot_Scheduled_Date__c = :schedDate9 OR Snapshot_Scheduled_Date__c = :schedDate10 OR Snapshot_Scheduled_Date__c = :schedDate11)       
                AND (Sales_rep_profile_snapshot__r.Active__c = TRUE OR Sales_rep_profile_snapshot__r.Annual_quota_amount__c > 0)];                
                
                /*
                system.debug(' sReps '+sReps);
                
                sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Company_Level_Junction_snapshot__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree 
                AND (Snapshot_Scheduled_Date__c = :schedDate0 OR Snapshot_Scheduled_Date__c = :schedDate1 OR Snapshot_Scheduled_Date__c = :schedDate2 OR Snapshot_Scheduled_Date__c = :schedDate3 OR Snapshot_Scheduled_Date__c = :schedDate4 OR Snapshot_Scheduled_Date__c = :schedDate5 OR Snapshot_Scheduled_Date__c = :schedDate6 OR Snapshot_Scheduled_Date__c = :schedDate7 OR Snapshot_Scheduled_Date__c = :schedDate8 OR Snapshot_Scheduled_Date__c = :schedDate9 OR Snapshot_Scheduled_Date__c = :schedDate10 OR Snapshot_Scheduled_Date__c = :schedDate11)       
                ];                
                
                system.debug(' sReps '+sReps);
                
                sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c, Snapshot_scheduled_date__c FROM Company_Level_Junction_snapshot__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree 
                ];                
                
                system.debug(' sReps '+sReps);
                
                sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c, Snapshot_scheduled_date__c FROM Company_Level_Junction_snapshot__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne 
                ];                
                
                system.debug(' sReps '+sReps);
                
                sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_rep_profile_snapshot__r.Active__c, Sales_Rep_Profile__r.Role__c, Sales_Rep_Profile__r.Sales_Manager__c, Company_Level__c, Company_Level__r.Level_Value__c, Snapshot_scheduled_date__c FROM Company_Level_Junction_snapshot__c 
                ];                
                
                system.debug(' sReps '+sReps);
                
                
                for(Company_Level_Junction_snapshot__c s: sReps){
                    system.debug(' Snapshot_scheduled_date__c '+s.Snapshot_scheduled_date__c);
                    system.debug(' Company_Level__r.Level_Value__c '+s.Company_Level__r.Level_Value__c);
                    system.debug(' Sales_Rep_Profile__r.Role__c '+s.Sales_Rep_Profile__r.Role__c);
                    system.debug(' Sales_rep_profile_snapshot__r.Active__c '+s.Sales_rep_profile_snapshot__r.Active__c);
                } */
                        
                //Store the profile ids of the managers
                for(Company_Level_Junction_snapshot__c s: sReps){
                
                    if(s.Snapshot_Scheduled_Date__c == schedDate0){
                        
                        if(profDateMap.keySet().contains(schedDate0)){
                            profDateMap.get(schedDate0).add(s.Sales_rep_profile__c);
                        }
                        else{
                            Set<Id> pro = new Set<id>();
                            pro.add(s.Sales_rep_profile__c);
                            
                            profDateMap.put(schedDate0,pro);
                        }
                        
                        profIds.add(s.Sales_Rep_Profile__c);
                        aggregateIds.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate1){
                    
                        if(profDateMap.keySet().contains(schedDate1)){
                            profDateMap.get(schedDate1).add(s.Sales_rep_profile__c);
                        }
                        else{
                            Set<Id> pro = new Set<id>();
                            pro.add(s.Sales_rep_profile__c);
                            
                            profDateMap.put(schedDate1,pro);
                        }
                        profIds1.add(s.Sales_Rep_Profile__c);
                        aggregateIds1.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate2){
                        
                        if(profDateMap.keySet().contains(schedDate2)){
                            profDateMap.get(schedDate2).add(s.Sales_rep_profile__c);
                        }
                        else{
                            Set<Id> pro = new Set<id>();
                            pro.add(s.Sales_rep_profile__c);
                            
                            profDateMap.put(schedDate2,pro);
                        }
                        
                        profIds2.add(s.Sales_Rep_Profile__c);
                        aggregateIds2.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate3){
                        
                        if(profDateMap.keySet().contains(schedDate3)){
                            profDateMap.get(schedDate3).add(s.Sales_rep_profile__c);
                        }
                        else{
                            Set<Id> pro = new Set<id>();
                            pro.add(s.Sales_rep_profile__c);
                            
                            profDateMap.put(schedDate3,pro);
                        }
                        
                        profIds3.add(s.Sales_Rep_Profile__c);
                        aggregateIds3.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate4){
                    
                        if(profDateMap.keySet().contains(schedDate4)){
                            profDateMap.get(schedDate4).add(s.Sales_rep_profile__c);
                        }
                        else{
                            Set<Id> pro = new Set<id>();
                            pro.add(s.Sales_rep_profile__c);
                            
                            profDateMap.put(schedDate4,pro);
                        }
                        
                        profIds4.add(s.Sales_Rep_Profile__c);
                        aggregateIds4.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate5){
                        
                        if(profDateMap.keySet().contains(schedDate5)){
                            profDateMap.get(schedDate5).add(s.Sales_rep_profile__c);
                        }
                        else{
                            Set<Id> pro = new Set<id>();
                            pro.add(s.Sales_rep_profile__c);
                            
                            profDateMap.put(schedDate5,pro);
                        }
                        
                        profIds5.add(s.Sales_Rep_Profile__c);
                        aggregateIds5.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate6){
                        
                        if(profDateMap.keySet().contains(schedDate6)){
                            profDateMap.get(schedDate6).add(s.Sales_rep_profile__c);
                        }
                        else{
                            Set<Id> pro = new Set<id>();
                            pro.add(s.Sales_rep_profile__c);
                            
                            profDateMap.put(schedDate6,pro);
                        }
                        
                        profIds6.add(s.Sales_Rep_Profile__c);
                        aggregateIds6.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate7){
                        
                        if(profDateMap.keySet().contains(schedDate7)){
                            profDateMap.get(schedDate7).add(s.Sales_rep_profile__c);
                        }
                        else{
                            Set<Id> pro = new Set<id>();
                            pro.add(s.Sales_rep_profile__c);
                            
                            profDateMap.put(schedDate7,pro);
                        }
                        
                        profIds7.add(s.Sales_Rep_Profile__c);
                        aggregateIds7.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate8){
                        
                        if(profDateMap.keySet().contains(schedDate8)){
                            profDateMap.get(schedDate8).add(s.Sales_rep_profile__c);
                        }
                        else{
                            Set<Id> pro = new Set<id>();
                            pro.add(s.Sales_rep_profile__c);
                            
                            profDateMap.put(schedDate8,pro);
                        }
                        
                        profIds8.add(s.Sales_Rep_Profile__c);
                        aggregateIds8.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate9){
                        
                        if(profDateMap.keySet().contains(schedDate9)){
                            profDateMap.get(schedDate9).add(s.Sales_rep_profile__c);
                        }
                        else{
                            Set<Id> pro = new Set<id>();
                            pro.add(s.Sales_rep_profile__c);
                            
                            profDateMap.put(schedDate9,pro);
                        }
                        
                        profIds9.add(s.Sales_Rep_Profile__c);
                        aggregateIds9.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate10){
                        
                        if(profDateMap.keySet().contains(schedDate10)){
                            profDateMap.get(schedDate10).add(s.Sales_rep_profile__c);
                        }
                        else{
                            Set<Id> pro = new Set<id>();
                            pro.add(s.Sales_rep_profile__c);
                            
                            profDateMap.put(schedDate10,pro);
                        }
                        
                        profIds10.add(s.Sales_Rep_Profile__c);
                        aggregateIds10.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate11){
                        
                        if(profDateMap.keySet().contains(schedDate11)){
                            profDateMap.get(schedDate11).add(s.Sales_rep_profile__c);
                        }
                        else{
                            Set<Id> pro = new Set<id>();
                            pro.add(s.Sales_rep_profile__c);
                            
                            profDateMap.put(schedDate11,pro);
                        }
                        
                        profIds11.add(s.Sales_Rep_Profile__c);
                        aggregateIds11.add(s.Sales_Rep_Profile__c);
                    }
                }
                fetchLevels();
            }
            
            
            if(scenario == 'team'){
                
                String level = String.escapeSingleQuotes(fw.selectedLevelOne);
                List<Company_Level_Junction_snapshot__c> CLJun = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c,Snapshot_Scheduled_Date__c FROM Company_Level_Junction_snapshot__c  
                WHERE (Snapshot_Scheduled_Date__c = :schedDate0 OR Snapshot_Scheduled_Date__c = :schedDate1 OR Snapshot_Scheduled_Date__c = :schedDate2 OR Snapshot_Scheduled_Date__c = :schedDate3 OR Snapshot_Scheduled_Date__c = :schedDate4 OR Snapshot_Scheduled_Date__c = :schedDate5 OR Snapshot_Scheduled_Date__c = :schedDate6 OR Snapshot_Scheduled_Date__c = :schedDate7 OR Snapshot_Scheduled_Date__c = :schedDate8 OR Snapshot_Scheduled_Date__c = :schedDate9 OR Snapshot_Scheduled_Date__c = :schedDate10 OR Snapshot_Scheduled_Date__c = :schedDate11)       
                AND Company_Level__r.Level_Value__c = :level AND (Sales_rep_profile_snapshot__r.Active__c = TRUE OR Sales_rep_profile_snapshot__r.Annual_quota_amount__c > 0)];
                                        
                for(Company_Level_Junction_snapshot__c s: CLJun){
                    
                    if(s.Snapshot_Scheduled_Date__c == schedDate0){
                        profIdsT.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate1){
                        profIds1T.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate2){
                        profIds2T.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate3){
                        profIds3T.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate4){
                        profIds4T.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate5){
                        profIds5T.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate6){
                        profIds6T.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate7){
                        profIds7T.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate8){
                        profIds8T.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate9){
                        profIds9T.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate10){
                        profIds10T.add(s.Sales_Rep_Profile__c);
                    }
                    else if(s.Snapshot_Scheduled_Date__c == schedDate11){
                        profIds11T.add(s.Sales_Rep_Profile__c);
                    }
                }
            }
            
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
                
            if(scenario == 'team'){
                fetchTableDataForTeam1(profIdsT,schedDate0,1);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole1(profIds, aggregateIds,schedDate0,1);    
            }
                    
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam1(profIds1T,schedDate1,2);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole1(profIds1, aggregateIds1,schedDate1,2);    
            }
                   
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam1(profIds2T,schedDate2,3);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole1(profIds2, aggregateIds2,schedDate2,3);    
            }
               
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam1(profIds3T,schedDate3,4);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole1(profIds3, aggregateIds3,schedDate3,4);    
            }
            
            
            
            if(scenario == 'team'){
                fetchTableDataForTeam1(profIds4T,schedDate4,5);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole1(profIds4, aggregateIds4,schedDate4,5);    
            }
            
            
            
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam1(profIds5T,schedDate5,6);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole1(profIds5, aggregateIds5,schedDate5,6);    
            }
            
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam1(profIds6T,schedDate6,7);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole1(profIds6, aggregateIds6,schedDate6,7);    
            }
            
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam1(profIds7T,schedDate7,8);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole1(profIds7, aggregateIds7,schedDate7,8);    
            }
            
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam1(profIds8T,schedDate8,9);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole1(profIds8, aggregateIds8,schedDate8,9);    
            }
            
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
           
            if(scenario == 'team'){
                fetchTableDataForTeam1(profIds9T,schedDate9,10);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole1(profIds9, aggregateIds9,schedDate9,10);    
            }
            
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam1(profIds10T,schedDate10,11);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole1(profIds10, aggregateIds10,schedDate10,11);    
            }
                
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
           
            if(scenario == 'team'){
                fetchTableDataForTeam1(profIds11T,schedDate11,12);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole1(profIds11, aggregateIds11,schedDate11,12);    
            }
            
            Decimal avg = fetchAverage(wins);
            if(wins.decm1 == avg){
                wins.trend = 'equal';
            }
            else if(wins.decm1 > avg){
                wins.trend = 'up';
            }
            else{
                wins.trend = 'down';
            }
            
            avg = fetchAverage(monthlyOppsAdded);
            if(monthlyOppsAdded.decm1 == avg){
                monthlyOppsAdded.trend = 'equal';
            }
            else if(monthlyOppsAdded.decm1 > avg){
                monthlyOppsAdded.trend = 'up';
            }
            else{
                monthlyOppsAdded.trend = 'down';
            }
            
            avg = fetchAverage(rollingOppsAdded);
            if(rollingOppsAdded.decm1 == avg){
                rollingOppsAdded.trend = 'equal';
            }
            else if(rollingOppsAdded.decm1 > avg){
                rollingOppsAdded.trend = 'up';
            }
            else{
                rollingOppsAdded.trend = 'down';
            }
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            avg = fetchAverage(rollingSalesCycle);
            system.debug(' rollingSalesCycle.decm1  '+rollingSalesCycle.decm1);
            system.debug(' avg '+avg);

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(rollingSalesCycle.decm1 == avg){
                rollingSalesCycle.trend = 'equal';
            }
            else if(rollingSalesCycle.decm1 > avg){
                rollingSalesCycle.trend = 'up';
            }
            else{
                rollingSalesCycle.trend = 'down';
            }
            
            avg = fetchAverage(rollingWinSize);
            
            
            if(rollingWinSize.decm1 == avg){
                rollingWinSize.trend = 'equal';
            }
            else if(rollingWinSize.decm1 > avg){
                rollingWinSize.trend = 'up';
            }
            else{
                rollingWinSize.trend = 'down';
            }

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            avg = fetchAverage(leads);
            if(leads.decm1 == avg){
                leads.trend = 'equal';
            }
            else if(leads.decm1 > avg){
                leads.trend = 'up';
            }
            else{
                leads.trend = 'down';
            }        

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
           
            avg = fetchAverage(lost);
            if(lost.decm1 == avg){
                lost.trend = 'equal';
            }
            else if(lost.decm1 > avg){
                lost.trend = 'up';
            }
            else{
                lost.trend = 'down';
            } 
       }  
        /*if(spCLJun != null && spCLJun.size() > 0){
        
            Date schedDate;
            if(spCLJun != null && spCLJun.size() > 0){
                schedDate = spCLJun[0].Snapshot_Scheduled_Date__c;
            }

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,1);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,1);    
            }

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            schedDate = schedDate.addMonths(-1);
            Integer lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,2);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,2);
            }

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,3);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,3);
            }

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,4);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,4);
            }

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
                        
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,5);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,5);
            }
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,6);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,6);
            }
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,7);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,7);
            }
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,8);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,8);
            }
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,9);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,9);
            }
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,10);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,10);
            }
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,11);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,11);
            }
            
            schedDate = schedDate.addMonths(-1);
            lastDay = Date.daysInMonth(schedDate.year(), schedDate.month());
            schedDate = Date.newInstance(schedDate.year(), schedDate.month(), lastDay); 

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(scenario == 'team'){
                fetchTableDataForTeam(schedDate,12);
            }
            else if(scenario == 'role'){
                fetchTableDataForRole(schedDate,12);
            }
                    
            Decimal avg = fetchAverage(wins);
            if(wins.decm1 == avg){
                wins.trend = 'equal';
            }
            else if(wins.decm1 > avg){
                wins.trend = 'up';
            }
            else{
                wins.trend = 'down';
            }
            
            avg = fetchAverage(monthlyOppsAdded);
            if(monthlyOppsAdded.decm1 == avg){
                monthlyOppsAdded.trend = 'equal';
            }
            else if(monthlyOppsAdded.decm1 > avg){
                monthlyOppsAdded.trend = 'up';
            }
            else{
                monthlyOppsAdded.trend = 'down';
            }
            
            avg = fetchAverage(rollingOppsAdded);
            if(rollingOppsAdded.decm1 == avg){
                rollingOppsAdded.trend = 'equal';
            }
            else if(rollingOppsAdded.decm1 > avg){
                rollingOppsAdded.trend = 'up';
            }
            else{
                rollingOppsAdded.trend = 'down';
            }
            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            avg = fetchAverage(rollingSalesCycle);
            system.debug(' rollingSalesCycle.decm1  '+rollingSalesCycle.decm1);
            system.debug(' avg '+avg);

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            if(rollingSalesCycle.decm1 == avg){
                rollingSalesCycle.trend = 'equal';
            }
            else if(rollingSalesCycle.decm1 > avg){
                rollingSalesCycle.trend = 'up';
            }
            else{
                rollingSalesCycle.trend = 'down';
            }
            
            avg = fetchAverage(rollingWinSize);
            
            
            if(rollingWinSize.decm1 == avg){
                rollingWinSize.trend = 'equal';
            }
            else if(rollingWinSize.decm1 > avg){
                rollingWinSize.trend = 'up';
            }
            else{
                rollingWinSize.trend = 'down';
            }

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            avg = fetchAverage(leads);
            if(leads.decm1 == avg){
                leads.trend = 'equal';
            }
            else if(leads.decm1 > avg){
                leads.trend = 'up';
            }
            else{
                leads.trend = 'down';
            }        

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
           
            avg = fetchAverage(lost);
            if(lost.decm1 == avg){
                lost.trend = 'equal';
            }
            else if(lost.decm1 > avg){
                lost.trend = 'up';
            }
            else{
                lost.trend = 'down';
            }  

            System.debug('Number of Queries used in this apex code so far: ' + Limits.getQueries());
            
            system.debug(' wins '+wins);
            system.debug(' monthlyOppsAdded '+monthlyOppsAdded);
            system.debug(' rollingOppsAdded '+rollingOppsAdded);
            system.debug(' rollingSalesCycle '+rollingSalesCycle);
            system.debug(' rollingWinSize '+rollingWinSize);
            system.debug(' leads '+leads);
            system.debug(' lost '+lost);
        }*/
    }
    
    private void fetchTableDataForTeam1(Set<id> srIds, Date scheduleDate, Integer month){
        
        /*String level = String.escapeSingleQuotes(fw.selectedLevelOne);
        List<Company_Level_Junction_snapshot__c> spCLJun = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Company_Level_Junction_snapshot__c  WHERE Snapshot_Scheduled_Date__c = :scheduleDate AND Company_Level__r.Level_Value__c = :level AND (Sales_rep_profile_snapshot__r.Active__c = TRUE OR Sales_rep_profile_snapshot__r.Annual_quota_amount__c > 0)];
        system.debug('scheduleDate '+scheduleDate);
        system.debug(' spCLJun '+spCLJun);

        Set<id> srIds = new Set<id>();
        
        for(Company_Level_Junction_snapshot__c sj: spCLJun){
             srIds.add(sj.Sales_Rep_Profile__c);
        }*/
        
        AggregateResult result = [SELECT SUM(Monthly_opp_won__c) mw, SUM(Monthly_opp_lost__c) mo, SUM(Monthly_Lead_Added__c) la, SUM(Monthly_QO_added_Quantitative__c) ma, SUM(X12_Month_QO_added__c) mf, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Average_Selling_Price__c) sp, COUNT(id) cnt FROM Sales_Rep_Profile_Snapshot__c WHERE Snapshot_Scheduled_Date__c = :scheduleDate AND Sales_Rep_Profile__c IN : srIds AND Annual_quota_amount__c > 0 AND Profile_Type__c != 'Overlay'];
        
        system.debug(' aggregated result '+result);
        if(result != null && result.get('cnt') != null && (Integer)result.get('cnt') > 0)
            populateRowWrapperForAggregates(result,month,scheduleDate);
    }
    
    /*private void fetchTableDataForTeam(Date scheduleDate, Integer month){
        
        String level = String.escapeSingleQuotes(fw.selectedLevelOne);
        List<Company_Level_Junction_snapshot__c> spCLJun = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Company_Level_Junction_snapshot__c  WHERE Snapshot_Scheduled_Date__c = :scheduleDate AND Company_Level__r.Level_Value__c = :level AND (Sales_rep_profile_snapshot__r.Active__c = TRUE OR Sales_rep_profile_snapshot__r.Annual_quota_amount__c > 0)];
        system.debug('scheduleDate '+scheduleDate);
        system.debug(' spCLJun '+spCLJun);

        //List<Company_Level_Junction_snapshot__c> spCLJunc = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c, Snapshot_Scheduled_Date__c,Company_Level__r.Level_Value__c, Sales_rep_profile_snapshot__c FROM Company_Level_Junction_snapshot__c];
        //system.debug(' spCLJunc '+spCLJunc);

        Set<id> srIds = new Set<id>();
        
        for(Company_Level_Junction_snapshot__c sj: spCLJun){
             srIds.add(sj.Sales_Rep_Profile__c);
        }
        
        AggregateResult result = [SELECT SUM(Monthly_opp_won__c) mw, SUM(Monthly_opp_lost__c) mo, SUM(Monthly_Lead_Added__c) la, SUM(Monthly_QO_added_Quantitative__c) ma, SUM(X12_Month_QO_added__c) mf, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Average_Selling_Price__c) sp, COUNT(id) cnt FROM Sales_Rep_Profile_Snapshot__c WHERE Snapshot_Scheduled_Date__c = :scheduleDate AND Sales_Rep_Profile__c IN : srIds AND Annual_quota_amount__c > 0 AND Profile_Type__c != 'Overlay'];
        
        system.debug(' aggregated result '+result);
        if(result != null && result.get('cnt') != null && (Integer)result.get('cnt') > 0)
            populateRowWrapperForAggregates(result,month,scheduleDate);
    }*/
    
    private void fetchTableDataForRole1(Set<ID> profIds, Set<ID> aggregateIds, Date scheduleDate, Integer month){
        
        /*
        //Fetch the records at the selected level and role
        List<Company_Level_Junction_snapshot__c> sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Company_Level_Junction_snapshot__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree AND Snapshot_Scheduled_Date__c = :scheduleDate AND (Sales_rep_profile_snapshot__r.Active__c = TRUE OR Sales_rep_profile_snapshot__r.Annual_quota_amount__c > 0)];                
        
        system.debug(' sReps '+sReps);
                
        //List to store the ids of the reps to be aggregated
        Set<ID> aggregateIds = new Set<Id>();
        
        Set<ID> profIds = new Set<Id>();
        
        //Store the profile ids of the managers
        for(Company_Level_Junction_snapshot__c s: sReps){
            profIds.add(s.Sales_Rep_Profile__c);
            aggregateIds.add(s.Sales_Rep_Profile__c);
        }
        */
        // Can reduce 
        
        
        Set<String> levels = new Set<String>();
        
        levels.clear();
        
        /*
        List<Company_Level_Junction_snapshot__c> sReps;
        
        //Fetch the company levels associated with the sales profiles
        if(profIds != null && profIds.size()>0){
            List<Company_Levels_snapshot__c> cl = [SELECT id, Level_Value__c FROM Company_Levels_snapshot__c WHERE Sales_Rep_Profile__c IN :profIds AND Snapshot_Scheduled_Date__c = :scheduleDate];
            
            //Store all the levels associated with the managers
            for(Company_Levels_snapshot__c c: cl){
                levels.add(c.Level_Value__c);
            }
        }*/
        
        levels = mapLevels.get(scheduleDate);
        
        List<Company_Level_Junction_snapshot__c> sReps;
        
        //Fetch the sales profiles associated with the levels // Can reduce 
        if(levels != null && levels.size()>0){
            sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Company_Level_Junction_snapshot__c WHERE Company_Level__r.Level_Value__c IN :levels AND Snapshot_Scheduled_Date__c = :scheduleDate];
                    
            //Add the sales profiles to the ids to be aggregated        
            for(Company_Level_Junction_snapshot__c s: sReps){
                aggregateIds.add(s.Sales_Rep_Profile__c);
            }                
        }
        system.debug(' aggregateIds '+aggregateIds);
        if(aggregateIds != null && aggregateIds.size()>0){
        
            AggregateResult result;
            if(RoleOverlay){
              result = [SELECT SUM(Monthly_opp_won__c) mw, SUM(Monthly_opp_lost__c) mo, SUM(Monthly_Lead_Added__c) la, SUM(Monthly_QO_added_Quantitative__c) ma, SUM(X12_Month_QO_added__c) mf, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Average_Selling_Price__c) sp, COUNT(id) cnt FROM Sales_Rep_Profile_Snapshot__c WHERE Snapshot_Scheduled_Date__c = :scheduleDate AND Sales_Rep_Profile__c IN : aggregateIds AND Annual_quota_amount__c > 0  ];
            }else{
                result = [SELECT SUM(Monthly_opp_won__c) mw, SUM(Monthly_opp_lost__c) mo, SUM(Monthly_Lead_Added__c) la, SUM(Monthly_QO_added_Quantitative__c) ma, SUM(X12_Month_QO_added__c) mf, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Average_Selling_Price__c) sp, COUNT(id) cnt FROM Sales_Rep_Profile_Snapshot__c WHERE Snapshot_Scheduled_Date__c = :scheduleDate AND Sales_Rep_Profile__c IN : aggregateIds AND Annual_quota_amount__c > 0  AND Profile_Type__c != 'Overlay'];
            }
            
           
            system.debug(' aggregated result '+result);
            if(result != null && result.get('cnt') != null && (Integer)result.get('cnt') > 0)
                populateRowWrapperForAggregates(result,month,scheduleDate);
        }
    }
    
    Map<Date,Set<String>> mapLevels = new Map<Date,Set<String>>();
    
    private void fetchLevels(){

        List<Company_Levels_snapshot__c> cl = [SELECT id, Level_Value__c, Sales_rep_profile__c, Snapshot_Scheduled_Date__c FROM Company_Levels_snapshot__c 
        WHERE (Snapshot_Scheduled_Date__c = :schedDate0 OR Snapshot_Scheduled_Date__c = :schedDate1 OR Snapshot_Scheduled_Date__c = :schedDate2 OR Snapshot_Scheduled_Date__c = :schedDate3 OR Snapshot_Scheduled_Date__c = :schedDate4 OR Snapshot_Scheduled_Date__c = :schedDate5 OR Snapshot_Scheduled_Date__c = :schedDate6 OR Snapshot_Scheduled_Date__c = :schedDate7 OR Snapshot_Scheduled_Date__c = :schedDate8 OR Snapshot_Scheduled_Date__c = :schedDate9 OR Snapshot_Scheduled_Date__c = :schedDate10 OR Snapshot_Scheduled_Date__c = :schedDate11)];
        
        for(Company_Levels_snapshot__c c:cl){
            if(profDateMap.get(c.Snapshot_Scheduled_Date__c).contains(c.Sales_rep_profile__c)){
                if(mapLevels.containsKey(c.Snapshot_Scheduled_Date__c)){
                    mapLevels.get(c.Snapshot_Scheduled_Date__c).add(c.Level_Value__c);
                }
                else{
                    Set<String> levs = new Set<String>();
                    levs.add(c.Level_value__c);
                    
                    mapLevels.put(c.Snapshot_Scheduled_Date__c,levs);
                }
                
            }
        }
    }
    
    private void fetchTableDataForRep(Id srId){
        
        header = new FunnelReportingTableWrapper();
        wins = new FunnelReportingTableWrapper();
        lost = new FunnelReportingTableWrapper();
        leads = new FunnelReportingTableWrapper();
        monthlyOppsAdded = new FunnelReportingTableWrapper();
        rollingOppsAdded = new FunnelReportingTableWrapper();
        rollingSalesCycle = new FunnelReportingTableWrapper();
        rollingWinSize = new FunnelReportingTableWrapper();
                    
        List<Sales_Rep_Profile_Snapshot__c> s = [SELECT Snapshot_Scheduled_Date__c, Sales_Rep_Profile__c, Monthly_opp_won__c, Monthly_opp_lost__c, Monthly_Lead_Added__c, Monthly_QO_added_Quantitative__c, X12_Month_QO_added__c, X12_Month_Rolling_Average_Sales_Cycle__c, X12_Month_Average_Selling_Price__c FROM Sales_Rep_Profile_Snapshot__c WHERE Sales_Rep_Profile__c = :srId ORDER BY Snapshot_Scheduled_Date__c DESC LIMIT 12];
        system.debug(' snapshot list '+s);
        
        wins.rowName = 'Wins';
        populateRowWrapper(s,wins,'Monthly_opp_won__c');
        system.debug(' wins.trend '+wins.trend);
                        
        monthlyOppsAdded.rowName = 'Monthly Opportunities added to Qualified Funnel';
        populateRowWrapper(s,monthlyOppsAdded,'Monthly_QO_added_Quantitative__c');
        system.debug(' monthlyOppsAdded.trend '+monthlyOppsAdded.trend);
        
        rollingOppsAdded.rowName = 'Rolling 12 Month Opps added to Qualified Funnel';
        populateRowWrapper(s,rollingOppsAdded,'X12_Month_QO_added__c');
        system.debug(' rollingOppsAdded.trend '+rollingOppsAdded.trend);
        
        rollingSalesCycle.rowName = '12 Month Rolling Average Sales Cycle';
        populateRowWrapper(s,rollingSalesCycle,'X12_Month_Rolling_Average_Sales_Cycle__c');
        system.debug(' rollingSalesCycle.trend '+rollingSalesCycle.trend);
        
        rollingWinSize.rowName = '12 Month Rolling Average $ Win Size';
        populateRowWrapper(s,rollingWinSize,'X12_Month_Average_Selling_Price__c');
        system.debug(' rollingWinSize.trend '+rollingWinSize.trend);
        
        leads.rowName = 'New leads';
        populateRowWrapper(s,leads,'Monthly_Lead_Added__c');
        system.debug(' leads.trend '+leads.trend);                
        
        wins.rowName = 'Lost/Delayed';
        populateRowWrapper(s,lost,'Monthly_opp_lost__c');
        system.debug(' lost.trend '+lost.trend);
        
        system.debug(' wins '+wins);
        system.debug(' lost '+lost); 
        system.debug(' monthlyOppsAdded '+monthlyOppsAdded);         
        system.debug(' rollingOppsAdded '+rollingOppsAdded); 
        system.debug(' rollingSalesCycle '+rollingSalesCycle); 
        system.debug(' rollingWinSize '+rollingWinSize); 
        
    }
    
    private void populateRowWrapperForAggregates(AggregateResult ar, Integer month, Date schDt){                                        
    
        if(month == 1){     
            
            header.m1 = fetchMonthString(schDt.month());
            
            if (ar.get('mw') != null){           
                wins.m1 = FunnelCalculationHelper.convert((Decimal)(ar.get('mw')),'');
                //wins.decm1 = Integer.valueOf((wins.m1).remove(','));  
                wins.decm1 = (Decimal)(ar.get('mw'));
            }
            else{
                wins.m1 = '0';
                wins.decm1 = 0;
            }                        
            
            if (ar.get('ma') != null){   
                monthlyOppsAdded.m1 = FunnelCalculationHelper.convert((Decimal)(ar.get('ma')),'');
                //monthlyOppsAdded.decm1 = Integer.valueOf((monthlyOppsAdded.m1).remove(','));
                monthlyOppsAdded.decm1 = (Decimal)(ar.get('ma'));
            }
            else{
                monthlyOppsAdded.m1 = '0';
                monthlyOppsAdded.decm1 = 0;
            } 
            
            if (ar.get('mf') != null){    
                rollingOppsAdded.m1 = FunnelCalculationHelper.convert((Decimal)(ar.get('mf')),'');
                //rollingOppsAdded.decm1 = Integer.valueOf((rollingOppsAdded.m1).remove(','));
                rollingOppsAdded.decm1 = (Decimal)(ar.get('mf'));
            }
            else{
                rollingOppsAdded.m1 = '0';
                rollingOppsAdded.decm1 = 0;
            }
            
            if (ar.get('sc') != null){   
                rollingSalesCycle.m1 = FunnelCalculationHelper.convert((Decimal)(ar.get('sc')),'');
                //rollingSalesCycle.decm1 = Integer.valueOf((rollingSalesCycle.m1).remove(','));
                rollingSalesCycle.decm1 =(Decimal)(ar.get('sc'));
            }
            else{
                rollingSalesCycle.m1 = '0';
                rollingSalesCycle.decm1 = 0;
            }
            
            if (ar.get('sp') != null){   
                rollingWinSize.m1 = FunnelCalculationHelper.convert((Decimal)(ar.get('sp')),'$');
                rollingWinSize.decm1 = (Decimal)(ar.get('sp'));
                system.debug(' rollingWinSize.decm1 '+rollingWinSize.decm1);
            }
            else{
                rollingWinSize.m1 = '$0';
                rollingWinSize.decm1 = 0;
            }
            
            if (ar.get('la') != null){  
                leads.m1 = FunnelCalculationHelper.convert((Decimal)(ar.get('la')),'');
                //leads.decm1 = Integer.valueOf((leads.m1).remove(','));
                leads.decm1 = (Decimal)(ar.get('la'));
            }
            else{
                leads.m1 = '0';
                leads.decm1 = 0;
            }
            
            if (ar.get('mo') != null){   
                lost.m1 = FunnelCalculationHelper.convert((Decimal)(ar.get('mo')),'');            
                //lost.decm1 = Integer.valueOf((lost.m1).remove(','));
                lost.decm1 =(Decimal)(ar.get('mo'));
            }
            else{
                lost.m1 = '0';
                lost.decm1 = 0;
            }
            
        }
        else if(month == 2){     
            
            header.m2 = fetchMonthString(schDt.month());
            
            if (ar.get('mw') != null){           
                wins.m2 = FunnelCalculationHelper.convert((Decimal)(ar.get('mw')),'');
                wins.decm2 = (Decimal)(ar.get('mw'));
            }
            else{
                wins.m2 = '0';
                wins.decm2 = 0;
            }                        
            
            if (ar.get('ma') != null){   
                monthlyOppsAdded.m2 = FunnelCalculationHelper.convert((Decimal)(ar.get('ma')),'');
                monthlyOppsAdded.decm2 = (Decimal)(ar.get('ma'));
            }
            else{
                monthlyOppsAdded.m2 = '0';
                monthlyOppsAdded.decm2 = 0;
            } 
            
            if (ar.get('mf') != null){    
                rollingOppsAdded.m2 = FunnelCalculationHelper.convert((Decimal)(ar.get('mf')),'');
                rollingOppsAdded.decm2 = (Decimal)(ar.get('mf'));
            }
            else{
                rollingOppsAdded.m2 = '0';
                rollingOppsAdded.decm2 = 0;
            }
            
            
            if (ar.get('sc') != null && (Decimal)ar.get('sc') > 0){   
                rollingSalesCycle.m2 = FunnelCalculationHelper.convert((Decimal)(ar.get('sc')),'');
                
                rollingSalesCycle.decm2 = (Decimal)ar.get('sc');
            }
            else{
                rollingSalesCycle.m2 = '0';
                rollingSalesCycle.decm2 = 0;
            }
           
            
            if (ar.get('sp') != null){   
                rollingWinSize.m2 = FunnelCalculationHelper.convert((Decimal)(ar.get('sp')),'$');
                rollingWinSize.decm2 = (Decimal)(ar.get('sp'));
                system.debug(' rollingWinSize.decm2 '+rollingWinSize.decm2);
            }
            else{
                rollingWinSize.m2 = '$0';
                rollingWinSize.decm2 = 0;
            }
            
            if (ar.get('la') != null){  
                leads.m2 = FunnelCalculationHelper.convert((Decimal)(ar.get('la')),'');
                leads.decm2 = (Decimal)(ar.get('la'));
            }
            else{
                leads.m2 = '0';
                leads.decm2 = 0;
            }
            
            if (ar.get('mo') != null){   
                lost.m2 = FunnelCalculationHelper.convert((Decimal)(ar.get('mo')),'');            
                lost.decm2 = (Decimal)(ar.get('mo'));
            }
            else{
                lost.m2 = '0';
                lost.decm2 = 0;
            }
        }
        else if(month == 3){     
            
            header.m3 = fetchMonthString(schDt.month());
            
            if (ar.get('mw') != null){           
                wins.m3 = FunnelCalculationHelper.convert((Decimal)(ar.get('mw')),'');
                wins.decm3 = (Decimal)(ar.get('mw'));
            }
            else{
                wins.m3 = '0';
                wins.decm3 = 0;
            }                        
            
            if (ar.get('ma') != null){   
                monthlyOppsAdded.m3 = FunnelCalculationHelper.convert((Decimal)(ar.get('ma')),'');
                monthlyOppsAdded.decm3 = (Decimal)(ar.get('ma'));
            }
            else{
                monthlyOppsAdded.m3 = '0';
                monthlyOppsAdded.decm3 = 0;
            } 
            
            if (ar.get('mf') != null){    
                rollingOppsAdded.m3 = FunnelCalculationHelper.convert((Decimal)(ar.get('mf')),'');
                rollingOppsAdded.decm3 = (Decimal)(ar.get('mf'));
            }
            else{
                rollingOppsAdded.m3 = '0';
                rollingOppsAdded.decm3 = 0;
            }
            
            if (ar.get('sc') != null && (Decimal)ar.get('sc') > 0) {   
                rollingSalesCycle.m3 = FunnelCalculationHelper.convert((Decimal)(ar.get('sc')),'');
                rollingSalesCycle.decm3 = (Decimal)(ar.get('sc'));
            }
            else{
                rollingSalesCycle.m3 = '0';
                rollingSalesCycle.decm3 = 0;
            }
            
            if (ar.get('sp') != null){   
                rollingWinSize.m3 = FunnelCalculationHelper.convert((Decimal)(ar.get('sp')),'$');
                rollingWinSize.decm3 = (Decimal)(ar.get('sp'));
                system.debug(' rollingWinSize.decm3 '+rollingWinSize.decm3);
            }
            else{
                rollingWinSize.m3 = '$0';
                rollingWinSize.decm3 = 0;
            }
            
            if (ar.get('la') != null){  
                leads.m3 = FunnelCalculationHelper.convert((Decimal)(ar.get('la')),'');
                leads.decm3 = (Decimal)(ar.get('la'));                
            }
            else{
                leads.m3 = '0';
                leads.decm3 = 0;
            }
            
            if (ar.get('mo') != null){   
                lost.m3 = FunnelCalculationHelper.convert((Decimal)(ar.get('mo')),'');            
                lost.decm3 = (Decimal)(ar.get('mo'));
            }
            else{
                lost.m3 = '0';
                lost.decm3 = 0;
            }
        }
        else if(month == 4){     
            
            header.m4 = fetchMonthString(schDt.month());
            
            if (ar.get('mw') != null){           
                wins.m4 = FunnelCalculationHelper.convert((Decimal)(ar.get('mw')),'');
                wins.decm4 = (Decimal)(ar.get('mw'));
            }
            else{
                wins.m4 = '0';
                wins.decm4 = 0;
            }                        
            
            if (ar.get('ma') != null){   
                monthlyOppsAdded.m4 = FunnelCalculationHelper.convert((Decimal)(ar.get('ma')),'');
                monthlyOppsAdded.decm4 = (Decimal)(ar.get('ma'));
            }
            else{
                monthlyOppsAdded.m4 = '0';
                monthlyOppsAdded.decm4 = 0;
            } 
            
            if (ar.get('mf') != null){    
                rollingOppsAdded.m4 = FunnelCalculationHelper.convert((Decimal)(ar.get('mf')),'');
                rollingOppsAdded.decm4 = (Decimal)(ar.get('mf'));
            }
            else{
                rollingOppsAdded.m4 = '0';
                rollingOppsAdded.decm4 = 0;
            }
            
            if (ar.get('sc') != null && (Decimal)ar.get('sc') > 0){   
                rollingSalesCycle.m4 = FunnelCalculationHelper.convert((Decimal)(ar.get('sc')),'');
                
                rollingSalesCycle.decm4 = (Decimal)(ar.get('sc'));
            }
            else{
                rollingSalesCycle.m4 = '0';
                rollingSalesCycle.decm4 = 0;
            }
            
            if (ar.get('sp') != null){   
                rollingWinSize.m4 = FunnelCalculationHelper.convert((Decimal)(ar.get('sp')),'$');
                rollingWinSize.decm4 = (Decimal)(ar.get('sp'));
                system.debug(' rollingWinSize.decm4 '+rollingWinSize.decm4);
            }
            else{
                rollingWinSize.m4 = '$0';
                rollingWinSize.decm4 = 0;
            }
            
            if (ar.get('la') != null){  
                leads.m4 = FunnelCalculationHelper.convert((Decimal)(ar.get('la')),'');
                leads.decm4 = (Decimal)(ar.get('la'));
            }
            else{
                leads.m4 = '0';
                leads.decm4 = 0;
            }
            
            if (ar.get('mo') != null){   
                lost.m4 = FunnelCalculationHelper.convert((Decimal)(ar.get('mo')),'');            
                lost.decm4 = (Decimal)(ar.get('mo'));
            }
            else{
                lost.m4 = '0';
                lost.decm4 = 0;
            }
        }
        else if(month == 5){     
            
            header.m5 = fetchMonthString(schDt.month());
            
            if (ar.get('mw') != null){           
                wins.m5 = FunnelCalculationHelper.convert((Decimal)(ar.get('mw')),'');
                wins.decm5 = (Decimal)(ar.get('mw'));
            }
            else{
                wins.m5 = '0';
                wins.decm5 = 0;
            }                        
            
            if (ar.get('ma') != null){   
                monthlyOppsAdded.m5 = FunnelCalculationHelper.convert((Decimal)(ar.get('ma')),'');
                monthlyOppsAdded.decm5 = (Decimal)(ar.get('ma'));
            }
            else{
                monthlyOppsAdded.m5 = '0';
                monthlyOppsAdded.decm5 = 0;
            } 
            
            if (ar.get('mf') != null){    
                rollingOppsAdded.m5 = FunnelCalculationHelper.convert((Decimal)(ar.get('mf')),'');
                rollingOppsAdded.decm5 = (Decimal)(ar.get('mf'));
            }
            else{
                rollingOppsAdded.m5 = '0';
                rollingOppsAdded.decm5 = 0;
            }
            
            if (ar.get('sc') != null && (Decimal)ar.get('sc') > 0){  
                Decimal dc  =  (Decimal)(ar.get('sc'));
                system.debug(' dc '+dc);
                rollingSalesCycle.m5 = FunnelCalculationHelper.convert((Decimal)(ar.get('sc')),'');
                system.debug(' rollingSalesCycle.m5 '+rollingSalesCycle.m5);
                rollingSalesCycle.decm5 = (Decimal)(ar.get('sc'));
            }
            else{
                rollingSalesCycle.m5 = '0';
                rollingSalesCycle.decm5 = 0;
            }
            
            if (ar.get('sp') != null){   
                rollingWinSize.m5 = FunnelCalculationHelper.convert((Decimal)(ar.get('sp')),'$');
                rollingWinSize.decm5 = (Decimal)(ar.get('sp'));
                system.debug(' rollingWinSize.decm5 '+rollingWinSize.decm5);
            }
            else{
                rollingWinSize.m5 = '$0';
                rollingWinSize.decm5 = 0;
            }
            
            if (ar.get('la') != null){  
                leads.m5 = FunnelCalculationHelper.convert((Decimal)(ar.get('la')),'');
                leads.decm5 = (Decimal)(ar.get('la'));
            }
            else{
                leads.m5 = '0';
                leads.decm5 = 0;
            }
            
            if (ar.get('mo') != null){   
                lost.m5 = FunnelCalculationHelper.convert((Decimal)(ar.get('mo')),'');            
                lost.decm5 = (Decimal)(ar.get('mo'));
            }
            else{
                lost.m5 = '0';
                lost.decm5 = 0;
            }
        }
        else if(month == 6){     
            
            header.m6 = fetchMonthString(schDt.month());
                        
            if (ar.get('mw') != null){           
                wins.m6 = FunnelCalculationHelper.convert((Decimal)(ar.get('mw')),'');
                wins.decm6 = (Decimal)(ar.get('mw'));
            }
            else{
                wins.m6 = '0';
                wins.decm6 = 0;
            }                        
            
            if (ar.get('ma') != null){   
                monthlyOppsAdded.m6 = FunnelCalculationHelper.convert((Decimal)(ar.get('ma')),'');
                monthlyOppsAdded.decm6 = (Decimal)(ar.get('ma'));
            }
            else{
                monthlyOppsAdded.m6 = '0';
                monthlyOppsAdded.decm6 = 0;
            } 
            
            if (ar.get('mf') != null){    
                rollingOppsAdded.m6 = FunnelCalculationHelper.convert((Decimal)(ar.get('mf')),'');
                rollingOppsAdded.decm6 = (Decimal)(ar.get('mf'));
            }
            else{
                rollingOppsAdded.m6 = '0';
                rollingOppsAdded.decm6 = 0;
            }
            
            if (ar.get('sc') != null && (Decimal)ar.get('sc') > 0){   
                rollingSalesCycle.m6 = FunnelCalculationHelper.convert((Decimal)(ar.get('sc')),'');
                rollingSalesCycle.decm6 =  (Decimal)ar.get('sc') ;
            }
            else{
                rollingSalesCycle.m6 = '0';
                rollingSalesCycle.decm6 = 0;
            }
            
            if (ar.get('sp') != null){   
                rollingWinSize.m6 = FunnelCalculationHelper.convert((Decimal)(ar.get('sp')),'$');
                rollingWinSize.decm6 = (Decimal)(ar.get('sp'));
                system.debug(' rollingWinSize.decm6 '+rollingWinSize.decm6);
            }
            else{
                rollingWinSize.m6 = '$0';
                rollingWinSize.decm6 = 0;
            }
            
            if (ar.get('la') != null){  
                leads.m6 = FunnelCalculationHelper.convert((Decimal)(ar.get('la')),'');
                leads.decm6 =  (Decimal)ar.get('la') ;
            }
            else{
                leads.m6 = '0';
                leads.decm6 = 0;
            }
            
            if (ar.get('mo') != null){   
                lost.m6 = FunnelCalculationHelper.convert((Decimal)(ar.get('mo')),'');            
                lost.decm6 = (Decimal)ar.get('mo') ;
            }
            else{
                lost.m6 = '0';
                lost.decm6 = 0;
            }
        }
        else if(month == 7){     
            
            header.m7 = fetchMonthString(schDt.month());
                        
            if (ar.get('mw') != null){           
                wins.m7 = FunnelCalculationHelper.convert((Decimal)(ar.get('mw')),'');
                wins.decm7 = (Decimal)ar.get('mw');
            }
            else{
                wins.m7 = '0';
                wins.decm7 = 0;
            }                        
            
            if (ar.get('ma') != null){   
                monthlyOppsAdded.m7 = FunnelCalculationHelper.convert((Decimal)(ar.get('ma')),'');
                monthlyOppsAdded.decm7 = (Decimal)ar.get('ma');
            }
            else{
                monthlyOppsAdded.m7 = '0';
                monthlyOppsAdded.decm7 = 0;
            } 
            
            if (ar.get('mf') != null){    
                rollingOppsAdded.m7 = FunnelCalculationHelper.convert((Decimal)(ar.get('mf')),'');
                rollingOppsAdded.decm7 = (Decimal)ar.get('mf');
            }
            else{
                rollingOppsAdded.m7 = '0';
                rollingOppsAdded.decm7 = 0;
            }
            
            if (ar.get('sc') != null && (Decimal)ar.get('sc') > 0){   
                rollingSalesCycle.m7 = FunnelCalculationHelper.convert((Decimal)(ar.get('sc')),'');
                rollingSalesCycle.decm7 = (Decimal)ar.get('sc');
            }
            else{
                rollingSalesCycle.m7 = '0';
                rollingSalesCycle.decm7 = 0;
            }
            
            if (ar.get('sp') != null){   
                rollingWinSize.m7 = FunnelCalculationHelper.convert((Decimal)(ar.get('sp')),'$');
                rollingWinSize.decm7 = (Decimal)(ar.get('sp'));
                system.debug(' rollingWinSize.decm7 '+rollingWinSize.decm7);
            }
            else{
                rollingWinSize.m7 = '$0';
                rollingWinSize.decm7 = 0;
            }
            
            if (ar.get('la') != null){  
                leads.m7 = FunnelCalculationHelper.convert((Decimal)(ar.get('la')),'');
                leads.decm7 = (Decimal)ar.get('la');
            }
            else{
                leads.m7 = '0';
                leads.decm7 = 0;
            }
            
            if (ar.get('mo') != null){   
                lost.m7 = FunnelCalculationHelper.convert((Decimal)(ar.get('mo')),'');            
                lost.decm7 =(Decimal)ar.get('mo');
            }
            else{
                lost.m7 = '0';
                lost.decm7 = 0;
            }
        }
        else if(month == 8){     
            
            header.m8 = fetchMonthString(schDt.month());
             
            if (ar.get('mw') != null){           
                wins.m8 = FunnelCalculationHelper.convert((Decimal)(ar.get('mw')),'');
                wins.decm8 = (Decimal)ar.get('mw');
            }
            else{
                wins.m8 = '0';
                wins.decm8 = 0;
            }                        
            
            if (ar.get('ma') != null){   
                monthlyOppsAdded.m8 = FunnelCalculationHelper.convert((Decimal)(ar.get('ma')),'');
                monthlyOppsAdded.decm8 = (Decimal)ar.get('ma');
            }
            else{
                monthlyOppsAdded.m8 = '0';
                monthlyOppsAdded.decm8 = 0;
            } 
            
            if (ar.get('mf') != null){    
                rollingOppsAdded.m8 = FunnelCalculationHelper.convert((Decimal)(ar.get('mf')),'');
                rollingOppsAdded.decm8 = (Decimal)ar.get('mf');
            }
            else{
                rollingOppsAdded.m8 = '0';
                rollingOppsAdded.decm8 = 0;
            }
            
            if (ar.get('sc') != null && (Decimal)ar.get('sc') > 0){   
                rollingSalesCycle.m8 = FunnelCalculationHelper.convert((Decimal)(ar.get('sc')),'');
                rollingSalesCycle.decm8 = (Decimal)ar.get('sc');
            }
            else{
                rollingSalesCycle.m8 = '0';
                rollingSalesCycle.decm8 = 0;
            }
            
            if (ar.get('sp') != null){   
                rollingWinSize.m8 = FunnelCalculationHelper.convert((Decimal)(ar.get('sp')),'$');
                rollingWinSize.decm8 = (Decimal)(ar.get('sp'));
                system.debug(' rollingWinSize.decm8 '+rollingWinSize.decm8);
            }
            else{
                rollingWinSize.m8 = '$0';
                rollingWinSize.decm8 = 0;
            }
            
            if (ar.get('la') != null){  
                leads.m8 = FunnelCalculationHelper.convert((Decimal)(ar.get('la')),'');
                leads.decm8 = (Decimal)ar.get('la');
            }
            else{
                leads.m8 = '0';
                leads.decm8 = 0;
            }
            
            if (ar.get('mo') != null){   
                lost.m8 = FunnelCalculationHelper.convert((Decimal)(ar.get('mo')),'');            
                lost.decm8 = (Decimal)ar.get('mo');
            }
            else{
                lost.m8 = '0';
                lost.decm8 = 0;
            }
        }
        else if(month == 9){     
            
            header.m9 = fetchMonthString(schDt.month());
            
            if (ar.get('mw') != null){           
                wins.m9 = FunnelCalculationHelper.convert((Decimal)(ar.get('mw')),'');
                wins.decm9 = (Decimal)ar.get('mw');
            }
            else{
                wins.m9 = '0';
                wins.decm9 = 0;
            }                        
            
            if (ar.get('ma') != null){   
                monthlyOppsAdded.m9 = FunnelCalculationHelper.convert((Decimal)(ar.get('ma')),'');
                monthlyOppsAdded.decm9 = (Decimal)ar.get('ma');
            }
            else{
                monthlyOppsAdded.m9 = '0';
                monthlyOppsAdded.decm9 = 0;
            } 
            
            if (ar.get('mf') != null){    
                rollingOppsAdded.m9 = FunnelCalculationHelper.convert((Decimal)(ar.get('mf')),'');
                rollingOppsAdded.decm9 = (Decimal)ar.get('mf');
            }
            else{
                rollingOppsAdded.m9 = '0';
                rollingOppsAdded.decm9 = 0;
            }
            
            if (ar.get('sc') != null && (Decimal)ar.get('sc') > 0){   
                rollingSalesCycle.m9 = FunnelCalculationHelper.convert((Decimal)(ar.get('sc')),'');
                rollingSalesCycle.decm9 = (Decimal)ar.get('sc');
            }
            else{
                rollingSalesCycle.m9 = '0';
                rollingSalesCycle.decm9 = 0;
            }
            
            if (ar.get('sp') != null){   
                rollingWinSize.m9 = FunnelCalculationHelper.convert((Decimal)(ar.get('sp')),'$');
                rollingWinSize.decm9 = (Decimal)(ar.get('sp'));
                system.debug(' rollingWinSize.decm9 '+rollingWinSize.decm9);
            }
            else{
                rollingWinSize.m9 = '$0';
                rollingWinSize.decm9 = 0;
            }
            
            if (ar.get('la') != null){  
                leads.m9 = FunnelCalculationHelper.convert((Decimal)(ar.get('la')),'');
                leads.decm9 =(Decimal)ar.get('la');
            }
            else{
                leads.m9 = '0';
                leads.decm9 = 0;
            }
            
            if (ar.get('mo') != null){   
                lost.m9 = FunnelCalculationHelper.convert((Decimal)(ar.get('mo')),'');            
                lost.decm9 = (Decimal)ar.get('mo');
            }
            else{
                lost.m9 = '0';
                lost.decm9 = 0;
            }
        }
        else if(month == 10){     
            
            header.m10 = fetchMonthString(schDt.month());
            
            if (ar.get('mw') != null){           
                wins.m10 = FunnelCalculationHelper.convert((Decimal)(ar.get('mw')),'');
                wins.decm10 = (Decimal)ar.get('mw');
            }
            else{
                wins.m10 = '0';
                wins.decm10 = 0;
            }                        
            
            if (ar.get('ma') != null){   
                monthlyOppsAdded.m10 = FunnelCalculationHelper.convert((Decimal)(ar.get('ma')),'');
                monthlyOppsAdded.decm10 = (Decimal)ar.get('ma');
            }
            else{
                monthlyOppsAdded.m10 = '0';
                monthlyOppsAdded.decm10 = 0;
            } 
            
            if (ar.get('mf') != null){    
                rollingOppsAdded.m10 = FunnelCalculationHelper.convert((Decimal)(ar.get('mf')),'');
                rollingOppsAdded.decm10 = (Decimal)ar.get('mf');
            }
            else{
                rollingOppsAdded.m10 = '0';
                rollingOppsAdded.decm10 = 0;
            }
            
            if (ar.get('sc') != null && (Decimal)ar.get('sc') > 0){   
                rollingSalesCycle.m10 = FunnelCalculationHelper.convert((Decimal)(ar.get('sc')),'');
                rollingSalesCycle.decm10 = (Decimal)ar.get('sc');
            }
            else{
                rollingSalesCycle.m10 = '0';
                rollingSalesCycle.decm10 = 0;
            }
            
            if (ar.get('sp') != null){   
                rollingWinSize.m10 = FunnelCalculationHelper.convert((Decimal)(ar.get('sp')),'$');
                rollingWinSize.decm10 = (Decimal)(ar.get('sp'));
                system.debug(' rollingWinSize.decm10 '+rollingWinSize.decm10);
            }
            else{
                rollingWinSize.m10 = '$0';
                rollingWinSize.decm10 = 0;
            }
            
            if (ar.get('la') != null){  
                leads.m10 = FunnelCalculationHelper.convert((Decimal)(ar.get('la')),'');
                leads.decm10 = (Decimal)ar.get('la');
            }
            else{
                leads.m10 = '0';
                leads.decm10 = 0;
            }
            
            if (ar.get('mo') != null){   
                lost.m10 = FunnelCalculationHelper.convert((Decimal)(ar.get('mo')),'');            
                lost.decm10 = (Decimal)ar.get('mo');
            }
            else{
                lost.m10 = '0';
                lost.decm10 = 0;
            }
        }
        else if(month == 11){     
            
            header.m11 = fetchMonthString(schDt.month());
            
            if (ar.get('mw') != null){           
                wins.m11 = FunnelCalculationHelper.convert((Decimal)(ar.get('mw')),'');
                wins.decm11 = (Decimal)ar.get('mw');
            }
            else{
                wins.m11 = '0';
                wins.decm11 = 0;
            }                        
            
            if (ar.get('ma') != null){   
                monthlyOppsAdded.m11 = FunnelCalculationHelper.convert((Decimal)(ar.get('ma')),'');
                monthlyOppsAdded.decm11 = (Decimal)ar.get('ma');
            }
            else{
                monthlyOppsAdded.m11 = '0';
                monthlyOppsAdded.decm11 = 0;
            } 
            
            if (ar.get('mf') != null){    
                rollingOppsAdded.m11 = FunnelCalculationHelper.convert((Decimal)(ar.get('mf')),'');
                rollingOppsAdded.decm11 = (Decimal)ar.get('mf');
            }
            else{
                rollingOppsAdded.m11 = '0';
                rollingOppsAdded.decm11 = 0;
            }
            
            if (ar.get('sc') != null && (Decimal)ar.get('sc') > 0){   
                rollingSalesCycle.m11 = FunnelCalculationHelper.convert((Decimal)(ar.get('sc')),'');
                rollingSalesCycle.decm11 = (Decimal)ar.get('sc');
            }
            else{
                rollingSalesCycle.m11 = '0';
                rollingSalesCycle.decm11 = 0;
            }
            
            if (ar.get('sp') != null){   
                rollingWinSize.m11 = FunnelCalculationHelper.convert((Decimal)(ar.get('sp')),'$');
                rollingWinSize.decm11 = (Decimal)(ar.get('sp'));
                system.debug(' rollingWinSize.decm11 '+rollingWinSize.decm11);
            }
            else{
                rollingWinSize.m11 = '$0';
                rollingWinSize.decm11 = 0;
            }
            
            if (ar.get('la') != null){  
                leads.m11 = FunnelCalculationHelper.convert((Decimal)(ar.get('la')),'');
                leads.decm11 = (Decimal)ar.get('la');
            }
            else{
                leads.m11 = '0';
                leads.decm11 = 0;
            }
            
            if (ar.get('mo') != null){   
                lost.m11 = FunnelCalculationHelper.convert((Decimal)(ar.get('mo')),'');            
                lost.decm11 = (Decimal)ar.get('mo');
            }
            else{
                lost.m11 = '0';
                lost.decm11 = 0;
            }
        }
        else if(month == 12){     
            
            header.m12 = fetchMonthString(schDt.month());
            
            if (ar.get('mw') != null){           
                wins.m12 = FunnelCalculationHelper.convert((Decimal)(ar.get('mw')),'');
                wins.decm12 = (Decimal)ar.get('mw');
            }
            else{
                wins.m12 = '0';
                wins.decm12 = 0;
            }                        
            
            if (ar.get('ma') != null){   
                monthlyOppsAdded.m12 = FunnelCalculationHelper.convert((Decimal)(ar.get('ma')),'');
                monthlyOppsAdded.decm12 = (Decimal)ar.get('ma');
            }
            else{
                monthlyOppsAdded.m12 = '0';
                monthlyOppsAdded.decm12 = 0;
            } 
            
            if (ar.get('mf') != null){    
                rollingOppsAdded.m12 = FunnelCalculationHelper.convert((Decimal)(ar.get('mf')),'');
                rollingOppsAdded.decm12 = (Decimal)ar.get('mf');
            }
            else{
                rollingOppsAdded.m12 = '0';
                rollingOppsAdded.decm12 = 0;
            }
            
            if (ar.get('sc') != null && (Decimal)ar.get('sc') > 0){   
                rollingSalesCycle.m12 = FunnelCalculationHelper.convert((Decimal)(ar.get('sc')),'');
                rollingSalesCycle.decm12 = (Decimal)ar.get('sc');
            }
            else{
                rollingSalesCycle.m12 = '0';
                rollingSalesCycle.decm12 = 0;
            }
            
            if (ar.get('sp') != null){   
                rollingWinSize.m12 = FunnelCalculationHelper.convert((Decimal)(ar.get('sp')),'$');
                rollingWinSize.decm12 = (Decimal)(ar.get('sp'));
                system.debug(' rollingWinSize.decm12 '+rollingWinSize.decm12);
            }
            else{
                rollingWinSize.m12 = '$0';
                rollingWinSize.decm12 = 0;
            }
            
            if (ar.get('la') != null){  
                leads.m12 = FunnelCalculationHelper.convert((Decimal)(ar.get('la')),'');
                leads.decm12 = (Decimal)ar.get('la');
            }
            else{
                leads.m12 = '0';
                leads.decm12 = 0;
            }
            
            if (ar.get('mo') != null){   
                lost.m12 = FunnelCalculationHelper.convert((Decimal)(ar.get('mo')),'');            
                lost.decm12 = (Decimal)ar.get('mo');
            }
            else{
                lost.m12 = '0';
                lost.decm12 = 0;
            }
        }
                                                   
    } 
    
    private void populateRowWrapper(List<Sales_Rep_Profile_Snapshot__c> s, FunnelReportingTableWrapper wr, String fieldName){
        
        Integer listLength = 0;
        
        if(s != null && s.size() > 0){
        
            listLength = s.size();
        }
                                
        for(Integer index=0; index<listLength;index++){
            if(index == 0){
                header.m1 = fetchMonthString(((Date)(s[index].get('Snapshot_Scheduled_Date__c'))).month());                             
            }
            else if (index == 1){
                header.m2 = fetchMonthString(((Date)(s[index].get('Snapshot_Scheduled_Date__c'))).month());      
            }
            else if (index == 2){
                header.m3 = fetchMonthString(((Date)(s[index].get('Snapshot_Scheduled_Date__c'))).month());      
            }
            else if (index == 3){
                header.m4 = fetchMonthString(((Date)(s[index].get('Snapshot_Scheduled_Date__c'))).month());      
            }
            else if (index == 4){
                header.m5 = fetchMonthString(((Date)(s[index].get('Snapshot_Scheduled_Date__c'))).month());      
            }
            else if (index == 5){
                header.m6 = fetchMonthString(((Date)(s[index].get('Snapshot_Scheduled_Date__c'))).month());      
            }
            else if (index == 6){
                header.m7 = fetchMonthString(((Date)(s[index].get('Snapshot_Scheduled_Date__c'))).month());      
            }
            else if (index == 7){
                header.m8 = fetchMonthString(((Date)(s[index].get('Snapshot_Scheduled_Date__c'))).month());      
            }
            else if (index == 8){
                header.m9 = fetchMonthString(((Date)(s[index].get('Snapshot_Scheduled_Date__c'))).month());      
            }
            else if (index == 9){
                header.m10 = fetchMonthString(((Date)(s[index].get('Snapshot_Scheduled_Date__c'))).month());      
            }
            else if (index == 10){
                header.m11 = fetchMonthString(((Date)(s[index].get('Snapshot_Scheduled_Date__c'))).month());      
            }
            else if (index == 11){
                header.m12 = fetchMonthString(((Date)(s[index].get('Snapshot_Scheduled_Date__c'))).month());      
            }    
        }
        
        Integer index = 0;
        Decimal sum = 0;
        Integer count = 0;
        
        while(listLength > 0){
            
            Decimal val = (Decimal)s[index].get(fieldName);
            system.debug(' fieldName '+fieldName);
            system.debug(' wr '+wr);
            system.debug(' val '+val);
            
            if(val != null && val >= 0){
                                                
                if(index == 0){                    
                    if(fieldName != 'X12_Month_Average_Selling_Price__c')
                        wr.m1 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),''); 
                    else
                        wr.m1 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'$'); 
                        
                    wr.decm1 = (Decimal)s[index].get(fieldName);            
                }
                else if (index == 1){
                
                    if(fieldName != 'X12_Month_Average_Selling_Price__c')
                        wr.m2 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'');
                    else
                        wr.m2 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'$'); 
                         
                    //wr.m2 = String.valueOf(s[index].get(fieldName));
                }
                else if (index == 2){
                    if(fieldName != 'X12_Month_Average_Selling_Price__c')
                        wr.m3 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'');
                    else
                        wr.m3 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'$');
                    //wr.m3 = String.valueOf(s[index].get(fieldName));
                }
                else if (index == 3){
                    if(fieldName != 'X12_Month_Average_Selling_Price__c')
                        wr.m4 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'');
                    else
                        wr.m4 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'$');
                    //wr.m4 = String.valueOf(s[index].get(fieldName));
                }
                else if (index == 4){
                    if(fieldName != 'X12_Month_Average_Selling_Price__c')
                        wr.m5 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'');
                    else
                        wr.m5 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'$');
                    //wr.m5 = String.valueOf(s[index].get(fieldName));
                }
                else if (index == 5){
                    if(fieldName != 'X12_Month_Average_Selling_Price__c')
                        wr.m6 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'');
                    else
                        wr.m6 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'$');
                    //wr.m6 = String.valueOf(s[index].get(fieldName));
                }
                else if (index == 6){
                    if(fieldName != 'X12_Month_Average_Selling_Price__c')
                        wr.m7 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'');
                    else 
                        wr.m7 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'$');
                    //wr.m7 = String.valueOf(s[index].get(fieldName));
                }
                else if (index == 7){
                    if(fieldName != 'X12_Month_Average_Selling_Price__c')
                        wr.m8 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'');
                    else
                        wr.m8 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'$');
                    //wr.m8 = String.valueOf(s[index].get(fieldName));
                }
                else if (index == 8){
                    if(fieldName != 'X12_Month_Average_Selling_Price__c')
                        wr.m9 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'');
                    else
                        wr.m9 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'$');
                    //wr.m9 = String.valueOf(s[index].get(fieldName));
                }
                else if (index == 9){
                    if(fieldName != 'X12_Month_Average_Selling_Price__c')
                        wr.m10 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'');
                    else
                        wr.m10 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'$');
                    //wr.m10 = String.valueOf(s[index].get(fieldName));
                }
                else if (index == 10){
                    if(fieldName != 'X12_Month_Average_Selling_Price__c')
                        wr.m11 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'');
                    else
                        wr.m11 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'$');
                    //wr.m11 = String.valueOf(s[index].get(fieldName));
                }
                else if (index == 11){
                    if(fieldName != 'X12_Month_Average_Selling_Price__c')
                        wr.m12 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'');
                    else
                        wr.m12 = FunnelCalculationHelper.convert((Decimal)(s[index].get(fieldName)),'$');
                }            
                
                sum += val;
                count ++;
            }
            else{
            
                if(index == 0){                    
                    wr.m1 = '0';                         
                    wr.decm1 = 0;            
                }
                else if (index == 1){                
                    wr.m2 = '0';
                }
                else if (index == 2){
                    wr.m3 = '0';
                }
                else if (index == 3){
                    wr.m4 = '0';
                }
                else if (index == 4){
                    wr.m5 = '0';
                }
                else if (index == 5){
                    wr.m6 = '0';
                }
                else if (index == 6){
                    wr.m7 = '0';
                }
                else if (index == 7){
                    wr.m8 = '0';
                }
                else if (index == 8){
                    wr.m9 = '0';
                }
                else if (index == 9){
                    wr.m10 = '0';
                }
                else if (index == 10){
                    wr.m11 = '0';
                }
                else if (index == 11){
                    wr.m12 = '0';
                }
                sum += 0;
                count ++;
            }
                
            listLength = listLength - 1;
            index = index + 1;
        }
        
        if(count > 0){
            Decimal average = sum/count;
            system.debug(' sum '+sum);
            system.debug(' count '+count);
            system.debug(' average '+average);
            system.debug(' wr.decm1 '+wr.decm1);
            if(wr.decm1 > average){
                wr.trend = 'up';
            }
            else if(wr.decm1 == average){
                wr.trend = 'equal';
            }
            else{
                wr.trend = 'down';
            }
        }
    } 
    
    private String fetchMonthString(Integer mon){

        if(mon == 1){
            return 'Jan';
        }
        else if(mon == 2){
            return 'Feb';
        }
        else if(mon == 3){
            return 'Mar';
        }
        else if(mon == 4){
            return 'Apr';
        }
        else if(mon == 5){
            return 'May';
        }
        else if(mon == 6){
            return 'June';
        }
        else if(mon == 7){
            return 'July';
        }
        else if(mon == 8){
            return 'Aug';
        }
        else if(mon == 9){
            return 'Sep';
        }
        else if(mon == 10){
            return 'Oct';
        }
        else if(mon == 11){
            return 'Nov';
        }
        else if(mon == 12){
            return 'Dec';
        }
        
        return '';
    }
    
    private Decimal fetchAverage(FunnelReportingTableWrapper fw){
        Decimal sum = 0;
        Integer count = 0;
        
        if(fw.m1 != null){
            system.debug(' fw.decm1 '+fw.decm1);
            sum = sum + fw.decm1;
            count ++;
        }
        
        if(fw.m2 != null){
            system.debug(' fw.decm2 '+fw.decm2);
            sum = sum + fw.decm2;
            count ++;
        }
        
        if(fw.m3 != null){
            system.debug(' fw.decm3 '+fw.decm3);
            sum = sum + fw.decm3;
            count ++;
        }
        
        if(fw.m4 != null){
            system.debug(' fw.decm4 '+fw.decm4);
            sum = sum + fw.decm4;
            count ++;
        }
        
        if(fw.m5 != null){
            system.debug(' fw.decm5 '+fw.decm5);
            sum = sum + fw.decm5;
            count ++;
        }
        
        if(fw.m6 != null){
            system.debug(' fw.decm6 '+fw.decm6);
            sum = sum + fw.decm6;
            count ++;
        }
        
        if(fw.m7 != null){
            system.debug(' fw.decm7 '+fw.decm7);
            sum = sum + fw.decm7;
            count ++;
        }
        
        if(fw.m8 != null){
            system.debug(' fw.decm8 '+fw.decm8);
            sum = sum + fw.decm8;
            count ++;
        }
        
        if(fw.m9 != null){
            system.debug(' fw.decm9 '+fw.decm9);
            sum = sum + fw.decm9;
            count ++;
        }
        
        if(fw.m10 != null){
            system.debug(' fw.decm10 '+fw.decm10);
            sum = sum + fw.decm10;
            count ++;
        }
        
        if(fw.m11 != null){
            system.debug(' fw.decm11 '+fw.decm11);
            sum = sum + fw.decm11;
            count ++;
        }
        
        if(fw.m12 != null){
            system.debug(' fw.decm12 '+fw.decm12);
            sum = sum + fw.decm12;
            count ++;
        }
        
        Decimal d;
        
        system.debug(' sum  '+sum);
        system.debug(' count '+count);
        
        if (count > 0){
            d = sum/count;
        }
        system.debug(' average '+d);
        return d;
    }          
    /*Code for table*/ 
    
    public void breadCrumClick(){
        
        fw = new FunnelFilterWrapper();
        fw.labelFour = 'Filter By Representative';
        FunnelFilterHelper.onclickpopulateFilters(crumValue,fw);
    }                 
}