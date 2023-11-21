/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelCalculator{
    
    public string appsetup {get;set;}
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    Public Map<String,String> managemenetReports{get;set;}
    
    public List<FunnelCalculatorWrapper> FunnelCalculatorWrapperList{get;set;}
    Sales_Rep_Profile__c srpcal = new Sales_Rep_Profile__c();
    List<AggregateResult> srpteam = new list<AggregateResult>();
    public string username ;
    public Sales_Rep_Profile__c srp{get;set;}
    public Id srpid{get;set;}
    public String SelectedSrpId { get; set; }       // Sales rep Filter
    public String SelectedsrpMngId { get; set; }    // sales manage filter
    public boolean Reponly{get;set;}                
    public decimal AverageSellingPrice{get;set;}    // This value for user input from the page
    public String AverageSellingPriceString{get;set;}  
    public decimal RollingConversionLead{get;set;}  // This value for user input from the page
    public String RollingConversionLeadString{get;set;}
    public decimal RollingCloseRate{get;set;}       // This value for user input from the page
    public String RollingCloseRateString{get;set;}
    
    //  
    public String LeadstoGenerateOneWinString{get;set;}
   // public decimal ag{get;set;}
    public boolean cal ;                            // this variable is used for the calculation from user input
    public integer currentFiscalMonths ;
    public FunnelCalculatorWrapper fcw7{get;set;}   // Annual Quota
    public FunnelCalculatorWrapper fcw8{get;set;}   // Quarterly Quota
    public FunnelCalculatorWrapper fcw9{get;set;}   // Monthly Quota
    public FunnelCalculatorWrapper fcw10{get;set;}  // Length of Sales Cycle
    public FunnelCalculatorWrapper fcw11{get;set;}  // Average Selling Price
    public FunnelCalculatorWrapper fcw12{get;set;}  //Lead to Opportunity  Conversion Rate
    public FunnelCalculatorWrapper fcw13{get;set;}  //# of Leads to Generate One Qualified Opportunity
    public FunnelCalculatorWrapper fcw14{get;set;}  //# of Leads to Generate One Win
    public FunnelCalculatorWrapper fcw15{get;set;}  //# of Quarterly Leads Required to Achieve Quota
    public FunnelCalculatorWrapper fcw16{get;set;}  //# of Monthly Leads Required to Achieve Quota
    public FunnelCalculatorWrapper fcw17{get;set;}  //# of Daily Leads Required to Achieve Quota
    public FunnelCalculatorWrapper fcw18{get;set;}  //# of Annual Opportunities Required to Achieve Quota
    public FunnelCalculatorWrapper fcw19{get;set;}  //# of Quarterly Opportunities Required to Achieve Quota
    public FunnelCalculatorWrapper fcw20{get;set;}  //# of Monthly Opportunities Required to Achieve Quota
    public FunnelCalculatorWrapper fcw21{get;set;}  // 12 Month Rolling Opportunities Added to Funnel
    public FunnelCalculatorWrapper fcw22{get;set;}
    public FunnelCalculatorWrapper fcw23{get;set;}  //12 Month Rolling Close Rate
    public FunnelCalculatorWrapper fcw24{get;set;}  //# of Wins to Achieve Annual Quota
    public FunnelCalculatorWrapper fcw25{get;set;}  //# of Wins to Achieve Quarterly Quota
    public FunnelCalculatorWrapper fcw26{get;set;}  //# of Wins to Achieve Monthly Quota
    public FunnelCalculatorWrapper fcw27{get;set;}  //# of Annual Leads Required to Achieve Quota
    public FunnelCalculatorWrapper fcw28{get;set;}  //YTD Annual Quota
    public FunnelCalculatorWrapper fcw29{get;set;}  // # of Monthly Opportunities Added to Achieve Quota
    public FunnelCalculatorWrapper fcw30{get;set;}  // # of Quaterly Opportunities Added to Achieve Quota
    public FunnelCalculatorWrapper fcw31{get;set;}  // # of Annual Opportunities Added to Achieve Quota
    public FunnelCalculatorWrapper fcw32{get;set;}  // # of Monthly Lead Added to Achieve Quota
    public FunnelCalculatorWrapper fcw33{get;set;}  // # of Quaterly Lead Added to Achieve Quota
    public FunnelCalculatorWrapper fcw34{get;set;}  // # of Annual Lead Added to Achieve Quota
    public FunnelCalculatorWrapper fcw35{get;set;}  // 12 Month Rolling Leads Added to Funnel
    public FunnelCalculatorWrapper fcw36{get;set;}  // Lead to Win Conversion Rate
    public FunnelCalculatorWrapper fcw37{get;set;}  // Opp to generate one win
    public FunnelCalculatorWrapper fcw38{get;set;}  // 12 month dollar close rate
    public string leadToAchieveAnnualQuota {get;set;}
    public string qualifiedOpptoOneWin {get;set;}
    
    public boolean opptab{get;set;}                 //For tab switch
    public boolean leadtab{get;set;}                //For tab switch
    public string selectol{get;set;}    
    
    public boolean resultcolor{get;set;}
    public string resultstring {get;set;}
    
    public boolean asp{get;set;}
    public boolean lcr{get;set;}
    public boolean cr{get;set;}
    
    public String curentPipeline{get;set;}
    public String activeopp{get;set;}
    public String ytdWin{get;set;}
    public String winNeedToMakeQuota{get;set;}
    
    
    public Date priorStartDate ;
    public DateTime Fyear; 
    public Date scheduleDate;
    
    public Boolean RoleOverlay{get;set;}
    public Boolean RepOverlay{get;set;} 
    // Below varibles store the data for Result column 
    
    Decimal Result_Annual_Quota_Amountc;
    Decimal Result_YTD_Revenuec;
    Decimal Result_X12_Month_Rolling_Average_Sales_Cyclec;
    Decimal Result_X12_Month_Average_Selling_Pricec;
    Decimal Result_X12_Month_Rolling_Win_Percentagec;
    Decimal Result_X12_Month_Rolling_revenueCloseRate;
    Decimal Result_X12_Month_Opprties_Added_to_the_funnelc;
    Decimal Result_X12_Month_Lead_Added_to_the_funnelc;
    Decimal Result_X12_Month_Lead_Conv_for_1_opptyc ;
    Decimal Result_Monthly_Opp_Added;
    Decimal Result_Quaterly_Opp_Added;
    Decimal Result_Annual_Opp_Added;
    Decimal Result_Monthly_Lead_Added;
    Decimal Result_Quaterly_Lead_Added;
    Decimal Result_Annual_Lead_Added;
    
    Decimal Result_Monthly_Revenue;
    Decimal Result_Quarterly_Revenue;
    
    Decimal Result_Monthly_Quota_Amountc;
    Decimal Result_Quarterly_Quota_Amountc; 
    
    //GOALS
    Decimal Goal_Result_X12_Month_Rolling_Average_Sales_Cyclec;
    Decimal Goal_Result_X12_Month_Rolling_Win_Percentagec;
    Decimal Goal_Result_X12_Month_Rolling_revenueCloseRate ;
    Decimal Goal_Result_X12_Month_Lead_Conv_for_1_opptyc ;
    Decimal Goal_Result_X12_Month_Average_Selling_Pricec;
    Decimal Goal_Result_YTDQuota;
    //// Below varibles store the data for Team Result column 
        
    Decimal TeamResult_Annual_Quota_Amountc;
    Decimal TeamResult_YTD_Revenuec;
    Decimal TeamResult_X12_Month_Rolling_Average_Sales_Cyclec;
    Decimal TeamResult_X12_Month_Average_Selling_Pricec;
    Decimal TeamResult_X12_Month_Rolling_Win_Percentagec;
    Decimal TeamResult_X12_Month_Rolling_revenueCloseRate;
    Decimal TeamResult_X12_Month_Opprties_Added_to_the_funnelc;
    Decimal TeamResult_X12_Month_Lead_Added_to_the_funnelc;
    Decimal TeamResult_X12_Month_Lead_Conv_for_1_opptyc;
    Decimal TeamResult_Monthly_Opp_Added;
    Decimal TeamResult_Quaterly_Opp_Added;
    Decimal TeamResult_Annual_Opp_Added;
    Decimal TeamResult_Monthly_Lead_Added;
    Decimal TeamResult_Quaterly_Lead_Added;
    Decimal TeamResult_Annual_Lead_Added;
    
    Decimal TeamResult_Monthly_Revenue;
    Decimal TeamResult_Quarterly_Revenue;
    
    Decimal TeamResult_Monthly_Quota_Amountc;
    Decimal TeamResult_Quarterly_Quota_Amountc; 
    
    // Below varibles store the data for Prior year column 
    
    Decimal Prior_Annual_Quota_Amountc;                          
    Decimal Prior_YTD_Revenuec;
    Decimal Prior_X12_Month_Rolling_Average_Sales_Cyclec;
    Decimal Prior_X12_Month_Average_Selling_Pricec;
    Decimal Prior_X12_Month_Rolling_Win_Percentagec;
    Decimal Prior_X12_Month_Rolling_revenueCloseRate;
    Decimal Prior_X12_Month_Opprties_Added_to_the_funnelc;
    Decimal Prior_X12_Month_Lead_Added_to_the_funnelc;
    Decimal Prior_X12_Month_Lead_Conv_for_1_opptyc ;
    Decimal Prior_Monthly_Opp_Added;
    Decimal Prior_Quaterly_Opp_Added;
    Decimal Prior_Annual_Opp_Added;
    Decimal Prior_Monthly_Lead_Added;
    Decimal Prior_Quaterly_Lead_Added;
    Decimal Prior_Annual_Lead_Added;
    
    Decimal Prior_Monthly_Revenue;
    Decimal Prior_Quarterly_Revenue;
    
    Decimal Prior_Monthly_Quota_Amountc;
    Decimal Prior_Quarterly_Quota_Amountc; 
    
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
    
    public class FunnelCalculatorWrapper{
        
        public string FunnelDescription{get;set;}
        public Decimal PriorYearResult{get;set;}
        public Decimal SalesRepGoal{get;set;}
        public Decimal TeamResult{get;set;}
        public Decimal Result{get;set;}
        public Decimal Gap_result_SalesRepGoal{get;set;}
        public Decimal Gap_result_TeamResult{get;set;}
        public Decimal Gap_result_PriorYearResult{get;set;}
        
        public String PriorYearResultString{get;set;}
        public String SalesRepGoalString{get;set;}
        public String TeamResultString{get;set;}
        public String ResultString{get;set;}
        public String Gap_result_SalesRepGoalString{get;set;}
        public String Gap_result_TeamResultString{get;set;}
        public String Gap_result_PriorYearResultString{get;set;}
    }
    Boolean readAccess;
    
    public FunnelCalculator(){
        try{ 
            
            List<AggregateResult> asperm = [SELECT count(Id) c FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = 'Funnel_App_Setup'];
        
            Boolean isManager = FunnelTriggerBatchHelper.isManager(UserInfo.getUserId());
            if((asperm != null && asperm.size() > 0 && asperm[0].get('c') != null && (Integer)asperm[0].get('c') > 0) || isManager  ){
                appsetup ='';
            }else{
                appsetup ='none';
            }
            
            readAccess = true;
            
            List<String> fldList1 = new List<String>{prefix+'User_Record_name__c',prefix+'name',prefix+'Annual_Quota_Amount__c',prefix+'Sales_Manager__c',prefix+'YTD_Revenue__c',prefix+'X12_Month_Rolling_Average_Sales_Cycle__c',prefix+'X12_Month_Rolling_Opptys_Won__c',prefix+'X12_Month_Rolling_Opportunity_Close_Rate__c',prefix+'X12_Month_QO_added__c',prefix+'X12_Month_Lead_Conv_for_1_oppty__c',prefix+'X12_Month_Average_Selling_Price__c',prefix+'User_Record_Name__c',prefix+'X12_Month_Leads_Added__c',prefix+'Goal_12m_Avg_Selling_Price__c',prefix+'Goal_12m_Lead_To_Opp_Conv_Rate__c',prefix+'Goal_12m_length_of_sales_cycle__c',prefix+'Goal_12m_rolling_close_rate__c',prefix+'Monthly_QO_added__c',prefix+'Quarterly_QO_added__c',prefix+'Ytd_QO_added__c',prefix+'Monthly_Lead_Added__c',prefix+'Quarterly_Lead_Added__c',prefix+'YTD_Leads_Added__c',prefix+'Monthly_Quota_Revenue__c',prefix+'Quarterly_Quota_Revenue__c'};                    
            
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
             
              scheduleDate = Date.newInstance(system.today().year() - 1, system.today().month(), Date.daysInMonth(system.today().year()-1, system.today().month()));
           // scheduleDate = Date.newInstance(2018,7,12); 
            system.debug('scheduleDate'+scheduleDate);

             Integer startMonth = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year').Month();
             system.debug(' startMonth is '+startMonth);
             Integer currentMonth = Date.Today().Month();
             system.debug(' current month is '+currentMonth);
        
             if(currentMonth > startMonth){
             currentFiscalMonths = currentMonth - startMonth +1;            
             }
             else if(currentMonth < startMonth){
                 currentFiscalMonths = 11 - startMonth + currentMonth;            
             }
             else if(currentMonth == startMonth){
                 currentFiscalMonths = 1;
             }
             // For Static date
             //currentFiscalMonths  = 3;
          //   system.debug('currentFiscalMonths '+currentFiscalMonths );
         
          Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
          priorStartDate = Date.newInstance(Fyear.yeargmt() - 1, Fyear.Monthgmt(), Fyear.daygmt());
          system.debug('yyyyy'+priorStartDate );
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
        
        /*filters*/
       opptab = true;
       leadtab = false;
       resultstring ='Actual  ';
       username = UserInfo.getUserId();
    /*   Sales_Rep_Profile__c names =[select User_Record_Name__r.name,name,Sales_Manager__c,Sales_Manager__r.name  from Sales_Rep_Profile__c where User_Record_Name__c =:username limit 1];
            
        srpcal=[Select id,name,Annual_Quota_Amount__c,Sales_Manager__c,YTD_Revenue__c,X12_Month_Rolling_Average_Sales_Cycle__c,X12_Month_Rolling_Opptys_Won__c,X12_Month_Rolling_Opportunity_Close_Rate__c,X12_Month_QO_added__c,X12_Month_Lead_Conv_for_1_oppty__c,X12_Month_Average_Selling_Price__c,X12_Month_Leads_Added__c from Sales_Rep_Profile__c where id=:names.id];
        
        SelectedSrpId = names.id;
       // SelectedsrpMngId = names.Sales_Manager__c ; 
        
        list<Sales_Rep_Profile__c> srpnm =  [Select Id,Sales_Manager__c , Sales_Manager__r.name from Sales_Rep_Profile__c where id=:SelectedSrpId AND (Active__c = TRUE OR Annual_Quota_Amount__c > 0)];
        
        
            
            if(srpnm != null && srpnm.size() > 0){
                Reponly = false;
            }else{
                 Reponly = true;
            } */
        
        cal = false;
         
        showUpdated();
        
        defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw); 
        
        system.debug(' defaultBreadCrumb '+defaultBreadCrumb);
        
        /*
        managemenetReports = new Map<String,String>();
        
        User u = [SELECT Name, UserPreferencesLightningExperiencePreferred FROM User WHERE id = :UserInfo.getUserId()];
        
        List<String> dashList = new List<String>();
        dashList.add('mXaDybYGcSDujlyIRRJQxUrUEqXiFe');
        
        managemenetReports = FunnelNavigationHelper.fetchDashboards(dashList,u);*/
      
       asp = false;
       cr=false;
       lcr=false;

        
        }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());                
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelCalculator '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }

             
    }
    
       List<Sales_Rep_Profile__c>  srpfilter = new List<Sales_Rep_Profile__c>();
     List<Sales_Rep_Profile__c>  srpfilter1 = new List<Sales_Rep_Profile__c>();
      
      // To get the Sales Manager names
      
        // To get the Names of the sales rep under the manager
      
          
          
         // To change the salesrep filter on change of  the manager
           
           
          
     public void calculate(){
         try{
             if(readAccess){
                  cal = true;
                  FunnelTable();
                  resultcolor = true;
                  resultstring ='Calculated  ';
              }
          }
          catch(Exception ex){
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelCalculator '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
         }
     }
         
     public void ResetCal(){
         if(readAccess){
              cal = false;
              FunnelTable();
              resultcolor = false;
              resultstring ='Actual ';
              asp =false;
              cr=false;
              lcr=false;
              }
         }
          
       
          
          //This method Create the data for the Calculator for funnel calculation based on three condition
          
    public void Data(string sm,string sp){
         if(readAccess){
             list<Sales_Rep_Profile__c> srpresult = new list<Sales_Rep_Profile__c>();
             list<Sales_Rep_Profile__c> srpTeamresult = new list<Sales_Rep_Profile__c>();
             list<Sales_Rep_Profile_Snapshot__c > Priorresult = new list<Sales_Rep_Profile_Snapshot__c >();
             list<YTD_Quota_Revenue__c> PriorTeamresult = new list<YTD_Quota_Revenue__c>();
             
              
            integer recordCount = 0;
              
         /* Condition 1 : salesManger = salesRep 
             Result = Values of  salesManger only
             TeamResult = salesManger and everyone under salesManger 
         */
        
                 
            
            
        /* Condition 2 : salesManger != salesRep 
                 Result = salesRep  and everyone under salesRep 
                 TeamResult = Everyone under salesManger 
         */
         
        if((sm != '' && sp != '' && sm != null && sp != null) && (sp != sm)){
                system.debug('inside Condition 2 ');
                 
                srpresult =[Select id,Profile_Type__c,name,YTD_Quota__c,Annual_Quota_Amount__c,Monthly_quota__c,Quarterly_Quota__c,Sales_Manager__c,YTD_Revenue__c,X12_Month_Rolling_Average_Sales_Cycle__c,X12_Month_Rolling_Opptys_Won__c,X12_Month_Rolling_Opportunity_Close_Rate__c,X12_Month_QO_added__c,X12_Month_Lead_Conv_for_1_oppty__c,X12_Month_Average_Selling_Price__c,User_Record_Name__c,X12_Month_Leads_Added__c,Goal_12m_Avg_Selling_Price__c,Goal_12m_Lead_To_Opp_Conv_Rate__c,Goal_12m_length_of_sales_cycle__c,Goal_12m_rolling_close_rate__c,
                            Monthly_QO_added__c, Quarterly_QO_added__c, Ytd_QO_added__c, Monthly_Lead_Added__c, Quarterly_Lead_Added__c,YTD_Leads_Added__c,Monthly_Quota_Revenue__c,Quarterly_Quota_Revenue__c,Current_Active_Opportunities__c,Current_Pipeline__c,YTD_Opportunities_won__c,X12_Month_Rolling_Close_Rate__c,Goal_12m_rolling_amt_close_rate__c   from Sales_Rep_Profile__c where id=:sp AND (Active__c = TRUE OR Annual_Quota_Amount__c > 0)];
                
                salesRepName = srpresult[0].name;
                Boolean overlayRep = false;
                if(srpresult[0].Profile_Type__c != null && srpresult[0].Profile_Type__c == 'Overlay'){
                    overlayRep = true;
                }
                
                
                Result_Annual_Quota_Amountc = 0;
                Result_YTD_Revenuec = 0;
                Result_X12_Month_Rolling_Average_Sales_Cyclec = 0;
                Result_X12_Month_Average_Selling_Pricec = 0;
                Result_X12_Month_Rolling_Win_Percentagec = 0;
                Result_X12_Month_Rolling_revenueCloseRate = 0;
                Result_X12_Month_Opprties_Added_to_the_funnelc = 0;
                Result_X12_Month_Lead_Added_to_the_funnelc = 0;
                Result_X12_Month_Lead_Conv_for_1_opptyc = 0;
                
                Result_Monthly_Revenue = 0;
                Result_Quarterly_Revenue = 0;
                
                Result_Monthly_Quota_Amountc = 0;
                Result_Quarterly_Quota_Amountc = 0; 
                
                Result_Monthly_Opp_Added =0;
                Result_Quaterly_Opp_Added =0;
                Result_Annual_Opp_Added =0;
                Result_Monthly_Lead_Added =0;
                Result_Quaterly_Lead_Added =0;
                Result_Annual_Lead_Added =0;
                
                Goal_Result_X12_Month_Rolling_Average_Sales_Cyclec = 0;
                Goal_Result_X12_Month_Rolling_Win_Percentagec = 0;
                Goal_Result_X12_Month_Rolling_revenueCloseRate = 0;
                Goal_Result_X12_Month_Lead_Conv_for_1_opptyc = 0;
                Goal_Result_X12_Month_Average_Selling_Pricec = 0;
                Goal_Result_YTDQuota = 0;
                integer count = 0;
                
                
                if(srpresult != null && srpresult.size()>0){
                    
                    if(srpresult[0].Monthly_QO_added__c != null) 
                        Result_Monthly_Opp_Added = (Decimal)srpresult[0].Monthly_QO_added__c;
                     
                    if(srpresult[0].Monthly_Lead_Added__c != null) 
                        Result_Monthly_Lead_Added = (Decimal)srpresult[0].Monthly_Lead_Added__c ;
                      
                    if(srpresult[0].Monthly_Quota_Revenue__c != null) 
                        Result_Monthly_Revenue= (Decimal)srpresult[0].Monthly_Quota_Revenue__c  ;
                
                    if(srpresult[0].Quarterly_QO_added__c != null) 
                        Result_Quaterly_Opp_Added = (Decimal)srpresult[0].Quarterly_QO_added__c  ;
                        
                    if(srpresult[0].Quarterly_Lead_Added__c != null) 
                        Result_Quaterly_Lead_Added = (Decimal)srpresult[0].Quarterly_Lead_Added__c;
                        
                    if(srpresult[0].Quarterly_Quota_Revenue__c != null) 
                        Result_Quarterly_Revenue= (Decimal)srpresult[0].Quarterly_Quota_Revenue__c;
               
                    if(srpresult[0].Ytd_QO_added__c != null) 
                        Result_Annual_Opp_Added = (Decimal)srpresult[0].Ytd_QO_added__c;
                      
                    if(srpresult[0].YTD_Leads_Added__c != null) 
                        Result_Annual_Lead_Added = (Decimal)srpresult[0].YTD_Leads_Added__c ;
                      
                    if(srpresult[0].Annual_Quota_Amount__c != null) 
                        Result_Annual_Quota_Amountc  =  (Decimal)srpresult[0].Annual_Quota_Amount__c;
                        
                    if(srpresult[0].Monthly_quota__c != null) 
                        Result_Monthly_Quota_Amountc =  (Decimal)srpresult[0].Monthly_quota__c;
                        
                    if(srpresult[0].Quarterly_Quota__c != null) 
                        Result_Quarterly_Quota_Amountc =  (Decimal)srpresult[0].Quarterly_Quota__c;
                   
                    if(srpresult[0].YTD_Revenue__c  != null) 
                        Result_YTD_Revenuec  =  (Decimal)srpresult[0].YTD_Revenue__c ;
                        
                    if(srpresult[0].YTD_Quota__c != null) 
                        Goal_Result_YTDQuota =  (Decimal)srpresult[0].YTD_Quota__c;
                    
                    if(srpresult[0].X12_Month_Rolling_Average_Sales_Cycle__c != null) 
                        Result_X12_Month_Rolling_Average_Sales_Cyclec  =  (Decimal)srpresult[0].X12_Month_Rolling_Average_Sales_Cycle__c;
                    
                    if(srpresult[0].X12_Month_Average_Selling_Price__c != null) 
                        Result_X12_Month_Average_Selling_Pricec  =  (Decimal)srpresult[0].X12_Month_Average_Selling_Price__c;
                    
                    if(srpresult[0].X12_Month_Rolling_Opportunity_Close_Rate__c != null) 
                        Result_X12_Month_Rolling_Win_Percentagec  =  (Decimal)srpresult[0].X12_Month_Rolling_Opportunity_Close_Rate__c;
                    
                    if(srpresult[0].X12_Month_Rolling_Close_Rate__c != null) 
                        Result_X12_Month_Rolling_revenueCloseRate  =  (Decimal)srpresult[0].X12_Month_Rolling_Close_Rate__c;
                                        
                    if(srpresult[0].X12_Month_QO_added__c != null) 
                        Result_X12_Month_Opprties_Added_to_the_funnelc  =  (Decimal)srpresult[0].X12_Month_QO_added__c;
                     
                    if(srpresult[0].X12_Month_Lead_Conv_for_1_oppty__c != null) 
                        Result_X12_Month_Lead_Conv_for_1_opptyc  =  (Decimal)srpresult[0].X12_Month_Lead_Conv_for_1_oppty__c;
                    
                    if(srpresult[0].X12_Month_Leads_Added__c!= null) 
                        Result_X12_Month_Lead_Added_to_the_funnelc  =  (Decimal)srpresult[0].X12_Month_Leads_Added__c;
                    
                    if(srpresult[0].Goal_12m_Avg_Selling_Price__c != null) 
                        Goal_Result_X12_Month_Average_Selling_Pricec =  (Decimal)srpresult[0].Goal_12m_Avg_Selling_Price__c;
                    
                    if(srpresult[0].Goal_12m_Lead_To_Opp_Conv_Rate__c != null) 
                        Goal_Result_X12_Month_Lead_Conv_for_1_opptyc  =  (Decimal)srpresult[0].Goal_12m_Lead_To_Opp_Conv_Rate__c;
                    
                    if(srpresult[0].Goal_12m_length_of_sales_cycle__c != null) 
                        Goal_Result_X12_Month_Rolling_Average_Sales_Cyclec =  (Decimal)srpresult[0].Goal_12m_length_of_sales_cycle__c;
                    
                    if(srpresult[0].Goal_12m_rolling_close_rate__c != null) 
                        Goal_Result_X12_Month_Rolling_Win_Percentagec =  (Decimal)srpresult[0].Goal_12m_rolling_close_rate__c;
                    
                    if(srpresult[0].Goal_12m_rolling_amt_close_rate__c != null) 
                        Goal_Result_X12_Month_Rolling_revenueCloseRate =  (Decimal)srpresult[0].Goal_12m_rolling_amt_close_rate__c;
                     
                    //Score card
                    
                     if(srpresult[0].Current_Pipeline__c != null) 
                        curentPipeline  = convert(convertsub( (Decimal)srpresult[0].Current_Pipeline__c,''),'$');
                    
                    if(srpresult[0].Current_Active_Opportunities__c != null) 
                        activeopp  = convert(convertsub( (Decimal)srpresult[0].Current_Active_Opportunities__c,''),'');
                    
                    if(srpresult[0].YTD_Opportunities_won__c != null) 
                        ytdWin  = convert(convertsub( (Decimal)srpresult[0].YTD_Opportunities_won__c,''),'');
                    
                    if(srpresult[0].X12_Month_Average_Selling_Price__c != null && srpresult[0].X12_Month_Average_Selling_Price__c  > 0 && srpresult[0].Annual_Quota_Amount__c != null  && srpresult[0].YTD_Revenue__c != null){
                        Decimal win = ((Decimal)srpresult[0].Annual_Quota_Amount__c - (Decimal)srpresult[0].YTD_Revenue__c)/(Decimal)srpresult[0].X12_Month_Average_Selling_Price__c;
                        winNeedToMakeQuota = convert(convertsub( win,''),'');
                         
                    }
                     
                }
               
                  
                
                
                srpTeamresult.clear();
                srpresult.clear();
                
                if(overlayRep){
                    srpresult =[Select id, name from Sales_Rep_Profile__c where Sales_Manager__c=:sm AND id != :sp AND Profile_Type__c = 'Overlay'];
                }else{
                    srpresult =[Select id, name from Sales_Rep_Profile__c where Sales_Manager__c=:sm AND id != :sp AND Profile_Type__c != 'Overlay'];
                }
                
                recordCount = srpresult.size() ;
                Set<id> sid = new set<id>();
                
                for(Sales_Rep_Profile__c s: srpresult){
                    sid.add(s.id);
                }
                 
                TeamResult_Annual_Quota_Amountc =0;
                TeamResult_YTD_Revenuec =0;
                TeamResult_X12_Month_Rolling_Average_Sales_Cyclec =0;
                TeamResult_X12_Month_Average_Selling_Pricec =0;
                TeamResult_X12_Month_Rolling_Win_Percentagec =0;
                 
                TeamResult_X12_Month_Opprties_Added_to_the_funnelc =0;
                TeamResult_X12_Month_Lead_Added_to_the_funnelc =0;
                TeamResult_X12_Month_Lead_Conv_for_1_opptyc =0;
                
                TeamResult_Monthly_Revenue = 0;
                TeamResult_Quarterly_Revenue = 0;
                
                TeamResult_Monthly_Quota_Amountc= 0;
                TeamResult_Quarterly_Quota_Amountc= 0;
                
                TeamResult_Monthly_Opp_Added =0;
                TeamResult_Quaterly_Opp_Added =0;
                TeamResult_Annual_Opp_Added =0;
                TeamResult_Monthly_Lead_Added =0;
                TeamResult_Quaterly_Lead_Added =0;
                TeamResult_Annual_Lead_Added =0;
                count = 0;
                List<AggregateResult> ar2 = new List<AggregateResult>();
                if(overlayRep){
                         ar2 = [Select SUM(YTD_Revenue__c) y, Sum(Annual_Quota_Amount__c) a,Sum(Monthly_quota__c) aam, Sum(Quarterly_Quota__c) aaq,  AVG(X12_Month_Average_Selling_Price__c) sp,  
                                        AVG(X12_Month_Lead_Conv_for_1_oppty__c) lc, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Rolling_Opportunity_Close_Rate__c) wp,
                                        SUM(X12_Month_QO_added__c) opaf, SUM(X12_Month_Leads_Added__c) laf,
                                        AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,SUM(Monthly_Quota_Revenue__c) mr, SUM(Quarterly_Quota_Revenue__c) qr,
                                        SUM(Monthly_QO_added__c) moa, SUM(Quarterly_QO_added__c)qoa, SUM(Ytd_QO_added__c) yoa, SUM(Monthly_Lead_Added__c) mla, SUM(Quarterly_Lead_Added__c) qla,SUM(YTD_Leads_Added__c) yla
                                        from Sales_Rep_Profile__c where id IN :sid AND Annual_Quota_Amount__c > 0 AND Profile_Type__c = 'Overlay'];
                }else{
                         ar2 = [Select SUM(YTD_Revenue__c) y, Sum(Annual_Quota_Amount__c) a,Sum(Monthly_quota__c) aam, Sum(Quarterly_Quota__c) aaq, AVG(X12_Month_Average_Selling_Price__c) sp,  
                                        AVG(X12_Month_Lead_Conv_for_1_oppty__c) lc, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Rolling_Opportunity_Close_Rate__c) wp,
                                        SUM(X12_Month_QO_added__c) opaf, SUM(X12_Month_Leads_Added__c) laf,
                                        AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,SUM(Monthly_Quota_Revenue__c) mr, SUM(Quarterly_Quota_Revenue__c) qr,
                                        SUM(Monthly_QO_added__c) moa, SUM(Quarterly_QO_added__c)qoa, SUM(Ytd_QO_added__c) yoa, SUM(Monthly_Lead_Added__c) mla, SUM(Quarterly_Lead_Added__c) qla,SUM(YTD_Leads_Added__c) yla
                                        from Sales_Rep_Profile__c where id IN :sid AND Annual_Quota_Amount__c > 0 AND Profile_Type__c != 'Overlay'];
                }
                if(ar2 != null && ar2.size()>0){
                    
                    if(ar2[0].get('moa') != null) 
                        TeamResult_Monthly_Opp_Added = (Decimal)(ar2[0].get('moa'))/(recordCount);
                     
                    if(ar2[0].get('mla') != null) 
                        TeamResult_Monthly_Lead_Added = (Decimal)(ar2[0].get('mla'))/(recordCount);
                    
                    if(ar2[0].get('mr') != null) 
                        TeamResult_Monthly_Revenue = (Decimal)(ar2[0].get('mr'))/(recordCount);
                
                    if(ar2[0].get('qoa') != null) 
                        TeamResult_Quaterly_Opp_Added = (Decimal)(ar2[0].get('qoa'))/(recordCount);
                     
                    if(ar2[0].get('qla') != null ) 
                        TeamResult_Quaterly_Lead_Added = (Decimal)(ar2[0].get('qla'))/(recordCount);
                     
                    if(ar2[0].get('qr') != null) 
                        TeamResult_Quarterly_Revenue= (Decimal)(ar2[0].get('qr'))/(recordCount);
               
                    if(ar2[0].get('yoa') != null) 
                        TeamResult_Annual_Opp_Added = (Decimal)(ar2[0].get('yoa'))/(recordCount);
                         
                    if(ar2[0].get('yla') != null) 
                        TeamResult_Annual_Lead_Added = (Decimal)(ar2[0].get('yla'))/(recordCount);
                         
                    if(ar2[0].get('a') != null) 
                        TeamResult_Annual_Quota_Amountc  = (Decimal)(ar2[0].get('a'))/(recordCount);
                        
                    if(ar2[0].get('aam') != null) 
                        TeamResult_Monthly_Quota_Amountc  = (Decimal)(ar2[0].get('aam'))/(recordCount);
                        
                    if(ar2[0].get('aaq') != null) 
                        TeamResult_Quarterly_Quota_Amountc = (Decimal)(ar2[0].get('aaq'))/(recordCount);
                     
                    if(ar2[0].get('y') != null) 
                        TeamResult_YTD_Revenuec   =  (Decimal)(ar2[0].get('y'))/(recordCount);
                     
                    if(ar2[0].get('sc') != null) 
                        TeamResult_X12_Month_Rolling_Average_Sales_Cyclec  =  (Decimal)(ar2[0].get('sc'));
                     
                    if(ar2[0].get('sp') != null) 
                        TeamResult_X12_Month_Average_Selling_Pricec   =  (Decimal)(ar2[0].get('sp'));
                     
                    if(ar2[0].get('wp') != null) 
                        TeamResult_X12_Month_Rolling_Win_Percentagec   =  (Decimal)(ar2[0].get('wp'));
                     
                    if(ar2[0].get('opaf') != null) 
                        TeamResult_X12_Month_Opprties_Added_to_the_funnelc  =  (Decimal)(ar2[0].get('opaf'))/(recordCount);
                     
                    if(ar2[0].get('lc') != null) 
                        TeamResult_X12_Month_Lead_Conv_for_1_opptyc  =  (Decimal)(ar2[0].get('lc'));
                     
                    if(ar2[0].get('laf') != null) 
                        TeamResult_X12_Month_Lead_Added_to_the_funnelc =  (Decimal)(ar2[0].get('laf'))/(recordCount);
                    
                }
                
                Prior_Annual_Quota_Amountc =0;                          
                Prior_YTD_Revenuec =0;
                Prior_X12_Month_Rolling_Average_Sales_Cyclec =0;
                Prior_X12_Month_Average_Selling_Pricec =0;
                Prior_X12_Month_Rolling_Win_Percentagec =0;
                Prior_X12_Month_Rolling_revenueCloseRate =0;
                Prior_X12_Month_Opprties_Added_to_the_funnelc =0;
                Prior_X12_Month_Lead_Added_to_the_funnelc =0;
                Prior_X12_Month_Lead_Conv_for_1_opptyc =0;
                Prior_Monthly_Opp_Added =0;
                Prior_Quaterly_Opp_Added =0;
                Prior_Annual_Opp_Added =0;
                Prior_Monthly_Lead_Added =0;
                Prior_Quaterly_Lead_Added =0;
                Prior_Annual_Lead_Added =0;
                Prior_Monthly_Revenue  = 0;
                Prior_Quarterly_Revenue  = 0;
                
                Prior_Monthly_Quota_Amountc = 0;
                Prior_Quarterly_Quota_Amountc = 0;
                
                count = 0;
                
                priorresult =[Select id,name,Annual_Quota_Amount__c,Monthly_quota__c,Quarterly_Quota__c,Sales_Manager__c,YTD_Revenue__c,X12_Month_Rolling_Average_Sales_Cycle__c,X12_Month_Rolling_Opptys_Won__c,X12_Month_Rolling_Opportunity_Close_Rate__c,X12_Month_QO_added__c,X12_Month_Lead_Conv_for_1_oppty__c,X12_Month_Average_Selling_Price__c,User_Record_Name__c,X12_Month_Leads_Added__c,Goal_12m_Avg_Selling_Price__c,Goal_12m_Lead_To_Opp_Conv_Rate__c,Goal_12m_length_of_sales_cycle__c,Goal_12m_rolling_close_rate__c,
                            Monthly_QO_added_Quantitative__c, Quarterly_QO_added_Quantitative__c, Ytd_QO_added_Quantitative__c, Monthly_Lead_Added__c, Quarterly_Lead_Added__c,YTD_Leads_Added__c,Monthly_Quota_Revenue__c,Quarterly_Quota_Revenue__c,Goal_12m_rolling_amt_close_rate__c,X12_Month_Rolling_Close_Rate__c   from Sales_Rep_Profile_Snapshot__c where Sales_Rep_Profile__c =:sp AND Snapshot_Scheduled_Date__c = :scheduleDate];
            
                    
                    if(priorresult != null && priorresult.size()>0){
                       
                        if(priorresult[0].Monthly_QO_added_Quantitative__c != null)
                            Prior_Monthly_Opp_Added =  (Decimal)priorresult[0].Monthly_QO_added_Quantitative__c;
                      
                        if(priorresult [0].Monthly_Lead_Added__c != null) 
                            Prior_Monthly_Lead_Added = (Decimal)priorresult[0].Monthly_Lead_Added__c;
                       
                        if(priorresult[0].Quarterly_QO_added_Quantitative__c != null) 
                            Prior_Quaterly_Opp_Added = (Decimal)priorresult[0].Quarterly_QO_added_Quantitative__c;
                     
                        if(priorresult[0].Quarterly_Lead_Added__c != null) 
                            Prior_Quaterly_Lead_Added = (Decimal)priorresult[0].Quarterly_Lead_Added__c;
                        
                        if(priorresult[0].Ytd_QO_added_Quantitative__c != null) 
                            Prior_Annual_Opp_Added = (Decimal)priorresult[0].Ytd_QO_added_Quantitative__c  ;
                        
                        if(priorresult[0].YTD_Leads_Added__c != null) 
                            Prior_Annual_Lead_Added = (Decimal)priorresult[0].YTD_Leads_Added__c;
                     
                        if(priorresult[0].Annual_Quota_Amount__c != null) 
                            Prior_Annual_Quota_Amountc =  (Decimal)priorresult[0].Annual_Quota_Amount__c;
                            
                        if(priorresult[0].Monthly_quota__c!= null) 
                            Prior_Monthly_Quota_Amountc =  (Decimal)priorresult[0].Monthly_quota__c;
                            
                        if(priorresult[0].Quarterly_Quota__c!= null) 
                            Prior_Quarterly_Quota_Amountc =  (Decimal)priorresult[0].Quarterly_Quota__c;
                     
                        if(priorresult[0].YTD_Revenue__c  != null) 
                            Prior_YTD_Revenuec  =  (Decimal)priorresult[0].YTD_Revenue__c ;
                     
                        if(priorresult[0].X12_Month_Rolling_Average_Sales_Cycle__c != null) 
                            Prior_X12_Month_Rolling_Average_Sales_Cyclec  =  (Decimal)priorresult[0].X12_Month_Rolling_Average_Sales_Cycle__c;
                     
                        if(priorresult[0].X12_Month_Average_Selling_Price__c != null) 
                            Prior_X12_Month_Average_Selling_Pricec  =  (Decimal)priorresult[0].X12_Month_Average_Selling_Price__c;
                     
                        if(priorresult[0].X12_Month_Rolling_Opportunity_Close_Rate__c != null) 
                            Prior_X12_Month_Rolling_Win_Percentagec   =  (Decimal)priorresult[0].X12_Month_Rolling_Opportunity_Close_Rate__c;
                        
                        if(priorresult[0].X12_Month_Rolling_Close_Rate__c != null) 
                            Prior_X12_Month_Rolling_revenueCloseRate   =  (Decimal)priorresult[0].X12_Month_Rolling_Close_Rate__c;
                    
                        if(priorresult[0].X12_Month_QO_added__c != null) 
                            Prior_X12_Month_Opprties_Added_to_the_funnelc  =  (Decimal)priorresult[0].X12_Month_QO_added__c;
                    
                        if(priorresult[0].X12_Month_Lead_Conv_for_1_oppty__c != null) 
                            Prior_X12_Month_Lead_Conv_for_1_opptyc  =  (Decimal)priorresult[0].X12_Month_Lead_Conv_for_1_oppty__c;
                    
                        if(priorresult[0].X12_Month_Leads_Added__c != null) 
                            Prior_X12_Month_Lead_Added_to_the_funnelc   =  (Decimal)priorresult[0].X12_Month_Leads_Added__c;
                   
                        if(priorresult[0].Monthly_Quota_Revenue__c != null) 
                            Prior_Monthly_Revenue  =  (Decimal)priorresult[0].Monthly_Quota_Revenue__c;
                    
                        if(priorresult[0].Quarterly_Quota_Revenue__c  != null) 
                            Prior_Quarterly_Revenue  =  (Decimal)priorresult[0].Quarterly_Quota_Revenue__c ;
                   
                    }
                     
                      
                
               
        }        
        
        
        
         /* Condition 3 : salesManger != '' and Sp= all
                 Result = salesManger and everyone under salesManger 
                 TeamResult = Everyone under Manager of salesManger 
         */
         
         if(sm != '' && sp == '' ){
            system.debug('inside Condition 3 ');
            String Mngid;
            String Spid;
            
        //Fetch the company level record associated with the particular level
        List<Company_Level__c> cl = [SELECT id,Sales_Rep_Profile__c,Sales_Rep_Profile__r.Role__c ,Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Sales_Manager__c FROM Company_Level__c WHERE Level_Value__c = :fw.SelectedLevelOne];
        Mngid = cl[0].Sales_Rep_Profile__r.Sales_Manager__c;
        Spid = cl[0].Sales_Rep_Profile__c;
        
        displayWrapper.name = cl[0].Sales_Rep_Profile__r.name;
        displayWrapper.Role= cl[0].Sales_Rep_Profile__r.Role__c;
        set<id> spidset = new set<id>();
        spidset.add(Spid);
        
        displayWrapper.score = FunnelCalculationHelper.findAggregateScore(spidset );
        
        List<Sales_Profile_Company_Level_Junction__c> spCLJun = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne];
        
        Set<Id> sr = new Set<Id>();
        
        for(Sales_Profile_Company_Level_Junction__c sj: spCLJun){
             sr.add(sj.Sales_Rep_Profile__c);
             system.debug('sj----->'+sj.Sales_Rep_Profile__r.name);
        }
         
        
        
                Result_Annual_Quota_Amountc = 0;
                Result_YTD_Revenuec = 0;
                Result_X12_Month_Rolling_Average_Sales_Cyclec = 0;
                Result_X12_Month_Average_Selling_Pricec = 0;
                Result_X12_Month_Rolling_Win_Percentagec = 0;
                Result_X12_Month_Rolling_revenueCloseRate = 0;
                Result_X12_Month_Opprties_Added_to_the_funnelc = 0;
                Result_X12_Month_Lead_Added_to_the_funnelc = 0;
                Result_X12_Month_Lead_Conv_for_1_opptyc = 0;
                
                Result_Monthly_Opp_Added =0;
                Result_Quaterly_Opp_Added  = 0;
                Result_Annual_Opp_Added  = 0;
                Result_Monthly_Lead_Added =0;
                Result_Quaterly_Lead_Added  = 0;
                Result_Annual_Lead_Added  = 0;
                
                Result_Monthly_Revenue = 0;
                Result_Quarterly_Revenue = 0;
                
                Result_Monthly_Quota_Amountc = 0;
                Result_Quarterly_Quota_Amountc = 0;
                
                Goal_Result_X12_Month_Rolling_Average_Sales_Cyclec = 0;
                Goal_Result_X12_Month_Rolling_Win_Percentagec = 0;
                Goal_Result_X12_Month_Rolling_revenueCloseRate = 0;
                Goal_Result_X12_Month_Lead_Conv_for_1_opptyc = 0;
                Goal_Result_X12_Month_Average_Selling_Pricec = 0;
                Goal_Result_YTDQuota = 0;
                
                integer count = 0;
                
                //Aggregate the results
        List<AggregateResult> ar = [Select SUM(YTD_Quota__c) yq,SUM(YTD_Revenue__c) y, SUM(Annual_Quota_Amount__c) a,SUM(Monthly_quota__c) aam,SUM(Quarterly_Quota__c) aaq, AVG(X12_Month_Average_Selling_Price__c) sp,  
                                    AVG(X12_Month_Lead_Conv_for_1_oppty__c) lc, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Rolling_Opportunity_Close_Rate__c) wp,
                                    SUM(X12_Month_QO_added__c) opaf, SUM(X12_Month_Leads_Added__c) laf,
                                    AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,SUM(Monthly_Quota_Revenue__c) mr, SUM(Quarterly_Quota_Revenue__c) qr,
                                    SUM(Monthly_QO_added__c) moa, SUM(Quarterly_QO_added__c)qoa, SUM(Ytd_QO_added__c) yoa, SUM(Monthly_Lead_Added__c) mla, SUM(Quarterly_Lead_Added__c) qla,SUM(YTD_Leads_Added__c) yla,
                                    SUM(Current_Active_Opportunities__c) ca, SUM(Current_Pipeline__c) cp, SUM(YTD_Opportunities_won__c) yw ,AVG(X12_Month_Rolling_Close_Rate__c) acr , AVG(Goal_12m_rolling_amt_close_rate__c) gacr
                                    from Sales_Rep_Profile__c where id IN :sr AND Annual_Quota_Amount__c > 0 AND Profile_Type__c != 'Overlay'];
        
        //Populate the wrapper
        if(ar != null && ar.size() > 0){                            
            
            if(ar[0].get('y') != null)
                Result_YTD_Revenuec = (Decimal)(ar[0].get('y'));
            
            if(ar[0].get('yq') != null)
                Goal_Result_YTDQuota = (Decimal)(ar[0].get('yq'));
            
            if(ar[0].get('a') != null)
                Result_Annual_Quota_Amountc = (Decimal)(ar[0].get('a'));
                
            if(ar[0].get('aam') != null)
                Result_Monthly_Quota_Amountc = (Decimal)(ar[0].get('aam'));
                
            if(ar[0].get('aaq') != null)
                Result_Quarterly_Quota_Amountc = (Decimal)(ar[0].get('aaq'));
            
            if(ar[0].get('sp') != null)    
                Result_X12_Month_Average_Selling_Pricec = (Decimal)(ar[0].get('sp'));
            
            if(ar[0].get('lc') != null)                
                Result_X12_Month_Lead_Conv_for_1_opptyc  = (Decimal)(ar[0].get('lc'));

            if(ar[0].get('sc') != null)
                Result_X12_Month_Rolling_Average_Sales_Cyclec = (Decimal)(ar[0].get('sc'));

            if(ar[0].get('wp') != null)                
                Result_X12_Month_Rolling_Win_Percentagec = (Decimal)(ar[0].get('wp'));
            
            if(ar[0].get('acr') != null)                
                Result_X12_Month_Rolling_revenueCloseRate = (Decimal)(ar[0].get('acr'));
                
            if(ar[0].get('opaf') != null)
                Result_X12_Month_Opprties_Added_to_the_funnelc = (Decimal)(ar[0].get('opaf'));

            if(ar[0].get('laf') != null)
                Result_X12_Month_Lead_Added_to_the_funnelc  = (Decimal)(ar[0].get('laf'));

            if(ar[0].get('spg') != null)
                Goal_Result_X12_Month_Average_Selling_Pricec = (Decimal)(ar[0].get('spg'));
                
            if(ar[0].get('lcg') != null)
                Goal_Result_X12_Month_Lead_Conv_for_1_opptyc = (Decimal)(ar[0].get('lcg'));

            if(ar[0].get('scg') != null)
                Goal_Result_X12_Month_Rolling_Average_Sales_Cyclec =  (Decimal)(ar[0].get('scg'));
            
            if(ar[0].get('wpg') != null)
                Goal_Result_X12_Month_Rolling_Win_Percentagec =  (Decimal)(ar[0].get('wpg'));
            
            if(ar[0].get('gacr') != null)
                Goal_Result_X12_Month_Rolling_revenueCloseRate =  (Decimal)(ar[0].get('gacr'));
                
            if(ar[0].get('moa') != null) 
                Result_Monthly_Opp_Added = (Decimal)(ar[0].get('moa'));
                
            if(ar[0].get('mla') != null) 
                Result_Monthly_Lead_Added = (Decimal)ar[0].get('mla');
             
            if(ar[0].get('mr') != null) 
               Result_Monthly_Revenue= (Decimal)ar[0].get('mr')  ;
                
            if(ar[0].get('qoa') != null) 
                Result_Quaterly_Opp_Added = (Decimal)ar[0].get('qoa');
               
            if(ar[0].get('qla') != null) 
                Result_Quaterly_Lead_Added = (Decimal)ar[0].get('qla');
                
            if(ar[0].get('qr') != null) 
                Result_Quarterly_Revenue= (Decimal)ar[0].get('qr')  ;
             
            if(ar[0].get('yoa') != null) 
                Result_Annual_Opp_Added = (Decimal)ar[0].get('yoa');
                
            if(ar[0].get('yla') != null) 
                Result_Annual_Lead_Added = (Decimal)ar[0].get('yla');
            
            //Score card
            
            if(ar[0].get('cp') != null) 
                curentPipeline  = convert(convertsub( (Decimal)ar[0].get('cp'),''),'$');
            
            if(ar[0].get('ca') != null) 
                activeopp  = convert(convertsub( (Decimal)ar[0].get('ca'),''),'');
            
            if(ar[0].get('yw') != null) 
                ytdWin  = convert(convertsub( (Decimal)ar[0].get('yw'),''),'');
            
            if(ar[0].get('sp') != null && (Decimal)ar[0].get('sp') > 0 && ar[0].get('y') != null  && ar[0].get('a') != null){
                Decimal win = ((Decimal)ar[0].get('a') - (Decimal)ar[0].get('y'))/(Decimal)ar[0].get('sp');
                winNeedToMakeQuota = convert(convertsub( win,''),'');
                 
            } 
                 
            
             
        }    
               
                TeamResult_Annual_Quota_Amountc =0;
                TeamResult_YTD_Revenuec =0;
                TeamResult_X12_Month_Rolling_Average_Sales_Cyclec =0;
                TeamResult_X12_Month_Average_Selling_Pricec =0;
                TeamResult_X12_Month_Rolling_Win_Percentagec =0;
                TeamResult_X12_Month_Opprties_Added_to_the_funnelc =0;
                TeamResult_X12_Month_Lead_Added_to_the_funnelc =0;
                TeamResult_X12_Month_Lead_Conv_for_1_opptyc =0;
                
                TeamResult_Monthly_Revenue = 0;
                TeamResult_Quarterly_Revenue = 0;
                
                TeamResult_Monthly_Quota_Amountc = 0;
                TeamResult_Quarterly_Quota_Amountc = 0;
                
                TeamResult_Monthly_Opp_Added =0;
                TeamResult_Quaterly_Opp_Added =0;
                TeamResult_Annual_Opp_Added =0;
                TeamResult_Monthly_Lead_Added =0;
                TeamResult_Quaterly_Lead_Added =0;
                TeamResult_Annual_Lead_Added =0;
                count =0;
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
        
        
        
                                 
            
        List<AggregateResult> ar2 = [Select SUM(YTD_Revenue__c) y, Sum(Annual_Quota_Amount__c) a,Sum(Monthly_quota__c) aam,Sum(Quarterly_Quota__c) aaq, AVG(X12_Month_Average_Selling_Price__c) sp,  
                                    AVG(X12_Month_Lead_Conv_for_1_oppty__c) lc, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Rolling_Opportunity_Close_Rate__c) wp,
                                    SUM(X12_Month_QO_added__c) opaf, SUM(X12_Month_Leads_Added__c) laf,
                                    AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,SUM(Monthly_Quota_Revenue__c) mr, SUM(Quarterly_Quota_Revenue__c) qr,
                                    SUM(Monthly_QO_added__c) moa, SUM(Quarterly_QO_added__c)qoa, SUM(Ytd_QO_added__c) yoa, SUM(Monthly_Lead_Added__c) mla, SUM(Quarterly_Lead_Added__c) qla,SUM(YTD_Leads_Added__c) yla
                                    from Sales_Rep_Profile__c where id IN :aggregateIds AND Annual_Quota_Amount__c > 0 AND Profile_Type__c != 'Overlay'];
        
            
        if(ar2 != null && ar2.size() > 0){  
            
            
            if(ar2[0].get('y') != null)
                TeamResult_YTD_Revenuec = (Decimal)(ar2[0].get('y'))/count;
            
            if(ar2[0].get('a') != null)
                TeamResult_Annual_Quota_Amountc = (Decimal)(ar2[0].get('a'))/count;
                
            if(ar2[0].get('aam') != null)
                TeamResult_Monthly_Quota_Amountc = (Decimal)(ar2[0].get('aam'))/count;
                
            if(ar2[0].get('aaq') != null)
                TeamResult_Quarterly_Quota_Amountc = (Decimal)(ar2[0].get('aaq'))/count;
            
            if(ar2[0].get('sp') != null)    
                TeamResult_X12_Month_Average_Selling_Pricec = (Decimal)(ar2[0].get('sp'));
            
            if(ar2[0].get('lc') != null)                
                TeamResult_X12_Month_Lead_Conv_for_1_opptyc  = (Decimal)(ar2[0].get('lc'));

            if(ar2[0].get('sc') != null)
                TeamResult_X12_Month_Rolling_Average_Sales_Cyclec = (Decimal)(ar2[0].get('sc'));

            
            if(ar2[0].get('wp') != null)                
                TeamResult_X12_Month_Rolling_Win_Percentagec = (Decimal)(ar2[0].get('wp'));
                
            if(ar2[0].get('opaf') != null)
                TeamResult_X12_Month_Opprties_Added_to_the_funnelc = (Decimal)(ar2[0].get('opaf'))/count;

            if(ar2[0].get('laf') != null)
                TeamResult_X12_Month_Lead_Added_to_the_funnelc  = (Decimal)(ar2[0].get('laf'))/count;

            /*if(ar2[0].get('spg') != null)
                Goal_Result_X12_Month_Average_Selling_Pricec = (Decimal)(ar2[0].get('spg'));
                
            if(ar2[0].get('lcg') != null)
                Goal_Result_X12_Month_Lead_Conv_for_1_opptyc = (Decimal)(ar2[0].get('lcg'));

            if(ar2[0].get('scg') != null)
                Goal_Result_X12_Month_Rolling_Average_Sales_Cyclec =  (Decimal)(ar2[0].get('scg'));
            
            if(ar2[0].get('wpg') != null)
                Goal_Result_X12_Month_Rolling_Win_Percentagec =  (Decimal)(ar2[0].get('wpg')); */
                
            
            if(ar2[0].get('moa') != null) 
                TeamResult_Monthly_Opp_Added = (Decimal)ar2[0].get('moa')/count;
             
            if(ar2[0].get('mla') != null) 
                TeamResult_Monthly_Lead_Added = (Decimal)ar2[0].get('mla')/count;
             
            if(ar2[0].get('mr') != null) 
                TeamResult_Monthly_Revenue = (Decimal)ar2[0].get('mr') /count ;
                
            if(ar2[0].get('qoa') != null) 
                TeamResult_Quaterly_Opp_Added = (Decimal)ar2[0].get('qoa')/count;
             
            if(ar2[0].get('qla') != null) 
                TeamResult_Quaterly_Lead_Added = (Decimal)ar2[0].get('qla')/count;
             
            if(ar2[0].get('qr') != null) 
                TeamResult_Quarterly_Revenue= (Decimal)ar2[0].get('qr')/count ;
             
            if(ar2[0].get('yoa') != null) 
                TeamResult_Annual_Opp_Added = (Decimal)ar2[0].get('yoa')/count;
            
            if(ar2[0].get('yla') != null) 
                TeamResult_Annual_Lead_Added = (Decimal)ar2[0].get('yla')/count;
                
            
            
            
        }    

        
                }
               
                    Prior_Annual_Quota_Amountc =0;                          
                    Prior_YTD_Revenuec =0;
                    Prior_X12_Month_Rolling_Average_Sales_Cyclec =0;
                    Prior_X12_Month_Average_Selling_Pricec =0;
                    Prior_X12_Month_Rolling_Win_Percentagec =0;
                    Prior_X12_Month_Rolling_revenueCloseRate =0;
                    Prior_X12_Month_Opprties_Added_to_the_funnelc =0;
                    Prior_X12_Month_Lead_Added_to_the_funnelc =0;
                    Prior_X12_Month_Lead_Conv_for_1_opptyc =0;
                    Prior_Monthly_Opp_Added =0;
                    Prior_Quaterly_Opp_Added =0;
                    Prior_Annual_Opp_Added =0;
                    Prior_Monthly_Lead_Added =0;
                    Prior_Quaterly_Lead_Added =0;
                    Prior_Annual_Lead_Added =0;
                    Prior_Monthly_Revenue  = 0;
                    Prior_Quarterly_Revenue  = 0;
                    
                    Prior_Monthly_Quota_Amountc = 0;
                    Prior_Quarterly_Quota_Amountc = 0;
                    count = 0;
                
                    
                List<Company_Level_Junction_snapshot__c> pspCLJun = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Company_Level_Junction_snapshot__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Snapshot_Scheduled_Date__c = :scheduleDate];
                Set<Id> psr = new Set<Id>();

                for(Company_Level_Junction_snapshot__c sj: pspCLJun){
                     psr.add(sj.Sales_Rep_Profile__c);
                    }
    
                    List<AggregateResult> ar3 = [Select SUM(YTD_Revenue__c) y, Sum(Annual_Quota_Amount__c) a,Sum(Monthly_quota__c) aam,Sum(Quarterly_Quota__c) aaq, AVG(X12_Month_Average_Selling_Price__c) sp,  
                                    AVG(X12_Month_Lead_Conv_for_1_oppty__c) lc, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Rolling_Opportunity_Close_Rate__c) wp,
                                    SUM(X12_Month_QO_added__c) opaf, SUM(X12_Month_Leads_Added__c) laf,
                                    SUM(Monthly_Quota_Revenue__c) mr, SUM(Quarterly_Quota_Revenue__c) qr,
                                    SUM(Monthly_QO_added_Quantitative__c) moa, SUM(Quarterly_QO_added_Quantitative__c)qoa, SUM(Ytd_QO_added_Quantitative__c) yoa, SUM(Monthly_Lead_Added__c) mla, SUM(Quarterly_Lead_Added__c) qla,SUM(YTD_Leads_Added__c) yla , AVG(Goal_12m_rolling_amt_close_rate__c) gacr , AVG(X12_Month_Rolling_Close_Rate__c) acr
                                    from Sales_Rep_Profile_Snapshot__c where Sales_Rep_Profile__c IN :psr AND Snapshot_Scheduled_Date__c = :scheduleDate AND  Annual_Quota_Amount__c > 0 AND Profile_Type__c != 'Overlay'];
                    
                
                 
                       
                if(ar3 != null && ar3.size() > 0){  
                
                    if(ar3[0].get('moa') != null) 
                        Prior_Monthly_Opp_Added = (Decimal)ar3[0].get('moa');
                       
                    if(ar3[0].get('mla') != null) 
                        Prior_Monthly_Lead_Added = (Decimal)ar3[0].get('mla');
                      
                    if(ar3[0].get('qoa') != null) 
                        Prior_Quaterly_Opp_Added = (Decimal)ar3[0].get('qoa');
                     
                    if(ar3[0].get('qla') != null) 
                        Prior_Quaterly_Lead_Added = (Decimal)ar3[0].get('qla');
                      
                    if(ar3[0].get('yoa') != null) 
                        Prior_Annual_Opp_Added = (Decimal)ar3[0].get('yoa');
                    
                    if(ar3[0].get('yla') != null) 
                        Prior_Annual_Lead_Added = (Decimal)ar3[0].get('yla');
                     
                    if(ar3[0].get('a') != null) 
                        Prior_Annual_Quota_Amountc  =  (Decimal)ar3[0].get('a');
                        
                    if(ar3[0].get('aam') != null) 
                        Prior_Monthly_Quota_Amountc =  (Decimal)ar3[0].get('aam');
                        
                    if(ar3[0].get('aaq') != null) 
                        Prior_Quarterly_Quota_Amountc=  (Decimal)ar3[0].get('aaq');
                     
                    if(ar3[0].get('y') != null) 
                        Prior_YTD_Revenuec =  (Decimal)ar3[0].get('y');
                     
                    if(ar3[0].get('sc') != null) 
                        Prior_X12_Month_Rolling_Average_Sales_Cyclec =  (Decimal)ar3[0].get('sc');
                     
                    if(ar3[0].get('sp') != null) 
                        Prior_X12_Month_Average_Selling_Pricec  =  (Decimal)ar3[0].get('sp');
                     
                    if(ar3[0].get('wp') != null) 
                        Prior_X12_Month_Rolling_Win_Percentagec  =  (Decimal)ar3[0].get('wp');
                    
                    if(ar3[0].get('acr') != null) 
                        Prior_X12_Month_Rolling_revenueCloseRate  =  (Decimal)ar3[0].get('acr');
                     
                    if(ar3[0].get('opaf') != null) 
                        Prior_X12_Month_Opprties_Added_to_the_funnelc =  (Decimal)ar3[0].get('opaf');
                    
                    if(ar3[0].get('lc') != null) 
                        Prior_X12_Month_Lead_Conv_for_1_opptyc =  (Decimal)ar3[0].get('lc');
                     
                    if(ar3[0].get('laf') != null) 
                        Prior_X12_Month_Lead_Added_to_the_funnelc  =  (Decimal)ar3[0].get('laf');
                     
                    if(ar3[0].get('mr') != null) 
                        Prior_Monthly_Revenue  =  (Decimal)ar3[0].get('mr');
                        
                    if(ar3[0].get('qr') != null) 
                        Prior_Quarterly_Revenue  =  (Decimal)ar3[0].get('qr');
                     
                    
                }   
                
                 
        }
                FunnelTable();
                
                system.debug(fcw28);
            }
}
    
    // This method calculate the values that are displayed on page.
    
    public List<FunnelCalculatorWrapper> FunnelTable(){
        
            FunnelCalculatorWrapperList = new List<FunnelCalculatorWrapper>();
        if(readAccess){    
            //system.debug('salesprofilename in side'+srpcal.name );
            fcw7 = new FunnelCalculatorWrapper();
            
            fcw7.FunnelDescription = 'Annual Quota';
            fcw7.PriorYearResult =  convertsub(Prior_YTD_Revenuec,'');
            fcw7.SalesRepGoal= convertsub(Result_Annual_Quota_Amountc,'');
            fcw7.TeamResult= convertsub(TeamResult_YTD_Revenuec,'' );
            fcw7.Result= convertsub(Result_YTD_Revenuec,'');
            fcw7.Gap_result_SalesRepGoal = fcw7.Result-fcw7.SalesRepGoal;
            fcw7.Gap_result_TeamResult = fcw7.Result-fcw7.TeamResult;
            system.debug(' fcw7.Result '+fcw7.Result);
            system.debug(' fcw7.PriorYearResult '+fcw7.PriorYearResult);
            fcw7.Gap_result_PriorYearResult = fcw7.Result-fcw7.PriorYearResult ;
            
            fcw7.PriorYearResultString = convert(fcw7.PriorYearResult,'$');
            fcw7.SalesRepGoalstring = convert(fcw7.SalesRepGoal,'$');
            fcw7.TeamResultstring = convert(fcw7.TeamResult,'$');
            fcw7.Resultstring  = convert(fcw7.Result,'$');
            fcw7.Gap_result_SalesRepGoalstring  = convert(fcw7.Gap_result_SalesRepGoal,'$');
            fcw7.Gap_result_TeamResultstring  = convert(fcw7.Gap_result_TeamResult,'$');
            fcw7.Gap_result_PriorYearResultString = convert(fcw7.Gap_result_PriorYearResult,'$');
            
            FunnelCalculatorWrapperList.add(fcw7);
            
            fcw8 = new FunnelCalculatorWrapper();
            
            fcw8.FunnelDescription = 'Quarterly Quota';
            fcw8.PriorYearResult = convertsub(Prior_Quarterly_Revenue,'');
            fcw8.SalesRepGoal= convertsub(Result_Quarterly_Quota_Amountc,'');
            fcw8.TeamResult= convertsub((TeamResult_Quarterly_Revenue),'');
            fcw8.Result= convertsub((Result_Quarterly_Revenue),'');
            fcw8.Gap_result_SalesRepGoal = ((fcw8.Result-fcw8.SalesRepGoal));
            fcw8.Gap_result_TeamResult = ((fcw8.Result-fcw8.TeamResult));
            fcw8.Gap_result_PriorYearResult= ((fcw8.Result-fcw8.PriorYearResult)) ;
            
            fcw8.PriorYearResultString = convert(fcw8.PriorYearResult,'$');
            fcw8.SalesRepGoalstring = convert(fcw8.SalesRepGoal,'$');
            fcw8.TeamResultstring = convert(fcw8.TeamResult,'$');
            fcw8.Resultstring  = convert(fcw8.Result,'$');
            fcw8.Gap_result_SalesRepGoalstring  = convert(fcw8.Gap_result_SalesRepGoal,'$');
            fcw8.Gap_result_TeamResultstring  = convert(fcw8.Gap_result_TeamResult,'$');
            fcw8.Gap_result_PriorYearResultString = convert(fcw8.Gap_result_PriorYearResult,'$');
            
            FunnelCalculatorWrapperList.add(fcw8);
            
            fcw9 = new FunnelCalculatorWrapper();
            
            fcw9.FunnelDescription = 'Monthly Quota';
            fcw9.PriorYearResult = convertsub(Prior_Monthly_Revenue,'');
            fcw9.SalesRepGoal= convertsub(Result_Monthly_Quota_Amountc,'');
            fcw9.TeamResult= convertsub((TeamResult_Monthly_Revenue),'');
            fcw9.Result= convertsub((Result_Monthly_Revenue),'');
            fcw9.Gap_result_SalesRepGoal =( fcw9.Result-fcw9.SalesRepGoal);
            fcw9.Gap_result_TeamResult = ((fcw9.Result-fcw9.TeamResult));
            fcw9.Gap_result_PriorYearResult = ((fcw9.Result-fcw9.PriorYearResult)) ;
            
            fcw9.PriorYearResultString = convert(fcw9.PriorYearResult,'$');
            fcw9.SalesRepGoalstring = convert(fcw9.SalesRepGoal,'$');
            fcw9.TeamResultstring = convert(fcw9.TeamResult,'$');
            fcw9.Resultstring  = convert(fcw9.Result,'$');
            fcw9.Gap_result_SalesRepGoalstring  = convert(fcw9.Gap_result_SalesRepGoal,'$');
            fcw9.Gap_result_TeamResultstring  = convert(fcw9.Gap_result_TeamResult,'$');
            fcw9.Gap_result_PriorYearResultString = convert(fcw9.Gap_result_PriorYearResult ,'$');
            
            FunnelCalculatorWrapperList.add(fcw9);
            
            fcw10 = new FunnelCalculatorWrapper();
            
            fcw10.FunnelDescription = 'Length of Sales Cycle';
            fcw10.PriorYearResult = convertsub(Prior_X12_Month_Rolling_Average_Sales_Cyclec,'') ;
            fcw10.SalesRepGoal= convertsub(Goal_Result_X12_Month_Rolling_Average_Sales_Cyclec,'') ;
            fcw10.TeamResult= convertsub((TeamResult_X12_Month_Rolling_Average_Sales_Cyclec),'');
            fcw10.Result= convertsub((Result_X12_Month_Rolling_Average_Sales_Cyclec),'');
            fcw10.Gap_result_SalesRepGoal = (fcw10.Result-fcw10.SalesRepGoal);
            fcw10.Gap_result_TeamResult = (fcw10.Result-fcw10.TeamResult);
            fcw10.Gap_result_PriorYearResult = (fcw10.Result-fcw10.PriorYearResult) ;
            
            fcw10.PriorYearResultString = convert(fcw10.PriorYearResult,'');
            fcw10.SalesRepGoalstring = convert(fcw10.SalesRepGoal,'');
            fcw10.TeamResultstring = convert(fcw10.TeamResult,'');
            fcw10.Resultstring  = convert(fcw10.Result,'');
            fcw10.Gap_result_SalesRepGoalstring  = convert(fcw10.Gap_result_SalesRepGoal,'');
            fcw10.Gap_result_TeamResultstring  = convert(fcw10.Gap_result_TeamResult,'');
            fcw10.Gap_result_PriorYearResultString = convert(fcw10.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw10);
            
            fcw11 = new FunnelCalculatorWrapper();
            
            fcw11.FunnelDescription = '12 month Average Selling Price or less than 12 month tenure YTD Avg. Selling Price';
            fcw11.PriorYearResult = convertsub(Prior_X12_Month_Average_Selling_Pricec,'') ;
            fcw11.SalesRepGoal= convertsub(Goal_Result_X12_Month_Average_Selling_Pricec,'') ;
            fcw11.TeamResult= convertsub((TeamResult_X12_Month_Average_Selling_Pricec),'');
            if(cal){
                AverageSellingPriceString = AverageSellingPriceString.remove('$'); 
                AverageSellingPriceString = AverageSellingPriceString.remove(','); 
                if(AverageSellingPriceString != null && AverageSellingPriceString != '$' && AverageSellingPriceString != ',' && AverageSellingPriceString != '.' && AverageSellingPriceString != ''){
                     AverageSellingPrice = Decimal.ValueOf(AverageSellingPriceString );
                }else{
                     AverageSellingPrice =0;
                }
                
                fcw11.Result= AverageSellingPrice;
            }else{
                fcw11.Result= convertsub((Result_X12_Month_Average_Selling_Pricec),'');
            }
            //system.debug('asp-->'+AverageSellingPrice +'--'+convertsub((Result_X12_Month_Average_Selling_Pricec),'') );
            
            
            fcw11.Gap_result_SalesRepGoal = (fcw11.Result-fcw11.SalesRepGoal) ;
            fcw11.Gap_result_TeamResult = (fcw11.Result-fcw11.TeamResult) ;
            fcw11.Gap_result_PriorYearResult = (fcw11.Result-fcw11.PriorYearResult) ;
            
            AverageSellingPrice = convertsub((fcw11.Result),'');
           
            //system.debug('asp-->'+AverageSellingPrice +'--'+convertsub((Result_X12_Month_Average_Selling_Pricec),'') );
            if(AverageSellingPrice == convertsub((Result_X12_Month_Average_Selling_Pricec),'')){
                asp =false;
            }else{
                asp = true;
            }
            AverageSellingPriceString = '$'+AverageSellingPrice.format();
            fcw11.PriorYearResultString = convert(fcw11.PriorYearResult,'$');
            fcw11.SalesRepGoalstring = convert(fcw11.SalesRepGoal,'$');
            fcw11.TeamResultstring = convert(fcw11.TeamResult,'$');
            fcw11.Resultstring  = convert(fcw11.Result,'$');
            fcw11.Gap_result_SalesRepGoalstring  = convert(fcw11.Gap_result_SalesRepGoal,'$');
            fcw11.Gap_result_TeamResultstring  = convert(fcw11.Gap_result_TeamResult,'$');
            fcw11.Gap_result_PriorYearResultString = convert(fcw11.Gap_result_PriorYearResult ,'$');
            
            FunnelCalculatorWrapperList.add(fcw11);
            
            
            
            
            
            fcw23 = new FunnelCalculatorWrapper();
            
            fcw23.FunnelDescription = '12 month rolling win rate or if less than 12 months tenure use YTD Win Rate (Qualified =  10% or Greater which moved to a Win)';
            fcw23.PriorYearResult = Prior_X12_Month_Rolling_Win_Percentagec ;
            fcw23.SalesRepGoal= Goal_Result_X12_Month_Rolling_Win_Percentagec ;
            fcw23.TeamResult= (TeamResult_X12_Month_Rolling_Win_Percentagec) ;
            if(cal){
                RollingCloseRateString = RollingCloseRateString.remove('%'); 
                //RollingConversionLeadString = RollingConversionLeadString.remove(','); 
                if(RollingCloseRateString != null && RollingCloseRateString != '%'  && RollingCloseRateString != '.' && RollingCloseRateString != ''){
                    RollingCloseRate = Decimal.ValueOf(RollingCloseRateString );
                }else{
                    RollingCloseRate = 0;
                }
                
                fcw23.Result= RollingCloseRate;
            }else{
               fcw23.Result= (Result_X12_Month_Rolling_Win_Percentagec)  ;
            }
            
            fcw23.Gap_result_SalesRepGoal = (fcw23.Result-fcw23.SalesRepGoal) ;
            fcw23.Gap_result_TeamResult = (fcw23.Result-fcw23.TeamResult) ;
            fcw23.Gap_result_PriorYearResult = (fcw23.Result-fcw23.PriorYearResult) ;
            RollingCloseRate = (fcw23.Result).setScale(2, RoundingMode.HALF_UP);
            
            //system.debug('cr-->'+RollingCloseRate +'--'+Result_X12_Month_Rolling_Win_Percentagec.setScale(2, RoundingMode.HALF_UP));
            if(RollingCloseRate == Result_X12_Month_Rolling_Win_Percentagec.setScale(2, RoundingMode.HALF_UP)){
                cr =false;
            }else{
                cr = true;
            }
            RollingCloseRateString = RollingCloseRate.format()+'%';
            
            fcw23.PriorYearResultString = convert(fcw23.PriorYearResult,'%');
            fcw23.SalesRepGoalstring = convert(fcw23.SalesRepGoal,'%');
            fcw23.TeamResultstring = convert(fcw23.TeamResult,'%');
            fcw23.Resultstring  = convert(fcw23.Result,'%');
            fcw23.Gap_result_SalesRepGoalstring  = convert(fcw23.Gap_result_SalesRepGoal,'%');
            fcw23.Gap_result_TeamResultstring  = convert(fcw23.Gap_result_TeamResult,'%');
            fcw23.Gap_result_PriorYearResultString = convert(fcw23.Gap_result_PriorYearResult ,'%');
            
            fcw24 = new FunnelCalculatorWrapper();
            
            fcw24.FunnelDescription = '# of Wins to Achieve Annual Quota';
            
            
            if( fcw11.SalesRepGoal != 0){
                fcw24.SalesRepGoal= convertsub((fcw7.SalesRepGoal/fcw11.SalesRepGoal),'');
            }else{
                fcw24.SalesRepGoal= 0;
            }
            
            if( fcw11.PriorYearResult != 0){
                fcw24.PriorYearResult = convertsub((Prior_Annual_Quota_Amountc /fcw11.PriorYearResult ),'');
            }else{
                fcw24.PriorYearResult = 0;
            }
            
            if(fcw11.TeamResult != 0){
                fcw24.TeamResult= convertsub((TeamResult_Annual_Quota_Amountc /fcw11.TeamResult) ,'');
            }else{
                fcw24.TeamResult= 0 ;
            }
            if(fcw11.Result != 0){
                fcw24.Result= convertsub((fcw7.SalesRepGoal/fcw11.Result),'') ;
            } else{
                fcw24.Result= 0;
            }
            
            
            
            fcw24.Gap_result_SalesRepGoal = (fcw24.Result-fcw24.SalesRepGoal) ;
            fcw24.Gap_result_TeamResult = (fcw24.Result-fcw24.TeamResult) ;
            fcw24.Gap_result_PriorYearResult = (fcw24.Result-fcw24.PriorYearResult) ;
            
            fcw24.PriorYearResultString = convert(fcw24.PriorYearResult,'');
            fcw24.SalesRepGoalstring = convert(fcw24.SalesRepGoal,'');
            fcw24.TeamResultstring = convert(fcw24.TeamResult,'');
            fcw24.Resultstring  = convert(fcw24.Result,'');
            fcw24.Gap_result_SalesRepGoalstring  = convert(fcw24.Gap_result_SalesRepGoal,'');
            fcw24.Gap_result_TeamResultstring  = convert(fcw24.Gap_result_TeamResult,'');
            fcw24.Gap_result_PriorYearResultString = convert(fcw24.Gap_result_PriorYearResult ,'');
            
            fcw18 = new FunnelCalculatorWrapper();
            
            fcw18.FunnelDescription = '# of Annual Qualifiied Opportunities - 10% to Achieve Quota';
            
            
             if(fcw23.SalesRepGoal != 0){
                
                fcw18.SalesRepGoal= convertsub(((fcw24.SalesRepGoal/fcw23.SalesRepGoal)*100),'') ;
            }else{
                fcw18.SalesRepGoal= 0;
            }
            
            
            if(fcw23.PriorYearResult != 0){
                
                fcw18.PriorYearResult = convertsub(((fcw24.PriorYearResult /fcw23.PriorYearResult )*100),'') ;
            }else{
                fcw18.PriorYearResult = 0;
            }
            
            if(fcw23.TeamResult != 0){
                fcw18.TeamResult= convertsub(((fcw24.TeamResult/fcw23.TeamResult)*100),'') ;
            }else{
                fcw18.TeamResult= 0;
            }
            
            if(fcw23.Result !=0){
                fcw18.Result= convertsub(((fcw24.Result/fcw23.Result)*100),'') ;
            }else{
                fcw18.Result= 0;
            }
            
            fcw18.Gap_result_SalesRepGoal = (fcw18.Result-fcw18.SalesRepGoal) ;
            fcw18.Gap_result_TeamResult =( fcw18.Result-fcw18.TeamResult);
            fcw18.Gap_result_PriorYearResult = (fcw18.Result-fcw18.PriorYearResult) ;
            
            fcw18.PriorYearResultString = convert(fcw18.PriorYearResult,'');
            fcw18.SalesRepGoalstring = convert(fcw18.SalesRepGoal,'');
            fcw18.TeamResultstring = convert(fcw18.TeamResult,'');
            fcw18.Resultstring  = convert(fcw18.Result,'');
            fcw18.Gap_result_SalesRepGoalstring  = convert(fcw18.Gap_result_SalesRepGoal,'');
            fcw18.Gap_result_TeamResultstring  = convert(fcw18.Gap_result_TeamResult,'');
            fcw18.Gap_result_PriorYearResultString = convert(fcw18.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw18);
            
            fcw25 = new FunnelCalculatorWrapper();
            
            fcw25.FunnelDescription = '# of Wins to Achieve Quarterly Quota';
            
            
            if(fcw11.SalesRepGoal!= 0 ){
                 fcw25.SalesRepGoal= convertsub((fcw8.SalesRepGoal/fcw11.SalesRepGoal),'') ;
            }else{
                 fcw25.SalesRepGoal= 0;
            }
            
            if(fcw11.PriorYearResult != 0 ){
                 fcw25.PriorYearResult = convertsub((Prior_Quarterly_Quota_Amountc /fcw11.PriorYearResult ),'') ;
            }else{
                 fcw25.PriorYearResult = 0;
            }
            if(fcw11.TeamResult != 0 ){
                 fcw25.TeamResult= convertsub((TeamResult_Quarterly_Quota_Amountc/fcw11.TeamResult),'') ;
            }else{
                 fcw25.TeamResult= 0;
            }
            if(fcw11.Result!=0){
               fcw25.Result= convertsub(( fcw8.SalesRepGoal/fcw11.Result),'') ;
            }else{
               fcw25.Result=0;
            }
            
            fcw25.Gap_result_SalesRepGoal = (fcw25.Result-fcw25.SalesRepGoal) ;
            fcw25.Gap_result_TeamResult =( fcw25.Result-fcw25.TeamResult) ;
            fcw25.Gap_result_PriorYearResult = (fcw25.Result-fcw25.PriorYearResult) ;
            
            fcw25.PriorYearResultString = convert(fcw25.PriorYearResult,'');
            fcw25.SalesRepGoalstring = convert(fcw25.SalesRepGoal,'');
            fcw25.TeamResultstring = convert(fcw25.TeamResult,'');
            fcw25.Resultstring  = convert(fcw25.Result,'');
            fcw25.Gap_result_SalesRepGoalstring  = convert(fcw25.Gap_result_SalesRepGoal,'');
            fcw25.Gap_result_TeamResultstring  = convert(fcw25.Gap_result_TeamResult,'');
            fcw25.Gap_result_PriorYearResultString = convert(fcw25.Gap_result_PriorYearResult ,'');
            
            
            fcw19 = new FunnelCalculatorWrapper();
             
             fcw19.FunnelDescription = '# of Quarterly Qualifiied Opportunities - 10% to Achieve Quota';
             
             if(fcw23.PriorYearResult != 0){
                fcw19.PriorYearResult = convertsub(((fcw25.PriorYearResult /fcw23.PriorYearResult )*100),'');
            }else{
                fcw19.PriorYearResult = 0;
            }  
            
            if(fcw23.SalesRepGoal != 0){
                fcw19.SalesRepGoal= convertsub(((fcw25.SalesRepGoal/fcw23.SalesRepGoal)*100),'');
            }else{
                fcw19.SalesRepGoal=0;
            }
            
            if(fcw23.TeamResult != 0){
                fcw19.TeamResult= convertsub(((fcw25.TeamResult/fcw23.TeamResult)*100),'') ;
            }else{
                fcw19.TeamResult=0;
            }
            
            if(fcw23.Result !=0){
                fcw19.Result= convertsub(((fcw25.Result/fcw23.Result)*100),'') ;
             }else{
                fcw19.Result=0;
            }
            
            fcw19.Gap_result_SalesRepGoal = (fcw19.Result-fcw19.SalesRepGoal) ;
            fcw19.Gap_result_TeamResult = (fcw19.Result-fcw19.TeamResult) ;
            fcw19.Gap_result_PriorYearResult = (fcw19.Result-fcw19.PriorYearResult) ;
            
            fcw19.PriorYearResultString = convert(fcw19.PriorYearResult,'');
            fcw19.SalesRepGoalstring = convert(fcw19.SalesRepGoal,'');
            fcw19.TeamResultstring = convert(fcw19.TeamResult,'');
            fcw19.Resultstring  = convert(fcw19.Result,'');
            fcw19.Gap_result_SalesRepGoalstring  = convert(fcw19.Gap_result_SalesRepGoal,'');
            fcw19.Gap_result_TeamResultstring  = convert(fcw19.Gap_result_TeamResult,'');
            fcw19.Gap_result_PriorYearResultString = convert(fcw19.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw19);
            
            fcw26 = new FunnelCalculatorWrapper();
            
            fcw26.FunnelDescription = '# of Wins to Achieve Monthly Quota';
            
            
            if(fcw11.SalesRepGoal != 0 ){
                fcw26.SalesRepGoal = convertsub((fcw9.SalesRepGoal/fcw11.SalesRepGoal),'') ;
            }else{
                fcw26.SalesRepGoal= 0;
            }
            
            if(fcw11.PriorYearResult != 0 ){
                fcw26.PriorYearResult = convertsub((Prior_Monthly_Quota_Amountc /fcw11.PriorYearResult ),'') ;
            }else{
                fcw26.PriorYearResult = 0;
            }
            if(fcw11.TeamResult != 0 ){
                fcw26.TeamResult= convertsub((TeamResult_Monthly_Quota_Amountc/fcw11.TeamResult),'') ;
            }else{
                fcw26.TeamResult= 0;
            }
            if( fcw11.Result!= 0){
                fcw26.Result= convertsub((fcw9.SalesRepGoal/fcw11.Result),'') ;
            }else{
                 fcw26.Result= 0;
            }
            
            fcw26.Gap_result_SalesRepGoal = (fcw26.Result-fcw26.SalesRepGoal) ;
            fcw26.Gap_result_TeamResult = (fcw26.Result-fcw26.TeamResult) ;
            fcw26.Gap_result_PriorYearResult = (fcw26.Result-fcw26.PriorYearResult) ;
            
            fcw26.PriorYearResultString = convert(fcw26.PriorYearResult,'');
            fcw26.SalesRepGoalstring = convert(fcw26.SalesRepGoal,'');
            fcw26.TeamResultstring = convert(fcw26.TeamResult,'');
            fcw26.Resultstring  = convert(fcw26.Result,'');
            fcw26.Gap_result_SalesRepGoalstring  = convert(fcw26.Gap_result_SalesRepGoal,'');
            fcw26.Gap_result_TeamResultstring  = convert(fcw26.Gap_result_TeamResult,'');
            fcw26.Gap_result_PriorYearResultString = convert(fcw26.Gap_result_PriorYearResult ,'');
            
            
            fcw20 = new FunnelCalculatorWrapper();
            
            fcw20.FunnelDescription = '# of Monthly Qualifiied Opportunities - 10% to Achieve Quota';
            fcw20.PriorYearResult = 0;
            fcw20.SalesRepGoal= 0;
            fcw20.TeamResult= 0;
            fcw20.Result = 0;
            
            if(fcw23.PriorYearResult !=0)
                fcw20.PriorYearResult = convertsub(((fcw26.PriorYearResult /fcw23.PriorYearResult )*100),'');
            
            if(fcw23.PriorYearResult !=0)   
                fcw20.SalesRepGoal= convertsub(((fcw26.SalesRepGoal/fcw23.SalesRepGoal)*100),'');
            
            if(fcw23.TeamResult!=0)
                fcw20.TeamResult= convertsub(((fcw26.TeamResult/fcw23.TeamResult)*100),'') ;
           
            if(fcw23.Result!=0)
                fcw20.Result= convertsub(((fcw26.Result/fcw23.Result)*100),'') ;
                
            fcw20.Gap_result_SalesRepGoal = (fcw20.Result-fcw20.SalesRepGoal) ;
            fcw20.Gap_result_TeamResult = (fcw20.Result-fcw20.TeamResult) ;
            fcw20.Gap_result_PriorYearResult = (fcw20.Result-fcw20.PriorYearResult) ;
            
            fcw20.PriorYearResultString = convert(fcw20.PriorYearResult,'');
            fcw20.SalesRepGoalstring = convert(fcw20.SalesRepGoal,'');
            fcw20.TeamResultstring = convert(fcw20.TeamResult,'');
            fcw20.Resultstring  = convert(fcw20.Result,'');
            fcw20.Gap_result_SalesRepGoalstring  = convert(fcw20.Gap_result_SalesRepGoal,'');
            fcw20.Gap_result_TeamResultstring  = convert(fcw20.Gap_result_TeamResult,'');
            fcw20.Gap_result_PriorYearResultString = convert(fcw20.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw20);
            
            fcw21 = new FunnelCalculatorWrapper();
            
            fcw21.FunnelDescription = '12 month or YTD total qualified opportunities added to funnel';
            fcw21.PriorYearResult = convertsub(Prior_X12_Month_Opprties_Added_to_the_funnelc,'') ;
            fcw21.SalesRepGoal= 0;
            fcw21.TeamResult= convertsub((TeamResult_X12_Month_Opprties_Added_to_the_funnelc),'') ;
            fcw21.Result= convertsub((Result_X12_Month_Opprties_Added_to_the_funnelc),'') ;
            fcw21.Gap_result_SalesRepGoal = (fcw21.Result-fcw21.SalesRepGoal) ;
            fcw21.Gap_result_TeamResult = (fcw21.Result-fcw21.TeamResult) ;
            fcw21.Gap_result_PriorYearResult = (fcw21.Result-fcw21.PriorYearResult) ;
            
            fcw21.PriorYearResultString = convert(fcw21.PriorYearResult,'');
            fcw21.SalesRepGoalstring = convert(fcw21.SalesRepGoal,'');
            fcw21.TeamResultstring = convert(fcw21.TeamResult,'');
            fcw21.Resultstring  = convert(fcw21.Result,'');
            fcw21.Gap_result_SalesRepGoalstring  = convert(fcw21.Gap_result_SalesRepGoal,'');
            fcw21.Gap_result_TeamResultstring  = convert(fcw21.Gap_result_TeamResult,'');
            fcw21.Gap_result_PriorYearResultString = convert(fcw21.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw21);
            FunnelCalculatorWrapperList.add(fcw23);
            FunnelCalculatorWrapperList.add(fcw24);
            
            
            FunnelCalculatorWrapperList.add(fcw25);
            
            
            FunnelCalculatorWrapperList.add(fcw26);
            
            fcw12 = new FunnelCalculatorWrapper();
            
            fcw12.FunnelDescription = '12 Month Rolling Conversion % of all Leads to generate 1 Active 10% Opportunity';
            fcw12.PriorYearResult = Prior_X12_Month_Lead_Conv_for_1_opptyc ;
            fcw12.SalesRepGoal= Goal_Result_X12_Month_Lead_Conv_for_1_opptyc ;
            fcw12.TeamResult= (TeamResult_X12_Month_Lead_Conv_for_1_opptyc) ;
            
             if(cal){
                RollingConversionLeadString = RollingConversionLeadString.remove('%'); 
                //RollingConversionLeadString = RollingConversionLeadString.remove(',');
                if(RollingConversionLeadString != null && RollingConversionLeadString != '%'  && RollingConversionLeadString != '.' && RollingConversionLeadString != ''){
                    RollingConversionLead = Decimal.ValueOf(RollingConversionLeadString );
                }else{
                    RollingConversionLead = 0;
                } 
                
                fcw12.Result= RollingConversionLead;
            }else{
                fcw12.Result= (Result_X12_Month_Lead_Conv_for_1_opptyc) ;
            }
            
            fcw12.Gap_result_SalesRepGoal = (fcw12.Result-fcw12.SalesRepGoal) ;
            fcw12.Gap_result_TeamResult = (fcw12.Result-fcw12.TeamResult) ;
            fcw12.Gap_result_PriorYearResult = (fcw12.Result-fcw12.PriorYearResult) ;
            RollingConversionLead = (fcw12.Result).setScale(2, RoundingMode.HALF_UP);
            
            //system.debug('lcr-->'+RollingConversionLead  +'--'+Result_X12_Month_Lead_Conv_for_1_opptyc.setScale(2, RoundingMode.HALF_UP));
            if(RollingConversionLead  == Result_X12_Month_Lead_Conv_for_1_opptyc.setScale(2, RoundingMode.HALF_UP)){
                lcr= false;
            }else{
                lcr= true;
            }
            RollingConversionLeadString = RollingConversionLead.format()+'%';
            
            fcw12.PriorYearResultString = convert(fcw12.PriorYearResult,'%');
            fcw12.SalesRepGoalstring = convert(fcw12.SalesRepGoal,'%');
            fcw12.TeamResultstring = convert(fcw12.TeamResult,'%');
            fcw12.Resultstring  = convert(fcw12.Result,'%');
            fcw12.Gap_result_SalesRepGoalstring  = convert(fcw12.Gap_result_SalesRepGoal,'%');
            fcw12.Gap_result_TeamResultstring  = convert(fcw12.Gap_result_TeamResult,'%');
            fcw12.Gap_result_PriorYearResultString = convert(fcw12.Gap_result_PriorYearResult ,'%');
            
            FunnelCalculatorWrapperList.add(fcw12);
            
            fcw13 = new FunnelCalculatorWrapper();
            
            fcw13.FunnelDescription = '# of LEADs to generate 1 Qualified Opportunity';
            
            
            if(fcw12.SalesRepGoal != 0 ){
                fcw13.SalesRepGoal= convertsub((100/fcw12.SalesRepGoal),'') ;
            }else{
                fcw13.SalesRepGoal= 0;
            }
            
            
            if(fcw12.PriorYearResult != 0 ){
                fcw13.PriorYearResult = convertsub((100/fcw12.PriorYearResult ),'') ;
            }else{
                fcw13.PriorYearResult = 0;
            }
            
            if(fcw12.TeamResult != 0 ){
                fcw13.TeamResult= convertsub((100/fcw12.TeamResult),'') ;
            }else{
                fcw13.TeamResult= 0;
            }
            if(fcw12.Result != 0){
                fcw13.Result=  convertsub((100/fcw12.Result),'') ;
            }else{
                fcw13.Result=  0;
            }
            
            fcw13.Gap_result_SalesRepGoal = (fcw13.Result-fcw13.SalesRepGoal) ;
            fcw13.Gap_result_TeamResult = (fcw13.Result-fcw13.TeamResult) ;
            fcw13.Gap_result_PriorYearResult = (fcw13.Result-fcw13.PriorYearResult) ;
            
            fcw13.PriorYearResultString = convert(fcw13.PriorYearResult,'');
            fcw13.SalesRepGoalstring = convert(fcw13.SalesRepGoal,'');
            fcw13.TeamResultstring = convert(fcw13.TeamResult,'');
            fcw13.Resultstring  = convert(fcw13.Result,'');
            fcw13.Gap_result_SalesRepGoalstring  = convert(fcw13.Gap_result_SalesRepGoal,'');
            fcw13.Gap_result_TeamResultstring  = convert(fcw13.Gap_result_TeamResult,'');
            fcw13.Gap_result_PriorYearResultString = convert(fcw13.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw13);
            
            fcw14 = new FunnelCalculatorWrapper();
            
            fcw14.FunnelDescription = '# of LEADs to generate 1 Win';
            
            
            if(fcw23.SalesRepGoal!= 0 ){
                fcw14.SalesRepGoal= convertsub((fcw13.SalesRepGoal*100/fcw23.SalesRepGoal),'') ;
            }else{
                fcw14.SalesRepGoal= 0;
            }
            
            if(fcw23.PriorYearResult != 0 ){
                fcw14.PriorYearResult = convertsub((fcw13.PriorYearResult *100/fcw23.PriorYearResult ),'') ;
            }else{
                fcw14.PriorYearResult = 0;
            }
            if(fcw23.TeamResult != 0 ){
                fcw14.TeamResult= convertsub((fcw13.TeamResult*100/fcw23.TeamResult),'') ;
            }else{
                fcw14.TeamResult= 0;
            }
            if( fcw23.Result !=0){
                fcw14.Result=  convertsub((fcw13.Result*100/fcw23.Result),'') ;
            }else{
                fcw14.Result=  0;
            }
            
            fcw14.Gap_result_SalesRepGoal = (fcw14.Result-fcw14.SalesRepGoal) ;
            fcw14.Gap_result_TeamResult = (fcw14.Result-fcw14.TeamResult) ;
            fcw14.Gap_result_PriorYearResult = (fcw14.Result-fcw14.PriorYearResult) ;
            
            fcw14.PriorYearResultString = convert(fcw14.PriorYearResult,'');
            fcw14.SalesRepGoalstring = convert(fcw14.SalesRepGoal,'');
            fcw14.TeamResultstring = convert(fcw14.TeamResult,'');
            fcw14.Resultstring  = convert(fcw14.Result,'');
            fcw14.Gap_result_SalesRepGoalstring  = convert(fcw14.Gap_result_SalesRepGoal,'');
            fcw14.Gap_result_TeamResultstring  = convert(fcw14.Gap_result_TeamResult,'');
            fcw14.Gap_result_PriorYearResultString = convert(fcw14.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw14);
            
            fcw15 = new FunnelCalculatorWrapper();
            
            fcw15.FunnelDescription = '# of Quarterly LEADs to Achieve Quota';
            fcw15.PriorYearResult = convertsub((fcw14.PriorYearResult *fcw25.PriorYearResult ),'') ;
            fcw15.SalesRepGoal= convertsub((fcw14.SalesRepGoal*fcw25.SalesRepGoal),'') ;
            fcw15.TeamResult= convertsub((fcw14.TeamResult*fcw25.TeamResult),'') ;
            fcw15.Result=  convertsub((fcw14.Result*fcw25.Result),'') ;
            fcw15.Gap_result_SalesRepGoal = (fcw15.Result-fcw15.SalesRepGoal) ;
            fcw15.Gap_result_TeamResult = (fcw15.Result-fcw15.TeamResult) ;
            fcw15.Gap_result_PriorYearResult = (fcw15.Result-fcw15.PriorYearResult) ;
            
            fcw15.PriorYearResultString = convert(fcw15.PriorYearResult,'');
            fcw15.SalesRepGoalstring = convert(fcw15.SalesRepGoal,'');
            fcw15.TeamResultstring = convert(fcw15.TeamResult,'');
            fcw15.Resultstring  = convert(fcw15.Result,'');
            fcw15.Gap_result_SalesRepGoalstring  = convert(fcw15.Gap_result_SalesRepGoal,'');
            fcw15.Gap_result_TeamResultstring  = convert(fcw15.Gap_result_TeamResult,'');
            fcw15.Gap_result_PriorYearResultString = convert(fcw15.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw15);
            
            fcw16 = new FunnelCalculatorWrapper();
            
            fcw16.FunnelDescription = '# of Monthly LEADs to Achieve Quota';
            fcw16.PriorYearResult = convertsub((fcw14.PriorYearResult *fcw26.PriorYearResult ),'') ;
            fcw16.SalesRepGoal= convertsub((fcw14.SalesRepGoal*fcw26.SalesRepGoal),'');
            fcw16.TeamResult= convertsub((fcw14.TeamResult*fcw26.TeamResult),'') ;
            fcw16.Result=  convertsub((fcw14.Result*fcw26.Result),'') ;
            fcw16.Gap_result_SalesRepGoal = (fcw16.Result-fcw16.SalesRepGoal) ;
            fcw16.Gap_result_TeamResult = (fcw16.Result-fcw16.TeamResult) ;
            fcw16.Gap_result_PriorYearResult = (fcw16.Result-fcw16.PriorYearResult) ;
            
            fcw16.PriorYearResultString = convert(fcw16.PriorYearResult,'');
            fcw16.SalesRepGoalstring = convert(fcw16.SalesRepGoal,'');
            fcw16.TeamResultstring = convert(fcw16.TeamResult,'');
            fcw16.Resultstring  = convert(fcw16.Result,'');
            fcw16.Gap_result_SalesRepGoalstring  = convert(fcw16.Gap_result_SalesRepGoal,'');
            fcw16.Gap_result_TeamResultstring  = convert(fcw16.Gap_result_TeamResult,'');
            fcw16.Gap_result_PriorYearResultString = convert(fcw16.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw16);
            
            fcw17 = new FunnelCalculatorWrapper();
            
            fcw17.FunnelDescription = '# of Daily LEADs to Achieve Quota';
            fcw17.PriorYearResult = convertsub((fcw16.PriorYearResult /22),'');
            fcw17.SalesRepGoal= convertsub((fcw16.SalesRepGoal/22),'');
            fcw17.TeamResult= convertsub((fcw16.TeamResult/22),'') ;
            fcw17.Result=  convertsub((fcw16.Result/22),'') ;
            fcw17.Gap_result_SalesRepGoal = (fcw17.Result-fcw17.SalesRepGoal) ;
            fcw17.Gap_result_TeamResult = (fcw17.Result-fcw17.TeamResult) ;
            fcw17.Gap_result_PriorYearResult = (fcw17.Result-fcw17.PriorYearResult) ;
            
            fcw17.PriorYearResultString = convert(fcw17.PriorYearResult,'');
            fcw17.SalesRepGoalstring = convert(fcw17.SalesRepGoal,'');
            fcw17.TeamResultstring = convert(fcw17.TeamResult,'');
            fcw17.Resultstring  = convert(fcw17.Result,'');
            fcw17.Gap_result_SalesRepGoalstring  = convert(fcw17.Gap_result_SalesRepGoal,'');
            fcw17.Gap_result_TeamResultstring  = convert(fcw17.Gap_result_TeamResult,'');
            fcw17.Gap_result_PriorYearResultString = convert(fcw17.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw17);
            
            
            fcw27 = new FunnelCalculatorWrapper();
            
            fcw27.FunnelDescription = '# of Annual LEADs to Achieve Quota';
            fcw27.PriorYearResult = convertsub((fcw14.PriorYearResult *fcw24.PriorYearResult ),'');
            fcw27.SalesRepGoal= convertsub((fcw14.SalesRepGoal*fcw24.SalesRepGoal),'');
            fcw27.TeamResult= convertsub((fcw14.TeamResult*fcw24.TeamResult),'') ;
            fcw27.Result=  convertsub((fcw14.Result*fcw24.Result),'') ;
            fcw27.Gap_result_SalesRepGoal = (fcw27.Result-fcw27.SalesRepGoal) ;
            fcw27.Gap_result_TeamResult = (fcw27.Result-fcw27.TeamResult) ;
            fcw27.Gap_result_PriorYearResult = (fcw27.Result-fcw27.PriorYearResult) ;
            
            fcw27.PriorYearResultString = convert(fcw27.PriorYearResult,'');
            fcw27.SalesRepGoalstring = convert(fcw27.SalesRepGoal,'');
            fcw27.TeamResultstring = convert(fcw27.TeamResult,'');
            fcw27.Resultstring  = convert(fcw27.Result,'');
            fcw27.Gap_result_SalesRepGoalstring  = convert(fcw27.Gap_result_SalesRepGoal,'');
            fcw27.Gap_result_TeamResultstring  = convert(fcw27.Gap_result_TeamResult,'');
            fcw27.Gap_result_PriorYearResultString = convert(fcw27.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw27);
            
            fcw28 = new FunnelCalculatorWrapper();
            
            fcw28.FunnelDescription = '# YTD Annual quota';
            fcw28.PriorYearResult = convertsub((fcw7.PriorYearResult),'');
            fcw28.SalesRepGoal= convertsub((Goal_Result_YTDQuota),'');
           // fcw28.TeamResult= (fcw7.TeamResult/12)*currentFiscalMonths;
            fcw28.TeamResult= convertsub((fcw7.TeamResult),'');
            fcw28.Result=  convertsub((fcw7.Result),'');
            fcw28.Gap_result_SalesRepGoal = (fcw28.Result-fcw28.SalesRepGoal) ;
            fcw28.Gap_result_TeamResult = (fcw28.Result-fcw28.TeamResult) ;
            fcw28.Gap_result_PriorYearResult = (fcw28.Result-fcw28.PriorYearResult) ;
            
            fcw28.PriorYearResultString = convert(fcw28.PriorYearResult,'$');
            fcw28.SalesRepGoalstring = convert(fcw28.SalesRepGoal,'$');
            fcw28.TeamResultstring = convert(fcw28.TeamResult,'$');
            fcw28.Resultstring  = convert(fcw28.Result,'$');
            fcw28.Gap_result_SalesRepGoalstring  = convert(fcw28.Gap_result_SalesRepGoal,'$');
            fcw28.Gap_result_TeamResultstring  = convert(fcw28.Gap_result_TeamResult,'$');
            fcw28.Gap_result_PriorYearResultString = convert(fcw28.Gap_result_PriorYearResult ,'$');
            
            FunnelCalculatorWrapperList.add(fcw28);
            
            fcw29 = new FunnelCalculatorWrapper();
            
            fcw29.FunnelDescription = '# of Monthly Opportunities  Added to Achieve Quota';
            fcw29.PriorYearResult = convertsub(Prior_Monthly_Opp_Added ,'');
            fcw29.SalesRepGoal= 0;
            fcw29.TeamResult= convertsub(TeamResult_Monthly_Opp_Added,'');
            fcw29.Result=  convertsub(Result_Monthly_Opp_Added,'');
            fcw29.Gap_result_SalesRepGoal = (fcw29.Result-fcw29.SalesRepGoal) ;
            fcw29.Gap_result_TeamResult = (fcw29.Result-fcw29.TeamResult) ;
            fcw29.Gap_result_PriorYearResult = (fcw29.Result-fcw29.PriorYearResult) ;
            
            fcw29.PriorYearResultString = convert(fcw29.PriorYearResult,'');
            fcw29.SalesRepGoalstring = convert(fcw29.SalesRepGoal,'');
            fcw29.TeamResultstring = convert(fcw29.TeamResult,'');
            fcw29.Resultstring  = convert(fcw29.Result,'');
            fcw29.Gap_result_SalesRepGoalstring  = convert(fcw29.Gap_result_SalesRepGoal,'');
            fcw29.Gap_result_TeamResultstring  = convert(fcw29.Gap_result_TeamResult,'');
            fcw29.Gap_result_PriorYearResultString = convert(fcw29.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw29);
            
            fcw30 = new FunnelCalculatorWrapper();
            
            fcw30.FunnelDescription = '# of Quaterly Opportunities  Added to Achieve Quota';
            fcw30.PriorYearResult = convertsub(Prior_Quaterly_Opp_Added ,'');
            fcw30.SalesRepGoal= 0;
            fcw30.TeamResult= convertsub(TeamResult_Quaterly_Opp_Added,'');
            fcw30.Result=  convertsub(Result_Quaterly_Opp_Added,'');
            fcw30.Gap_result_SalesRepGoal = (fcw30.Result-fcw30.SalesRepGoal) ;
            fcw30.Gap_result_TeamResult = (fcw30.Result-fcw30.TeamResult) ;
            fcw30.Gap_result_PriorYearResult = (fcw30.Result-fcw30.PriorYearResult) ;
            
            fcw30.PriorYearResultString = convert(fcw30.PriorYearResult,'');
            fcw30.SalesRepGoalstring = convert(fcw30.SalesRepGoal,'');
            fcw30.TeamResultstring = convert(fcw30.TeamResult,'');
            fcw30.Resultstring  = convert(fcw30.Result,'');
            fcw30.Gap_result_SalesRepGoalstring  = convert(fcw30.Gap_result_SalesRepGoal,'');
            fcw30.Gap_result_TeamResultstring  = convert(fcw30.Gap_result_TeamResult,'');
            fcw30.Gap_result_PriorYearResultString = convert(fcw30.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw30);
            
            fcw31 = new FunnelCalculatorWrapper();
            
            fcw31.FunnelDescription = '# of Annual Opportunities  Added to Achieve Quota';
            fcw31.PriorYearResult = convertsub(Prior_Annual_Opp_Added ,'');
            fcw31.SalesRepGoal= 0;
            fcw31.TeamResult= convertsub(TeamResult_Annual_Opp_Added,'');
            fcw31.Result=  convertsub(Result_Annual_Opp_Added,'');
            fcw31.Gap_result_SalesRepGoal = (fcw31.Result-fcw31.SalesRepGoal) ;
            fcw31.Gap_result_TeamResult = (fcw31.Result-fcw31.TeamResult) ;
            fcw31.Gap_result_PriorYearResult = (fcw31.Result-fcw31.PriorYearResult) ;
            
            fcw31.PriorYearResultString = convert(fcw31.PriorYearResult,'');
            fcw31.SalesRepGoalstring = convert(fcw31.SalesRepGoal,'');
            fcw31.TeamResultstring = convert(fcw31.TeamResult,'');
            fcw31.Resultstring  = convert(fcw31.Result,'');
            fcw31.Gap_result_SalesRepGoalstring  = convert(fcw31.Gap_result_SalesRepGoal,'');
            fcw31.Gap_result_TeamResultstring  = convert(fcw31.Gap_result_TeamResult,'');
            fcw31.Gap_result_PriorYearResultString = convert(fcw31.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw31);
            
            
            fcw32 = new FunnelCalculatorWrapper();
            
            fcw32.FunnelDescription = '# of Monthly Lead Added to Achieve Quota';
            fcw32.PriorYearResult = convertsub(Prior_Monthly_Lead_Added,'') ;
            fcw32.SalesRepGoal= 0;
            fcw32.TeamResult= convertsub(TeamResult_Monthly_Lead_Added,'');
            fcw32.Result=  convertsub(Result_Monthly_Lead_Added,'');
            fcw32.Gap_result_SalesRepGoal = (fcw32.Result-fcw32.SalesRepGoal) ;
            fcw32.Gap_result_TeamResult = (fcw32.Result-fcw32.TeamResult) ;
            fcw32.Gap_result_PriorYearResult = (fcw32.Result-fcw32.PriorYearResult) ;
            
            fcw32.PriorYearResultString = convert(fcw32.PriorYearResult,'');
            fcw32.SalesRepGoalstring = convert(fcw32.SalesRepGoal,'');
            fcw32.TeamResultstring = convert(fcw32.TeamResult,'');
            fcw32.Resultstring  = convert(fcw32.Result,'');
            fcw32.Gap_result_SalesRepGoalstring  = convert(fcw32.Gap_result_SalesRepGoal,'');
            fcw32.Gap_result_TeamResultstring  = convert(fcw32.Gap_result_TeamResult,'');
            fcw32.Gap_result_PriorYearResultString = convert(fcw32.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw32);
            
            fcw33 = new FunnelCalculatorWrapper();
            
            fcw33.FunnelDescription = '# of Quaterly Lead Added to Achieve Quota';
            fcw33.PriorYearResult = convertsub(Prior_Quaterly_Lead_Added,'') ;
            fcw33.SalesRepGoal= 0;
            fcw33.TeamResult= convertsub(TeamResult_Quaterly_Lead_Added,'');
            fcw33.Result=  convertsub(Result_Quaterly_Lead_Added,'');
            fcw33.Gap_result_SalesRepGoal = (fcw33.Result-fcw33.SalesRepGoal) ;
            fcw33.Gap_result_TeamResult = (fcw33.Result-fcw33.TeamResult) ;
            fcw33.Gap_result_PriorYearResult = (fcw33.Result-fcw33.PriorYearResult) ;
            
            fcw33.PriorYearResultString = convert(fcw33.PriorYearResult,'');
            fcw33.SalesRepGoalstring = convert(fcw33.SalesRepGoal,'');
            fcw33.TeamResultstring = convert(fcw33.TeamResult,'');
            fcw33.Resultstring  = convert(fcw33.Result,'');
            fcw33.Gap_result_SalesRepGoalstring  = convert(fcw33.Gap_result_SalesRepGoal,'');
            fcw33.Gap_result_TeamResultstring  = convert(fcw33.Gap_result_TeamResult,'');
            fcw33.Gap_result_PriorYearResultString = convert(fcw33.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw33);
            
            fcw34 = new FunnelCalculatorWrapper();
            
            fcw34.FunnelDescription = '# of Annual Lead Added to Achieve Quota';
            fcw34.PriorYearResult = convertsub(Prior_Annual_Lead_Added,'') ;
            fcw34.SalesRepGoal= 0;
            fcw34.TeamResult= convertsub(TeamResult_Annual_Lead_Added,'');
            fcw34.Result=  convertsub(Result_Annual_Lead_Added,'');
            fcw34.Gap_result_SalesRepGoal = (fcw34.Result-fcw34.SalesRepGoal) ;
            fcw34.Gap_result_TeamResult = (fcw34.Result-fcw34.TeamResult) ;
            fcw34.Gap_result_PriorYearResult = (fcw34.Result-fcw34.PriorYearResult) ;
            
            fcw34.PriorYearResultString = convert(fcw34.PriorYearResult,'');
            fcw34.SalesRepGoalstring = convert(fcw34.SalesRepGoal,'');
            fcw34.TeamResultstring = convert(fcw34.TeamResult,'');
            fcw34.Resultstring  = convert(fcw34.Result,'');
            fcw34.Gap_result_SalesRepGoalstring  = convert(fcw34.Gap_result_SalesRepGoal,'');
            fcw34.Gap_result_TeamResultstring  = convert(fcw34.Gap_result_TeamResult,'');
            fcw34.Gap_result_PriorYearResultString = convert(fcw34.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw34);
            
            fcw35 = new FunnelCalculatorWrapper();
            
            fcw35.FunnelDescription = '# of Annual Lead Added to Achieve Quota';
            fcw35.PriorYearResult = convertsub(Prior_X12_Month_Lead_Added_to_the_funnelc,'') ;
            fcw35.SalesRepGoal= 0;
            fcw35.TeamResult= convertsub(TeamResult_X12_Month_Lead_Added_to_the_funnelc,'');
            fcw35.Result=  convertsub(Result_X12_Month_Lead_Added_to_the_funnelc,'');
            fcw35.Gap_result_SalesRepGoal = (fcw35.Result-fcw35.SalesRepGoal) ;
            fcw35.Gap_result_TeamResult = (fcw35.Result-fcw35.TeamResult) ;
            fcw35.Gap_result_PriorYearResult = (fcw35.Result-fcw35.PriorYearResult) ;
            
            fcw35.PriorYearResultString = convert(fcw35.PriorYearResult,'');
            fcw35.SalesRepGoalstring = convert(fcw35.SalesRepGoal,'');
            fcw35.TeamResultstring = convert(fcw35.TeamResult,'');
            fcw35.Resultstring  = convert(fcw35.Result,'');
            fcw35.Gap_result_SalesRepGoalstring  = convert(fcw35.Gap_result_SalesRepGoal,'');
            fcw35.Gap_result_TeamResultstring  = convert(fcw35.Gap_result_TeamResult,'');
            fcw35.Gap_result_PriorYearResultString = convert(fcw35.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw35);
            
            fcw36 = new FunnelCalculatorWrapper();
            
            fcw36.FunnelDescription = 'Lead to Win Conversion Rate';
            if(fcw14.PriorYearResult != 0){
                fcw36.PriorYearResult =  (100/fcw14.PriorYearResult ) ;
            }else{
                fcw36.PriorYearResult = 0 ;
            }
            
            if(fcw14.SalesRepGoal != 0){
                fcw36.SalesRepGoal=  (100/fcw14.SalesRepGoal ) ;
            }else{
                fcw36.SalesRepGoal= 0 ;
            }
            
            if(fcw14.TeamResult != 0){
                fcw36.TeamResult=  (100/fcw14.TeamResult ) ;
            }else{
                fcw36.TeamResult= 0 ;
            }
            
            if(fcw14.Result != 0){
                fcw36.Result=   (100/fcw14.Result ) ;
            }else{
                fcw36.Result=  0 ;
            }
            
            
            fcw36.Gap_result_SalesRepGoal = (fcw36.Result-fcw36.SalesRepGoal) ;
            fcw36.Gap_result_TeamResult = (fcw36.Result-fcw36.TeamResult) ;
            fcw36.Gap_result_PriorYearResult = (fcw36.Result-fcw36.PriorYearResult) ;
            
            fcw36.PriorYearResultString = convert(fcw36.PriorYearResult,'%');
            fcw36.SalesRepGoalstring = convert(fcw36.SalesRepGoal,'%');
            fcw36.TeamResultstring = convert(fcw36.TeamResult,'%');
            fcw36.Resultstring  = convert(fcw36.Result,'%');
            fcw36.Gap_result_SalesRepGoalstring  = convert(fcw36.Gap_result_SalesRepGoal,'%');
            fcw36.Gap_result_TeamResultstring  = convert(fcw36.Gap_result_TeamResult,'%');
            fcw36.Gap_result_PriorYearResultString = convert(fcw36.Gap_result_PriorYearResult ,'%');
            
            FunnelCalculatorWrapperList.add(fcw36);
            
            
            
            fcw37 = new FunnelCalculatorWrapper();
            
            fcw37.FunnelDescription = 'Opp to generate one win';
            if(fcw23.PriorYearResult != 0){
                fcw37.PriorYearResult = convertsub(100/fcw23.PriorYearResult,'') ;
            }else{
                fcw37.PriorYearResult = 0 ;
            }
            
            if(fcw23.SalesRepGoal != 0){
                fcw37.SalesRepGoal=  convertsub(100/fcw23.SalesRepGoal,'') ;
            }else{
                fcw37.SalesRepGoal= 0 ;
            }
            
            if(fcw23.TeamResult != 0){
                fcw37.TeamResult=  convertsub(100/fcw23.TeamResult,'') ;
            }else{
                fcw37.TeamResult= 0 ;
            }
            
            if(fcw23.Result != 0){
                fcw37.Result=   convertsub(100/fcw23.Result,'') ;
            }else{
                fcw37.Result=  0 ;
            }
            
            
            fcw37.Gap_result_SalesRepGoal = (fcw37.Result-fcw37.SalesRepGoal) ;
            fcw37.Gap_result_TeamResult = (fcw37.Result-fcw37.TeamResult) ;
            fcw37.Gap_result_PriorYearResult = (fcw37.Result-fcw37.PriorYearResult) ;
            
            fcw37.PriorYearResultString =  convert(fcw37.PriorYearResult,'');
            fcw37.SalesRepGoalstring =  convert(fcw37.SalesRepGoal,'');
            fcw37.TeamResultstring = convert(fcw37.TeamResult,'');
            fcw37.Resultstring  = convert(fcw37.Result,'');
            fcw37.Gap_result_SalesRepGoalstring  = convert(fcw37.Gap_result_SalesRepGoal,'');
            fcw37.Gap_result_TeamResultstring  = convert(fcw37.Gap_result_TeamResult,'');
            fcw37.Gap_result_PriorYearResultString = convert(fcw37.Gap_result_PriorYearResult ,'');
            
            FunnelCalculatorWrapperList.add(fcw37);
            
            fcw38 = new FunnelCalculatorWrapper();
            
            fcw38.FunnelDescription = '12 month Dollar close rate';
            fcw38.PriorYearResult = convertsub(Prior_X12_Month_Rolling_revenueCloseRate,'%') ;
            fcw38.SalesRepGoal= Goal_Result_X12_Month_Rolling_revenueCloseRate;
            fcw38.Result=  convertsub(Result_X12_Month_Rolling_revenueCloseRate,'%');
            fcw38.Gap_result_SalesRepGoal = (fcw38.Result-fcw38.SalesRepGoal) ;
            fcw38.Gap_result_PriorYearResult = (fcw38.Result-fcw38.PriorYearResult) ;
            
            fcw38.PriorYearResultString = convert(fcw38.PriorYearResult,'%');
            fcw38.SalesRepGoalstring = convert(fcw38.SalesRepGoal,'%');
            fcw38.Resultstring  = convert(fcw38.Result,'%');
            fcw38.Gap_result_SalesRepGoalstring  = convert(fcw38.Gap_result_SalesRepGoal,'%');
            fcw38.Gap_result_PriorYearResultString = convert(fcw38.Gap_result_PriorYearResult ,'%');
            
            FunnelCalculatorWrapperList.add(fcw38);
            
            
            leadToAchieveAnnualQuota =convert((fcw14.Result*fcw24.Result),'');
            if(fcw23.Result != 0){
                qualifiedOpptoOneWin =convert((100/fcw23.Result),'');
            }else{
                qualifiedOpptoOneWin = '0';
            }
             
            if(fcw23.Result != 0 && fcw12.Result != 0 ){
                LeadstoGenerateOneWinString=convert(10000/(fcw23.Result*fcw12.Result),'');   
            }else{
                LeadstoGenerateOneWinString = '0';
            }
           // system.debug('FunnelCalculatorWrapperList'+FunnelCalculatorWrapperList);
           }
            return FunnelCalculatorWrapperList ;
        }
        
        //This method will Roundup the big number and will add bracket , $ and %
        
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
        
        public void switchtab(){
        
            if(selectol == 'Leads'){
                opptab = false;
                leadtab = true;
            }else{
                opptab= true;
                leadtab = false;
            }
            
        }
    
        /*Filters*/
        //Method called when reset button is selected
        public PageReference reset(){
            
            /*        
            isReset = true;
            
            fw.userId = UserInfo.getUserId();  
            
            FunnelFilterHelper.reset(fw);
            */
            
                return FunnelNavigationHelper.navigateToCalculator('','','','','',''); 
            
        }
        /*Filters*/ 
        
        public void showUpdated(){
            try{
            RoleOverlay = false; 
            RepOverlay =false;
            
            isReset = false;
            cal = false;
            resultcolor = false;
            asp =false;
            cr = false;
            lcr = false;
            resultstring ='Actual ';
            curentPipeline =  '';
            ytdWin ='' ;
            winNeedToMakeQuota ='';
            activeopp = '';
            
            metricRowMap = new Map<String, tableWrapper>(); 
            metricRowMapQual = new Map<String, tableWrapper>();      
              
              
                if(readAccess){
                    //Aggregates of a particular level value need to be done
                    if(fw.selectedLevelThree == 'All' ){
                        //Fetch the sales profile record associated with that level
                        List<Company_Level__c> cl = [SELECT Sales_Rep_Profile__c FROM Company_Level__c WHERE Level_Value__c = : fw.selectedLevelOne LIMIT 1];
                        
                        displayWrapper = new FunnelSalesProfileWrapper();
                        data(cl[0].Sales_Rep_Profile__c,'');
                        mgr = true;
                    }
                    //A particular rep has been selected and his values need to be displayed
                    else if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All'){
                        //list<Sales_Rep_Profile__c> names = querySalesProfileAndPopulateWrapper(fw.selectedLevelTwo,null);   
                        List<Company_Level__c> cl = [SELECT Sales_Rep_Profile__c FROM Company_Level__c WHERE Level_Value__c = : fw.selectedLevelOne LIMIT 1];
                        data(cl[0].Sales_Rep_Profile__c,fw.selectedLevelTwo);
                        mgr = false; 
                        
                        
                        displayWrapper = new FunnelSalesProfileWrapper();
                        fetchPerfScores();
                        fetchPerformerSet('rep',fw.selectedLevelTwo); 
                        Sales_rep_profile__c sr = [SELECT id, name,Role__c,Profile_Type__c FROM Sales_rep_profile__c WHERE id = :fw.selectedLevelTwo];
                        if(sr.Profile_Type__c != null && sr.Profile_Type__c == 'Overlay'){
                     
                                RepOverlay =true;
                            }
                        if(sr.Role__c != null){
                        
                            
                            roleVal = sr.Role__c;
                            sname =sr.name;
                            displayWrapper.Name = sr.name;
                            displayWrapper.Role= sr.Role__c;
                            
                            Set<Id> aggregateIds = new Set<Id>();
                            aggregateIds.add(sr.id);
                            if(aggregateIds != null && aggregateIds.size() >0  )
                                displayWrapper.score = FunnelCalculationHelper.findAggregateScore(aggregateIds);
                             
                             
                            fetchImpMetrics();  
                             
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
                       
                        fetchPerfScores();
                        fetchPerformerSet('role',fw.selectedLevelThree);
                        sname = fw.SelectedLevelOne;
                        fetchImpMetrics();  
                         
                    }
                }
            }
            catch(Exception ex){
                System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
                FunnelTriggerBatchHelper.sendErrorMail(' FunnelCalculator '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            } 
        }
        
        
        private void aggregateOnRole(){
        if(readAccess){
        Boolean isOverlay = true;
        String Mngid;
        String Spid;
         
        Result_Annual_Quota_Amountc = 0;
        Result_YTD_Revenuec = 0;
        Result_X12_Month_Rolling_Average_Sales_Cyclec = 0;
        Result_X12_Month_Average_Selling_Pricec = 0;
        Result_X12_Month_Rolling_Win_Percentagec = 0;
        Result_X12_Month_Rolling_revenueCloseRate = 0;
        Result_X12_Month_Opprties_Added_to_the_funnelc = 0;
        Result_X12_Month_Lead_Added_to_the_funnelc = 0;
        Result_X12_Month_Lead_Conv_for_1_opptyc = 0;
        
        Result_Monthly_Opp_Added =0;
        Result_Quaterly_Opp_Added  = 0;
        Result_Annual_Opp_Added  = 0;
        Result_Monthly_Lead_Added =0;
        Result_Quaterly_Lead_Added  = 0;
        Result_Annual_Lead_Added  = 0;
        
        Result_Monthly_Revenue = 0;
        Result_Quarterly_Revenue = 0;
        
        Result_Monthly_Quota_Amountc = 0;
        Result_Quarterly_Quota_Amountc = 0;
        
        Goal_Result_X12_Month_Rolling_Average_Sales_Cyclec = 0;
        Goal_Result_X12_Month_Rolling_Win_Percentagec = 0;
        Goal_Result_X12_Month_Rolling_revenueCloseRate = 0;
        Goal_Result_X12_Month_Lead_Conv_for_1_opptyc = 0;
        Goal_Result_X12_Month_Average_Selling_Pricec = 0;
        Goal_Result_YTDQuota = 0;
        
        //Fetch the company level record associated with the particular level
        List<Company_Level__c> cl = [SELECT id,Sales_Rep_Profile__c, Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Sales_Manager__c FROM Company_Level__c WHERE Level_Value__c = :fw.SelectedLevelOne];
        Mngid = cl[0].Sales_Rep_Profile__r.Sales_Manager__c;
        Spid = cl[0].Sales_Rep_Profile__c;
        
        
        //Fetch the records at the selected level and role
        List<Sales_Profile_Company_Level_Junction__c> sReps = [SELECT Sales_Rep_Profile__c,Sales_Rep_Profile__r.Profile_Type__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree];                
        
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
        
        displayWrapper.score = FunnelCalculationHelper.findAggregateScore(profIds);
        //Fetch the company levels associated with the sales profiles
        cl = [SELECT id, Level_Value__c FROM Company_Level__c WHERE Sales_Rep_Profile__c IN :profIds];
        
        levels.clear();
        
        //Store all the levels associated with the managers
        for(Company_Level__c c: cl){
            levels.add(c.Level_Value__c);
        }
        
        //Fetch the sales profiles associated with the levels
        sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Role__c,Sales_Rep_Profile__r.Profile_Type__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels];
        
        system.debug(' aggregateIds '+aggregateIds);        
        //Add the sales profiles to the ids to be aggregated 
        Set<Id> srpid = new Set<Id>();
        for(Sales_Profile_Company_Level_Junction__c s: sReps){
            aggregateIds.add(s.Sales_Rep_Profile__c);
            if(s.Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' ){
                    isOverlay = false;
                  }
        }
        srpid.addAll(aggregateIds);
         RoleOverlay = isOverlay ;   
        //Aggregate the results
        List<AggregateResult> ar = new List<AggregateResult> ();
            if(RoleOverlay ){
                ar = [Select AVG(YTD_Quota__c) yq,AVG(YTD_Revenue__c) y, AVG(Annual_Quota_Amount__c) a,AVG(Monthly_quota__c) aam,AVG(Quarterly_Quota__c) aaq, AVG(X12_Month_Average_Selling_Price__c) sp,  
                                AVG(X12_Month_Lead_Conv_for_1_oppty__c) lc, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Rolling_Opportunity_Close_Rate__c) wp,
                                AVG(X12_Month_QO_added__c) opaf, AVG(X12_Month_Leads_Added__c) laf,
                                AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,AVG(Monthly_Quota_Revenue__c) mr, AVG(Quarterly_Quota_Revenue__c) qr,
                                AVG(Monthly_QO_added__c) moa, AVG(Quarterly_QO_added__c)qoa, AVG(Ytd_QO_added__c) yoa, AVG(Monthly_Lead_Added__c) mla, AVG(Quarterly_Lead_Added__c) qla,AVG(YTD_Leads_Added__c) yla,
                                AVG(Current_Active_Opportunities__c) ca, AVG(Current_Pipeline__c) cp, AVG(YTD_Opportunities_won__c) yw ,AVG(Goal_12m_rolling_amt_close_rate__c) gacr , AVG(X12_Month_Rolling_Close_Rate__c) acr
                                from Sales_Rep_Profile__c where id IN :aggregateIds  AND  Annual_Quota_Amount__c > 0 AND Profile_Type__c = 'Overlay'];
            }else{
                ar = [Select AVG(YTD_Quota__c) yq,AVG(YTD_Revenue__c) y, AVG(Annual_Quota_Amount__c) a,AVG(Monthly_quota__c) aam,AVG(Quarterly_Quota__c) aaq, AVG(X12_Month_Average_Selling_Price__c) sp,  
                                AVG(X12_Month_Lead_Conv_for_1_oppty__c) lc, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Rolling_Opportunity_Close_Rate__c) wp,
                                AVG(X12_Month_QO_added__c) opaf, AVG(X12_Month_Leads_Added__c) laf,
                                AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,AVG(Monthly_Quota_Revenue__c) mr, AVG(Quarterly_Quota_Revenue__c) qr,
                                AVG(Monthly_QO_added__c) moa, AVG(Quarterly_QO_added__c)qoa, AVG(Ytd_QO_added__c) yoa, AVG(Monthly_Lead_Added__c) mla, AVG(Quarterly_Lead_Added__c) qla,AVG(YTD_Leads_Added__c) yla,
                                AVG(Current_Active_Opportunities__c) ca, AVG(Current_Pipeline__c) cp, AVG(YTD_Opportunities_won__c) yw ,AVG(Goal_12m_rolling_amt_close_rate__c) gacr , AVG(X12_Month_Rolling_Close_Rate__c) acr
                                from Sales_Rep_Profile__c where id IN :aggregateIds  AND  Annual_Quota_Amount__c > 0 AND Profile_Type__c != 'Overlay'];
            }
                           
    
        //Populate the wrapper
        if(ar != null && ar.size() > 0){                            
            
            if(ar[0].get('y') != null)
                Result_YTD_Revenuec = (Decimal)(ar[0].get('y'));
                
            if(ar[0].get('yq') != null)
                Goal_Result_YTDQuota = (Decimal)(ar[0].get('yq'));
            
            if(ar[0].get('a') != null)
                Result_Annual_Quota_Amountc = (Decimal)(ar[0].get('a'));
                
            if(ar[0].get('aam') != null)
                Result_Monthly_Quota_Amountc = (Decimal)(ar[0].get('aam'));
                
            if(ar[0].get('aaq') != null)
                Result_Quarterly_Quota_Amountc = (Decimal)(ar[0].get('aaq'));
            
            if(ar[0].get('sp') != null)    
                Result_X12_Month_Average_Selling_Pricec = (Decimal)(ar[0].get('sp'));
            
            if(ar[0].get('lc') != null)                
                Result_X12_Month_Lead_Conv_for_1_opptyc  = (Decimal)(ar[0].get('lc'));

            if(ar[0].get('sc') != null)
                Result_X12_Month_Rolling_Average_Sales_Cyclec = (Decimal)(ar[0].get('sc'));

            
            if(ar[0].get('wp') != null)                
                Result_X12_Month_Rolling_Win_Percentagec = (Decimal)(ar[0].get('wp'));
             
            if(ar[0].get('acr') != null)                
                Result_X12_Month_Rolling_revenueCloseRate = (Decimal)(ar[0].get('acr'));
                         
            if(ar[0].get('opaf') != null)
                Result_X12_Month_Opprties_Added_to_the_funnelc = (Decimal)(ar[0].get('opaf'));

            if(ar[0].get('laf') != null)
                Result_X12_Month_Lead_Added_to_the_funnelc  = (Decimal)(ar[0].get('laf'));

            if(ar[0].get('spg') != null)
                Goal_Result_X12_Month_Average_Selling_Pricec = (Decimal)(ar[0].get('spg'));
                
            if(ar[0].get('lcg') != null)
                Goal_Result_X12_Month_Lead_Conv_for_1_opptyc = (Decimal)(ar[0].get('lcg'));

            if(ar[0].get('scg') != null)
                Goal_Result_X12_Month_Rolling_Average_Sales_Cyclec =  (Decimal)(ar[0].get('scg'));
            
            if(ar[0].get('wpg') != null)
                Goal_Result_X12_Month_Rolling_Win_Percentagec =  (Decimal)(ar[0].get('wpg'));
            
            if(ar[0].get('gacr') != null)
                Goal_Result_X12_Month_Rolling_revenueCloseRate =  (Decimal)(ar[0].get('gacr'));
                
            if(ar[0].get('moa') != null) 
                Result_Monthly_Opp_Added = (Decimal)(ar[0].get('moa'));
             
            if(ar[0].get('mla') != null) 
                Result_Monthly_Lead_Added = (Decimal)(ar[0].get('mla'));
             
            if(ar[0].get('mr') != null) 
                Result_Monthly_Revenue=  (Decimal)(ar[0].get('mr'));
                
            if(ar[0].get('qoa') != null) 
                Result_Quaterly_Opp_Added = (Decimal)(ar[0].get('qoa'));
             
            if(ar[0].get('qla') != null) 
                Result_Quaterly_Lead_Added = (Decimal)(ar[0].get('qla'));
             
            if(ar[0].get('qr') != null) 
                Result_Quarterly_Revenue= (Decimal)(ar[0].get('qr'));
              
            if(ar[0].get('yoa') != null) 
                Result_Annual_Opp_Added = (Decimal)(ar[0].get('yoa'));
             
            if(ar[0].get('yla') != null) 
                Result_Annual_Lead_Added = (Decimal)(ar[0].get('yla'));
             
            //Score card
            
            if(ar[0].get('cp') != null) 
                curentPipeline  = convert(convertsub( (Decimal)ar[0].get('cp'),''),'$');
            
            if(ar[0].get('ca') != null) 
                activeopp  = convert(convertsub( (Decimal)ar[0].get('ca'),''),'');
            
            if(ar[0].get('yw') != null) 
                ytdWin  = convert(convertsub( (Decimal)ar[0].get('yw'),''),'');
            
            if(ar[0].get('sp') != null && (Decimal)ar[0].get('sp') > 0 && ar[0].get('y') != null  && ar[0].get('a') != null){
                Decimal win = ((Decimal)ar[0].get('a') - (Decimal)ar[0].get('y'))/(Decimal)ar[0].get('sp');
                winNeedToMakeQuota = convert(convertsub( win,''),'');
                 
            }
        }    
                 
                TeamResult_Annual_Quota_Amountc =0;
                TeamResult_YTD_Revenuec =0;
                TeamResult_X12_Month_Rolling_Average_Sales_Cyclec =0;
                TeamResult_X12_Month_Average_Selling_Pricec =0;
                TeamResult_X12_Month_Rolling_Win_Percentagec =0;
                TeamResult_X12_Month_Opprties_Added_to_the_funnelc =0;
                TeamResult_X12_Month_Lead_Added_to_the_funnelc =0;
                TeamResult_X12_Month_Lead_Conv_for_1_opptyc =0;
                
                TeamResult_Monthly_Revenue = 0;
                TeamResult_Quarterly_Revenue = 0;
                
                TeamResult_Monthly_Quota_Amountc = 0;
                TeamResult_Quarterly_Quota_Amountc = 0;
                
                TeamResult_Monthly_Opp_Added =0;
                TeamResult_Quaterly_Opp_Added =0;
                TeamResult_Annual_Opp_Added =0;
                TeamResult_Monthly_Lead_Added =0;
                TeamResult_Quaterly_Lead_Added =0;
                TeamResult_Annual_Lead_Added =0;
                
                if(Mngid != null){
                    List<Sales_Rep_Profile__c> srps = [select id from Sales_Rep_Profile__c where Sales_Manager__c = :Mngid AND id != :Spid];
                    levels = new Set<String>();
                    Set<Id> spids = new set<Id>();
                    spids = (new map<id,Sales_Rep_Profile__c>(srps)).keyset();
                    
                    List<Company_Level__c> c2 = [SELECT id, Level_Value__c FROM Company_Level__c WHERE Sales_Rep_Profile__c IN :spids];
                    
                    for(Company_Level__c c: c2){
                        levels.add(c.Level_Value__c);
                    }
                    List<Sales_Profile_Company_Level_Junction__c> sReps2 = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree ];  
                    
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
           ar2 = [Select AVG(YTD_Revenue__c) y, AVG(Annual_Quota_Amount__c) a,AVG(Monthly_quota__c) aam,AVG(Quarterly_Quota__c) aaq, AVG(X12_Month_Average_Selling_Price__c) sp,  
                AVG(X12_Month_Lead_Conv_for_1_oppty__c) lc, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Rolling_Opportunity_Close_Rate__c) wp,
                AVG(X12_Month_QO_added__c) opaf, AVG(X12_Month_Leads_Added__c) laf,
                AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,AVG(Monthly_Quota_Revenue__c) mr, AVG(Quarterly_Quota_Revenue__c) qr,
                AVG(Monthly_QO_added__c) moa, AVG(Quarterly_QO_added__c)qoa, AVG(Ytd_QO_added__c) yoa, AVG(Monthly_Lead_Added__c) mla, AVG(Quarterly_Lead_Added__c) qla,AVG(YTD_Leads_Added__c) yla
                from Sales_Rep_Profile__c where id IN :aggregateIds AND  Annual_Quota_Amount__c > 0 AND Profile_Type__c = 'Overlay'];
       }else{
           ar2 = [Select AVG(YTD_Revenue__c) y, AVG(Annual_Quota_Amount__c) a,AVG(Monthly_quota__c) aam,AVG(Quarterly_Quota__c) aaq, AVG(X12_Month_Average_Selling_Price__c) sp,  
                AVG(X12_Month_Lead_Conv_for_1_oppty__c) lc, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Rolling_Opportunity_Close_Rate__c) wp,
                AVG(X12_Month_QO_added__c) opaf, AVG(X12_Month_Leads_Added__c) laf,
                AVG(Goal_12m_Avg_Selling_Price__c) spg, AVG(Goal_12m_Lead_To_Opp_Conv_Rate__c) lcg, AVG(Goal_12m_length_of_sales_cycle__c) scg, AVG(Goal_12m_rolling_close_rate__c ) wpg,AVG(Monthly_Quota_Revenue__c) mr, AVG(Quarterly_Quota_Revenue__c) qr,
                AVG(Monthly_QO_added__c) moa, AVG(Quarterly_QO_added__c)qoa, AVG(Ytd_QO_added__c) yoa, AVG(Monthly_Lead_Added__c) mla, AVG(Quarterly_Lead_Added__c) qla,AVG(YTD_Leads_Added__c) yla
                from Sales_Rep_Profile__c where id IN :aggregateIds AND  Annual_Quota_Amount__c > 0 AND Profile_Type__c != 'Overlay'];
       }
                                
        
        
        if(ar2 != null && ar2.size() > 0){                            
            
            if(ar2[0].get('y') != null)
                TeamResult_YTD_Revenuec = (Decimal)(ar2[0].get('y'));
            
            if(ar2[0].get('a') != null)
                TeamResult_Annual_Quota_Amountc = (Decimal)(ar2[0].get('a'));
                
            if(ar2[0].get('aam') != null)
                TeamResult_Monthly_Quota_Amountc= (Decimal)(ar2[0].get('aam'));
                
            if(ar2[0].get('aaq') != null)
                TeamResult_Quarterly_Quota_Amountc = (Decimal)(ar2[0].get('aaq'));
            
            if(ar2[0].get('sp') != null)    
                TeamResult_X12_Month_Average_Selling_Pricec = (Decimal)(ar2[0].get('sp'));
            
            if(ar2[0].get('lc') != null)                
                TeamResult_X12_Month_Lead_Conv_for_1_opptyc  = (Decimal)(ar2[0].get('lc'));

            if(ar2[0].get('sc') != null)
                TeamResult_X12_Month_Rolling_Average_Sales_Cyclec = (Decimal)(ar2[0].get('sc'));

            if(ar2[0].get('wp') != null)                
                TeamResult_X12_Month_Rolling_Win_Percentagec = (Decimal)(ar2[0].get('wp'));
                
            if(ar2[0].get('opaf') != null)
                TeamResult_X12_Month_Opprties_Added_to_the_funnelc = (Decimal)(ar2[0].get('opaf'));

            if(ar2[0].get('laf') != null)
                TeamResult_X12_Month_Lead_Added_to_the_funnelc  = (Decimal)(ar2[0].get('laf'));

            /*if(ar2[0].get('spg') != null)
                Goal_Result_X12_Month_Average_Selling_Pricec = (Decimal)(ar2[0].get('spg'));
                
            if(ar2[0].get('lcg') != null)
                Goal_Result_X12_Month_Lead_Conv_for_1_opptyc = (Decimal)(ar2[0].get('lcg'));

            if(ar2[0].get('scg') != null)
                Goal_Result_X12_Month_Rolling_Average_Sales_Cyclec =  (Decimal)(ar2[0].get('scg'));
            
            if(ar2[0].get('wpg') != null)
                Goal_Result_X12_Month_Rolling_Win_Percentagec =  (Decimal)(ar2[0].get('wpg')); */
              
            
            if(ar2[0].get('moa') != null) 
                TeamResult_Monthly_Opp_Added = (Decimal)(ar2[0].get('moa'));
             
            if(ar2[0].get('mla') != null) 
                TeamResult_Monthly_Lead_Added = (Decimal)(ar2[0].get('mla'));
             
            if(ar2[0].get('mr') != null) 
                TeamResult_Monthly_Revenue = (Decimal)(ar2[0].get('mr'));
             
            if(ar2[0].get('qoa') != null) 
                TeamResult_Quaterly_Opp_Added = (Decimal)(ar2[0].get('qoa'));
            
            if(ar2[0].get('qla') != null) 
                TeamResult_Quaterly_Lead_Added = (Decimal)(ar2[0].get('qla'));
            
            if(ar2[0].get('qr') != null) 
                TeamResult_Quarterly_Revenue= (Decimal)(ar2[0].get('qr'));
            
            if(ar2[0].get('yoa') != null) 
                TeamResult_Annual_Opp_Added = (Decimal)(ar2[0].get('yoa'));
            
            if(ar2[0].get('yla') != null) 
                TeamResult_Annual_Lead_Added = (Decimal)(ar2[0].get('yla'));
              
                    }    

        
                }
                
                
                
                Prior_Annual_Quota_Amountc =0;                          
                Prior_YTD_Revenuec =0;
                Prior_X12_Month_Rolling_Average_Sales_Cyclec =0;
                Prior_X12_Month_Average_Selling_Pricec =0;
                Prior_X12_Month_Rolling_Win_Percentagec =0;
                Prior_X12_Month_Rolling_revenueCloseRate =0;
                Prior_X12_Month_Opprties_Added_to_the_funnelc =0;
                Prior_X12_Month_Lead_Added_to_the_funnelc =0;
                Prior_X12_Month_Lead_Conv_for_1_opptyc =0;
                Prior_Monthly_Opp_Added =0;
                Prior_Quaterly_Opp_Added =0;
                Prior_Annual_Opp_Added =0;
                Prior_Monthly_Lead_Added =0;
                Prior_Quaterly_Lead_Added =0;
                Prior_Annual_Lead_Added =0;
                Prior_Monthly_Revenue  = 0;
                Prior_Quarterly_Revenue  = 0;
                
                Prior_Monthly_Quota_Amountc = 0;
                Prior_Quarterly_Quota_Amountc = 0;
                
                
                List<Company_Level_Junction_snapshot__c> psReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Company_Level_Junction_snapshot__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree AND Snapshot_Scheduled_Date__c = :scheduleDate];                
        
         Set<String> plevels = new Set<String>();
        
        //List to store the ids of the reps to be aggregated
        Set<ID> paggregateIds = new Set<Id>();
        
        Set<ID> pprofIds = new Set<Id>();
        
        //Store the profile ids of the managers
        for(Company_Level_Junction_snapshot__c s: psReps){
            pprofIds.add(s.Sales_Rep_Profile__c);
            paggregateIds.add(s.Sales_Rep_Profile__c);
        }
        
        //Fetch the company levels associated with the sales profiles
        List<Company_Levels_snapshot__c> pcl  = [SELECT id, Level_Value__c FROM Company_Levels_snapshot__c WHERE Sales_Rep_Profile__c IN :pprofIds AND Snapshot_Scheduled_Date__c = :scheduleDate];
        
        plevels.clear();
        
        //Store all the levels associated with the managers
        for(Company_Levels_snapshot__c c: pcl){
            plevels.add(c.Level_Value__c);
        }
        
        //Fetch the sales profiles associated with the levels
        psReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Company_Level_Junction_snapshot__c  WHERE Company_Level__r.Level_Value__c IN :plevels AND Snapshot_Scheduled_Date__c = :scheduleDate];
        
        system.debug(' aggregateIds '+paggregateIds);        
        //Add the sales profiles to the ids to be aggregated 
        Set<Id> psrpid = new Set<Id>();
        for(Company_Level_Junction_snapshot__c s: psReps){
            paggregateIds.add(s.Sales_Rep_Profile__c);
        }
        psrpid.addAll(paggregateIds);
           List<AggregateResult> ar3 = new  List<AggregateResult>(); 
           if(RoleOverlay){
                ar3 = [Select AVG(YTD_Revenue__c) y, AVG(Annual_Quota_Amount__c) a,AVG(Monthly_quota__c) aam,AVG(Quarterly_Quota__c) aaq, AVG(X12_Month_Average_Selling_Price__c) sp,  
                AVG(X12_Month_Lead_Conv_for_1_oppty__c) lc, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Rolling_Opportunity_Close_Rate__c) wp,
                AVG(X12_Month_QO_added__c) opaf, AVG(X12_Month_Leads_Added__c) laf,
                AVG(Monthly_Quota_Revenue__c) mr, AVG(Quarterly_Quota_Revenue__c) qr,
                AVG(Monthly_QO_added_Quantitative__c) moa, AVG(Quarterly_QO_added_Quantitative__c)qoa, AVG(Ytd_QO_added_Quantitative__c) yoa, AVG(Monthly_Lead_Added__c) mla, AVG(Quarterly_Lead_Added__c) qla,AVG(YTD_Leads_Added__c) yla ,AVG(Goal_12m_rolling_amt_close_rate__c) gacr , AVG(X12_Month_Rolling_Close_Rate__c) acr
                from Sales_Rep_Profile_Snapshot__c where Sales_Rep_Profile__c IN :psrpid AND Snapshot_Scheduled_Date__c = :scheduleDate AND Annual_Quota_Amount__c > 0 AND Profile_Type__c = 'Overlay'];
                
           }else{
                ar3 = [Select AVG(YTD_Revenue__c) y, AVG(Annual_Quota_Amount__c) a,AVG(Monthly_quota__c) aam,AVG(Quarterly_Quota__c) aaq, AVG(X12_Month_Average_Selling_Price__c) sp,  
                AVG(X12_Month_Lead_Conv_for_1_oppty__c) lc, AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Rolling_Opportunity_Close_Rate__c) wp,
                AVG(X12_Month_QO_added__c) opaf, AVG(X12_Month_Leads_Added__c) laf,
                AVG(Monthly_Quota_Revenue__c) mr, AVG(Quarterly_Quota_Revenue__c) qr,
                AVG(Monthly_QO_added_Quantitative__c) moa, AVG(Quarterly_QO_added_Quantitative__c)qoa, AVG(Ytd_QO_added_Quantitative__c) yoa, AVG(Monthly_Lead_Added__c) mla, AVG(Quarterly_Lead_Added__c) qla,AVG(YTD_Leads_Added__c) yla ,AVG(Goal_12m_rolling_amt_close_rate__c) gacr , AVG(X12_Month_Rolling_Close_Rate__c) acr
                from Sales_Rep_Profile_Snapshot__c where Sales_Rep_Profile__c IN :psrpid AND Snapshot_Scheduled_Date__c = :scheduleDate AND Annual_Quota_Amount__c > 0 AND Profile_Type__c != 'Overlay'];
                
           }  
                 
                if(ar3 != null && ar3.size() > 0){
                    
                    if(ar3[0].get('moa') != null) 
                        Prior_Monthly_Opp_Added = (Decimal)ar3[0].get('moa');
                       
                    if(ar3[0].get('mla') != null) 
                        Prior_Monthly_Lead_Added = (Decimal)ar3[0].get('mla');
                      
                    if(ar3[0].get('qoa') != null) 
                        Prior_Quaterly_Opp_Added = (Decimal)ar3[0].get('qoa');
                     
                    if(ar3[0].get('qla') != null) 
                        Prior_Quaterly_Lead_Added = (Decimal)ar3[0].get('qla');
                      
                    if(ar3[0].get('yoa') != null) 
                        Prior_Annual_Opp_Added = (Decimal)ar3[0].get('yoa');
                    
                    if(ar3[0].get('yla') != null) 
                        Prior_Annual_Lead_Added = (Decimal)ar3[0].get('yla');
                     
                    if(ar3[0].get('a') != null) 
                        Prior_Annual_Quota_Amountc  =  (Decimal)ar3[0].get('a');
                        
                    if(ar3[0].get('aam') != null) 
                        Prior_Monthly_Quota_Amountc =  (Decimal)ar3[0].get('aam');
                        
                    if(ar3[0].get('aaq') != null) 
                        Prior_Quarterly_Quota_Amountc =  (Decimal)ar3[0].get('aaq');
                     
                    if(ar3[0].get('y') != null) 
                        Prior_YTD_Revenuec =  (Decimal)ar3[0].get('y');
                     
                    if(ar3[0].get('sc') != null) 
                        Prior_X12_Month_Rolling_Average_Sales_Cyclec =  (Decimal)ar3[0].get('sc');
                     
                    if(ar3[0].get('sp') != null) 
                        Prior_X12_Month_Average_Selling_Pricec  =  (Decimal)ar3[0].get('sp');
                     
                    if(ar3[0].get('wp') != null) 
                        Prior_X12_Month_Rolling_Win_Percentagec  =  (Decimal)ar3[0].get('wp');
                    
                    if(ar3[0].get('acr') != null) 
                        Prior_X12_Month_Rolling_revenueCloseRate  =  (Decimal)ar3[0].get('acr');
                     
                    if(ar3[0].get('opaf') != null) 
                        Prior_X12_Month_Opprties_Added_to_the_funnelc =  (Decimal)ar3[0].get('opaf');
                    
                    if(ar3[0].get('lc') != null) 
                        Prior_X12_Month_Lead_Conv_for_1_opptyc =  (Decimal)ar3[0].get('lc');
                     
                    if(ar3[0].get('laf') != null) 
                        Prior_X12_Month_Lead_Added_to_the_funnelc  =  (Decimal)ar3[0].get('laf');
                     
                    if(ar3[0].get('mr') != null) 
                        Prior_Monthly_Revenue  =  (Decimal)ar3[0].get('mr');
                     
                    if(ar3[0].get('qr') != null) 
                        Prior_Quarterly_Revenue =  (Decimal)ar3[0].get('qr');
                        
                    
                     
                    
                }
                FunnelTable();
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
                    FunnelTriggerBatchHelper.sendErrorMail(' FunnelCalculator '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
                }
            } 
        }
        
        //Action method when level two is changed
        public void levelTwoAction(){
            if(readAccess){
                try{
                    FunnelFilterHelper.levelTwoAction(fw);
                }
                catch(Exception ex){
                    System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
                    FunnelTriggerBatchHelper.sendErrorMail(' FunnelCalculator '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
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
            
            //return FunnelNavigationHelper.navigateToAnalytics(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
          	return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
        } 
        
        public PageReference navigateToFunnelAnalyticQualitative(){
          
            //return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
          	return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
        }
    
    public PageReference navigateToFunnelAnalytic(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
      	return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    public PageReference navigateToAnnualizationDashboard(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
    	return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
        /*Navigation*/ 
         public List<SelectOption>  getselectopoption() {
             List<SelectOption> Options = new List<SelectOption>();
             Options.add(new SelectOption('Opportunities','Opportunities'));
             Options.add(new SelectOption('Leads','Leads'));
             return Options;
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
        
        List<Certification__c> certScores = [SELECT id, Overall_Rating__c FROM Certification__c WHERE Sales_Rep_Profile__r.Active__c = TRUE ORDER BY Overall_Rating__c DESC LIMIT 5000  ];
        
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
            profs.add(fw.selectedLevelTwo);
            
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
            
            //Fetch the company levels associated with the sales profiles
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
        
        if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All'){
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
        
            List<AggregateResult> cres = [SELECT MAX(Due_Date__c) d, Certifcation_Rating__r.id cr FROM Certification_Answer__c WHERE Certifcation_Rating__c IN :ratingRecs AND Rating_Score__c != null AND Certifcation_Rating__r.Timing__c = 'End of month' AND Certifcation_Rating__r.Assessment_type__c = 'Quantitative' AND Due_Date__c < today AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
            
            Date monthlyDueDate;
            
            if(cres != null && cres.size() > 0){
                monthlyDueDate = (Date)cres[0].get('d');
            }
            
            if(monthlyDueDate != null){        
                
                fetchScores('end of month',monthlyDueDate);                        
                
            }
            
            cres = [SELECT MAX(Due_Date__c) d, Certifcation_Rating__r.id cr FROM Certification_Answer__c WHERE Certifcation_Rating__c IN :ratingRecs AND Rating_Score__c != null AND Certifcation_Rating__r.Timing__c = 'End of month' AND Certifcation_Rating__r.Assessment_type__c = 'Quantitative' AND Due_Date__c < today AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
            
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
        
        List<AggregateResult> ares = [SELECT AVG(Rating_Score__c) r, Certifcation_Rating__r.id rid FROM Certification_Answer__c WHERE Certifcation_Rating__r.timing__c = :timing AND Certifcation_Rating__r.Assessment_type__c = 'Quantitative' AND Certifcation_Rating__c IN :ratingRecs AND Due_Date__c = :dueDate AND Certifcation__r.Overall_rating__c >= :highPerfScore AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
            
        for(AggregateResult r: ares){
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
        
                        
        
       
        ares = [SELECT AVG(Rating_Score__c) r, Certifcation_Rating__r.id rid FROM Certification_Answer__c WHERE Certifcation_Rating__r.timing__c = :timing AND Certifcation_Rating__r.Assessment_type__c = 'Quantitative' AND Certifcation_Rating__c IN :ratingRecs AND Due_Date__c = :dueDate AND Sales_rep_profile__c IN :profs AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
        
        for(AggregateResult r: ares){
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
}