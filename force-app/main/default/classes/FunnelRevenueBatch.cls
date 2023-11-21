/*
Copyright: Funnel Metrics, LLC
*/
global with Sharing class FunnelRevenueBatch implements Database.Batchable<sobject>, Database.Stateful{
    
    Date triggerDate;
    Boolean chainBatch;
    Boolean histVal;
    Date triggerDateminus1;

    Boolean errorVal = false;
    public Boolean updateAccess = true;
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    
    public String orgid ;
     
    
    public FunnelRevenueBatch(Date scheduleDate,Boolean chain, Boolean historical){
        
        triggerDateminus1 = scheduleDate;
        triggerDate = scheduleDate.addDays(1);
         
        chainBatch = chain;
        histVal = historical;
        updateAccess = true;
        orgid = UserInfo.getOrganizationId();
        
    }
    
    public Database.QueryLocator start(Database.BatchableContext con){
         return Database.getQueryLocator('select id,name,Profile_Type__c,Goal_of_monthly_leads_to_achieve_quota__c,User_Record_Name__r.name,Time_to_Tenured_Average_Rev__c ,Role__c,Tenure_in_current_role__c,Rep_start_date__c,YTD_Revenue__c,Quarterly_Quota_Revenue__c ,Monthly_Quota_Revenue__c,Monthly_lost_QO_Amt__c,Quarterly_lost_QO_Amt__c,Ytd_lost_QO_Amt__c,Monthly_lost_QO__c,Quarterly_lost_QO__c,Ytd_lost_QO__c, Annual_Quota_Amount__c,Goal_of_monthly_meetings__c,Goal_of_wins_to_achieve_monthly_quota__c,Goal_of_monthly_opptys_added_to_funnel__c,Q1_Quota_Amount__c,Q2_Quota_Amount__c,Q3_Quota_Amount__c,Q4_Quota_Amount__c ,Month_1_Quota_Amount__c,Month_2_Quota_Amount__c,Month_3_Quota_Amount__c,Month_4_Quota_Amount__c,Month_5_Quota_Amount__c,Month_6_Quota_Amount__c,Month_7_Quota_Amount__c,Month_8_Quota_Amount__c,Month_9_Quota_Amount__c,Month_10_Quota_Amount__c,Month_11_Quota_Amount__c,Month_12_Quota_Amount__c,User_Record_Name__c,Close_rate_monthly_opp_amount__c,Close_rate_monthly_opp_count__c,Close_rate_Quarterly_opp_amount__c,Close_rate_Quarterly_opp_count__c,Close_rate_YTD_opp_amount__c,Close_rate_YTD_opp_count__c, Monthly_QO_added__c, Quarterly_QO_added__c, Ytd_QO_added__c, User_Record_Name__r.CreatedDate from Sales_Rep_Profile__c WHERE Profile_Type__c = \'Hybrid\' AND (Active__c = TRUE OR Annual_Quota_Amount__c > 0) ');
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
    
    
    
    public void execute(Database.BatchableContext con, List<Sales_Rep_Profile__c> srp){
        
        try{
           if(updateAccess){    
            
            generateDates();
            
           
           List<Funnelocity_Revenue_data__c> fmRevenue =  database.query('SELECT Direct_Revenue__c, Sales_Rep_Profile__c FROM Funnelocity_Revenue_data__c WHERE  Year__c =' +triggerDateminus1.year()+ ' AND Month__c = '+triggerDateminus1.month());                           
           Map<Id, Decimal> fmMonthlyRevenue =  new Map<Id,Decimal>();
           for(Funnelocity_Revenue_data__c a:fmRevenue){
                fmMonthlyRevenue.put(a.Sales_Rep_Profile__c,a.Direct_Revenue__c);
            }
            
            Map<Id, Decimal> fQtRevenue = fetchQtRevenue();
            Map<Id, Decimal> fYtdRevenue = fetchYtdRevenue();
            Map<Id, Decimal> f12MonthRevenue = fetch12MonthRevenue();
             
            for(Sales_Rep_Profile__c s : srp){
               
                if(s.Profile_Type__c == 'Hybrid'){
                    if(fmMonthlyRevenue.keySet().contains(s.id) &&  fmMonthlyRevenue.get(s.id) !=  null ){
                        s.Monthly_Quota_Revenue__c =  fmMonthlyRevenue.get(s.id);
                    }else{
                        s.Monthly_Quota_Revenue__c =  0;
                    }
                    
                    if(fQtRevenue.keySet().contains(s.id) &&  fQtRevenue.get(s.id) !=  null ){
                        s.Quarterly_Quota_Revenue__c =  fQtRevenue .get(s.id);
                    }else{
                        s.Quarterly_Quota_Revenue__c =  0;
                    }
                    
                   if(fYtdRevenue.keySet().contains(s.id) &&  fYtdRevenue.get(s.id) !=  null ){
                        s.YTD_Revenue__c=  fYtdRevenue.get(s.id);
                    }else{
                        s.YTD_Revenue__c=  0;
                    }
                    
                     if(f12MonthRevenue.keySet().contains(s.id) &&  f12MonthRevenue.get(s.id) !=  null){
                        s.X12_Month_Rolling_Revenue__c =  f12MonthRevenue.get(s.id);
                    }
                    else{
                        s.X12_Month_Rolling_Revenue__c =  0;
                    }
                }              
               
            }        
            
                  
                                        
               update srp; 
     
            }
        }
        catch(Exception ex){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelRevenueBatch '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
    }
    
    public void finish(Database.BatchableContext con){
        
        //FunnelTriggerBatchHelper.sendErrorMail(' Funnel12MonthBatch finish method');
        if(!errorVal){ 
            if(!histVal){
             //   FunnelTriggerBatchHelper.sendErrorMail(' Funnel12MonthBatch finish method no error');
            }
            
            //system.debug(' triggerDateminus1 '+triggerDateminus1);
            if(chainBatch){
                //Funnel12MonthBatch fm = new Funnel12MonthBatch(triggerDateminus1,chainBatch,histVal);
                FunnelOverlayBatch fm = new FunnelOverlayBatch(triggerDateminus1,chainBatch,histVal);
                Database.executeBatch(fm);
            }
            
        }
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
        ////system.debug(Q0);
        ////system.debug(Q1);
        ////system.debug('Cyear'+Cyear);
        
        if( (Q0 <=  Cyear) && (Cyear <= Q1)){
        
            startDate=  Q0;
            endDate =  Q1;
            Quarter =  'Q1';
            ////system.debug('Q1');
                      
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
       ////system.debug('Cyear.Monthgmt()'+Cyear.Monthgmt());  
       ////system.debug('Cyear.yearGmt()'+Cyear.yearGmt());
       
       ////system.debug('endDate.Monthgmt()'+endDate.Monthgmt());
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
            
        system.debug('Cyeard R'+Cyeard);  
        system.debug('Cs R'+Cs);
        system.debug('startd R'+startd);  
    }
    
     
  private Map<Id,Decimal>  fetch12MonthRevenue(){
        
        Map<Id,Decimal> list12MonthRevenue  =  new  Map<Id,Decimal>();
       
        String SOQL12 =  'SELECT Sales_Rep_Profile__c i, SUM(Direct_Revenue__c) mqr    FROM Funnelocity_Revenue_data__c WHERE Snapshot_Scheduled_Date__c  >=  '+ startDate12Monthsd+' AND Snapshot_Scheduled_Date__c <'+ Cyeard+'  AND (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_Quota_Amount__c > 0) GROUP BY Sales_Rep_Profile__c';
        
        List<AggregateResult> ar12revenue =  database.query(SOQL12);

        for(AggregateResult ar: ar12revenue){
            list12MonthRevenue.put((Id)ar.get('i'), (Decimal)ar.get('mqr'));
        }
          
         return list12MonthRevenue;
        
    }
    
     private Map<Id,Decimal>  fetchYtdRevenue(){
        
        Map<Id,Decimal> listYtdRevenue  =  new  Map<Id,Decimal>();
       
        String SOQLYtd =  'SELECT Sales_Rep_Profile__c i, SUM(Direct_Revenue__c) mqr    FROM Funnelocity_Revenue_data__c WHERE Snapshot_Scheduled_Date__c  >=  '+ Fs+' AND Snapshot_Scheduled_Date__c <'+ Cs+' AND (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_Quota_Amount__c > 0) GROUP BY Sales_Rep_Profile__c';
        
        List<AggregateResult> arYtdrevenue =  database.query(SOQLYtd);

        for(AggregateResult ar: arYtdrevenue){
            listYtdRevenue.put((Id)ar.get('i'),  (Decimal)ar.get('mqr')   );
        }
          
         return listYtdRevenue;
        
    }
    
     private Map<Id,Decimal>  fetchQtRevenue(){
        
        Map<Id,Decimal> listQtRevenue  =  new  Map<Id,Decimal>();
       
        String SOQLQt =  'SELECT Sales_Rep_Profile__c i, SUM(Direct_Revenue__c) mqr    FROM Funnelocity_Revenue_data__c WHERE Snapshot_Scheduled_Date__c  >=  '+ startd+' AND Snapshot_Scheduled_Date__c <'+ Cs+' AND (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_Quota_Amount__c > 0) GROUP BY Sales_Rep_Profile__c';
        
        List<AggregateResult> arQtrevenue =  database.query(SOQLQt);

        for(AggregateResult ar: arQtrevenue){
            listQtRevenue.put((Id)ar.get('i'), (Decimal)ar.get('mqr') );
        } 
        
        return listQtRevenue;
    }
}