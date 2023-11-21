/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelUserReportController{
 /*   
    public FunnelUserReportController(){
    
    }
    
    public List<User> usersWithNoMgr {get; set;}
    
    public List<User> usersWithNoTitle {get; set;}
    
    public Id userIdVal {get; set;}
    
    public User u {get; set;}
    
    public void displayResults(){
        
        usersWithNoMgr = new List<User>();
        usersWithNoTitle = new List<User>();
        
        usersWithNoMgr = [SELECT id, name FROM User WHERE isActive = true AND ManagerId = null];
        
        usersWithNoTitle = [SELECT id, name FROM User WHERE isActive = true AND (Title = null OR Title = '')];        
    }
    */
   
   /* /*
    public PageReference checkThemeAndNavigate(){        
        
        u = [SELECT Name, UserPreferencesLightningExperiencePreferred FROM User WHERE id = :UserInfo.getUserId()];
        
        if(u.UserPreferencesLightningExperiencePreferred && UserInfo.getUiThemeDisplayed() == 'Theme3'){            
            PageReference p = new PageReference('/one/one.app#/alohaRedirect/apex/FunnelUserReport');
            return p;
        }
        else{
            return null;
        }
        
    }/**/ 
    
   /* public PageReference navigate(){
        system.debug(' userIdVal '+userIdVal);
        PageReference p;
        
        if(u.UserPreferencesLightningExperiencePreferred){
            p = new PageReference('/one/one.app#/alohaRedirect/'+userIdVal+'?noredirect=1&isUserEntityOverride=1');            
        }
        else{
            String s = 'https://'+URL.getSalesforceBaseUrl().getHost()+'/'+userIdVal;
            system.debug(' s '+s);
            
            p = new PageReference('/'+userIdVal+'?noredirect=1&isUserEntityOverride=1');
        }    
        
        return p;
    } */
}