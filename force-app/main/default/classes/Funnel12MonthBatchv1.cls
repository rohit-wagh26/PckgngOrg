/*
Copyright: Funnel Metrics, LLC
*/
global with Sharing class Funnel12MonthBatchv1 implements Database.Batchable<sobject>, Database.Stateful{
    
    Date triggerDate;
    Boolean chainBatch;
    Boolean histVal;
    Date triggerDateminus1;

    Boolean errorVal = false;
    public Boolean updateAccess = true;
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    
    /* Custom metadata code */
            
    List<Client_custom_field_mapping__mdt> lstCustMd = [SELECT Action__c, Custom_field_name__c, Standard_field_name__c, Record_type_name__c FROM Client_custom_field_mapping__mdt WHERE Standard_field_name__c = 'Amount'];
    
    List<RecordType> recTypes = [SELECT id, Name FROM RecordType WHERE SobjectType='Opportunity'];
    
    Map<String,List<String>> recTypeFldMap = new Map<String,List<String>>();                                                                
    
    Map<String,String> recTypeNameIdMap = new Map<String,String>();
            
    /* Custom metadata code */
    
    public Funnel12MonthBatchv1(Date scheduleDate,Boolean chain, Boolean historical){
        
        triggerDateminus1 = scheduleDate;
        triggerDate = scheduleDate.addDays(1);
        system.debug('triggerDate --'+triggerDate );
        system.debug('triggerDateminus1 --'+triggerDateminus1 );
        
        chainBatch = chain;
        histVal = historical;
        updateAccess = true;
        
        /* Custom metadata code */
        
        List<String> rectypeNames = new List<String>();                
        
        for(Client_custom_field_mapping__mdt cm: lstCustMd){
            rectypeNames.add(cm.Record_type_name__c);
        }
        
        List<RecordType> lstRT = [SELECT id, name FROM RecordType WHERE name IN :rectypeNames];
        for(RecordType r:lstRT ){
            recTypeNameIdMap.put(r.name,r.id);
        }
        
        if(lstCustMd != null && lstCustMd.size() > 0){
            for(Client_custom_field_mapping__mdt cm: lstCustMd){
                if(recTypeFldMap.containsKey(cm.Record_type_name__c)){
                    recTypeFldMap.get(cm.Record_type_name__c).add(cm.Custom_field_name__c);
                }
                else{
                    List<String> flds = new List<String>();
                    flds.add(cm.Custom_field_name__c);
                    recTypeFldMap.put(cm.Record_type_name__c,flds);
                }
            }
        }
                
        /* Custom metadata code */
        
        /*List<String> fldList1 = new List<String>{prefix+'X12_Month_Rolling_Quota__c',prefix+'Goal_Number_of_meetings_12_months__c',prefix+'Goal_12_Month_Rolling_Opptys_Won__c',prefix+'Goal_12_Month_Opportunitie_added_funnel__c',prefix+'X12_Month_Leads_Added__c',prefix+'Lead_to_Opportunity_Conversion_Rate__c',prefix+'Number_of_meetings_per_month__c',prefix+'Number_of_meetings_per_quarter__c',prefix+'Number_of_meetings_Rolling_12_months__c',prefix+'Number_of_meetings_YTD__c',prefix+'Monthly_Opportunities_added_to_Qualifie__c',prefix+'Quarterly_Opportunities_added_to_Qualifi__c',prefix+'Monthly_opp_won__c',prefix+'Monthly_Quota_Revenue__c',prefix+'YTD_Opportunity_Close_Rate__c',prefix+'YTD_Close_Rate__c',prefix+'Monthly_Opportunity_Close_Rate__c',prefix+'Monthly_Close_Rate__c',prefix+'Quarterly_opp_won__c',prefix+'Quarterly_Quota_Revenue__c',prefix+'Quarterly_Opportunity_Close_Rate__c',prefix+'Quarterly_Close_Rate__c',prefix+'Quarterly_Quota_Performance__c',prefix+'Monthly_Quota_Performance__c',prefix+'Tenure__c',prefix+'X12_Month_Rolling_Opptys_Won__c',prefix+'X12_Month_Rolling_Revenue__c',prefix+'X12_Month_Opprties_Added_to_the_funnel__c',prefix+'X12_Month_Rolling_Opportunity_Close_Rate__c',prefix+'X12_Month_Rolling_Close_Rate__c',prefix+'Close_rate_monthly_opp_amount__c',prefix+'Close_rate_monthly_opp_count__c',prefix+'Close_rate_Quarterly_opp_count__c',prefix+'Close_rate_Quarterly_opp_amount__c'};

        Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile__c').getDescribe().fields.getMap();
        
        for(String fldName: fldList1){
            if(!fieldMap1.get(fldName).getDescribe().isUpdateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              updateAccess = false;
              break;
            }                
        }*/
    }
    
    public Database.QueryLocator start(Database.BatchableContext con){
         return Database.getQueryLocator('select id,User_Record_Name__r.name,Rep_start_date__c,Monthly_lost_QO_Amt__c,Quarterly_lost_QO_Amt__c,Ytd_lost_QO_Amt__c,Monthly_lost_QO__c,Quarterly_lost_QO__c,Ytd_lost_QO__c, Annual_Quota_Amount__c,Goal_of_monthly_meetings__c,Goal_of_wins_to_achieve_monthly_quota__c,Goal_of_monthly_opptys_added_to_funnel__c,Q1_Quota_Amount__c,Q2_Quota_Amount__c,Q3_Quota_Amount__c,Q4_Quota_Amount__c ,Month_1_Quota_Amount__c,Month_2_Quota_Amount__c,Month_3_Quota_Amount__c,Month_4_Quota_Amount__c,Month_5_Quota_Amount__c,Month_6_Quota_Amount__c,Month_7_Quota_Amount__c,Month_8_Quota_Amount__c,Month_9_Quota_Amount__c,Month_10_Quota_Amount__c,Month_11_Quota_Amount__c,Month_12_Quota_Amount__c,User_Record_Name__c,Close_rate_monthly_opp_amount__c,Close_rate_monthly_opp_count__c,Close_rate_Quarterly_opp_amount__c,Close_rate_Quarterly_opp_count__c,Close_rate_YTD_opp_amount__c,Close_rate_YTD_opp_count__c, Monthly_QO_added__c, Quarterly_QO_added__c, Ytd_QO_added__c, User_Record_Name__r.CreatedDate from Sales_Rep_Profile__c WHERE (Active__c = TRUE OR Annual_Quota_Amount__c > 0) ');
    }
    
    public DateTime Fyear;
    public String Fyeard;
    public String Fisyear;
    public DateTime Cyear; 
    public String Cisyear;
    public String Cyeard;                        
    public DateTime startDate;                     
    public DateTime endDate;                       
    public DateTime Q0;                            
    public DateTime Q1;                            
    public DateTime Q2;                            
    public DateTime Q3;                            
    public DateTime Q4;                            
    public integer dif;
    public string startDates;
    public string endDates;
    public String SOQL_IDs ;
    public String Quarter;
    public integer numberofmonth;
    public string startd;
    public string endd;
    public string Fs;
    public string Cs;
    public boolean quat =  false;
    
    public DateTime startDateMonth;
    public DateTime endDateMonth;
    
    public string startDateMonths;
    public string endDateMonths;
    
    public string startDateMonthsd;
    public string endDateMonthsd;
    
    public DateTime startDate12Month;
    public DateTime endDate12Month;
    
    public string startDate12Months;
    public string endDate12Months;
    
    public string startDate12Monthsd;
    public string endDate12Monthsd;
    
    public String stage =  'Closed Won';
    
    public Decimal userprob = 0;
    
    
                        
    public void execute(Database.BatchableContext con, List<Sales_Rep_Profile__c> srp){
        system.debug(' inside execute ');
        
        try{
           if(updateAccess){    
            
            system.debug(' inside execute update access ');
            
            generateDates();
            
             
            //list<Sales_Rep_Profile__c> updatesrp =  new list<Sales_Rep_Profile__c>();
            
            //List of sales rep ids that are being processed
            Set<Id> srIds =  fetchSalesRepIds(srp);
            
            //List of user ids associated with the sales reps
            Set<Id> userIds =  fetchUserIds(srp); 
            
             generateSoqlId(userIds);
            //
            list<Map<Id, Integer>>  listOfleadCount=  fetchCountOfLeads();
            
             
            //Fetch the leads created in the past 12 months
            Map<Id, Integer> leadCount =  listOfleadCount[0];
            
            //Fetch the leads created in current fiscal year
            Map<Id, Integer> leadCountfy =  listOfleadCount[1];
            
            //Fetch the leads converted in current fiscal year
            Map<Id, Integer> leadCountcfy =  listOfleadCount[2];
            
            //Fetch the leads created in current Month
             Map<Id, Integer> leadCountmn =  listOfleadCount[3];
             
            //Fetch the leads created in current Quarter
            Map<Id, Integer> leadCountq =  listOfleadCount[4];
            
            
            list<Map<Id,Integer>> listofmeetingcount =  fetchCountOfMeetings();
            
            //Fetch the Task where meeting created in the past 12 months
            Map<Id, Integer> meetingCount =  listofmeetingcount[0];
            
            //Fetch the Task where meeting created in the current  month
            Map<Id, Integer> meetingCountmn =  listofmeetingcount[1];
            
            //Fetch the Task where meeting created in the current  quater
            Map<Id, Integer> meetingCountq =  listofmeetingcount[2];
            
            //Fetch the Task where meeting created in the YTD
            Map<Id, Integer> meetingCountytd =  listofmeetingcount[3];
            
            list<Map<Id, Integer>>  listOfOppCount=  fetchCountOfOpp();
            
            //Fetch the  opp created in the current  month
            Map<Id, Integer> oppCountmn =  listofoppcount[0];
            
            //Fetch the opp created in the current  quater
            Map<Id, Integer> oppCountq =  listofoppcount[1];
            
            List<Map<Id,AggregateResult>>listofoppRevenue  =  fetchQuotaRevenue();
            
            //Fetch the  opp revenue and won created in the current  month
            Map<Id, AggregateResult> oppRevenuemn =  listofoppRevenue[0];
            
            //Fetch the opp revenue and won created in the current  quater
            Map<Id, AggregateResult> oppRevenueq =  listofoppRevenue[1];
            
            //Fetch the opp revenue and won created YTD
            Map<Id, AggregateResult> oppRevenueYtd =  listofoppRevenue[2];
            
            List<Map<Id,AggregateResult>>listofoppRevenueTotal  =  fetchQuotaRevenueTotal();
            
            //Fetch the  opp Total revenue and count created in the current  month
            Map<Id, AggregateResult> oppRevenuemnTotal =  listofoppRevenueTotal[0];
            
            //Fetch the opp  Totalrevenue and count created in the current  quater
            Map<Id, AggregateResult> oppRevenueqTotal =  listofoppRevenueTotal[1];
            
            //Fetch the opp Total revenue and  count created YTD
            Map<Id, AggregateResult> oppRevenueYtdTotal =  listofoppRevenueTotal[2];
            
            Map<Id,Sales_Rep_Profile__c> srMap =  new Map<Id,Sales_Rep_Profile__c>();
            
            //Fetch data from salesprofile snapshot for 12 month $ and opp close rate
            Map<Id, AggregateResult> closerate =  fetch12CloseRate();
            
            //Fetch the monthly opportunities lost
            Map<Id, Integer> oppLostMap =  fetchOppLost(); 
            
            //Fetch the previous fiscal year start date to fetch the data stored for last year
            Date fiscalYr =  FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');        
            Date prevYr =  Date.newInstance((fiscalYr.year() - 1), fiscalYr.month(), fiscalYr.day());
            
            //Find the months to be considered in the previous and current fiscal years for calculation of 12 month rolling quota
            Integer currentFiscalMonths, previousFiscalMonths =  0;               
            List<Integer> fiscalMonths =  fetchMonthsForCalculation(currentFiscalMonths, previousFiscalMonths);
            currentFiscalMonths =  fiscalMonths[0];
            previousFiscalMonths =  fiscalMonths[1];
            
           // system.debug(' currentFiscalMonths after population '+currentFiscalMonths+' previousFiscalMonths after population '+previousFiscalMonths);
            //Fetch the quota for the previous year
            List<Map<Id,Integer>> spQuotaMapList =  fetchQuotaForPastYr(prevYr ,srIds);
    
            //Fetch the quota for the previous year
            Map<Id,Integer> spQuotaMap =  spQuotaMapList[0];
            
            Map<Id,Integer> spMeetinggMap =  spQuotaMapList[1];
            
            Map<Id,Integer> spOppWingMap =  spQuotaMapList[2];
            
            Map<Id,Integer> spOppAddedgMap =  spQuotaMapList[3];                       
            
            //  List<AggregateResult> oppAggr =  [SELECT COUNT(id) c, SUM(amount) s, AVG(Days_For_Closure__c) av, ownerId o FROM Opportunity WHERE OwnerId IN :userIds AND StageName =  'Closed Won' AND CloseDate =  LAST_N_days:365 GROUP BY OwnerId];  
            //List<AggregateResult> oppAggr =  database.query('SELECT COUNT(id) c, SUM(amount) s, ownerId o FROM Opportunity WHERE OwnerId IN ('+SOQL_IDs+') AND StageName = '+'\''+stage+'\''+' AND CloseDate >=  '+ startDate12Monthsd+' AND CloseDate <=  '+ endDate12Monthsd+' GROUP BY OwnerId');                         
            
            
            /* Custom metadata code */                       
            
            Map<id,Decimal> ownerAmtMap = new Map<id,Decimal>();
            
            List<AggregateResult> oppAggrAmt = new List<AggregateResult>();                         
            
            String omit = 'Omitted';
               
            if(lstCustMd != null && lstCustMd.size() > 0){                    
                
                for (String recTypeName : recTypeFldMap.keySet()){
                    
                    String q;
                    q = 'SELECT ownerId o ';
            
                    if(lstCustMd[0].Action__c == 'Add'){
                        q += ', SUM(amount) s ';
                    }
                
                    List<String> flds = recTypeFldMap.get(recTypeName);
                    
                    for(Integer i = 0; i < flds.size(); i++){
                        q += ', SUM('+flds[i]+') '+flds[i];       
                    }
                    
                    q += ' FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND  iswon = true AND CloseDate >=  '+ startDate12Monthsd+' AND CloseDate <  '+ Cyeard+' AND RecordTypeId = '+'\''+recTypeNameIdMap.get(recTypeName)+'\''+' GROUP BY OwnerId';
                    
                    oppAggrAmt = database.query(q);
                    
                    for(AggregateResult ar: oppAggrAmt){
                        Decimal totAmt = 0;
                        
                        if(lstCustMd[0].Action__c == 'Add'){
                                                        
                            if(ar.get('s') != null)
                                totAmt  += (Decimal)ar.get('s');
                        }
                            
                        for(Integer i = 0; i < flds.size(); i++){
                            if(ar.get(flds[i]) != null)
                                totAmt += (Decimal)ar.get(flds[i]);       
                        }                            
                    
                        if(!ownerAmtMap.containsKey((id)ar.get('o'))){
                            ownerAmtMap.put((id)ar.get('o'),(Decimal)totAmt);        
                        }
                        else{
                            Decimal amt = ownerAmtMap.get('o');
                            amt += totAmt;                           
                            ownerAmtMap.put((id)ar.get('o'),amt);
                        }
                           
                    } 
                    
                                       
                }                                
                                
                /*for(Client_custom_field_mapping__mdt cm: lstCustMd){
                    q += ', SUM('+cm.Custom_field_name__c+') '+cm.Custom_field_name__c;    
                }*/
                   
            }
            else{
                
                String q = 'SELECT ownerId o, SUM(amount) s, FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND  iswon = true AND CloseDate >=  '+ startDate12Monthsd+' AND CloseDate <  '+ Cyeard+' GROUP BY OwnerId'; 
                
                oppAggrAmt = database.query(q);
                
                for(AggregateResult ar: oppAggrAmt){                    
                    if(ar.get('s') != null){
                        ownerAmtMap.put((id)ar.get('o'),(Decimal)ar.get('s'));        
                    }
                }
            }                                                          
            
            /* Custom metadata code */
            
            system.debug(' startDate12Monthsd '+startDate12Monthsd);
            system.debug(' Cyeard '+Cyeard);
            
            List<AggregateResult> oppAggr =  database.query('SELECT COUNT(id) c, ownerId o FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND  iswon = true AND CloseDate >=  '+ startDate12Monthsd+' AND CloseDate <  '+ Cyeard+' GROUP BY OwnerId');                           
            
            system.debug('X12_Month_Rolling_Opptys_Won__c 204------>'+'SELECT COUNT(id) c, SUM(amount) s, ownerId o FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN   AND iswon = true AND CloseDate >=  '+ startDate12Monthsd+' AND CloseDate <  '+ Cyeard+' GROUP BY OwnerId');
            
            Map<Id, AggregateResult> ownerClosedAggregates =  new Map<Id,AggregateResult>();
            
            for(AggregateResult a:oppAggr){
                ownerClosedAggregates.put((Id)a.get('o'),a);
            }
            
            //   List<AggregateResult> allOppAggr =  [SELECT COUNT(id) c, ownerId o FROM Opportunity WHERE OwnerId IN :userIds AND CreatedDate =  LAST_N_days:365 GROUP BY OwnerId];  
            //List<AggregateResult> allOppAggr = database.query('SELECT COUNT(id) c, ownerId o FROM Opportunity WHERE OwnerId IN ('+SOQL_IDs+') AND CreatedDate >= '+ startDate12Months+' AND CreatedDate <= '+endDate12Months+ ' GROUP BY OwnerId');      
            List<AggregateResult> allOppAggr = database.query('SELECT COUNT(id) c, ownerId o FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND CreatedDate >= '+ startDate12Months+' AND CreatedDate < '+Cisyear+ ' GROUP BY OwnerId');      
            system.debug('X12_Month_Opprties_Added_to_the_funnel__c 215--->'+'SELECT COUNT(id) c, ownerId o FROM Opportunity WHERE OwnerId IN   AND CreatedDate >= '+ startDate12Months+' AND CreatedDate < '+Cisyear+ ' GROUP BY OwnerId');
            
            Map<Id, AggregateResult> ownerAllAggregates =  new Map<Id,AggregateResult>();
            
            for(AggregateResult a: allOppAggr){
                ownerAllAggregates.put((Id)a.get('o'),a);
            }
            
            for(Sales_Rep_Profile__c s : srp){
                
                system.debug(' in srp loop ');
                
                if(s.Month_1_Quota_Amount__c !=  0 && s.Month_1_Quota_Amount__c !=  null){
                    numberofmonth =  12 ;
                }else if(s.Month_2_Quota_Amount__c !=  0 && s.Month_2_Quota_Amount__c !=  null){
                    numberofmonth =  11 ;
                }else if(s.Month_3_Quota_Amount__c !=  0 && s.Month_3_Quota_Amount__c !=  null){
                    numberofmonth =  10 ;
                }else if(s.Month_4_Quota_Amount__c !=  0 && s.Month_4_Quota_Amount__c !=  null){
                    numberofmonth =  9 ;
                }else if(s.Month_5_Quota_Amount__c !=  0 && s.Month_5_Quota_Amount__c !=  null){
                    numberofmonth =  8 ;
                }else if(s.Month_6_Quota_Amount__c !=  0 && s.Month_6_Quota_Amount__c !=  null){
                    numberofmonth =  7;
                }else if(s.Month_7_Quota_Amount__c !=  0 && s.Month_7_Quota_Amount__c !=  null){
                    numberofmonth =  6 ;
                }else if(s.Month_8_Quota_Amount__c !=  0 && s.Month_8_Quota_Amount__c !=  null){
                    numberofmonth =  5 ;
                }else if(s.Month_9_Quota_Amount__c !=  0 && s.Month_9_Quota_Amount__c !=  null){
                    numberofmonth =  4 ;
                }else if(s.Month_10_Quota_Amount__c !=  0 && s.Month_10_Quota_Amount__c !=  null){
                    numberofmonth =  3 ;
                }else if(s.Month_11_Quota_Amount__c !=  0 && s.Month_11_Quota_Amount__c !=  null){
                    numberofmonth =  2 ;
                }else if(s.Month_12_Quota_Amount__c !=  0 && s.Month_12_Quota_Amount__c !=  null){
                    numberofmonth =  1 ;
                }
                
                if(spQuotaMap.get(s.id) !=  null && s.Annual_Quota_Amount__c !=  null && s.Annual_Quota_Amount__c >0){     
                    s.X12_Month_Rolling_Quota__c =  ((s.Annual_Quota_Amount__c/12) * currentFiscalMonths) + (spQuotaMap.get(s.id) * previousFiscalMonths);
                }else if(s.Annual_Quota_Amount__c !=  null && s.Annual_Quota_Amount__c >0){
                    s.X12_Month_Rolling_Quota__c =  ((s.Annual_Quota_Amount__c/12) * currentFiscalMonths) ;
                }else{
                    s.X12_Month_Rolling_Quota__c = 0;
                }
                
                if(spMeetinggMap.get(s.id) !=  null && s.Goal_of_monthly_meetings__c !=  null && s.Goal_of_monthly_meetings__c >0){     
                    s.Goal_Number_of_meetings_12_months__c =  ((s.Goal_of_monthly_meetings__c ) * currentFiscalMonths) + (spMeetinggMap.get(s.id) * previousFiscalMonths);
                }else if(s.Goal_of_monthly_meetings__c !=  null && s.Goal_of_monthly_meetings__c >0){
                    s.Goal_Number_of_meetings_12_months__c =  ((s.Goal_of_monthly_meetings__c ) * currentFiscalMonths);
                }else{
                    s.Goal_Number_of_meetings_12_months__c = 0;
                }
                
                if(spOppWingMap.get(s.id) !=  null && s.Goal_of_wins_to_achieve_monthly_quota__c !=  null && s.Goal_of_wins_to_achieve_monthly_quota__c >0){     
                    s.Goal_12_Month_Rolling_Opptys_Won__c =  ((s.Goal_of_wins_to_achieve_monthly_quota__c ) * currentFiscalMonths) + (spOppWingMap.get(s.id) * previousFiscalMonths);
                }else if(s.Goal_of_wins_to_achieve_monthly_quota__c !=  null && s.Goal_of_wins_to_achieve_monthly_quota__c >0){
                    s.Goal_12_Month_Rolling_Opptys_Won__c =  ((s.Goal_of_wins_to_achieve_monthly_quota__c ) * currentFiscalMonths);
                }else{
                    s.Goal_12_Month_Rolling_Opptys_Won__c = 0;
                }
                
                if(spOppAddedgMap.get(s.id) !=  null && s.Goal_of_monthly_opptys_added_to_funnel__c !=  null && s.Goal_of_monthly_opptys_added_to_funnel__c >0){     
                    s.Goal_12_Month_Opportunitie_added_funnel__c =  ((s.Goal_of_monthly_opptys_added_to_funnel__c ) * currentFiscalMonths) + (spOppAddedgMap.get(s.id) * previousFiscalMonths);
                }else if(s.Goal_of_monthly_opptys_added_to_funnel__c !=  null && s.Goal_of_monthly_opptys_added_to_funnel__c >0){
                    s.Goal_12_Month_Opportunitie_added_funnel__c =  ((s.Goal_of_monthly_opptys_added_to_funnel__c ) * currentFiscalMonths);
                }else{
                    s.Goal_12_Month_Opportunitie_added_funnel__c = 0;
                }
                
                s.X12_Month_Leads_Added__c =  leadCount.get(s.User_Record_Name__c);
                if(s.X12_Month_Leads_Added__c ==  null){
                    s.X12_Month_Leads_Added__c =  0;
                }
                
                s.Number_of_meetings_per_month__c =  meetingCountmn.get(s.User_Record_Name__c);
                if(s.Number_of_meetings_per_month__c ==  null){
                    s.Number_of_meetings_per_month__c =  0;
                }
                
                s.Number_of_meetings_per_quarter__c=  meetingCountq.get(s.User_Record_Name__c);
                if(s.Number_of_meetings_per_quarter__c ==  null){
                    s.Number_of_meetings_per_quarter__c =  0;
                }
                
                s.Number_of_meetings_Rolling_12_months__c=  meetingCount.get(s.User_Record_Name__c);
                if(s.Number_of_meetings_Rolling_12_months__c ==  null){
                    s.Number_of_meetings_Rolling_12_months__c =  0;
                }
                
                s.Number_of_meetings_YTD__c=  meetingCountytd.get(s.User_Record_Name__c);
                if(s.Number_of_meetings_YTD__c ==  null){
                    s.Number_of_meetings_YTD__c =  0;
                }
                
                s.Monthly_Opportunities_added_to_Qualifie__c =  oppCountmn.get(s.User_Record_Name__c);
                if(s.Monthly_Opportunities_added_to_Qualifie__c ==  null){
                    s.Monthly_Opportunities_added_to_Qualifie__c =  0;
                }
                
                s.Quarterly_Opportunities_added_to_Qualifi__c =  oppCountq.get(s.User_Record_Name__c);
                if(s.Quarterly_Opportunities_added_to_Qualifi__c ==  null){
                    s.Quarterly_Opportunities_added_to_Qualifi__c =  0;
                }
                
                if(oppLostMap.keySet().contains(s.User_Record_Name__c)){
                    s.Monthly_opp_lost__c =  oppLostMap.get(s.User_Record_Name__c);
                }
                else{
                    s.Monthly_opp_lost__c = 0;
                }
                
                if(oppRevenuemn.keySet().contains(s.User_Record_Name__c) &&  oppRevenuemn.get(s.User_Record_Name__c).get('c') !=  null ){
                    s.Monthly_opp_won__c =  (Integer)oppRevenuemn.get(s.User_Record_Name__c).get('c');
                }else{
                    s.Monthly_opp_won__c =  0;
                }
                
                if(oppRevenuemn.keySet().contains(s.User_Record_Name__c) &&  oppRevenuemn.get(s.User_Record_Name__c).get('s') !=  null ){
                    s.Monthly_Quota_Revenue__c =  (Decimal)oppRevenuemn.get(s.User_Record_Name__c).get('s');
                }else{
                    s.Monthly_Quota_Revenue__c =  0;
                }
                Decimal ytdLostCount = 0;
                if (s.Ytd_lost_QO__c != null){
                    ytdLostCount =  s.Ytd_lost_QO__c;
                }
                
                if(oppRevenueYtdTotal.keySet().contains(s.User_Record_Name__c)  && oppRevenueYtd.keySet().contains(s.User_Record_Name__c) && oppRevenueYtd.get(s.User_Record_Name__c).get('c') !=  null  && oppRevenueYtdTotal.get(s.User_Record_Name__c).get('c') != null && (Integer)oppRevenueYtdTotal.get(s.User_Record_Name__c).get('c') > 0 ){
                    if(s.Close_rate_YTD_opp_count__c !=  null){
                        s.YTD_Opportunity_Close_Rate__c =  (((Integer)oppRevenueYtd.get(s.User_Record_Name__c).get('c'))*100)/((Integer)oppRevenueYtdTotal.get(s.User_Record_Name__c).get('c')+s.Close_rate_YTD_opp_count__c + ytdLostCount);
                        system.debug(' YTD_Opportunity_Close_Rate__c NUM-'+(Integer)oppRevenueYtd.get(s.User_Record_Name__c).get('c'));
                        system.debug(' YTD_Opportunity_Close_Rate__c DM1-'+(Integer)oppRevenueYtdTotal.get(s.User_Record_Name__c).get('c'));
                         
                    }else{
                        s.YTD_Opportunity_Close_Rate__c =  (((Integer)oppRevenueYtd.get(s.User_Record_Name__c).get('c'))*100)/((Integer)oppRevenueYtdTotal.get(s.User_Record_Name__c).get('c')+ ytdLostCount);
                    }   
                }else{
                    s.YTD_Opportunity_Close_Rate__c =  0;
                }
                
                Decimal ytdLostamt = 0;
                if ( s.Ytd_lost_QO_Amt__c != null){
                    ytdLostamt =  s.Ytd_lost_QO_Amt__c;
                }
                if(oppRevenueYtdTotal.keySet().contains(s.User_Record_Name__c)  && oppRevenueYtd.keySet().contains(s.User_Record_Name__c) && oppRevenueYtd.get(s.User_Record_Name__c).get('s') !=  null  && oppRevenueYtdTotal.get(s.User_Record_Name__c).get('s') != null && (Decimal)oppRevenueYtdTotal.get(s.User_Record_Name__c).get('s') > 0  ){
                   // system.debug(' s.Ytd_lost_QO_Amt__c '+s.Ytd_lost_QO_Amt__c);
                    if( s.Close_rate_YTD_opp_amount__c !=  null){
                        s.YTD_Close_Rate__c =  (((Decimal)oppRevenueYtd.get(s.User_Record_Name__c).get('s'))*100)/((Decimal)oppRevenueYtdTotal.get(s.User_Record_Name__c).get('s')+s.Close_rate_YTD_opp_amount__c + ytdLostamt);
                    }else{
                        s.YTD_Close_Rate__c =  (((Decimal)oppRevenueYtd.get(s.User_Record_Name__c).get('s'))*100)/((Decimal)oppRevenueYtdTotal.get(s.User_Record_Name__c).get('s') + ytdLostamt);
                    }
                }else{
                    s.YTD_Close_Rate__c =  0;
                    
                }
                
                Decimal mnLostCount = 0;
                if (s.Monthly_lost_QO__c != null){
                    mnLostCount =  s.Monthly_lost_QO__c;
                }
                
                if(oppRevenuemnTotal.keySet().contains(s.User_Record_Name__c) &&  oppRevenuemnTotal.get(s.User_Record_Name__c).get('c') != null && (Integer)oppRevenuemnTotal.get(s.User_Record_Name__c).get('c') >0   ){
                    if(s.Close_rate_monthly_opp_count__c !=  null ){
                        s.Monthly_Opportunity_Close_Rate__c =  ((s.Monthly_opp_won__c)*100)/((Integer)oppRevenuemnTotal.get(s.User_Record_Name__c).get('c')+s.Close_rate_monthly_opp_count__c + mnLostCount);
                        system.debug(' Monthly_Opportunity_Close_Rate__c NUM-'+(s.Monthly_opp_won__c));
                        system.debug(' Monthly_Opportunity_Close_Rate__c DM1-'+(Integer)oppRevenuemnTotal.get(s.User_Record_Name__c).get('c'));
                    }else{
                        s.Monthly_Opportunity_Close_Rate__c =  ((s.Monthly_opp_won__c)*100)/((Integer)oppRevenuemnTotal.get(s.User_Record_Name__c).get('c') + mnLostCount);
                        system.debug(' Monthly_Opportunity_Close_Rate__c NUM-'+(s.Monthly_opp_won__c));
                        system.debug(' Monthly_Opportunity_Close_Rate__c DM1-'+(Integer)oppRevenuemnTotal.get(s.User_Record_Name__c).get('c'));
                    }
                }else{
                    s.Monthly_Opportunity_Close_Rate__c =  0;
                }
                
                Decimal mnLostamt = 0;
                if ( s.Monthly_lost_QO_Amt__c != null){
                    mnLostamt =  s.Monthly_lost_QO_Amt__c;
                }
                
                if(oppRevenuemnTotal.keySet().contains(s.User_Record_Name__c) &&  oppRevenuemnTotal.get(s.User_Record_Name__c).get('s') != null && (Decimal)oppRevenuemnTotal.get(s.User_Record_Name__c).get('s') > 0 ){
                    if( s.Close_rate_monthly_opp_amount__c !=  null ){
                        s.Monthly_Close_Rate__c =  ((s.Monthly_Quota_Revenue__c)*100)/((Decimal)oppRevenuemnTotal.get(s.User_Record_Name__c).get('s')+s.Close_rate_monthly_opp_amount__c + mnLostamt);
                        
                    }else{
                        s.Monthly_Close_Rate__c =  ((s.Monthly_Quota_Revenue__c)*100)/((Decimal)oppRevenuemnTotal.get(s.User_Record_Name__c).get('s') + mnLostamt );
                    }
                }else{
                    s.Monthly_Close_Rate__c =  0;
                }
                
                
                if(oppRevenueq.keySet().contains(s.User_Record_Name__c) &&  oppRevenueq.get(s.User_Record_Name__c).get('c') !=  null ){
                    s.Quarterly_opp_won__c =  (Integer)oppRevenueq.get(s.User_Record_Name__c).get('c');
                }else{
                    s.Quarterly_opp_won__c =  0;
                }
                
                if(oppRevenueq.keySet().contains(s.User_Record_Name__c) &&  oppRevenueq.get(s.User_Record_Name__c).get('s') !=  null ){
                    s.Quarterly_Quota_Revenue__c =  (Decimal)oppRevenueq.get(s.User_Record_Name__c).get('s');
                }else{
                    s.Quarterly_Quota_Revenue__c =  0;
                }
                
                Decimal qLostCount = 0;
                if (s.Quarterly_lost_QO__c != null){
                    qLostCount =  s.Quarterly_lost_QO__c;
                }
                
                if(oppRevenueqTotal.keySet().contains(s.User_Record_Name__c) &&  oppRevenueqTotal.get(s.User_Record_Name__c).get('c') != null && (Integer)oppRevenueqTotal.get(s.User_Record_Name__c).get('c') >0 ){
                    if(s.Close_rate_Quarterly_opp_count__c !=  null ){
                        s.Quarterly_Opportunity_Close_Rate__c =  ((s.Quarterly_opp_won__c)*100)/((Integer)oppRevenueqTotal.get(s.User_Record_Name__c).get('c')+s.Close_rate_Quarterly_opp_count__c + qLostCount);
                        
                    }else{
                        s.Quarterly_Opportunity_Close_Rate__c =  ((s.Quarterly_opp_won__c)*100)/((Integer)oppRevenueqTotal.get(s.User_Record_Name__c).get('c') + qLostCount);
                    }
                }else{
                    s.Quarterly_Opportunity_Close_Rate__c =  0;
                }
                
                Decimal qLostamt = 0;
                if ( s.Quarterly_lost_QO_Amt__c != null){
                    qLostamt =  s.Quarterly_lost_QO_Amt__c;
                }
                
                if(oppRevenueqTotal.keySet().contains(s.User_Record_Name__c) &&  oppRevenueqTotal.get(s.User_Record_Name__c).get('s') != null && (Decimal)oppRevenueqTotal.get(s.User_Record_Name__c).get('s') >0 ){
                    if( s.Close_rate_Quarterly_opp_amount__c !=  null ){
                        s.Quarterly_Close_Rate__c =  ((s.Quarterly_Quota_Revenue__c)*100)/((Decimal)oppRevenueqTotal.get(s.User_Record_Name__c).get('s') + s.Close_rate_Quarterly_opp_amount__c + qLostamt);
                        
                    }else{
                        
                        s.Quarterly_Close_Rate__c =  ((s.Quarterly_Quota_Revenue__c)*100)/((Decimal)oppRevenueqTotal.get(s.User_Record_Name__c).get('s') + qLostamt);
                    }
                }else{
                    s.Quarterly_Close_Rate__c =  0;
                }
                
                if(Quarter ==  'Q1'){
                    if(s.Q1_Quota_Amount__c > 0){
                        s.Quarterly_Quota_Performance__c =  (s.Quarterly_Quota_Revenue__c/s.Q1_Quota_Amount__c)*100;
                    }else{
                        s.Quarterly_Quota_Performance__c = 0;
                    }
                    
                }else if(Quarter ==  'Q2'){
                    if(s.Q2_Quota_Amount__c > 0){
                        s.Quarterly_Quota_Performance__c =  (s.Quarterly_Quota_Revenue__c/s.Q2_Quota_Amount__c)*100;
                    }else{
                        s.Quarterly_Quota_Performance__c = 0;
                    }
                    
                }else if(Quarter ==  'Q3'){
                    if(s.Q3_Quota_Amount__c > 0){
                        s.Quarterly_Quota_Performance__c =  (s.Quarterly_Quota_Revenue__c/s.Q3_Quota_Amount__c)*100;
                    }else{
                        s.Quarterly_Quota_Performance__c =  0;
                    }
                    
                }else if (Quarter ==  'Q4'){
                    if(s.Q4_Quota_Amount__c >0){
                        s.Quarterly_Quota_Performance__c =  (s.Quarterly_Quota_Revenue__c/s.Q4_Quota_Amount__c)*100;
                    }else{
                        s.Quarterly_Quota_Performance__c = 0;
                    }
                    
                }
                
                if(s.Monthly_Quota_Revenue__c !=  null && s.Annual_Quota_Amount__c>0){
                    s.Monthly_Quota_Performance__c =  (s.Monthly_Quota_Revenue__c/(s.Annual_Quota_Amount__c/numberofmonth))*100;
                }else{
                    s.Monthly_Quota_Performance__c =  0;
                }
                                                
                
                if(s.User_Record_Name__c !=  null && s.Rep_start_date__c != null){
                    //s.Tenure__c =  s.User_Record_Name__r.CreatedDate.date().monthsBetween(triggerDate); 
                    s.Tenure__c =  s.Rep_start_date__c.monthsBetween(triggerDateminus1);
                }
                
                system.debug(' before if loop for revenue ' );
                
                if(ownerClosedAggregates.keySet().contains(s.User_Record_Name__c)){
                    s.X12_Month_Rolling_Opptys_Won__c =  (Integer)ownerClosedAggregates.get(s.User_Record_Name__c).get('c');
                    
                    /* Custom metadata code */
                    
                    
                    
                    
                    system.debug(' inside custom metadata '+ownerClosedAggregates );
                                
                    if(lstCustMd != null && lstCustMd.size() > 0){
                        system.debug(' executed custom metadata code ');
                        if(lstCustMd[0].Action__c == 'Add'){
                            s.X12_Month_Rolling_Revenue__c =  (Decimal)ownerClosedAggregates.get(s.User_Record_Name__c).get('s');
                        }
                        
                        for(Client_custom_field_mapping__mdt cm: lstCustMd){
                            //s.X12_Month_Rolling_Revenue__c += (Decimal)((ownerClosedAggregates.get(s.User_Record_Name__c)).get('\''+cm.Custom_field_name__c+'\''));
                            String fld = cm.Custom_field_name__c;
                            system.debug(((ownerClosedAggregates.get(s.User_Record_Name__c)).get(fld))); 
                            if((ownerClosedAggregates.get(s.User_Record_Name__c)).get(fld) != null){
                                s.X12_Month_Rolling_Revenue__c += (Decimal)((ownerClosedAggregates.get(s.User_Record_Name__c)).get(fld));    
                            }
                        }
                           
                    }
                    else{
                        
                        s.X12_Month_Rolling_Revenue__c =  (Decimal)ownerClosedAggregates.get(s.User_Record_Name__c).get('s');
                    }
                    
                    //s.X12_Month_Rolling_Revenue__c =  (Decimal)ownerClosedAggregates.get(s.User_Record_Name__c).get('s');
                    
                    /* Custom metadata code */
                    
                    
                    //s.X12_Month_Rolling_Average_Sales_Cycle__c =  (Decimal)ownerClosedAggregates.get(s.User_Record_Name__c).get('av');                
                }
                else{
                    s.X12_Month_Rolling_Opptys_Won__c =  0;
                    
                    /* Custom metadata code - comment below line*/
                    //s.X12_Month_Rolling_Revenue__c =  0;
                    //s.X12_Month_Rolling_Average_Sales_Cycle__c =  0;
                }
                
                
                /* Custom metadata code */
                if(ownerAmtMap.containsKey(s.User_Record_Name__c)){
                    s.X12_Month_Rolling_Revenue__c = ownerAmtMap.get(s.User_Record_Name__c);
                }
                else{
                    s.X12_Month_Rolling_Revenue__c =  0;
                }
                /* Custom metadata code */
                
                if(ownerAllAggregates.keySet().contains(s.User_Record_Name__c)){
                    s.X12_Month_Opprties_Added_to_the_funnel__c =  (Integer)ownerAllAggregates.get(s.User_Record_Name__c).get('c');                 
                }
                else{
                    s.X12_Month_Opprties_Added_to_the_funnel__c =  0;
                }  
                
                if(closerate.keySet().contains(s.User_Record_Name__c) && closerate.get(s.User_Record_Name__c).get('ocr') !=  null ){
                    s.X12_Month_Rolling_Opportunity_Close_Rate__c =  ((Decimal)closerate.get(s.User_Record_Name__c).get('ocr') + s.Monthly_Opportunity_Close_Rate__c)/((Integer)closerate.get(s.User_Record_Name__c).get('cid') +1);
                }else{
                    s.X12_Month_Rolling_Opportunity_Close_Rate__c =  s.Monthly_Opportunity_Close_Rate__c;
                }
                
                if(closerate.keySet().contains(s.User_Record_Name__c) && closerate.get(s.User_Record_Name__c).get('scr') !=  null ){
                    s.X12_Month_Rolling_Close_Rate__c =  ((Decimal)closerate.get(s.User_Record_Name__c).get('scr')+s.Monthly_Close_Rate__c)/((Integer)closerate.get(s.User_Record_Name__c).get('cid')+1);
                }else{
                    s.X12_Month_Rolling_Close_Rate__c = s.Monthly_Close_Rate__c;
                }
                
                
                
                
                if(s.Monthly_QO_added__c != null){
                    s.Monthly_QO_added_Quantitative__c = s.Monthly_QO_added__c;
                }else{
                    s.Monthly_QO_added_Quantitative__c = 0;
                }
                
                if(s.Quarterly_QO_added__c != null){
                    s.Quarterly_QO_added_Quantitative__c = s.Quarterly_QO_added__c;
                }else{
                    s.Quarterly_QO_added_Quantitative__c = 0;
                }
                
                if(s.Ytd_QO_added__c != null){
                    s.Ytd_QO_added_Quantitative__c = s.Ytd_QO_added__c;
                }else{
                    s.Ytd_QO_added_Quantitative__c = 0;
                }
                
                
                
                if(closerate.keySet().contains(s.User_Record_Name__c) && closerate.get(s.User_Record_Name__c).get('mqoa') !=  null ){
                    s.X12_Month_QO_added__c =   Integer.valueOf(closerate.get(s.User_Record_Name__c).get('mqoa')) + s.Monthly_QO_added_Quantitative__c ;
                }else{
                    s.X12_Month_QO_added__c =  s.Monthly_QO_added_Quantitative__c;
                }
                
                if(leadCountcfy.get(s.User_Record_Name__c) !=  null && leadCountfy.get(s.User_Record_Name__c) != null &&  (integer)leadCountfy.get(s.User_Record_Name__c ) > 0 && s.Ytd_QO_added_Quantitative__c > 0){
                    s.Lead_to_Opportunity_Conversion_Rate__c =  s.Ytd_QO_added_Quantitative__c /leadCountfy.get(s.User_Record_Name__c);
                
                    }else{
                        s.Lead_to_Opportunity_Conversion_Rate__c =  0;
                }
                  s.Close_rate_monthly_opp_amount__c = 0;
                  s.Close_rate_monthly_opp_count__c = 0;
                  s.Monthly_lost_QO_Amt__c = 0;
                  s.Monthly_lost_QO__c =0;
                  s.Monthly_QO_added__c = 0;
                    
                  if(quat){
                      s.Close_rate_Quarterly_opp_count__c =  0;
                      s.Close_rate_Quarterly_opp_amount__c= 0;
                      s.Quarterly_lost_QO_Amt__c = 0;
                      s.Quarterly_lost_QO__c=0;
                      s.Quarterly_QO_added__c = 0;
                  }
                s.Current_Fiscal_Months__c =  currentFiscalMonths;
                
                // new fields
                s.Monthly_Lead_Added__c =  leadCountmn.get(s.User_Record_Name__c);
                if(s.Monthly_Lead_Added__c ==  null){
                    s.Monthly_Lead_Added__c =  0;
                }
                
                s.Quarterly_Lead_Added__c =  leadCountq.get(s.User_Record_Name__c);
                if(s.Quarterly_Lead_Added__c ==  null){
                    s.Quarterly_Lead_Added__c =  0;
                }
              
            }        
                    
                  // if(Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile__c').getDescribe().isUpdateable()){                      
                       update srp; 
                  //    }
            }
        }
        catch(Exception ex){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(ex.getMessage(),ex.getStackTraceString());
        } 
    }        
    
    public void finish(Database.BatchableContext con){
        //FunnelTriggerBatchHelper.sendErrorMail(' Funnel12MonthBatch finish method');
        if(!errorVal){ 
            //FunnelTriggerBatchHelper.sendErrorMail(' Funnel12MonthBatch finish method no error');
            system.debug(' triggerDateminus1 '+triggerDateminus1);
            if(chainBatch){
                FunnelCustomMetricBatch fm = new FunnelCustomMetricBatch(triggerDateminus1,chainBatch,histVal);
                Database.executeBatch(fm);
            }
            /*
            if(histVal){
                FunnelCalculateActiveOpptysBatch fm = new FunnelCalculateActiveOpptysBatch(triggerDateminus1,chainBatch,histVal);
                Database.executeBatch(fm);
            }
            else if(chainBatch){
                FunnelQuantitativeBatchMonthly fb = new FunnelQuantitativeBatchMonthly(triggerDateminus1,chainBatch,histVal);
                Database.executeBatch(fb,100);
            }*/
        }
    }
    
    private List<Integer> fetchMonthsForCalculation(Integer currentFiscalMonths, Integer previousFiscalMonths){
        
        List<Integer> fiscalMonths =  new List<Integer>();
        
        Integer startMonth =  FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year').Month();
       // system.debug(' startMonth is '+startMonth);
        Integer currentMonth =  triggerDate.Month();
       // system.debug(' current month is '+currentMonth);
        
        if(currentMonth > startMonth){
            currentFiscalMonths =  currentMonth - startMonth + 1;            
        }
        else if(currentMonth < startMonth){
            currentFiscalMonths =  11 - startMonth + currentMonth;            
        }
        else if(currentMonth ==  startMonth){
            currentFiscalMonths =  1;
        }
        
        
        // static date currentFiscalMonths = 3;
       
        previousFiscalMonths =  12 - currentFiscalMonths;
         
        fiscalMonths.add(currentFiscalMonths);  
        fiscalMonths.add(previousFiscalMonths);                          
        
        //system.debug(' fiscalMonths '+fiscalMonths);
        return fiscalMonths;    
    }
    
    private List<Map<Id,Integer>> fetchQuotaForPastYr(Date startDatep, Set<Id> salesReps){
        
        List<Map<Id,Integer>> priorYearData =  new List<Map<Id,Integer>> ();
        
        Map<Id,Integer> spQuotaMap =  new Map<Id,Integer>();
        
        Map<Id,Integer> spMeetinggMap =  new Map<Id,Integer>();
        Map<Id,Integer> spOppWingMap =  new Map<Id,Integer>();
        Map<Id,Integer> spOppAddedgMap =  new Map<Id,Integer>();
        
        List<YTD_Quota_Revenue__c> previousYearData =  [SELECT Id, Sales_Rep_Profile__c, Annual_Quota_Amount__c,Goal_of_monthly_meetings__c,Goal_of_wins_to_achieve_monthly_quota__c,Goal_of_monthly_opptys_added_to_funnel__c FROM YTD_Quota_Revenue__c WHERE Start_date__c =  :startDatep AND Sales_Rep_Profile__c IN :salesReps AND (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_Quota_Amount__c > 0)];                
        
        for(YTD_Quota_Revenue__c qr: previousYearData){
        
            spQuotaMap.put(qr.Sales_Rep_Profile__c , (Integer)qr.Annual_Quota_Amount__c/12); 
            spMeetinggMap.put(qr.Sales_Rep_Profile__c , (Integer)qr.Goal_of_monthly_meetings__c ); 
            spOppWingMap.put(qr.Sales_Rep_Profile__c , (Integer)qr.Goal_of_wins_to_achieve_monthly_quota__c ); 
            spOppAddedgMap.put(qr.Sales_Rep_Profile__c , (Integer)qr.Goal_of_monthly_opptys_added_to_funnel__c ); 
        }
        
            priorYearData.add(spQuotaMap);
            priorYearData.add(spMeetinggMap);
            priorYearData.add(spOppWingMap);
            priorYearData.add(spOppAddedgMap);
            
        return priorYearData;
    }
    
    private Set<Id> fetchSalesRepIds(List<Sales_Rep_Profile__c> salesReps){
    
        Set<Id> salesRepIds =  new Set<Id>();
        
        for(Sales_Rep_Profile__c sr: salesReps){
            salesRepIds.add(sr.id);
        }
        
        return salesRepIds;
    }
    
    private Set<Id> fetchUserIds(List<Sales_Rep_Profile__c> salesReps){
    
        Set<Id> userIds =  new Set<Id>();
        
        for(Sales_Rep_Profile__c sr: salesReps){
            if(sr.User_Record_Name__c !=  null)
                userIds.add(sr.User_Record_Name__c);
        }
        
        return userIds;
    }
    
    private list<Map<Id,Integer>> fetchCountOfLeads(){
        
        list<Map<Id,Integer>> leadCountMapList =  new list<Map<Id,Integer>>();
        Map<Id,Integer> leadCountMap =  new Map<Id,Integer>();
        
       
        
        // String SOQL =  'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+SOQL_IDs+') AND CreatedDate =  LAST_N_days:365 GROUP BY OwnerId';
        //String SOQL =  'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+SOQL_IDs+') AND CreatedDate >= '+startDate12Months+' AND CreatedDate <= '+endDate12Months+' GROUP BY OwnerId';
        String SOQL =  'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+SOQL_IDs+') AND CreatedDate >= '+startDate12Months+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId';
        system.debug('12 month lead --->'+'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN - AND CreatedDate >= '+startDate12Months+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId');
      
      List<AggregateResult> leadAggrList =  database.query(SOQL);

        for(AggregateResult ar: leadAggrList){
            leadCountMap.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        
        //system.debug(' leadCountMap '+leadCountMap);
         
        leadCountMapList.add(leadCountMap);
        
        Map<Id,Integer> leadCountMapfy =  new Map<Id,Integer>();
         
        String SOQLfy =  'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+SOQL_IDs+') AND CreatedDate >= '+Fisyear+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId';
        system.debug('ytd lead created --->'+'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN - AND CreatedDate >= '+Fisyear+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId');
        
        List<AggregateResult> leadAggrListfy =  database.query(SOQLfy);

        for(AggregateResult ar: leadAggrListfy){
            leadCountMapfy.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        leadCountMapList.add(leadCountMapfy);
        
        Map<Id,Integer> leadCountMapcfy =  new Map<Id,Integer>();
        
        String SOQLcfy =  'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+SOQL_IDs+') AND ConvertedDate >= '+Fyeard +' AND ConvertedDate < '+Cyeard +' AND isconverted =  true GROUP BY OwnerId';
        system.debug('ytd Converted lead --->'+'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN - AND ConvertedDate>= '+Fyeard +' AND ConvertedDate < '+Cyeard +' AND isconverted =  true GROUP BY OwnerId');
        
        //system.debug(' SOQLcfy '+SOQLcfy);
        List<AggregateResult> leadAggrListcfy =  database.query(SOQLcfy);

        for(AggregateResult ar: leadAggrListcfy){
            leadCountMapcfy.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        leadCountMapList.add(leadCountMapcfy);
        
        
        Map<Id,Integer> leadCountMapmn =  new Map<Id,Integer>();
         
        String SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+SOQL_IDs+') AND CreatedDate >= '+startDateMonths+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId';
        system.debug('Monthly lead created --->'+'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN - AND CreatedDate >= '+startDateMonths+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId');
        
        List<AggregateResult> leadAggrListmn =  database.query(SOQLmn);

        for(AggregateResult ar: leadAggrListmn){
            leadCountMapmn.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        leadCountMapList.add(leadCountMapmn);
        
        Map<Id,Integer> leadCountMapq =  new Map<Id,Integer>();
         
        String SOQLq =  'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+SOQL_IDs+') AND CreatedDate >= '+startDates+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId';
        system.debug('Quarterly lead created --->'+'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN - AND CreatedDate >= '+startDates+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId');
        
        List<AggregateResult> leadAggrListq =  database.query(SOQLq);

        for(AggregateResult ar: leadAggrListq){
            leadCountMapq.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        leadCountMapList.add(leadCountMapq);
        
        return leadCountMapList;
    }
    
    private list<Map<Id,Integer>> fetchCountOfMeetings(){
        
        list<Map<Id,Integer>> meetingCountMapList =  new list<Map<Id,Integer>>();
        Map<Id,Integer> meetingCountMap =  new Map<Id,Integer>();
        
        
        string m = '%Meeting%';
        //  String SOQL =  'SELECT OwnerId o, Count(id) c FROM Task WHERE OwnerId IN ('+SOQL_IDs+') AND subject =  '+'\''+m+ '\''+' AND CreatedDate =  LAST_N_days:365 GROUP BY OwnerId';
        //String SOQL =  'SELECT OwnerId o, Count(id) c FROM Task WHERE OwnerId IN ('+SOQL_IDs+') AND subject =  '+'\''+m+ '\''+' AND CreatedDate >= '+startDate12Months+' AND CreatedDate <= '+endDate12Months+' GROUP BY OwnerId';
        String SOQL =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND CreatedDate >= '+startDate12Months+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId';
        system.debug('12 month meeting created --->'+'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN - AND Type Like  '+'\''+m+ '\''+' AND CreatedDate >= '+startDate12Months+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId');
        
        List<AggregateResult> MeetingAggrList =  database.query(SOQL);

        for(AggregateResult ar: MeetingAggrList){
            meetingCountMap.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        
        //system.debug(' meetingCountMap '+meetingCountMap);
         
        meetingCountMapList.add(meetingCountMap);
        
        Map<Id,Integer> meetingCountMapmonth =  new Map<Id,Integer>();
         
        //String SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Task WHERE OwnerId IN ('+SOQL_IDs+') AND subject =  '+'\''+m+ '\''+' AND CreatedDate >= '+startDateMonths+' AND CreatedDate <= '+endDateMonths+' GROUP BY OwnerId';
        String SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND CreatedDate >= '+startDateMonths+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId';
        system.debug('monthly meeting --->'+'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN - AND Type Like  '+'\''+m+ '\''+' AND CreatedDate >= '+startDateMonths+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId');
        
        List<AggregateResult> meetingAggrListmn =  database.query(SOQLmn);

        for(AggregateResult ar: meetingAggrListmn){
            meetingCountMapmonth.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        meetingCountMapList.add(meetingCountMapmonth);
        
        Map<Id,Integer> meetingCountMapq =  new Map<Id,Integer>();
         
        //String SOQLq =  'SELECT OwnerId o, Count(id) c FROM Task WHERE OwnerId IN ('+SOQL_IDs+') AND subject =  '+'\''+m+ '\''+' AND CreatedDate >= '+startDates+' AND CreatedDate <'+endDates+' GROUP BY OwnerId';
        String SOQLq =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND CreatedDate >= '+startDates+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId';
        system.debug('quaterly meeting --->'+'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN - AND Type Like  '+'\''+m+ '\''+' AND CreatedDate >= '+startDates+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId');
        
        List<AggregateResult> meetingAggrListq =  database.query(SOQLq);

        for(AggregateResult ar: meetingAggrListq){
            meetingCountMapq.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        meetingCountMapList.add(meetingCountMapq);
        
        Map<Id,Integer> meetingCountMapytd =  new Map<Id,Integer>();
         
        String SOQLytd =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+')AND Type Like '+'\''+m+ '\''+' AND CreatedDate >= '+Fisyear+' AND CreatedDate < '+Cisyear+'   GROUP BY OwnerId';
        system.debug('ytd meeting --->'+'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN - AND Type Like  '+'\''+m+ '\''+' AND CreatedDate >= '+Fisyear+' AND CreatedDate < '+Cisyear+'   GROUP BY OwnerId');
        
        List<AggregateResult> meetingAggrListytd =  database.query(SOQLytd);

        for(AggregateResult ar: meetingAggrListytd){
            meetingCountMapytd.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        meetingCountMapList.add(meetingCountMapytd);
        
        return meetingCountMapList;
    }
    
    private list<Map<Id,Integer>> fetchCountOfOpp(){
        
        list<Map<Id,Integer>> oppCountMapList =  new list<Map<Id,Integer>>();
        
        String omit = 'Omitted';
        
        Map<Id,Integer> oppCountMapmonth =  new Map<Id,Integer>();
         
        //String SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE OwnerId IN ('+SOQL_IDs+') AND CreatedDate >= '+startDateMonths+' AND CreatedDate <= '+endDateMonths+' GROUP BY OwnerId';
        String SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND CreatedDate >= '+startDateMonths+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId';
        system.debug('monthly opp created --->'+'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN - AND CreatedDate >= '+startDateMonths+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId');
        
        List<AggregateResult> oppAggrListmn =  database.query(SOQLmn);

        for(AggregateResult ar: oppAggrListmn){
            oppCountMapmonth.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        oppCountMapList.add(oppCountMapmonth);
        
        Map<Id,Integer> oppCountMapq =  new Map<Id,Integer>();
        
        //String SOQLq =  'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE OwnerId IN ('+SOQL_IDs+') AND CreatedDate >= '+startDates+' AND CreatedDate <'+endDates+' GROUP BY OwnerId';
        String SOQLq =  'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND CreatedDate >= '+startDates+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId';
        system.debug('quaterly opp created --->'+'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN - AND CreatedDate >= '+startDates+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId');
        
        List<AggregateResult> oppAggrListq =  database.query(SOQLq);

        for(AggregateResult ar: oppAggrListq){
            oppCountMapq.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        oppCountMapList.add(oppCountMapq);
        
        
        return oppCountMapList;
    }
    
    private Map<Id,Integer> fetchOppLost(){
        
        Map<Id,Integer> oppLostMap =  new Map<Id,Integer>();
        
        String stage =  'Closed Lost';
        
        String omit = 'Omitted';
        
        //String SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE OwnerId IN ('+SOQL_IDs+') AND StageName =  '+'\''+stage+'\''+' AND CloseDate >= '+startDateMonthsd+' AND CloseDate <= '+endDateMonthsd+' GROUP BY OwnerId';
             String SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND iswon = false and isclosed = true AND CloseDate >= '+startDateMonthsd+' AND CloseDate < '+Cyeard+' GROUP BY OwnerId';
        system.debug('Monthly opp lost --->'+'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN - iswon = false and isclosed = true AND CloseDate >= '+startDateMonthsd+' AND CloseDate < '+Cyeard+' GROUP BY OwnerId');
        List<AggregateResult> oppAggrList =  database.query(SOQLmn);

        for(AggregateResult ar: oppAggrList){
            if(ar.get('c') != null){
                oppLostMap.put((Id)ar.get('o'),(Integer)ar.get('c'));
            }
            else{
                oppLostMap.put((Id)ar.get('o'),0);
            }
        }
        
        return oppLostMap;
    }
    
    private List<Map<Id,AggregateResult>> fetchQuotaRevenue(){
        
        List<Map<Id,AggregateResult>> oppQuotatMapList =  new List<Map<Id,AggregateResult>>();
        Map<Id,AggregateResult> oppQuotaMapmn=  new Map<Id,AggregateResult>();
        
        String stage =  'Closed Won';
        String omit = 'Omitted';
        
        //String SOQLmn =  'SELECT OwnerId o, SUM(amount) s, Count(id) c FROM Opportunity WHERE OwnerId IN ('+SOQL_IDs+') AND StageName =  '+'\''+stage+'\''+' AND CloseDate >= '+startDateMonthsd+' AND CloseDate <= '+endDateMonthsd+' GROUP BY OwnerId';
        String SOQLmn =  'SELECT OwnerId o, SUM(amount) s, Count(id) c FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND iswon = true AND CloseDate >= '+startDateMonthsd+' AND CloseDate < '+Cyeard+' GROUP BY OwnerId';
        system.debug('Monthly opp won and revenue --->'+'SELECT OwnerId o, SUM(amount) s, Count(id) c FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN - AND iswon = true AND CloseDate >= '+startDateMonthsd+' AND CloseDate < '+Cyeard+' GROUP BY OwnerId');
        
        List<AggregateResult> oppAggrListmn =  database.query(SOQLmn);

        for(AggregateResult ar: oppAggrListmn){
            oppQuotaMapmn.put((Id)ar.get('o'), ar);
        }
        oppQuotatMapList.add(oppQuotaMapmn);
        
        Map<Id,AggregateResult> oppQuotaMapq =  new Map<Id,AggregateResult>();
        
        //String SOQLq =  'SELECT OwnerId o, Count(id) c , SUM(amount) s FROM Opportunity WHERE OwnerId IN ('+SOQL_IDs+') AND StageName =  '+'\''+stage+'\''+' AND CloseDate >= '+startd+' AND CloseDate <'+endd+' GROUP BY OwnerId';
        String SOQLq =  'SELECT OwnerId o, Count(id) c , SUM(amount) s FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND iswon = true AND CloseDate >= '+startd+' AND CloseDate < '+Cyeard+' GROUP BY OwnerId';
        system.debug('quaterly opp won and revenue --->'+'SELECT OwnerId o, Count(id) c , SUM(amount) s FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN - AND iswon = true AND CloseDate >= '+startd+' AND CloseDate < '+Cyeard+' GROUP BY OwnerId');
        
        //system.debug('SOQLq'+SOQLq);
        List<AggregateResult> oppAggrListq =  database.query(SOQLq);

        for(AggregateResult ar: oppAggrListq){
            oppQuotaMapq.put((Id)ar.get('o'), ar);
        }
        oppQuotatMapList.add(oppQuotaMapq);
        
        Map<Id,AggregateResult> oppQuotaMapYtd =  new Map<Id,AggregateResult>();
        
        String SOQLytd =  'SELECT OwnerId o, Count(id) c , SUM(amount) s FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND iswon = true AND CloseDate >= '+Fs+' AND CloseDate < '+Cs+' GROUP BY OwnerId';
        system.debug('ytd opp won and reven --->'+'SELECT OwnerId o, Count(id) c , SUM(amount) s FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN - AND iswon = true AND CloseDate >= '+Fs+' AND CloseDate < '+Cs+' GROUP BY OwnerId');
        
        //system.debug('SOQLytd'+SOQLytd);
        List<AggregateResult> oppAggrListYtd =  database.query(SOQLytd);

        for(AggregateResult ar: oppAggrListYtd){
            oppQuotaMapYtd.put((Id)ar.get('o'), ar);
        }
        oppQuotatMapList.add(oppQuotaMapYtd);
        
        return oppQuotatMapList;
        
    }
    
    private List<Map<Id,AggregateResult>> fetchQuotaRevenueTotal(){
        
        List<Map<Id,AggregateResult>> oppQuotatMapList =  new List<Map<Id,AggregateResult>>();
        Map<Id,AggregateResult> oppQuotaMapmn=  new Map<Id,AggregateResult>();
        
        String omit = 'Omitted';
        
        //String SOQLmn =  'SELECT OwnerId o, SUM(amount) s, Count(id) c FROM Opportunity WHERE OwnerId IN ('+SOQL_IDs+') AND  CloseDate >= '+startDateMonthsd+' AND CloseDate <= '+endDateMonthsd+' GROUP BY OwnerId';
        String SOQLmn =  'SELECT OwnerId o, SUM(amount) s, Count(id) c FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND  CloseDate >= '+startDateMonthsd+' AND CloseDate < '+Cyeard+' AND Probability >='+userprob+' GROUP BY OwnerId';
        system.debug('monthly Count and sum of amount closedate --->'+'SELECT OwnerId o, SUM(amount) s, Count(id) c FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN - AND  CloseDate >= '+startDateMonthsd+' AND CloseDate < '+Cyeard+' AND Probability >='+userprob+' GROUP BY OwnerId');
        
        List<AggregateResult> oppAggrListmn =  database.query(SOQLmn);

        for(AggregateResult ar: oppAggrListmn){
            oppQuotaMapmn.put((Id)ar.get('o'), ar);
        }
        oppQuotatMapList.add(oppQuotaMapmn);
        
        Map<Id,AggregateResult> oppQuotaMapq =  new Map<Id,AggregateResult>();
        
        //String SOQLq =  'SELECT OwnerId o, Count(id) c , SUM(amount) s FROM Opportunity WHERE OwnerId IN ('+SOQL_IDs+') AND  CloseDate >= '+startd+' AND CloseDate <'+endd+' GROUP BY OwnerId';
        String SOQLq =  'SELECT OwnerId o, Count(id) c , SUM(amount) s FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND  CloseDate >= '+startd+' AND CloseDate <'+Cyeard+' AND Probability >='+userprob+' GROUP BY OwnerId';
        
        system.debug('quaterly Count and sum of amount closedate --->'+'SELECT OwnerId o, Count(id) c , SUM(amount) s FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN - AND  CloseDate >= '+startd+' AND CloseDate <'+Cyeard+' AND Probability >='+userprob+' GROUP BY OwnerId');
        
        List<AggregateResult> oppAggrListq =  database.query(SOQLq);

        for(AggregateResult ar: oppAggrListq){
            oppQuotaMapq.put((Id)ar.get('o'), ar);
        }
        oppQuotatMapList.add(oppQuotaMapq);
        
        Map<Id,AggregateResult> oppQuotaMapYtd =  new Map<Id,AggregateResult>();
        
        String SOQLytd =  'SELECT OwnerId o, Count(id) c , SUM(amount) s FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+')  AND CloseDate >= '+Fs+' AND CloseDate < '+Cs+' AND Probability >='+userprob+' GROUP BY OwnerId';
        system.debug('ytd Count and sum of amount closedate --->'+'SELECT OwnerId o, Count(id) c , SUM(amount) s FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN -  AND CloseDate >= '+Fs+' AND CloseDate < '+Cs+' AND Probability >='+userprob+' GROUP BY OwnerId');
        
        List<AggregateResult> oppAggrListYtd =  database.query(SOQLytd);

        for(AggregateResult ar: oppAggrListYtd){
            oppQuotaMapYtd.put((Id)ar.get('o'), ar);
        }
        oppQuotatMapList.add(oppQuotaMapYtd);
        
        return oppQuotatMapList;
        
    }
    
     private Map<Id,AggregateResult>  fetch12CloseRate(){
        
        Map<Id,AggregateResult> c12CloseRatelist  =  new  Map<Id,AggregateResult>();
       
        //String SOQLmn =  'SELECT User_Record_Name__c o,COUNT(id) cid, SUM(Monthly_Close_Rate__c) scr, SUM(Monthly_Opportunity_Close_Rate__c) ocr FROM Sales_Rep_Profile_Snapshot__c WHERE User_Record_Name__c IN ('+SOQL_IDs+')  AND CreatedDate =  LAST_N_days:365 GROUP BY User_Record_Name__c';
        String SOQLmn =  'SELECT User_Record_Name__c o,COUNT(id) cid,SUM (Monthly_QO_added_Quantitative__c)mqoa, SUM(Monthly_Close_Rate__c) scr, SUM(Monthly_Opportunity_Close_Rate__c) ocr FROM Sales_Rep_Profile_Snapshot__c WHERE User_Record_Name__c IN ('+SOQL_IDs+')  AND Snapshot_Scheduled_Date__c  >=  '+ startDate12Monthsd+' AND (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_Quota_Amount__c > 0) GROUP BY User_Record_Name__c';
        
        List<AggregateResult> ar12CloseRatelist =  database.query(SOQLmn);

        for(AggregateResult ar: ar12CloseRatelist){
            c12CloseRatelist.put((Id)ar.get('o'), ar);
        }
         //system.debug('c12CloseRatelist'+c12CloseRatelist);
         return c12CloseRatelist;
        
    }
    
    private void generateDates(){
        Fyear =  FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        //Fyeard =  FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        Fisyear = Fyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
       
        Cyear =  triggerDate ;  
        Cisyear = Cyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
       // static date  Cyear =  datetime.newInstance(2018, 3, 31, 0, 0, 0);
       
        Fyeard =  Fisyear.substring(0,10);
        Cyeard =  Cisyear.substring(0,10);
        //This is used under dynamic query for Annual Added             
                 
        Q0 =  Fyear ;
        Q1 =  Fyear.addMonths(3);
        Q2 =  Q1.addMonths(3);
        Q3 =  Q2.addMonths(3);
        Q4 =  Q3.addMonths(3);
        //system.debug(Q0);
        //system.debug(Q1);
        //system.debug('Cyear'+Cyear);
        
        if( (Q0 <=  Cyear) && (Cyear <= Q1)){
        
            startDate=  Q0;
            endDate =  Q1;
            Quarter =  'Q1';
            //system.debug('Q1');
                      
        }else if((Q1 <=  Cyear) && (Cyear <= Q2)){
        
            startDate=  Q1;
            endDate =  Q2;
            Quarter =  'Q2';
            
        }else if((Q2 <=  Cyear) && (Cyear <= Q3)){
        
            startDate=  Q2;
            endDate =  Q3;
            Quarter =  'Q3';
            
        }else if((Q3 <=  Cyear) && (Cyear <= Q4)){
        
            startDate=  Q3;
            endDate =  Q4;
            Quarter =  'Q4';
        
        }  
       //system.debug('Cyear.Monthgmt()'+Cyear.Monthgmt());  
       //system.debug('Cyear.yearGmt()'+Cyear.yearGmt());
       
       //system.debug('endDate.Monthgmt()'+endDate.Monthgmt());
       if( endDate !=  null && Cyear.Monthgmt() ==  endDate.Monthgmt()-1){
           quat =  true;
       }
       
       startDates =  startDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
       endDates =  endDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
        
        Integer yr = Cyear.yearGmt();
        Integer mn = Cyear.monthGmt();
        
        dateTime dt = triggerDateminus1 ;
        Integer yrtm1 = dt.yearGmt();
        Integer mntm1 = dt.monthGmt();
        
        startDateMonth =  Datetime.newInstance(yrtm1 ,mntm1 ,1);
        endDateMonth =  Datetime.newInstance(yr,mn,Date.daysInMonth(yr,mn));                 
        
        Integer offset = UserInfo.getTimezone().getOffset(startDateMonth);
        
        startDateMonth = startDateMonth.addSeconds(offset/1000);
        endDateMonth = endDateMonth.addSeconds(offset/1000);
        
        startDateMonths =  startDateMonth.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        endDateMonths =  endDateMonth.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
        
        startDateMonthsd =  startDateMonths.substring(0, 10);
        endDateMonthsd =  endDateMonths.substring(0, 10);
        
        endDate12Month =  Cyear;
        startDate12Month =   datetime.newInstance(dt.yearGmt()-1 , dt.monthGmt()+1, 1);
        startDate12Month =   startDate12Month.addSeconds(offset/1000);      
        
        startDate12Months =  startDate12Month.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        endDate12Months =  endDate12Month.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
        
        startDate12Monthsd =  startDate12Months.substring(0, 10);
        endDate12Monthsd =  endDate12Months.substring(0, 10);
        
        startd =  startDates.substring(0, 10);
        endd =  endDates.substring(0, 10);
        Fs =  Fisyear.substring(0, 10);
        Cs=  Cyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        Cs =  cs.substring(0, 10);
        //system.debug('startDates---->'+startDates);
        //system.debug('endDates---->'+endDates);
        //system.debug('startd---->'+startd);
        //system.debug('endd---->'+endd);
        //system.debug('Fs---->'+Fs);
        //system.debug('Cs---->'+Cs);
        //system.debug('Cyear.Monthgmt()---->'+Cyear.Monthgmt());
        //system.debug('startDateMonths ---->'+startDateMonths );
        //system.debug('endDateMonths ---->'+endDateMonths );
        //system.debug('startDateMonthsd ---->'+startDateMonthsd);
        //system.debug('endDate12Months ---->'+endDateMonthsd);
        //system.debug('startDate12Months---->'+startDate12Months);
        //system.debug('endDate12Months ---->'+endDate12Months);
        //system.debug('startDate12Monthsd ---->'+startDate12Monthsd );
        //system.debug('endDate12Monthsd ---->'+endDate12Monthsd );
        // integer i =  endDate.Monthgmt()-1;
        // system.debug('endDate.Monthgmt()-1---->'+ i);
        
        //This is used under dynamic query for Monthly Added   
        List<Application_Setting__c> prob = [SELECT Id, Probability__c FROM Application_Setting__c limit 1];
        
        if(prob != null && prob.size()>0){
            userprob = prob[0].Probability__c;
        }   
        system.debug('userprob -->'+userprob);
    }
    
    private void generateSoqlId(Set<Id> userIds){
        
          SOQL_IDs = '';
        
        for (Id id : userIds) {
        
            String id_in_quotes =  '\''+id+'\'';
           
            if (SOQL_IDs !=  '') { 
                SOQL_IDs+= ','; 
            }
           
            SOQL_IDs +=  id_in_quotes;
        }
        
        //system.debug(' SOQL_IDs '+SOQL_IDs);
    } 
    
    /* Custom metadata code */
    
    private Map<id,Decimal> fetchRevenueNumbers(String SOQL_IDs, String startDate12Monthsd, String Cyeard){
        
        Map<id,Decimal> ownerAmtMap = new Map<id,Decimal>();
            
        List<AggregateResult> oppAggrAmt = new List<AggregateResult>();                         
        
        String omit = 'Omitted';
        
        if(lstCustMd != null && lstCustMd.size() > 0){                    
            
            for (String recTypeName : recTypeFldMap.keySet()){
                
                String q;
                q = 'SELECT ownerId o ';
        
                if(lstCustMd[0].Action__c == 'Add'){
                    q += ', SUM(amount) s ';
                }
            
                List<String> flds = recTypeFldMap.get(recTypeName);
                
                for(Integer i = 0; i < flds.size(); i++){
                    q += ', SUM('+flds[i]+') '+flds[i];       
                }
                
                q += ' FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND  iswon = true AND CloseDate >=  '+ startDate12Monthsd+' AND CloseDate <  '+ Cyeard+' AND RecordTypeId = '+'\''+recTypeNameIdMap.get(recTypeName)+'\''+' GROUP BY OwnerId';
                
                oppAggrAmt = database.query(q);
                
                for(AggregateResult ar: oppAggrAmt){
                    
                    Decimal totAmt = 0;
                    
                    if(lstCustMd[0].Action__c == 'Add'){
                                                    
                        if(ar.get('s') != null)
                            totAmt  += (Decimal)ar.get('s');
                    }
                        
                    for(Integer i = 0; i < flds.size(); i++){
                        if(ar.get(flds[i]) != null)
                            totAmt += (Decimal)ar.get(flds[i]);       
                    }                            
                
                    if(!ownerAmtMap.containsKey((id)ar.get('o'))){
                        ownerAmtMap.put((id)ar.get('o'),(Decimal)totAmt);        
                    }
                    else{
                        Decimal amt = ownerAmtMap.get('o');
                        amt += totAmt;                           
                        ownerAmtMap.put((id)ar.get('o'),amt);
                    }
                       
                } 
                
                                   
            }                                
                            
            /*for(Client_custom_field_mapping__mdt cm: lstCustMd){
                q += ', SUM('+cm.Custom_field_name__c+') '+cm.Custom_field_name__c;    
            }*/
               
        }
        else{
            
            String q = 'SELECT ownerId o, SUM(amount) s, FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND  iswon = true AND CloseDate >=  '+ startDate12Monthsd+' AND CloseDate <  '+ Cyeard+' GROUP BY OwnerId'; 
            
            oppAggrAmt = database.query(q);
            
            for(AggregateResult ar: oppAggrAmt){                    
                if(ar.get('s') != null){
                    ownerAmtMap.put((id)ar.get('o'),(Decimal)ar.get('s'));        
                }
            }
        }
        
        return ownerAmtMap;
    } 
    
    /* Custom metadata code */
}