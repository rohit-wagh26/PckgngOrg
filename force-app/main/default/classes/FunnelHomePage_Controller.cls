/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelHomePage_Controller{

    public FunnelHomePage_Controller(FunnelInstallationStep2Controller controller) {

    }

    
    Public Map<String,String> managemenetReports{get;set;}
    public string appsetup {get;set;}
    
    public FunnelHomePage_Controller() {
        /*
        managemenetReports = new Map<String,String>();
        
        User u = [SELECT Name, UserPreferencesLightningExperiencePreferred FROM User WHERE id = :UserInfo.getUserId()];
        
        List<String> dashList = new List<String>();
        dashList.add('mXaDybYGcSDujlyIRRJQxUrUEqXiFe');
        
        managemenetReports = FunnelNavigationHelper.fetchDashboards(dashList,u);
        */
        
        List<AggregateResult> asperm = [SELECT count(Id) c FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = 'Funnel_App_Setup'];
        
        if(asperm != null && asperm.size() > 0 && asperm[0].get('c') != null && (Integer)asperm[0].get('c') > 0 ){
            appsetup ='';
        }else{
            appsetup ='none';
        }
    }
       
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToCertification(){
        
        return FunnelNavigationHelper.navigateToCertification('','','','','','','');
    
    }
    
    public PageReference navigateToCalculator(){
        
        return FunnelNavigationHelper.navigateToCalculator('','','','','','');
        
    }
    
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToDashboard(){
        
        return FunnelNavigationHelper.navigateToDashboard('','','','','','','');
    
    }  
    
    //Method called on clicking Reporting on header    
    public PageReference navigateToReportsPage(){
        
        return FunnelNavigationHelper.navigateToReportsPage('','','','','','','');
        
    }
    
    //Method called on clicking App Setup on header    
    public PageReference navigateToAppSetup(){
        
        return FunnelNavigationHelper.navigateToAppSetupPage('','','','','','');
        
    }
    
     public PageReference navigateToCertificateReports(){
        
        return FunnelNavigationHelper.navigateToCertificateReports('','','','','','');
        
    } 
     
    public PageReference navigateToAnalytics(){
        
        return FunnelNavigationHelper.navigateToFunnelAnalytic('','','','','','','');
        
    } 
     
}