public with sharing class FunnelTrendingBySkillController {
    
    public FunnelFilterWrapper fw {get; set;}
    
    public string zeroGoalRating{get;set;}
    public boolean showError{get;set;}
    
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
    public List<SelectOption> leftOptions {get;set;}
    public List<SelectOption> rightOptions {get;set;}
    
    public String defaultBreadCrumb{get; set;}
    public String crumValue{get;set;}
    public String levelValue{get;set;}
    
    
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
    
    public FunnelTrendingBySkillController(){
        try{
            leftOptions= new List<SelectOption>();
            rightOptions= new List<SelectOption>();
            displayRec = true;
            maxVal = 0;
            cdisplay = new List<Certification__c>();
            cdisplay = [Select Display_Recommendation__c from Certification__c where Sales_Rep_Profile__r.User_Record_Name__c = :UserInfo.getUserId() LIMIT 1];
            
            if(cdisplay != Null && cdisplay.size()>0){
                displayRec =cdisplay[0].Display_Recommendation__c ;
            }  
            
            label1 = ApexPages.currentPage().getParameters().get('labelOne');
            label2 = ApexPages.currentPage().getParameters().get('labelTwo');
            label3 = ApexPages.currentPage().getParameters().get('labelThree');
            selectedLevel1 = ApexPages.currentPage().getParameters().get('selectOne');
            selectedLevel2 = ApexPages.currentPage().getParameters().get('selectTwo');
            selectedLevel3 = ApexPages.currentPage().getParameters().get('selectThree');  
            
            fw = new FunnelFilterWrapper();
            
            fw.userId = UserInfo.getUserId();
            
            FunnelFilterHelper.populateFilters(fw, 
                                               label1, label2, label3,
                                               selectedLevel1, selectedLevel2, selectedLevel3);
            
            system.debug('fw.selectedLevelThree '+fw.selectedLevelThree);
            
            fw.labelFour = 'Filter By Metric/Skill';
            fw.labelFive = 'Filter By Representative';
            
            
            fw.levelFour = FunnelFilterHelper.populateLevelFour(fw,'');
            fw.levelFive = FunnelFilterHelper.populateLevelFive(fw,'');
            
            system.debug('isRep :: '+fw.isRep);
            system.debug('isRep :: '+fw.levelTwo);
            
            
            
            showUpdated();
            
            if(fw.isRep != null && fw.isRep){
                system.debug('inside isrep');
                fw.selectedLevelFour = '';
                List<Sales_rep_profile__c> srLst = new List<Sales_rep_profile__c>([select id,name from Sales_rep_profile__c where id=: fw.selectedLevelTwo]);
                List<SelectOption> opt = new List<SelectOption>();
                opt.add(new SelectOption(srLst[0].id,srLst[0].name));
                fw.levelFive = opt;
            }
            
            if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All' && fw.selectedLevelTwo != null && fw.selectedLevelTwo != '' && fw.selectedLevelTwo != 'null'){
                fw.selectedLevelTwo = 'All';
                fw.disableLevelThree = false;
            }
            
            defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw); 
            
             
            
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
            //metricRowMap = new Map<String, tableWrapper>();
            
            //Aggregates of a particular level value need to be done
            if(fw.selectedLevelThree == 'All'){
                List<Company_Level__c> cl = [SELECT Sales_Rep_Profile__c FROM Company_Level__c WHERE Level_Value__c = : fw.selectedLevelOne LIMIT 1];
                mgr = true;                       
            }
            //A particular rep has been selected and his values need to be displayed
            else if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All'){  
                mgr = false;   
                Sales_rep_profile__c sr = [SELECT Role__c,Profile_Type__c FROM Sales_rep_profile__c WHERE id = :fw.selectedLevelTwo];
                rcid = sr.id;
                if(sr.Profile_Type__c != null && sr.Profile_Type__c == 'Overlay'){
                    
                    RepOverlay =true;
                }
                if(sr.Role__c != null){
                    roleVal = sr.Role__c;  
                }                               
            }
            fw.labelFour = 'Filter By Metric/Skill';
            fw.labelFive = 'Filter By Representative';
            if(fw.selectedLevelTwo != '' && fw.selectedLevelTwo == 'All'){
                fw.levelFour = FunnelFilterHelper.populateLevelFour(fw,'One');
                fw.levelFive = FunnelFilterHelper.populateLevelFive(fw,'One');
            }else{
                fw.levelFour = FunnelFilterHelper.populateLevelFour(fw,'');
                fw.levelFive = FunnelFilterHelper.populateLevelFive(fw,'');
            }
            system.debug('fw.labelFive :: '+fw.labelFive+' fw.levelFive :: '+fw.levelFive);
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelAnalyticQualitativeController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
    }
    
    public void breadCrumClick(){
        
        fw = new FunnelFilterWrapper();
        fw.labelFive = 'Filter By Representative';
        FunnelFilterHelper.onclickpopulateFilters(crumValue,fw);
        system.debug('level1 :: '+fw.selectedLevelOne);
        system.debug('level3 :: '+fw.selectedLevelThree);
    } 
    
    public PageReference navigateToHomePage(){
        if(fw.selectedLevelFive != null && fw.selectedLevelFive.size()>0){
            return FunnelNavigationHelper.navigateToHomePage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFive[0]);
        }else{
            return FunnelNavigationHelper.navigateToHomePage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,'All');
        }
        
        
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
        
            return FunnelNavigationHelper.navigateToTrendingBySkill('','','','','','');
             
    }
    
    
    public class tableWrapper{
        public id metricId {get; set;}
        public Decimal rankingScore {get; set;}
        public String metricName {get; set;}
        public String ratingType {get; set;}
        public Decimal actual {get; set;}
        public Decimal Percentage {get; set;}
        public Date dueDate {get; set;}
    }
    
    public List<tableWrapper> tableVals1 {get; set;}
    public List<tableWrapper> tableVals2 {get; set;}
    public List<tableWrapper> tableVals3 {get; set;}
    public List<tableWrapper> tableVals4 {get; set;}
    public List<tableWrapper> tableVals5 {get; set;}
    public List<String> actualPlot {get;set;}
    public String actualLabel {get;set;}
    public Decimal maxVal {get;set;}
        
    Map<String, List<tableWrapper>> metricRowMap = new Map<String, List<tableWrapper>>();
    
    public void levelFiveAction(){
        zeroGoalRating = '';
        showError = false;
        tableVals1 = new List<tableWrapper>();
        tableVals2 = new List<tableWrapper>();
        tableVals3 = new List<tableWrapper>();
        tableVals4 = new List<tableWrapper>();
        tableVals5 = new List<tableWrapper>();
        months = new Set<String>();
        metricRowMap = new Map<String, List<tableWrapper>>();
        set<id> sId = new set<id>();
        actualPlot = new List<String>();
        fw.SelectedLevelFive = new List<String>();
        maxVal = 0;
        
        system.debug('metric selected :: '+ fw.SelectedLevelFive);
        //List<String> splitName = fw.SelectedLevelFive.split(',/');
        //system.debug('metric splitName :: '+ splitName);
        //system.debug('metric certiList :: '+ String.escapeSingleQuotes(fw.SelectedLevelFour));
        for(selectOption s :rightOptions){
           system.debug('s :: '+s);
           fw.SelectedLevelFive.add(s.getValue()); 
        }
        if(fw.SelectedLevelFour != '' && fw.SelectedLevelFour != 'All'){
            
            List<Certification_Rating__c> cType = [Select id,name,Rating_type__c,Metric_Field_Name__c from Certification_Rating__c where name =:String.escapeSingleQuotes(fw.SelectedLevelFour)];
            system.debug(' cType '+cType);
            
            //List <Certification_Answer__c> cansTest = [Select name, Due_Date__c, Rating_Score__c,Certifcation_Rating__r.Rating_type__c,Certifcation_Rating__r.Category__c,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name,Certifcation_rating__c, Certifcation_Rating__r.id,Certifcation_Rating__r.Metric_Field_Name__c, Certifcation_Rating__r.name, Certifcation_Rating__r.Calculation_type__c from Certification_Answer__c];
            //system.debug(cansTest[0].Sales_rep_profile__c);
            //system.debug(' cansTest '+cansTest);
            system.debug(' fw.SelectedLevelFive '+fw.SelectedLevelFive);
            system.debug(' fw.SelectedLevelFour '+fw.SelectedLevelFour);
            List <Certification_Answer__c> cans = [Select name, Due_Date__c, Rating_Score__c,Certifcation_Rating__r.Rating_type__c,Certifcation_Rating__r.Category__c,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name,Certifcation_rating__c, Certifcation_Rating__r.id,Certifcation_Rating__r.Metric_Field_Name__c, Certifcation_Rating__r.Goal_field_name__c, Certifcation_Rating__r.name, Certifcation_Rating__r.Calculation_type__c from Certification_Answer__c where Certifcation_rating__r.name =:String.escapeSingleQuotes(fw.SelectedLevelFour) AND Sales_Rep_Profile__c IN : fw.SelectedLevelFive AND Rating_Score__c != null AND Due_Date__c = LAST_N_DAYS:365 Order By Due_Date__c asc];
            List <Sales_Rep_Profile_Snapshot__c> srpShot = [Select name,Sales_Rep_Profile__c,Snapshot_Scheduled_Date__c,X12_Month_Rolling_Opptys_Won__c,X12_Month_QO_added__c,X12_Month_Rolling_Revenue__c,Average_Deal_Size__c,YTD_Average_Sales_Cycle__c,X12_Month_Rolling_Average_Sales_Cycle__c,YTD_Lead_Conversion_rate__c,Monthly_QO_added_Quantitative__c,Monthly_Average_Win_size__c,Monthly_Close_Rate__c,Monthly_Opportunity_Close_Rate__c,Number_of_meetings_per_month__c,Monthly_opp_won__c,Monthly_Quota_Revenue__c,Quarterly_Average_Win_Size__c,Quarterly_Close_Rate__c,Quarterly_Opportunity_Close_Rate__c,Number_of_meetings_per_quarter__c,Quarterly_opp_won__c,Quarterly_QO_added_Quantitative__c,Quarterly_Quota_Revenue__c,YTD_Average_win_size__c,YTD_Close_Rate__c,YTD_Opportunity_Close_Rate__c,Number_of_meetings_YTD__c,YTD_Opportunities_won__c,Ytd_QO_added_Quantitative__c,YTD_Revenue__c,FMCustom_Metric_1__c,FMCustom_Metric_9__c,FMCustom_Metric_4__c,FMCustom_Metric_2__c,FMCustom_Metric_3__c,FMCustom_Metric_10__c,Number_of_meetings_Rolling_12_months__c,X12_Month_Average_Selling_Price__c,X12_Month_Rolling_Opportunity_Close_Rate__c,X12_Month_Rolling_Close_Rate__c,Goal_of_annual_leads_to_achieve_quota__c,Goal_of_annual_opptys_added_to_funnel__c,Goal_of_daily_leads_to_achieve_quota__c,Goal_of_leads_for_1_qualified_oppty__c,Goal_of_leads_for_1_win__c,Goal_of_monthly_leads_to_achieve_quota__c,Goal_of_monthly_meetings__c,Goal_of_monthly_opptys_added_to_funnel__c,Goal_of_quartly_leads_to_achieve_quota__c,Goal_of_quartly_opptys_added_to_funnel__c,Goal_of_wins_to_achieve_annual_quota__c,Goal_of_wins_to_achieve_monthly_quota__c,Goal_of_wins_to_achieve_quartly_quota__c,Goal_of_wins_to_achieve_YTD_quota__c,Goal_of_YTD_leads_to_achieve_quota__c,Goal_of_YTD_meetings__c,Goal_12m_Avg_Selling_Price__c,Goal_12m_Lead_To_Opp_Conv_Rate__c,Goal_12m_length_of_sales_cycle__c,Goal_12_Month_Lead_Added__c,Goal_12_Month_Opportunitie_added_funnel__c,Goal_12Month_Rolling_Opptys_Added_amt__c,Goal_12_Month_Rolling_Opptys_Won__c,Goal_12Month_Rolling_Opptys_Won_amt__c,Goal_12m_rolling_amt_close_rate__c,Goal_12m_rolling_close_rate__c,Goal_Average_Deal_Size__c,Goal_Number_of_meetings_12_months__c,Goal_of_quarterly_meetings__c,Goal_YTD_Opportunities_Added__c,FMCustom_Metric_10Goal__c,FMCustom_Metric_11Goal__c,FMCustom_Metric_12Goal__c,FMCustom_Metric_13Goal__c,FMCustom_Metric_14Goal__c,FMCustom_Metric_15Goal__c,FMCustom_Metric_16Goal__c,FMCustom_Metric_17Goal__c,FMCustom_Metric_18Goal__c,FMCustom_Metric_19Goal__c,FMCustom_Metric_1Goal__c,FMCustom_Metric_20Goal__c,FMCustom_Metric_21Goal__c,FMCustom_Metric_22Goal__c,FMCustom_Metric_23Goal__c,FMCustom_Metric_24Goal__c,FMCustom_Metric_25Goal__c,FMCustom_Metric_26Goal__c,FMCustom_Metric_27Goal__c,FMCustom_Metric_28Goal__c,FMCustom_Metric_29Goal__c,FMCustom_Metric_2Goal__c,FMCustom_Metric_30Goal__c,FMCustom_Metric_31Goal__c,FMCustom_Metric_32Goal__c,FMCustom_Metric_33Goal__c,FMCustom_Metric_34Goal__c,FMCustom_Metric_35Goal__c,FMCustom_Metric_36Goal__c,FMCustom_Metric_37Goal__c,FMCustom_Metric_38Goal__c,FMCustom_Metric_39Goal__c,FMCustom_Metric_38__c,FMCustom_Metric_3Goal__c,FMCustom_Metric_40Goal__c,FMCustom_Metric_41Goal__c,FMCustom_Metric_42Goal__c,FMCustom_Metric_43Goal__c,FMCustom_Metric_44Goal__c,FMCustom_Metric_45Goal__c,FMCustom_Metric_47Goal__c,FMCustom_Metric_48Goal__c,FMCustom_Metric_49Goal__c,FMCustom_Metric_4Goal__c,FMCustom_Metric_50Goal__c,FMCustom_Metric_5Goal__c,FMCustom_Metric_6Goal__c,FMCustom_Metric_7Goal__c,FMCustom_Metric_8Goal__c,FMCustom_Metric_9Goal__c,X12_Month_Rolling_Quota__c,X12_Month_Rolling_Quota_Performance__c,Annual_Opportunity_Quota__c,Annual_Quota_Amount__c,Annual_Win_Quota__c,YTD_Quota__c,FunnelMetrics__Monthly_quota__c,FunnelMetrics__Quarterly_Quota__c,FMCustom_Metric_15__c,FMCustom_Metric_19__c,FMCustom_Metric_21__c,FMCustom_Metric_11__c,FMCustom_Metric_16__c,FMCustom_Metric_20__c,FMCustom_Metric_17__c,FMCustom_Metric_12__c,FMCustom_Metric_7__c,FMCustom_Metric_13__c,FMCustom_Metric_18__c,FMCustom_Metric_8__c,FMCustom_Metric_14__c from Sales_Rep_Profile_Snapshot__c where  Sales_Rep_Profile__c IN : fw.SelectedLevelFive And Snapshot_Scheduled_Date__c = LAST_N_DAYS:365];
            Sales_Rep_Profile_Snapshot__c srpSS = new Sales_Rep_Profile_Snapshot__c();
            system.debug('metric cans :: '+ cans);
            List<Date> dueDates = new List<Date>();
            for(Certification_Answer__c c : cans){
                String year = String.valueOf(c.Due_Date__c.Year()).right(2);
                String mnth = fetchMonthString(c.Due_Date__c.month());
                String mnyr = mnth+year;
                
                 if(!dueDates.contains(c.Due_Date__c)){
                    dueDates.add(c.Due_Date__c);
                }
                
                if(c.Due_Date__c != null){
                    months.add(mnyr);
                }else{
                    months.add('');
                }
                tableWrapper tw = new tableWrapper();
                tw.metricId = c.Sales_Rep_Profile__c;
                tw.metricName = c.Sales_Rep_Profile__r.name;
                tw.rankingScore = c.FunnelMetrics__Rating_Score__c;
                tw.ratingType = c.Certifcation_Rating__r.Rating_type__c;
                tw.dueDate = c.Due_date__c;
                
                if(c.Certifcation_Rating__r.Category__c == 'Quantitative'){
                    for(Sales_Rep_Profile_Snapshot__c ss : srpShot){
                        if(ss.Sales_Rep_Profile__c == c.Sales_Rep_Profile__c && c.Due_Date__c == ss.Snapshot_Scheduled_Date__c){
                            tw.actual = (decimal)(ss.get(c.Certifcation_Rating__r.Metric_Field_Name__c));
                            tw.actual = tw.actual.setScale(2, RoundingMode.HALF_UP);
                            system.debug('Actual :: '+integer.valueOf(ss.get(c.Certifcation_Rating__r.Metric_Field_Name__c))+' Goal :: '+integer.valueOf(ss.get(c.Certifcation_Rating__r.Goal_field_name__c)));
                            decimal actual = integer.valueOf(ss.get(c.Certifcation_Rating__r.Metric_Field_Name__c));
                            decimal goal = integer.valueOf(ss.get(c.Certifcation_Rating__r.Goal_field_name__c));
                            if(goal!=0){
                                tw.Percentage = (actual/goal)*100;
                                tw.Percentage = tw.Percentage.setScale(2, RoundingMode.HALF_UP);
                            }else{
                                showError = true;
                                  
                                zeroGoalRating = c.Certifcation_Rating__r.name;
                            }
                        }
                    }
                    system.debug('zeroGoalRating :: '+zeroGoalRating);
                    if(c.Certifcation_Rating__r.Rating_type__c == '%'){
                        actualLabel = 'Percentage';
                    }else if(c.Certifcation_Rating__r.Rating_type__c == '#'){
                        actualLabel = 'Number of Days';
                    }else if(c.Certifcation_Rating__r.Rating_type__c == '$'){
                        //tw.actual = tw.actual.format();
                        actualLabel = 'Currency';
                    }else{
                        actualLabel = 'Number';
                    }
                    if(actualLabel == 'Percentage'){
                        maxVal = 100;
                    }else if(maxVal!= null && tw.actual > maxVal){
                        maxVal = tw.actual;
                    }
                }else{
                    tw.actual = c.FunnelMetrics__Rating_Score__c;
                    tw.Percentage = (c.FunnelMetrics__Rating_Score__c/5)*100;
                    tw.Percentage = tw.Percentage.setScale(2, RoundingMode.HALF_UP);
                    if(maxVal!= null && tw.actual > maxVal){
                        maxVal = 10;
                    }
                    actualLabel = 'Ratings';
                }
                //tw.Percentage = (c.FunnelMetrics__Rating_Score__c/5)*100;
                if(sId.contains(tw.metricId)){
                    metricRowMap.get(tw.metricId).add(tw);
                }else{
                    metricRowMap.put(tw.metricId,new List<tableWrapper>{tw});
                    sId.add(tw.metricId);
                }
            }
            
            Map<String, List<tableWrapper>> metricRowMapFinal = new Map<String, List<tableWrapper>>();  
                            
            for(Id spId: metricRowMap.keySet()){    
                
                List<tableWrapper> finalLst = new List<tableWrapper>(); 
                List<tableWrapper> currentLst = new List<tableWrapper>();   
                    
                currentLst = metricRowMap.get(spId);    
                    
                //system.debug(' currentLst: '+currentLst);   
                    
                Integer nullAdded = 0;  
                Integer j = 0;  
                    
                for(Integer i =0; i < currentLst.size(); i++){  
                    system.debug(' due Dt '+currentLst[i].dueDate); 
                    system.debug(' due Dt 1 '+dueDates[j]); 
                        
                    if (nullAdded == 1){    
                        i = i - 1;  
                        nullAdded = 0;  
                    }   
                        
                    if (currentLst[i].dueDate == dueDates[j]){  
                        finalLst.add(currentLst[i]);    
                        //system.debug(' finalLst '+finalLst);    
                    }   
                    else{   
                        tableWrapper tw = new tableWrapper();   
                        tw.metricId = currentLst[i].metricId;   
                        tw.metricName = currentLst[i].metricName;   
                        tw.rankingScore = null; 
                        tw.dueDate = dueDates[j];   
                        tw.ratingType = currentLst[i].ratingType;   
                        tw.actual = null;   
                        tw.Percentage = null;   
                        finalLst.add(tw);   
                        //system.debug(' i is '+i);   
                        //i = i - 1;    
                        nullAdded = 1;  
                        //system.debug(' finalLst '+finalLst);                                
                    }   
                        
                    j++;    
                        
                }   
                //system.debug(' metricId '+currentLst[0].metricId);  
                //system.debug(' finalLst: '+finalLst);   
                metricRowMapFinal.put(currentLst[0].metricId,finalLst); 
                //metricRowMap.put(currentLst[0].metricId,finalLst);    
                    
            }
            
            metricRowMap = metricRowMapFinal;
            
            if(showError == true && zeroGoalRating != ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.warning,'The Metric '+zeroGoalRating+' have a goal of 0'));
            }
        }
        if(actualLabel == 'Percentage'){
            List<String> lst = new List<String>{'0','20','40','60','80','100'};
            actualPlot = lst;
        }
        system.debug('metric metricRowMap :: '+ metricRowMap);
        List<id> s = new List<String>();
        s.addAll(sId);
        system.debug('metric c :: '+ s);
        integer ListSize = sId.size();
        for(integer i =0; i<ListSize; i++){
            if(i == 0 && i != null){
                tableVals1= metricRowMap.get(s[i]);
            }
            if(i == 1 && i != null){
                tableVals2= metricRowMap.get(s[i]);
            }
            if(i == 2 && i != null){
                tableVals3= metricRowMap.get(s[i]);
            }
            if(i == 3 && i != null){
                tableVals4= metricRowMap.get(s[i]);
            }
            if(i == 4 && i != null){
                tableVals5= metricRowMap.get(s[i]);
            }
        }
        
    }
    
    
    public PageReference navigateToCertification(){
        
        //return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        if (fw.selectedLevelFive != null && fw.selectedLevelFive.size() > 0)
            return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFive[0]);
        else
            return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,''); 
    }
    
    public PageReference navigateToDashboard(){
        
        //return FunnelNavigationHelper.navigateToDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        if (fw.selectedLevelFive != null && fw.selectedLevelFive.size() > 0)
            return FunnelNavigationHelper.navigateToDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFive[0]);
        else
            return FunnelNavigationHelper.navigateToDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,''); 
    }
    public PageReference navigateToCertificateReports(){
        
        return FunnelNavigationHelper.navigateToCertificateReports(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToReportsPage(){
        
        //return FunnelNavigationHelper.navigateToReportsPage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        if (fw.selectedLevelFive != null && fw.selectedLevelFive.size() > 0)
            return FunnelNavigationHelper.navigateToReportsPage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFive[0]);
        else
            return FunnelNavigationHelper.navigateToReportsPage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,''); 
    }
    public PageReference navigateToAnnualizationDashboard(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        if (fw.selectedLevelFive != null && fw.selectedLevelFive.size() > 0)
            return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFive[0]);
        else
            return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,''); 
    }
    
    public PageReference navigateToFunnelAnalytic(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        if (fw.selectedLevelFive != null && fw.selectedLevelFive.size() > 0)
            return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFive[0]);
        else
            return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,''); 
    } 
    
    public PageReference navigateToFunnelAnalyticQualitative(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        if (fw.selectedLevelFive != null && fw.selectedLevelFive.size() > 0)
            return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFive[0]);
        else
            return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,''); 
    } 
    
    public PageReference navigateToSalesPipeline(){
        
        return FunnelNavigationHelper.navigateToSalesPipeline(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToTrendingByRep(){
        
        return FunnelNavigationHelper.navigateToTrendingByRep(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
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