/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelNavigationHelper{
    
    public static PageReference navigateToFunnelAnalytic(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree,String selectedLevelFour){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/SalesScoreCard?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree+'&selectFour='+selectedLevelFour); 
        else
            redirect = new PageReference('/apex/SalesScoreCard'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToFunnelAnalyticQualitative(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree,String selectedLevelFour){
    //public static PageReference navigateToFunnelAnalyticQualitative(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelAnalyticQualitative?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree+'&selectFour='+selectedLevelFour); 
        else
            redirect = new PageReference('/apex/FunnelAnalyticQualitative'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    /*public static PageReference navigateToSalesScoreCard(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree,String selectedLevelFour){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/SalesScoreCard?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree+'&selectFour='+selectedLevelFour); 
        else
            redirect = new PageReference('/apex/SalesScoreCard'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }*/
        
    public static PageReference navigateToTrndngRep(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree,String selectedLevelFour){
        
        PageReference redirect;
        system.debug('labelOne :: '+labelOne);
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelTrendingByRepDashboard?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree+'&selectFour='+selectedLevelFour); 
        else
            redirect = new PageReference('/apex/FunnelTrendingByRepDashboard?'); 
        
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToTrendingByRep(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelTrendingByRepDashboard?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelTrendingByRepDashboard'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToTrendingBySkill(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelTrendingBySkillDashboard?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelTrendingBySkillDashboard'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    //public static PageReference navigateToCertification(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
    public static PageReference navigateToCertification(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree,String selectedLevelFour){    
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelCerificationTable?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree+'&selectFour='+selectedLevelFour); 
        else
            redirect = new PageReference('/apex/FunnelCerificationTable'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToSalesPipeline(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree,String selectedLevelFour){    
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelHomePage1?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree+'&selectFour='+selectedLevelFour); 
        else
            redirect = new PageReference('/apex/FunnelHomePage1'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToCalculator(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelCalculator?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelCalculator'); 
            
        redirect.setRedirect(true);     
        return redirect;
        
    }
    
    public static PageReference navigateToDashboard(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelSalesDashboard?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelSalesDashboard'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToDashboard(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree,String selectedLevelFour){
    //public static PageReference navigateToDashboard(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree,String selectedLevelFour){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelSalesDashboard?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree+'&selectFour='+selectedLevelFour); 
        else
            redirect = new PageReference('/apex/FunnelSalesDashboard'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToHomePage(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelHomePage?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelHomePage'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToHomePage(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree,String selectedLevelFour){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelHomePage?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree+'&selectFour='+selectedLevelFour); 
        else
            redirect = new PageReference('/apex/FunnelHomePage'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToHomePage(){
        
        PageReference redirect;
        
        redirect = new PageReference('/apex/FunnelHomePage'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToChecklistPage(){
        
        PageReference redirect;
        
        redirect = new PageReference('/apex/FunnelInstallationChecklist'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToReportsPage(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree,String selectedLevelFour){
    //public static PageReference navigateToReportsPage(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelReportingPage?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree+'&selectFour='+selectedLevelFour); 
        else
            redirect = new PageReference('/apex/FunnelReportingPage'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToAppSetupPage(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        List<AggregateResult> asperm = [SELECT count(Id) c FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = 'Funnel_App_Setup'];
        
        if(asperm != null && asperm.size() > 0 && asperm[0].get('c') != null && (Integer)asperm[0].get('c') > 0  ){
           
            if(labelOne != null && labelOne != '')
                redirect = new PageReference('/apex/FunnelSalesCertification?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
            else
                redirect = new PageReference('/apex/FunnelSalesCertification');
                
        }else{
            if(labelOne != null && labelOne != '')
                redirect = new PageReference('/apex/FunnelManagerUpdate?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
            else
                redirect = new PageReference('/apex/FunnelManagerUpdate');
        }
        
         
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToCertificateReports(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelCertificationReports?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelCertificationReports'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToAssignRole(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelAssignrole?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelAssignrole'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToCustomMetric(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelSalesCertificationcustom?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelSalesCertificationcustom'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToNotifications(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelNotification?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelNotification'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToCreateEditRatings(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelSalesCertification?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelSalesCertification'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToCategories(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelAddAndEditCategory?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelAddAndEditCategory'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToAnalytics(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelAnalytic?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelAnalytic'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }    
    
    public static PageReference navigateToFunnelEvaluationGuidelines(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelEvaluationGuidelines?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelEvaluationGuidelines'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }  
    
    public static PageReference navigateToFunnelAnnualizationDashboard(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree,String selectedLevelFour){
    //public static PageReference navigateToFunnelAnnualizationDashboard(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelAnnualizationDashboard?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree+'&selectFour='+selectedLevelFour); 
        else
            redirect = new PageReference('/apex/FunnelAnnualizationDashboard'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }     
    
    public static PageReference navigateToFunnelSetup(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelSetup?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelSetup'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToFunnelReviewGoals(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelReviewGoals?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelReviewGoals'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
     public static PageReference navigateToFunnelManagerUpdate(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelManagerUpdate?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelManagerUpdate'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToFunnelAddEditSrp(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelAddEditSrp?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelAddEditSrp'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToFunnelAddEditCompanyLevel(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelAddEditCompanyLevel?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelAddEditCompanyLevel'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToFunnelAddEditRole(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        if(labelOne != null && labelOne != '')
            redirect = new PageReference('/apex/FunnelAddEditRole?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelAddEditRole'); 
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToGoalsPage(String labelOne,String labelTwo,String labelThree,String selectedLevelOne,String selectedLevelTwo,String selectedLevelThree){
        
        PageReference redirect;
        
        List<AggregateResult> asperm = [SELECT count(Id) c FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = 'Funnel_App_Setup'];
        
        if(asperm != null && asperm.size() > 0 && asperm[0].get('c') != null && (Integer)asperm[0].get('c') > 0  ){
           
            if(labelOne != null && labelOne != '')
                redirect = new PageReference('/apex/FunnelReviewGoals?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
            else
                redirect = new PageReference('/apex/FunnelReviewGoals');
                
        }else{
            if(labelOne != null && labelOne != '')
                redirect = new PageReference('/apex/FunnelManagerUpdate?'+'labelOne='+labelOne+'&labelTwo='+labelTwo+'&labelThree='+labelThree+'&selectOne='+selectedLevelOne+'&selectTwo='+selectedLevelTwo+'&selectThree='+selectedLevelThree); 
            else
                redirect = new PageReference('/apex/FunnelManagerUpdate');
        }
        
         
 
        redirect.setRedirect(true);     
        return redirect;
    
    }
    
    public static PageReference navigateToHelpMenu(){
        PageReference redirect = new PageReference (' https://funnelocity.force.com/supportandhelp/s/');
        return redirect;
    }
    
    /*
    public static Map<String,String> fetchDashboards(List<String> devNames, User u){
        
        Map<String,String> managemenetReports = new Map<String,String>();
        
        system.debug(' devNames '+devNames);
        
        List<Dashboard> dashList = [SELECT Id, DeveloperName FROM Dashboard WHERE DeveloperName IN :devNames];
        system.debug(' dashList '+dashList);
               
        if(u.UserPreferencesLightningExperiencePreferred  == true){
            
            for(Dashboard r : dashList){
                managemenetReports.put(r.developerName,'/one/one.app#/alohaRedirect/'+(String)r.id);
            }                       
        
        }else{
        
            for(Dashboard r : dashList){
                managemenetReports.put(r.developerName,'/'+(String)r.id);
            }            
        }
        
        for(String s : devNames){
            if(!managemenetReports.containsKey(s)){
                managemenetReports.put(s,'FunnelNoReport');
            }
        } 
        
        return managemenetReports;
    }*/
    
    public static Map<String,String> fetchDashboards(List<String> devNames, Map<String,String> dashMap, String theme){
        
        Map<String,String> managemenetReports = new Map<String,String>();
        
        system.debug(' devNames '+devNames);
        
        List<Dashboard> dashList = [SELECT Id, DeveloperName FROM Dashboard WHERE DeveloperName IN :devNames];
        system.debug(' dashList '+dashList);
               
        if(theme  == 'lightning'){
            
            for(Dashboard r : dashList){
                managemenetReports.put(dashMap.get(r.developerName),'/one/one.app#/alohaRedirect/'+(String)r.id);
            }   
            
        }                            
        else{
        
            for(Dashboard r : dashList){
                managemenetReports.put(dashMap.get(r.developerName),'/'+(String)r.id);
            }            
        }
        
        system.debug(' dashMap.values '+dashMap.values());        
        
        return managemenetReports;
    }
    
    public static List<Report> fetchReports(){
    
        List<Report> reportList = [SELECT id, name,developerName FROM Report WHERE developerName IN ('X12_Mo_Opptys_added_to_funnel_SRP_Snapsho_73d',    'X12_Mo_SRP_Snapshots_Opptys_Added_tTS',    
            'X12_Month_Funnel_Report',  'X12_Month_Funnel_Win_Rate_m3a',    'X12_Month_Funnel_by_Lead_Source',  'Monthly_Funnel_Report',    'Opportunities_Added_by_Rep_qtr',   
            'Opportunity_Win_Report',   'Quarterly_Funnel_Report',  'SRP_Lead_Conversion_Rate_by_Month_2MH',    'SRP_Snapshot_Sales_Cycle_ALc', 'SRP_Snapshot_12_Mo_Win_Size_iuS',  
            'X12_Mo_SRP_Snapshot_Mnthly_Opptys_Added_Wnh',  'SRP_Snapshot_Monthly_Leads_Added_xB3', 'Copy_of_SRP_Snapshot_Mnthly_Opptys_Added_7aQ', 
            'X12_Mo_SRP_Snapshot_Mnthly_Opptys_Added_Wnh1', 'YTD_Win_Report_jWK1',  'Sales_Rep_Quota_YTD_Attainment',   'YTD_Win_Report_jWK',   
            'Current_Yr_YTD_Oppty_Wins_by_Lead_Source')];
            
            return reportList;
    }
}