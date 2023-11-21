/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelScorecard{
    
    
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    
    
    public Boolean LeadUsed  {get;set;}
    public Boolean MeetingUsed  {get;set;} 
    
    
    Sales_Rep_Profile__c srpcal = new Sales_Rep_Profile__c();
    List<AggregateResult> srpteam = new list<AggregateResult>();
    public string username ;
    public Sales_Rep_Profile__c srp{get;set;}
    public Id srpid{get;set;}
    
    
    public String curentPipeline{get;set;}
    public String activeopp{get;set;}
    public String ytdWin{get;set;}
    public String winNeedToMakeQuota{get;set;}
    
    
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
    
    private String roleVal;
    private List<Certification_rating__c> ratingRecs;
    private Set<id> ratings;
    private List<Important_Rating__c> rats = new List<Important_Rating__c>();
    private List<Certification_rating__c> ratingRecsQual;
    private Set<id> ratingsQual;
    private List<Important_Rating__c> ratsQual = new List<Important_Rating__c>();
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
    
    //added by shaik Amanulla (declared role variables everywhere)

    public Decimal YTDQuotaPerformance {get;set;}
    public Decimal YTDQuotaPerformanceTeam{get;set;}
    public Decimal YTDQuotaPerformanceGoal{get;set;}
    public Decimal YTDQuotaPerformanceRole{get;set;}
    
    
    public Decimal YTDLeadsAdded{get;set;}
    public Decimal YTDLeadsAddedTeam{get;set;}
    public Decimal YTDLeadsAddedGoal{get;set;}
    public Decimal YTDLeadsAddedRole{get;set;}
    
    public Decimal X12MonthRollingLeadConversion {get;set;}
    public Decimal X12MonthRollingLeadConversionTeam{get;set;}
    public Decimal X12MonthRollingLeadConversionGoal{get;set;}
    public Decimal X12MonthRollingLeadConversionRole{get;set;}

    
    
    public Decimal YTDNumberofMeetings{get;set;}
    public Decimal YTDNumberofMeetingsTeam{get;set;}
    public Decimal YTDNumberofMeetingsGoal{get;set;}
    public Decimal YTDNumberofMeetingsRole{get;set;}

    
    public Decimal YTDOpportunitiesAddedtoQualifiedFunnel{get;set;}
    public Decimal YTDOpportunitiesAddedtoQualifiedFunnelTeam{get;set;}
    public Decimal YTDOpportunitiesAddedtoQualifiedFunnelGoal{get;set;}
    public Decimal YTDOpportunitiesAddedtoQualifiedFunnelRole{get;set;}

    
    public Decimal X12MonthRollingCloseRatebasedonOpportunities{get;set;}
    public Decimal X12MonthRollingCloseRatebasedonOpportunitiesTeam{get;set;}
    public Decimal X12MonthRollingCloseRatebasedonOpportunitiesGoal{get;set;}
    public Decimal X12MonthRollingCloseRatebasedonOpportunitiesRole{get;set;}
    
    
    public Decimal X12MonthRollingCloseRatebasedondollar{get;set;}
    public Decimal X12MonthRollingCloseRatebasedondollarTeam{get;set;}
    public Decimal X12MonthRollingCloseRatebasedondollarGoal{get;set;}
    public Decimal X12MonthRollingCloseRatebasedondollarRole{get;set;}
    
    public Decimal X12MonthRollingAveragedollarWinSize{get;set;}
    public Decimal X12MonthRollingAveragedollarWinSizeTeam{get;set;}
    public Decimal X12MonthRollingAveragedollarWinSizeGoal{get;set;}
    public Decimal X12MonthRollingAveragedollarWinSizeRole{get;set;}
    
    public Decimal X12MonthRollingLengthofSalesCycle{get;set;}
    public Decimal X12MonthRollingLengthofSalesCycleTeam{get;set;}
    public Decimal X12MonthRollingLengthofSalesCycleGoal{get;set;}
    public Decimal X12MonthRollingLengthofSalesCycleRole{get;set;}
    
    public Decimal X12AverageDealSize{get;set;}
    public Decimal X12AverageDealSizeTeam{get;set;}
    public Decimal X12AverageDealSizeGoal{get;set;}
    public Decimal X12AverageDealSizeRole{get;set;}
    
    public Boolean RoleOverlay{get;set;}
    public Boolean RepOverlay{get;set;}
    
    Boolean readAccess;
    
    
    public FunnelScorecard(){
        try{ 
            
            
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
                    
                    fw = new FunnelFilterWrapper();
                    
                    fw.userId = UserInfo.getUserId();
                    
                    FunnelFilterHelper.populateFilters(fw, 
                                                       label1, label2, label3,
                                                       selectedLevel1, selectedLevel2, selectedLevel3);
                    
                    
                    
                    fw.labelFour = 'Filter By Representative';
                    fw.levelFour = FunnelFilterHelper.populateLevelFour(fw,'');
                    system.debug('in constructor :: '+fw.levelFour);
                
                    if(selectedLevel4 != null && selectedLevel4 != '' && selectedLevel4 != 'ALL'){
                        fw.SelectedLevelFour  = selectedLevel4;
                    }
                    /*filters*/
                    
                    
                    /*if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo == 'All'){
                        fw.SelectedLevelFour = 'All' ;
                    }*/
                    if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All' && fw.selectedLevelTwo != null && fw.selectedLevelTwo != '' && fw.selectedLevelTwo != 'null'){
                        fw.selectedLevelTwo = 'All';
                        fw.disableLevelThree = false;
                    }
                    
                    username = UserInfo.getUserId();
                    
                    system.debug('readaccess before showupdate :: '+readAccess);
                    showUpdated();
                    
                    
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
    
    
    
    //This method Create the data for the role average Calculator depends on the representative selected
    
    
    //This method Create the data for the Calculator for funnel calculation based on three condition
    
    public void Data(string sm,string sp){
        
        
        
        if(readAccess){
            list<Sales_Rep_Profile__c> srpresult = new list<Sales_Rep_Profile__c>();
            list<Sales_Rep_Profile__c> srpTeamresult = new list<Sales_Rep_Profile__c>();
            
            
            integer recordCount = 0;
            
            
            
            if((sm != '' && sp != '' && sm != null && sp != null) && (sp != sm)){
                system.debug('inside Condition 2 ');
                system.debug('sp:: '+sp+' sm :: '+sm);
                srpresult =[Select id,Profile_Type__c,name,Annual_Quota_Amount__c,YTD_Quota__c,Sales_Manager__c,YTD_Revenue__c,YTD_Average_Sales_Cycle__c,X12_Month_Rolling_Opptys_Won__c,YTD_Opportunity_Close_Rate__c,X12_Month_QO_added__c,YTD_Lead_Conversion_rate__c,YTD_Average_win_size__c,User_Record_Name__c,X12_Month_Leads_Added__c,Goal_12m_Avg_Selling_Price__c,Goal_12m_Lead_To_Opp_Conv_Rate__c,Goal_12m_length_of_sales_cycle__c,Goal_12m_rolling_close_rate__c,Goal_YTD_Opportunities_Added__c,
                            Goal_of_YTD_meetings__c,Number_of_meetings_YTD__c,Goal_of_YTD_leads_to_achieve_quota__c,Monthly_QO_added__c, Quarterly_QO_added__c, Ytd_QO_added__c, Monthly_Lead_Added__c, Quarterly_Lead_Added__c,YTD_Leads_Added__c,Monthly_Quota_Revenue__c,Quarterly_Quota_Revenue__c,Current_Active_Opportunities__c,Current_Pipeline__c,YTD_Opportunities_won__c,YTD_Close_Rate__c,Goal_12m_rolling_amt_close_rate__c,X12_Month_Average_Selling_Price__c,Goal_Average_Deal_Size__c,Average_Deal_Size__c   from Sales_Rep_Profile__c where id=:sp AND (Active__c = TRUE OR Annual_Quota_Amount__c > 0)];
                
                salesRepName = srpresult[0].name;
                Boolean overlayRep = false;
                if(srpresult[0].Profile_Type__c != null && srpresult[0].Profile_Type__c == 'Overlay'){
                    overlayRep = true;
                    RepOverlay =true;
                }
                integer count = 0;
                
                
                if(srpresult != null && srpresult.size()>0){
                    
                    if(srpresult[0].YTD_Revenue__c != null) 
                        YTDQuotaPerformance = (Decimal)srpresult[0].YTD_Revenue__c;
                    
                    if(srpresult[0].YTD_Quota__c != null) 
                        YTDQuotaPerformanceGoal = (Decimal)srpresult[0].YTD_Quota__c ;
                    
                    if(srpresult[0].YTD_Leads_Added__c != null) 
                        YTDLeadsAdded = (Decimal)srpresult[0].YTD_Leads_Added__c  ;
                    
                    if(srpresult[0].Goal_of_YTD_leads_to_achieve_quota__c != null) 
                        YTDLeadsAddedGoal = (Decimal)srpresult[0].Goal_of_YTD_leads_to_achieve_quota__c  ;
                    
                    if(srpresult[0].YTD_Lead_Conversion_rate__c != null) 
                        X12MonthRollingLeadConversion = (Decimal)srpresult[0].YTD_Lead_Conversion_rate__c;
                    
                    if(srpresult[0].Goal_12m_Lead_To_Opp_Conv_Rate__c != null) 
                        X12MonthRollingLeadConversionGoal = (Decimal)srpresult[0].Goal_12m_Lead_To_Opp_Conv_Rate__c;
                    
                    if(srpresult[0].Number_of_meetings_YTD__c != null) 
                        YTDNumberofMeetings = (Decimal)srpresult[0].Number_of_meetings_YTD__c;
                    
                    if(srpresult[0].Goal_of_YTD_meetings__c != null) 
                        YTDNumberofMeetingsGoal = (Decimal)srpresult[0].Goal_of_YTD_meetings__c ;
                    
                    if(srpresult[0].Ytd_QO_added__c != null) 
                        YTDOpportunitiesAddedtoQualifiedFunnel  =  (Decimal)srpresult[0].Ytd_QO_added__c;
                    
                    if(srpresult[0].Goal_YTD_Opportunities_Added__c  != null) 
                        YTDOpportunitiesAddedtoQualifiedFunnelGoal  =  (Decimal)srpresult[0].Goal_YTD_Opportunities_Added__c ;
                    
                    if(srpresult[0].YTD_Opportunity_Close_Rate__c != null) 
                        X12MonthRollingCloseRatebasedonOpportunities  =  (Decimal)srpresult[0].YTD_Opportunity_Close_Rate__c;
                    
                    if(srpresult[0].Goal_12m_rolling_close_rate__c != null) 
                        X12MonthRollingCloseRatebasedonOpportunitiesGoal  =  (Decimal)srpresult[0].Goal_12m_rolling_close_rate__c;
                    
                    if(srpresult[0].YTD_Close_Rate__c != null) 
                        X12MonthRollingCloseRatebasedondollar  =  (Decimal)srpresult[0].YTD_Close_Rate__c;
                    
                    if(srpresult[0].Goal_12m_rolling_amt_close_rate__c != null) 
                        X12MonthRollingCloseRatebasedondollarGoal  =  (Decimal)srpresult[0].Goal_12m_rolling_amt_close_rate__c;
                    
                    if(srpresult[0].YTD_Average_win_size__c != null) 
                        X12MonthRollingAveragedollarWinSize  =  (Decimal)srpresult[0].YTD_Average_win_size__c;
                    
                    if(srpresult[0].Goal_12m_Avg_Selling_Price__c != null) 
                        X12MonthRollingAveragedollarWinSizeGoal  =  (Decimal)srpresult[0].Goal_12m_Avg_Selling_Price__c;
                    
                    if(srpresult[0].YTD_Average_Sales_Cycle__c!= null) 
                        X12MonthRollingLengthofSalesCycle  =  (Decimal)srpresult[0].YTD_Average_Sales_Cycle__c;
                    
                    if(srpresult[0].Goal_12m_length_of_sales_cycle__c!= null) 
                        X12MonthRollingLengthofSalesCycleGoal  =  (Decimal)srpresult[0].Goal_12m_length_of_sales_cycle__c;
                    
                    if(srpresult[0].Average_Deal_Size__c!= null) 
                        X12AverageDealSize  =  (Decimal)srpresult[0].Average_Deal_Size__c;
                    
                    if(srpresult[0].Goal_Average_Deal_Size__c!= null) 
                        X12AverageDealSizeGoal  =  (Decimal)srpresult[0].Goal_Average_Deal_Size__c;
                    
                    //Score card
                    
                    if(srpresult[0].Current_Pipeline__c != null) 
                        curentPipeline  = convert(convertsub( (Decimal)srpresult[0].Current_Pipeline__c,''),'$');
                    
                    if(srpresult[0].Current_Active_Opportunities__c != null) 
                        activeopp  = convert(convertsub( (Decimal)srpresult[0].Current_Active_Opportunities__c,''),'');
                    
                    if(srpresult[0].YTD_Opportunities_won__c != null) 
                        ytdWin  = convert(convertsub( (Decimal)srpresult[0].YTD_Opportunities_won__c,''),'');
                    
                    if(srpresult[0].X12_Month_Average_Selling_Price__c!= null && srpresult[0].X12_Month_Average_Selling_Price__c > 0 && srpresult[0].Annual_Quota_Amount__c != null  && srpresult[0].YTD_Revenue__c != null){
                        Decimal win = ((Decimal)srpresult[0].Annual_Quota_Amount__c - (Decimal)srpresult[0].YTD_Revenue__c)/(Decimal)srpresult[0].X12_Month_Average_Selling_Price__c;
                        winNeedToMakeQuota = convert(convertsub( win,''),'');
                        
                    }
                    
                }
                
                
                
                
                srpTeamresult.clear();
                srpresult.clear();
                if(overlayRep ){
                    srpresult =[Select id, name from Sales_Rep_Profile__c where Sales_Manager__c=:sm AND id != :sp AND Profile_Type__c = 'Overlay'];
                }else{
                    srpresult =[Select id, name from Sales_Rep_Profile__c where Sales_Manager__c=:sm AND id != :sp AND Profile_Type__c != 'Overlay'];
                }
                
                recordCount = srpresult.size() ;
                Set<id> sid = new set<id>();
                
                for(Sales_Rep_Profile__c s: srpresult){
                    sid.add(s.id);
                }
                System.debug('dcheck2'+sid);
                List<AggregateResult> ar2 = new List<AggregateResult>();
                if(overlayRep){
                    ar2 = [Select SUM(YTD_Revenue__c) y, Sum(Annual_Quota_Amount__c) a, AVG(YTD_Average_win_size__c) sp,AVG(Average_Deal_Size__c) ads,  
                           AVG(YTD_Lead_Conversion_rate__c) lc, AVG(YTD_Average_Sales_Cycle__c) sc, AVG(YTD_Opportunity_Close_Rate__c) wp,
                           SUM(X12_Month_QO_added__c) opaf, SUM(X12_Month_Leads_Added__c) laf,
                           AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,SUM(Monthly_Quota_Revenue__c) mr, SUM(Quarterly_Quota_Revenue__c) qr,
                           SUM(Monthly_QO_added__c) moa, SUM(Quarterly_QO_added__c)qoa, SUM(Ytd_QO_added__c) yoa, SUM(Monthly_Lead_Added__c) mla, SUM(Quarterly_Lead_Added__c) qla,SUM(YTD_Leads_Added__c) yla, SUM(Number_of_meetings_YTD__c) nmtyd, AVG (YTD_Close_Rate__c) acr
                           from Sales_Rep_Profile__c where id IN :sid AND Annual_Quota_Amount__c > 0 AND Profile_Type__c = 'Overlay'];
                }else{
                    ar2 = [Select SUM(YTD_Revenue__c) y, Sum(Annual_Quota_Amount__c) a, AVG(YTD_Average_win_size__c) sp,AVG(Average_Deal_Size__c) ads,  
                           AVG(YTD_Lead_Conversion_rate__c) lc, AVG(YTD_Average_Sales_Cycle__c) sc, AVG(YTD_Opportunity_Close_Rate__c) wp,
                           SUM(X12_Month_QO_added__c) opaf, SUM(X12_Month_Leads_Added__c) laf,
                           AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,SUM(Monthly_Quota_Revenue__c) mr, SUM(Quarterly_Quota_Revenue__c) qr,
                           SUM(Monthly_QO_added__c) moa, SUM(Quarterly_QO_added__c)qoa, SUM(Ytd_QO_added__c) yoa, SUM(Monthly_Lead_Added__c) mla, SUM(Quarterly_Lead_Added__c) qla,SUM(YTD_Leads_Added__c) yla, SUM(Number_of_meetings_YTD__c) nmtyd, AVG (YTD_Close_Rate__c) acr
                           from Sales_Rep_Profile__c where id IN :sid AND Annual_Quota_Amount__c > 0 AND Profile_Type__c != 'Overlay'];
                }
                if(ar2 != null && ar2.size()>0){
                    
                    if(ar2[0].get('y') != null) 
                        YTDQuotaPerformanceTeam = (Decimal)(ar2[0].get('y'))/(recordCount);
                    
                    if(ar2[0].get('yla') != null) 
                        YTDLeadsAddedTeam  = (Decimal)(ar2[0].get('yla'))/(recordCount);
                    
                    if(ar2[0].get('lc') != null) 
                        X12MonthRollingLeadConversionTeam = (Decimal)(ar2[0].get('lc'));
                    
                    if(ar2[0].get('nmtyd') != null) 
                        YTDNumberofMeetingsTeam = (Decimal)(ar2[0].get('nmtyd'))/(recordCount);
                    
                    if(ar2[0].get('yoa') != null ) 
                        YTDOpportunitiesAddedtoQualifiedFunnelTeam = (Decimal)(ar2[0].get('yoa'))/(recordCount);
                    
                    System.debug('dcheckteam'+YTDOpportunitiesAddedtoQualifiedFunnelTeam);
                    
                    if(ar2[0].get('wp') != null) 
                        X12MonthRollingCloseRatebasedonOpportunitiesTeam = (Decimal)(ar2[0].get('wp'));
                    
                    if(ar2[0].get('acr') != null) 
                        X12MonthRollingCloseRatebasedondollarTeam = (Decimal)(ar2[0].get('acr'));
                    
                    if(ar2[0].get('sp') != null) 
                        X12MonthRollingAveragedollarWinSizeTeam =  (Decimal)(ar2[0].get('sp'));
                    
                    if(ar2[0].get('sc') != null) 
                        X12MonthRollingLengthofSalesCycleTeam  = (Decimal)(ar2[0].get('sc'));
                    
                    if(ar2[0].get('ads') != null) 
                        X12AverageDealSizeTeam  = (Decimal)(ar2[0].get('ads'));                 
                    
                }
                
                
                
            }        
            
            
            
            /* Condition 3 : salesManger != '' and Sp= all
Result = salesManger and everyone under salesManger 
TeamResult = Everyone under Manager of salesManger 
*/
            
            if(sm != '' && sp == '' ){
                String Mngid;
                String Spid;
                
                //Fetch the company level record associated with the particular level
                List<Company_Level__c> cl = [SELECT id,Certification__r.Overall_Qualitative_Rating__c,Sales_Rep_Profile__c,Sales_Rep_Profile__r.Role__c ,Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Sales_Manager__c FROM Company_Level__c WHERE Level_Value__c = :fw.SelectedLevelOne];
                Mngid = cl[0].Sales_Rep_Profile__r.Sales_Manager__c;
                Spid = cl[0].Sales_Rep_Profile__c;
                
                displayWrapper.name = cl[0].Sales_Rep_Profile__r.name;
                displayWrapper.Role= cl[0].Sales_Rep_Profile__r.Role__c;
                set<id> spidset = new set<id>();
                spidset.add(Spid);
                
                displayWrapper.score = FunnelCalculationHelper.findAggregateScore(spidset );
                
                if(cl != null && cl.size()>0 && cl[0].Certification__r.Overall_Qualitative_Rating__c != null)
                    displayWrapper.scoreQual = Decimal.valueOf(FunnelCalculationHelper.convert(cl[0].Certification__r.Overall_Qualitative_Rating__c,'score'));
                
                List<Sales_Profile_Company_Level_Junction__c> spCLJun = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne];
                
                Set<Id> sr = new Set<Id>();
                
                for(Sales_Profile_Company_Level_Junction__c sj: spCLJun){
                    sr.add(sj.Sales_Rep_Profile__c);
                    system.debug('sj----->'+sj.Sales_Rep_Profile__r.name);
                }
                system.debug('fw.levelFour :: '+fw.levelFour );
                
                //CustomMetric code
                displayCustomMetric('Team',sr);
                
                integer count = 0;
                //Aggregate the results
                List<AggregateResult> ar = [Select SUM(YTD_Revenue__c) y, SUM(Annual_Quota_Amount__c) a, AVG(YTD_Average_win_size__c) sp,AVG(X12_Month_Average_Selling_Price__c) sp12, SUM(YTD_Quota__c) ytdq , SUM(Goal_of_YTD_leads_to_achieve_quota__c) gYtdL,
                                            AVG(YTD_Lead_Conversion_rate__c) lc, AVG(YTD_Average_Sales_Cycle__c) sc, AVG(YTD_Opportunity_Close_Rate__c) wp,
                                            SUM(X12_Month_QO_added__c) opaf, SUM(X12_Month_Leads_Added__c) laf,
                                            AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,SUM(Monthly_Quota_Revenue__c) mr, SUM(Quarterly_Quota_Revenue__c) qr,
                                            SUM(Monthly_QO_added__c) moa, SUM(Quarterly_QO_added__c)qoa, SUM(Ytd_QO_added__c) yoa, SUM(Monthly_Lead_Added__c) mla, SUM(Quarterly_Lead_Added__c) qla,SUM(YTD_Leads_Added__c) yla,
                                            SUM(Current_Active_Opportunities__c) ca, SUM(Current_Pipeline__c) cp, SUM(YTD_Opportunities_won__c) yw ,AVG(YTD_Close_Rate__c) acr , AVG(Goal_12m_rolling_amt_close_rate__c) gacr,
                                            SUM(Number_of_meetings_YTD__c) nmytd , SUM(Goal_of_YTD_meetings__c) gytdM , SUM(Goal_YTD_Opportunities_Added__c) gYtdOA , AVG(Average_Deal_Size__c) ads, AVG(Goal_Average_Deal_Size__c) gads
                                            from Sales_Rep_Profile__c where id IN :sr AND Annual_Quota_Amount__c > 0  AND Profile_Type__c != 'Overlay'];
                
                //Populate the wrapper
                if(ar != null && ar.size() > 0){                            
                    
                    if(ar[0].get('y') != null)
                        YTDQuotaPerformance = (Decimal)(ar[0].get('y'));
                    
                    if(ar[0].get('ytdq') != null)
                        YTDQuotaPerformanceGoal = (Decimal)(ar[0].get('ytdq'));
                    
                    if(ar[0].get('yla') != null)    
                        YTDLeadsAdded = (Decimal)(ar[0].get('yla'));
                    
                    if(ar[0].get('gYtdL') != null)                
                        YTDLeadsAddedGoal  = (Decimal)(ar[0].get('gYtdL'));  
                    
                    if(ar[0].get('lc') != null)
                        X12MonthRollingLeadConversion = (Decimal)(ar[0].get('lc'));  
                    
                    if(ar[0].get('lcg') != null)                
                        X12MonthRollingLeadConversionGoal = (Decimal)(ar[0].get('lcg')); 
                    
                    if(ar[0].get('nmytd') != null)                
                        YTDNumberofMeetings = (Decimal)(ar[0].get('nmytd'));
                    
                    if(ar[0].get('gytdM') != null)
                        YTDNumberofMeetingsGoal = (Decimal)(ar[0].get('gytdM'));
                    
                    if(ar[0].get('yoa') != null)
                        YTDOpportunitiesAddedtoQualifiedFunnel  = (Decimal)(ar[0].get('yoa')); 
                    
                    if(ar[0].get('gYtdOA') != null)
                        YTDOpportunitiesAddedtoQualifiedFunnelGoal = (Decimal)(ar[0].get('gYtdOA'));
                    
                    if(ar[0].get('wp') != null)
                        X12MonthRollingCloseRatebasedonOpportunities = (Decimal)(ar[0].get('wp')); 
                    
                    if(ar[0].get('wpg') != null)
                        X12MonthRollingCloseRatebasedonOpportunitiesGoal =  (Decimal)(ar[0].get('wpg')); 
                    
                    if(ar[0].get('acr') != null)
                        X12MonthRollingCloseRatebasedondollar =  (Decimal)(ar[0].get('acr'));  
                    
                    if(ar[0].get('gacr') != null)
                        X12MonthRollingCloseRatebasedondollarGoal =  (Decimal)(ar[0].get('gacr')); 
                    
                    if(ar[0].get('sp') != null) 
                        X12MonthRollingAveragedollarWinSize = (Decimal)(ar[0].get('sp')); 
                    
                    if(ar[0].get('spg') != null) 
                        X12MonthRollingAveragedollarWinSizeGoal = (Decimal)(ar[0].get('spg'));  
                    
                    if(ar[0].get('sc') != null)
                        X12MonthRollingLengthofSalesCycle =  (Decimal)(ar[0].get('sc')); 
                    
                    if(ar[0].get('scg') != null)
                        X12MonthRollingLengthofSalesCycleGoal =  (Decimal)(ar[0].get('scg')); 
                    
                    if(ar[0].get('ads') != null)
                        X12AverageDealSize =  (Decimal)(ar[0].get('ads')); 
                    
                    if(ar[0].get('gads') != null)
                        X12AverageDealSizeGoal =  (Decimal)(ar[0].get('gads')); 
                    
                    //Score card
                    
                    if(ar[0].get('cp') != null) 
                        curentPipeline  = convert(convertsub( (Decimal)ar[0].get('cp'),''),'$');
                    
                    if(ar[0].get('ca') != null) 
                        activeopp  = convert(convertsub( (Decimal)ar[0].get('ca'),''),'');
                    
                    if(ar[0].get('yw') != null) 
                        ytdWin  = convert(convertsub( (Decimal)ar[0].get('yw'),''),'');
                    
                    if(ar[0].get('sp12') != null && (Decimal)ar[0].get('sp12') > 0 && ar[0].get('y') != null  && ar[0].get('a') != null){
                        Decimal win = ((Decimal)ar[0].get('a') - (Decimal)ar[0].get('y'))/(Decimal)ar[0].get('sp12');
                        winNeedToMakeQuota = convert(convertsub( win,''),'');
                        
                    } 
                    
                    
                    
                }    
                
                
                Set<ID> aggregateIds = new Set<Id>();
                
                if(Mngid != null){
                    List<Sales_Rep_Profile__c> srps = [select id from Sales_Rep_Profile__c where Sales_Manager__c = :Mngid AND id != :Spid];
                    count= srps.size();
                    Set<String> levels = new Set<String>();
                    Set<Id> spids = new set<Id>();
                    spids = (new map<id,Sales_Rep_Profile__c>(srps)).keyset();
                    
                    List<Company_Level__c> c2 = [SELECT id, Level_Value__c FROM Company_Level__c WHERE Sales_Rep_Profile__c IN :spids];
                    
                    for(Company_Level__c c: c2){
                        levels.add(c.Level_Value__c);
                    }
                    List<Sales_Profile_Company_Level_Junction__c> sReps2 = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels  ];  
                    
                    
                    
                    
                    //Store the profile ids of the managers
                    for(Sales_Profile_Company_Level_Junction__c s: sReps2){
                        
                        aggregateIds.add(s.Sales_Rep_Profile__c);
                    }
                    
                    system.debug('Team aggregateIds'+aggregateIds);
                    
                    
                    
                    
                    
                    List<AggregateResult> ar2 = [Select SUM(YTD_Revenue__c) y, Sum(Annual_Quota_Amount__c) a, AVG(YTD_Average_win_size__c) sp,  
                                                 AVG(YTD_Lead_Conversion_rate__c) lc, AVG(YTD_Average_Sales_Cycle__c) sc, AVG(YTD_Opportunity_Close_Rate__c) wp,
                                                 SUM(X12_Month_QO_added__c) opaf, SUM(X12_Month_Leads_Added__c) laf,
                                                 AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,SUM(Monthly_Quota_Revenue__c) mr, SUM(Quarterly_Quota_Revenue__c) qr,
                                                 SUM(Monthly_QO_added__c) moa, SUM(Quarterly_QO_added__c)qoa, SUM(Ytd_QO_added__c) yoa, SUM(Monthly_Lead_Added__c) mla, SUM(Quarterly_Lead_Added__c) qla,SUM(YTD_Leads_Added__c) yla,
                                                 SUM(Number_of_meetings_YTD__c) nmytd, AVG(YTD_Close_Rate__c) acr, AVG(Average_Deal_Size__c) ads
                                                 from Sales_Rep_Profile__c where id IN :aggregateIds AND Annual_Quota_Amount__c > 0 AND Profile_Type__c != 'Overlay'];
                    
                    
                    if(ar2 != null && ar2.size() > 0){  
                        
                        
                        if(ar2[0].get('y') != null)
                            YTDQuotaPerformanceTeam = (Decimal)(ar2[0].get('y'))/count;
                        
                        if(ar2[0].get('yla') != null)
                            YTDLeadsAddedTeam = (Decimal)(ar2[0].get('yla'))/count;  
                        
                        if(ar2[0].get('lc') != null)                
                            X12MonthRollingLeadConversionTeam  = (Decimal)(ar2[0].get('lc')); 
                        
                        if(ar2[0].get('nmytd') != null)                
                            YTDNumberofMeetingsTeam  = (Decimal)(ar2[0].get('nmytd'))/count;   
                        
                        if(ar2[0].get('yoa') != null)
                            YTDOpportunitiesAddedtoQualifiedFunnelTeam = (Decimal)(ar2[0].get('yoa'))/count; 
                        
                        if(ar2[0].get('wp') != null)                
                            X12MonthRollingCloseRatebasedonOpportunitiesTeam = (Decimal)(ar2[0].get('wp')); 
                        
                        if(ar2[0].get('acr') != null)                
                            X12MonthRollingCloseRatebasedondollarTeam = (Decimal)(ar2[0].get('acr'));  
                        
                        if(ar2[0].get('sp') != null)    
                            X12MonthRollingAveragedollarWinSizeTeam = (Decimal)(ar2[0].get('sp')); 
                        
                        if(ar2[0].get('sc') != null)
                            X12MonthRollingLengthofSalesCycleTeam = (Decimal)(ar2[0].get('sc')); 
                        
                        if(ar2[0].get('ads') != null)
                            X12AverageDealSizeTeam = (Decimal)(ar2[0].get('ads')); 
                        
                        
                        
                        
                        
                        
                    }    
                    
                    
                }
                
                
                
                
            }
            
            
            
        }
    }
    
    // This method calculate the values that are displayed on page.
    
    
    
    //This method will Roundup the big number and will add bracket , $ and %
    
    
    
    
    
    /*Filters*/
    //Method called when reset button is selected
    public PageReference reset(){
        
        
        return FunnelNavigationHelper.navigateToCalculator('','','','','',''); 
        
    }
    /*Filters*/ 
    
    public void showUpdated(){
        try{
            system.debug('inside show update');
            fw.labelFour = 'Filter By Representative';
            RoleOverlay = false; 
            RepOverlay =false;
            curentPipeline =  '';
            ytdWin ='' ;
            winNeedToMakeQuota ='';
            activeopp = '';
            
            //added by shaik Amanulla (added role variables everywhere)
            
            YTDQuotaPerformance  = 0;
            YTDQuotaPerformanceTeam  = 0;
            YTDQuotaPerformanceGoal  = 0;
            YTDQuotaPerformanceRole  = 0;
            
            YTDLeadsAdded  = 0;
            YTDLeadsAddedTeam  = 0;
            YTDLeadsAddedGoal  = 0;
            YTDLeadsAddedRole  = 0;
            
            X12MonthRollingLeadConversion  = 0; 
            X12MonthRollingLeadConversionTeam  = 0;
            X12MonthRollingLeadConversionGoal  = 0;
            X12MonthRollingLeadConversionRole  = 0;
            
            
            YTDNumberofMeetings  = 0;
            YTDNumberofMeetingsTeam  = 0;
            YTDNumberofMeetingsGoal  = 0;
            YTDNumberofMeetingsRole  = 0;
            
            YTDOpportunitiesAddedtoQualifiedFunnel  = 0;
            YTDOpportunitiesAddedtoQualifiedFunnelTeam  = 0;
            YTDOpportunitiesAddedtoQualifiedFunnelGoal  = 0;
            YTDOpportunitiesAddedtoQualifiedFunnelRole  = 0;
            
            X12MonthRollingCloseRatebasedonOpportunities  = 0;
            X12MonthRollingCloseRatebasedonOpportunitiesTeam  = 0;
            X12MonthRollingCloseRatebasedonOpportunitiesGoal  = 0;
            X12MonthRollingCloseRatebasedonOpportunitiesRole  = 0;
            
            X12MonthRollingCloseRatebasedondollar  = 0;
            X12MonthRollingCloseRatebasedondollarTeam  = 0;
            X12MonthRollingCloseRatebasedondollarGoal  = 0;
            X12MonthRollingCloseRatebasedondollarRole  = 0;
            
            X12MonthRollingAveragedollarWinSize  = 0;
            X12MonthRollingAveragedollarWinSizeTeam  = 0;
            X12MonthRollingAveragedollarWinSizeGoal  = 0;
            X12MonthRollingAveragedollarWinSizeRole  = 0;
            
            X12MonthRollingLengthofSalesCycle  = 0;
            X12MonthRollingLengthofSalesCycleTeam  = 0;
            X12MonthRollingLengthofSalesCycleGoal  = 0;
            X12MonthRollingLengthofSalesCycleRole  = 0;
            
            X12AverageDealSize = 0;
            X12AverageDealSizeTeam = 0;
            X12AverageDealSizeGoal = 0;
            X12AverageDealSizeRole = 0;
            
            metricRowMap = new Map<String, tableWrapper>(); 
            metricRowMapQual = new Map<String, tableWrapper>();      
            system.debug('fw.selectedLevelThree :: '+fw.selectedLevelThree);
            system.debug('fw.selectedLevelFour :: '+fw.selectedLevelFour);
            if(readAccess){
                //Aggregates of a particular level value need to be done
                if(fw.selectedLevelThree == 'All' && fw.selectedLevelFour == 'All'){
                    //Fetch the sales profile record associated with that level
                    List<Company_Level__c> cl = [SELECT Sales_Rep_Profile__c FROM Company_Level__c WHERE Level_Value__c = : fw.selectedLevelOne LIMIT 1];
                    displayWrapper = new FunnelSalesProfileWrapper();
                    data(cl[0].Sales_Rep_Profile__c,'');
                    mgr = true;
                }
                //A particular rep has been selected and his values need to be displayed
                else if((fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All') || (fw.selectedLevelFour!='All' && fw.selectedLevelFour != null && fw.selectedLevelFour!='')){
                    
                    
                    List<Company_Level__c> cl = [SELECT Sales_Rep_Profile__c,Sales_Rep_Profile__r.Sales_Manager__c FROM Company_Level__c WHERE Level_Value__c = : fw.selectedLevelOne LIMIT 1];
                    System.debug('check3'+fw.selectedLevelOne);
                    System.debug('check4'+cl);
                    if(fw.selectedLevelFour != 'All' && fw.selectedLevelFour != ''){
                        if(cl[0].Sales_Rep_Profile__c == fw.selectedLevelFour){
                            data(cl[0].Sales_Rep_Profile__r.Sales_Manager__c,fw.selectedLevelFour);
                        }else{
                        	data(cl[0].Sales_Rep_Profile__c,fw.selectedLevelFour);
                        }
                        //added by shaik Amanulla
                        roleData();
                    }else{
                        data(cl[0].Sales_Rep_Profile__c,fw.selectedLevelTwo);
                        //added by shaik Amanulla
                        roleData();
                    }
                    
                    mgr = false; 
                    
                    
                    displayWrapper = new FunnelSalesProfileWrapper();
                    fetchPerfScores(); 
                    Sales_rep_profile__c sr;
                    system.debug('fw.selectedLevelFour :' +fw.selectedLevelFour + 'fw.selectedLevelTwo :: '+fw.selectedLevelTwo);
                    if(fw.selectedLevelFour != 'All' && fw.selectedLevelFour != '' && fw.selectedLevelFour!=null){
                        sr = [SELECT id, name,Role__c FROM Sales_rep_profile__c WHERE id = :fw.selectedLevelFour];
                    }else{
                        sr = [SELECT id, name,Role__c FROM Sales_rep_profile__c WHERE id = :fw.selectedLevelTwo];
                    }
                    if(sr.Role__c != null){
                        roleVal = sr.Role__c;
                        sname =sr.name;
                        displayWrapper.Name = sr.name;
                        displayWrapper.id= sr.id;
                        displayWrapper.Role= sr.Role__c;
                        Set<Id> aggregateIds = new Set<Id>();
                        aggregateIds.add(sr.id);
                        if(aggregateIds != null && aggregateIds.size() >0  )
                            displayWrapper.score = FunnelCalculationHelper.findAggregateScore(aggregateIds);
                        
                        List<AggregateResult> r = [SELECT AVG(Overall_Rating__c) avor, AVG(Overall_Qualitative_Rating__c) avoq FROM Certification__c WHERE Sales_Rep_Profile__c IN :aggregateIds AND (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_Quota_Amount__c > 0)] ;
                        
                        if(r != null && r.size() > 0){   
                            if(r[0].get('avoq') != null){
                                displayWrapper.scoreQual = Decimal.valueOf(FunnelCalculationHelper.convert((Decimal)r[0].get('avoq'),'score'));
                            }
                        } 
                        
                        fetchImpMetrics(); 
                        
                        //CustomMetric code
                        Set<id> sid = new Set<id>();
                        sid.add(sr.id); 
                        displayCustomMetric('Rep',sid); 
                    }             
                }
                //A particular role has been selected 
                else if (fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
                    system.debug('role aggregates');
                    mgr = true;
                    
                    displayWrapper = new FunnelSalesProfileWrapper();
                    displayWrapper.Name = fw.selectedLevelone;
                    displayWrapper.Role= fw.selectedLevelThree;
                    
                    aggregateOnRole();
                    roleData();
                    fetchPerfScores();
                    fetchPerformerSet('role',fw.selectedLevelThree);
                    sname = fw.SelectedLevelOne;
                    fetchImpMetrics();  
                    
                }
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelScorecard '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        } 
    }
    
    //added by shaik Amanulla (method to calclate the role averages)
    public void roleData(){
             if(readAccess){
            
            String Mngid;
            String Spid;
            
            string companyValue;
            string roleValue;
            if(fw.selectedLevelFour!='All' && fw.selectedLevelFour != null && fw.selectedLevelFour!='')
            {
            List<Sales_rep_profile__c> levelCompany =[SELECT id, name,Role__c,FunnelMetrics__Level_picklist_1__c FROM Sales_Rep_Profile__c where id=:fw.selectedLevelFour LIMIT 1];
                    
            companyValue=levelCompany[0].FunnelMetrics__Level_picklist_1__c;
            roleValue= levelCompany[0].Role__c; 
                System.debug('hello'+companyValue+roleValue);
            }
            else if(fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
            List<Company_Level__c> compLevel = [SELECT id,Sales_Rep_Profile__c,Sales_Rep_Profile__r.FunnelMetrics__Level_picklist_1__c, Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Sales_Manager__c FROM Company_Level__c WHERE Level_Value__c = :fw.SelectedLevelOne LIMIT 1];
            companyValue=compLevel[0].Sales_Rep_Profile__r.FunnelMetrics__Level_picklist_1__c;
            roleValue=fw.SelectedLevelThree;
                System.debug('hellyeah'+companyValue+roleValue);
            }
            //Fetch the company level record associated with the particular level
            List<Company_Level__c> cl = [SELECT id,Sales_Rep_Profile__c, Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Sales_Manager__c FROM Company_Level__c WHERE Level_Value__c = :companyValue];
            Mngid = cl[0].Sales_Rep_Profile__r.Sales_Manager__c;
            Spid = cl[0].Sales_Rep_Profile__c;
            
            
            //Fetch the records at the selected level and role
            List<Sales_Profile_Company_Level_Junction__c> sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Profile_Type__c, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :companyValue AND Sales_Rep_Profile__r.Role__c = :roleValue];                
            
            Set<String> levels = new Set<String>();
            
            //List to store the ids of the reps to be aggregated
            Set<ID> aggregateIds = new Set<Id>();
            
            Set<ID> profIds = new Set<Id>();
            
            Boolean isOverlay = true;
            //Store the profile ids of the managers
            for(Sales_Profile_Company_Level_Junction__c s: sReps){
                profIds.add(s.Sales_Rep_Profile__c);
                aggregateIds.add(s.Sales_Rep_Profile__c);
                if(s.Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' ){
                    isOverlay = false;
                }
            }
            
            
            List<AggregateResult> r = [SELECT AVG(Overall_Rating__c) avor, AVG(Overall_Qualitative_Rating__c) avoq FROM Certification__c WHERE Sales_Rep_Profile__c IN :aggregateIds AND (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_Quota_Amount__c > 0)] ;
            
            displayWrapper.score = FunnelCalculationHelper.findAggregateScore(profIds);
            
            if(r != null && r.size() > 0){   
                if(r[0].get('avoq') != null){
                    displayWrapper.scoreQual = Decimal.valueOf(FunnelCalculationHelper.convert((Decimal)r[0].get('avoq'),'score'));
                }
            }
            //Fetch the company levels associated with the sales profiles
            cl = [SELECT id, Level_Value__c FROM Company_Level__c WHERE Sales_Rep_Profile__c IN :profIds];
            
            levels.clear();
            
            //Store all the levels associated with the managers
            for(Company_Level__c c: cl){
                levels.add(c.Level_Value__c);
            }
            
            //Fetch the sales profiles associated with the levels
            sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Profile_Type__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels];
            
            system.debug(' aggregateIds '+aggregateIds);        
            //Add the sales profiles to the ids to be aggregated 
            Set<Id> srpid = new Set<Id>();
            for(Sales_Profile_Company_Level_Junction__c s: sReps){
                aggregateIds.add(s.Sales_Rep_Profile__c);
                if(s.Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' ){
                    isOverlay = false;
                }
            }
            System.debug('aggregateIds'+aggregateIds) ;    
            
            RoleOverlay = isOverlay ;
            srpid.addAll(aggregateIds);
            
            
            //CustomMetric code
            displayCustomMetric('Role',aggregateIds);
            
            
            
            //Aggregate the results
                List<AggregateResult> ar2 = new List<AggregateResult>();
                
                if(RoleOverlay){
                    ar2 = [Select AVG(YTD_Revenue__c) y, AVG(Annual_Quota_Amount__c) a, AVG(YTD_Average_win_size__c) sp,  
                           AVG(YTD_Lead_Conversion_rate__c) lc, AVG(YTD_Average_Sales_Cycle__c) sc, AVG(YTD_Opportunity_Close_Rate__c) wp,
                           AVG(X12_Month_QO_added__c) opaf, AVG(X12_Month_Leads_Added__c) laf,
                           AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,AVG(Monthly_Quota_Revenue__c) mr, AVG(Quarterly_Quota_Revenue__c) qr,
                           AVG(Monthly_QO_added__c) moa, AVG(Quarterly_QO_added__c)qoa, AVG(Ytd_QO_added__c) yoa, AVG(Monthly_Lead_Added__c) mla, AVG(Quarterly_Lead_Added__c) qla,AVG(YTD_Leads_Added__c) yla,
                           AVG(Number_of_meetings_YTD__c) nmytd , AVG(YTD_Close_Rate__c) acr, AVG(Average_Deal_Size__c) ads
                           from Sales_Rep_Profile__c where id IN :aggregateIds AND  Annual_Quota_Amount__c > 0 AND Profile_Type__c = 'Overlay'];
                }else{
                    ar2 = [Select AVG(YTD_Revenue__c) y, AVG(Annual_Quota_Amount__c) a, AVG(YTD_Average_win_size__c) sp,  
                           AVG(YTD_Lead_Conversion_rate__c) lc, AVG(YTD_Average_Sales_Cycle__c) sc, AVG(YTD_Opportunity_Close_Rate__c) wp,
                           AVG(X12_Month_QO_added__c) opaf, AVG(X12_Month_Leads_Added__c) laf,
                           AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,AVG(Monthly_Quota_Revenue__c) mr, AVG(Quarterly_Quota_Revenue__c) qr,
                           AVG(Monthly_QO_added__c) moa, AVG(Quarterly_QO_added__c)qoa, AVG(Ytd_QO_added__c) yoa, AVG(Monthly_Lead_Added__c) mla, AVG(Quarterly_Lead_Added__c) qla,AVG(YTD_Leads_Added__c) yla,
                           AVG(Number_of_meetings_YTD__c) nmytd , AVG(YTD_Close_Rate__c) acr, AVG(Average_Deal_Size__c) ads
                           from Sales_Rep_Profile__c where id IN :aggregateIds AND  Annual_Quota_Amount__c > 0 AND Profile_Type__c != 'Overlay'];
                }
                if(ar2 != null && ar2.size() > 0){                           

				    if(ar2[0].get('y') != null)
					YTDQuotaPerformanceRole = (Decimal)(ar2[0].get('y')) ;

					if(ar2[0].get('yla') != null)
					YTDLeadsAddedRole = (Decimal)(ar2[0].get('yla')) ;  

					if(ar2[0].get('lc') != null)                
					X12MonthRollingLeadConversionRole  = (Decimal)(ar2[0].get('lc')); 

					if(ar2[0].get('nmytd') != null)                
					YTDNumberofMeetingsRole  = (Decimal)(ar2[0].get('nmytd')) ;   

					if(ar2[0].get('yoa') != null)
					YTDOpportunitiesAddedtoQualifiedFunnelRole = (Decimal)(ar2[0].get('yoa')); 

					if(ar2[0].get('wp') != null)                
					X12MonthRollingCloseRatebasedonOpportunitiesRole = (Decimal)(ar2[0].get('wp')); 

					if(ar2[0].get('acr') != null)                
					X12MonthRollingCloseRatebasedondollarRole = (Decimal)(ar2[0].get('acr'));  

					if(ar2[0].get('sp') != null)    
					X12MonthRollingAveragedollarWinSizeRole = (Decimal)(ar2[0].get('sp')); 

					if(ar2[0].get('sc') != null)
					X12MonthRollingLengthofSalesCycleRole = (Decimal)(ar2[0].get('sc')); 

					if(ar2[0].get('ads') != null)
					X12AverageDealSizeRole = (Decimal)(ar2[0].get('ads'));           

}    
                
                  


                 
                 
        
    }
    }
    
    
    private void aggregateOnRole(){
        if(readAccess){
            
            String Mngid;
            String Spid;
            
            
            
            //Fetch the company level record associated with the particular level
            List<Company_Level__c> cl = [SELECT id,Sales_Rep_Profile__c, Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Sales_Manager__c FROM Company_Level__c WHERE Level_Value__c = :fw.SelectedLevelOne];
            Mngid = cl[0].Sales_Rep_Profile__r.Sales_Manager__c;
            Spid = cl[0].Sales_Rep_Profile__c;
            
            
            //Fetch the records at the selected level and role
            List<Sales_Profile_Company_Level_Junction__c> sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Profile_Type__c, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree];                
            
            Set<String> levels = new Set<String>();
            
            //List to store the ids of the reps to be aggregated
            Set<ID> aggregateIds = new Set<Id>();
            
            Set<ID> profIds = new Set<Id>();
            
            Boolean isOverlay = true;
            //Store the profile ids of the managers
            for(Sales_Profile_Company_Level_Junction__c s: sReps){
                profIds.add(s.Sales_Rep_Profile__c);
                aggregateIds.add(s.Sales_Rep_Profile__c);
                if(s.Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' ){
                    isOverlay = false;
                }
            }
            
            
            List<AggregateResult> r = [SELECT AVG(Overall_Rating__c) avor, AVG(Overall_Qualitative_Rating__c) avoq FROM Certification__c WHERE Sales_Rep_Profile__c IN :aggregateIds AND (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_Quota_Amount__c > 0)] ;
            
            displayWrapper.score = FunnelCalculationHelper.findAggregateScore(profIds);
            
            if(r != null && r.size() > 0){   
                if(r[0].get('avoq') != null){
                    displayWrapper.scoreQual = Decimal.valueOf(FunnelCalculationHelper.convert((Decimal)r[0].get('avoq'),'score'));
                }
            }
            //Fetch the company levels associated with the sales profiles
            cl = [SELECT id, Level_Value__c FROM Company_Level__c WHERE Sales_Rep_Profile__c IN :profIds];
            
            levels.clear();
            
            //Store all the levels associated with the managers
            for(Company_Level__c c: cl){
                levels.add(c.Level_Value__c);
            }
            
            //Fetch the sales profiles associated with the levels
            sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Profile_Type__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels];
            
            system.debug(' aggregateIds '+aggregateIds);        
            //Add the sales profiles to the ids to be aggregated 
            Set<Id> srpid = new Set<Id>();
            for(Sales_Profile_Company_Level_Junction__c s: sReps){
                aggregateIds.add(s.Sales_Rep_Profile__c);
                if(s.Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' ){
                    isOverlay = false;
                }
            }
            
            RoleOverlay = isOverlay ;
            srpid.addAll(aggregateIds);
            
            
            //CustomMetric code
            displayCustomMetric('Role',aggregateIds);
            
            //Aggregate the results
            List<AggregateResult> ar  = new List<AggregateResult>();
            
            
            if(RoleOverlay){
                ar = [Select SUM(YTD_Revenue__c) y, SUM(Annual_Quota_Amount__c) a, AVG(YTD_Average_win_size__c) sp, AVG(X12_Month_Average_Selling_Price__c) sp12, 
                      AVG(YTD_Lead_Conversion_rate__c) lc, AVG(YTD_Average_Sales_Cycle__c) sc, AVG(YTD_Opportunity_Close_Rate__c) wp,
                      SUM(X12_Month_QO_added__c) opaf, SUM(X12_Month_Leads_Added__c) laf,
                      AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,SUM(Monthly_Quota_Revenue__c) mr, SUM(Quarterly_Quota_Revenue__c) qr,
                      SUM(Monthly_QO_added__c) moa, SUM(Quarterly_QO_added__c)qoa, SUM(Ytd_QO_added__c) yoa, SUM(Monthly_Lead_Added__c) mla, SUM(Quarterly_Lead_Added__c) qla,SUM(YTD_Leads_Added__c) yla,
                      SUM(Current_Active_Opportunities__c) ca, SUM(Current_Pipeline__c) cp, SUM(YTD_Opportunities_won__c) yw ,AVG(Goal_12m_rolling_amt_close_rate__c) gacr , AVG(YTD_Close_Rate__c) acr,
                      SUM(YTD_Quota__c) ytdq , SUM(Goal_of_YTD_leads_to_achieve_quota__c) gYtdL ,SUM(Number_of_meetings_YTD__c) nmytd, SUM(Goal_of_YTD_meetings__c) gytdM, SUM(Goal_YTD_Opportunities_Added__c) gYtdOA, AVG(Average_Deal_Size__c) ads, AVG(Goal_Average_Deal_Size__c) gads
                      from Sales_Rep_Profile__c where id IN :aggregateIds  AND  Annual_Quota_Amount__c > 0 AND Profile_Type__c = 'Overlay'];
                
            }else{
                ar = [Select SUM(YTD_Revenue__c) y, SUM(Annual_Quota_Amount__c) a, AVG(YTD_Average_win_size__c) sp, AVG(X12_Month_Average_Selling_Price__c) sp12, 
                      AVG(YTD_Lead_Conversion_rate__c) lc, AVG(YTD_Average_Sales_Cycle__c) sc, AVG(YTD_Opportunity_Close_Rate__c) wp,
                      SUM(X12_Month_QO_added__c) opaf, SUM(X12_Month_Leads_Added__c) laf,
                      AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,SUM(Monthly_Quota_Revenue__c) mr, SUM(Quarterly_Quota_Revenue__c) qr,
                      SUM(Monthly_QO_added__c) moa, SUM(Quarterly_QO_added__c)qoa, SUM(Ytd_QO_added__c) yoa, SUM(Monthly_Lead_Added__c) mla, SUM(Quarterly_Lead_Added__c) qla,SUM(YTD_Leads_Added__c) yla,
                      SUM(Current_Active_Opportunities__c) ca, SUM(Current_Pipeline__c) cp, SUM(YTD_Opportunities_won__c) yw ,AVG(Goal_12m_rolling_amt_close_rate__c) gacr , AVG(YTD_Close_Rate__c) acr,
                      SUM(YTD_Quota__c) ytdq , SUM(Goal_of_YTD_leads_to_achieve_quota__c) gYtdL ,SUM(Number_of_meetings_YTD__c) nmytd, SUM(Goal_of_YTD_meetings__c) gytdM, SUM(Goal_YTD_Opportunities_Added__c) gYtdOA, AVG(Average_Deal_Size__c) ads, AVG(Goal_Average_Deal_Size__c) gads
                      from Sales_Rep_Profile__c where id IN :aggregateIds  AND  Annual_Quota_Amount__c > 0 AND Profile_Type__c != 'Overlay'];
            }
            
            //Populate the wrapper
            if(ar != null && ar.size() > 0){                            
                
                if(ar[0].get('y') != null)
                    YTDQuotaPerformance = (Decimal)(ar[0].get('y'));
                
                if(ar[0].get('ytdq') != null)
                    YTDQuotaPerformanceGoal = (Decimal)(ar[0].get('ytdq')); 
                
                if(ar[0].get('yla') != null)    
                    YTDLeadsAdded = (Decimal)(ar[0].get('yla'));
                
                if(ar[0].get('gYtdL') != null)                
                    YTDLeadsAddedGoal  = (Decimal)(ar[0].get('gYtdL'));  
                
                if(ar[0].get('lc') != null)
                    X12MonthRollingLeadConversion = (Decimal)(ar[0].get('lc'));  
                
                if(ar[0].get('lcg') != null)                
                    X12MonthRollingLeadConversionGoal = (Decimal)(ar[0].get('lcg')); 
                
                if(ar[0].get('nmytd') != null)                
                    YTDNumberofMeetings = (Decimal)(ar[0].get('nmytd'));
                
                if(ar[0].get('gytdM') != null)
                    YTDNumberofMeetingsGoal = (Decimal)(ar[0].get('gytdM'));
                
                if(ar[0].get('yoa') != null)
                    YTDOpportunitiesAddedtoQualifiedFunnel  = (Decimal)(ar[0].get('yoa')); 
                
                if(ar[0].get('gYtdOA') != null)
                    YTDOpportunitiesAddedtoQualifiedFunnelGoal = (Decimal)(ar[0].get('gYtdOA'));
                
                if(ar[0].get('wp') != null)
                    X12MonthRollingCloseRatebasedonOpportunities = (Decimal)(ar[0].get('wp')); 
                
                if(ar[0].get('wpg') != null)
                    X12MonthRollingCloseRatebasedonOpportunitiesGoal =  (Decimal)(ar[0].get('wpg')); 
                
                if(ar[0].get('acr') != null)
                    X12MonthRollingCloseRatebasedondollar =  (Decimal)(ar[0].get('acr'));  
                
                if(ar[0].get('gacr') != null)
                    X12MonthRollingCloseRatebasedondollarGoal =  (Decimal)(ar[0].get('gacr')); 
                
                if(ar[0].get('sp') != null) 
                    X12MonthRollingAveragedollarWinSize = (Decimal)(ar[0].get('sp')); 
                
                if(ar[0].get('spg') != null) 
                    X12MonthRollingAveragedollarWinSizeGoal = (Decimal)(ar[0].get('spg'));  
                
                if(ar[0].get('sc') != null)
                    X12MonthRollingLengthofSalesCycle =  (Decimal)(ar[0].get('sc')); 
                
                if(ar[0].get('scg') != null)
                    X12MonthRollingLengthofSalesCycleGoal =  (Decimal)(ar[0].get('scg')); 
                
                if(ar[0].get('ads') != null)
                    X12AverageDealSize =  (Decimal)(ar[0].get('ads')); 
                
                if(ar[0].get('gads') != null)
                    X12AverageDealSizeGoal =  (Decimal)(ar[0].get('gads')); 
                //Score card
                
                if(ar[0].get('cp') != null) 
                    curentPipeline  = convert(convertsub( (Decimal)ar[0].get('cp'),''),'$');
                
                if(ar[0].get('ca') != null) 
                    activeopp  = convert(convertsub( (Decimal)ar[0].get('ca'),''),'');
                
                if(ar[0].get('yw') != null) 
                    ytdWin  = convert(convertsub( (Decimal)ar[0].get('yw'),''),'');
                
                if(ar[0].get('sp12') != null && (Decimal)ar[0].get('sp12') > 0 && ar[0].get('y') != null  && ar[0].get('a') != null){
                    Decimal win = ((Decimal)ar[0].get('a') - (Decimal)ar[0].get('y'))/(Decimal)ar[0].get('sp12');
                    winNeedToMakeQuota = convert(convertsub( win,''),'');
                    
                }
            }    
            
            
            if(Mngid != null){
                List<Sales_Rep_Profile__c> srps = new List<Sales_Rep_Profile__c>();
                srps = [select id from Sales_Rep_Profile__c where Sales_Manager__c = :Mngid AND id != :Spid];
                levels = new Set<String>();
                Set<Id> spids = new set<Id>();
                spids = (new map<id,Sales_Rep_Profile__c>(srps)).keyset();
                
                List<Company_Level__c> c2 = [SELECT id, Level_Value__c FROM Company_Level__c WHERE Sales_Rep_Profile__c IN :spids];
                
                for(Company_Level__c c: c2){
                    levels.add(c.Level_Value__c);
                }
                List<Sales_Profile_Company_Level_Junction__c> sReps2  = new List<Sales_Profile_Company_Level_Junction__c>();
                
                sReps2 = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree ]; 
                
                levels = new Set<String>();
                
                //List to store the ids of the reps to be aggregated
                aggregateIds = new Set<Id>();
                
                profIds = new Set<Id>();
                
                //Store the profile ids of the managers
                for(Sales_Profile_Company_Level_Junction__c s: sReps2){
                    profIds.add(s.Sales_Rep_Profile__c);
                    aggregateIds.add(s.Sales_Rep_Profile__c);
                }
                
                //Fetch the company levels associated with the sales profiles
                c2 = [SELECT id, Level_Value__c FROM Company_Level__c WHERE Sales_Rep_Profile__c IN :profIds];
                
                levels.clear();
                
                //Store all the levels associated with the managers
                for(Company_Level__c c: c2){
                    levels.add(c.Level_Value__c);
                }
                
                //Fetch the sales profiles associated with the levels
                
                sReps2 = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels];
                
                system.debug(' aggregateIds '+aggregateIds);        
                //Add the sales profiles to the ids to be aggregated        
                for(Sales_Profile_Company_Level_Junction__c s: sReps2){
                    aggregateIds.add(s.Sales_Rep_Profile__c);
                }
                
                //Aggregate the results
                List<AggregateResult> ar2 = new List<AggregateResult>();
                
                if(RoleOverlay){
                    ar2 = [Select AVG(YTD_Revenue__c) y, AVG(Annual_Quota_Amount__c) a, AVG(YTD_Average_win_size__c) sp,  
                           AVG(YTD_Lead_Conversion_rate__c) lc, AVG(YTD_Average_Sales_Cycle__c) sc, AVG(YTD_Opportunity_Close_Rate__c) wp,
                           AVG(X12_Month_QO_added__c) opaf, AVG(X12_Month_Leads_Added__c) laf,
                           AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,AVG(Monthly_Quota_Revenue__c) mr, AVG(Quarterly_Quota_Revenue__c) qr,
                           AVG(Monthly_QO_added__c) moa, AVG(Quarterly_QO_added__c)qoa, AVG(Ytd_QO_added__c) yoa, AVG(Monthly_Lead_Added__c) mla, AVG(Quarterly_Lead_Added__c) qla,AVG(YTD_Leads_Added__c) yla,
                           AVG(Number_of_meetings_YTD__c) nmytd , AVG(YTD_Close_Rate__c) acr, AVG(Average_Deal_Size__c) ads
                           from Sales_Rep_Profile__c where id IN :aggregateIds AND  Annual_Quota_Amount__c > 0 AND Profile_Type__c = 'Overlay'];
                }else{
                    ar2 = [Select AVG(YTD_Revenue__c) y, AVG(Annual_Quota_Amount__c) a, AVG(YTD_Average_win_size__c) sp,  
                           AVG(YTD_Lead_Conversion_rate__c) lc, AVG(YTD_Average_Sales_Cycle__c) sc, AVG(YTD_Opportunity_Close_Rate__c) wp,
                           AVG(X12_Month_QO_added__c) opaf, AVG(X12_Month_Leads_Added__c) laf,
                           AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,AVG(Monthly_Quota_Revenue__c) mr, AVG(Quarterly_Quota_Revenue__c) qr,
                           AVG(Monthly_QO_added__c) moa, AVG(Quarterly_QO_added__c)qoa, AVG(Ytd_QO_added__c) yoa, AVG(Monthly_Lead_Added__c) mla, AVG(Quarterly_Lead_Added__c) qla,AVG(YTD_Leads_Added__c) yla,
                           AVG(Number_of_meetings_YTD__c) nmytd , AVG(YTD_Close_Rate__c) acr, AVG(Average_Deal_Size__c) ads
                           from Sales_Rep_Profile__c where id IN :aggregateIds AND  Annual_Quota_Amount__c > 0 AND Profile_Type__c != 'Overlay'];
                }
                
                
                /* Commented to make Team peer for role 0     
if(ar2 != null && ar2.size() > 0){                           

if(ar2[0].get('y') != null)
YTDQuotaPerformanceTeam = (Decimal)(ar2[0].get('y')) ;

if(ar2[0].get('yla') != null)
YTDLeadsAddedTeam = (Decimal)(ar2[0].get('yla')) ;  

if(ar2[0].get('lc') != null)                
X12MonthRollingLeadConversionTeam  = (Decimal)(ar2[0].get('lc')); 

if(ar2[0].get('nmytd') != null)                
YTDNumberofMeetingsTeam  = (Decimal)(ar2[0].get('nmytd')) ;   

if(ar2[0].get('yoa') != null)
YTDOpportunitiesAddedtoQualifiedFunnelTeam = (Decimal)(ar2[0].get('yoa')); 

if(ar2[0].get('wp') != null)                
X12MonthRollingCloseRatebasedonOpportunitiesTeam = (Decimal)(ar2[0].get('wp')); 

if(ar2[0].get('acr') != null)                
X12MonthRollingCloseRatebasedondollarTeam = (Decimal)(ar2[0].get('acr'));  

if(ar2[0].get('sp') != null)    
X12MonthRollingAveragedollarWinSizeTeam = (Decimal)(ar2[0].get('sp')); 

if(ar2[0].get('sc') != null)
X12MonthRollingLengthofSalesCycleTeam = (Decimal)(ar2[0].get('sc')); 

if(ar2[0].get('ads') != null)
X12AverageDealSizeTeam = (Decimal)(ar2[0].get('ads'));           

}    
*/
                
            }
            
            
            
            
            
            
            
            
        }
    }
    
    //Action method when level one is changed
    public void levelOneAction(){
        if(readAccess){
            try{
                FunnelFilterHelper.levelOneAction(fw);
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
        
        return FunnelNavigationHelper.navigateToHomePage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
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
    public String convert(decimal d , string s){
        string dr;
        Decimal rounded ;
        if(math.abs(d) >= 1000000000){
            rounded = d/1000000000;
            rounded   = rounded.setScale(2, RoundingMode.HALF_UP);
            
            if(d >= 0){
                if(s == '$'){
                    dr= s + rounded.format() + 'B';
                }else{
                    dr= rounded.format() + 'B' + s;
                }
                
            }else{
                if(s == '$'){
                    dr= s + rounded.format() + 'B';
                }else{
                    dr= rounded.format() + 'B' + s;
                }
                dr = '('+ dr.remove('-') +')';
            }
        }
        else if(math.abs(d) >= 1000000){
            rounded = d/1000000 ;
            rounded   = rounded.setScale(2, RoundingMode.HALF_UP);
            
            if(rounded >= 1000){
                rounded =rounded/1000 ;
                
                if(d >= 0){
                    if(s == '$'){
                        if(rounded.format().contains('.')){
                            dr= s + rounded.format() + 'B';
                        }else{
                            dr= s + rounded.format() + '.00'+'B';
                        }
                        
                    }else{
                        dr= rounded.format() + 'B' + s;
                    }
                }else{
                    if(s == '$'){
                        if(rounded.format().contains('.')){
                            dr= s + rounded.format() + 'B';
                        }else{
                            dr= s + rounded.format() + '.00'+'B';
                        }
                    }else{
                        dr= rounded.format() + 'B' + s;
                    }
                    dr = '('+ dr.remove('-') +')';
                }
            }else{
                if(d >= 0){
                    if(s == '$'){
                        if(rounded.format().contains('.')){
                            dr= s + rounded.format() + 'M';
                        }else{
                            dr= s + rounded.format() + '.00'+'M';
                        }
                        
                    }else{
                        dr= rounded.format() + 'M' + s;
                    }
                }else{
                    if(s == '$'){
                        if(rounded.format().contains('.')){
                            dr= s + rounded.format() + 'M';
                        }else{
                            dr= s + rounded.format() + '.00'+'M';
                        }
                    }else{
                        dr= rounded.format() + 'M' + s;
                    }
                    dr = '('+ dr.remove('-') +')';
                }
            }
            
            
        }
        else if(math.abs(d) >= 10000){
            rounded =d/1000 ;
            rounded   = rounded .setScale(2, RoundingMode.HALF_UP);
            
            if(rounded >= 1000  ){
                rounded =rounded/1000 ;
                if(d >= 0){
                    if(s == '$'){
                        if(rounded.format().contains('.')){
                            dr= s + rounded.format() + 'M';
                        }else{
                            dr= s + rounded.format() + '.00'+'M';
                        }
                    }else{
                        dr= rounded.format() + 'M' + s;
                    }
                }else{
                    if(s == '$'){
                        if(rounded.format().contains('.')){
                            dr= s + rounded.format() + 'M';
                        }else{
                            dr= s + rounded.format() + '.00'+'M';
                        }
                    }else{
                        dr= rounded.format() + 'M' + s;
                    }
                    dr = '('+ dr.remove('-') +')';
                }
                
            }else{
                d= d.setScale(2, RoundingMode.HALF_UP);
                if(d >= 0){
                    if(s == '$'){
                        dr= s + rounded.format() + 'K';
                    }else{
                        dr= rounded.format() + 'K' + s;
                    }
                }else{
                    if(s == '$'){
                        dr= s + rounded.format() + 'K';
                    }else{
                        dr= rounded.format() + 'K' + s;
                    }
                    dr = '('+ dr.remove('-') +')';
                }
            }
            
        }else
        {
            if( s == '%'){
                d =d.setScale(2, RoundingMode.HALF_UP);
            }else{
                d =d.setScale(0, RoundingMode.HALF_UP);
            }
            if(d >= 0){
                if(s == '$'){
                    dr= s + d.format() ;
                }else{
                    dr= d.format() + s;
                }
                
            }else{
                if(s == '$'){
                    dr= s + d.format() ;
                }else{
                    dr= d.format() + s;
                }
                dr = '('+ dr.remove('-') +')';
            }
        }
        return dr;
    }
    
    public Decimal convertsub(decimal d , string s){
        Decimal rounded ;
        if(math.abs(d) >= 1000000000){
            rounded = d/1000000000;
            rounded   = rounded.setScale(2, RoundingMode.HALF_UP);
            rounded = rounded * 1000000000;
            
        }
        else if(math.abs(d) >= 1000000){
            rounded = d/1000000 ;
            rounded   = rounded.setScale(2, RoundingMode.HALF_UP);
            rounded = rounded * 1000000;
            
            
            
        }
        else if(math.abs(d) >= 10000){
            rounded =d/1000 ;
            rounded   = rounded .setScale(2, RoundingMode.HALF_UP);
            rounded = rounded * 1000;
            
            
        }else{
            if( s == '%'){
                d =d.setScale(2, RoundingMode.HALF_UP);
            }else{
                d =d.setScale(0, RoundingMode.HALF_UP);
            }
            rounded = d;
        }
        return rounded;
    }     
    
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
    
    
    
    private void fetchPerfScores(){
        
        List<Certification__c> certScores = [SELECT id, Overall_Rating__c FROM Certification__c WHERE Sales_Rep_Profile__r.Active__c = TRUE AND Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' ORDER BY Overall_Rating__c DESC LIMIT 5000  ];
        
        if(certScores != null && certScores.size() > 0){
            
            Integer i = certScores.size();
            Integer quarSize = (Integer)(i/4);
            
            highPerfScore = certScores[quarSize - 1].Overall_Rating__c;
            lowPerfScore = certScores[(quarSize * 3) - 1].Overall_Rating__c;            
        }
        
        List<Certification__c> certScoresQual = [SELECT id, Overall_Qualitative_Rating__c FROM Certification__c WHERE Sales_Rep_Profile__r.Active__c = TRUE ORDER BY Overall_Qualitative_Rating__c DESC LIMIT 5000 ];
        
        if(certScoresQual != null && certScoresQual.size() > 0){
            
            Integer i = certScoresQual.size();
            Integer quarSize = (Integer)(i/4);
            
            highPerfScoreQual = certScoresQual[quarSize - 1].Overall_Qualitative_Rating__c;
            lowPerfScoreQual = certScoresQual[(quarSize * 3) - 1].Overall_Qualitative_Rating__c;             
        }
        
    }
    private void fetchPerformerSet(String scenario, String param){  
        
        system.debug(' scenario '+scenario);
        system.debug(' param '+param); 
        profs = new List<id>(); 
        
        if (scenario == 'rep'){
            if(fw.selectedLevelFour != 'All'){
                profs.add(fw.selectedLevelFour);
            }else{
                profs.add(fw.selectedLevelTwo);
            }
            
        }else if (scenario == 'role'){
            //Fetch the records at the selected level and role
            List<Sales_Profile_Company_Level_Junction__c> sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree AND Sales_Rep_Profile__r.Active__c = TRUE];                
            Set<String> levels = new Set<String>();
            
            //List to store the ids of the reps to be aggregated
            Set<ID> aggregateIds = new Set<Id>();
            Set<ID> profIds = new Set<Id>();
            
            //Store the profile ids of the managers
            for(Sales_Profile_Company_Level_Junction__c s: sReps){
                profIds.add(s.Sales_Rep_Profile__c);
                profs.add(s.Sales_Rep_Profile__c);
            }
            
            // Confirm with Carine
            
            /*      //Fetch the company levels associated with the sales profiles
List<Company_Level__c> cl = [SELECT id, Level_Value__c FROM Company_Level__c WHERE Sales_Rep_Profile__c IN :profIds AND Sales_Rep_Profile__r.Active__c = TRUE];

levels.clear();

//Store all the levels associated with the managers
for(Company_Level__c c: cl){
levels.add(c.Level_Value__c);
}

//Fetch the sales profiles associated with the levels
sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels AND Sales_Rep_Profile__r.Active__c = TRUE];

//Add the sales profiles to the ids to be aggregated        
for(Sales_Profile_Company_Level_Junction__c s: sReps){
profs.add(s.Sales_Rep_Profile__c);
}  
*/
        }
        
        
    }
    private void fetchImpMetrics (){                      
        
        rats = new List<Important_Rating__c>();
        tableVals = new List<tableWrapper>();
        certMap = new Map<Id,Important_Rating__c>();
        
        ratsQual = new List<Important_Rating__c>();
        tableValsQual = new List<tableWrapper>();
        certMapQual = new Map<Id,Important_Rating__c>();
        
        List<Application_Setting__c> aps = [Select Leads_used__c,Meetings_used__c From Application_Setting__c Limit 1];
        Map<string,id> stdMetric =  new Map<string,id>();
        List<Important_Rating__c> CMrat = new List<Important_Rating__c>();
        Set<id> imprat = new Set<id>();
        
        if((fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All') || fw.selectedLevelFour != 'All'){
            rats = [Select id, Certification_Rating__r.group__c, Importance_coefficient__c, Certification_Rating__c, Certification_Rating__r.name From Important_Rating__c where Role__c = :roleVal AND Certification_rating__r.Assessment_type__c='Quantitative' AND Certification_rating__r.Deactivated__c = false AND Importance_coefficient__c > 0 AND Certification_rating__r.Metric_Field_Name__c != NULL AND Certification_rating__r.SRP_field_name__c = null AND Certification_Rating__r.group__c != null  order by  Importance_coefficient__c desc];
            CMrat = [Select id, Certification_Rating__r.group__c, Importance_coefficient__c, Certification_Rating__c, Certification_Rating__r.name From Important_Rating__c where Role__c = :roleVal AND Certification_rating__r.Assessment_type__c='Quantitative' AND Certification_rating__r.Deactivated__c = false AND Importance_coefficient__c > 0 AND Certification_rating__r.Metric_Field_Name__c != NULL AND Certification_rating__r.SRP_field_name__c != null AND Certification_Rating__r.group__c != null  order by  Importance_coefficient__c desc];     
            ratsQual = [Select Importance_coefficient__c, Certification_Rating__c, Certification_Rating__r.name From Important_Rating__c where Role__c = :roleVal AND Certification_rating__r.Assessment_type__c='Qualitative' AND Certification_rating__r.Deactivated__c = false AND Importance_coefficient__c > 0 order by  Importance_coefficient__c desc];        
        }
        else{
            rats = [Select id, Certification_Rating__r.group__c, Importance_coefficient__c, Certification_Rating__c, Certification_Rating__r.name From Important_Rating__c where Role__c = :fw.selectedLevelThree AND Certification_rating__r.Assessment_type__c='Quantitative' AND Certification_rating__r.Deactivated__c = false AND Importance_coefficient__c > 0 AND Certification_rating__r.Metric_Field_Name__c != NULL AND Certification_rating__r.SRP_field_name__c = null AND Certification_Rating__r.group__c != null order by  Importance_coefficient__c desc];        
            CMrat = [Select id,Certification_Rating__r.group__c, Importance_coefficient__c, Certification_Rating__c, Certification_Rating__r.name From Important_Rating__c where Role__c = :fw.selectedLevelThree AND Certification_rating__r.Assessment_type__c='Quantitative' AND Certification_rating__r.Deactivated__c = false AND Importance_coefficient__c > 0 AND Certification_rating__r.Metric_Field_Name__c != NULL AND Certification_rating__r.SRP_field_name__c != null AND Certification_Rating__r.group__c != null order by  Importance_coefficient__c desc];  
            ratsQual = [Select Importance_coefficient__c, Certification_Rating__c, Certification_Rating__r.name From Important_Rating__c where Role__c = :fw.selectedLevelThree AND Certification_rating__r.Assessment_type__c='Qualitative' AND Certification_rating__r.Deactivated__c = false AND Importance_coefficient__c > 0 order by  Importance_coefficient__c desc];        
        }
        
        System.debug('ratsQual '+ratsQual );
        
        for(Important_Rating__c r:rats ){
            if(!stdMetric.keySet().contains(r.Certification_Rating__r.group__c)){
                stdMetric.put(r.Certification_Rating__r.group__c,r.id);
            }
        }   
        
        if(aps != null && aps.size()>0){
            
            if(!aps[0].Leads_used__c && stdMetric.keySet().contains('Leads') ){
                stdMetric.remove('Leads');
            }
            if(!aps[0].Meetings_used__c && stdMetric.keySet().contains('Meetings') ){
                stdMetric.remove('Meetings');
            }
            
        } 
        
        for(String r : stdMetric.keySet()){
            if(r == 'Opportunity Close Rate' || r =='Qualified Opportunities Added' || r == 'Meetings' || r == 'Leads' || r =='Sales Cycle' || r == 'Deal Size' )
                imprat.add(stdMetric.get(r));
        }
        for(Important_Rating__c i : CMrat){
            imprat.add(i.id);
        }
        rats.clear(); 
        rats=[Select Importance_coefficient__c, Certification_Rating__c, Certification_Rating__r.name From Important_Rating__c where id IN :imprat  order by  Importance_coefficient__c desc LIMIT 6];
        for(Important_Rating__c r:rats){
            certMap.put(r.Certification_Rating__c,r);    
        }
        
        List<Important_Rating__c> rat70Qual = new List<Important_Rating__c>();
        Decimal limQual = 0;
        
        for(Important_Rating__c r :ratsQual){
            if((limQual < 70 || rat70Qual.size() < 2) && rat70Qual.size() < 6){
                rat70Qual.add(r);
                limQual += r.Importance_coefficient__c;
            }
        }
        
        
        if( rat70Qual != null && rat70Qual.size() > 0){
            ratsQual = rat70Qual;
        }else if(ratsQual != null){
            ratsQual.clear();
        }
        
        System.debug('ratsQual '+ratsQual );
        
        
        for(Important_Rating__c r:ratsQual){
            certMapQual.put(r.Certification_Rating__c,r);    
        }
        System.debug('certMapQual'+certMapQual);
        
        ratings = new Set<id>();
        ratingRecs = new List<Certification_Rating__c>();
        ratings = certMap.keySet();
        
        ratingsQual = new Set<id>();
        ratingRecsQual = new List<Certification_Rating__c>();
        ratingsQual = certMapQual.keySet();
        System.debug('ratingsQual '+ratingsQual );
        
        if(ratings != null && ratings.size() > 0){
            
            ratingRecs = [SELECT id FROM Certification_Rating__c WHERE id IN :ratings];
            
            List<AggregateResult> cres = [SELECT MAX(Due_Date__c) d, Certifcation_Rating__r.id cr FROM Certification_Answer__c WHERE Certifcation_Rating__c IN :ratingRecs AND Rating_Score__c != null AND Certifcation_Rating__r.Timing__c = 'End of month' AND Certifcation_Rating__r.Assessment_type__c = 'Quantitative' AND Due_Date__c < today AND Sales_Rep_Profile__r.Active__c = TRUE AND Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' GROUP BY Certifcation_Rating__r.id];
            
            Date monthlyDueDate;
            
            if(cres != null && cres.size() > 0){
                monthlyDueDate = (Date)cres[0].get('d');
            }
            
            if(monthlyDueDate != null){        
                
                fetchScores('end of month',monthlyDueDate);                        
                
            }
            
            cres = [SELECT MAX(Due_Date__c) d, Certifcation_Rating__r.id cr FROM Certification_Answer__c WHERE Certifcation_Rating__c IN :ratingRecs AND Rating_Score__c != null AND Certifcation_Rating__r.Timing__c = 'End of month' AND Certifcation_Rating__r.Assessment_type__c = 'Quantitative' AND Due_Date__c < today AND Sales_Rep_Profile__r.Active__c = TRUE AND Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' GROUP BY Certifcation_Rating__r.id];
            
            Date quarDueDate;
            
            if(cres != null && cres.size() > 0){
                quarDueDate = (Date)cres[0].get('d');
            }
            
            if(quarDueDate != null){        
                fetchScores('end of quarter',quarDueDate);                                    
            }                
            
            findRankBasedOnGapAndImpCoeff();
            
            tableVals = metricRowMap.values();
            
            system.debug(' tableVals  '+tableVals);
            
            for(tableWrapper t: tableVals){
                if(t.teamScore == null){
                    t.teamScore = 0;
                }
            }
            
            List<tableWrapper> finalTable = new List<tableWrapper>();
            
            for(tableWrapper t: tableVals){
                if(t.teamScore != null){
                    finalTable.add(t);
                }
            }
            
            tableVals = finalTable;
            
            tableVals.sort();
            
            
            
            findRanking();
            
            tableVals = metricRowMap.values();
            
            system.debug(' tableVals  '+tableVals);
            
            finalTable = new List<tableWrapper>();
            
            for(tableWrapper t: tableVals){
                if(t.teamScore == null){
                    t.teamScore = 0;
                }
            }
            
            for(tableWrapper t: tableVals){
                if(t.teamScore != null){
                    finalTable.add(t);
                }
            }
            
            tableVals = finalTable;
            
            tableVals.sort();
            assignRank();                
            
            system.debug(' sorted tableVals  '+tableVals);
        } 
        
        if(ratingsQual != null && ratingsQual.size() > 0){
            
            ratingRecsQual = [SELECT id FROM Certification_Rating__c WHERE id IN :ratingsQual];
            
            List<AggregateResult> cresQual = [SELECT MAX(Due_Date__c) d, Certifcation_Rating__r.id cr FROM Certification_Answer__c WHERE Certifcation_rating__c IN :ratingRecsQual AND Rating_Score__c != null AND Certifcation_Rating__r.Timing__c = 'End of month' AND Certifcation_Rating__r.Assessment_type__c = 'Qualitative' AND Due_Date__c < today AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
            System.debug('cresQual'+cresQual);
            Date monthlyDueDateQual;
            
            if(cresQual != null && cresQual.size() > 0){
                monthlyDueDateQual = (Date)cresQual[0].get('d');
            }
            
            if(monthlyDueDateQual != null){        
                
                fetchScoresQual('end of month',monthlyDueDateQual);                        
                
            }
            
            cresQual = [SELECT MAX(Due_Date__c) d, Certifcation_Rating__r.id cr FROM Certification_Answer__c WHERE Certifcation_rating__c IN :ratingRecsQual AND Rating_Score__c != null AND Certifcation_Rating__r.Timing__c = 'End of quarter' AND Certifcation_Rating__r.Assessment_type__c = 'Qualitative' AND Due_Date__c < today AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
            system.debug(' cres val Qual '+cresQual);
            system.debug(' ratings val Qual'+ratingsQual );
            
            
            Date quarDueDateQual;
            
            if(cresQual != null && cresQual.size() > 0){
                quarDueDateQual = (Date)cresQual[0].get('d');
            }
            
            if(quarDueDateQual != null){        
                fetchScoresQual('end of quarter',quarDueDateQual);                                    
            }
            
            cresQual = [SELECT MAX(Due_Date__c) d, Certifcation_Rating__r.id cr FROM Certification_Answer__c WHERE Certifcation_rating__c IN :ratingRecsQual AND Rating_Score__c != null AND Certifcation_Rating__r.Timing__c = 'Bi-annual' AND Certifcation_Rating__r.Assessment_type__c = 'Qualitative' AND Due_Date__c < today AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
            
            Date biAnnDueDate;
            
            if(cresQual != null && cresQual.size() > 0){
                biAnnDueDate = (Date)cresQual[0].get('d');
            }
            
            if(biAnnDueDate != null){        
                fetchScoresQual('Bi-annual',biAnnDueDate);                                    
            }                   
            
            cresQual = [SELECT MAX(Due_Date__c) d, Certifcation_Rating__r.id cr FROM Certification_Answer__c WHERE Certifcation_rating__c IN :ratingRecsQual AND Rating_Score__c != null AND Certifcation_Rating__r.Timing__c = 'Annual' AND Certifcation_Rating__r.Assessment_type__c = 'Qualitative' AND Due_Date__c < today AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
            
            Date annDueDate;
            
            if(cresQual != null && cresQual.size() > 0){
                annDueDate = (Date)cresQual[0].get('d');
            }
            
            if(biAnnDueDate != null){        
                fetchScoresQual('Annual',annDueDate);                                    
            }        
            
            findRankBasedOnGapAndImpCoeffQual();
            
            tableValsQual = metricRowMapQual.values();
            
            
            
            for(tableWrapper t: tableValsQual){
                if(t.teamScore == null){
                    t.teamScore = 0;
                }
            }
            
            List<tableWrapper> finalTableQual = new List<tableWrapper>();
            
            for(tableWrapper t: tableValsQual){
                if(t.teamScore != null){
                    finalTableQual.add(t);
                }
            }
            
            tableValsQual = finalTableQual;
            
            tableValsQual.sort();
            
            findRankingQual();
            
            tableValsQual = metricRowMapQual.values();
            
            finalTableQual = new List<tableWrapper>();
            
            for(tableWrapper t: tableValsQual){
                if(t.teamScore == null){
                    t.teamScore = 0;
                }
            }
            
            for(tableWrapper t: tableValsQual){
                if(t.teamScore != null){
                    finalTableQual.add(t);
                }
            }
            
            tableValsQual = finalTableQual;
            
            tableValsQual.sort();
            assignRankQual();                
            
            system.debug(' sorted tableVals  '+tableValsQual);
        }
    }
    
    private void fetchScores(String timing, Date dueDate){
        
        List<AggregateResult> ares = [SELECT AVG(Rating_Score__c) r, Certifcation_Rating__r.id rid FROM Certification_Answer__c WHERE Certifcation_Rating__r.timing__c = :timing AND Certifcation_Rating__r.Assessment_type__c = 'Quantitative' AND Certifcation_Rating__c IN :ratingRecs AND Due_Date__c = :dueDate AND Certifcation__r.Overall_rating__c >= :highPerfScore AND Sales_Rep_Profile__r.Active__c = TRUE AND Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' GROUP BY Certifcation_Rating__r.id];
        
        for(AggregateResult r: ares){
            if(r.get('r') != null){
                if(!metricRowMap.containsKey((id)r.get('rid'))){
                    tableWrapper tw = new tableWrapper();
                    tw.metricId = (id)r.get('rid');
                    tw.metricName = certMap.get((id)r.get('rid')).Certification_Rating__r.name;
                    tw.imporCoeff = certMap.get((id)r.get('rid')).Importance_coefficient__c;
                    tw.highPerfScore = ((Decimal)r.get('r')).setScale(2, RoundingMode.HALF_UP);
                    metricRowMap.put(tw.metricId,tw);
                } 
                else{
                    metricRowMap.get((id)r.get('rid')).highPerfScore = ((Decimal)r.get('r')).setScale(2, RoundingMode.HALF_UP);
                    
                } 
            }  
        }
        
        
        
        
        ares = [SELECT AVG(Rating_Score__c) r, Certifcation_Rating__r.id rid FROM Certification_Answer__c WHERE Certifcation_Rating__r.timing__c = :timing AND Certifcation_Rating__r.Assessment_type__c = 'Quantitative' AND Certifcation_Rating__c IN :ratingRecs AND Due_Date__c = :dueDate AND Sales_rep_profile__c IN :profs AND Sales_Rep_Profile__r.Active__c = TRUE AND Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' GROUP BY Certifcation_Rating__r.id];
        
        for(AggregateResult r: ares){
            if(r.get('r') != null){
                if(!metricRowMap.containsKey((id)r.get('rid'))){
                    tableWrapper tw = new tableWrapper();
                    tw.metricId = (id)r.get('rid');
                    tw.metricName = certMap.get((id)r.get('rid')).Certification_rating__r.name;
                    tw.imporCoeff = certMap.get((id)r.get('rid')).Importance_coefficient__c;                
                    tw.teamScore = ((Decimal)r.get('r')).setScale(2, RoundingMode.HALF_UP);
                    metricRowMap.put(tw.metricId,tw);
                } 
                else{
                    metricRowMap.get((id)r.get('rid')).teamScore = ((Decimal)r.get('r')).setScale(2, RoundingMode.HALF_UP);
                    
                }  
            } 
        }
        
    }
    private void fetchScoresQual(String timing, Date dueDate){
        
        List<AggregateResult> ares = [SELECT AVG(Rating_Score__c) r, Certifcation_Rating__r.id rid FROM Certification_Answer__c WHERE Certifcation_Rating__r.timing__c = :timing AND Certifcation_Rating__r.Assessment_type__c = 'Qualitative' AND Certifcation_Rating__c IN :ratingRecsQual AND Due_Date__c = :dueDate AND Certifcation__r.Overall_Qualitative_Rating__c >= :highPerfScoreQual AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
        system.debug(' ares Qual'+ares);    
        for(AggregateResult r: ares){
            if(r.get('r') != null){
                if(!metricRowMapQual.containsKey((id)r.get('rid')) && r.get('r') != null){
                    tableWrapper tw = new tableWrapper();
                    tw.metricId = (id)r.get('rid');
                    tw.metricName = certMapQual.get((id)r.get('rid')).Certification_Rating__r.name;
                    tw.imporCoeff = certMapQual.get((id)r.get('rid')).Importance_coefficient__c;
                    
                    tw.highPerfScore = ((Decimal)r.get('r')).setScale(2, RoundingMode.HALF_UP);
                    metricRowMapQual.put(tw.metricId,tw);
                } 
                else{
                    metricRowMapQual.get((id)r.get('rid')).highPerfScore = ((Decimal)r.get('r')).setScale(2, RoundingMode.HALF_UP);
                    
                }   
            }
        }
        
        
        ares = [SELECT AVG(Rating_Score__c) r, Certifcation_Rating__r.id rid FROM Certification_Answer__c WHERE Certifcation_Rating__r.timing__c = :timing AND Certifcation_Rating__r.Assessment_type__c = 'Qualitative'AND Certifcation_Rating__c IN :ratingRecsQual AND Due_Date__c = :dueDate AND Sales_rep_profile__c IN :profs AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
        system.debug(' team score is '+ares);
        for(AggregateResult r: ares){
            if(r.get('r') != null){
                if(!metricRowMapQual.containsKey((id)r.get('rid')) && r.get('r') != null){
                    tableWrapper tw = new tableWrapper();
                    tw.metricId = (id)r.get('rid');
                    tw.metricName = certMapQual.get((id)r.get('rid')).Certification_rating__r.name;
                    tw.imporCoeff = certMapQual.get((id)r.get('rid')).Importance_coefficient__c;
                    
                    
                    tw.teamScore = ((Decimal)r.get('r')).setScale(2, RoundingMode.HALF_UP);
                    metricRowMapQual.put(tw.metricId,tw);
                } 
                else{
                    metricRowMapQual.get((id)r.get('rid')).teamScore = ((Decimal)r.get('r')).setScale(2, RoundingMode.HALF_UP);
                    
                } 
            }  
        }
        
    }
    
    private void findRanking(){
        for(String key: metricRowMap.keySet()){
            
            if(metricRowMap.get(key).teamScore  != null && metricRowMap.get(key).highPerfScore != null){
                metricRowMap.get(key).gap = (metricRowMap.get(key).teamScore - metricRowMap.get(key).highPerfScore).setScale(2, RoundingMode.HALF_UP); 
            } 
            
            if(metricRowMap.get(key).imporCoeff != null){
                metricRowMap.get(key).rankingScore = (metricRowMap.get(key).imporCoeff).setScale(2, RoundingMode.HALF_UP);
            }            
            
        }    
    }
    private void findRankingQual(){
        for(String key: metricRowMapQual.keySet()){
            
            if(metricRowMapQual.get(key).teamScore  != null && metricRowMapQual.get(key).highPerfScore != null){
                metricRowMapQual.get(key).gap = (metricRowMapQual.get(key).teamScore - metricRowMapQual.get(key).highPerfScore).setScale(2, RoundingMode.HALF_UP); 
            } 
            
            if(metricRowMapQual.get(key).imporCoeff != null){
                metricRowMapQual.get(key).rankingScore = (metricRowMapQual.get(key).imporCoeff).setScale(2, RoundingMode.HALF_UP);
            }            
            
        }    
    }
    
    private void findRankBasedOnGapAndImpCoeff(){
        for(String key: metricRowMap.keySet()){
            
            if(metricRowMap.get(key).teamScore  != null && metricRowMap.get(key).highPerfScore != null){
                metricRowMap.get(key).gap = (metricRowMap.get(key).teamScore - metricRowMap.get(key).highPerfScore).setScale(2, RoundingMode.HALF_UP); 
            } 
            
            if(metricRowMap.get(key).gap != null && metricRowMap.get(key).imporCoeff != null){
                metricRowMap.get(key).rankingScore = (metricRowMap.get(key).gap * metricRowMap.get(key).imporCoeff).setScale(2, RoundingMode.HALF_UP);
            }
            
        }    
    }
    
    private void findRankBasedOnGapAndImpCoeffQual(){
        for(String key: metricRowMapQual.keySet()){
            
            if(metricRowMapQual.get(key).teamScore  != null && metricRowMapQual.get(key).highPerfScore != null){
                metricRowMapQual.get(key).gap = (metricRowMapQual.get(key).teamScore - metricRowMapQual.get(key).highPerfScore).setScale(2, RoundingMode.HALF_UP); 
            } 
            
            if(metricRowMapQual.get(key).gap != null && metricRowMapQual.get(key).imporCoeff != null){
                metricRowMapQual.get(key).rankingScore = (metricRowMapQual.get(key).gap * metricRowMapQual.get(key).imporCoeff).setScale(2, RoundingMode.HALF_UP);
            }
            
        }    
    }
    
    private void assignRank(){
        Integer i = 1;
        for(tableWrapper t:tableVals){
            t.rank = i;
            i++;
        }
    }
    
    private void assignRankQual(){
        Integer i = 1;
        for(tableWrapper t:tableValsQual){
            t.rank = i;
            i++;
        }
    }
    
    
    
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
    public void displayCustomMetric(String scenario, Set<id> srpId){
        
        List<Certification_Rating__c> cm =[Select id ,Description__c,name,Agg__c,SRP_Field_Name__c,Goal_field_name__c,Rating_type__c from Certification_Rating__c where SRP_Field_Name__c != Null AND Display_Custom_Metric__c = true Order by Display_Order__c  Asc];
        System.debug('cm---'+cm);
        if(cm != null && cm.size()>0){
            String aggregateQuery ='Select ';
            for(Certification_Rating__c c :cm){
                
                if(aggregateQuery != 'Select '){
                    aggregateQuery += ' , ';
                }
                
                /*if(scenario == 'Role'){ commented to do aggregate on role
aggregateQuery += ' AVG '+'('+c.SRP_Field_Name__c+') '+ c.SRP_Field_Name__c + ', AVG '+'('+c.Goal_field_name__c+') '+ c.Goal_field_name__c;
}else 
*/
                
                if(c.Agg__c == 'Count'){
                    aggregateQuery += ' SUM ('+c.SRP_Field_Name__c+') '+ c.SRP_Field_Name__c +', SUM ('+c.Goal_field_name__c+') '+ c.Goal_field_name__c;
                }else{
                    aggregateQuery += ' '+ c.Agg__c+'('+c.SRP_Field_Name__c+') '+ c.SRP_Field_Name__c +', '+ c.Agg__c+'('+c.Goal_field_name__c+') '+ c.Goal_field_name__c;
                }
                
            }
            
            
            
            String SOQL_IDs = '';
            
            for (Id id : srpId) {
                if(id != null){
                    String id_in_quotes =  '\''+id+'\'';
                    
                    if (SOQL_IDs !=  '') { 
                        SOQL_IDs+= ','; 
                    }
                    
                    SOQL_IDs +=  id_in_quotes;
                }
            } 
            aggregateQuery += ' FROM Sales_Rep_Profile__c WHERE id IN ('+SOQL_IDs+')  ';
            
            
            List<AggregateResult> ar = database.query(aggregateQuery);
            
            CustomMetricWrapperList = new List<CustomMetricWrapper>();
            if(ar != null && ar.size()>0){
                
                Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                Schema.SObjectType leadSchema = schemaMap.get('FunnelMetrics__Sales_Rep_Profile__c');
                Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
                
                System.debug('ar ar '+ar );
                for(Certification_Rating__c c :cm){
                    CustomMetricWrapper cmw = new CustomMetricWrapper();
                    cmw.fieldLable = fieldMap.get('FunnelMetrics__'+c.SRP_Field_Name__c).getDescribe().getLabel();
                    cmw.name= c.name;
                    cmw.fieldDes =c.Description__c;
                    cmw.fieldApiName = c.SRP_Field_Name__c; 
                    cmw.ratingType= c.Rating_type__c; 
                    
                    if((Decimal)ar[0].get(c.SRP_Field_Name__c) != null && (Decimal)ar[0].get(c.SRP_Field_Name__c) >0){
                        cmw.fieldValue =  (Decimal)ar[0].get(c.SRP_Field_Name__c);
                    }else{
                        cmw.fieldValue = 0;
                    }
                    
                    if((Decimal)ar[0].get(c.Goal_field_name__c) != null && (Decimal)ar[0].get(c.Goal_field_name__c) >0){
                        cmw.fieldGoal =  (Decimal)ar[0].get(c.Goal_field_name__c);
                    }else{
                        cmw.fieldGoal = 0;
                    }
                    
                    CustomMetricWrapperList.add(cmw);
                }
                System.debug(CustomMetricWrapperList);
            }
        }
    }
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
    
    
}