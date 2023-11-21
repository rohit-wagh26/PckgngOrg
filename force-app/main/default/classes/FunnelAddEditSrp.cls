public with sharing class FunnelAddEditSrp {

    public List<Sales_Rep_Profile__c> srpList {get;set;}
    public Sales_Rep_Profile__c  srpSelected {get;set;}
    public Id srpId {get;set;}
    public Decimal annualQuota{get;set;}

    public  List<SelectOption> SrpsList{get;set;}
     public  List<SelectOption> rpsList{get;set;}

    //Variables to store the parameters passed in the URL
    public String label1{get; set;}
    public String label2{get; set;}
    public String label3{get; set;}
    public String selectedLevel1{get; set;}
    public String selectedLevel2{get; set;}
    public String selectedLevel3{get; set;}
    
    public Boolean adminPer{get;set;}
    public Boolean isManger{get;set;}
    public Decimal currentfiscalmonth ;
    
    public List<SelectOption>  u1 { get;set; }
    public List<SelectOption>  u2{ get;set; }
    public List<SelectOption>  u3{ get;set; }
    public List<SelectOption>  u4 { get;set; }
    public List<SelectOption>  u5{ get;set; }
    public List<SelectOption>  u6{ get;set; }
    public List<SelectOption>  u7{ get;set; }
    public List<SelectOption>  deactiveUser{ get;set; }
        
    Public FunnelAddEditSrp (){ 
        
         Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce')]);
         
        List<User> allList = [SELECT id, name, username, profile.name, userrole.name FROM User WHERE  profileId in:profileIds.Keyset() AND isActive = TRUE   ORDER BY name ASC Limit 4000];
        
        //List<User> allList = [SELECT id, name, username, profile.name, userrole.name FROM User WHERE isActive = TRUE ORDER BY name ASC ];

        //Variables to store the max limit of a  list and count
        Integer limitMax = 998;
        Integer limitMax1 = 1997;
        Integer limitMax2 = 2996;
        Integer limitMax3 = 3995;
        Integer limitMax4 = 4995;
        Integer limitMax5 = 5994;
        Integer count = 0;
        u1 =  new List<SelectOption>();
        u2 =  new List<SelectOption>();
        u3 =  new List<SelectOption>();
        u4 =  new List<SelectOption>();
        u5 =  new List<SelectOption>();
        u6 =  new List<SelectOption>();
        u7 =  new List<SelectOption>();
        deactiveUser  =  new List<SelectOption>();
        u1.add(new SelectOption('','--None--' )); 
        
        //Iterating through the users and creating two wrapper lists for original and list to update
        for(User u: allList){
            
            count++;
            
            if(count > 0 && count <= limitMax){
                u1.add(new SelectOption(u.id,u.name)); 
            }
            else if (count > limitMax && count <= limitMax1 ){
                u2.add(new SelectOption(u.id,u.name)); 
            }
            else if (count > limitMax1 && count <= limitMax2){
                u3.add(new SelectOption(u.id,u.name)); 
            }
            else if (count > limitMax2 && count <= limitMax3 ){
                u4.add(new SelectOption(u.id,u.name)); 
            }
            else if (count > limitMax3 && count <= limitMax4 ){
                u5.add(new SelectOption(u.id,u.name)); 
            }
            else if (count > limitMax4 && count <= limitMax5 ){
                u6.add(new SelectOption(u.id,u.name)); 
            }
            else{
                u7.add(new SelectOption(u.id,u.name)); 
            }            
            
        
        }
         
       
        srpList = [Select id,Name,Active__c,Dont_send_to_model__c,User_Record_Name__c,User_Record_Name__r.username,Rep_Start_Date__c,Profile_Type__c,Rep_Staus__c,Role__c,Placeholder__c,Sales_Manager__c,Sales_Manager__r.Name,Annual_Quota_Amount__c,Month_1_Quota_Amount__c,Month_2_Quota_Amount__c,Month_3_Quota_Amount__c,Month_4_Quota_Amount__c,Month_5_Quota_Amount__c,Month_6_Quota_Amount__c,Month_7_Quota_Amount__c,Month_8_Quota_Amount__c,Month_9_Quota_Amount__c,Month_10_Quota_Amount__c,Month_11_Quota_Amount__c,Month_12_Quota_Amount__c,Goal_Average_Deal_Size__c,Goal_of_monthly_meetings__c,Goal_12m_length_of_sales_cycle__c,Goal_12m_rolling_amt_close_rate__c,Goal_12m_rolling_close_rate__c,Goal_12m_Lead_To_Opp_Conv_Rate__c,Goal_12m_Avg_Selling_Price__c,Current_Fiscal_Months__c from Sales_Rep_Profile__c order by  name asc Limit 5000];
        currentfiscalmonth = 1 ;
        
        if( srpList != null && srpList.size()>0 && srpList[0].Current_Fiscal_Months__c != null){
            currentfiscalmonth = srpList[0].Current_Fiscal_Months__c;
        }
        
        SrpsList= new List<SelectOption>();
        rpsList= new List<SelectOption>();
        SrpsList.add(new SelectOption( '','--None--')); 
        for(Sales_Rep_Profile__c cr :[Select id , name from Sales_Rep_Profile__c   order by Name asc Limit 5000] ){
            SrpsList.add(new SelectOption(cr.id,cr.name)); 
        }
        
        label1 = ApexPages.currentPage().getParameters().get('labelOne');
        label2 = ApexPages.currentPage().getParameters().get('labelTwo');
        label3 = ApexPages.currentPage().getParameters().get('labelThree');
        selectedLevel1 = ApexPages.currentPage().getParameters().get('selectOne');
        selectedLevel2 = ApexPages.currentPage().getParameters().get('selectTwo');
        selectedLevel3 = ApexPages.currentPage().getParameters().get('selectThree');   
        
        List<AggregateResult> asperm = [SELECT count(Id) c FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = 'Funnel_App_Setup'];
        if((asperm != null && asperm.size() > 0 && asperm[0].get('c') != null && (Integer)asperm[0].get('c') > 0)   ){
            adminPer= true;
        }else{
            adminPer= false;
        }
        
        isManger = FunnelTriggerBatchHelper.isManager(UserInfo.getUserId());
        srpId = null; 
    }
    
    public void displayAddEditSrp(){
         
        
        if(srpId != null){
           srpSelected  = [Select id,Interim_Manager__c,Name,Active__c,Dont_send_to_model__c,Sales_Manager__r.Active__c,User_Record_Name__c,User_Record_Name__r.username,User_Record_Name__r.Name,User_Record_Name__r.isActive,Rep_Start_Date__c,Profile_Type__c,Rep_Staus__c,Role__c,Placeholder__c,Sales_Manager__c,Sales_Manager__r.Name,Annual_Quota_Amount__c,Month_1_Quota_Amount__c,Month_2_Quota_Amount__c,Month_3_Quota_Amount__c,Month_4_Quota_Amount__c,Month_5_Quota_Amount__c,Month_6_Quota_Amount__c,Month_7_Quota_Amount__c,Month_8_Quota_Amount__c,Month_9_Quota_Amount__c,Month_10_Quota_Amount__c,Month_11_Quota_Amount__c,Month_12_Quota_Amount__c,Goal_Average_Deal_Size__c,Goal_of_monthly_meetings__c,Goal_12m_length_of_sales_cycle__c,Goal_12m_rolling_amt_close_rate__c,Goal_12m_rolling_close_rate__c,Goal_12m_Lead_To_Opp_Conv_Rate__c,Goal_12m_Avg_Selling_Price__c,Current_Fiscal_Months__c  from Sales_Rep_Profile__c where id =:srpId Limit 1];
           annualQuota = srpSelected.Annual_Quota_Amount__c;
           if(srpSelected.User_Record_Name__c != null && !srpSelected.User_Record_Name__r.isActive ){
               deactiveUser.add(new SelectOption(srpSelected.User_Record_Name__c,srpSelected.User_Record_Name__r.Name)); 
           }
           /*if(srpSelected.Sales_Manager__c != null && !srpSelected.Sales_Manager__r.Active__c){
               SrpsList.add(new SelectOption(srpSelected.Sales_Manager__c,srpSelected.Sales_Manager__r.Name)); 
           }*/
        }else{
            srpSelected = new Sales_Rep_Profile__c();
            srpSelected.Active__c = true;
            srpSelected.Current_Fiscal_Months__c =currentfiscalmonth ;
            annualQuota  = null; 
        }
         
    }
    
    public void updateAQ(){
        annualQuota   = 0;
        for(integer i =1; i<=12;i++){
            
            if(srpSelected.get('Month_'+i+'_Quota_Amount__c') != null){
                Decimal c= (Decimal)srpSelected.get('Month_'+i+'_Quota_Amount__c');
                system.debug('c-'+c);
                annualQuota  += (Decimal)srpSelected.get('Month_'+i+'_Quota_Amount__c');
            }
        } 
       // annualQuota  = srpSelected.Month_1_Quota_Amount__c +srpSelected.Month_2_Quota_Amount__c+srpSelected.Month_3_Quota_Amount__c+srpSelected.Month_4_Quota_Amount__c+srpSelected.Month_5_Quota_Amount__c+srpSelected.Month_6_Quota_Amount__c+srpSelected.Month_7_Quota_Amount__c+srpSelected.Month_8_Quota_Amount__c+srpSelected.Month_9_Quota_Amount__c+srpSelected.Month_10_Quota_Amount__c+srpSelected.Month_11_Quota_Amount__c+srpSelected.Month_12_Quota_Amount__c;
    }
    
     
    public void hideAddEditSrp(){

         
        srpId = null; 
        srpSelected = new Sales_Rep_Profile__c(); 
                
    }
    
    public void RoleChange(){
        
        List<Yearly_goals_by_Role__c> latestYr = [SELECT Year__c FROM Yearly_goals_by_Role__c ORDER BY Year__c DESC LIMIT 1];
        
        if(latestYr != null && latestYr.size() > 0){
            List<Yearly_goals_by_Role__c>  goalsLst = [SELECT id, Role__c, Year__c, X12_month_avg_selling_price__c, X12_month_rolling_lead_to_opp_conv_rate__c, X12_month_rolling_avg_deal_size__c, X12_month_rolling_opp_close_rate__c, X12_month_rolling_amt_close_rate__c, X12_month_rolling_avg_sales_cycle__c, Number_of_monthly_meetings__c FROM Yearly_goals_by_Role__c WHERE Year__c = :latestYr[0].Year__c And Role__c= :srpSelected.Role__c LIMIT 1];
            
            if(goalsLst != null && goalsLst.size()>0 ){
                srpSelected.Goal_12m_Avg_Selling_Price__c = goalsLst[0].X12_month_avg_selling_price__c;
                srpSelected.Goal_12m_Lead_To_Opp_Conv_Rate__c= goalsLst[0].X12_month_rolling_lead_to_opp_conv_rate__c;
                srpSelected.Goal_Average_Deal_Size__c= goalsLst[0].X12_month_rolling_avg_deal_size__c;
                srpSelected.Goal_12m_rolling_close_rate__c= goalsLst[0].X12_month_rolling_opp_close_rate__c;
                srpSelected.Goal_12m_rolling_amt_close_rate__c= goalsLst[0].X12_month_rolling_amt_close_rate__c;
                srpSelected.Goal_12m_length_of_sales_cycle__c= goalsLst[0].X12_month_rolling_avg_sales_cycle__c;
                srpSelected.Goal_of_monthly_meetings__c= goalsLst[0].Number_of_monthly_meetings__c ;
           }else{
                srpSelected.Goal_12m_Avg_Selling_Price__c = 0;
                srpSelected.Goal_12m_Lead_To_Opp_Conv_Rate__c=  0;
                srpSelected.Goal_Average_Deal_Size__c=  0;
                srpSelected.Goal_12m_rolling_close_rate__c=  0;
                srpSelected.Goal_12m_rolling_amt_close_rate__c=  0;
                srpSelected.Goal_12m_length_of_sales_cycle__c=  0;
                srpSelected.Goal_of_monthly_meetings__c=  0;
           } 
        }
    
    }
    public void QuotaChange(){
        
        if(annualQuota > 0){
            for(integer i= 1;i<=12;i++){
                srpSelected.put('Month_'+i+'_Quota_Amount__c',(annualQuota /12).setScale(2, RoundingMode.HALF_UP));
            }
            if(srpSelected.Rep_Start_Date__c  != null ){
                
                Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues('Current_Year');
                Date firstDate = fy.Start_Date__c;
                Integer monthsBetween = firstDate.monthsBetween(srpSelected.Rep_Start_Date__c );
                
                if(monthsBetween >0 ){
                    for(integer i= 1 ;i<=12;i++){
                        
                        if(i > monthsBetween){
                            srpSelected.put('Month_'+i+'_Quota_Amount__c',(annualQuota/(12- monthsBetween)).setScale(2, RoundingMode.HALF_UP));
                        }else{
                            srpSelected.put('Month_'+i+'_Quota_Amount__c',0);
                        }
            
                    }
                }
            }
        }else{
            for(integer i= 1 ;i<=12;i++){
                        
                    srpSelected.put('Month_'+i+'_Quota_Amount__c',0);
                         
            }
        }
    }
    
    public void save(){
       
        if(srpId == null){
            List<Metric_Goals__c> mg = [Select Certification_Rating__r.Goal_field_name__c,Goal__c,Role__c From Metric_Goals__c where Role__c =:srpSelected.Role__c AND Certification_Rating__r.Group__c ='Custom Metrics' AND Certification_Rating__c!= null Limit 5000];
            
            for(Metric_Goals__c m : mg){
            
                srpSelected.put(m.Certification_Rating__r.Goal_field_name__c ,m.Goal__c);
            
            }
        }
        System.debug('srpSelected -->'+srpSelected );
        upsert srpSelected ; 
        srpList = [Select id,Name,Active__c,Dont_send_to_model__c,User_Record_Name__c,User_Record_Name__r.username,Rep_Start_Date__c,Profile_Type__c,Rep_Staus__c,Role__c,Placeholder__c,Sales_Manager__c,Sales_Manager__r.Name,Annual_Quota_Amount__c,Month_1_Quota_Amount__c,Month_2_Quota_Amount__c,Month_3_Quota_Amount__c,Month_4_Quota_Amount__c,Month_5_Quota_Amount__c,Month_6_Quota_Amount__c,Month_7_Quota_Amount__c,Month_8_Quota_Amount__c,Month_9_Quota_Amount__c,Month_10_Quota_Amount__c,Month_11_Quota_Amount__c,Month_12_Quota_Amount__c,Goal_Average_Deal_Size__c,Goal_of_monthly_meetings__c,Goal_12m_length_of_sales_cycle__c,Goal_12m_rolling_amt_close_rate__c,Goal_12m_rolling_close_rate__c,Goal_12m_Lead_To_Opp_Conv_Rate__c,Goal_12m_Avg_Selling_Price__c from Sales_Rep_Profile__c order by  name asc Limit 5000];
        FunnelInstallationHelper.createPermsissions();        
    }
    
    
    /*Navigation*/
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToCertification(){
        
        //return FunnelNavigationHelper.navigateToCertification(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToCertification(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToDashboard(){
        
        //return FunnelNavigationHelper.navigateToDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    //Method called on clicking Performance Dashboard on header
    public PageReference navigateToCalculator(){
        
        return FunnelNavigationHelper.navigateToCalculator(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    //Method called on clicking Home on header    
    public PageReference navigateToHomePage(){
        
        return FunnelNavigationHelper.navigateToHomePage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    //Method called on clicking Reporting on header    
    public PageReference navigateToReportsPage(){
        
        //return FunnelNavigationHelper.navigateToReportsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        return FunnelNavigationHelper.navigateToReportsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    //Method called on clicking App Setup on header    
    public PageReference navigateToAppSetup(){
        
        return FunnelNavigationHelper.navigateToAppSetupPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    public PageReference navigateToCertificateReports(){
        
        return FunnelNavigationHelper.navigateToCertificateReports(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }  
    
    public PageReference navigateToAssignRole(){
        
        return FunnelNavigationHelper.navigateToAssignRole(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);    
        
    }
     public PageReference navigateToRatings(){
        
        return FunnelNavigationHelper.navigateToCreateEditRatings(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }  
    
    
    
    public PageReference navigateToNotifications(){
        
        return FunnelNavigationHelper.navigateToNotifications(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    }
    
    public PageReference navigateToAnalytics(){
        
        return FunnelNavigationHelper.navigateToAnalytics(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    public PageReference navigateToFunnelAnalyticQualitative(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    } 
    
    public PageReference navigateToSalesPipeline(){
        
        return FunnelNavigationHelper.navigateToSalesPipeline(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    public PageReference navigateToTrendingByRep(){
        
        return FunnelNavigationHelper.navigateToTrendingByRep(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToTrendingBySkill(){
        
        return FunnelNavigationHelper.navigateToTrendingBySkill(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToFunnelAnalytic(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalytic(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToFunnelAnalytic(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    public PageReference navigateToFunnelEvaluationGuidelines(){
        
        return FunnelNavigationHelper.navigateToFunnelEvaluationGuidelines(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    public PageReference navigateToAnnualizationDashboard(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
     public PageReference navigateToFunnelSetup(){
        
        return FunnelNavigationHelper.navigateToFunnelSetup(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    public PageReference navigateToFunnelReviewGoals(){
        
        return FunnelNavigationHelper.navigateToFunnelReviewGoals(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    public PageReference navigateToFunnelManagerUpdate(){
        
        return FunnelNavigationHelper.navigateToFunnelManagerUpdate(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    public PageReference navigateToCustomMetric(){
        
        return FunnelNavigationHelper.navigateToCustomMetric(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
     public PageReference navigateToFunnelAddEditCompanyLevel(){
        
        return FunnelNavigationHelper.navigateToFunnelAddEditCompanyLevel(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
   
    public PageReference navigateToFunnelAddEditSRP(){
        
        return FunnelNavigationHelper.navigateToFunnelAddEditSrp(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    public PageReference navigateToFunnelAddEditRole(){
        
        return FunnelNavigationHelper.navigateToFunnelAddEditRole(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    public PageReference navigateToGoals(){
        
        return FunnelNavigationHelper.navigateToGoalsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    //Added for Help Menu - Rohit
    public PageReference navigateToHelpMenu(){
        
        return FunnelNavigationHelper.navigateToHelpMenu();
    
    }
    /*Navigation*/ 
}