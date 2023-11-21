/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelMonthlySalesProfSnapshotBatch implements Database.Batchable<sobject>, Database.Stateful{
    
    Date triggerDate;

    Boolean chainBatch;

    Boolean errorVal = false;
    Boolean histVal;
    public Boolean createAccess = true;
    public static String prefix{ get{return 'FunnelMetrics__';} set; }

    public FunnelMonthlySalesProfSnapshotBatch(Date scheduleDate,Boolean chain, Boolean historical){
        triggerDate = scheduleDate;
        chainBatch = chain;
        histVal = historical;
    }           
    
    public Database.QueryLocator start(Database.BatchableContext con){
        /*
        List<String> fldList1 = new List<String>{prefix+'of_annual_leads_to_achieve_quota__c',prefix+'Quarterly_Lead_Added__c',prefix+ 'of_annual_opptys_req_to_achieve_quot__c',prefix+  'of_annual_qualified_opptys__c',prefix+    'of_daily_leads_to_achieve_quota__c',prefix+   'of_leads_for_1_qualified_oppty__c',prefix+    'of_leads_for_1_win__c',prefix+    'of_monthly_leads_to_achieve_quota__c',prefix+ 'of_monthly_opptys_req_to_achieve_quo__c',prefix+  'of_monthly_qualified_opptys__c',prefix+   'of_quarterly_leads_to_achieve_quota__c',prefix+   'of_quarterly_qualified_opptys__c',prefix+ 'of_quartly_opptys_req_to_achieve_quo__c',prefix+  'of_wins_to_achieve_annual_quota__c',prefix+   'of_wins_to_achieve_monthly_quota__c',prefix+  'of_wins_to_achieve_quarterly_quota__c',prefix+    'X12_Month_Average_Selling_Price__c',prefix+   'X12_Month_Lead_Conv_for_1_oppty__c',prefix+   'X12_Month_Leads_Added__c',prefix+ 'X12_Month_Opportunities_added_percentage__c',prefix+  'X12_Month_Opprties_Added_to_the_funnel__c',prefix+    'X12_Month_Revenue_Close_Rate__c',prefix+  'X12_Month_Rolling_Close_Rate__c', prefix+ 'X12_Month_Rolling_Average_Sales_Cycle__c',prefix+ 'X12_Month_Rolling_Opportunity_Close_Rate__c',prefix+  'X12_Month_Rolling_Opptys_Won__c', prefix+ 'X12_Month_Rolling_Opptys_Won_percentage__c', prefix+  'X12_Month_Rolling_Quota__c', prefix+  'X12_Month_Rolling_Quota_Performance__c', prefix+  'X12_Month_Rolling_Revenue__c',prefix+ 'X12_Month_Rolling_Win_Percentage__c',prefix+  'Annual_Opportunity_Quota__c', prefix+ 'Annual_Quota_Amount__c', prefix+  'Annual_Win_Quota__c', prefix+ 'Average_Sales_Price__c', prefix+  'Current_Active_Opportunities__c', prefix+ 'Current_Fiscal_Months__c',prefix+ 'Goal_of_annual_leads_to_achieve_quota__c',prefix+ 'Goal_of_annual_opptys_added_to_funnel__c',prefix+ 'Goal_of_daily_leads_to_achieve_quota__c',prefix+  'Goal_of_leads_for_1_qualified_oppty__c',prefix+   'Goal_of_leads_for_1_win__c',prefix+   'Goal_of_monthly_leads_to_achieve_quota__c',prefix+    'Goal_of_monthly_meetings__c',prefix+  'Goal_of_monthly_opptys_added_to_funnel__c', prefix+   'Goal_of_quartly_leads_to_achieve_quota__c', prefix+   'Goal_of_quartly_opptys_added_to_funnel__c', prefix+   'Goal_of_wins_to_achieve_annual_quota__c',prefix+  'Goal_of_wins_to_achieve_monthly_quota__c', prefix+'Goal_of_wins_to_achieve_quartly_quota__c', prefix+'Goal_12m_Avg_Selling_Price__c', prefix+   'Goal_12m_Lead_To_Opp_Conv_Rate__c',  prefix+  'Goal_12m_length_of_sales_cycle__c', prefix+   'Goal_12_Month_Opportunitie_added_funnel__c', prefix+  'Goal_12_Month_Rolling_Opptys_Won__c', prefix+ 'Goal_12m_rolling_close_rate__c',prefix+   'Goal_Number_of_meetings_12_months__c',prefix+ 'Goal_YTD_Opportunities_Added__c', prefix+ 'Lead_to_Opportunity_Conversion_Rate__c', prefix+  'Monthly_Close_Rate__c', prefix+   'Monthly_Average_Win_size__c',prefix+  'Monthly_Lead_Added__c', prefix+   'Monthly_Opp_added_to_Qualif_Percentage__c',  prefix+  'Monthly_opp_lost__c',prefix+  'Monthly_Opportunities_added_to_Qualifie__c',prefix+   'Monthly_Opportunities_Closed_percentage__c', prefix+  'Monthly_Opportunity_Close_Rate__c', prefix+   'Monthly_Opportunity_Quota__c',prefix+ 'Monthly_opp_won__c',prefix+   'Monthly_Quota_Performance__c',prefix+ 'Monthly_Quota_Revenue__c',prefix+ 'Monthly_Wins__c',prefix+  'Number_of_meetings_12_months_percentage__c',prefix+   'Number_of_meetings_per_month__c', prefix+ 'Number_of_meetings_per_month_percentage__c',prefix+   'Number_of_meetings_per_quarte_percentage__c',prefix+  'Number_of_meetings_per_quarter__c',prefix+    'Number_of_meetings_Rolling_12_months__c',prefix+  'Number_of_meetings_YTD__c',prefix+    'Number_of_meetings_YTD_percentage__c',prefix+ 'Q1_Quota_Amount__c', prefix+  'Q2_Quota_Amount__c', prefix+  'Q3_Quota_Amount__c', prefix+  'Q4_Quota_Amount__c', prefix+  'Quarterly_Close_Rate__c', prefix+ 'Quarterly_Average_Win_Size__c', prefix+   'Quarterly_Opp_added_to_Qualif_Percentage__c',prefix+  'Quarterly_Opportunitie_Closed_percentage__c',prefix+  'Quarterly_Opportunities_added_to_Qualifi__c',prefix+  'Quarterly_Opportunity_Close_Rate__c', prefix+ 'Quarterly_Opportunity_Quota__c',prefix+   'Quarterly_opp_won__c',prefix+ 'Quarterly_Quota_Performance__c',prefix+   'Quarterly_Quota_Revenue__c', prefix+  'Quarterly_Wins__c',prefix+    'Rep_Staus__c',prefix+ 'Role__c',prefix+  'Role_change_date__c',prefix+  'Sales_Manager__c',prefix+ 'Sales_Manager_Id__c', prefix+ 'Sales_Manager_Name__c', prefix+   'Sales_Rep_id__c',prefix+  'Sales_Rep_Profile__c',prefix+ 'Sales_Rep_Start_Date__c',prefix+  'Sales_Title__c',prefix+   'Snapshot_Scheduled_Date__c',prefix+   'Tenure__c', prefix+   'Tenure_in_current_role__c', prefix+   'Territory__c', prefix+'User_Record_Name__c', prefix+ 'YTD_Close_Rate__c',prefix+    'YTD_Average_win_size__c',prefix+  'YTD_Average_Sales_Cycle__c',prefix+   'YTD_Leads_Added__c', prefix+  'YTD_Opportunities_Added__c', prefix+  'YTD_Opportunities_Added_percentage__c',  prefix+  'YTD_Opportunities_Closed_percentage__c', prefix+  'YTD_Opportunities_Won__c',prefix+ 'YTD_Opportunity_Close_Rate__c',  prefix+  'YTD_Quota__c',prefix+ 'YTD_Quota_Percentage__c', prefix+ 'YTD_Revenue__c', prefix+  'YTD_Revenue_Close_Rate__c',  prefix+  'YTD_Revenue_Quota_Percent__c',prefix+ 'YTD_Win_Percentage__c',prefix+'Close_rate_monthly_opp_amount__c',prefix+'Close_rate_monthly_opp_count__c',prefix+'Close_rate_Quarterly_opp_amount__c',prefix+'Close_rate_Quarterly_opp_count__c',prefix+'Close_rate_YTD_opp_amount__c',prefix+'Close_rate_YTD_opp_count__c',prefix+ 'Ytd_QO_added_Quantitative__c',prefix+ 'Level_picklist_1__c',prefix+ 'Level_picklist_2__c',prefix+ 'Level_picklist_3__c',prefix+ 'Level_picklist_4__c',prefix+ 'Level_picklist_5__c',prefix+ 'Level_picklist_6__c', prefix+'Level_picklist_7__c', prefix+'Level_picklist_8__c',prefix+'Level_picklist_9__c',prefix+ 'Level_picklist_10__c',prefix+'Quarterly_QO_added_Quantitative__c'};

        Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile_Snapshot__c').getDescribe().fields.getMap();
        
        for(String fldName: fldList1){
            if(!fieldMap1.get(fldName).getDescribe().isCreateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              createAccess = false;
              break;
            }                
        }
        */
        
        DateTime tdt = triggerDate;
        String datTim = tdt.format('yyyy-MM-dd');

        return Database.getQueryLocator('SELECT Id,X12_Month_Avg_Length_of_Sales_Cycle_Per__c ,YTD_lead_conversion_percentage__c,Monthly_lead_converted__c,Quarterly_Lead_Converted__c,YTD_Lead_Converted__c,X12_Month_Lead_Converted__c,Monthly_Lead_Conversion_rate__c,Quarterly_Lead_Conversion_rate__c,YTD_Lead_Conversion_rate__c,X12_Month_Lead_Conversion_rate__c,Placeholder__c,Profile_Type__c,Dont_send_to_model__c,YTDQP__c,YTD_Lead_Added_Percentage__c,Ytd_Funnel_Opportunities__c,YTD_Opportunities_Added_amt__c,YTD_Avg_Length_of_Sales_Cycle_percentage__c,Quartile__c,Quarterly_Opp_Added_amt_percentage__c,Quarterly_Lead_Added_Percentage__c,Quarterly_Funnel_Opportunities__c,On_boarding_Date__c,Monthly_Lead_Added_Percentage__c,Monthly_funnel_opportunities__c,Monthly_Opp_Added_amt_percentage__c,Month_9_Quota_Amount__c,Month_8_Quota_Amount__c,Month_7_Quota_Amount__c,Month_6_Quota_Amount__c,Month_5_Quota_Amount__c,Month_4_Quota_Amount__c,Month_3_Quota_Amount__c,Month_2_Quota_Amount__c,Month_1_Quota_Amount__c,Month_12_Quota_Amount__c,Month_11_Quota_Amount__c,Month_10_Quota_Amount__c,Manger_Id__c,Manger_Name__c,Interim_Manager__c,Goal_12Month_Rolling_Opptys_Won_amt__c,Goal_12_Month_Lead_Added__c,Goal_of_YTD_leads_to_achieve_quota__c,Current_Pipeline__c,X18CharSalesRepID__c,X12_Month_Rolling_Lead_Added_Percentage__c,X12_Month_funnel_amt__c,Goal_of_quarterly_meetings__c,Monthly_quota__c,Quarterly_Quota__c,Goal_of_YTD_meetings__c,Goal_of_wins_to_achieve_YTD_quota__c,Goal_Average_Deal_Size__c,Average_Deal_Size_Percentage__c ,Average_Deal_Size__c,New_or_Tenured__c,Avg_Annual_Rev_Perf_For_Tenured_Role__c,Time_to_Tenured_Average_Rev__c ,Avg_ann_Rev_Perf_of_Tenured_Rep_Role__c ,Avg_ann_Rev_Perf_of_Tenured_Rep__c,Projected_Annualized_Revenue__c,Monthly_Average_Win_size_percentage__c, Quarterly_Average_Win_Size_percentage__c, YTD_Average_Win_Size_percentage__c, X12_Month_Rolling_Average_Win_Size_perc__c, Active__c, name,Goal_12m_rolling_amt_close_rate__c,Goal_12Month_Rolling_Opptys_Added_amt__c,Monthly_Lead_to_Opp_Conversion_Rate__c,Monthly_Opportunities_Added_amt__c,Quarterly_Lead_to_Opp_Conversion_Rate__c,Quarterly_Opportunities_Added_amt__c,Monthly_lost_QO__c,Monthly_lost_QO_Amt__c,Monthly_QO_added__c,Quarterly_lost_QO__c,Quarterly_lost_QO_Amt__c,Quarterly_QO_added__c,Ytd_lost_QO__c,Ytd_lost_QO_Amt__c,Ytd_QO_added__c,X12_Month_QO_added__c,Quarterly_Lead_Added__c, of_annual_leads_to_achieve_quota__c,  of_annual_opptys_req_to_achieve_quota__c,    of_annual_qualified_opptys__c,  of_daily_leads_to_achieve_quota__c, of_leads_for_1_qualified_oppty__c,  of_leads_for_1_win__c,  of_monthly_leads_to_achieve_quota__c,   of_monthly_opptys_req_to_achieve_quota__c,    of_monthly_qualified_opptys__c, of_quarterly_leads_to_achieve_quota__c, of_quarterly_qualified_opptys__c,   of_quartly_opptys_req_to_achieve_quota__c,    of_wins_to_achieve_annual_quota__c, of_wins_to_achieve_monthly_quota__c,    of_wins_to_achieve_quarterly_quota__c,  X12_Month_Average_Selling_Price__c, X12_Month_Lead_Conv_for_1_oppty__c, X12_Month_Leads_Added__c,   X12_Month_Opportunities_added_percentage__c,    X12_Month_Opprties_Added_to_the_funnel__c,  X12_Month_Revenue_Close_Rate__c,    X12_Month_Rolling_Close_Rate__c,    X12_Month_Rolling_Average_Sales_Cycle__c,   X12_Month_Rolling_Opportunity_Close_Rate__c,    X12_Month_Rolling_Opptys_Won__c,    X12_Month_Rolling_Opptys_Won_percentage__c, X12_Month_Rolling_Quota__c, X12_Month_Rolling_Quota_Performance__c, X12_Month_Rolling_Revenue__c,   X12_Month_Rolling_Win_Percentage__c,    Annual_Opportunity_Quota__c,    Annual_Quota_Amount__c, Annual_Win_Quota__c,    Average_Sales_Price__c, Current_Active_Opportunities__c,    Current_Fiscal_Months__c,   Goal_of_annual_leads_to_achieve_quota__c,   Goal_of_annual_opptys_added_to_funnel__c,   Goal_of_daily_leads_to_achieve_quota__c,    Goal_of_leads_for_1_qualified_oppty__c, Goal_of_leads_for_1_win__c, Goal_of_monthly_leads_to_achieve_quota__c,  Goal_of_monthly_meetings__c,    Goal_of_monthly_opptys_added_to_funnel__c,  Goal_of_quartly_leads_to_achieve_quota__c,  Goal_of_quartly_opptys_added_to_funnel__c,  Goal_of_wins_to_achieve_annual_quota__c,    Goal_of_wins_to_achieve_monthly_quota__c,   Goal_of_wins_to_achieve_quartly_quota__c,   Goal_12m_Avg_Selling_Price__c,  Goal_12m_Lead_To_Opp_Conv_Rate__c,  Goal_12m_length_of_sales_cycle__c,  Goal_12_Month_Opportunitie_added_funnel__c, Goal_12_Month_Rolling_Opptys_Won__c,    Goal_12m_rolling_close_rate__c, Goal_Number_of_meetings_12_months__c,   Goal_YTD_Opportunities_Added__c,    Lead_to_Opportunity_Conversion_Rate__c, Monthly_Close_Rate__c,  Monthly_Average_Win_size__c,    Monthly_Lead_Added__c,  Monthly_Opp_added_to_Qualif_Percentage__c,  Monthly_opp_lost__c,    Monthly_Opportunities_added_to_Qualifie__c, Monthly_Opportunities_Closed_percentage__c, Monthly_Opportunity_Close_Rate__c,  Monthly_Opportunity_Quota__c,   Monthly_opp_won__c, Monthly_Quota_Performance__c,   Monthly_Quota_Revenue__c,   Monthly_Wins__c,    Number_of_meetings_12_months_percentage__c, Number_of_meetings_per_month__c,    Number_of_meetings_per_month_percentage__c, Number_of_meetings_per_quarte_percentage__c,    Number_of_meetings_per_quarter__c,  Number_of_meetings_Rolling_12_months__c,    Number_of_meetings_YTD__c,  Number_of_meetings_YTD_percentage__c,   Q1_Quota_Amount__c, Q2_Quota_Amount__c, Q3_Quota_Amount__c, Q4_Quota_Amount__c, Quarterly_Close_Rate__c,    Quarterly_Average_Win_Size__c,  Quarterly_Opp_added_to_Qualif_Percentage__c,    Quarterly_Opportunitie_Closed_percentage__c,    Quarterly_Opportunities_added_to_Qualifi__c,    Quarterly_Opportunity_Close_Rate__c,    Quarterly_Opportunity_Quota__c, Quarterly_opp_won__c,   Quarterly_Quota_Performance__c, Quarterly_Quota_Revenue__c, Quarterly_Wins__c,  Rep_Staus__c,   Role__c,    Role_change_date__c,    Sales_Manager__c,  Rep_Start_Date__c,    Sales_Title__c,  Tenure__c,  Tenure_in_current_role__c,  Territory__c,   User_Record_Name__c,    YTD_Close_Rate__c,  YTD_Average_win_size__c,    YTD_Average_Sales_Cycle__c, YTD_Leads_Added__c, YTD_Opportunities_Added__c, YTD_Opportunities_Added_percentage__c,  YTD_Opportunities_Closed_percentage__c, YTD_Opportunities_Won__c,   YTD_Opportunity_Close_Rate__c,  YTD_Quota__c,   YTD_Quota_Percentage__c,    YTD_Revenue__c, YTD_Revenue_Close_Rate__c,  YTD_Revenue_Quota_Percent__c,   YTD_Win_Percentage__c, Close_rate_monthly_opp_amount__c, Close_rate_monthly_opp_count__c, Close_rate_Quarterly_opp_amount__c, Close_rate_Quarterly_opp_count__c, Close_rate_YTD_opp_amount__c, Close_rate_YTD_opp_count__c, Monthly_QO_added_Quantitative__c, Quarterly_QO_added_Quantitative__c, Ytd_QO_added_Quantitative__c, Level_picklist_1__c, Level_picklist_2__c, Level_picklist_3__c, Level_picklist_4__c, Level_picklist_5__c, Level_picklist_6__c, Level_picklist_7__c, Level_picklist_8__c, Level_picklist_9__c, Level_picklist_10__c, FMCustom_Metric_1__c, FMCustom_Metric_2__c, FMCustom_Metric_3__c, FMCustom_Metric_4__c, FMCustom_Metric_5__c, FMCustom_Metric_6__c, FMCustom_Metric_7__c, FMCustom_Metric_8__c, FMCustom_Metric_9__c, FMCustom_Metric_10__c,FMCustom_Metric_11__c,FMCustom_Metric_12__c,FMCustom_Metric_13__c,FMCustom_Metric_14__c,FMCustom_Metric_15__c,FMCustom_Metric_16__c,FMCustom_Metric_17__c,FMCustom_Metric_18__c,FMCustom_Metric_19__c,FMCustom_Metric_20__c,FMCustom_Metric_21__c,FMCustom_Metric_22__c,FMCustom_Metric_23__c,FMCustom_Metric_24__c,FMCustom_Metric_25__c,FMCustom_Metric_26__c,FMCustom_Metric_27__c,FMCustom_Metric_28__c, FMCustom_Metric_1_percentage__c,  FMCustom_Metric_2_percentage__c,  FMCustom_Metric_3_percentage__c,  FMCustom_Metric_4_percentage__c,  FMCustom_Metric_5_percentage__c,  FMCustom_Metric_6_percentage__c,  FMCustom_Metric_7_percentage__c,  FMCustom_Metric_8_percentage__c,  FMCustom_Metric_9_percentage__c,  FMCustom_Metric_10_percentage__c, FMCustom_Metric_11_percentage__c, FMCustom_Metric_12_percentage__c, FMCustom_Metric_13_percentage__c, FMCustom_Metric_14_percentage__c, FMCustom_Metric_15_percentage__c, FMCustom_Metric_16_percentage__c, FMCustom_Metric_17_percentage__c, FMCustom_Metric_18_percentage__c, FMCustom_Metric_19_percentage__c, FMCustom_Metric_20_percentage__c, FMCustom_Metric_21_percentage__c, FMCustom_Metric_22_percentage__c, FMCustom_Metric_23_percentage__c, FMCustom_Metric_24_percentage__c, FMCustom_Metric_25_percentage__c, FMCustom_Metric_26_percentage__c, FMCustom_Metric_27_percentage__c, FMCustom_Metric_28_percentage__c, FMCustom_Metric_1Goal__c, FMCustom_Metric_2Goal__c, FMCustom_Metric_3Goal__c, FMCustom_Metric_4Goal__c, FMCustom_Metric_5Goal__c, FMCustom_Metric_6Goal__c, FMCustom_Metric_7Goal__c, FMCustom_Metric_8Goal__c, FMCustom_Metric_9Goal__c, FMCustom_Metric_10Goal__c,FMCustom_Metric_11Goal__c,FMCustom_Metric_12Goal__c,FMCustom_Metric_13Goal__c,FMCustom_Metric_14Goal__c,FMCustom_Metric_15Goal__c,FMCustom_Metric_16Goal__c,FMCustom_Metric_17Goal__c,FMCustom_Metric_18Goal__c,FMCustom_Metric_19Goal__c,FMCustom_Metric_20Goal__c,FMCustom_Metric_21Goal__c,FMCustom_Metric_22Goal__c,FMCustom_Metric_23Goal__c,FMCustom_Metric_24Goal__c,FMCustom_Metric_25Goal__c,FMCustom_Metric_26Goal__c,FMCustom_Metric_27Goal__c,FMCustom_Metric_28Goal__c, X12_Month_Rolling_Opp_Close_Rate_perc__c, Monthly_close_rate_percentage__c, Monthly_opp_close_rate_percentage__c, Quarterly_Close_Rate_percentage__c, Quarterly_opp_close_rate_percentage__c, YTD_close_rate_percentage__c, YTD_lead_to_opp_conversion_percentage__c, YTD_opp_close_rate_percentage__c, X12_Month_Rolling_Close_Rate_percentage__c,FMCustom_Metric_29__c,FMCustom_Metric_30__c,FMCustom_Metric_31__c,FMCustom_Metric_32__c,FMCustom_Metric_33__c,FMCustom_Metric_34__c,FMCustom_Metric_35__c,FMCustom_Metric_36__c,FMCustom_Metric_37__c,FMCustom_Metric_38__c,FMCustom_Metric_39__c,FMCustom_Metric_40__c,FMCustom_Metric_41__c,FMCustom_Metric_42__c,FMCustom_Metric_43__c,FMCustom_Metric_44__c,FMCustom_Metric_45__c,FMCustom_Metric_46__c,FMCustom_Metric_47__c,FMCustom_Metric_48__c,FMCustom_Metric_49__c,FMCustom_Metric_50__c,FMCustom_Metric_29_percentage__c,FMCustom_Metric_30_percentage__c,FMCustom_Metric_31_percentage__c,FMCustom_Metric_32_percentage__c,FMCustom_Metric_33_percentage__c,FMCustom_Metric_34_percentage__c,FMCustom_Metric_35_percentage__c,FMCustom_Metric_36_percentage__c,FMCustom_Metric_37_percentage__c,FMCustom_Metric_38_percentage__c,FMCustom_Metric_39_percentage__c,FMCustom_Metric_40_percentage__c,FMCustom_Metric_41_percentage__c,FMCustom_Metric_42_percentage__c,FMCustom_Metric_43_percentage__c,FMCustom_Metric_44_percentage__c,FMCustom_Metric_45_percentage__c,FMCustom_Metric_46_percentage__c,FMCustom_Metric_47_percentage__c,FMCustom_Metric_48_percentage__c,FMCustom_Metric_49_percentage__c,FMCustom_Metric_50_percentage__c,FMCustom_Metric_29Goal__c,FMCustom_Metric_30Goal__c,FMCustom_Metric_31Goal__c,FMCustom_Metric_32Goal__c,FMCustom_Metric_33Goal__c,FMCustom_Metric_34Goal__c,FMCustom_Metric_35Goal__c,FMCustom_Metric_36Goal__c,FMCustom_Metric_37Goal__c,FMCustom_Metric_38Goal__c,FMCustom_Metric_39Goal__c,FMCustom_Metric_40Goal__c,FMCustom_Metric_41Goal__c,FMCustom_Metric_42Goal__c,FMCustom_Metric_43Goal__c,FMCustom_Metric_44Goal__c,FMCustom_Metric_45Goal__c,FMCustom_Metric_46Goal__c,FMCustom_Metric_47Goal__c,FMCustom_Metric_48Goal__c,FMCustom_Metric_49Goal__c,FMCustom_Metric_50Goal__c FROM Sales_Rep_Profile__c WHERE  (Active__c = TRUE OR Annual_Quota_Amount__c  >0 )  AND Rep_Start_Date__c <= '+datTim);
        
    }
    
    public void execute(Database.BatchableContext con, List<Sales_Rep_Profile__c> srp){
        try{    
        List<Sales_Rep_Profile_Snapshot__c> snapshotRecsToBeInserted = new List<Sales_Rep_Profile_Snapshot__c>();   
        
        if(createAccess){
                             
            for(Sales_Rep_Profile__c sp : srp){
            
                system.debug('sp name '+sp.name);
                Sales_Rep_Profile_Snapshot__c ss = new Sales_Rep_Profile_Snapshot__c();
                ss.name = sp.name;
                ss.Monthly_Average_Win_size_percentage__c = sp.Monthly_Average_Win_size_percentage__c;
                ss.of_annual_leads_to_achieve_quota__c  =   sp.of_annual_leads_to_achieve_quota__c;
                ss.of_annual_opptys_req_to_achieve_quot__c  =   sp.of_annual_opptys_req_to_achieve_quota__c;
                ss.of_annual_qualified_opptys__c    =   sp.of_annual_qualified_opptys__c;
                ss.of_daily_leads_to_achieve_quota__c   =   sp.of_daily_leads_to_achieve_quota__c;
                ss.of_leads_for_1_qualified_oppty__c    =   sp.of_leads_for_1_qualified_oppty__c;
                ss.of_leads_for_1_win__c    =   sp.of_leads_for_1_win__c;
                ss.of_monthly_leads_to_achieve_quota__c =   sp.of_monthly_leads_to_achieve_quota__c;
                ss.of_monthly_opptys_req_to_achieve_quo__c  =   sp.of_monthly_opptys_req_to_achieve_quota__c;
                ss.of_monthly_qualified_opptys__c   =   sp.of_monthly_qualified_opptys__c;
                ss.of_quarterly_leads_to_achieve_quota__c   =   sp.of_quarterly_leads_to_achieve_quota__c;
                ss.of_quarterly_qualified_opptys__c =   sp.of_quarterly_qualified_opptys__c;
                ss.of_quartly_opptys_req_to_achieve_quo__c  =   sp.of_quartly_opptys_req_to_achieve_quota__c;
                ss.of_wins_to_achieve_annual_quota__c   =   sp.of_wins_to_achieve_annual_quota__c;
                ss.of_wins_to_achieve_monthly_quota__c  =   sp.of_wins_to_achieve_monthly_quota__c;
                ss.of_wins_to_achieve_quarterly_quota__c    =   sp.of_wins_to_achieve_quarterly_quota__c;
                ss.X12_Month_Average_Selling_Price__c   =   sp.X12_Month_Average_Selling_Price__c;
                ss.X12_Month_funnel_amt__c=   sp.X12_Month_funnel_amt__c;
                ss.X12_Month_Lead_Conv_for_1_oppty__c   =   sp.X12_Month_Lead_Conv_for_1_oppty__c;
                ss.X12_Month_Leads_Added__c =   sp.X12_Month_Leads_Added__c;
                ss.X12_Month_Opportunities_added_percentage__c  =   sp.X12_Month_Opportunities_added_percentage__c;
                ss.X12_Month_Opprties_Added_to_the_funnel__c    =   sp.X12_Month_Opprties_Added_to_the_funnel__c;
                ss.X12_Month_Revenue_Close_Rate__c  =   sp.X12_Month_Revenue_Close_Rate__c;
                ss.X12_Month_Rolling_Close_Rate__c  =   sp.X12_Month_Rolling_Close_Rate__c;
                ss.X12_Month_Rolling_Average_Sales_Cycle__c =   sp.X12_Month_Rolling_Average_Sales_Cycle__c;
                ss.X12_Month_Rolling_Lead_Added_Percentage__c=   sp.X12_Month_Rolling_Lead_Added_Percentage__c;
                ss.X12_Month_Rolling_Opportunity_Close_Rate__c  =   sp.X12_Month_Rolling_Opportunity_Close_Rate__c;
                ss.X12_Month_Rolling_Opptys_Won__c  =   sp.X12_Month_Rolling_Opptys_Won__c;
                ss.X12_Month_Rolling_Opptys_Won_percentage__c   =   sp.X12_Month_Rolling_Opptys_Won_percentage__c;
                ss.X12_Month_Rolling_Quota__c   =   sp.X12_Month_Rolling_Quota__c;
                ss.X12_Month_Rolling_Quota_Performance__c   =   sp.X12_Month_Rolling_Quota_Performance__c;
                ss.X12_Month_Rolling_Revenue__c =   sp.X12_Month_Rolling_Revenue__c;
                ss.X12_Month_Rolling_Win_Percentage__c  =   sp.X12_Month_Rolling_Win_Percentage__c;
                ss.X18CharSalesRepID__c=   sp.X18CharSalesRepID__c;
                ss.Annual_Opportunity_Quota__c  =   sp.Annual_Opportunity_Quota__c;
                ss.Annual_Quota_Amount__c   =   sp.Annual_Quota_Amount__c;
                ss.Annual_Win_Quota__c  =   sp.Annual_Win_Quota__c;
                ss.Average_Sales_Price__c   =   sp.Average_Sales_Price__c;
                ss.Current_Active_Opportunities__c  =   sp.Current_Active_Opportunities__c;
                ss.Current_Pipeline__c=   sp.Current_Pipeline__c;
                
                ss.Goal_of_annual_leads_to_achieve_quota__c =   sp.Goal_of_annual_leads_to_achieve_quota__c;
                ss.Goal_of_annual_opptys_added_to_funnel__c =   sp.Goal_of_annual_opptys_added_to_funnel__c;
                ss.Goal_of_daily_leads_to_achieve_quota__c  =   sp.Goal_of_daily_leads_to_achieve_quota__c;
                ss.Goal_of_leads_for_1_qualified_oppty__c   =   sp.Goal_of_leads_for_1_qualified_oppty__c;
                ss.Goal_of_leads_for_1_win__c   =   sp.Goal_of_leads_for_1_win__c;
                ss.Goal_of_monthly_leads_to_achieve_quota__c    =   sp.Goal_of_monthly_leads_to_achieve_quota__c;
                ss.Goal_of_monthly_meetings__c  =   sp.Goal_of_monthly_meetings__c;
                ss.Goal_of_monthly_opptys_added_to_funnel__c    =   sp.Goal_of_monthly_opptys_added_to_funnel__c;
                ss.Goal_of_quartly_leads_to_achieve_quota__c    =   sp.Goal_of_quartly_leads_to_achieve_quota__c;
                ss.Goal_of_quartly_opptys_added_to_funnel__c    =   sp.Goal_of_quartly_opptys_added_to_funnel__c;
                ss.Goal_of_wins_to_achieve_annual_quota__c  =   sp.Goal_of_wins_to_achieve_annual_quota__c;
                ss.Goal_of_wins_to_achieve_monthly_quota__c =   sp.Goal_of_wins_to_achieve_monthly_quota__c;
                ss.Goal_of_wins_to_achieve_quartly_quota__c =   sp.Goal_of_wins_to_achieve_quartly_quota__c;
                ss.Goal_12m_Avg_Selling_Price__c    =   sp.Goal_12m_Avg_Selling_Price__c;
                ss.Goal_12m_Lead_To_Opp_Conv_Rate__c    =   sp.Goal_12m_Lead_To_Opp_Conv_Rate__c;
                ss.Goal_12m_length_of_sales_cycle__c    =   sp.Goal_12m_length_of_sales_cycle__c;
                ss.Goal_12_Month_Opportunitie_added_funnel__c   =   sp.Goal_12_Month_Opportunitie_added_funnel__c;
                ss.Goal_12_Month_Rolling_Opptys_Won__c  =   sp.Goal_12_Month_Rolling_Opptys_Won__c;
                ss.Goal_12m_rolling_close_rate__c   =   sp.Goal_12m_rolling_close_rate__c;
                ss.Goal_Number_of_meetings_12_months__c =   sp.Goal_Number_of_meetings_12_months__c;
                ss.Goal_YTD_Opportunities_Added__c  =   sp.Goal_YTD_Opportunities_Added__c;
                ss.Lead_to_Opportunity_Conversion_Rate__c   =   sp.Lead_to_Opportunity_Conversion_Rate__c;
                ss.Monthly_Close_Rate__c    =   sp.Monthly_Close_Rate__c;
                ss.Monthly_Average_Win_size__c  =   sp.Monthly_Average_Win_size__c;
                ss.Monthly_Opp_added_to_Qualif_Percentage__c    =   sp.Monthly_Opp_added_to_Qualif_Percentage__c;
                ss.Monthly_Opportunities_added_to_Qualifie__c   =   sp.Monthly_Opportunities_added_to_Qualifie__c;
                ss.Monthly_Opportunities_Closed_percentage__c   =   sp.Monthly_Opportunities_Closed_percentage__c;
                ss.Monthly_Opportunity_Close_Rate__c    =   sp.Monthly_Opportunity_Close_Rate__c;
                ss.Monthly_Opportunity_Quota__c =   sp.Monthly_Opportunity_Quota__c;
                ss.Monthly_opp_won__c   =   sp.Monthly_opp_won__c;
                ss.Monthly_Quota_Performance__c =   sp.Monthly_Quota_Performance__c;
                ss.Monthly_Quota_Revenue__c =   sp.Monthly_Quota_Revenue__c;
                ss.Monthly_Wins__c  =   sp.Monthly_Wins__c;
                ss.Number_of_meetings_12_months_percentage__c   =   sp.Number_of_meetings_12_months_percentage__c;
                ss.Number_of_meetings_per_month__c  =   sp.Number_of_meetings_per_month__c;
                ss.Number_of_meetings_per_month_percentage__c   =   sp.Number_of_meetings_per_month_percentage__c;
                ss.Number_of_meetings_per_quarte_percentage__c  =   sp.Number_of_meetings_per_quarte_percentage__c;
                ss.Number_of_meetings_per_quarter__c    =   sp.Number_of_meetings_per_quarter__c;
                ss.Number_of_meetings_Rolling_12_months__c  =   sp.Number_of_meetings_Rolling_12_months__c;
                ss.Number_of_meetings_YTD__c    =   sp.Number_of_meetings_YTD__c;
                ss.Number_of_meetings_YTD_percentage__c =   sp.Number_of_meetings_YTD_percentage__c;
                ss.Q1_Quota_Amount__c   =   sp.Q1_Quota_Amount__c;
                ss.Q2_Quota_Amount__c   =   sp.Q2_Quota_Amount__c;
                ss.Q3_Quota_Amount__c   =   sp.Q3_Quota_Amount__c;
                ss.Q4_Quota_Amount__c   =   sp.Q4_Quota_Amount__c;
                ss.Quarterly_Close_Rate__c  =   sp.Quarterly_Close_Rate__c;
                ss.Quarterly_Average_Win_Size__c    =   sp.Quarterly_Average_Win_Size__c;
                ss.Quarterly_Opp_added_to_Qualif_Percentage__c  =   sp.Quarterly_Opp_added_to_Qualif_Percentage__c;
                ss.Quarterly_Opportunitie_Closed_percentage__c  =   sp.Quarterly_Opportunitie_Closed_percentage__c;
                ss.Quarterly_Opportunities_added_to_Qualifi__c  =   sp.Quarterly_Opportunities_added_to_Qualifi__c;
                ss.Quarterly_Opportunity_Close_Rate__c  =   sp.Quarterly_Opportunity_Close_Rate__c;
                ss.Quarterly_Opportunity_Quota__c   =   sp.Quarterly_Opportunity_Quota__c;
                ss.Quarterly_opp_won__c =   sp.Quarterly_opp_won__c;
                ss.Quarterly_Quota_Performance__c   =   sp.Quarterly_Quota_Performance__c;
                ss.Quarterly_Quota_Revenue__c   =   sp.Quarterly_Quota_Revenue__c;
                ss.Quarterly_Wins__c    =   sp.Quarterly_Wins__c;
                ss.Rep_Staus__c =   sp.Rep_Staus__c;
                ss.Role__c  =   sp.Role__c;
                ss.Role_change_date__c  =   sp.Role_change_date__c;
                ss.Sales_Manager__c =   sp.Sales_Manager__c;
                ss.Sales_Rep_Start_Date__c  =   sp.Rep_Start_Date__c;
                ss.Sales_Title__c   =   sp.Sales_Title__c;
                ss.Tenure__c    =   sp.Tenure__c;
                
                ss.Territory__c =   sp.Territory__c;
                ss.User_Record_Name__c  =   sp.User_Record_Name__c;
                ss.YTD_Close_Rate__c    =   sp.YTD_Close_Rate__c;
                ss.YTD_Average_win_size__c  =   sp.YTD_Average_win_size__c;
                ss.YTD_Average_Sales_Cycle__c   =   sp.YTD_Average_Sales_Cycle__c;
                ss.YTD_Leads_Added__c   =   sp.YTD_Leads_Added__c;
                ss.YTD_Opportunities_Added__c   =   sp.YTD_Opportunities_Added__c;
                ss.YTD_Opportunities_Added_percentage__c    =   sp.YTD_Opportunities_Added_percentage__c;
                ss.YTD_Opportunities_Closed_percentage__c   =   sp.YTD_Opportunities_Closed_percentage__c;
                ss.YTD_Opportunities_Won__c =   sp.YTD_Opportunities_won__c;
                ss.YTD_Opportunity_Close_Rate__c    =   sp.YTD_Opportunity_Close_Rate__c;
                ss.YTD_Quota__c =   sp.YTD_Quota__c;
                ss.YTD_Quota_Percentage__c  =   sp.YTD_Quota_Percentage__c;
                ss.YTD_Revenue__c   =   sp.YTD_Revenue__c;
                ss.YTD_Revenue_Close_Rate__c    =   sp.YTD_Revenue_Close_Rate__c;
                ss.YTD_Revenue_Quota_Percent__c =   sp.YTD_Revenue_Quota_Percent__c;
                ss.YTD_Win_Percentage__c    =   sp.YTD_Win_Percentage__c;
                ss.Monthly_opp_lost__c  = sp.Monthly_opp_lost__c;
                ss.Quarterly_Lead_Added__c = sp.Quarterly_Lead_Added__c;
                ss.Sales_Rep_Profile__c =   sp.id;
                ss.Close_rate_monthly_opp_amount__c = sp.Close_rate_monthly_opp_amount__c;
                ss.Close_rate_monthly_opp_count__c = sp.Close_rate_monthly_opp_count__c;
                ss.Close_rate_Quarterly_opp_amount__c = sp.Close_rate_Quarterly_opp_amount__c;
                ss.Close_rate_Quarterly_opp_count__c = sp.Close_rate_Quarterly_opp_count__c;
                ss.Close_rate_YTD_opp_amount__c = sp.Close_rate_YTD_opp_amount__c;
                ss.Close_rate_YTD_opp_count__c = sp.Close_rate_YTD_opp_count__c;
                ss.Monthly_Lead_Added__c = sp.Monthly_Lead_Added__c;
                ss.Active__c = sp.Active__c;
                ss.Goal_12m_rolling_amt_close_rate__c = sp.Goal_12m_rolling_amt_close_rate__c; 
                ss.Goal_12Month_Rolling_Opptys_Added_amt__c = sp.Goal_12Month_Rolling_Opptys_Added_amt__c;
                ss.Monthly_Lead_to_Opp_Conversion_Rate__c = sp.Monthly_Lead_to_Opp_Conversion_Rate__c;
                ss.Monthly_Opportunities_Added_amt__c = sp.Monthly_Opportunities_Added_amt__c;
                ss.Quarterly_Lead_to_Opp_Conversion_Rate__c = sp.Quarterly_Lead_to_Opp_Conversion_Rate__c;
                ss.Quarterly_Opportunities_Added_amt__c = sp.Quarterly_Opportunities_Added_amt__c;
                ss.Monthly_lost_QO__c = sp.Monthly_lost_QO__c;
                ss.Monthly_lost_QO_Amt__c = sp.Monthly_lost_QO_Amt__c;
                ss.Monthly_QO_added_Quantitative__c = sp.Monthly_QO_added_Quantitative__c;
                ss.Quarterly_lost_QO__c = sp.Quarterly_lost_QO__c;
                ss.Quarterly_lost_QO_Amt__c = sp.Quarterly_lost_QO_Amt__c;
                ss.Quarterly_QO_added_Quantitative__c = sp.Quarterly_QO_added_Quantitative__c;
                ss.Ytd_lost_QO__c = sp.Ytd_lost_QO__c;
                ss.Ytd_lost_QO_Amt__c = sp.Ytd_lost_QO_Amt__c;
                ss.Ytd_QO_added_Quantitative__c = sp.Ytd_QO_added_Quantitative__c;
                ss.X12_Month_QO_added__c = sp.X12_Month_QO_added__c; 
                ss.Quarterly_Average_Win_Size_percentage__c = sp.Quarterly_Average_Win_Size_percentage__c;
                ss.YTD_Average_Win_Size_percentage__c = sp.YTD_Average_Win_Size_percentage__c;
                ss.X12_Month_Rolling_Average_Win_Size_perc__c = sp.X12_Month_Rolling_Average_Win_Size_perc__c;
                
                ss.Level_picklist_1__c = sp.Level_picklist_1__c;
                ss.Level_picklist_2__c = sp.Level_picklist_2__c;
                ss.Level_picklist_3__c = sp.Level_picklist_3__c;
                ss.Level_picklist_4__c = sp.Level_picklist_4__c;
                ss.Level_picklist_5__c = sp.Level_picklist_5__c;
                ss.Level_picklist_6__c = sp.Level_picklist_6__c;
                ss.Level_picklist_7__c = sp.Level_picklist_7__c;
                ss.Level_picklist_8__c = sp.Level_picklist_8__c;
                ss.Level_picklist_9__c = sp.Level_picklist_9__c;
                ss.Level_picklist_10__c = sp.Level_picklist_10__c;
                 

                ss.FMCustom_Metric_1__c = sp.FMCustom_Metric_1__c;
                ss.FMCustom_Metric_2__c = sp.FMCustom_Metric_2__c;
                ss.FMCustom_Metric_3__c = sp.FMCustom_Metric_3__c;
                ss.FMCustom_Metric_4__c = sp.FMCustom_Metric_4__c;
                ss.FMCustom_Metric_5__c = sp.FMCustom_Metric_5__c;
                ss.FMCustom_Metric_6__c = sp.FMCustom_Metric_6__c;
                ss.FMCustom_Metric_7__c = sp.FMCustom_Metric_7__c;
                ss.FMCustom_Metric_8__c = sp.FMCustom_Metric_8__c;
                ss.FMCustom_Metric_9__c = sp.FMCustom_Metric_9__c;
                ss.FMCustom_Metric_10__c = sp.FMCustom_Metric_10__c;
                ss.FMCustom_Metric_11__c = sp.FMCustom_Metric_11__c;
                ss.FMCustom_Metric_12__c = sp.FMCustom_Metric_12__c;
                ss.FMCustom_Metric_13__c = sp.FMCustom_Metric_13__c;
                ss.FMCustom_Metric_14__c = sp.FMCustom_Metric_14__c;
                ss.FMCustom_Metric_15__c = sp.FMCustom_Metric_15__c;
                ss.FMCustom_Metric_16__c = sp.FMCustom_Metric_16__c;
                ss.FMCustom_Metric_17__c = sp.FMCustom_Metric_17__c;
                ss.FMCustom_Metric_18__c = sp.FMCustom_Metric_18__c;
                ss.FMCustom_Metric_19__c = sp.FMCustom_Metric_19__c;
                ss.FMCustom_Metric_20__c = sp.FMCustom_Metric_20__c;
                ss.FMCustom_Metric_21__c = sp.FMCustom_Metric_21__c;
                ss.FMCustom_Metric_22__c = sp.FMCustom_Metric_22__c;
                ss.FMCustom_Metric_23__c = sp.FMCustom_Metric_23__c;
                ss.FMCustom_Metric_24__c = sp.FMCustom_Metric_24__c;
                ss.FMCustom_Metric_25__c = sp.FMCustom_Metric_25__c;
                ss.FMCustom_Metric_26__c = sp.FMCustom_Metric_26__c;
                ss.FMCustom_Metric_27__c = sp.FMCustom_Metric_27__c;
                ss.FMCustom_Metric_28__c = sp.FMCustom_Metric_28__c;
                ss.FMCustom_Metric_29__c = sp.FMCustom_Metric_29__c;
                ss.FMCustom_Metric_30__c = sp.FMCustom_Metric_30__c;
                ss.FMCustom_Metric_31__c = sp.FMCustom_Metric_31__c;
                ss.FMCustom_Metric_32__c = sp.FMCustom_Metric_32__c;
                ss.FMCustom_Metric_33__c = sp.FMCustom_Metric_33__c;
                ss.FMCustom_Metric_34__c = sp.FMCustom_Metric_34__c;
                ss.FMCustom_Metric_35__c = sp.FMCustom_Metric_35__c;
                ss.FMCustom_Metric_36__c = sp.FMCustom_Metric_36__c;
                ss.FMCustom_Metric_37__c = sp.FMCustom_Metric_37__c;
                ss.FMCustom_Metric_38__c = sp.FMCustom_Metric_38__c;
                ss.FMCustom_Metric_39__c = sp.FMCustom_Metric_39__c;
                ss.FMCustom_Metric_40__c = sp.FMCustom_Metric_40__c;
                ss.FMCustom_Metric_41__c = sp.FMCustom_Metric_41__c;
                ss.FMCustom_Metric_42__c = sp.FMCustom_Metric_42__c;
                ss.FMCustom_Metric_43__c = sp.FMCustom_Metric_43__c;
                ss.FMCustom_Metric_44__c = sp.FMCustom_Metric_44__c;
                ss.FMCustom_Metric_45__c = sp.FMCustom_Metric_45__c;
                ss.FMCustom_Metric_46__c = sp.FMCustom_Metric_46__c;
                ss.FMCustom_Metric_47__c = sp.FMCustom_Metric_47__c;
                ss.FMCustom_Metric_48__c = sp.FMCustom_Metric_48__c;
                ss.FMCustom_Metric_49__c = sp.FMCustom_Metric_49__c;
                ss.FMCustom_Metric_50__c = sp.FMCustom_Metric_50__c;
                 

                ss.FMCustom_Metric_1_percentage__c = sp.FMCustom_Metric_1_percentage__c;
                ss.FMCustom_Metric_2_percentage__c = sp.FMCustom_Metric_2_percentage__c;
                ss.FMCustom_Metric_3_percentage__c = sp.FMCustom_Metric_3_percentage__c;
                ss.FMCustom_Metric_4_percentage__c = sp.FMCustom_Metric_4_percentage__c;
                ss.FMCustom_Metric_5_percentage__c = sp.FMCustom_Metric_5_percentage__c;
                ss.FMCustom_Metric_6_percentage__c = sp.FMCustom_Metric_6_percentage__c;
                ss.FMCustom_Metric_7_percentage__c = sp.FMCustom_Metric_7_percentage__c;
                ss.FMCustom_Metric_8_percentage__c = sp.FMCustom_Metric_8_percentage__c;
                ss.FMCustom_Metric_9_percentage__c = sp.FMCustom_Metric_9_percentage__c;
                ss.FMCustom_Metric_10_percentage__c = sp.FMCustom_Metric_10_percentage__c;
                ss.FMCustom_Metric_11_percentage__c = sp.FMCustom_Metric_11_percentage__c;
                ss.FMCustom_Metric_12_percentage__c = sp.FMCustom_Metric_12_percentage__c;
                ss.FMCustom_Metric_13_percentage__c = sp.FMCustom_Metric_13_percentage__c;
                ss.FMCustom_Metric_14_percentage__c = sp.FMCustom_Metric_14_percentage__c;
                ss.FMCustom_Metric_15_percentage__c = sp.FMCustom_Metric_15_percentage__c;
                ss.FMCustom_Metric_16_percentage__c = sp.FMCustom_Metric_16_percentage__c;
                ss.FMCustom_Metric_17_percentage__c = sp.FMCustom_Metric_17_percentage__c;
                ss.FMCustom_Metric_18_percentage__c = sp.FMCustom_Metric_18_percentage__c;
                ss.FMCustom_Metric_19_percentage__c = sp.FMCustom_Metric_19_percentage__c;
                ss.FMCustom_Metric_20_percentage__c = sp.FMCustom_Metric_20_percentage__c;
                ss.FMCustom_Metric_21_percentage__c = sp.FMCustom_Metric_21_percentage__c;
                ss.FMCustom_Metric_22_percentage__c = sp.FMCustom_Metric_22_percentage__c;
                ss.FMCustom_Metric_23_percentage__c = sp.FMCustom_Metric_23_percentage__c;
                ss.FMCustom_Metric_24_percentage__c = sp.FMCustom_Metric_24_percentage__c;
                ss.FMCustom_Metric_25_percentage__c = sp.FMCustom_Metric_25_percentage__c;
                ss.FMCustom_Metric_26_percentage__c = sp.FMCustom_Metric_26_percentage__c;
                ss.FMCustom_Metric_27_percentage__c = sp.FMCustom_Metric_27_percentage__c;
                ss.FMCustom_Metric_28_percentage__c = sp.FMCustom_Metric_28_percentage__c;
                ss.FMCustom_Metric_29_percentage__c = sp.FMCustom_Metric_29_percentage__c;
                ss.FMCustom_Metric_30_percentage__c = sp.FMCustom_Metric_30_percentage__c;
                ss.FMCustom_Metric_31_percentage__c = sp.FMCustom_Metric_31_percentage__c;
                ss.FMCustom_Metric_32_percentage__c = sp.FMCustom_Metric_32_percentage__c;
                ss.FMCustom_Metric_33_percentage__c = sp.FMCustom_Metric_33_percentage__c;
                ss.FMCustom_Metric_34_percentage__c = sp.FMCustom_Metric_34_percentage__c;
                ss.FMCustom_Metric_35_percentage__c = sp.FMCustom_Metric_35_percentage__c;
                ss.FMCustom_Metric_36_percentage__c = sp.FMCustom_Metric_36_percentage__c;
                ss.FMCustom_Metric_37_percentage__c = sp.FMCustom_Metric_37_percentage__c;
                ss.FMCustom_Metric_38_percentage__c = sp.FMCustom_Metric_38_percentage__c;
                ss.FMCustom_Metric_39_percentage__c = sp.FMCustom_Metric_39_percentage__c;
                ss.FMCustom_Metric_40_percentage__c = sp.FMCustom_Metric_40_percentage__c;
                ss.FMCustom_Metric_41_percentage__c = sp.FMCustom_Metric_41_percentage__c;
                ss.FMCustom_Metric_42_percentage__c = sp.FMCustom_Metric_42_percentage__c;
                ss.FMCustom_Metric_43_percentage__c = sp.FMCustom_Metric_43_percentage__c;
                ss.FMCustom_Metric_44_percentage__c = sp.FMCustom_Metric_44_percentage__c;
                ss.FMCustom_Metric_45_percentage__c = sp.FMCustom_Metric_45_percentage__c;
                ss.FMCustom_Metric_46_percentage__c = sp.FMCustom_Metric_46_percentage__c;
                ss.FMCustom_Metric_47_percentage__c = sp.FMCustom_Metric_47_percentage__c;
                ss.FMCustom_Metric_48_percentage__c = sp.FMCustom_Metric_48_percentage__c;
                ss.FMCustom_Metric_49_percentage__c = sp.FMCustom_Metric_49_percentage__c;
                ss.FMCustom_Metric_50_percentage__c = sp.FMCustom_Metric_50_percentage__c;
                                 
                ss.FMCustom_Metric_1Goal__c = sp.FMCustom_Metric_1Goal__c;
                ss.FMCustom_Metric_2Goal__c = sp.FMCustom_Metric_2Goal__c;
                ss.FMCustom_Metric_3Goal__c = sp.FMCustom_Metric_3Goal__c;
                ss.FMCustom_Metric_4Goal__c = sp.FMCustom_Metric_4Goal__c;
                ss.FMCustom_Metric_5Goal__c = sp.FMCustom_Metric_5Goal__c;
                ss.FMCustom_Metric_6Goal__c = sp.FMCustom_Metric_6Goal__c;
                ss.FMCustom_Metric_7Goal__c = sp.FMCustom_Metric_7Goal__c;
                ss.FMCustom_Metric_8Goal__c = sp.FMCustom_Metric_8Goal__c;
                ss.FMCustom_Metric_9Goal__c = sp.FMCustom_Metric_9Goal__c;
                ss.FMCustom_Metric_10Goal__c = sp.FMCustom_Metric_10Goal__c;
                ss.FMCustom_Metric_11Goal__c = sp.FMCustom_Metric_11Goal__c;
                ss.FMCustom_Metric_12Goal__c = sp.FMCustom_Metric_12Goal__c;
                ss.FMCustom_Metric_13Goal__c = sp.FMCustom_Metric_13Goal__c;
                ss.FMCustom_Metric_14Goal__c = sp.FMCustom_Metric_14Goal__c;
                ss.FMCustom_Metric_15Goal__c = sp.FMCustom_Metric_15Goal__c;
                ss.FMCustom_Metric_16Goal__c = sp.FMCustom_Metric_16Goal__c;
                ss.FMCustom_Metric_17Goal__c = sp.FMCustom_Metric_17Goal__c;
                ss.FMCustom_Metric_18Goal__c = sp.FMCustom_Metric_18Goal__c;
                ss.FMCustom_Metric_19Goal__c = sp.FMCustom_Metric_19Goal__c;
                ss.FMCustom_Metric_20Goal__c = sp.FMCustom_Metric_20Goal__c;
                ss.FMCustom_Metric_21Goal__c = sp.FMCustom_Metric_21Goal__c;
                ss.FMCustom_Metric_22Goal__c = sp.FMCustom_Metric_22Goal__c;
                ss.FMCustom_Metric_23Goal__c = sp.FMCustom_Metric_23Goal__c;
                ss.FMCustom_Metric_24Goal__c = sp.FMCustom_Metric_24Goal__c;
                ss.FMCustom_Metric_25Goal__c = sp.FMCustom_Metric_25Goal__c;
                ss.FMCustom_Metric_26Goal__c = sp.FMCustom_Metric_26Goal__c;
                ss.FMCustom_Metric_27Goal__c = sp.FMCustom_Metric_27Goal__c;
                ss.FMCustom_Metric_28Goal__c = sp.FMCustom_Metric_28Goal__c;
                ss.FMCustom_Metric_29Goal__c = sp.FMCustom_Metric_29Goal__c;
                ss.FMCustom_Metric_30Goal__c = sp.FMCustom_Metric_30Goal__c;
                ss.FMCustom_Metric_31Goal__c = sp.FMCustom_Metric_31Goal__c;
                ss.FMCustom_Metric_32Goal__c = sp.FMCustom_Metric_32Goal__c;
                ss.FMCustom_Metric_33Goal__c = sp.FMCustom_Metric_33Goal__c;
                ss.FMCustom_Metric_34Goal__c = sp.FMCustom_Metric_34Goal__c;
                ss.FMCustom_Metric_35Goal__c = sp.FMCustom_Metric_35Goal__c;
                ss.FMCustom_Metric_36Goal__c = sp.FMCustom_Metric_36Goal__c;
                ss.FMCustom_Metric_37Goal__c = sp.FMCustom_Metric_37Goal__c;
                ss.FMCustom_Metric_38Goal__c = sp.FMCustom_Metric_38Goal__c;
                ss.FMCustom_Metric_39Goal__c = sp.FMCustom_Metric_39Goal__c;
                ss.FMCustom_Metric_40Goal__c = sp.FMCustom_Metric_40Goal__c;
                ss.FMCustom_Metric_41Goal__c = sp.FMCustom_Metric_41Goal__c;
                ss.FMCustom_Metric_42Goal__c = sp.FMCustom_Metric_42Goal__c;
                ss.FMCustom_Metric_43Goal__c = sp.FMCustom_Metric_43Goal__c;
                ss.FMCustom_Metric_44Goal__c = sp.FMCustom_Metric_44Goal__c;
                ss.FMCustom_Metric_45Goal__c = sp.FMCustom_Metric_45Goal__c;
                ss.FMCustom_Metric_46Goal__c = sp.FMCustom_Metric_46Goal__c;
                ss.FMCustom_Metric_47Goal__c = sp.FMCustom_Metric_47Goal__c;
                ss.FMCustom_Metric_48Goal__c = sp.FMCustom_Metric_48Goal__c;
                ss.FMCustom_Metric_49Goal__c = sp.FMCustom_Metric_49Goal__c;
                ss.FMCustom_Metric_50Goal__c = sp.FMCustom_Metric_50Goal__c;
                
                
                ss.Projected_Annualized_Revenue__c = sp.Projected_Annualized_Revenue__c;
                
                ss.Avg_ann_Rev_Perf_of_Tenured_Rep__c = sp.Avg_ann_Rev_Perf_of_Tenured_Rep__c;
                ss.Avg_ann_Rev_Perf_of_Tenured_Rep_Role__c = sp.Avg_ann_Rev_Perf_of_Tenured_Rep_Role__c;      
                
               // ss.Avg_12_Month_Rev_Perf_of_Tenured_Rep__c= sp.Avg_12_Month_Rev_Perf_of_Tenured_Rep__c;      
               
                ss.Time_to_Tenured_Average_Rev__c   = sp.Time_to_Tenured_Average_Rev__c   ;
                ss.Avg_Annual_Rev_Perf_For_Tenured_Role__c = sp.Avg_Annual_Rev_Perf_For_Tenured_Role__c;
                
                ss.Goal_Average_Deal_Size__c = sp.Goal_Average_Deal_Size__c ;
                ss.Average_Deal_Size__c = sp.Average_Deal_Size__c ;
                ss.Average_Deal_Size_Percentage__c = sp.Average_Deal_Size_Percentage__c;
                ss.New_or_Tenured__c = sp.New_or_Tenured__c;
                
                ss.X12_Month_Rolling_Close_Rate_percentage__c = sp.X12_Month_Rolling_Close_Rate_percentage__c;
                ss.X12_Month_Rolling_Opp_Close_Rate_perc__c = sp.X12_Month_Rolling_Opp_Close_Rate_perc__c ;
                ss.Monthly_close_rate_percentage__c = sp.Monthly_close_rate_percentage__c;
                ss.Monthly_opp_close_rate_percentage__c = sp.Monthly_opp_close_rate_percentage__c;
                ss.Quarterly_Close_Rate_percentage__c = sp.Quarterly_Close_Rate_percentage__c;
                ss.Quarterly_opp_close_rate_percentage__c = sp.Quarterly_opp_close_rate_percentage__c;
                ss.YTD_close_rate_percentage__c = sp.YTD_close_rate_percentage__c;
                ss.YTD_lead_to_opp_conversion_percentage__c = sp.YTD_lead_to_opp_conversion_percentage__c;
                ss.YTD_opp_close_rate_percentage__c = sp.YTD_opp_close_rate_percentage__c;
                
                ss.Goal_of_quarterly_meetings__c= sp.Goal_of_quarterly_meetings__c;
                ss.Monthly_quota__c= sp.Monthly_quota__c;
                ss.Quarterly_Quota__c= sp.Quarterly_Quota__c;
                ss.Goal_of_YTD_meetings__c= sp.Goal_of_YTD_meetings__c;
                ss.Goal_of_wins_to_achieve_YTD_quota__c= sp.Goal_of_wins_to_achieve_YTD_quota__c;
                ss.Goal_of_YTD_leads_to_achieve_quota__c= sp.Goal_of_YTD_leads_to_achieve_quota__c;
                ss.Goal_12_Month_Lead_Added__c= sp.Goal_12_Month_Lead_Added__c;
                
                ss.Goal_12Month_Rolling_Opptys_Won_amt__c= sp.Goal_12Month_Rolling_Opptys_Won_amt__c;
                ss.Interim_Manager__c= sp.Interim_Manager__c;
                ss.Sales_Manager_Id__c= sp.Manger_Id__c;
                ss.Sales_Manager_Name__c= sp.Manger_Name__c;
                
                ss.Month_10_Quota_Amount__c= sp.Month_10_Quota_Amount__c;
                ss.Month_11_Quota_Amount__c= sp.Month_11_Quota_Amount__c;
                ss.Month_12_Quota_Amount__c= sp.Month_12_Quota_Amount__c;
                ss.Month_1_Quota_Amount__c= sp.Month_1_Quota_Amount__c;
                ss.Month_2_Quota_Amount__c= sp.Month_2_Quota_Amount__c;
                ss.Month_3_Quota_Amount__c= sp.Month_3_Quota_Amount__c;
                ss.Month_4_Quota_Amount__c= sp.Month_4_Quota_Amount__c;
                ss.Month_5_Quota_Amount__c= sp.Month_5_Quota_Amount__c;
                ss.Month_6_Quota_Amount__c= sp.Month_6_Quota_Amount__c;
                ss.Month_7_Quota_Amount__c= sp.Month_7_Quota_Amount__c;
                ss.Month_8_Quota_Amount__c= sp.Month_8_Quota_Amount__c;
                ss.Month_9_Quota_Amount__c= sp.Month_9_Quota_Amount__c;
                
                ss.Monthly_Opp_Added_amt_percentage__c= sp.Monthly_Opp_Added_amt_percentage__c;
                ss.Monthly_funnel_opportunities__c= sp.Monthly_funnel_opportunities__c;
                ss.Monthly_Lead_Added_Percentage__c= sp.Monthly_Lead_Added_Percentage__c;
                ss.Monthly_QO_added__c= sp.Monthly_QO_added__c;
                ss.On_boarding_Date__c= sp.On_boarding_Date__c;
                ss.Quarterly_Funnel_Opportunities__c= sp.Quarterly_Funnel_Opportunities__c;
                ss.Quarterly_Lead_Added_Percentage__c= sp.Quarterly_Lead_Added_Percentage__c;
                ss.Quarterly_Opp_Added_amt_percentage__c= sp.Quarterly_Opp_Added_amt_percentage__c;
                ss.Quarterly_QO_added__c= sp.Quarterly_QO_added__c;
                ss.Quartile__c= sp.Quartile__c;
                ss.YTD_Avg_Length_of_Sales_Cycle_percentage__c= sp.YTD_Avg_Length_of_Sales_Cycle_percentage__c;
                ss.YTD_Opportunities_Added_amt__c= sp.YTD_Opportunities_Added_amt__c;
                ss.Ytd_Funnel_Opportunities__c= sp.Ytd_Funnel_Opportunities__c;
                ss.YTD_Lead_Added_Percentage__c= sp.YTD_Lead_Added_Percentage__c;
                ss.Ytd_QO_added__c= sp.Ytd_QO_added__c;
                ss.YTDQP__c= sp.YTDQP__c;
                ss.Current_Fiscal_Months__c = sp.Current_Fiscal_Months__c ;
                
                ss.Profile_Type__c= sp.Profile_Type__c;
                ss.Dont_send_to_model__c= sp.Dont_send_to_model__c;
                ss.Placeholder__c= sp.Placeholder__c;
                
                ss.Monthly_lead_converted__c= sp.Monthly_lead_converted__c;
                ss.Quarterly_Lead_Converted__c= sp.Quarterly_Lead_Converted__c;
                ss.YTD_Lead_Converted__c= sp.YTD_Lead_Converted__c;
                ss.X12_Month_Lead_Converted__c= sp.X12_Month_Lead_Converted__c;
                ss.Monthly_Lead_Conversion_rate__c= sp.Monthly_Lead_Conversion_rate__c;
                ss.Quarterly_Lead_Conversion_rate__c= sp.Quarterly_Lead_Conversion_rate__c;
                ss.YTD_Lead_Conversion_rate__c= sp.YTD_Lead_Conversion_rate__c;
                ss.X12_Month_Lead_Conversion_rate__c= sp.X12_Month_Lead_Conversion_rate__c;
                ss.YTD_lead_conversion_percentage__c =sp.YTD_lead_conversion_percentage__c;
                ss.X12_Month_Avg_Length_of_Sales_Cycle_Per__c =sp.X12_Month_Avg_Length_of_Sales_Cycle_Per__c ;
                
                 
                /*
                if(sp.Current_Fiscal_Months__c == 1){
                    ss.Current_Fiscal_Months__c = 12;
                }else{
                    ss.Current_Fiscal_Months__c =   sp.Current_Fiscal_Months__c - 1;
                }
                */
                if(sp.Current_Fiscal_Months__c == 12){
                    sp.Current_Fiscal_Months__c = 1;
                }else{
                    sp.Current_Fiscal_Months__c =   sp.Current_Fiscal_Months__c + 1;
                }
                
                if(sp.Role_change_date__c != null && sp.Role_change_date__c <= triggerDate){
                    ss.Tenure_in_current_role__c =  sp.Role_change_date__c.monthsBetween(triggerDate)+1;
                }else{
                    ss.Tenure_in_current_role__c    =   sp.Tenure__c;
                }
                 
                
                ss.Snapshot_Scheduled_Date__c = triggerDate;                            
                
                /*
                if(date.today().day() >=1 && date.today().day() <= 27){
                    Date newDate = date.today() - 27;   
                    Integer dayVal = Date.daysInMonth(newDate.year(), newDate.month());
                    Date snapDate = Date.newInstance(newDate.year(), newDate.month(), dayVal);
                    ss.Snapshot_Scheduled_Date__c = snapDate;
                    
                    DateTime actualDateTime = snapDate;
             
                    actualDateTime = actualDateTime.addHours(actualDateTime.hour());
                    actualDateTime = actualDateTime.addMinutes(actualDateTime.minute());
                    actualDateTime = actualDateTime.addSeconds(actualDateTime.second());
                    ss.CreatedDate = actualDateTime;
                }
                else{
                    ss.CreatedDate = System.today();
                    ss.Snapshot_Scheduled_Date__c = Date.today();
                }
                */
                
                /*
                //DateTime todaysDateTime = Date.today();
                DateTime todaysDateTime = Date.newInstance(2017,12,31);
                
                todaysDateTime = todaysDateTime.addHours(todaysDateTime.hour());
                todaysDateTime = todaysDateTime.addMinutes(todaysDateTime.minute());
                todaysDateTime = todaysDateTime.addSeconds(todaysDateTime.second());
                ss.CreatedDate = todaysDateTime;
                    
                ss.Snapshot_Scheduled_Date__c = Date.newInstance(2017,12,31);
                */
                            
                snapshotRecsToBeInserted.add(ss);  
                                          
            }
        
        }
        
        //if(Schema.sObjectType.Sales_Rep_Profile_Snapshot__c.isCreateable())
        // if(Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile_Snapshot__c').getDescribe().isCreateable()){   
            insert snapshotRecsToBeInserted;
            update srp;
        //}
          
        }catch(Exception e){
            errorVal = true;
            system.debug(' error has occured '+e.getMessage()+' '+e.getStackTraceString());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelMonthlySalesProfSnapshotBatch '+e.getMessage()+' '+e.getStackTraceString()+' '+e.getLineNumber());  
        }
        
    }
    
    public void finish(Database.BatchableContext con){
        if(!errorVal){ 
            if(!histVal){ 
                //FunnelTriggerBatchHelper.sendErrorMail(' Sales prof snapshots created ');
            }
            /*if(histVal){
                FunnelMonthlyCompanyLevelSnapshotBatch compLevelBatch = new FunnelMonthlyCompanyLevelSnapshotBatch(triggerDate,chainBatch);
                Database.executeBatch(compLevelBatch); 
            }   
            else if(chainBatch){  */      
                FunnelUpdateCounters counterBatch = new FunnelUpdateCounters(triggerDate,chainBatch,histVal);
                Database.executeBatch(counterBatch);                                    
            //}
            if(histVal){
                /*FunnelPushQuantData fpu = new FunnelPushQuantData();
                database.executeBatch(fpu);*/
            }
        }
    }
}