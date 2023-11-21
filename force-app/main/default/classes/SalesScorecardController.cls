/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class SalesScorecardController{
    List<Certification_Answer__c> cerAnswerList = new List<Certification_Answer__c>();
    public List<Certification_Answer__c> bubblechart{get;set;}
    public List<Certification_Answer__c> bubblechart1{get;set;}
    Map<Id,Certification_Answer__c> scoremap = new map<Id,Certification_Answer__c>();
    public list<data1> data1{get;set;}
    public list<data1> data2{get;set;}
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    public String selectedType{get;set;}
    public String perfPeriodValues{get;set;}
    public String chartTitle{get;set;}
    public String selectedTypevalue{get;set;}
    public String perfPeriodValuesvalue{get;set;}
    public String Rolevalue{get;set;}
    
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
    
    public String defaultBreadCrumb{get; set;}
    public String crumValue{get;set;}
    public String levelValue{get;set;}
    /* Filters */
    
    Boolean readAccess;
    
    public Boolean RoleOverlay{get;set;}
    public Boolean RepOverlay{get;set;}
    public SalesScorecardController(){
        isData4 = true;
        try{ 
            
            
            List<Sales_rep_profile_snapshot__c> snap = [Select id from Sales_rep_profile_snapshot__c Limit 1]; 
            system.debug('snap :: '+snap);
            if(snap != null && snap .size()>0){
                
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
                system.debug('readAccess :: '+readAccess);
                if(readAccess){
                    
                    
                    
                    /*filters*/
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
                    
                    
                    
                    fw.labelFour = 'Filter By Representative';
                    fw.levelFour = FunnelFilterHelper.populateLevelFour(fw,'');
                    system.debug('in constructor :: '+fw.levelFour);
                    /*filters*/
                    
                    if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All' && fw.selectedLevelTwo != null && fw.selectedLevelTwo != '' && fw.selectedLevelTwo != 'null'){
                        fw.selectedLevelTwo = 'All';
                        fw.disableLevelThree = false;
                    }
                    if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo == 'All'){
                        fw.SelectedLevelFour = 'All' ;
                    }
                    
                    system.debug('readaccess before showupdate :: '+readAccess);
                    showUpdated();
                    metricsSkillsFilters();
                    
                    defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw); 
                    
                    system.debug('fw.selectedLevelFour :: '+fw.selectedLevelFour);
                    system.debug('fw.levelFour :: '+fw.levelFour);
                    system.debug(' defaultBreadCrumb '+defaultBreadCrumb);
                    selectedType = 'Metrix';
                    perfPeriodValues = 'YTD';
                    PopulateMetricOrSkill();
                    system.debug('lstMetricOrSkill :: '+lstMetricOrSkill);
                    system.debug('sMetricOrSkill :: '+sMetricOrSkill);
                    sMetricOrSkill = lstMetricOrSkill[0].getValue();
                    CalculateData4();
                    CalculateData();
                    calculateData1();
                    CalculateData2();
                    system.debug('sMetricOrSkill :: '+sMetricOrSkill);
                    
                }
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());                
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelScorecard '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
        
        
    }
    List<String> strList = new List<String>();
    List<String> strList1 = new List<String>();
    List<Company_Level__c> cl = new List<Company_Level__c>();
    List<Company_Level__c> regionList = new List<Company_Level__c>();
    public List<Data> lstdata {get;set;}
    public List<Data1> lstdata1 {get;set;}
    public List<Data2> lstdata2 {get;set;}
    public decimal vdata2Percentage10 {get;set;}
    public decimal vdata2Percentage8 {get;set;}
    public decimal vdata2Percentage5 {get;set;}
    public decimal vdata2Percentage2 {get;set;}
    public decimal vdata2Percentage0 {get;set;}
    public decimal vdata1Percentage10 {get;set;}
    public decimal vdata1Percentage8 {get;set;}
    public decimal vdata1Percentage5 {get;set;}
    public decimal vdata1Percentage2 {get;set;}
    public decimal vdata1Percentage0 {get;set;}
    public decimal vdata2Count10 {get;set;}
    public decimal vdata2Count8 {get;set;}
    public decimal vdata2Count5 {get;set;}
    public decimal vdata2Count2 {get;set;}
    public decimal vdata2Count0 {get;set;}
    public decimal vdata1Count10 {get;set;}
    public decimal vdata1Count8 {get;set;}
    public decimal vdata1Count5 {get;set;}
    public decimal vdata1Count2 {get;set;}
    public decimal vdata1Count0 {get;set;}
    public decimal averagevalue2 {get;set;}
    public decimal averagevalue1 {get;set;}
    public Boolean isData1 {get;set;}
    public void CalculateData() {
        Boolean isData4local = false;
        lstdata = new List<Data>();
        List<Data> data4 = new List<Data>();
        lstdata.clear();
        cerAnswerList.clear();
        List<String> strList = new List<String>();
        List<String> strList1 = new List<String>();
        //List<Company_Level__c> cl = new List<Company_Level__c>();
        List<Sales_Profile_Company_Level_Junction__c> cl2 = new List<Sales_Profile_Company_Level_Junction__c>();
        List<Company_Level__c> regionList = new List<Company_Level__c>();
        integer count = 0;
        integer count1 = 0;
        integer count2 = 0;
        integer count3 = 0;
        integer count4 = 0;
        integer count5 = 0;
        integer count6 = 0;
        integer count7 = 0;
        integer count8 = 0;
        integer count9 = 0;
        integer count_1 = 0;
        integer count_2 = 0;
        integer count_3 = 0;
        integer count_4 = 0;
        integer count_5 = 0;
        integer count_6 = 0;
        integer count_7 = 0;
        integer count_8 = 0;
        integer count_9 = 0;
        integer count_10 = 0;
        integer count00 = 0;
        integer count01 = 0;
        integer count02 = 0;
        integer count03 = 0;
        integer count04 = 0;
        integer count05 = 0;
        integer count06 = 0;
        integer count07 = 0;
        integer count08 = 0;
        integer count09 = 0;
        Map<String,Set<String>> MapLevel_Value = new Map<String,Set<String>>();
        Map<String,Map<Integer, Integer>> MapRating_Score = new Map<String,Map<Integer, Integer>>();
        Map<Integer, Decimal> mapScorePercentage = new Map<Integer, Decimal>();
        Set<String> setSales_Rep_Profile = new Set<String>();
        string namefilt = perfPeriodValues +' '+ sMetricOrSkill;
        if(fw.SelectedLevelThree != 'All'){
            Rolevalue = fw.SelectedLevelThree;
        }else{
            Rolevalue = '';
        }
        //if(selectedType == 'Metrix'){
        system.debug('namefilt1' +namefilt);
        system.debug('fw.selectedLevelFour :: '+fw.selectedLevelFour);
        system.debug('fw.selectedLevelThree :: '+fw.selectedLevelThree);
        If(fw.selectedLevelThree == 'All'){
            //cl = [SELECT id,Sales_Rep_Profile__r.Sales_Manager__c,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name FROM Company_Level__c Where Level_Value__c =: fw.SelectedLevelOne];
            cl2 = [SELECT Sales_Rep_Profile__c,FunnelMetrics__Company_Level__r.FunnelMetrics__Level_Value__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne];
            
        }else if (fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
            //cl = [SELECT id,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name FROM Company_Level__c Where Level_Value__c =: fw.SelectedLevelOne and Sales_Rep_Profile__r.Role__c = : fw.SelectedLevelThree];
            cl2 = [SELECT Sales_Rep_Profile__c,FunnelMetrics__Company_Level__r.FunnelMetrics__Level_Value__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne and Sales_Rep_Profile__r.Role__c = : fw.SelectedLevelThree];
            
        }
        
        
        system.debug('cl list' + cl2);
        if(cl2.size() > 0){
            for(FunnelMetrics__Sales_Profile_Company_Level_Junction__c cl1 : cl2){
                if(cl1.Sales_Rep_Profile__c != null) {
                    strList.add(cl1.Sales_Rep_Profile__c);
                }
                if(!MapLevel_Value.isEmpty() && MapLevel_Value.containsKey(cl1.FunnelMetrics__Company_Level__r.FunnelMetrics__Level_Value__c)) {
                    MapLevel_Value.get(cl1.FunnelMetrics__Company_Level__r.FunnelMetrics__Level_Value__c).add(cl1.FunnelMetrics__Sales_Rep_Profile__c);
                    setSales_Rep_Profile.add(cl1.FunnelMetrics__Sales_Rep_Profile__c);
                    system.debug('setSales_Rep_Profile' +setSales_Rep_Profile);
                }
                else {
                    MapLevel_Value.put(cl1.FunnelMetrics__Company_Level__r.FunnelMetrics__Level_Value__c, new Set<String>{cl1.FunnelMetrics__Sales_Rep_Profile__c});
                    setSales_Rep_Profile.add(cl1.FunnelMetrics__Sales_Rep_Profile__c);
                    system.debug('setSales_Rep_Profile1' +setSales_Rep_Profile);
                }
            }
        }
        System.debug('Checking MapLevel_Value : ' + MapLevel_Value);
        System.debug('Checking setSales_Rep_Profile : ' + setSales_Rep_Profile);
        system.debug('strList' + strList);
        if(setSales_Rep_Profile.size() > 0){
            system.debug('name filter ' +namefilt);
            System.debug('Checking namefilt : ' + namefilt);
            System.debug('Checking setSales_Rep_Profile : ' + setSales_Rep_Profile);
            if(selectedType == 'Metrix'){
                List<Certification_Answer__c> ca = [Select id,Due_Date__c from Certification_Answer__c where Rating_Score__c!= null and Certifcation_Rating__r.name = : sMetricOrSkill order by Due_Date__c desc Limit 1];
                if(ca != null && ca.size() > 0){
                    cerAnswerList = [Select id,name, FunnelMetrics__Sales_Rep_Profile__r.name, FunnelMetrics__Rating_Score__c, FunnelMetrics__Sales_Rep_Profile__r.FunnelMetrics__Role__c, FunnelMetrics__Sales_Rep_Profile__c from FunnelMetrics__Certification_Answer__c where FunnelMetrics__Certifcation_Rating__r.name = : sMetricOrSkill  AND FunnelMetrics__Sales_Rep_Profile__c IN : setSales_Rep_Profile and Due_Date__c =: ca[0].Due_Date__c order by Rating_Score__c desc];
                    
                }
            }else if(selectedType == 'Skill'){
                String timing = '';
                if(perfPeriodValues == 'Monthly'){
                    timing = 'End of month';
                }else if(perfPeriodValues == 'Quarterly'){
                    timing = 'End of quarter';
                }else if(perfPeriodValues == 'Bi-Annual'){
                    timing = 'Bi-annual';
                }else if(perfPeriodValues == 'Annual'){
                    timing = 'Annual';
                }
                system.debug('timing :: '+ timing);
                List<Certification_Answer__c> ca = [Select id,Due_Date__c from Certification_Answer__c where Rating_Score__c!= null and Certifcation_Rating__r.name = : sMetricOrSkill  AND FunnelMetrics__Certifcation_Rating__r.FunnelMetrics__Timing__c =: timing order by Due_Date__c desc Limit 1];
                if(ca != null && ca.size() > 0){
                    cerAnswerList = [Select id,name, FunnelMetrics__Sales_Rep_Profile__r.name, FunnelMetrics__Rating_Score__c, FunnelMetrics__Sales_Rep_Profile__r.FunnelMetrics__Role__c, FunnelMetrics__Sales_Rep_Profile__c from FunnelMetrics__Certification_Answer__c where FunnelMetrics__Certifcation_Rating__r.name = : sMetricOrSkill  AND FunnelMetrics__Certifcation_Rating__r.FunnelMetrics__Timing__c =: timing  AND FunnelMetrics__Sales_Rep_Profile__c IN : setSales_Rep_Profile and Due_Date__c =: ca[0].Due_Date__c order by Rating_Score__c desc ];        
                }
            }
            system.debug('cerAnswerList' + cerAnswerList);
            system.debug('Checking cerAnswerList size' + cerAnswerList.size());
            Map<Integer, Integer> mapScoreCount = new Map<Integer, Integer>();
            for(Certification_Answer__c c1: cerAnswerList){
                if(c1.Rating_Score__c == 10.00 || c1.Rating_Score__c == 8.00 || c1.Rating_Score__c == 5.00 || c1.Rating_Score__c == 2.00 || c1.Rating_Score__c == 0.00){
                    system.debug('Certificationo Answer' + c1.Rating_Score__c +' name :: '+c1.name +' srp name :: '+c1.Sales_Rep_Profile__r.name);
                    Integer iRating_Score = Integer.valueOf(c1.Rating_Score__c);
                    count = count+1;
                    if(!MapRating_Score.isEmpty() && MapRating_Score.containsKey(c1.FunnelMetrics__Sales_Rep_Profile__c)) {
                        Map<Integer, Integer> mapChildRating_Score = MapRating_Score.get(c1.FunnelMetrics__Sales_Rep_Profile__c);
                        if(mapChildRating_Score.containsKey(iRating_Score)) {
                            mapChildRating_Score.put(iRating_Score, mapChildRating_Score.get(iRating_Score) + 1);
                        }
                        else {
                            mapChildRating_Score.put(iRating_Score, 1);
                        }
                        MapRating_Score.put(c1.FunnelMetrics__Sales_Rep_Profile__c, mapChildRating_Score);
                    }
                    else {
                        Map<Integer, Integer> mapChildRating_Score = new Map<Integer, Integer>();
                        mapChildRating_Score.put(iRating_Score, 1);
                        // MapRating_Score.put(c1.FunnelMetrics__Sales_Rep_Profile__c, mapChildRating_Score);
                        MapRating_Score.put(c1.FunnelMetrics__Sales_Rep_Profile__r.name, mapChildRating_Score);
                    }
                    if(!mapScoreCount.isEmpty() && mapScoreCount.containsKey(iRating_Score)) {
                        mapScoreCount.put(iRating_Score, mapScoreCount.get(iRating_Score)+1);
                    }
                    else {
                        mapScoreCount.put(iRating_Score, 1);
                    }
                    
                }
            }
            system.debug('MapRating_Score' + MapRating_Score);
            system.debug('Checking mapScoreCount :' +mapScoreCount);
            if(!MapRating_Score.isEmpty()){
                for(String sProfile_Value : MapRating_Score.keySet()){
                    Map<Integer, Integer> mapChildRating_Score = MapRating_Score.get(sProfile_Value);
                    system.debug('mapChildRating_Score.keySet()' + mapChildRating_Score.keySet());
                    for(Integer iScore : mapChildRating_Score.keySet()) {
                        data4.add(new Data(sProfile_Value, iScore));
                    }
                }
            }
            System.debug('Checking Result : ' + data4);
        }
        system.debug('data4' + data4);
        //}    // isData4 = true;
        lstdata = data4;
        // return isData4;
    }
    public void calculateData1() {
        List<Data1> data1 = new List<Data1>();
        strList.clear();
        strList1.clear();
        lstdata1 = new List<Data1>();
        lstdata1.clear();
        cerAnswerList.clear();
        vdata1Percentage10 = 0;
        vdata1Percentage8 = 0;
        vdata1Percentage5 = 0;
        vdata1Percentage2 = 0;
        vdata1Percentage0 = 0;
        vdata1Count10 = 0;
        vdata1Count8 = 0;
        vdata1Count5 = 0;
        vdata1Count2 = 0;
        vdata1Count0 = 0;
        averagevalue1 = 0;
        selectedTypevalue = sMetricOrSkill;
        perfPeriodValuesvalue = perfPeriodValues;
        string namefilt = perfPeriodValues +' '+ sMetricOrSkill;
        string quotafilt = 'YTD' +' Quota Performance';
        system.debug('namefilt '+ namefilt);
        integer count = 0;
        integer count1 = 0;
        integer count2 = 0;
        integer count3 = 0;
        integer count4 = 0;
        integer count5 = 0;
        integer count6 = 0;
        integer count7 = 0;
        integer count8 = 0;
        integer count9 = 0;
        integer count_1 = 0;
        integer count_2 = 0;
        integer count_3 = 0;
        integer count_4 = 0;
        integer count_5 = 0;
        integer count_6 = 0;
        integer count_7 = 0;
        integer count_8 = 0;
        integer count_9 = 0;
        integer count_10 = 0;
        integer count00 = 0;
        integer count01 = 0;
        integer count02 = 0;
        integer count03 = 0;
        integer count04 = 0;
        integer count05 = 0;
        integer count06 = 0;
        integer count07 = 0;
        integer count08 = 0;
        integer count09 = 0;
        String name = '';
        String name1 = '';
        String name2 = '';
        String name3 = '';
        String name4 = '';
        String name5 = '';
        String name6 = '';
        String name7 = '';
        String name8 = '';
        String name9 = '';
        String name_1 = '';
        String name_2 = '';
        String name_3 = '';
        String name_4 = '';
        String name_5 = '';
        String name_6 = '';
        String name_7 = '';
        String name_8 = '';
        String name_9 = '';
        String name_10 = '';
        String name00 = '';
        String name01 = '';
        String name02 = '';
        String name03 = '';
        String name04 = '';
        String name05 = '';
        String name06 = '';
        String name07 = '';
        String name08 = '';
        String name09 = '';
        Map<Decimal, Decimal> mapScorePercentage = new Map<Decimal, Decimal>();
        if(fw.SelectedLevelThree != 'All'){
            Rolevalue = fw.SelectedLevelThree;
        }else{
            Rolevalue = '';
        }
        // if(selectedType == 'Metrix'){
        system.debug('namefilt1' +namefilt);
        system.debug('cl list' + cl);
        system.debug('strList' + strList);
        
        system.debug('fw.selectedLevelFour :: '+fw.selectedLevelFour);
        system.debug('fw.selectedLevelThree :: '+fw.selectedLevelThree);
        If(fw.selectedLevelThree == 'All'){
            cl = [SELECT id,Sales_Rep_Profile__r.Sales_Manager__c,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name FROM Company_Level__c Where Level_Value__c =: fw.SelectedLevelOne];
            List<Sales_Profile_Company_Level_Junction__c> sj = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne];
            strList1.clear();
            for(Sales_Profile_Company_Level_Junction__c s:sj){
                strList1.add(s.Sales_Rep_Profile__c);
            }
        }else if (fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
            cl = [SELECT id,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name FROM Company_Level__c Where Level_Value__c =: fw.SelectedLevelOne and Sales_Rep_Profile__r.Role__c = : fw.SelectedLevelThree];
            List<Sales_Profile_Company_Level_Junction__c> sj = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne and Sales_Rep_Profile__r.Role__c = : fw.SelectedLevelThree];
            strList1.clear();
            for(Sales_Profile_Company_Level_Junction__c s:sj){
                strList1.add(s.Sales_Rep_Profile__c);
            }
        }
        Map<Decimal, Integer> mapScoreCount = new Map<Decimal, Integer>();
        List<AggregateResult> avg1 = new List<AggregateResult>();
        List<Certification_Answer__c> cans = [Select id,Due_Date__c from Certification_Answer__c where Rating_Score__c!= null and Certifcation_Rating__r.name = : quotafilt order by Due_Date__c desc Limit 1];
        if(cans != null && cans.size() > 0){
            bubblechart =[Select Rating_Score__c,Sales_Rep_Profile__r.name from Certification_Answer__c where Certifcation_Rating__r.name = : quotafilt AND FunnelMetrics__Sales_Rep_Profile__c IN : strList1 and Due_Date__c =: cans[0].Due_Date__c];
        }
        if(selectedType == 'Metrix'){
            List<Certification_Answer__c> ca = [Select id,Due_Date__c from Certification_Answer__c where Rating_Score__c!= null and Certifcation_Rating__r.name = : sMetricOrSkill order by Due_Date__c desc Limit 1];
            if(ca != null && ca.size() > 0){
                cerAnswerList = [Select id,name, FunnelMetrics__Sales_Rep_Profile__r.name, FunnelMetrics__Rating_Score__c, FunnelMetrics__Sales_Rep_Profile__r.FunnelMetrics__Role__c, FunnelMetrics__Sales_Rep_Profile__c from FunnelMetrics__Certification_Answer__c where FunnelMetrics__Certifcation_Rating__r.name = : sMetricOrSkill  AND FunnelMetrics__Sales_Rep_Profile__c IN : strList1 and Due_Date__c =: ca[0].Due_Date__c];
                avg1=[select AVG(Rating_Score__c)a from FunnelMetrics__Certification_Answer__c where FunnelMetrics__Certifcation_Rating__r.name = : sMetricOrSkill  AND FunnelMetrics__Sales_Rep_Profile__c IN : strList1 and Due_Date__c =: ca[0].Due_Date__c];
                averagevalue1 = (decimal)avg1[0].get('a');
            }
        }else if(selectedType == 'Skill'){
            String timing = '';
            if(perfPeriodValues == 'Monthly'){
                timing = 'End of month';
            }else if(perfPeriodValues == 'Quarterly'){
                timing = 'End of quarter';
            }else if(perfPeriodValues == 'Bi-Annual'){
                timing = 'Bi-annual';
            }else if(perfPeriodValues == 'Annual'){
                timing = 'Annual';
            }
            List<Certification_Answer__c> ca = [Select id,Due_Date__c from Certification_Answer__c where Rating_Score__c!= null and Certifcation_Rating__r.name = : sMetricOrSkill  AND FunnelMetrics__Certifcation_Rating__r.FunnelMetrics__Timing__c =: timing order by Due_Date__c desc Limit 1];
            if(ca != null && ca.size() > 0){
                cerAnswerList = [Select id,name, FunnelMetrics__Sales_Rep_Profile__r.name, FunnelMetrics__Rating_Score__c, FunnelMetrics__Sales_Rep_Profile__r.FunnelMetrics__Role__c, FunnelMetrics__Sales_Rep_Profile__c from FunnelMetrics__Certification_Answer__c where FunnelMetrics__Certifcation_Rating__r.name = : sMetricOrSkill  AND FunnelMetrics__Certifcation_Rating__r.FunnelMetrics__Timing__c =: timing  AND FunnelMetrics__Sales_Rep_Profile__c IN : strList1 and Due_Date__c =: ca[0].Due_Date__c]; 
            }
        }
        //System.debug('line550:::'+bubblechart.size());
        if(bubblechart != null && bubblechart.size()>0){
            for(Certification_Answer__c c: bubblechart){
                if(c.Rating_Score__c == 0.00){
                    for(Certification_Answer__c c1: cerAnswerList){
                        if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                            if(c1.Rating_Score__c == 10.00){
                                count = count+1;
                                if(name == ''){
                                    name = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name = name+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 8.00){
                                count1 = count1+1;
                                if(name1 == ''){
                                    name1 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name1 = name1+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 5.00){
                                count2 = count2+1;
                                if(name2 == ''){
                                    name2 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name2 = name2+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 2.00){
                                count3 = count3+1;
                                if(name3 == ''){
                                    name3 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name3 = name2+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 0.00){
                                count4 = count4+1;
                                if(name4 == ''){
                                    name4 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name4 = name4+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }
                        } 
                    }
                    integer sum = count+count1+count2+count3+count4;
                    mapScoreCount.put(c.Rating_Score__c,sum);
                    //data1.add(new Data1(String.valueof(count), c.Rating_Score__c,c1.Rating_Score__c));
                }
            }
        }
        if(cerAnswerList.size() > 0) {
            for(Decimal iScoreCount : mapScoreCount.keySet()) {
                Decimal iScoreCountTotal = mapScoreCount.get(iScoreCount);
                Decimal dScorePercentage = ((Decimal)iScoreCountTotal/cerAnswerList.size()) * 100;
                mapScorePercentage.put(iScoreCount, dScorePercentage.setScale(2));
            }
        }
        if(bubblechart != null && bubblechart.size()>0){
            for(Certification_Answer__c c: bubblechart){
                if(c.Rating_Score__c == 0.00){
                    for(Certification_Answer__c c1: cerAnswerList){
                        if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                            if(c1.Rating_Score__c == 10.00){
                                data1.add(new Data1(name,String.valueof(count), c.Rating_Score__c,c1.Rating_Score__c,count,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 8.00){
                                data1.add(new Data1(name1,String.valueof(count1), c.Rating_Score__c,c1.Rating_Score__c,count1,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 5.00){
                                data1.add(new Data1(name2,String.valueof(count2), c.Rating_Score__c,c1.Rating_Score__c,count2,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 2.00){
                                data1.add(new Data1(name3,String.valueof(count3), c.Rating_Score__c,c1.Rating_Score__c,count3,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 0.00){
                                data1.add(new Data1(name4,String.valueof(count4), c.Rating_Score__c,c1.Rating_Score__c,count4,mapScorePercentage.get(c.Rating_Score__c)));
                            }
                        } 
                    }
                }
            }
            for(Certification_Answer__c c: bubblechart){
                if(c.Rating_Score__c == 2.00){
                    for(Certification_Answer__c c1: cerAnswerList){
                        if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                            if(c1.Rating_Score__c == 10.00){
                                count5 = count5+1;
                                if(name5 == ''){
                                    name5 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name5 = name5+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 8.00){
                                count6 = count6+1;
                                if(name6 == ''){
                                    name6 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name6 = name6+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 5.00){
                                count7 = count7+1;
                                if(name7 == ''){
                                    name7 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name7 = name7+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 2.00){
                                count8 = count8+1;
                                if(name8 == ''){
                                    name8 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name8 = name8+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 0.00){
                                count9 = count9+1;
                                if(name9 == ''){
                                    name9 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name9 = name9+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }
                        } 
                    }
                    integer sum = count5+count6+count7+count8+count9;
                    mapScoreCount.put(c.Rating_Score__c,sum);
                    //data1.add(new Data1(String.valueof(count), c.Rating_Score__c,c1.Rating_Score__c));
                }
            }
        }
        if(cerAnswerList.size() > 0) {
            for(Decimal iScoreCount : mapScoreCount.keySet()) {
                Decimal iScoreCountTotal = mapScoreCount.get(iScoreCount);
                Decimal dScorePercentage = ((Decimal)iScoreCountTotal/cerAnswerList.size()) * 100;
                mapScorePercentage.put(iScoreCount, dScorePercentage.setScale(2));
            }
        }
        if(bubblechart != null && bubblechart.size()>0){
            for(Certification_Answer__c c: bubblechart){
                if(c.Rating_Score__c == 2.00){
                    for(Certification_Answer__c c1: cerAnswerList){
                        if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                            if(c1.Rating_Score__c == 10.00){
                                data1.add(new Data1(name5,String.valueof(count5), c.Rating_Score__c,c1.Rating_Score__c,count5,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 8.00){
                                data1.add(new Data1(name6,String.valueof(count6), c.Rating_Score__c,c1.Rating_Score__c,count6,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 5.00){
                                data1.add(new Data1(name7,String.valueof(count7), c.Rating_Score__c,c1.Rating_Score__c,count7,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 2.00){
                                data1.add(new Data1(name8,String.valueof(count8), c.Rating_Score__c,c1.Rating_Score__c,count8,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 0.00){
                                data1.add(new Data1(name9,String.valueof(count9), c.Rating_Score__c,c1.Rating_Score__c,count9,mapScorePercentage.get(c.Rating_Score__c)));
                            }
                        } 
                    }
                }
            }
            for(Certification_Answer__c c: bubblechart){
                if(c.Rating_Score__c == 5.00){
                    for(Certification_Answer__c c1: cerAnswerList){
                        if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                            if(c1.Rating_Score__c == 10.00){
                                count_1 = count_1+1;
                                if(name_1 == ''){
                                    name_1 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name_1 = name_1+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 8.00){
                                count_2 = count_2+1;
                                if(name_2 == ''){
                                    name_2 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name_2 = name_2+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 5.00){
                                count_3 = count_3+1;
                                if(name_3 == ''){
                                    name_3 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name_3 = name_3+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 2.00){
                                count_4 = count_4+1;
                                if(name_4 == ''){
                                    name_4 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name_4 = name_4+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 0.00){
                                count_5 = count_5+1;
                                if(name_5 == ''){
                                    name_5 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name_5 = name_5+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }
                        } 
                    }
                    integer sum = count_1+count_2+count_3+count_4+count_5;
                    mapScoreCount.put(c.Rating_Score__c,sum);
                    //data1.add(new Data1(String.valueof(count), c.Rating_Score__c,c1.Rating_Score__c));
                }
            }
        }
        if(cerAnswerList.size() > 0) {
            for(Decimal iScoreCount : mapScoreCount.keySet()) {
                Decimal iScoreCountTotal = mapScoreCount.get(iScoreCount);
                Decimal dScorePercentage = ((Decimal)iScoreCountTotal/cerAnswerList.size()) * 100;
                mapScorePercentage.put(iScoreCount, dScorePercentage.setScale(2));
            }
        }
        if(bubblechart != null && bubblechart.size()>0){
            for(Certification_Answer__c c: bubblechart){
                if(c.Rating_Score__c == 5.00){
                    for(Certification_Answer__c c1: cerAnswerList){
                        if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                            if(c1.Rating_Score__c == 10.00){
                                data1.add(new Data1(name_1,String.valueof(count_1), c.Rating_Score__c,c1.Rating_Score__c,count_1,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 8.00){
                                data1.add(new Data1(name_2,String.valueof(count_2), c.Rating_Score__c,c1.Rating_Score__c,count_2,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 5.00){
                                data1.add(new Data1(name_3,String.valueof(count_3), c.Rating_Score__c,c1.Rating_Score__c,count_3,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 2.00){
                                data1.add(new Data1(name_4,String.valueof(count_4), c.Rating_Score__c,c1.Rating_Score__c,count_4,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 0.00){
                                data1.add(new Data1(name_5,String.valueof(count_5), c.Rating_Score__c,c1.Rating_Score__c,count_5,mapScorePercentage.get(c.Rating_Score__c)));
                            }
                        } 
                    }
                }
            }
            for(Certification_Answer__c c: bubblechart){
                if(c.Rating_Score__c == 8.00){
                    for(Certification_Answer__c c1: cerAnswerList){
                        if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                            if(c1.Rating_Score__c == 10.00){
                                count00 = count00+1;
                                if(name00 == ''){
                                    name00 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name00 = name00+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 8.00){
                                count01 = count01+1;
                                if(name01 == ''){
                                    name01 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name01 = name01+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 5.00){
                                count02 = count02+1;
                                if(name02 == ''){
                                    name02 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name02 = name02+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 2.00){
                                count03 = count03+1;
                                if(name03 == ''){
                                    name03 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name03 = name03+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 0.00){
                                count04 = count04+1;
                                if(name04 == ''){
                                    name04 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name04 = name04+'<br/>' +c.Sales_Rep_Profile__r.name;
                                } 
                            }
                        } 
                    }
                    integer sum = count00+count01+count02+count03+count04;
                    mapScoreCount.put(c.Rating_Score__c,sum);
                    //data1.add(new Data1(String.valueof(count), c.Rating_Score__c,c1.Rating_Score__c));
                }
            }
        }
        if(cerAnswerList.size() > 0) {
            for(Decimal iScoreCount : mapScoreCount.keySet()) {
                Decimal iScoreCountTotal = mapScoreCount.get(iScoreCount);
                Decimal dScorePercentage = ((Decimal)iScoreCountTotal/cerAnswerList.size()) * 100;
                mapScorePercentage.put(iScoreCount, dScorePercentage.setScale(2));
            }
        }
        if(bubblechart != null && bubblechart.size()>0){
            for(Certification_Answer__c c: bubblechart){
                if(c.Rating_Score__c == 8.00){
                    for(Certification_Answer__c c1: cerAnswerList){
                        if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                            if(c1.Rating_Score__c == 10.00){
                                data1.add(new Data1(name00,String.valueof(count00), c.Rating_Score__c,c1.Rating_Score__c,count00,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 8.00){
                                data1.add(new Data1(name01,String.valueof(count01), c.Rating_Score__c,c1.Rating_Score__c,count01,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 5.00){
                                data1.add(new Data1(name02,String.valueof(count02), c.Rating_Score__c,c1.Rating_Score__c,count02,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 2.00){
                                data1.add(new Data1(name03,String.valueof(count03), c.Rating_Score__c,c1.Rating_Score__c,count03,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 0.00){
                                data1.add(new Data1(name04,String.valueof(count04), c.Rating_Score__c,c1.Rating_Score__c,count04,mapScorePercentage.get(c.Rating_Score__c)));
                            }
                        } 
                    }
                }
            }
            for(Certification_Answer__c c: bubblechart){
                if(c.Rating_Score__c == 10.00){
                    for(Certification_Answer__c c1: cerAnswerList){
                        if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                            if(c1.Rating_Score__c == 10.00){
                                count05 = count05+1;
                                if(name05 == ''){
                                    name05 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name05 = name05+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 8.00){
                                count06 = count06+1;
                                if(name06 == ''){
                                    name06 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name06 = name06+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 5.00){
                                count07 = count07+1;
                                if(name07 == ''){
                                    name07 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name07 = name07+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 2.00){
                                count08 = count08+1;
                                if(name08 == ''){
                                    name08 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name08 = name08+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }else if(c1.Rating_Score__c == 0.00){
                                count09 = count09+1;
                                if(name09 == ''){
                                    name09 = c.Sales_Rep_Profile__r.name;
                                }else{
                                    name09 = name09+'<br/>' +c.Sales_Rep_Profile__r.name;
                                }
                            }
                        } 
                    }
                    integer sum = count05+count06+count07+count08+count09;
                    mapScoreCount.put(c.Rating_Score__c,sum);
                    //data1.add(new Data1(String.valueof(count), c.Rating_Score__c,c1.Rating_Score__c));
                }
            }
        }
        if(cerAnswerList.size() > 0) {
            for(Decimal iScoreCount : mapScoreCount.keySet()) {
                Decimal iScoreCountTotal = mapScoreCount.get(iScoreCount);
                Decimal dScorePercentage = ((Decimal)iScoreCountTotal/cerAnswerList.size()) * 100;
                mapScorePercentage.put(iScoreCount, dScorePercentage.setScale(2));
            }
        }
        if(bubblechart != null && bubblechart.size()>0){
            for(Certification_Answer__c c: bubblechart){
                if(c.Rating_Score__c == 10.00){
                    for(Certification_Answer__c c1: cerAnswerList){
                        if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                            if(c1.Rating_Score__c == 10.00){
                                data1.add(new Data1(name05,String.valueof(count05), c.Rating_Score__c,c1.Rating_Score__c,count05,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 8.00){
                                data1.add(new Data1(name06,String.valueof(count06), c.Rating_Score__c,c1.Rating_Score__c,count06,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 5.00){
                                data1.add(new Data1(name07,String.valueof(count07), c.Rating_Score__c,c1.Rating_Score__c,count07,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 2.00){
                                data1.add(new Data1(name08,String.valueof(count08), c.Rating_Score__c,c1.Rating_Score__c,count08,mapScorePercentage.get(c.Rating_Score__c)));
                            }else if(c1.Rating_Score__c == 0.00){
                                data1.add(new Data1(name09,String.valueof(count09), c.Rating_Score__c,c1.Rating_Score__c,count09,mapScorePercentage.get(c.Rating_Score__c)));
                            }
                        } 
                    }
                }
            }
        }
        
        
        for(Certification_Answer__c c: cerAnswerList){
            if(c.Rating_Score__c == 10){
                vdata1Count10 =vdata1Count10+1 ;
            }else if(c.Rating_Score__c == 8){
                vdata1Count8 =vdata1Count8+1 ;
            }else if(c.Rating_Score__c == 5){
                vdata1Count5 =vdata1Count5+1 ;
            }else if(c.Rating_Score__c == 2){
                vdata1Count2 =vdata1Count2+1 ;
            }else if(c.Rating_Score__c == 0){
                vdata1Count0 =vdata1Count0+1 ;
            }
        }
        
        if(vdata1Count10 != 0){
            vdata1Percentage10 = ((vdata1Count10/cerAnswerList.size()) * 100).round();
        }
        if(vdata1Count8 != 0){
            vdata1Percentage8 = ((vdata1Count8/cerAnswerList.size()) * 100).round();
        }
        if(vdata1Count5 != 0){
            vdata1Percentage5 = ((vdata1Count5/cerAnswerList.size()) * 100).round();
        }
        if(vdata1Count2 != 0){
            vdata1Percentage2 = ((vdata1Count2/cerAnswerList.size()) * 100).round();
        }
        if(vdata1Count0 != 0){
            vdata1Percentage0 = ((vdata1Count0/cerAnswerList.size()) * 100).round();
        }
        
        lstdata1 = data1;
        
        //return data1;
    }
    public List<Data4> lstdata4 {get;set;}
    public Boolean isData4 {get;set;}
    public Boolean CalculateData4() {
        Boolean isData4local = false;
        lstdata4 = new List<Data4>();
        List<Data4> data4 = new List<Data4>();
        lstdata4.clear();
        cerAnswerList.clear();
        List<String> strList = new List<String>();
        List<String> strList1 = new List<String>();
        //List<Company_Level__c> cl = new List<Company_Level__c>();
        List<Sales_Profile_Company_Level_Junction__c> cl2 = new List<Sales_Profile_Company_Level_Junction__c>();
        List<Company_Level__c> regionList = new List<Company_Level__c>();
        integer count = 0;
        integer count1 = 0;
        integer count2 = 0;
        integer count3 = 0;
        integer count4 = 0;
        integer count5 = 0;
        integer count6 = 0;
        integer count7 = 0;
        integer count8 = 0;
        integer count9 = 0;
        integer count_1 = 0;
        integer count_2 = 0;
        integer count_3 = 0;
        integer count_4 = 0;
        integer count_5 = 0;
        integer count_6 = 0;
        integer count_7 = 0;
        integer count_8 = 0;
        integer count_9 = 0;
        integer count_10 = 0;
        integer count00 = 0;
        integer count01 = 0;
        integer count02 = 0;
        integer count03 = 0;
        integer count04 = 0;
        integer count05 = 0;
        integer count06 = 0;
        integer count07 = 0;
        integer count08 = 0;
        integer count09 = 0;
        Map<String,Set<String>> MapLevel_Value = new Map<String,Set<String>>();
        Map<String,Map<Integer, Integer>> MapRating_Score = new Map<String,Map<Integer, Integer>>();
        Map<Integer, Decimal> mapScorePercentage = new Map<Integer, Decimal>();
        Set<String> setSales_Rep_Profile = new Set<String>();
        string namefilt = perfPeriodValues +' '+ sMetricOrSkill;
        //if(selectedType == 'Metrix'){
        system.debug('namefilt1' +namefilt);
        List<Company_Level__c> cmpnyLvl1 = new List<Company_Level__c>();
        List<Company_Level__c> cmpnyLvl = new List<Company_Level__c>();
        If(fw.selectedLevelThree == 'All'){
            //cl = [SELECT id,Sales_Rep_Profile__r.Sales_Manager__c,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name FROM Company_Level__c Where Level_Value__c =: fw.SelectedLevelOne];
            Rolevalue = '';
            cmpnyLvl1 = [select Sales_Rep_Profile__c, Level_Value__c,Order__c from Company_Level__c where Level_Value__c = :fw.SelectedLevelOne];
            cmpnyLvl = [select Sales_Rep_Profile__c, Level_Value__c,Order__c from Company_Level__c where Sales_Rep_Profile__r.Sales_Manager__c = : cmpnyLvl1[0].Sales_Rep_Profile__c Or Sales_Rep_Profile__c =:cmpnyLvl1[0].Sales_Rep_Profile__c];
            List<String> lvl = new List<String>();
            //lvl.add(cmpnyLvl1[0].Level_Value__c);
            for(Company_Level__c l : cmpnyLvl){
                lvl.add(l.Level_Value__c);
            }
            cl2 = [SELECT Sales_Rep_Profile__c,FunnelMetrics__Company_Level__r.Order__c,FunnelMetrics__Company_Level__r.FunnelMetrics__Level_Value__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN : lvl Order by Company_Level__r.Order__c];
        }else if (fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
            //cl = [SELECT id,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name FROM Company_Level__c Where Level_Value__c =: fw.SelectedLevelOne and Sales_Rep_Profile__r.Role__c = : fw.SelectedLevelThree];
            Rolevalue = fw.SelectedLevelThree;
            cmpnyLvl1 = [select Sales_Rep_Profile__c, Level_Value__c,Order__c from Company_Level__c where Level_Value__c = :fw.SelectedLevelOne];
            cmpnyLvl = [select Sales_Rep_Profile__c, Level_Value__c,Order__c from Company_Level__c where Sales_Rep_Profile__r.Sales_Manager__c = : cmpnyLvl1[0].Sales_Rep_Profile__c Or Sales_Rep_Profile__c =:cmpnyLvl1[0].Sales_Rep_Profile__c];
            List<String> lvl = new List<String>();
            for(Company_Level__c l : cmpnyLvl){
                lvl.add(l.Level_Value__c);
            }
            cl2 = [SELECT Sales_Rep_Profile__c,FunnelMetrics__Company_Level__r.Order__c,FunnelMetrics__Company_Level__r.FunnelMetrics__Level_Value__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :lvl and Sales_Rep_Profile__r.Role__c = : fw.SelectedLevelThree Order by Company_Level__r.Order__c];
        }
        
        if(cl2.size() > 0){
            for(FunnelMetrics__Sales_Profile_Company_Level_Junction__c cl1 : cl2){
                if(cl1.Sales_Rep_Profile__c != null) {
                    strList.add(cl1.Sales_Rep_Profile__c);
                }
                if(!MapLevel_Value.isEmpty() && MapLevel_Value.containsKey(cl1.FunnelMetrics__Company_Level__r.FunnelMetrics__Level_Value__c)) {
                    MapLevel_Value.get(cl1.FunnelMetrics__Company_Level__r.FunnelMetrics__Level_Value__c).add(cl1.FunnelMetrics__Sales_Rep_Profile__c);
                    setSales_Rep_Profile.add(cl1.FunnelMetrics__Sales_Rep_Profile__c);
                }
                else {
                    MapLevel_Value.put(cl1.FunnelMetrics__Company_Level__r.FunnelMetrics__Level_Value__c, new Set<String>{cl1.FunnelMetrics__Sales_Rep_Profile__c});
                    setSales_Rep_Profile.add(cl1.FunnelMetrics__Sales_Rep_Profile__c);
                }
            }
        }
        
        
        if(setSales_Rep_Profile.size() > 0){
            if(selectedType == 'Metrix'){
                List<Certification_Answer__c> ca = [Select id,Due_Date__c from Certification_Answer__c where Rating_Score__c!= null and Certifcation_Rating__r.name = : sMetricOrSkill order by Due_Date__c desc Limit 1];
                if(ca != null && ca.size() > 0){
                    cerAnswerList = [Select id,name, FunnelMetrics__Sales_Rep_Profile__r.name, FunnelMetrics__Rating_Score__c, FunnelMetrics__Sales_Rep_Profile__r.FunnelMetrics__Role__c, FunnelMetrics__Sales_Rep_Profile__c from FunnelMetrics__Certification_Answer__c where FunnelMetrics__Certifcation_Rating__r.name = : sMetricOrSkill  AND FunnelMetrics__Sales_Rep_Profile__c IN : setSales_Rep_Profile and Due_Date__c =: ca[0].Due_Date__c];
                }
            }else if(selectedType == 'Skill'){
                String timing = '';
                if(perfPeriodValues == 'Monthly'){
                    timing = 'End of month';
                }else if(perfPeriodValues == 'Quarterly'){
                    timing = 'End of quarter';
                }else if(perfPeriodValues == 'Bi-Annual'){
                    timing = 'Bi-annual';
                }else if(perfPeriodValues == 'Annual'){
                    timing = 'Annual';
                }
                List<Certification_Answer__c> ca = [Select id,Due_Date__c from Certification_Answer__c where Rating_Score__c!= null AND FunnelMetrics__Certifcation_Rating__r.FunnelMetrics__Timing__c =: timing and Certifcation_Rating__r.name = : sMetricOrSkill order by Due_Date__c desc Limit 1];
                if(ca != null && ca.size() > 0){
                    cerAnswerList = [Select id,name, FunnelMetrics__Sales_Rep_Profile__r.name, FunnelMetrics__Rating_Score__c, FunnelMetrics__Sales_Rep_Profile__r.FunnelMetrics__Role__c, FunnelMetrics__Sales_Rep_Profile__c from FunnelMetrics__Certification_Answer__c where FunnelMetrics__Certifcation_Rating__r.name = : sMetricOrSkill  AND FunnelMetrics__Certifcation_Rating__r.FunnelMetrics__Timing__c =: timing  AND FunnelMetrics__Sales_Rep_Profile__c IN : setSales_Rep_Profile and Due_Date__c =: ca[0].Due_Date__c]; 
                }
            }
            Map<Integer, Integer> mapScoreCount = new Map<Integer, Integer>();
            for(Certification_Answer__c c1: cerAnswerList){
                if(c1.Rating_Score__c == 10.00 || c1.Rating_Score__c == 8.00 || c1.Rating_Score__c == 5.00 || c1.Rating_Score__c == 2.00 || c1.Rating_Score__c == 0.00){
                    
                    Integer iRating_Score = Integer.valueOf(c1.Rating_Score__c);
                    count = count+1;
                    if(!MapRating_Score.isEmpty() && MapRating_Score.containsKey(c1.FunnelMetrics__Sales_Rep_Profile__c)) {
                        Map<Integer, Integer> mapChildRating_Score = MapRating_Score.get(c1.FunnelMetrics__Sales_Rep_Profile__c);
                        if(mapChildRating_Score.containsKey(iRating_Score)) {
                            mapChildRating_Score.put(iRating_Score, mapChildRating_Score.get(iRating_Score) + 1);
                        }
                        else {
                            mapChildRating_Score.put(iRating_Score, 1);
                        }
                        MapRating_Score.put(c1.FunnelMetrics__Sales_Rep_Profile__c, mapChildRating_Score);
                    }
                    else {
                        Map<Integer, Integer> mapChildRating_Score = new Map<Integer, Integer>();
                        mapChildRating_Score.put(iRating_Score, 1);
                        MapRating_Score.put(c1.FunnelMetrics__Sales_Rep_Profile__c, mapChildRating_Score);
                    }
                    if(!mapScoreCount.isEmpty() && mapScoreCount.containsKey(iRating_Score)) {
                        mapScoreCount.put(iRating_Score, mapScoreCount.get(iRating_Score)+1);
                    }
                    else {
                        mapScoreCount.put(iRating_Score, 1);
                    }
                    
                }
            }
            if(cerAnswerList.size() > 0) {
                for(Integer iScoreCount : mapScoreCount.keySet()) {
                    Integer iScoreCountTotal = mapScoreCount.get(iScoreCount);
                    Decimal dScorePercentage = ((Decimal)iScoreCountTotal/cerAnswerList.size()) * 100;
                    mapScorePercentage.put(iScoreCount, dScorePercentage.setScale(2));
                }
                
            }
            data4.clear();
            if(!MapLevel_Value.isEmpty()) {
                for(String sLevel_Value : MapLevel_Value.keySet()) {
                    system.debug('Checking sLevel_Value :' + sLevel_Value);
                    Set<String> setProfile = MapLevel_Value.get(sLevel_Value);
                    Integer iCount10 = 0;
                    Integer iCount8 = 0;
                    Integer iCount5 = 0;
                    Integer iCount2 = 0;
                    Integer iCount0 = 0;
                    decimal iPer10 = 0;
                    decimal iPer8 = 0;
                    decimal iPer5 = 0;
                    decimal iPer2 = 0;
                    decimal iPer0 = 0;
                    decimal iTotal = 0;
                    system.debug('setProfile' + setProfile);
                    for(String sProfile : setProfile) {
                        if(MapRating_Score.containsKey(sProfile)) {
                            Map<Integer, Integer> mapChildRating_Score = MapRating_Score.get(sProfile);
                            for(Integer iScore : mapChildRating_Score.keySet()) {
                                if(iScore == 10) {
                                    iCount10 = iCount10 + mapChildRating_Score.get(iScore);
                                }
                                else if(iScore == 8) {
                                    iCount8 = iCount8 + mapChildRating_Score.get(iScore);
                                }
                                else if(iScore == 5) {
                                    iCount5 = iCount5 + mapChildRating_Score.get(iScore);
                                }
                                else if(iScore == 2) {
                                    iCount2 = iCount2 + mapChildRating_Score.get(iScore);
                                }
                                else if(iScore == 0) {
                                    iCount0 = iCount0 + mapChildRating_Score.get(iScore);
                                }
                            }
                        }
                    }
                    iTotal = (decimal)iCount10+iCount8+iCount5+iCount2+iCount0;
                    if(iCount10 > 0) {
                        iPer10 = ((decimal)iCount10/iTotal)*100;
                        data4.add(new Data4(sLevel_Value, iPer10, 10, mapScorePercentage.get(10)));
                    }else if(iCount10 == 0){
                        data4.add(new Data4(sLevel_Value, 0, 10, mapScorePercentage.get(10)));
                    }
                    if(iCount8 > 0) {
                        iPer8 = ((decimal)iCount8/iTotal)*100;
                        data4.add(new Data4(sLevel_Value, iPer8, 8, mapScorePercentage.get(8)));
                    }else if(iCount8 == 0){
                        data4.add(new Data4(sLevel_Value, 0, 8, mapScorePercentage.get(8)));
                    }
                    if(iCount5 > 0) {
                        iPer5 = ((decimal)iCount5/iTotal)*100;
                        data4.add(new Data4(sLevel_Value, iPer5, 5, mapScorePercentage.get(5)));
                    }else if(iCount5 == 0){
                        data4.add(new Data4(sLevel_Value, 0, 5, mapScorePercentage.get(5)));
                    }
                    if(iCount2 > 0) {
                        iPer2 = ((decimal)iCount2/iTotal)*100;
                        data4.add(new Data4(sLevel_Value, iPer2, 2, mapScorePercentage.get(2)));
                    }else if(iCount2 == 0){
                        data4.add(new Data4(sLevel_Value, 0, 2, mapScorePercentage.get(2)));
                    }
                    if(iCount0 > 0) {
                        iPer0 = ((decimal)iCount0/iTotal)*100;
                        data4.add(new Data4(sLevel_Value, iPer0, 0, mapScorePercentage.get(0)));
                    }else if(iCount0 == 0){
                        data4.add(new Data4(sLevel_Value, 0, 0, mapScorePercentage.get(0)));
                    }
                }
                
            }
        }
        //}    // isData4 = true;
        lstdata4 = data4;
        return isData4;
    }
    
    public void CalculateData2() {
        List<Data2> data2 = new List<Data2>();
        lstdata2 = new List<Data2>();
        lstdata2.clear();
        cerAnswerList.clear();
        vdata2Percentage10 = 0;
        vdata2Percentage8 = 0;
        vdata2Percentage5 = 0;
        vdata2Percentage2 = 0;
        vdata2Percentage0 = 0;
        vdata2Count10 = 0;
        vdata2Count8 = 0;
        vdata2Count5 = 0;
        vdata2Count2 = 0;
        vdata2Count0 = 0;
        averagevalue2 = 0;
        selectedTypevalue = sMetricOrSkill;
        perfPeriodValuesvalue = perfPeriodValues;
        string namefilt = perfPeriodValues +' '+ sMetricOrSkill;
        string quotafilt = 'YTD' +' Quota Performance';
        integer count = 0;
        integer count1 = 0;
        integer count2 = 0;
        integer count3 = 0;
        integer count4 = 0;
        integer count5 = 0;
        integer count6 = 0;
        integer count7 = 0;
        integer count8 = 0;
        integer count9 = 0;
        integer count_1 = 0;
        integer count_2 = 0;
        integer count_3 = 0;
        integer count_4 = 0;
        integer count_5 = 0;
        integer count_6 = 0;
        integer count_7 = 0;
        integer count_8 = 0;
        integer count_9 = 0;
        integer count_10 = 0;
        integer count00 = 0;
        integer count01 = 0;
        integer count02 = 0;
        integer count03 = 0;
        integer count04 = 0;
        integer count05 = 0;
        integer count06 = 0;
        integer count07 = 0;
        integer count08 = 0;
        integer count09 = 0;
        Map<Decimal, Decimal> mapScorePercentage = new Map<Decimal, Decimal>();
        //if(selectedType == 'Metrix'){
        if(fw.SelectedLevelThree != 'All'){
            Rolevalue = fw.SelectedLevelThree;
        }else{
            Rolevalue = '';
        }
        Map<Decimal, Decimal> mapScoreCount = new Map<Decimal, Decimal>();
        
        If(fw.selectedLevelThree == 'All'){
            cl = [SELECT id,Sales_Rep_Profile__r.Sales_Manager__c,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name FROM Company_Level__c Where Level_Value__c =: fw.SelectedLevelOne];
            List<Sales_Profile_Company_Level_Junction__c> sj = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne];
            strList1.clear();
            for(Sales_Profile_Company_Level_Junction__c s:sj){
                strList1.add(s.Sales_Rep_Profile__c);
            }
        }else if (fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
            cl = [SELECT id,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name FROM Company_Level__c Where Level_Value__c =: fw.SelectedLevelOne and Sales_Rep_Profile__r.Role__c = : fw.SelectedLevelThree];
            List<Sales_Profile_Company_Level_Junction__c> sj = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne and Sales_Rep_Profile__r.Role__c = : fw.SelectedLevelThree];
            strList1.clear();
            for(Sales_Profile_Company_Level_Junction__c s:sj){
                strList1.add(s.Sales_Rep_Profile__c);
            }
        }
        
        
        List<Certification_Answer__c> cans = [Select id,Due_Date__c from Certification_Answer__c where Rating_Score__c!= null and Certifcation_Rating__r.name = : quotafilt order by Due_Date__c desc Limit 1];
        List<AggregateResult> avg = new List<AggregateResult>();
        if(cans != null && cans.size() > 0){
            bubblechart =[Select Rating_Score__c,Sales_Rep_Profile__r.name from Certification_Answer__c where Certifcation_Rating__r.name = : quotafilt AND FunnelMetrics__Sales_Rep_Profile__c IN : strList1 and Due_Date__c =: cans[0].Due_Date__c];
            avg = [select AVG(Rating_Score__c)a from Certification_Answer__c where Certifcation_Rating__r.name = : quotafilt AND FunnelMetrics__Sales_Rep_Profile__c IN : strList1 and Due_Date__c =: cans[0].Due_Date__c];
            averagevalue2 = (decimal)avg[0].get('a');
        }
        if(selectedType == 'Metrix'){
            List<Certification_Answer__c> ca = [Select id,Due_Date__c from Certification_Answer__c where Rating_Score__c!= null and Certifcation_Rating__r.name = : sMetricOrSkill order by Due_Date__c desc Limit 1];
            if(ca != null && ca.size() > 0){
                cerAnswerList = [Select id,name, FunnelMetrics__Sales_Rep_Profile__r.name, FunnelMetrics__Rating_Score__c, FunnelMetrics__Sales_Rep_Profile__r.FunnelMetrics__Role__c, FunnelMetrics__Sales_Rep_Profile__c from FunnelMetrics__Certification_Answer__c where FunnelMetrics__Certifcation_Rating__r.name = : sMetricOrSkill  AND FunnelMetrics__Sales_Rep_Profile__c IN : strList1 and Due_Date__c = : ca[0].Due_Date__c order by Rating_Score__c desc];
            }
        }else if(selectedType == 'Skill'){
            String timing = '';
            if(perfPeriodValues == 'Monthly'){
                timing = 'End of month';
            }else if(perfPeriodValues == 'Quarterly'){
                timing = 'End of quarter';
            }else if(perfPeriodValues == 'Bi-Annual'){
                timing = 'Bi-annual';
            }else if(perfPeriodValues == 'Annual'){
                timing = 'Annual';
            }
            system.debug('timing :: '+perfPeriodValues);
            List<Certification_Answer__c> ca = [Select id,Due_Date__c from Certification_Answer__c where Rating_Score__c!= null AND FunnelMetrics__Certifcation_Rating__r.FunnelMetrics__Timing__c =: timing and Certifcation_Rating__r.name = : sMetricOrSkill order by Due_Date__c desc Limit 1];
            system.debug('ca list :: '+ca);
            if(ca != null && ca.size() > 0){
                cerAnswerList = [Select id,name, FunnelMetrics__Sales_Rep_Profile__r.name, FunnelMetrics__Rating_Score__c, FunnelMetrics__Sales_Rep_Profile__r.FunnelMetrics__Role__c, FunnelMetrics__Sales_Rep_Profile__c from FunnelMetrics__Certification_Answer__c where FunnelMetrics__Certifcation_Rating__r.name = : sMetricOrSkill  AND FunnelMetrics__Certifcation_Rating__r.FunnelMetrics__Timing__c =: timing  AND FunnelMetrics__Sales_Rep_Profile__c IN : strList1 and Due_Date__c = : ca[0].Due_Date__c]; 
            }
        }
        for(Certification_Answer__c c :cerAnswerList){
            scoremap.put(c.Sales_Rep_Profile__c,c);
        }
        system.debug('cerAnswerList :: '+cerAnswerList);
        if(bubblechart != null && bubblechart.size()>0){ 
        for(Certification_Answer__c c: bubblechart){
            if(c.Rating_Score__c == 0.00){
                for(Certification_Answer__c c1: cerAnswerList){
                    if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                        if(c1.Rating_Score__c == 10.00){
                            count = count+1;
                        }else if(c1.Rating_Score__c == 8.00){
                            count1 = count1+1;
                        }else if(c1.Rating_Score__c == 5.00){
                            count2 = count2+1;
                        }else if(c1.Rating_Score__c == 2.00){
                            count3 = count3+1;
                        }else if(c1.Rating_Score__c == 0.00){
                            count4 = count4+1;
                        }
                    } 
                }
                integer sum = count+count1+count2+count3+count4;
                mapScoreCount.put(c.Rating_Score__c,sum);
                //data1.add(new Data1(String.valueof(count), c.Rating_Score__c,c1.Rating_Score__c));
            }
        }
        }
        if(cerAnswerList.size() > 0) {
            for(Decimal iScoreCount : mapScoreCount.keySet()) {
                Decimal iScoreCountTotal = mapScoreCount.get(iScoreCount);
                Decimal dScorePercentage = ((Decimal)iScoreCountTotal/cerAnswerList.size()) * 100;
                mapScorePercentage.put(iScoreCount, dScorePercentage.setScale(2));
            }
        }
        if(bubblechart != null && bubblechart.size()>0){
        for(Certification_Answer__c c: bubblechart){
            if(c.Rating_Score__c == 0.00){
                for(Certification_Answer__c c1: cerAnswerList){
                    if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                        if(c1.Rating_Score__c == 10.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name,c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 8.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name,c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 5.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name,c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 2.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name,c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 0.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name,c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }
                    } 
                }
            }
        }
        for(Certification_Answer__c c: bubblechart){
            if(c.Rating_Score__c == 2.00){
                for(Certification_Answer__c c1: cerAnswerList){
                    if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                        if(c1.Rating_Score__c == 10.00){
                            count5 = count5+1;
                        }else if(c1.Rating_Score__c == 8.00){
                            count6 = count6+1;
                        }else if(c1.Rating_Score__c == 5.00){
                            count7 = count7+1;
                        }else if(c1.Rating_Score__c == 2.00){
                            count8 = count8+1;
                        }else if(c1.Rating_Score__c == 0.00){
                            count9 = count9+1;
                        }
                    } 
                }
                integer sum = count5+count6+count7+count8+count9;
                mapScoreCount.put(c.Rating_Score__c,sum);
                //data1.add(new Data1(String.valueof(count), c.Rating_Score__c,c1.Rating_Score__c));
            }
        }
        }
        if(cerAnswerList.size() > 0) {
            for(Decimal iScoreCount : mapScoreCount.keySet()) {
                Decimal iScoreCountTotal = mapScoreCount.get(iScoreCount);
                Decimal dScorePercentage = ((Decimal)iScoreCountTotal/cerAnswerList.size()) * 100;
                mapScorePercentage.put(iScoreCount, dScorePercentage.setScale(2));
            }
        }
        if(bubblechart != null && bubblechart.size()>0){
        for(Certification_Answer__c c: bubblechart){
            if(c.Rating_Score__c == 2.00){
                for(Certification_Answer__c c1: cerAnswerList){
                    if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                        if(c1.Rating_Score__c == 10.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name, c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 8.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name,c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 5.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name, c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 2.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name,c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 0.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name,c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }
                    } 
                }
            }
        }
        for(Certification_Answer__c c: bubblechart){
            if(c.Rating_Score__c == 5.00){
                for(Certification_Answer__c c1: cerAnswerList){
                    if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                        if(c1.Rating_Score__c == 10.00){
                            count_1 = count_1+1;
                        }else if(c1.Rating_Score__c == 8.00){
                            count_2 = count_2+1;
                        }else if(c1.Rating_Score__c == 5.00){
                            count_3 = count_3+1;
                        }else if(c1.Rating_Score__c == 2.00){
                            count_4 = count_4+1;
                        }else if(c1.Rating_Score__c == 0.00){
                            count_5 = count_5+1;
                        }
                    } 
                }
                integer sum = count_1+count_2+count_3+count_4+count_5;
                mapScoreCount.put(c.Rating_Score__c,sum);
                //data1.add(new Data1(String.valueof(count), c.Rating_Score__c,c1.Rating_Score__c));
            }
        }
        }
        if(cerAnswerList.size() > 0) {
            for(Decimal iScoreCount : mapScoreCount.keySet()) {
                Decimal iScoreCountTotal = mapScoreCount.get(iScoreCount);
                Decimal dScorePercentage = ((Decimal)iScoreCountTotal/cerAnswerList.size()) * 100;
                mapScorePercentage.put(iScoreCount, dScorePercentage.setScale(2));
            }
        }
        if(bubblechart != null && bubblechart.size()>0){
        for(Certification_Answer__c c: bubblechart){
            if(c.Rating_Score__c == 5.00){
                for(Certification_Answer__c c1: cerAnswerList){
                    if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                        if(c1.Rating_Score__c == 10.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name,c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 8.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name,c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 5.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name,c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 2.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name, c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 0.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name,c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }
                    } 
                }
            }
        }
        for(Certification_Answer__c c: bubblechart){
            if(c.Rating_Score__c == 8.00){
                for(Certification_Answer__c c1: cerAnswerList){
                    if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                        if(c1.Rating_Score__c == 10.00){
                            count00 = count00+1;
                        }else if(c1.Rating_Score__c == 8.00){
                            count01 = count01+1;
                        }else if(c1.Rating_Score__c == 5.00){
                            count02 = count02+1;
                        }else if(c1.Rating_Score__c == 2.00){
                            count03 = count03+1;
                        }else if(c1.Rating_Score__c == 0.00){
                            count04 = count04+1;
                        }
                    } 
                }
                integer sum = count00+count01+count02+count03+count04;
                mapScoreCount.put(c.Rating_Score__c,sum);
                //data1.add(new Data1(String.valueof(count), c.Rating_Score__c,c1.Rating_Score__c));
            }
        }
        }
        if(cerAnswerList.size() > 0) {
            for(Decimal iScoreCount : mapScoreCount.keySet()) {
                Decimal iScoreCountTotal = mapScoreCount.get(iScoreCount);
                Decimal dScorePercentage = ((Decimal)iScoreCountTotal/cerAnswerList.size()) * 100;
                mapScorePercentage.put(iScoreCount, dScorePercentage.setScale(2));
            }
        }
        if(bubblechart != null && bubblechart.size()>0){
        for(Certification_Answer__c c: bubblechart){
            if(c.Rating_Score__c == 8.00){
                for(Certification_Answer__c c1: cerAnswerList){
                    if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                        if(c1.Rating_Score__c == 10.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name, c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 8.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name, c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 5.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name, c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 2.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name,c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 0.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name,c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }
                    } 
                }
            }
        }
        
        for(Certification_Answer__c c: bubblechart){
            if(c.Rating_Score__c == 10.00){
                for(Certification_Answer__c c1: cerAnswerList){
                    if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                        if(c1.Rating_Score__c == 10.00){
                            count05 = count05+1;
                        }else if(c1.Rating_Score__c == 8.00){
                            count06 = count06+1;
                        }else if(c1.Rating_Score__c == 5.00){
                            count07 = count07+1;
                        }else if(c1.Rating_Score__c == 2.00){
                            count08 = count08+1;
                        }else if(c1.Rating_Score__c == 0.00){
                            count09 = count09+1;
                        }
                    } 
                }
                integer sum = count05+count06+count07+count08+count09;
                mapScoreCount.put(c.Rating_Score__c,sum);
                //data1.add(new Data1(String.valueof(count), c.Rating_Score__c,c1.Rating_Score__c));
            }
        }
        }
        if(cerAnswerList.size() > 0) {
            for(Decimal iScoreCount : mapScoreCount.keySet()) {
                Decimal iScoreCountTotal = mapScoreCount.get(iScoreCount);
                Decimal dScorePercentage = ((Decimal)iScoreCountTotal/cerAnswerList.size()) * 100;
                mapScorePercentage.put(iScoreCount, dScorePercentage.setScale(2));
            }
        }
        if(bubblechart != null && bubblechart.size()>0){
        for(Certification_Answer__c c: bubblechart){
            if(c.Rating_Score__c == 10.00){
                for(Certification_Answer__c c1: cerAnswerList){
                    if(c.Sales_Rep_Profile__c == c1.Sales_Rep_Profile__c){
                        if(c1.Rating_Score__c == 10.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name, c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 8.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name,c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 5.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name, c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 2.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name, c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }else if(c1.Rating_Score__c == 0.00){
                            data2.add(new Data2(c.Sales_Rep_Profile__r.name,c.Rating_Score__c,c1.Rating_Score__c,mapScorePercentage.get(c.Rating_Score__c)));
                        }
                    } 
                }
            }
        }
            
        for(Certification_Answer__c c: bubblechart){
            if(c.Rating_Score__c == 10){
                vdata2Count10 =vdata2Count10+1 ;
            }else if(c.Rating_Score__c == 8){
                vdata2Count8 =vdata2Count8+1 ;
            }else if(c.Rating_Score__c == 5){
                vdata2Count5 =vdata2Count5+1 ;
            }else if(c.Rating_Score__c == 2){
                vdata2Count2 =vdata2Count2+1 ;
            }else if(c.Rating_Score__c == 0){
                vdata2Count0 =vdata2Count0+1 ;
            }
        }
        }
        if(vdata2Count10 != 0){
            vdata2Percentage10 = ((vdata2Count10/bubblechart.size()) * 100).round();
        }
        if(vdata2Count8 != 0){
            vdata2Percentage8 = ((vdata2Count8/bubblechart.size()) * 100).round();
        }
        if(vdata2Count5 != 0){
            vdata2Percentage5 = ((vdata2Count5/bubblechart.size()) * 100).round();
        }
        if(vdata2Count2 != 0){
            vdata2Percentage2 = ((vdata2Count2/bubblechart.size()) * 100).round();
        }
        if(vdata2Count0 != 0){
            vdata2Percentage0 = ((vdata2Count0/bubblechart.size()) * 100).round();
        }
        
        
        lstdata2 =  data2;
    }
    
    /*Filters*/
    //Method called when reset button is selected
    public PageReference reset(){
        
        
        return FunnelNavigationHelper.navigateToCalculator('','','','','',''); 
        
    }
    /*Filters*/ 
    
    public void showUpdated(){
        try{
            system.debug('inside show update');    
            system.debug('fw.selectedLevelThree :: '+fw.selectedLevelThree);
            system.debug('fw.selectedLevelFour :: '+fw.selectedLevelFour);
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelScorecard '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        } 
    }
    
    //Action method when level one is changed
    public void levelOneAction(){
        if(readAccess){
            try{
                FunnelFilterHelper.levelOneAction(fw);
                defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw);
                PopulateMetricOrSkill();
                CalculateData4();
                CalculateData();
                calculateData1();
                CalculateData2();
            }
            catch(Exception ex){
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
                defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw);
                CalculateData4();
                CalculateData();
                calculateData1();
                CalculateData2();
            }
            catch(Exception ex){
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
    
    public PageReference navigateToTrendingByRep(){
        
        return FunnelNavigationHelper.navigateToTrendingByRep(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToTrndngRep(){
        
        return FunnelNavigationHelper.navigateToTrndngRep(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
        
    }
    
    public PageReference navigateToTrendingBySkill(){
        
        return FunnelNavigationHelper.navigateToTrendingBySkill(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToSalesPipeline(){
        
        return FunnelNavigationHelper.navigateToSalesPipeline(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
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
        FunnelFilterHelper.onclickpopulateFilters(crumValue,fw);
        ExecuteChart();
        
    } 
    
    
    
    /* Gap tabel methods*/
    
    
    /*Table methods*/   
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
    
    public class filterWrappers{
        public String selectedTypeOne{get;set;}
        public List<String> selectTypeList{get;set;}
        public List<String> selectPeriodList{get;set;}
        public List<String> selectMetricOrSkillList{get;set;}
        
    }
    
    public static filterWrappers metricsSkillsFilters(){
        filterWrappers fWrap= new filterWrappers();
        
        Schema.DescribeFieldResult pickList = selectTypeMetricOrSkill__mdt.Select_Type__c.getDescribe();
        Schema.DescribeFieldResult metricPeriodPickList = selectTypeMetricOrSkill__mdt.Select_an_Performance_Period__c.getDescribe();
        Schema.DescribeFieldResult skillPeriodPickList = selectTypeMetricOrSkill__mdt.Select_an_Performance_Period_Skills__c.getDescribe();
        Schema.DescribeFieldResult skillsSubmenuPickList = selectTypeMetricOrSkill__mdt.SelectSkillMenu__c.getDescribe();
        
        if(pickList.getPicklistValues() != null && pickList.getPicklistValues().size() <= 0){
            for( Schema.PicklistEntry pickVal : pickList.getPicklistValues()){
                fWrap.selectTypeList.add(pickVal.getValue());
            }
        }
        return fWrap;
    }
    public List<SelectOption> lstMetricOrSkill {get; set;}
    public List<SelectOption> performancePeriod {get; set;}
    public string sMetricOrSkill {get; set;}
    public String ratingScale0 {get; set;}
    public String ratingScale2 {get; set;}
    public String ratingScale5 {get; set;}
    public String ratingScale8 {get; set;}
    public String ratingScale10 {get; set;}
    public void PopulateMetricOrSkill() {
        lstMetricOrSkill = new List<SelectOption>();
        performancePeriod = new List<SelectOption>();
        if(selectedType == 'Metrix'){
            performancePeriod.add(new SelectOption('Monthly','Monthly'));
            performancePeriod.add(new SelectOption('Quarterly','Quarterly'));
            performancePeriod.add(new SelectOption('YTD','YTD'));
            performancePeriod.add(new SelectOption('Rolling 12 Month','Rolling 12 Month'));
        }else{
            performancePeriod.add(new SelectOption('Monthly','Monthly'));
            performancePeriod.add(new SelectOption('Quarterly','Quarterly'));
            performancePeriod.add(new SelectOption('Bi-Annual','Bi-Annual'));
            performancePeriod.add(new SelectOption('Annual','Annual'));
        }
        List<Certification_Rating__c> cr = new List<Certification_Rating__c>();
        system.debug('selectedType :: '+selectedType);
        if(selectedType == 'Metrix') {
            ratingScale0 = 'Needs Improvement';
            ratingScale2 = 'Marginal';
            ratingScale5 = 'Average';
            ratingScale8 = 'Strong';
            ratingScale10 = 'Outstanding';
            cr = [select id,name,Category__c from Certification_Rating__c where Category__c = 'Quantitative' And Deactivated__c = false Order by name];
            List<String> nLst = new List<String>();
            if(perfPeriodValues != 'YTD' && perfPeriodValues != 'Monthly' && perfPeriodValues != 'Quarterly' && perfPeriodValues != 'Rolling 12 Month'){
                perfPeriodValues = 'YTD';
            }
            for(Certification_Rating__c c: cr){
                if(perfPeriodValues == 'YTD' && c.name.contains('YTD')){
                    lstMetricOrSkill.add(new SelectOption(c.name,c.name));
                    nLst.add(c.Name);
                }else if(perfPeriodValues == 'Monthly' && c.name.contains('Monthly')){
                    lstMetricOrSkill.add(new SelectOption(c.name,c.name));
                    nLst.add(c.Name);
                }else if(perfPeriodValues == 'Quarterly' && c.name.contains('Quarterly')){
                    lstMetricOrSkill.add(new SelectOption(c.name,c.name));
                    nLst.add(c.Name);
                }else if(perfPeriodValues == 'Rolling 12 Month' && c.name.contains('12 Month Rolling')){
                    lstMetricOrSkill.add(new SelectOption(c.name,c.name));
                    nLst.add(c.Name);
                }
                if(!c.name.contains('YTD') && !c.name.contains('Monthly') && !c.name.contains('Quarterly') && !c.name.contains('12 Month Rolling')){
                    lstMetricOrSkill.add(new SelectOption(c.name,c.name));
                    nLst.add(c.Name);
                }
            }
            
            if(sMetricOrSkill != null && sMetricOrSkill !='' && !nLst.Contains(sMetricOrSkill)){
                sMetricOrSkill = lstMetricOrSkill[0].getValue();
            }
            
        }
        else {
            ratingScale0 = 'Greatly Below';
            ratingScale2 = 'Below';
            ratingScale5 = 'Meets';
            ratingScale8 = 'Exceeds';
            ratingScale10 = 'Greatly Exceeds';
            if(perfPeriodValues != 'Monthly' && perfPeriodValues != 'Quarterly' && perfPeriodValues != 'Bi-Annual' && perfPeriodValues != 'Annual'){
                perfPeriodValues = 'Monthly';
            }
            String timing = '';
            if(perfPeriodValues == 'Monthly'){
                timing = 'End of month';
            }else if(perfPeriodValues == 'Quarterly'){
                timing = 'End of quarter';
            }else if(perfPeriodValues == 'Bi-Annual'){
                timing = 'Bi-annual';
            }else if(perfPeriodValues == 'Annual'){
                timing = 'Annual';
            }
            system.debug('timing :: '+ timing);
            List<String> roles = new List<String>();
            if(fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
                cr = [select id,name,Category__c,Timing__c from Certification_Rating__c where Category__c = 'Qualitative' And Deactivated__c = false And Roles_enabled__c INCLUDES (: fw.selectedLevelThree) Order by name];
            }else{
                cr = [select id,name,Category__c,Timing__c from Certification_Rating__c where Category__c = 'Qualitative' And Deactivated__c = false Order by name];
            }
            List<String> cname = new List<String>();
            for(Certification_Rating__c c:cr){
                if(c.Timing__c == timing){
                    lstMetricOrSkill.add(new SelectOption(c.name,c.Name));
                    cname.add(c.Name);
                }
            }
            if(cname != null && cname.size()>0){
                if(sMetricOrSkill != null && sMetricOrSkill !='' && !cname.Contains(sMetricOrSkill)){
                    sMetricOrSkill = lstMetricOrSkill[0].getValue();
                }else if(sMetricOrSkill == null){
                    sMetricOrSkill = lstMetricOrSkill[0].getValue();
                }
            }
            
        }
        //return null;
        ExecuteChart();
    }
    public void ExecuteChart(){
        //PopulateMetricOrSkill();
        CalculateData4();
        CalculateData();
        calculateData1();
        CalculateData2();
        
    }
    public class Data {
        
        public String name { get; set; }
        public String srpName { get; set; }
        public Integer data1 { get; set; }
        
        public Integer data2 { get; set; }
        
        public Integer data3 { get; set; }
        public Integer data4 { get; set; }
        public Integer data5 { get; set; }
        public Integer data6 { get; set; }
        
        public Decimal data7 { get; set; }
        
        public Decimal data8 { get; set; }
        
        public Decimal data9 { get; set; }
        public Decimal data10 { get; set; }
        public Decimal data11 { get; set; }
        public Decimal data13 { get; set; }     
        public Decimal data12 { get; set; }
        
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
        public Data(String name, Integer data13) {
            
            this.name = name;
            
            this.data13 = data13;
            
        }}
    public class Data1 {
        
        public String name { get; set; }
        public String srpName { get; set; }
        
        public Decimal data13 { get; set; }
        public Decimal data12 { get; set; }
        public Integer data14 { get; set; }
        public Decimal Percentage { get; set; }
        public Data1(String srpName,String Name, Decimal data13,Decimal data12, Integer data14, Decimal Percentage) {
            
            this.Name = Name;
            this.srpName = srpName;
            
            this.data13 = data13;
            this.data12 = data12;
            this.data14 = data14;
            this.Percentage = Percentage;
        }
    }
    public class Data4 {
        
        public String name { get; set; }
        
        public Decimal data13 { get; set; }
        public Decimal ScoreType { get; set; }
        public Decimal Percentage { get; set; }
        public Data4(String Name, Decimal data13, Decimal ScoreType, Decimal Percentage) {
            
            this.Name = Name;
            
            this.data13 = data13.setScale(0);
            this.ScoreType = ScoreType;
            this.Percentage = Percentage;
            
        }
    }
    public class Data2 {
        
        public String name { get; set; }
        public String salesrep { get; set; }
        public Decimal data13 { get; set; }
        public Decimal data12 { get; set; }
        public Decimal percentage { get; set; }
        
        public Data2(String salesrep, Decimal data13,Decimal data12) {
            
            this.salesrep = salesrep;
            this.data13 = data13;
            this.data12 = data12;
            
        }
        
        public Data2(String salesrep, Decimal data13,Decimal data12, Decimal percentage) {
            this.salesrep = salesrep;
            this.data13 = data13;
            this.data12 = data12;
            this.percentage = percentage;
            
        }
    }
    
}