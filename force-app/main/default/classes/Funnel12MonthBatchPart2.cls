/*
Copyright: Funnel Metrics, LLC
*/
global with Sharing class Funnel12MonthBatchPart2 implements Database.Batchable<sobject>, Database.Stateful{
    
    Date triggerDate;
    Boolean chainBatch;
    Boolean histVal;
    Date triggerDateminus1;

    Boolean errorVal = false;
    public Boolean updateAccess = true;
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    
    public String orgid ;
    /* Custom metadata code */
            
    List<Client_custom_field_mapping__mdt> lstCustMd = [SELECT Action__c, Custom_field_name__c, Standard_field_name__c, Record_type_name__c FROM Client_custom_field_mapping__mdt WHERE Standard_field_name__c = 'Amount'];
    
    List<RecordType> recTypes = [SELECT id, Name FROM RecordType WHERE SobjectType='Opportunity'];
    
    Map<String,List<String>> recTypeFldMap = new Map<String,List<String>>();                                                                
    
    Map<String,String> recTypeNameIdMap = new Map<String,String>();
    
    Map<String,String> recTypeActionMap = new Map<String,String>();      
      
    /* Custom metadata code */
    
    public Funnel12MonthBatchPart2(Date scheduleDate,Boolean chain, Boolean historical){
        
        triggerDateminus1 = scheduleDate;
        triggerDate = scheduleDate.addDays(1);
        ////system.debug('triggerDate --'+triggerDate );
        //system.debug('triggerDateminus1 --'+triggerDateminus1 );
        
        chainBatch = chain;
        histVal = historical;
        updateAccess = true;
        orgid = UserInfo.getOrganizationId();
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
                
                if(!recTypeActionMap.containsKey(cm.Record_type_name__c)){
                    recTypeActionMap.put(cm.Record_type_name__c,cm.Action__c);
                }
                                
            }
        }
                
         
    }
    
    public Database.QueryLocator start(Database.BatchableContext con){
         return Database.getQueryLocator('select id,Monthly_lost_QO__c,Quarterly_lost_QO__c,Ytd_lost_QO__c,X12_Month_Opprties_Added_to_the_funnel__c ,name,User_Record_Name__r.name,Rep_start_date__c, Annual_Quota_Amount__c ,User_Record_Name__c,User_Record_Name__r.CreatedDate from Sales_Rep_Profile__c WHERE (Active__c = TRUE OR Annual_Quota_Amount__c > 0) ');
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
             
            //List of sales rep ids that are being processed
            Set<Id> srIds =  fetchSalesRepIds(srp);
            
            //List of user ids associated with the sales reps
            Set<Id> userIds =  fetchUserIds(srp); 
            
             generateSoqlId(userIds);
           
            
            /* Custom metadata code */
               
            Map<Id, Decimal> ownerAmtMap12mn =  fetchAmtNumbers(SOQL_IDs, startDate12Months, Cisyear , 'DealSize');
            Map<Id, Decimal> ownerAmtMapCp =  fetchAmtNumbers(SOQL_IDs, startDate12Months, Cisyear , 'CurrentPipeline');
             
            /* Custom metadata code */
           
            list<Map<Id,AggregateResult>> listofLostopp =  fetchLostOpp();
            
            Map<Id, AggregateResult> mnOppLost =  listofLostopp[0];
            Map<Id, AggregateResult> qOppLost =  listofLostopp[1];
            Map<Id, AggregateResult> ytdOppLost =  listofLostopp[2];
            
           
            list<Map<Id, Integer>>  listOfleadCount=  fetchConvertedCountOfLeads();
            
             
            //Fetch the leads created in the past 12 months
            Map<Id, Integer> leadCount12 =  listOfleadCount[0];
            
            //Fetch the leads created in current fiscal year
            Map<Id, Integer> leadCountytd =  listOfleadCount[1];
            
            //Fetch the leads converted in current fiscal year
            Map<Id, Integer> leadCountmn =  listOfleadCount[2];
            
            //Fetch the leads created in current Month
             Map<Id, Integer> leadCountq =  listOfleadCount[3];
            
            
            for(Sales_Rep_Profile__c s : srp){
                 
                /* Custom metadata code */
                if(ownerAmtMap12mn .keySet().contains(s.User_Record_Name__c) && s.X12_Month_Opprties_Added_to_the_funnel__c != null && s.X12_Month_Opprties_Added_to_the_funnel__c != 0){
                    s.Average_Deal_Size__c =  ownerAmtMap12mn.get(s.User_Record_Name__c)/s.X12_Month_Opprties_Added_to_the_funnel__c ;
                }
                else{
                    s.Average_Deal_Size__c =  0;
                }
                
                if(ownerAmtMapCp.keySet().contains(s.User_Record_Name__c)){
                    s.Current_Pipeline__c =  ownerAmtMapCp.get(s.User_Record_Name__c);
                }
                else{
                    s.Current_Pipeline__c =  0;
                }
                /* Custom metadata code */
                
                if(histVal){
                    if(mnOppLost.keySet().contains(s.User_Record_Name__c) &&  mnOppLost.get(s.User_Record_Name__c).get('c') !=  null ){
                        s.Monthly_lost_QO__c =  (Integer)mnOppLost.get(s.User_Record_Name__c).get('c');
                    }else{
                        s.Monthly_lost_QO__c =  0;
                    }
                    
                    if(qOppLost.keySet().contains(s.User_Record_Name__c) &&  qOppLost.get(s.User_Record_Name__c).get('c') !=  null ){
                        s.Quarterly_lost_QO__c =  (Integer)qOppLost.get(s.User_Record_Name__c).get('c');
                    }else{
                        s.Quarterly_lost_QO__c =  0;
                    }
                    
                    if(ytdOppLost.keySet().contains(s.User_Record_Name__c) &&  ytdOppLost.get(s.User_Record_Name__c).get('c') !=  null ){
                        s.Ytd_lost_QO__c =  (Integer)ytdOppLost.get(s.User_Record_Name__c).get('c');
                    }else{
                        s.Ytd_lost_QO__c =  0;
                    }
                }
                
                // new fields
                s.Monthly_Lead_Converted__c=  leadCountmn.get(s.User_Record_Name__c);
                if(s.Monthly_Lead_Converted__c ==  null){
                    s.Monthly_Lead_Converted__c =  0;
                }
                
                s.Quarterly_Lead_Converted__c =  leadCountq.get(s.User_Record_Name__c);
                if(s.Quarterly_Lead_Converted__c ==  null){
                    s.Quarterly_Lead_Converted__c =  0;
                }
                
                
                s.YTD_Lead_Converted__c=  leadCountytd.get(s.User_Record_Name__c);
                if(s.YTD_Lead_Converted__c==  null){
                    s.YTD_Lead_Converted__c=  0;
                }
                
                s.X12_Month_Lead_Converted__c=  leadCount12.get(s.User_Record_Name__c);
                if(s.X12_Month_Lead_Converted__c==  null){
                    s.X12_Month_Lead_Converted__c=  0;
                }
                   
              
            }        
            
                                      
               update srp; 
       
            }
        }
        catch(Exception ex){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' Funnel12MonthBatchPart2 '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
    }
    
    public void finish(Database.BatchableContext con){
        
        Application_Setting__c managerUpdate = [Select Enable_Manger_Goal_Update__c from Application_Setting__c Limit 1];
        managerUpdate.Enable_Manger_Goal_Update__c = false;
        update managerUpdate ;
            
        if(!errorVal){ 
            if(!histVal){
              //  FunnelTriggerBatchHelper.sendErrorMail(' Funnel12MonthBatchPart2 finish method no error');
            }
            //system.debug(' triggerDateminus1 '+triggerDateminus1);
            if(chainBatch){
                FunnelCustomMetricBatch fm = new FunnelCustomMetricBatch(triggerDateminus1,chainBatch,histVal);
                Database.executeBatch(fm,1);
            }
             
        }
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
        
         
    }
    
    private void generateSoqlId(Set<Id> userIds){
        
        //FunnelTriggerBatchHelper.sendErrorMail(' userIds are '+userIds.size());                                                          
        
        SOQL_IDs = '';
        
        for (Id id : userIds) {
        
            String id_in_quotes =  '\''+id+'\'';
           
            if (SOQL_IDs !=  '') { 
                SOQL_IDs+= ','; 
            }
           
            SOQL_IDs +=  id_in_quotes;
        }

        //FunnelTriggerBatchHelper.sendErrorMail(' Ids queried are '+SOQL_IDs);                                                          
        
        ////system.debug(' SOQL_IDs '+SOQL_IDs);
    }  
    
    /* Custom metadata code */
    
    private Map<id,Decimal> fetchAmtNumbers(String SOQL_IDs, String startDate12Months, String Cyear , String senario){
        
        Map<id,Decimal> ownerAmtMap = new Map<id,Decimal>();
            
        List<AggregateResult> oppAggrAmt = new List<AggregateResult>();                         
        
        String q;
        String omit = 'Omitted';
                          
        if(lstCustMd != null && lstCustMd.size() > 0){                    
            
            for (String recTypeName : recTypeFldMap.keySet()){
                                
                q = 'SELECT ownerId o, Count(id) c  ';
        
                if(recTypeActionMap.get(recTypeName) == 'Add'){
                    q += ', SUM(amount) s ';
                }
            
                List<String> flds = recTypeFldMap.get(recTypeName);
                
                for(Integer i = 0; i < flds.size(); i++){
                    q += ', SUM('+flds[i]+') '+flds[i];       
                }
                 
                if(senario == 'DealSize'){
                    q += ' FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND CreatedDate  >=  '+ startDate12Months+' AND CreatedDate  <  '+ Cyear+' AND RecordTypeId = '+'\''+recTypeNameIdMap.get(recTypeName)+'\'';
                }else{
                    q += ' FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND  IsClosed = false AND RecordTypeId = '+'\''+recTypeNameIdMap.get(recTypeName)+'\'';
                } 
                 
                
                q += ' GROUP BY OwnerId';                
                                                                                                
                oppAggrAmt = database.query(q);
                
                 
                for(AggregateResult ar: oppAggrAmt){
                    
                    Decimal totAmt = 0;
                     
                    if(recTypeActionMap.get(recTypeName) == 'Add'){
                                                    
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
                        Decimal amt = ownerAmtMap.get((id)ar.get('o'));
                        amt += totAmt;                           
                        ownerAmtMap.put((id)ar.get('o'),amt);
                    }
                       
                } 
                
                                   
            }                                
                            
             
        }
        else{
            
            if(senario == 'DealSize'){
            q = 'SELECT ownerId o, SUM(amount) s, Count(id) c FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND   CreatedDate  >=  '+ startDate12Months+' AND CreatedDate  <  '+ Cyear+' GROUP BY OwnerId'; 
            }else{
            q = 'SELECT ownerId o, SUM(amount) s, Count(id) c FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND   IsClosed = false GROUP BY OwnerId'; 
            }                                              
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
    
     private List<Map<Id,AggregateResult>> fetchLostOpp(){
        
        List<Map<Id,AggregateResult>> oppLostMapList =  new List<Map<Id,AggregateResult>>();
        Map<Id,AggregateResult> oppLostMapmn=  new Map<Id,AggregateResult>();
        
        //String stage =  'Closed Won';
        
        String omit = 'Omitted';
        
        //String SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE OwnerId IN ('+SOQL_IDs+') AND StageName =  '+'\''+stage+'\''+' AND CloseDate >= '+startDateMonthsd+' AND CloseDate <= '+endDateMonthsd+' GROUP BY OwnerId';
        String SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND iswon = false And isclosed = true AND CloseDate >= '+startDateMonthsd+' AND CloseDate < '+Cyeard+' GROUP BY OwnerId';
        //system.debug('Monthly opp won and revenue --->'+'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE OwnerId IN - AND iswon = false AND CloseDate >= '+startDateMonthsd+' AND CloseDate < '+Cyeard+' GROUP BY OwnerId');
        
        List<AggregateResult> oppAggrListmn =  database.query(SOQLmn);

        for(AggregateResult ar: oppAggrListmn){
            oppLostMapmn.put((Id)ar.get('o'), ar);
        }
        oppLostMapList.add(oppLostMapmn);
        
        Map<Id,AggregateResult> oppLostMapq =  new Map<Id,AggregateResult>();
        
        //String SOQLq =  'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE OwnerId IN ('+SOQL_IDs+') AND StageName =  '+'\''+stage+'\''+' AND CloseDate >= '+startd+' AND CloseDate <'+endd+' GROUP BY OwnerId';
        String SOQLq =  'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND iswon = false And isclosed = true AND CloseDate >= '+startd+' AND CloseDate < '+Cyeard+' GROUP BY OwnerId';
        //system.debug('quaterly opp won and revenue --->'+'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE OwnerId IN - AND iswon = false AND CloseDate >= '+startd+' AND CloseDate < '+Cyeard+' GROUP BY OwnerId');
        
        ////system.debug('SOQLq'+SOQLq);
        List<AggregateResult> oppAggrListq =  database.query(SOQLq);

        for(AggregateResult ar: oppAggrListq){
            oppLostMapq.put((Id)ar.get('o'), ar);
        }
        oppLostMapList.add(oppLostMapq);
        
        Map<Id,AggregateResult> oppLostMapYtd =  new Map<Id,AggregateResult>();
        
        String SOQLytd =  'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND iswon = false And isclosed = true AND CloseDate >= '+Fs+' AND CloseDate < '+Cs+' GROUP BY OwnerId';
        //system.debug('ytd opp won and reven --->'+'SELECT OwnerId o, Count(id) c FROM Opportunity WHERE OwnerId IN - AND iswon = false AND CloseDate >= '+Fs+' AND CloseDate < '+Cs+' GROUP BY OwnerId');
        
        ////system.debug('SOQLytd'+SOQLytd);
        List<AggregateResult> oppAggrListYtd =  database.query(SOQLytd);

        for(AggregateResult ar: oppAggrListYtd){
            oppLostMapYtd.put((Id)ar.get('o'), ar);
        }
        oppLostMapList.add(oppLostMapYtd);
        
        return oppLostMapList;
        
    }
    
    //To fetch lead Added
    
    private list<Map<Id,Integer>> fetchConvertedCountOfLeads(){
        
        list<Map<Id,Integer>> leadCountMapList =  new list<Map<Id,Integer>>();
        Map<Id,Integer> leadCountMap =  new Map<Id,Integer>();
        
        //12 month
        String SOQL =  'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+SOQL_IDs+')  AND ConvertedDate >= '+startDate12Monthsd +' AND ConvertedDate < '+Cyeard +' AND isconverted =  true GROUP BY OwnerId';
         
        List<AggregateResult> leadAggrList =  database.query(SOQL);

        for(AggregateResult ar: leadAggrList){
            leadCountMap.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        
        ////system.debug(' leadCountMap '+leadCountMap);
         
        leadCountMapList.add(leadCountMap);
        
        //YTD 
        Map<Id,Integer> leadCountMapcfy =  new Map<Id,Integer>();
        
        String SOQLcfy =  'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+SOQL_IDs+') AND ConvertedDate >= '+Fyeard  +' AND ConvertedDate < '+Cyeard +' AND isconverted =  true GROUP BY OwnerId';
         
        ////system.debug(' SOQLcfy '+SOQLcfy);
        List<AggregateResult> leadAggrListcfy =  database.query(SOQLcfy);

        for(AggregateResult ar: leadAggrListcfy){
            leadCountMapcfy.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        leadCountMapList.add(leadCountMapcfy);
        
        
        // Monthly
        Map<Id,Integer> leadCountMapmn =  new Map<Id,Integer>();
         
        String SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+SOQL_IDs+')  AND ConvertedDate >= '+startDateMonthsd +' AND ConvertedDate < '+Cyeard +' AND isconverted =  true GROUP BY OwnerId';
         
        List<AggregateResult> leadAggrListmn =  database.query(SOQLmn);

        for(AggregateResult ar: leadAggrListmn){
            leadCountMapmn.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        leadCountMapList.add(leadCountMapmn);
        
        // Quaterly
        Map<Id,Integer> leadCountMapq =  new Map<Id,Integer>();
         
        String SOQLq =  'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+SOQL_IDs+')  AND ConvertedDate >= '+startd +' AND ConvertedDate < '+Cyeard +' AND isconverted =  true GROUP BY OwnerId';
         
        List<AggregateResult> leadAggrListq =  database.query(SOQLq);

        for(AggregateResult ar: leadAggrListq){
            leadCountMapq.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        leadCountMapList.add(leadCountMapq);
        
        return leadCountMapList;
    }
}