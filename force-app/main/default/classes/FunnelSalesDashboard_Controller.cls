/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelSalesDashboard_Controller{
    
    Public Map<String,String> managemenetReports{get;set;}
    
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
    
    //Wrapper to store the results
    private FunnelSalesProfileWrapper displayWrapperValue = new FunnelSalesProfileWrapper();
    
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    
    public FunnelSalesProfileWrapper displayWrapper{
        
        get{
            return displayWrapperValue;
        }
        set{
            displayWrapperValue = value;
        }
    }                    
    
    public Boolean RoleOverlay{get;set;}
    public Boolean RepOverlay{get;set;}
    
    Boolean readAccess;
    
    public FunnelSalesDashboard_Controller() {
        
        try{
            
            //Checking if the logged in user has read permissions to the fields in the different objects  
            readAccess = true;
            
            List<String> fldList1 = new List<String>{prefix+'User_Record_name__c',prefix+'YTD_Quota__c',prefix+'YTD_Close_Rate__c',prefix+'YTD_Quota_Percentage__c',prefix+'Tenure_in_current_role__c',prefix+'name',prefix+'Role__c',prefix+'Sales_Manager__c',prefix+'Sales_Rep_Start_Date__c',prefix+'Territory__c',prefix+'YTD_Opportunity_Close_Rate__c',prefix+'YTD_Revenue__c',prefix+'Annual_Quota_Amount__c',prefix+'YTD_Win_Percentage__c',prefix+'Average_Sales_Price__c',prefix+'YTD_Opportunities_won__c',prefix+'Current_Active_Opportunities__c',prefix+'of_annual_qualified_opptys__c',prefix+'of_quarterly_qualified_opptys__c',prefix+'of_monthly_qualified_opptys__c',prefix+'of_wins_to_achieve_annual_quota__c',prefix+'of_wins_to_achieve_quarterly_quota__c',prefix+'of_wins_to_achieve_monthly_quota__c',prefix+'X12_Month_Lead_Conv_for_1_oppty__c',prefix+'of_quarterly_leads_to_achieve_quota__c',prefix+'of_monthly_leads_to_achieve_quota__c',prefix+'of_daily_leads_to_achieve_quota__c',prefix+'of_leads_for_1_win__c',prefix+'of_leads_for_1_qualified_oppty__c',prefix+'ytd_leads_added__c',prefix+'Monthly_QO_added__c',prefix+'Quarterly_QO_added__c',prefix+'Ytd_QO_added__c',prefix+'Monthly_Lead_Added__c',prefix+'Quarterly_Lead_Added__c'};                    
                
                Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList1){
                
                if(!fieldMap1.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            }
            
            List<String> fldList2 = new List<String>{prefix+'Overall_Rating__c'};                    
                
                Map <String, Schema.SObjectField> fieldMap2 = Schema.getGlobalDescribe().get(prefix+'Certification__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList2){
                if(!fieldMap2.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            }
            
            List<String> fldList3 = new List<String>{prefix+'Sales_Rep_Profile__c',prefix+'Level_Value__c',prefix+'Level_Name__c'};
                
                Map <String, Schema.SObjectField> fieldMap3 = Schema.getGlobalDescribe().get(prefix+'Company_Level__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList3){
                
                if(!fieldMap3.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            }
            
            List<String> fldList4 = new List<String>{prefix+'Sales_Rep_Profile__c',prefix+'Company_Level__c'};
                
                Map <String, Schema.SObjectField> fieldMap4 = Schema.getGlobalDescribe().get(prefix+'Sales_Profile_Company_Level_Junction__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList4){
                
                if(!fieldMap4.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            } 
            
            if(readAccess){
                
                label1 = ApexPages.currentPage().getParameters().get('labelOne');
                label2 = ApexPages.currentPage().getParameters().get('labelTwo');
                label3 = ApexPages.currentPage().getParameters().get('labelThree');
                selectedLevel1 = ApexPages.currentPage().getParameters().get('selectOne');
                selectedLevel2 = ApexPages.currentPage().getParameters().get('selectTwo');
                selectedLevel3 = ApexPages.currentPage().getParameters().get('selectThree');
                selectedLevel4 = ApexPages.currentPage().getParameters().get('selectFour');                 
                system.debug(' selectedLevel3  '+selectedLevel3);
                
                fw = new FunnelFilterWrapper();
                
                fw.userId = UserInfo.getUserId();
                
                //Based on the parameters passed, the dropdowns in the three levels are populated
                FunnelFilterHelper.populateFilters(fw, 
                                                   label1, label2, label3,
                                                   selectedLevel1, selectedLevel2, selectedLevel3);
                /*FunnelFilterHelper.populateFilters1(fw, 
                                                   label1, label2, label3,
                                                   selectedLevel1, selectedLevel2, selectedLevel3,selectedLevel4);*/
                
                
                fw.labelFour = 'Filter By Representative';
                fw.levelFour = FunnelFilterHelper.populateLevelFour(fw,'');
                system.debug('in constructor :: '+fw.levelFour);
                
                if(selectedLevel4 != null && selectedLevel4 != '' && selectedLevel4 != 'ALL'){
                   fw.SelectedLevelFour  = selectedLevel4;
                }
                
                showUpdated();
                
                //The filter is defaulted based on the logged in user
                defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw);
                
                system.debug(defaultBreadCrumb);        
                
                managemenetReports = new Map<String,String>();
                
                User u = [SELECT Name, UserPreferencesLightningExperiencePreferred FROM User WHERE id = :UserInfo.getUserId()];
                
                //This code was used to link to the standard dashboard from the navigation. It is removed now
                /*
List<String> dashList = new List<String>();
dashList.add('mXaDybYGcSDujlyIRRJQxUrUEqXiFe');

managemenetReports = FunnelNavigationHelper.fetchDashboards(dashList,u);*/      
                
                system.debug('inside constructor');
            }
        }  
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelSalesDashboard_Controller '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }    
    }                   
    
    public void showUpdated(){
        
        try{
            
            RoleOverlay = false; 
            RepOverlay =false;
            fw.labelFour = 'Filter By Representative';
            
            isReset = false;
            
            system.debug(' fw.selectedLevelThree '+fw.selectedLevelThree);
            
            system.debug(' readAccess '+readAccess);
            
            if(readAccess){  
                
                //Aggregates of a particular level value need to be done
                if(fw.selectedLevelThree == 'All' && fw.selectedLevelFour == 'All'){
                    //Fetch the sales profile record associated with that level
                    List<Company_Level__c> cl = [SELECT Sales_Rep_Profile__c FROM Company_Level__c WHERE Level_Value__c = : fw.selectedLevelOne LIMIT 1];
                    aggregate(cl[0].Sales_Rep_Profile__c);
                    mgr = true;
                }
                //A particular rep has been selected and his values need to be displayed
                else if((fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All') || (fw.selectedLevelFour!='All' && fw.selectedLevelFour != null && fw.selectedLevelFour!='')){
                    if(fw.selectedLevelFour != 'All' && fw.selectedLevelFour != ''){
                        list<Sales_Rep_Profile__c> names = querySalesProfileAndPopulateWrapper(fw.selectedLevelFour,null);
                    }else{
                    	list<Sales_Rep_Profile__c> names = querySalesProfileAndPopulateWrapper(fw.selectedLevelTwo,null);   
                    }
                    mgr = false;             
                }
                //A particular role has been selected 
                else if (fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
                    system.debug('role aggregates');
                    mgr = true;
                    aggregateOnRole();
                }
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelSalesDashboard_Controller '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }                          
    }
    
    //Aggregation needs to be done based on the role
    private void aggregateOnRole(){        
        
        if(readAccess){
            
            List<AggregateResult> Leadcount = new List<AggregateResult>();
            List<AggregateResult> LeadcountTeam = new List<AggregateResult>();
            Boolean isOverlay = true;
            
            //Fetch the company level record associated with the particular level
            List<Company_Level__c> cl = [SELECT id, Sales_Rep_Profile__r.name FROM Company_Level__c WHERE Level_Value__c = :fw.SelectedLevelOne];
            
            displayWrapper = new FunnelSalesProfileWrapper();
            displayWrapper.Name = cl[0].Sales_Rep_Profile__r.name;                
            
            //Fetch the records at the selected level and role
            List<Sales_Profile_Company_Level_Junction__c> sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Profile_Type__c, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree];                
            
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
            
            //Fetch the company levels associated with the sales profiles
            cl = [SELECT id, Level_Value__c FROM Company_Level__c WHERE Sales_Rep_Profile__c IN :profIds];
            
            levels.clear();
            
            //Store all the levels associated with the managers
            for(Company_Level__c c: cl){
                levels.add(c.Level_Value__c);
            }
            
            //Fetch the sales profiles associated with the levels
            sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Profile_Type__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels];
            
            //Add the sales profiles to the ids to be aggregated        
            for(Sales_Profile_Company_Level_Junction__c s: sReps){
                aggregateIds.add(s.Sales_Rep_Profile__c);
                if(s.Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' ){
                    isOverlay = false;
                }
            }
            RoleOverlay = isOverlay ;
            //Fetch the sales profiles that are in the particular role and level
            List<Sales_Rep_Profile__c> sr = [SELECT id, User_Record_Name__c, name FROM Sales_Rep_Profile__c WHERE id IN :aggregateIds];
            
            String ownerString = '';
            
            //Create a string of all the owners associated with the sales profiles
            for(Sales_Rep_Profile__c s : sr){
                if(s.User_Record_Name__c != null){     
                    system.debug(' user record '+s.User_Record_Name__c);
                    
                    if (ownerString == ''){
                        ownerString = '\''+s.User_Record_Name__c+'\''+','; 
                    }
                    else{
                        
                        ownerString += '\''+s.User_Record_Name__c+'\''+',';
                    }
                }
            }
            
            if(ownerString != null && ownerString.length() > 0)
                ownerString = ownerString.subString(0,(ownerString.length() - 1));
            
            //Aggregate the results
            List<AggregateResult> ar = new List<AggregateResult>();
            
            if(RoleOverlay){
                ar = [Select AVG(YTD_Quota_Percentage__c) yp, AVG(YTD_Opportunity_Close_Rate__c) yc, SUM(YTD_Revenue__c) y, SUM(YTD_Quota__c) ytq, SUM(Annual_Quota_Amount__c) a, SUM(Monthly_quota__c) m,SUM(Quarterly_Quota__c) q ,AVG(YTD_Close_Rate__c) w, AVG(Average_Sales_Price__c) sp, SUM(YTD_Opportunities_won__c) yw, SUM(Current_Active_Opportunities__c) c, Sum(Goal_of_wins_to_achieve_annual_quota__c) qtaaq,Sum(Goal_of_wins_to_achieve_monthly_quota__c) qtamq,Sum(Goal_of_wins_to_achieve_quartly_quota__c) qtaqq,
                      SUM(of_wins_to_achieve_annual_quota__c) wq, SUM(of_wins_to_achieve_quarterly_quota__c) wqq, SUM(of_wins_to_achieve_monthly_quota__c) wmq, AVG(YTD_Lead_Conversion_rate__c) lc, AVG(of_leads_for_1_win__c) lw, AVG(of_leads_for_1_qualified_oppty__c) lo, SUM(YTD_Leads_Added__c) yl, 
                      SUM(Monthly_QO_added__c) moa, SUM(Quarterly_QO_added__c)qoa, SUM(Ytd_QO_added__c) yoa, SUM(Monthly_Lead_Added__c) mla, SUM(Quarterly_Lead_Added__c) qla, AVG(X12_Month_Lead_Conv_for_1_oppty__c) lcr,AVG(X12_Month_Rolling_Opportunity_Close_Rate__c) wp,SUM(Annual_Quota_Amount__c)aq,AVG(X12_Month_Average_Selling_Price__c)avgs  from Sales_Rep_Profile__c where id IN :aggregateIds AND Annual_Quota_Amount__c > 0 AND Profile_Type__c = 'Overlay'];
            }else{
                ar = [Select AVG(YTD_Quota_Percentage__c) yp, AVG(YTD_Opportunity_Close_Rate__c) yc, SUM(YTD_Revenue__c) y, SUM(YTD_Quota__c) ytq, SUM(Annual_Quota_Amount__c) a, SUM(Monthly_quota__c) m,SUM(Quarterly_Quota__c) q , AVG(YTD_Close_Rate__c) w, AVG(Average_Sales_Price__c) sp, SUM(YTD_Opportunities_won__c) yw, SUM(Current_Active_Opportunities__c) c, Sum(Goal_of_wins_to_achieve_annual_quota__c) qtaaq,Sum(Goal_of_wins_to_achieve_monthly_quota__c) qtamq,Sum(Goal_of_wins_to_achieve_quartly_quota__c) qtaqq,
                      SUM(of_wins_to_achieve_annual_quota__c) wq, SUM(of_wins_to_achieve_quarterly_quota__c) wqq, SUM(of_wins_to_achieve_monthly_quota__c) wmq, AVG(YTD_Lead_Conversion_rate__c) lc, AVG(of_leads_for_1_win__c) lw, AVG(of_leads_for_1_qualified_oppty__c) lo, SUM(YTD_Leads_Added__c) yl, 
                      SUM(Monthly_QO_added__c) moa, SUM(Quarterly_QO_added__c)qoa, SUM(Ytd_QO_added__c) yoa, SUM(Monthly_Lead_Added__c) mla, SUM(Quarterly_Lead_Added__c) qla, AVG(X12_Month_Lead_Conv_for_1_oppty__c) lcr,AVG(X12_Month_Rolling_Opportunity_Close_Rate__c) wp,SUM(Annual_Quota_Amount__c)aq,AVG(X12_Month_Average_Selling_Price__c)avgs  from Sales_Rep_Profile__c where id IN :aggregateIds AND Annual_Quota_Amount__c > 0  AND Profile_Type__c != 'Overlay'];
            }
            //Fetching the certification score
            if(profIds != null && profIds .size() > 0)
                displayWrapper.score = FunnelCalculationHelper.findAggregateScore(profIds);
            
            //Populate the wrapper
            if(ar != null && ar.size() > 0){                            
                
                if(ar[0].get('yp') != null)
                    displayWrapper.ytdQuotaPercentage = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('yp'))),'%');            
                
                if(ar[0].get('yc') != null)
                    displayWrapper.ytdCloseRate = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('yc'))),'%');
                
                if(ar[0].get('y') != null)
                    displayWrapper.ytdRevenueValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('y'))),'$');
                
                if(ar[0].get('ytq') != null)
                    displayWrapper.ytdQuotaValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('ytq'))),'$');
                
                if(ar[0].get('a') != null)
                    displayWrapper.annualQuotaValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('a'))),'$');
                
                if(ar[0].get('q') != null)
                    displayWrapper.quarterlyQuotaValue = FunnelCalculationHelper.convert((((Decimal)(ar[0].get('q')))/1),'$');
                
                if(ar[0].get('m') != null)
                    displayWrapper.monthlyQuotaValue = FunnelCalculationHelper.convert((((Decimal)(ar[0].get('m')))/1),'$');
                
                if(ar[0].get('w') != null)
                    displayWrapper.winPercentageValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('w'))),'%');
                
                if(ar[0].get('sp') != null)    
                    displayWrapper.salesPriceValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('sp'))),'$');
                
                if(ar[0].get('yw') != null)                
                    displayWrapper.ytdWonOpptysValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('yw'))),'');
                
                if(ar[0].get('qtaaq') != null)
                    displayWrapper.winsForAnnualQuotaValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('qtaaq'))),'');
                
                if(ar[0].get('qtaqq') != null )
                    displayWrapper.winsForQuarterlyQuotaValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('qtaqq'))),'');
                
                if(ar[0].get('qtamq') != null )
                    displayWrapper.winsForMonthlyQuotaValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('qtamq'))),'');
                
                if(ar[0].get('lc') != null)                
                    displayWrapper.leadConvPercentageValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('lc'))),'%');
                
                if(ar[0].get('lcr') != null && ar[0].get('wp') != null && ar[0].get('wp') != 0 && ar[0].get('lcr') != 0)
                    displayWrapper.leadsForWinValue = FunnelCalculationHelper.convert(((100/(Decimal)(ar[0].get('lcr'))).setScale(0, RoundingMode.HALF_UP)*100)/(Decimal)(ar[0].get('wp')),'');
                
                if(ar[0].get('lcr') != null && ar[0].get('lcr') != 0)
                    displayWrapper.leadsForQualifiedOpptyValue = FunnelCalculationHelper.convert((100/(Decimal)(ar[0].get('lcr'))),'');
                
                if(ar[0].get('moa') != null)
                    displayWrapper.monthlyQualifiedOpptysValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('moa'))),'');
                
                if(ar[0].get('qoa') != null) 
                    displayWrapper.quarterlyQualifiedOpptysValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('qoa'))),'');
                
                if(ar[0].get('yoa') != null)
                    displayWrapper.annualQualifiedOpptysValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('yoa'))),'');
                
                if(ar[0].get('c') != null)
                    displayWrapper.currentActiveOpptysValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('c'))),'');
                
                if(ar[0].get('yl') != null)
                    displayWrapper.ytdLeadsAdded = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('yl'))),'');
                
                if(ar[0].get('mla') != null) 
                    displayWrapper.monthlyLeadsForQuotaValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('mla'))),'');            
                
                if(ar[0].get('qla') != null) 
                    displayWrapper.quarterlyLeadsForQuotaValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('qla'))),'');                          
                
                Leadcount.clear();      
                system.debug(' ownerString '+ownerString);
                
                Leadcount=database.query('SELECT COUNT(id) ca From Lead WHERE OwnerId IN ('+ownerString+') And CreatedDate = TODAY');
                
                if(Leadcount != null && Leadcount.size()>0){
                    displayWrapper.dailyLeadsForQuotaValue = FunnelCalculationHelper.convert((Decimal)Leadcount[0].get('ca'),'');
                }                                     
            }  
        }              
    }
    
    private list<Sales_Rep_Profile__c> querySalesProfileAndPopulateWrapper(Id sr, Id ur){
        
        List<AggregateResult> Leadcount = new List<AggregateResult>();
        List<AggregateResult> LeadcountTeam = new List<AggregateResult>();
        
        list<Sales_Rep_Profile__c> names = new List<Sales_Rep_Profile__c>();
        
        if(readAccess){
            
            if(sr != null){
                names =[select id, (SELECT id, Overall_Rating__c FROM Certifcations__r) cr,Monthly_quota__c,Quarterly_Quota__c,Goal_of_wins_to_achieve_annual_quota__c,Goal_of_wins_to_achieve_monthly_quota__c,Goal_of_wins_to_achieve_quartly_quota__c, User_Record_name__r.CreatedDate, YTD_Quota__c, YTD_Close_Rate__c, YTD_Quota_Percentage__c, User_Record_Name__r.name,User_Record_Name__r.title,Tenure_in_current_role__c,name,Role__c,Sales_Manager__c,Sales_Manager__r.name,Sales_Rep_Start_Date__c,Territory__c, YTD_Opportunity_Close_Rate__c, YTD_Revenue__c, Annual_Quota_Amount__c, YTD_Win_Percentage__c, Average_Sales_Price__c, YTD_Opportunities_won__c, Current_Active_Opportunities__c, of_annual_qualified_opptys__c, of_quarterly_qualified_opptys__c, of_monthly_qualified_opptys__c, of_wins_to_achieve_annual_quota__c, of_wins_to_achieve_quarterly_quota__c, of_wins_to_achieve_monthly_quota__c, YTD_Lead_Conversion_rate__c, of_quarterly_leads_to_achieve_quota__c, of_monthly_leads_to_achieve_quota__c, of_daily_leads_to_achieve_quota__c, of_leads_for_1_win__c, of_leads_for_1_qualified_oppty__c, ytd_leads_added__c,
                        Profile_Type__c,Monthly_QO_added__c, Quarterly_QO_added__c, Ytd_QO_added__c, Monthly_Lead_Added__c, Quarterly_Lead_Added__c  from Sales_Rep_Profile__c where id =:sr limit 1];
            }
            else if(ur != null){
                names =[select id, (SELECT id, Overall_Rating__c FROM Certifcations__r) cr,Monthly_quota__c,Quarterly_Quota__c,Goal_of_wins_to_achieve_annual_quota__c,Goal_of_wins_to_achieve_monthly_quota__c,Goal_of_wins_to_achieve_quartly_quota__c, User_Record_name__r.CreatedDate, YTD_Quota__c, YTD_Close_Rate__c, YTD_Quota_Percentage__c, User_Record_Name__r.name,User_Record_Name__r.title,Tenure_in_current_role__c,name,Role__c,Sales_Manager__c,Sales_Manager__r.name,Sales_Rep_Start_Date__c,Territory__c, YTD_Opportunity_Close_Rate__c, YTD_Revenue__c, Annual_Quota_Amount__c, YTD_Win_Percentage__c, Average_Sales_Price__c, YTD_Opportunities_won__c, Current_Active_Opportunities__c, of_annual_qualified_opptys__c, of_quarterly_qualified_opptys__c, of_monthly_qualified_opptys__c, of_wins_to_achieve_annual_quota__c, of_wins_to_achieve_quarterly_quota__c, of_wins_to_achieve_monthly_quota__c, YTD_Lead_Conversion_rate__c, of_quarterly_leads_to_achieve_quota__c, of_monthly_leads_to_achieve_quota__c, of_daily_leads_to_achieve_quota__c, of_leads_for_1_win__c, of_leads_for_1_qualified_oppty__c, ytd_leads_added__c,
                        Profile_Type__c,Monthly_QO_added__c, Quarterly_QO_added__c, Ytd_QO_added__c, Monthly_Lead_Added__c, Quarterly_Lead_Added__c  from Sales_Rep_Profile__c where User_Record_Name__c =:ur limit 1];
            }
            
            if(names.size() > 0){ 
                
                if(names[0].Profile_Type__c != null && names[0].Profile_Type__c == 'Overlay'){
                    RepOverlay =true;
                }  
                displayWrapper = new FunnelSalesProfileWrapper();
                displayWrapper.salesManager = names[0].Sales_Manager__r.Name ;
                displayWrapper.title = names[0].User_Record_Name__r.title;
                displayWrapper.role = names[0].Role__c;
                displayWrapper.Name = names[0].name;
                displayWrapper.territory = names[0].Territory__c;
                displayWrapper.tenure = names[0].Tenure_in_current_role__c;
                
                Set<Id> aggregateIds = new Set<Id>();
                aggregateIds.add(sr);            
                displayWrapper.score = FunnelCalculationHelper.findAggregateScore(aggregateIds);
                
                Datetime strDt = names[0].User_Record_name__r.CreatedDate;
                
                if(strDt != null){
                    displayWrapper.startDate = strDt.format('MM/dd/yyyy');
                }
                
                if(names[0].YTD_Quota_Percentage__c != null)
                    displayWrapper.ytdQuotaPercentage = FunnelCalculationHelper.convert(names[0].YTD_Quota_Percentage__c,'%');
                
                if(names[0].YTD_Opportunity_Close_Rate__c != null)
                    displayWrapper.ytdCloseRate = FunnelCalculationHelper.convert(names[0].YTD_Opportunity_Close_Rate__c,'%');
                
                if(names[0].YTD_Revenue__c != null)
                    displayWrapper.ytdRevenueValue = FunnelCalculationHelper.convert(names[0].YTD_Revenue__c,'$');
                
                if(names[0].YTD_Quota__c != null)
                    displayWrapper.ytdQuotaValue = FunnelCalculationHelper.convert(names[0].YTD_Quota__c,'$');
                
                if(names[0].Annual_Quota_Amount__c != null)
                    displayWrapper.annualQuotaValue = FunnelCalculationHelper.convert(names[0].Annual_Quota_Amount__c,'$');
                
                if(names[0].Quarterly_Quota__c!= null)
                    displayWrapper.quarterlyQuotaValue = FunnelCalculationHelper.convert(((names[0].Quarterly_Quota__c)/1),'$');
                
                if(names[0].Monthly_quota__c!= null)
                    displayWrapper.monthlyQuotaValue = FunnelCalculationHelper.convert(((names[0].Monthly_quota__c)/1),'$');
                
                if(names[0].YTD_Close_Rate__c != null)
                    displayWrapper.winPercentageValue = FunnelCalculationHelper.convert(names[0].YTD_Close_Rate__c,'%');
                
                if(names[0].Average_Sales_Price__c != null)    
                    displayWrapper.salesPriceValue = FunnelCalculationHelper.convert(names[0].Average_Sales_Price__c,'$');
                
                if(names[0].YTD_Opportunities_won__c != null)                
                    displayWrapper.ytdWonOpptysValue = FunnelCalculationHelper.convert(names[0].YTD_Opportunities_won__c,'');
                
                if(names[0].Current_Active_Opportunities__c != null)
                    displayWrapper.currentActiveOpptysValue = FunnelCalculationHelper.convert(names[0].Current_Active_Opportunities__c,'');
                
                if(names[0].Goal_of_wins_to_achieve_annual_quota__c != null)
                    displayWrapper.winsForAnnualQuotaValue = FunnelCalculationHelper.convert(names[0].Goal_of_wins_to_achieve_annual_quota__c,'');
                
                if(names[0].Goal_of_wins_to_achieve_quartly_quota__c != null)
                    displayWrapper.winsForQuarterlyQuotaValue = FunnelCalculationHelper.convert(names[0].Goal_of_wins_to_achieve_quartly_quota__c,'');
                
                if(names[0].Goal_of_wins_to_achieve_monthly_quota__c != null)
                    displayWrapper.winsForMonthlyQuotaValue = FunnelCalculationHelper.convert(names[0].Goal_of_wins_to_achieve_monthly_quota__c,'');
                
                if(names[0].YTD_Lead_Conversion_rate__c != null)                
                    displayWrapper.leadConvPercentageValue = FunnelCalculationHelper.convert(names[0].YTD_Lead_Conversion_rate__c,'%');
                
                if(names[0].of_leads_for_1_win__c != null)
                    displayWrapper.leadsForWinValue = FunnelCalculationHelper.convert(names[0].of_leads_for_1_win__c,'');
                
                if(names[0].of_leads_for_1_qualified_oppty__c != null)
                    displayWrapper.leadsForQualifiedOpptyValue = FunnelCalculationHelper.convert(names[0].of_leads_for_1_qualified_oppty__c,'');
                
                if(names[0].ytd_leads_added__c != null)
                    displayWrapper.ytdLeadsAdded = FunnelCalculationHelper.convert(names[0].ytd_leads_added__c,'');
                
                if(names[0].Monthly_QO_added__c != null) 
                    displayWrapper.monthlyQualifiedOpptysValue = FunnelCalculationHelper.convert(names[0].Monthly_QO_added__c,'');
                
                if(names[0].Quarterly_QO_added__c != null) 
                    displayWrapper.quarterlyQualifiedOpptysValue = FunnelCalculationHelper.convert(names[0].Quarterly_QO_added__c,'');
                
                if(names[0].Ytd_QO_added__c != null) 
                    displayWrapper.annualQualifiedOpptysValue = FunnelCalculationHelper.convert(names[0].Ytd_QO_added__c,'');
                
                if(names[0].Monthly_Lead_Added__c != null) 
                    displayWrapper.monthlyLeadsForQuotaValue = FunnelCalculationHelper.convert(names[0].Monthly_Lead_Added__c,'');                
                
                if(names[0].Quarterly_Lead_Added__c != null) 
                    displayWrapper.quarterlyLeadsForQuotaValue = FunnelCalculationHelper.convert(names[0].Quarterly_Lead_Added__c,''); 
                
                Leadcount.clear();            
                Leadcount=database.query('SELECT COUNT(id) ca From Lead WHERE OwnerId ='+'\''+ names[0].User_Record_Name__c +'\''+ ' And CreatedDate = TODAY');
                
                if(Leadcount != null && Leadcount.size()>0){
                    displayWrapper.dailyLeadsForQuotaValue = FunnelCalculationHelper.convert((Decimal)Leadcount[0].get('ca'),'');
                } 
                
            }
        }        
        return names;
    }            
    
    //Aggregates under a manager    
    public void aggregate(Id mgrId){
        
        if(readAccess){
            
            List<Sales_Rep_Profile__c> sRep = new List<Sales_Rep_Profile__c>();
            
            List<AggregateResult> oppcount = new List<AggregateResult>();        
            
            List<AggregateResult> Leadcount = new List<AggregateResult>();
            
            String newSetStr = '' ;
            
            sRep = [Select id,User_Record_Name__c, name from Sales_Rep_Profile__c where id =:mgrId];
            
            displayWrapper = new FunnelSalesProfileWrapper();
            displayWrapper.salesManager = sRep[0].Name ;
            displayWrapper.name = sRep[0].Name ;
            set<id> mgridset = new set<id>();
            mgridset.add(mgrId);
            displayWrapper.score = FunnelCalculationHelper.findAggregateScore(mgridset);  
            
            List<Company_Level__c> cl = [SELECT id, Level_Value__c FROM Company_Level__c WHERE Level_Value__c = :fw.SelectedLevelOne];
            
            List<Sales_Profile_Company_Level_Junction__c> spCLJun = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :cl[0].Level_Value__c];
            
            Set<Id> sr = new Set<Id>();
            Set<Id> urs = new Set<Id>();
            
            for(Sales_Profile_Company_Level_Junction__c sj: spCLJun){
                sr.add(sj.Sales_Rep_Profile__c);
                if(sj.Sales_Rep_Profile__r.User_record_name__c != null){
                    urs.add(sj.Sales_Rep_Profile__r.User_record_name__c);
                }
            }
            
            for(id str : urs){
                newSetStr += '\'' + str + '\',';
            }
            
            newSetStr = newSetStr.lastIndexOf(',') > 0 ? newSetStr.substring(0,newSetStr.lastIndexOf(',')) : newSetStr ;
            
            fetchUserListAggregates(newSetStr, sr); 
            
        }
    }           
    
    private void fetchUserListAggregates(String ownerString, Set<Id> aggregateIds){                
        
        if(readAccess){     
            List<AggregateResult> Leadcount = new List<AggregateResult>();
            List<AggregateResult> LeadcountTeam = new List<AggregateResult>();
            
            Set<String> levels = new Set<String>();
            
            Set<ID> profIds = new Set<Id>();
            
            List<AggregateResult> ar = [Select AVG(YTD_Quota_Percentage__c) yp, AVG(YTD_Opportunity_Close_Rate__c) yc, SUM(YTD_Quota__c) ytq, SUM(YTD_Revenue__c) y, SUM(Annual_Quota_Amount__c) a, AVG(YTD_Close_Rate__c) w, AVG(Average_Sales_Price__c) sp, SUM(YTD_Opportunities_won__c) yw, SUM(Current_Active_Opportunities__c) c,  SUM(Monthly_quota__c) m,SUM(Quarterly_Quota__c) q ,Sum(Goal_of_wins_to_achieve_annual_quota__c) qtaaq,Sum(Goal_of_wins_to_achieve_monthly_quota__c) qtamq,Sum(Goal_of_wins_to_achieve_quartly_quota__c) qtaqq,
                                        SUM(of_wins_to_achieve_annual_quota__c) wq, SUM(of_wins_to_achieve_quarterly_quota__c) wqq, SUM(of_wins_to_achieve_monthly_quota__c) wmq, AVG(YTD_Lead_Conversion_rate__c) lc, AVG(of_leads_for_1_win__c) lw, AVG(of_leads_for_1_qualified_oppty__c) lo, SUM(YTD_Leads_Added__c) yl,
                                        SUM(Monthly_QO_added__c) moa, SUM(Quarterly_QO_added__c)qoa, SUM(Ytd_QO_added__c) yoa, SUM(Monthly_Lead_Added__c) mla, SUM(Quarterly_Lead_Added__c) qla, AVG(X12_Month_Lead_Conv_for_1_oppty__c) lcr,AVG(X12_Month_Rolling_Opportunity_Close_Rate__c) wp,SUM(Annual_Quota_Amount__c)aq,AVG(X12_Month_Average_Selling_Price__c)avgs from Sales_Rep_Profile__c where id IN :aggregateIds AND  Annual_Quota_Amount__c > 0 AND Profile_Type__c != 'Overlay' ];
            
            //displayWrapper.score = FunnelCalculationHelper.findAggregateScore(aggregateIds);                
            
            if(ar != null && ar.size() > 0){                            
                
                if(ar[0].get('yp') != null)
                    displayWrapper.ytdQuotaPercentage = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('yp'))),'%');
                
                if(ar[0].get('yc') != null)
                    displayWrapper.ytdCloseRate = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('yc'))),'%');
                
                if(ar[0].get('y') != null)
                    displayWrapper.ytdRevenueValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('y'))),'$');
                
                if(ar[0].get('ytq') != null)
                    displayWrapper.ytdQuotaValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('ytq'))),'$');
                
                if(ar[0].get('a') != null)
                    displayWrapper.annualQuotaValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('a'))),'$');
                
                if(ar[0].get('q') != null)
                    displayWrapper.quarterlyQuotaValue = FunnelCalculationHelper.convert((((Decimal)(ar[0].get('q')))/1),'$');
                
                if(ar[0].get('m') != null)
                    displayWrapper.monthlyQuotaValue = FunnelCalculationHelper.convert((((Decimal)(ar[0].get('m')))/1),'$');
                
                if(ar[0].get('w') != null)
                    displayWrapper.winPercentageValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('w'))),'%');
                
                if(ar[0].get('sp') != null)    
                    displayWrapper.salesPriceValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('sp'))),'$');
                
                if(ar[0].get('yw') != null)                
                    displayWrapper.ytdWonOpptysValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('yw'))),'');
                
                if(ar[0].get('qtaaq') != null )
                    displayWrapper.winsForAnnualQuotaValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('qtaaq'))),'');
                
                if(ar[0].get('qtaqq') != null)
                    displayWrapper.winsForQuarterlyQuotaValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('qtaqq'))),'');
                
                if(ar[0].get('qtamq') != null)
                    displayWrapper.winsForMonthlyQuotaValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('qtamq'))),'');
                
                if(ar[0].get('lc') != null)                
                    displayWrapper.leadConvPercentageValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('lc'))),'%');
                
                if(ar[0].get('lcr') != null && ar[0].get('lcr') != 0){
                    displayWrapper.leadsForQualifiedOpptyValue = FunnelCalculationHelper.convert((100/(Decimal)(ar[0].get('lcr'))),'');
                }else{
                    displayWrapper.leadsForQualifiedOpptyValue ='0';
                }
                if(ar[0].get('lcr') != null && ar[0].get('wp') != null && ar[0].get('lcr') != 0 && ar[0].get('wp') != 0){
                    displayWrapper.leadsForWinValue = FunnelCalculationHelper.convert(((100/(Decimal)(ar[0].get('lcr'))).setScale(0, RoundingMode.HALF_UP)*100)/(Decimal)(ar[0].get('wp')),'');
                }else{
                    displayWrapper.leadsForWinValue = '0';
                }
                
                if(ar[0].get('yl') != null)
                    displayWrapper.ytdLeadsAdded = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('yl'))),'');
                
                if(ar[0].get('moa') != null) 
                    displayWrapper.monthlyQualifiedOpptysValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('moa'))),'');
                
                if(ar[0].get('qoa') != null) 
                    displayWrapper.quarterlyQualifiedOpptysValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('qoa'))),'');
                
                if(ar[0].get('yoa') != null) 
                    displayWrapper.annualQualifiedOpptysValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('yoa'))),'');
                
                if(ar[0].get('mla') != null) 
                    displayWrapper.monthlyLeadsForQuotaValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('mla'))),'');            
                
                if(ar[0].get('qla') != null) 
                    displayWrapper.quarterlyLeadsForQuotaValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('qla'))),'');                               
                
                if(ar[0].get('c') != null) 
                    displayWrapper.currentActiveOpptysValue = FunnelCalculationHelper.convert(((Decimal)(ar[0].get('c'))),'');
                
                Leadcount.clear();            
                Leadcount=database.query('SELECT COUNT(id) ca From Lead WHERE OwnerId IN ('+ownerString+') And CreatedDate = TODAY');
                if(Leadcount != null && Leadcount.size()>0){
                    displayWrapper.dailyLeadsForQuotaValue = FunnelCalculationHelper.convert((Decimal)Leadcount[0].get('ca'),'');
                } 
                
            }
        }
    }                        
    
    /*Filters*/
    //Method called when reset button is selected
    public PageReference reset(){
        
        //return FunnelNavigationHelper.navigateToDashboard('','','','','','');
        return FunnelNavigationHelper.navigateToDashboard('','','','','','','');
        
    }
    /*Filters*/ 
    
    //Action method when level one is changed
    public void levelOneAction(){
        try{
            if(readAccess){
                system.debug(' inside level one action ');
                FunnelFilterHelper.levelOneAction(fw);
                defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw);
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelSalesDashboard_Controller '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        } 
    }
    
    //Action method when level two is changed
    public void levelTwoAction(){
        try{
            if(readAccess)
                FunnelFilterHelper.levelTwoAction(fw);
        		defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw);
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelSalesDashboard_Controller '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        } 
    }
    
    //Method that resets the filters when first dropdown is changed
    //In this scenario, the filter should not be concatenated but the filters should be repopulated
    /*public void resetCrumb(){
defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw);
system.debug(' defaultBreadCrumb '+defaultBreadCrumb);
}*/   
    
    /*Navigation*/
    
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToCertification(){
        
        //return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
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
    
    public PageReference navigateToFunnelAnalyticQualitative(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    } 
    
    public PageReference navigateToSalesPipeline(){
        
        return FunnelNavigationHelper.navigateToSalesPipeline(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToFunnelAnalytic(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
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
    public PageReference navigateToAnnualizationDashboard(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
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
        fw.labelFour = 'Filter By Representative';
        FunnelFilterHelper.onclickpopulateFilters(crumValue,fw);
    } 
    
}