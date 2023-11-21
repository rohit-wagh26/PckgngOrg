public with sharing class FunnelInstallationStep6Controller {

    public FunnelInstallationStep6Controller(FunnelAddEditCompanyLevel controller) {
        clList = new List<Company_Level__c>();
        clList = [Select id, Level_Name__c,Level_Value__c,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name,Sub_order__c from Company_Level__c order by order__c asc, Sub_order__c asc LIMIT 5000];
    }

    
    public List<Company_Level__c> clList{get;set;}
    
    public FunnelInstallationStep6Controller (){
        clList = new List<Company_Level__c>();
        clList = [Select id, Level_Name__c,Level_Value__c,Sales_Rep_Profile__c,Sub_order__c from Company_Level__c order by order__c asc, Sub_order__c asc Limit 5000];
    }
    
    public void save(){
        FunnelInstallationHelper.createPermsissions();
        
        update clList ;
        
    }
    
    public PageReference navigateToStep5b(){
        FunnelInstallationHelper.saveStep('6');
        save();
        return FunnelInstallationHelper.navigateToStep5b();
    
    }
    public PageReference navigateToStep7(){
        FunnelInstallationHelper.saveStep('6');
        save();
        
        return FunnelInstallationHelper.navigateToStep7();
    
    }
    
    public PageReference saveAndExit(){
        save();
        return FunnelInstallationHelper.navigateToChecklist();
    }
}