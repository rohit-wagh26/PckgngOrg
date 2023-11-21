public with sharing class FunnelTrendingByRepController {
    
    public FunnelFilterWrapper fw {get; set;}
    public List<String> chartLabels {get;set;} 
    public List<Decimal> chartData {get;set;}
    public string zeroGoalRating{get;set;}
    
    public List<Decimal> Lp{get;set;}
    public List<Decimal> Mp{get;set;}
    public List<Decimal> Ap{get;set;}
    public List<Decimal> Sp{get;set;}
    public List<Decimal> Hp{get;set;}
    
    public string rcid{get;set;}
    
    public boolean displayRec{get;set;}
    public List<Certification__c> cdisplay;
    
    //Variables to store the parameters passed in the URL
    public String label1 {get; set;}
    public String label2 {get; set;}
    public String label3 {get; set;}
    public String selectedLevel1 {get; set;}
    public String selectedLevel2 {get; set;}
    public String selectedLevel3 {get; set;}
    public String selectedLevel4 {get; set;}
    public List<SelectOption> leftOptions {get;set;}
    public List<SelectOption> rightOptions {get;set;}
    
    public String defaultBreadCrumb{get; set;}
    public String crumValue{get;set;}
    public String levelValue{get;set;}
    public String repName{get;set;}
    
    
    public Set<String> months{get;set;}
    
    public Boolean RoleOverlay{get;set;}
    public Boolean RepOverlay{get;set;}
    
    
    //Map<String, tableWrapper> metricRowMap = new Map<String, tableWrapper>(); 
    
    
    //used to store the value of role for single rep scenario
    private String roleVal;
    
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
    
    public FunnelTrendingByRepController(){
        try{  
            
            label1 = ApexPages.currentPage().getParameters().get('labelOne');
            label2 = ApexPages.currentPage().getParameters().get('labelTwo');
            label3 = ApexPages.currentPage().getParameters().get('labelThree');
            selectedLevel1 = ApexPages.currentPage().getParameters().get('selectOne');
            selectedLevel2 = ApexPages.currentPage().getParameters().get('selectTwo');
            selectedLevel3 = ApexPages.currentPage().getParameters().get('selectThree'); 
            selectedLevel4 = ApexPages.currentPage().getParameters().get('selectFour'); 
            
            leftOptions= new List<SelectOption>();
            rightOptions= new List<SelectOption>();
            displayRec = true;
            cdisplay = new List<Certification__c>();
            cdisplay = [Select Display_Recommendation__c from Certification__c where Sales_Rep_Profile__r.User_Record_Name__c = :UserInfo.getUserId() LIMIT 1];
            
            if(cdisplay != Null && cdisplay.size()>0){
                displayRec =cdisplay[0].Display_Recommendation__c ;
            } 
            
            fw = new FunnelFilterWrapper();
            
            fw.userId = UserInfo.getUserId();
            
            FunnelFilterHelper.populateFilters(fw, 
                                               label1, label2, label3,
                                               selectedLevel1, selectedLevel2, selectedLevel3);
            
            system.debug('fw.selectedLevelThree '+fw.selectedLevelThree);
            system.debug('selectedLevel4 :: '+selectedLevel4);
            
            fw.labelFour = 'Filter By Representative';
            fw.labelFive = 'Filter By Metric/Skill';
            
            fw.levelFour = FunnelFilterHelper.populateLevelFour(fw,'');
            fw.levelFive = FunnelFilterHelper.populateLevelFive(fw,'');
            
            /*if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo == 'All'){
                fw.SelectedLevelFour = 'All' ;
            }*/
            
            /*if(selectedLevel4 != null && selectedLevel4 != '' && selectedLevel4 != 'ALL'){
                fw.SelectedLevelFour  = selectedLevel4;
            }*/
            
            if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All' && fw.selectedLevelTwo != null && fw.selectedLevelTwo != '' && fw.selectedLevelTwo != 'null'){
                fw.selectedLevelTwo = 'All';
                fw.disableLevelThree = false;
            }
            
            //fetchPerfScores();
            
            //showUpdated();
            
            defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw); 
            
            //guildlineList = [select id,name,Description__c,order__c from  EvaluationGuidelines__c ORDER BY order__c ASC limit 5];
            /*
            if(fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
            fetchImportantMetricsForRole();
            } */ 
            leftOptions=fw.levelFive;
            
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelAnalyticQualitativeController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
    }
    
    
    public void showUpdated(){
        try{ 
            RoleOverlay = false; 
            RepOverlay =false;
            
            rcid ='';
            //metric();
            chartLabels = new list<String>();
            chartData = new list<Decimal>();
            Lp = new list<Decimal>();
            Mp = new list<Decimal>();
            Ap = new list<Decimal>();
            Sp = new list<Decimal>();
            Hp = new list<Decimal>();
            //metricRowMap = new Map<String, tableWrapper>();      
            
            //fetchPerfScores();
            
            //Aggregates of a particular level value need to be done
            if(fw.selectedLevelThree == 'All'){
                //Fetch the sales profile record associated with that level
                List<Company_Level__c> cl = [SELECT Sales_Rep_Profile__c FROM Company_Level__c WHERE Level_Value__c = : fw.selectedLevelOne LIMIT 1];
                //aggregate(cl[0].Sales_Rep_Profile__c);  // team aggregation method
                mgr = true;
                //fetchPerformerSet('team',fw.selectedLevelOne);                       
            }
            //A particular rep has been selected and his values need to be displayed
            else if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All'){
                //singleRep(fw.selectedLevelTwo,null);   
                mgr = false;   
                //fetchPerformerSet('rep',fw.selectedLevelTwo); 
                Sales_rep_profile__c sr = [SELECT Role__c,Profile_Type__c FROM Sales_rep_profile__c WHERE id = :fw.selectedLevelTwo];
                rcid = sr.id;
                if(sr.Profile_Type__c != null && sr.Profile_Type__c == 'Overlay'){
                    
                    RepOverlay =true;
                }
                if(sr.Role__c != null){
                    roleVal = sr.Role__c;
                    //fetchImpMetrics();  
                    //fetchImportantMetricsForRole();  
                }                               
            }
            //A particular role has been selected 
            else if (fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
                system.debug('role aggregates');
                mgr = true;
                //aggregateOnRole();
                //fetchPerformerSet('role',fw.selectedLevelThree);  
                //fetchImpMetrics();  
                //fetchImportantMetricsForRole();                                      
            }
            system.debug('fw.selectedLevelTwo :: '+fw.selectedLevelTwo);
            fw.labelFour = 'Filter By Representative';
            fw.labelFive = 'Filter By Metric/Skill';
            if(fw.selectedLevelTwo != '' && fw.selectedLevelTwo == 'All'){
                fw.levelFour = FunnelFilterHelper.populateLevelFour(fw,'One');
                fw.levelFive = FunnelFilterHelper.populateLevelFive(fw,'One');
            }else{
                fw.levelFour = FunnelFilterHelper.populateLevelFour(fw,'');
                fw.levelFive = FunnelFilterHelper.populateLevelFive(fw,'');
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelAnalyticQualitativeController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
    }
    
    public void breadCrumClick(){
        
        fw = new FunnelFilterWrapper();
        FunnelFilterHelper.onclickpopulateFilters(crumValue,fw);
    } 
    
    public PageReference navigateToHomePage(){
        
        return FunnelNavigationHelper.navigateToHomePage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
        
    }
    
    //Action method when level one is changed
    public void levelOneAction(){
        FunnelFilterHelper.levelOneAction(fw);
        defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw);
    } 
    
    //Action method when level two is changed
    public void levelTwoAction(){
        FunnelFilterHelper.levelTwoAction(fw);        
    }
    public PageReference reset(){
        /*        
        isReset = true;
        
        fw.userId = UserInfo.getUserId();  
        
        FunnelFilterHelper.reset(fw);
        */
        
            return FunnelNavigationHelper.navigateToTrendingByRep('','','','','','');
             
    }
    
    
    public class tableWrapper{
        public id metricId {get; set;}
        public Decimal rankingScore {get; set;}
        public String metricName {get; set;}
        public String timing {get; set;}
        public Decimal Percentage {get; set;}
        public Date dueDate {get;set;}
    }
    
    public List<tableWrapper> tableVals1 {get; set;}
    public List<tableWrapper> tableVals2 {get; set;}
    public List<tableWrapper> tableVals3 {get; set;}
    public List<tableWrapper> tableVals4 {get; set;}
    public List<tableWrapper> tableVals5 {get; set;}
    
    public integer sPoint1 {get; set;}
    public integer sPoint2 {get; set;}
    public integer sPoint3 {get; set;}
    public integer sPoint4 {get; set;}
    public integer sPoint5 {get; set;}
    
    public integer iPoint1 {get; set;}
    public integer iPoint2 {get; set;}
    public integer iPoint3 {get; set;}
    public integer iPoint4 {get; set;}
    public integer iPoint5 {get; set;}
        
    Map<String, List<tableWrapper>> metricRowMap = new Map<String, List<tableWrapper>>();
    
    public void levelFiveAction(){
        zeroGoalRating = '';
        Date fiscalYr =  FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        integer fiscalMonth = fiscalYr.month()+2;
        integer fiscalMonthBA = fiscalYr.month()+5;
        system.debug('metric fiscalMonth1 :: '+ fiscalMonth);
        List<integer> quarterMonths = new List<integer>();
        List<integer> biannualMonths = new List<integer>();
        quarterMonths.add(fiscalMonth);
        biannualMonths.add(fiscalMonthBA);
        if(fiscalMonthBA == 12){
            biannualMonths.add(6);
        }else{
            fiscalMonthBA = fiscalMonthBA+6;
            biannualMonths.add(fiscalMonthBA);
        }
        
        biannualMonths.add(fiscalMonthBA);
        for(integer i=0;i<3;i++){
            system.debug('metric fiscalMonth2 :: '+ fiscalMonth);
            if(fiscalMonth == 12 && fiscalMonth!= null){
                quarterMonths.add(3);
                fiscalMonth = 3;
            }else if(fiscalMonth == 11 && fiscalMonth!= null){
                quarterMonths.add(2);
                fiscalMonth = 2;
            }else if(fiscalMonth == 10 && fiscalMonth!= null){
                quarterMonths.add(1);
                fiscalMonth = 1;
            }else{
                fiscalMonth = fiscalMonth + 3;
                quarterMonths.add(fiscalMonth);
            }
        }
        system.debug('metric quarterMonths :: '+ quarterMonths);
        
        sPoint1=0;
        iPoint1=1;
        sPoint2=0;
        iPoint2=1;
        sPoint3=0;
        iPoint3=1;
        sPoint4=0;
        iPoint4=1;
        sPoint5=0;
        iPoint5=1;
        
        tableVals1 = new List<tableWrapper>();
        tableVals2 = new List<tableWrapper>();
        tableVals3 = new List<tableWrapper>();
        tableVals4 = new List<tableWrapper>();
        tableVals5 = new List<tableWrapper>();
        months = new Set<String>();
        metricRowMap = new Map<String, List<tableWrapper>>();
        set<id> cId = new set<id>();
        fw.SelectedLevelFive = new List<String>();
        List<Sales_Rep_Profile__c> sr = new List<Sales_Rep_Profile__c>(); 
        system.debug('metric selected opt :: '+ rightOptions);
        //List<String> splitName = fw.SelectedLevelFive.split(',/');
        //system.debug('metric splitName :: '+ splitName);
        for(selectOption s :rightOptions){
           system.debug('s :: '+s);
           fw.SelectedLevelFive.add(s.getValue()); 
        }
        system.debug('metric selected :: '+ fw.SelectedLevelFive);
        List<Certification_Rating__c> certiList = new List<Certification_Rating__c>();
        system.debug('SelectedLevelFour=='+fw.SelectedLevelFour);
        if(fw.SelectedLevelFour != '' && fw.SelectedLevelFour != 'All'){
            system.debug('SelectedLevelFour=='+fw.SelectedLevelFour);
            sr = [Select name from Sales_Rep_Profile__c where id =: fw.SelectedLevelFour];
        	repName = sr[0].name;
            System.debug('SelectedLevelFive=='+fw.SelectedLevelFive);
            certiList = [select name from Certification_Rating__c where name IN: fw.SelectedLevelFive];
            system.debug('metric certiList :: '+ String.escapeSingleQuotes(fw.SelectedLevelFour));
            System.debug('SelectedLevelFour=='+fw.SelectedLevelFour+' '+certiList);
            List <Certification_Answer__c> cans = [Select name,Sales_Rep_Profile__c, Rating_Score__c, Due_Date__c,Certifcation_Rating__r.Rating_type__c,Certifcation_Rating__r.Metric_Field_Name__c, Certifcation_Rating__r.Goal_field_name__c,Certifcation_Rating__r.Category__c, Certifcation_rating__c, Certifcation_Rating__r.id, Certifcation_Rating__r.name, Certifcation_Rating__r.Timing__c from Certification_Answer__c where Certifcation_rating__c IN : certiList AND Rating_Score__c != null AND Sales_Rep_Profile__c =:String.escapeSingleQuotes(fw.SelectedLevelFour) AND Due_Date__c = LAST_N_DAYS:365 Order By Due_Date__c asc];
            System.debug('cans=='+cans);
           	List <Sales_Rep_Profile_Snapshot__c> srpShot = [Select name,Sales_Rep_Profile__c,Snapshot_Scheduled_Date__c,X12_Month_Rolling_Opptys_Won__c,X12_Month_QO_added__c,X12_Month_Rolling_Revenue__c,Average_Deal_Size__c,YTD_Average_Sales_Cycle__c,
                 X12_Month_Rolling_Average_Sales_Cycle__c,YTD_Lead_Conversion_rate__c,Monthly_QO_added_Quantitative__c,Monthly_Average_Win_size__c,Monthly_Close_Rate__c,Monthly_Opportunity_Close_Rate__c,
                 Number_of_meetings_per_month__c,Monthly_opp_won__c,Monthly_Quota_Revenue__c,Quarterly_Average_Win_Size__c,Quarterly_Close_Rate__c,Quarterly_Opportunity_Close_Rate__c,
                 Number_of_meetings_per_quarter__c,Quarterly_opp_won__c,Quarterly_QO_added_Quantitative__c,Quarterly_Quota_Revenue__c,YTD_Average_win_size__c,YTD_Close_Rate__c,YTD_Opportunity_Close_Rate__c,
                 Number_of_meetings_YTD__c,YTD_Opportunities_won__c,Ytd_QO_added_Quantitative__c,YTD_Revenue__c,X12_Month_Average_Selling_Price__c,X12_Month_Rolling_Opportunity_Close_Rate__c,
                 X12_Month_Rolling_Close_Rate__c,Goal_of_annual_leads_to_achieve_quota__c,Goal_of_annual_opptys_added_to_funnel__c,Goal_of_daily_leads_to_achieve_quota__c,
                 Goal_of_leads_for_1_qualified_oppty__c,Goal_of_leads_for_1_win__c,Goal_of_monthly_leads_to_achieve_quota__c,Goal_of_monthly_meetings__c,
                 Goal_of_monthly_opptys_added_to_funnel__c,Goal_of_quartly_leads_to_achieve_quota__c,Goal_of_quartly_opptys_added_to_funnel__c,Goal_of_wins_to_achieve_annual_quota__c,
                 Goal_of_wins_to_achieve_monthly_quota__c,Goal_of_wins_to_achieve_quartly_quota__c,Goal_of_wins_to_achieve_YTD_quota__c,Goal_of_YTD_leads_to_achieve_quota__c,
                 Goal_of_YTD_meetings__c,Goal_12m_Avg_Selling_Price__c,Goal_12m_Lead_To_Opp_Conv_Rate__c,Goal_12m_length_of_sales_cycle__c,Goal_12_Month_Lead_Added__c,
                 Goal_12_Month_Opportunitie_added_funnel__c,Goal_12Month_Rolling_Opptys_Added_amt__c,Goal_12_Month_Rolling_Opptys_Won__c,Goal_12Month_Rolling_Opptys_Won_amt__c,
                 Goal_12m_rolling_amt_close_rate__c,Goal_12m_rolling_close_rate__c,Goal_Average_Deal_Size__c,Goal_Number_of_meetings_12_months__c,Goal_of_quarterly_meetings__c,Goal_YTD_Opportunities_Added__c,X12_Month_Rolling_Quota_Performance__c,Annual_Opportunity_Quota__c,Annual_Quota_Amount__c,Annual_Win_Quota__c,YTD_Quota__c,FunnelMetrics__Monthly_quota__c,FunnelMetrics__Quarterly_Quota__c,
                 FMCustom_Metric_1Goal__c,FMCustom_Metric_2Goal__c,FMCustom_Metric_3Goal__c,FMCustom_Metric_4Goal__c,FMCustom_Metric_5Goal__c,FMCustom_Metric_6Goal__c,FMCustom_Metric_7Goal__c,FMCustom_Metric_8Goal__c,FMCustom_Metric_9Goal__c,
                 FMCustom_Metric_10Goal__c,FMCustom_Metric_11Goal__c,FMCustom_Metric_12Goal__c,FMCustom_Metric_13Goal__c,FMCustom_Metric_14Goal__c,FMCustom_Metric_15Goal__c,FMCustom_Metric_16Goal__c,FMCustom_Metric_17Goal__c,FMCustom_Metric_18Goal__c,FMCustom_Metric_19Goal__c,
                 FMCustom_Metric_20Goal__c,FMCustom_Metric_21Goal__c,FMCustom_Metric_22Goal__c,FMCustom_Metric_23Goal__c,FMCustom_Metric_24Goal__c,FMCustom_Metric_25Goal__c,FMCustom_Metric_26Goal__c,FMCustom_Metric_27Goal__c,FMCustom_Metric_28Goal__c,FMCustom_Metric_29Goal__c,
                 FMCustom_Metric_30Goal__c,FMCustom_Metric_31Goal__c,FMCustom_Metric_32Goal__c,FMCustom_Metric_33Goal__c,FMCustom_Metric_34Goal__c,FMCustom_Metric_35Goal__c,FMCustom_Metric_36Goal__c,FMCustom_Metric_37Goal__c,FMCustom_Metric_38Goal__c,FMCustom_Metric_39Goal__c,
                 FMCustom_Metric_41Goal__c,FMCustom_Metric_42Goal__c,FMCustom_Metric_43Goal__c,FMCustom_Metric_44Goal__c,FMCustom_Metric_45Goal__c,FMCustom_Metric_47Goal__c,FMCustom_Metric_48Goal__c,FMCustom_Metric_49Goal__c,FMCustom_Metric_50Goal__c,X12_Month_Rolling_Quota__c,  
                 FMCustom_Metric_1__c,FMCustom_Metric_2__c,FMCustom_Metric_3__c,FMCustom_Metric_4__c,FMCustom_Metric_5__c,FMCustom_Metric_6__c,FMCustom_Metric_7__c,FMCustom_Metric_8__c,FMCustom_Metric_9__c,
                 FMCustom_Metric_10__c,FMCustom_Metric_11__c,FMCustom_Metric_12__c,FMCustom_Metric_13__c,FMCustom_Metric_14__c, FMCustom_Metric_15__c,FMCustom_Metric_16__c,FMCustom_Metric_17__c,FMCustom_Metric_18__c,FMCustom_Metric_19__c,
                 FMCustom_Metric_20__c,FMCustom_Metric_21__c,FMCustom_Metric_22__c,FMCustom_Metric_23__c,FMCustom_Metric_24__c, FMCustom_Metric_25__c,FMCustom_Metric_26__c,FMCustom_Metric_27__c,FMCustom_Metric_28__c,FMCustom_Metric_29__c,
                 FMCustom_Metric_30__c,FMCustom_Metric_31__c,FMCustom_Metric_32__c,FMCustom_Metric_33__c,FMCustom_Metric_34__c, FMCustom_Metric_35__c,FMCustom_Metric_36__c,FMCustom_Metric_37__c,FMCustom_Metric_38__c,FMCustom_Metric_39__c,
                 FMCustom_Metric_40__c,FMCustom_Metric_41__c,FMCustom_Metric_42__c,FMCustom_Metric_43__c,FMCustom_Metric_44__c, FMCustom_Metric_45__c,FMCustom_Metric_46__c,FMCustom_Metric_47__c,FMCustom_Metric_48__c,FMCustom_Metric_49__c,FMCustom_Metric_50__c,
                 Number_of_meetings_Rolling_12_months__c from Sales_Rep_Profile_Snapshot__c where  Sales_Rep_Profile__c = : fw.SelectedLevelFour And Snapshot_Scheduled_Date__c = LAST_N_DAYS:365];//system.debug('metric cans :: '+ cans);
            //system.debug('metric month :: '+ cans[0].Due_Date__c.month());
            integer i = 0;
            for(Certification_Answer__c c : cans){
                i++;
                String year = String.valueOf(c.Due_Date__c.Year()).right(2);
                String mnth = fetchMonthString(c.Due_Date__c.month());
                String mnyr = mnth+year;
                if(c.Due_Date__c != null){
                    months.add(mnyr);
                }else{
                    months.add('');
                }
                system.debug('mnyr :: '+mnyr);
                tableWrapper tw = new tableWrapper();
                tw.metricId = c.Certifcation_Rating__r.id;
                tw.metricName = c.Certifcation_Rating__r.name;
                tw.rankingScore = c.FunnelMetrics__Rating_Score__c;
                if(c.Certifcation_Rating__r.Category__c == 'Quantitative'){
                    for(Sales_Rep_Profile_Snapshot__c ss : srpShot){
                        if(ss.Sales_Rep_Profile__c == c.Sales_Rep_Profile__c && c.Due_Date__c == ss.Snapshot_Scheduled_Date__c){
                            system.debug('Actual :: '+integer.valueOf(ss.get(c.Certifcation_Rating__r.Metric_Field_Name__c))+' Goal :: '+integer.valueOf(ss.get(c.Certifcation_Rating__r.Goal_field_name__c)));
                            decimal actual = integer.valueOf(ss.get(c.Certifcation_Rating__r.Metric_Field_Name__c));
                            decimal goal = integer.valueOf(ss.get(c.Certifcation_Rating__r.Goal_field_name__c));
                            if(goal!=0 && goal != null){
                                tw.Percentage = (actual/goal)*100;
                                tw.Percentage = tw.Percentage.setScale(2, RoundingMode.HALF_UP);
                            }else{ 
                                system.debug('inside if '+zeroGoalRating );
                                if(zeroGoalRating == ''){
                                    zeroGoalRating = c.Certifcation_Rating__r.name;
                                }else{
                                    system.debug('inside if 2 '+zeroGoalRating );
                                    if(!zeroGoalRating.contains(c.Certifcation_Rating__r.name)){
                                    zeroGoalRating += '; '+c.Certifcation_Rating__r.name;
                                    }
                                    system.debug('inside if 3 '+zeroGoalRating );
                                }
                                
                            }
                        }
                    }
                }else{
                    tw.Percentage = (c.FunnelMetrics__Rating_Score__c/5)*100;
                    tw.Percentage = tw.Percentage.setScale(2, RoundingMode.HALF_UP);
                }
                tw.timing = c.Certifcation_Rating__r.Timing__c;
                tw.dueDate=c.Due_Date__c;
                system.debug('monthYear :: '+tw.timing);
                if(cId.contains(tw.metricId)){
                    metricRowMap.get(tw.metricId).add(tw);
                }else{
                    metricRowMap.put(tw.metricId,new List<tableWrapper>{tw});
                    cId.add(tw.metricId);
                }
                
            }
            system.debug('inside if 4 '+zeroGoalRating );
            if(zeroGoalRating != '' && zeroGoalRating != null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'For Your Information: The '+zeroGoalRating+' metric has one or more previous months where a goal was not set or is 0. This reduces the trending data displayed'));
            }
        }
        system.debug('metric metricRowMap :: '+ metricRowMap);
        system.debug('metric cId :: '+ cId);
        List<id> c = new List<String>();
        c.addAll(cId);
        system.debug('metric c :: '+ c);
        integer ListSize = cId.size();
        for(integer i =0; i<ListSize; i++){
            if(i == 0 && i != null){
                tableVals1= metricRowMap.get(c[i]);
            }
            if(i == 1 && i != null){
                tableVals2= metricRowMap.get(c[i]);
            }
            if(i == 2 && i != null){
                tableVals3= metricRowMap.get(c[i]);
            }
            if(i == 3 && i != null){
                tableVals4= metricRowMap.get(c[i]);
            }
            if(i == 4 && i != null){
                tableVals5= metricRowMap.get(c[i]);
            }
        }
        if(tableVals1.size()>0){
            if(tableVals1[0].timing == 'End of quarter'){
                integer dueMnth = tableVals1[0].dueDate.month();
                integer startMnth = Date.Today().Month() + 1;
                system.debug('metric dueMnth :: '+ dueMnth);
                system.debug('metric startMnth :: '+ startMnth);
                
                integer count = 0;
                for(integer i=0;i<4;i++){
                    if(!quarterMonths.contains(startMnth)){
                        count++;
                        startMnth++;
                    }
                }
                if(count==0){
                    count++;
                }
                
                if((tableVals2.size()>0 && tableVals2[0].timing == 'End of month') || (tableVals3.size()>0 && tableVals3[0].timing == 'End of month') || (tableVals4.size()>0 && tableVals4[0].timing == 'End of month') || (tableVals5.size()>0 && tableVals5[0].timing == 'End of month')){
                    sPoint1 = count;
                    iPoint1 = 3;
                }
            }else if(tableVals1[0].timing == 'Bi-annual'){
                integer dueMnth = tableVals1[0].dueDate.month();
                integer startMnth = Date.Today().Month() + 1;
                integer count = 0;
                for(integer i=0;i<6;i++){
                    if(startMnth != dueMnth){
                        count++;
                        startMnth++;
                    }
                }
                if(count==0){
                    count++;
                }
                if((tableVals2.size()>0 && tableVals2[0].timing == 'End of month') || (tableVals3.size()>0 && tableVals3[0].timing == 'End of month') || (tableVals4.size()>0 && tableVals4[0].timing == 'End of month') || (tableVals5.size()>0 && tableVals5[0].timing == 'End of month')){
                    sPoint1 = count;
                    iPoint1 = 6;
                }else if((tableVals2.size()>0 && tableVals2[0].timing == 'End of quarter') || (tableVals3.size()>0 && tableVals3[0].timing == 'End of quarter') || (tableVals4.size()>0 && tableVals4[0].timing == 'End of quarter') || (tableVals5.size()>0 && tableVals5[0].timing == 'End of quarter')){
                    sPoint1 = count;
                    iPoint1 = 3;
                }
            }
        }
        if(tableVals2.size()>0){
            if(tableVals2[0].timing == 'End of quarter'){
                integer dueMnth = tableVals2[0].dueDate.month();
                integer startMnth = Date.Today().Month() + 1;
                system.debug('metric dueMnth :: '+ dueMnth);
                system.debug('metric startMnth :: '+ startMnth);
                
                integer count = 0;
                for(integer i=0;i<4;i++){
                    if(!quarterMonths.contains(startMnth)){
                        count++;
                        startMnth++;
                    }
                }
                if(count==0){
                    count++;
                }
                if((tableVals1.size()>0 && tableVals1[0].timing == 'End of month') || (tableVals3.size()>0 && tableVals3[0].timing == 'End of month') || (tableVals4.size()>0 && tableVals4[0].timing == 'End of month') || (tableVals5.size()>0 && tableVals5[0].timing == 'End of month')){
                    sPoint2 = count;
                    iPoint2 = 3;
                }
            }else if(tableVals2[0].timing == 'Bi-annual'){
                integer dueMnth = tableVals2[0].dueDate.month();
                integer startMnth = Date.Today().Month() + 1;
                integer count = 0;
                for(integer i=0;i<6;i++){
                    if(startMnth != dueMnth){
                        count++;
                        startMnth++;
                    }
                }
                if(count==0){
                    count++;
                }
                if((tableVals1.size()>0 && tableVals1[0].timing == 'End of month') || (tableVals3.size()>0 && tableVals3[0].timing == 'End of month') || (tableVals4.size()>0 && tableVals4[0].timing == 'End of month') || (tableVals5.size()>0 && tableVals5[0].timing == 'End of month')){
                    sPoint2 = count;
                    iPoint2 = 6;
                }else if((tableVals1.size()>0 && tableVals1[0].timing == 'End of quarter') || (tableVals3.size()>0 && tableVals3[0].timing == 'End of quarter') || (tableVals4.size()>0 && tableVals4[0].timing == 'End of quarter') || (tableVals5.size()>0 && tableVals5[0].timing == 'End of quarter')){
                    sPoint2 = count;
                    iPoint2 = 3;
                }
            }
        }
        if(tableVals3.size()>0){
            if(tableVals3[0].timing == 'End of quarter'){
                integer dueMnth = tableVals3[0].dueDate.month();
                integer startMnth = Date.Today().Month() + 1;
                system.debug('metric dueMnth :: '+ dueMnth);
                system.debug('metric startMnth :: '+ startMnth);
                
                integer count = 0;
                for(integer i=0;i<4;i++){
                    if(!quarterMonths.contains(startMnth)){
                        count++;
                        startMnth++;
                    }
                }
                if(count==0){
                    count++;
                }
                if((tableVals1.size()>0 && tableVals1[0].timing == 'End of month') || (tableVals2.size()>0 && tableVals2[0].timing == 'End of month') || (tableVals4.size()>0 && tableVals4[0].timing == 'End of month') || (tableVals5.size()>0 && tableVals5[0].timing == 'End of month')){
                    sPoint3 = count;
                    iPoint3 = 3;
                }
            }else if(tableVals3[0].timing == 'Bi-annual'){
                integer dueMnth = tableVals3[0].dueDate.month();
                integer startMnth = Date.Today().Month() + 1;
                integer count = 0;
                for(integer i=0;i<6;i++){
                    if(startMnth != dueMnth){
                        count++;
                        startMnth++;
                    }
                }
                if(count==0){
                    count++;
                }
                if((tableVals2.size()>0 && tableVals2[0].timing == 'End of month') || (tableVals1.size()>0 && tableVals1[0].timing == 'End of month') || (tableVals4.size()>0 && tableVals4[0].timing == 'End of month') || (tableVals5.size()>0 && tableVals5[0].timing == 'End of month')){
                    sPoint3 = count;
                    iPoint3 = 6;
                }else if((tableVals2.size()>0 && tableVals2[0].timing == 'End of quarter') || (tableVals1.size()>0 && tableVals1[0].timing == 'End of quarter') || (tableVals4.size()>0 && tableVals4[0].timing == 'End of quarter') || (tableVals5.size()>0 && tableVals5[0].timing == 'End of quarter')){
                    sPoint3 = count;
                    iPoint3 = 3;
                }
            }
        }
        if(tableVals4.size()>0){
            if(tableVals4[0].timing == 'End of quarter'){
                integer dueMnth = tableVals4[0].dueDate.month();
                integer startMnth = Date.Today().Month() + 1;
                system.debug('metric dueMnth :: '+ dueMnth);
                system.debug('metric startMnth :: '+ startMnth);
                
                integer count = 0;
                for(integer i=0;i<4;i++){
                    if(!quarterMonths.contains(startMnth)){
                        count++;
                        startMnth++;
                    }
                }
                if(count==0){
                    count++;
                }
                if((tableVals1.size()>0 && tableVals1[0].timing == 'End of month') || (tableVals2.size()>0 && tableVals2[0].timing == 'End of month') || (tableVals3.size()>0 && tableVals3[0].timing == 'End of month') || (tableVals5.size()>0 && tableVals5[0].timing == 'End of month')){
                    sPoint4 = count;
                    iPoint4 = 3;
                }
            }else if(tableVals4[0].timing == 'Bi-annual'){
                integer dueMnth = tableVals4[0].dueDate.month();
                integer startMnth = Date.Today().Month() + 1;
                integer count = 0;
                for(integer i=0;i<6;i++){
                    if(startMnth != dueMnth){
                        count++;
                        startMnth++;
                    }
                }
                if(count==0){
                    count++;
                }
                if((tableVals2.size()>0 && tableVals2[0].timing == 'End of month') || (tableVals3.size()>0 && tableVals3[0].timing == 'End of month') || (tableVals1.size()>0 && tableVals1[0].timing == 'End of month') || (tableVals5.size()>0 && tableVals5[0].timing == 'End of month')){
                    sPoint4 = count;
                    iPoint4 = 6;
                }else if((tableVals2.size()>0 && tableVals2[0].timing == 'End of quarter') || (tableVals3.size()>0 && tableVals3[0].timing == 'End of quarter') || (tableVals1.size()>0 && tableVals1[0].timing == 'End of quarter') || (tableVals5.size()>0 && tableVals5[0].timing == 'End of quarter')){
                    sPoint4 = count;
                    iPoint4 = 3;
                }
            }
        }
        if(tableVals5.size()>0){
            if(tableVals5[0].timing == 'End of quarter'){
                integer dueMnth = tableVals5[0].dueDate.month();
                integer startMnth = Date.Today().Month() + 1;
                system.debug('metric dueMnth :: '+ dueMnth);
                system.debug('metric startMnth :: '+ startMnth);
                
                integer count = 0;
                for(integer i=0;i<4;i++){
                    if(!quarterMonths.contains(startMnth)){
                        count++;
                        startMnth++;
                    }
                }
                if(count==0){
                    count++;
                }
                if((tableVals1.size()>0 && tableVals1[0].timing == 'End of month') || (tableVals2.size()>0 && tableVals2[0].timing == 'End of month') || (tableVals3.size()>0 && tableVals3[0].timing == 'End of month') || (tableVals4.size()>0 && tableVals4[0].timing == 'End of month')){
                    sPoint5 = count;
                    iPoint5 = 3;
                }
            }else if(tableVals5[0].timing == 'Bi-annual'){
                integer dueMnth = tableVals5[0].dueDate.month();
                integer startMnth = Date.Today().Month() + 1;
                integer count = 0;
                for(integer i=0;i<6;i++){
                    if(startMnth != dueMnth){
                        count++;
                        startMnth++;
                    }
                }
                if(count==0){
                    count++;
                }
                if((tableVals2.size()>0 && tableVals2[0].timing == 'End of month') || (tableVals3.size()>0 && tableVals3[0].timing == 'End of month') || (tableVals4.size()>0 && tableVals4[0].timing == 'End of month') || (tableVals1.size()>0 && tableVals1[0].timing == 'End of month')){
                    sPoint5 = count;
                    iPoint5 = 6;
                }else if((tableVals2.size()>0 && tableVals2[0].timing == 'End of quarter') || (tableVals3.size()>0 && tableVals3[0].timing == 'End of quarter') || (tableVals4.size()>0 && tableVals4[0].timing == 'End of quarter') || (tableVals1.size()>0 && tableVals1[0].timing == 'End of quarter')){
                    sPoint5 = count;
                    iPoint5 = 3;
                }
            }
        }
        
        system.debug('gmetricname1 :: '+tableVals1+'  grankingScore1 :: '+tableVals2);
        
    }
    
    
    public PageReference navigateToCertification(){
        
        //return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToDashboard(){
        
        //return FunnelNavigationHelper.navigateToDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    public PageReference navigateToCertificateReports(){
        
        return FunnelNavigationHelper.navigateToCertificateReports(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToReportsPage(){
        
        //return FunnelNavigationHelper.navigateToReportsPage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToReportsPage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    public PageReference navigateToAnnualizationDashboard(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToFunnelAnalytic(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    } 
    
    public PageReference navigateToFunnelAnalyticQualitative(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    } 
    
    public PageReference navigateToSalesPipeline(){
        
        return FunnelNavigationHelper.navigateToSalesPipeline(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToTrendingBySkill(){
        
        return FunnelNavigationHelper.navigateToTrendingBySkill(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToCalculator(){
        
        return FunnelNavigationHelper.navigateToCalculator(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }    
    public PageReference navigateToAppSetup(){
        
        return FunnelNavigationHelper.navigateToAppSetupPage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    public PageReference navigateToGoals(){
        
        return FunnelNavigationHelper.navigateToGoalsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    public PageReference navigateToHelpMenu(){
        
        return FunnelNavigationHelper.navigateToHelpMenu();
        
    }
    
    public String fetchMonthString(Integer mon){

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
     
     public String getMonthss() {
        return JSON.serialize(months); // Third graph - Funnelocity Score
     }
    
}