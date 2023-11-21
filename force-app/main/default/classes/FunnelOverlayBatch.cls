/*
Copyright: Funnel Metrics, LLC
*/
global with Sharing class FunnelOverlayBatch implements Database.Batchable < sobject > , Database.Stateful {

  Date triggerDate;
  Boolean chainBatch;
  Boolean histVal;
  Date triggerDateminus1;
  List<Sales_Rep_Profile__c> allSrp = new List<Sales_Rep_Profile__c>();

  Boolean errorVal = false;
  public Boolean updateAccess = true;
  public static String prefix {
    get {
      return 'FunnelMetrics__';
    }
    set;
  }

  public String orgid;

  public FunnelOverlayBatch(Date scheduleDate, Boolean chain, Boolean historical) {

    triggerDateminus1 = scheduleDate;
    triggerDate = scheduleDate.addDays(1);

    chainBatch = chain;
    histVal = historical;
    updateAccess = true;
    orgid = UserInfo.getOrganizationId();

  }

  public Database.QueryLocator start(Database.BatchableContext con) {
    return Database.getQueryLocator('select id,name,Profile_Type__c,Goal_of_monthly_leads_to_achieve_quota__c,User_Record_Name__r.name,Time_to_Tenured_Average_Rev__c ,Role__c,Tenure_in_current_role__c,Rep_start_date__c,YTD_Revenue__c,Quarterly_Quota_Revenue__c ,Monthly_Quota_Revenue__c,Monthly_lost_QO_Amt__c,Quarterly_lost_QO_Amt__c,Ytd_lost_QO_Amt__c,Monthly_lost_QO__c,Quarterly_lost_QO__c,Ytd_lost_QO__c, Annual_Quota_Amount__c,Goal_of_monthly_meetings__c,Goal_of_wins_to_achieve_monthly_quota__c,Goal_of_monthly_opptys_added_to_funnel__c,Q1_Quota_Amount__c,Q2_Quota_Amount__c,Q3_Quota_Amount__c,Q4_Quota_Amount__c ,Month_1_Quota_Amount__c,Month_2_Quota_Amount__c,Month_3_Quota_Amount__c,Month_4_Quota_Amount__c,Month_5_Quota_Amount__c,Month_6_Quota_Amount__c,Month_7_Quota_Amount__c,Month_8_Quota_Amount__c,Month_9_Quota_Amount__c,Month_10_Quota_Amount__c,Month_11_Quota_Amount__c,Month_12_Quota_Amount__c,User_Record_Name__c,Close_rate_monthly_opp_amount__c,Close_rate_monthly_opp_count__c,Close_rate_Quarterly_opp_amount__c,Close_rate_Quarterly_opp_count__c,Close_rate_YTD_opp_amount__c,Close_rate_YTD_opp_count__c, Monthly_QO_added__c, Quarterly_QO_added__c, Ytd_QO_added__c, User_Record_Name__r.CreatedDate from Sales_Rep_Profile__c WHERE Profile_Type__c = \'Overlay\' AND (Active__c = TRUE OR Annual_Quota_Amount__c > 0) ');
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
  public String SOQL_IDs;
  public String Quarter;
  public integer numberofmonth;
  public string startd;
  public string endd;
  public string Fs;
  public string Cs;
  public boolean quat = false;

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

  //public static List < Funnel_Overlay__mdt > olayCustMd;
  @testVisible public static List<Funnel_Overlay__mdt > olayCustMd{ 
get{ 
    if(olayCustMd== NULL){ 
        olayCustMd= [SELECT Object_Name__c, Field_Name__c, Split_Field_Name__c, Amount_Field_Name__c, Date_Field_Name__c FROM Funnel_Overlay__mdt Where Object_Name__c != null]; 
    } 
    return olayCustMd; 
} 
set; 
} 
  public static Map<String, Decimal> conversionRates = new Map<String, Decimal>();
  public static Boolean multiCurrencyEnabled;
  
  public void execute(Database.BatchableContext con, List < Sales_Rep_Profile__c > srp) {
    System.debug('srp' + srp);
    try {
      if (updateAccess) {
     /*   if(!Test.isRunningTest()){
            olayCustMd = new List < Funnel_Overlay__mdt > ();
            olayCustMd = [SELECT Object_Name__c, Field_Name__c, Split_Field_Name__c, Amount_Field_Name__c, Date_Field_Name__c FROM Funnel_Overlay__mdt Where Object_Name__c != null];
        }*/
        System.debug('olayCustMd ' + olayCustMd);

        if (olayCustMd != null && olayCustMd.size() > 0) {
          generateDates();
         
          multiCurrencyEnabled = Schema.getGlobalDescribe().containsKey('CurrencyType');
          if(multiCurrencyEnabled){
             createConvertionRateMap();
          }
          
          //List of sales rep ids that are being processed
          Set < Id > srIds = fetchSalesRepIds(srp);

          //List of user ids associated with the sales reps
          Set < Id > userIds = fetchUserIds(srp);
          generateSoqlId(userIds);

          Map < Id, Decimal > mnRevenue = monthlyRev();
          Map < Id, Decimal > qtRevenue = fetchQtRevenue();
          Map < Id, Decimal > ytdRevenue = fetchYtdRevenue();
          Map < Id, Decimal > x12MonthRevenue = fetch12MonthRevenue();

          for (Sales_Rep_Profile__c s: srp) {

            if (s.Profile_Type__c == 'Overlay') {
              if (mnRevenue.keySet().contains(s.User_Record_Name__c) && mnRevenue.get(s.User_Record_Name__c) != null) {
                s.Monthly_Quota_Revenue__c = mnRevenue.get(s.User_Record_Name__c);
              } else {
                s.Monthly_Quota_Revenue__c = 0;
              }

              if (qtRevenue.keySet().contains(s.id) && qtRevenue.get(s.id) != null) {
                s.Quarterly_Quota_Revenue__c = qtRevenue.get(s.id) + s.Monthly_Quota_Revenue__c;
              } else {
                s.Quarterly_Quota_Revenue__c = 0 + s.Monthly_Quota_Revenue__c;
              }

              if (ytdRevenue.keySet().contains(s.id) && ytdRevenue.get(s.id) != null) {
                s.YTD_Revenue__c = ytdRevenue.get(s.id) + s.Monthly_Quota_Revenue__c;
              } else {
                s.YTD_Revenue__c = 0 + s.Monthly_Quota_Revenue__c;
              }

              if (x12MonthRevenue.keySet().contains(s.id) && x12MonthRevenue.get(s.id) != null) {
                s.X12_Month_Rolling_Revenue__c = x12MonthRevenue.get(s.id) + s.Monthly_Quota_Revenue__c;
              } else {
                s.X12_Month_Rolling_Revenue__c = 0 + s.Monthly_Quota_Revenue__c;
              }

            }
          }

          System.debug('update srp' + srp);
          allSrp.addAll(srp);
          //update srp;
        }
      }
    } catch (Exception ex) {
      errorVal = true;
      FunnelTriggerBatchHelper.sendErrorMail(' FunnelOverlayBatch ' + ex.getMessage() + ' ' + ex.getStackTraceString() + ' line number: ' + ex.getLineNumber() + ' cause ' + ex.getCause());
    }
  }

  public void finish(Database.BatchableContext con) {
    
    try{
        update allSrp;
    }catch (Exception ex) {
      errorVal = true;
      FunnelTriggerBatchHelper.sendErrorMail(' FunnelOverlayBatch ' + ex.getMessage() + ' ' + ex.getStackTraceString() + ' line number: ' + ex.getLineNumber() + ' cause ' + ex.getCause());
    }
    //FunnelTriggerBatchHelper.sendErrorMail(' Funnel12MonthBatch finish method');
    if (!errorVal) {
      if (!histVal) {
        //   FunnelTriggerBatchHelper.sendErrorMail(' Funnel12MonthBatch finish method no error');
      }

      //system.debug(' triggerDateminus1 '+triggerDateminus1);
      if (chainBatch) {
        Funnel12MonthBatch fm = new Funnel12MonthBatch(triggerDateminus1, chainBatch, histVal);
        Database.executeBatch(fm);
      }

    }
  }

  private Set < Id > fetchSalesRepIds(List < Sales_Rep_Profile__c > salesReps) {

    Set < Id > salesRepIds = new Set < Id > ();

    for (Sales_Rep_Profile__c sr: salesReps) {
      salesRepIds.add(sr.id);
    }

    return salesRepIds;
  }

  private Set < Id > fetchUserIds(List < Sales_Rep_Profile__c > salesReps) {

    Set < Id > userIds = new Set < Id > ();

    for (Sales_Rep_Profile__c sr: salesReps) {
      if (sr.User_Record_Name__c != null)
        userIds.add(sr.User_Record_Name__c);
    }

    return userIds;
  }

  private void generateSoqlId(Set < Id > userIds) {

    //FunnelTriggerBatchHelper.sendErrorMail(' userIds are '+userIds.size());                                                          

    SOQL_IDs = '';

    for (Id id: userIds) {

      String id_in_quotes = '\'' + id + '\'';

      if (SOQL_IDs != '') {
        SOQL_IDs += ',';
      }

      SOQL_IDs += id_in_quotes;
    }

    //FunnelTriggerBatchHelper.sendErrorMail(' Ids queried are '+SOQL_IDs);                                                          

    ////system.debug(' SOQL_IDs '+SOQL_IDs);
  }

  private void generateDates() {
    Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
    //Fyeard =  FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
    Fisyear = Fyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');

    Cyear = triggerDate;
    Cisyear = Cyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
    // static date  Cyear =  datetime.newInstance(2018, 3, 31, 0, 0, 0);

    Fyeard = Fisyear.substring(0, 10);
    Cyeard = Cisyear.substring(0, 10);
    //This is used under dynamic query for Annual Added             

    Q0 = Fyear;
    Q1 = Fyear.addMonths(3);
    Q2 = Q1.addMonths(3);
    Q3 = Q2.addMonths(3);
    Q4 = Q3.addMonths(3);
    ////system.debug(Q0);
    ////system.debug(Q1);
    ////system.debug('Cyear'+Cyear);

    if ((Q0 <= Cyear) && (Cyear <= Q1)) {

      startDate = Q0;
      endDate = Q1;
      Quarter = 'Q1';
      ////system.debug('Q1');

    } else if ((Q1 <= Cyear) && (Cyear <= Q2)) {

      startDate = Q1;
      endDate = Q2;
      Quarter = 'Q2';

    } else if ((Q2 <= Cyear) && (Cyear <= Q3)) {

      startDate = Q2;
      endDate = Q3;
      Quarter = 'Q3';

    } else if ((Q3 <= Cyear) && (Cyear <= Q4)) {

      startDate = Q3;
      endDate = Q4;
      Quarter = 'Q4';

    }
    ////system.debug('Cyear.Monthgmt()'+Cyear.Monthgmt());  
    ////system.debug('Cyear.yearGmt()'+Cyear.yearGmt());

    ////system.debug('endDate.Monthgmt()'+endDate.Monthgmt());
    if (endDate != null && Cyear.Monthgmt() == endDate.Monthgmt() - 1) {
      quat = true;
    }

    startDates = startDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
    endDates = endDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');

    Integer yr = Cyear.yearGmt();
    Integer mn = Cyear.monthGmt();

    dateTime dt = triggerDateminus1;
    Integer yrtm1 = dt.yearGmt();
    Integer mntm1 = dt.monthGmt();

    startDateMonth = Datetime.newInstance(yrtm1, mntm1, 1);
    endDateMonth = Datetime.newInstance(yr, mn, Date.daysInMonth(yr, mn));

    Integer offset = UserInfo.getTimezone().getOffset(startDateMonth);

    startDateMonth = startDateMonth.addSeconds(offset / 1000);
    endDateMonth = endDateMonth.addSeconds(offset / 1000);

    startDateMonths = startDateMonth.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
    endDateMonths = endDateMonth.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');

    startDateMonthsd = startDateMonths.substring(0, 10);
    endDateMonthsd = endDateMonths.substring(0, 10);

    endDate12Month = Cyear;
    startDate12Month = datetime.newInstance(dt.yearGmt() - 1, dt.monthGmt() + 1, 1);
    startDate12Month = startDate12Month.addSeconds(offset / 1000);

    startDate12Months = startDate12Month.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
    endDate12Months = endDate12Month.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');

    startDate12Monthsd = startDate12Months.substring(0, 10);
    endDate12Monthsd = endDate12Months.substring(0, 10);

    startd = startDates.substring(0, 10);
    endd = endDates.substring(0, 10);
    Fs = Fisyear.substring(0, 10);
    Cs = Cyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
    Cs = cs.substring(0, 10);

    system.debug('Cyeard R' + Cyeard);
    system.debug('Cs R' + Cs);
    system.debug('startd R' + startd);
  }

  public Map < id, Decimal > monthlyRev() {

    String objName = '';
    String fieldName = '';
    String amountFieldName = '';
    String splitFieldName = '';
    String dateFieldName = '';
    Boolean isDate;
    List < String > fieldNameSet = new List < String > ();
    Set < String > splitFieldNameSet = new Set < String > ();
    //Set<String> allField;
    Map < String, String > filedAndSplit = new Map < String, String > ();
    Map < id, Decimal > retunrMap = new Map < id, Decimal > ();
    String queryString;
    String whereClause;
    whereClause = ' Where (';

    system.debug('start getCpuTime' + Limits.getCpuTime());
    if (olayCustMd != null && olayCustMd.size() > 0) {
       system.debug('olayCustMd ' + olayCustMd );
      objName = olayCustMd[0].Object_Name__c;
      dateFieldName = olayCustMd[0].Date_Field_Name__c;
      amountFieldName = olayCustMd[0].Amount_Field_Name__c;

      SObjectType r = ((SObject)(Type.forName('Schema.' + objName).newInstance())).getSObjectType();
      DescribeSObjectResult d = r.getDescribe();
      if (d.fields.getMap().get(dateFieldName).getDescribe().getType() == Schema.DisplayType.DATE) {
        isDate = true;
      } else if (d.fields.getMap().get(dateFieldName).getDescribe().getType() == Schema.DisplayType.DATETIME) {
        isDate = false;
      }

      for (Funnel_Overlay__mdt ol: olayCustMd) {

        if (ol.Field_Name__c != null && !fieldNameSet.contains(ol.Field_Name__c)) {
          if (fieldName == '') {
            fieldName = ol.Field_Name__c;
            whereClause += ol.Field_Name__c + ' IN (' + SOQL_IDs + ') ';
          } else {
            fieldName += ', ' + ol.Field_Name__c;
            whereClause += ' OR ' + ol.Field_Name__c + ' IN (' + SOQL_IDs + ') ';
          }
          fieldNameSet.add(ol.Field_Name__c);

        }

        if (ol.Split_Field_Name__c != '' && ol.Split_Field_Name__c != null && !splitFieldNameSet.contains(ol.Split_Field_Name__c)) {
          splitFieldName += ', ' + ol.Split_Field_Name__c;
          splitFieldNameSet.add(ol.Split_Field_Name__c);
        }

        if (ol.Split_Field_Name__c != '' && ol.Split_Field_Name__c != null) {
          filedAndSplit.put(ol.Field_Name__c, ol.Split_Field_Name__c);
        }
      }
      if (fieldNameSet != null && fieldNameSet.size() > 0) {
        whereClause += ')';
      }
      if (isDate) {
        whereClause += ' AND ' + dateFieldName + ' >= ' + startDateMonthsd + ' AND ' + dateFieldName + ' <  ' + Cyeard;
      } else {
        whereClause += ' AND ' + dateFieldName + ' >= ' + startDateMonths + ' AND ' + dateFieldName + ' <  ' + Cisyear;
      }
      
      if(multiCurrencyEnabled){
          queryString = 'Select CurrencyIsoCode, ' + fieldName + ' ' + splitFieldName + ' ,' + amountFieldName + ' From ' + objName + whereClause;
      }else{
          queryString = 'Select ' + fieldName + ' ' + splitFieldName + ' ,' + amountFieldName + ' From ' + objName + whereClause;
      }
      

      System.debug('queryString ' + queryString);

      List < sObject > re = database.query(queryString);

      if (re != null && re.size() > 0) {
        for (sObject rr: re) {
          if ((Decimal) rr.get(amountFieldName) != null && (Decimal) rr.get(amountFieldName) > 0) {
            for (Integer i = 0; i < fieldNameSet.size(); i++) {
              if (rr.get(fieldNameSet[i]) != null) {
                if (!retunrMap.containsKey((String) rr.get(fieldNameSet[i]))) {
                  Decimal totAmt = 0;
                  if (filedAndSplit.containsKey(fieldNameSet[i]) && (Decimal) rr.get(filedAndSplit.get(fieldNameSet[i])) != null) {
                    totAmt = (Decimal) rr.get(amountFieldName) * (Decimal) rr.get(filedAndSplit.get(fieldNameSet[i])) / 100;
                  } else {
                    totAmt = (Decimal) rr.get(amountFieldName);
                  }
                  if(multiCurrencyEnabled && totAmt > 0){
                      String currencyCode = (String)rr.get('CurrencyIsoCode');
                      String cr = 'CurrencyIsoCode';    
                      totAmt = totAmt / conversionRates.get(currencyCode);
                  }
                  retunrMap.put((String) rr.get(fieldNameSet[i]), totAmt);
                } else {
                  Decimal totAmt = 0;
                  if (filedAndSplit.containsKey(fieldNameSet[i]) && (Decimal) rr.get(filedAndSplit.get(fieldNameSet[i])) != null) {
                    totAmt += (Decimal) rr.get(amountFieldName) * (Decimal) rr.get(filedAndSplit.get(fieldNameSet[i])) / 100;
                  } else {
                    totAmt += (Decimal) rr.get(amountFieldName);
                  }
                  if(multiCurrencyEnabled && totAmt > 0){
                      String currencyCode = (String)rr.get('CurrencyIsoCode');
                      String cr = 'CurrencyIsoCode';    
                      totAmt = totAmt / conversionRates.get(currencyCode);
                  }
                  Decimal amt = (Decimal) retunrMap.get((String) rr.get(fieldNameSet[i]));
                  amt += totAmt;
                  retunrMap.put((String) rr.get(fieldNameSet[i]), amt);
                }

              }

            }
          }
        }
      }
    }
    system.debug('end getCpuTime' + Limits.getCpuTime());
    System.debug('queryString ' + queryString);

    return retunrMap;
  }

  private Map < Id, Decimal > fetch12MonthRevenue() {

    Map < Id, Decimal > list12MonthRevenue = new Map < Id, Decimal > ();

    String SOQL12 = 'SELECT Sales_Rep_Profile__c i, SUM(Monthly_Quota_Revenue__c) mqr    FROM Sales_Rep_Profile_Snapshot__c WHERE Snapshot_Scheduled_Date__c  >=  ' + startDate12Monthsd + ' AND Snapshot_Scheduled_Date__c <' + Cyeard + ' AND Profile_Type__c = \'Overlay\' AND Sales_rep_profile__r.Profile_Type__c = \'Overlay\' AND (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_Quota_Amount__c > 0) GROUP BY Sales_Rep_Profile__c';

    System.debug('SOQL12 ' + SOQL12);

    List < AggregateResult > ar12revenue = database.query(SOQL12);

    for (AggregateResult ar: ar12revenue) {
      list12MonthRevenue.put((Id) ar.get('i'), (Decimal) ar.get('mqr'));
    }

    return list12MonthRevenue;

  }

  private Map < Id, Decimal > fetchYtdRevenue() {

    Map < Id, Decimal > listYtdRevenue = new Map < Id, Decimal > ();

    String SOQLYtd = 'SELECT Sales_Rep_Profile__c i, SUM(Monthly_Quota_Revenue__c) mqr    FROM Sales_Rep_Profile_Snapshot__c WHERE Snapshot_Scheduled_Date__c  >=  ' + Fs + ' AND Snapshot_Scheduled_Date__c <' + Cs + ' AND Profile_Type__c = \'Overlay\' AND Sales_rep_profile__r.Profile_Type__c = \'Overlay\'  AND (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_Quota_Amount__c > 0) GROUP BY Sales_Rep_Profile__c';

    System.debug('SOQLYtd  ' + SOQLYtd);

    List < AggregateResult > arYtdrevenue = database.query(SOQLYtd);

    for (AggregateResult ar: arYtdrevenue) {
      listYtdRevenue.put((Id) ar.get('i'), (Decimal) ar.get('mqr'));
    }

    return listYtdRevenue;

  }

  private Map < Id, Decimal > fetchQtRevenue() {

    Map < Id, Decimal > listQtRevenue = new Map < Id, Decimal > ();

    String SOQLQt = 'SELECT Sales_Rep_Profile__c i, SUM(Monthly_Quota_Revenue__c) mqr    FROM Sales_Rep_Profile_Snapshot__c WHERE Snapshot_Scheduled_Date__c  >=  ' + startd + ' AND Snapshot_Scheduled_Date__c <' + Cs + ' AND Profile_Type__c = \'Overlay\'  AND Sales_rep_profile__r.Profile_Type__c = \'Overlay\'  AND (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_Quota_Amount__c > 0) GROUP BY Sales_Rep_Profile__c';

    System.debug('SOQLQt ' + SOQLQt);

    List < AggregateResult > arQtrevenue = database.query(SOQLQt);

    for (AggregateResult ar: arQtrevenue) {
      listQtRevenue.put((Id) ar.get('i'), (Decimal) ar.get('mqr'));
    }

    return listQtRevenue;
  }
  public static void createConvertionRateMap(){
     
        string isoCode;
        Decimal convertionRate;
        String s;
        
        s = 'SELECT Id, isoCode, Conversionrate, nextStartDate, startDate FROM DatedConversionRate ORDER BY NextStartDate DESC';
        List<Sobject> rates =  database.query(s);
        for(Sobject r: rates){
            isoCode = (String)r.get('isocode');
            convertionRate = (Decimal)r.get('Conversionrate');
            
            if(!conversionRates.containsKey(isoCode )){
                conversionRates.put(isoCode,convertionRate);
            }
        }
        
        s = 'SELECT Id, isoCode, Conversionrate FROM CurrencyType';
        List<Sobject> crates  =  database.query(s);
        
        for(Sobject r: crates){
            isoCode = (String)r.get('isocode');
            convertionRate = (Decimal)r.get('Conversionrate');
            
            if(!conversionRates.containsKey(isoCode)){
                conversionRates.put(isoCode,convertionRate);
            }
       }   
     
  }

}