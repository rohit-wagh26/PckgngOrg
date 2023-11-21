public with sharing class FunnelInstallationStep7Controller {

    public   FunnelInstallationStep7Controller() {
    
     }
     
     
    
    public PageReference navigateToStep6(){
        //save();
        return FunnelInstallationHelper.navigateToStep6();
    
    }
    
    public PageReference navigateToStep8(){
        
        Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues('Historic_Year');
        Fiscal_Year_Setting__c fyc = Fiscal_Year_Setting__c.getValues('Current_Year');
        if(fy != null && fyc !=null){
            fyc.Start_Date__c = fy.Start_Date__c;
            update fyc;
        }
        FunnelInstallationHelper.saveStep('7');
        return FunnelInstallationHelper.navigateToStep8();
     
    }

    public PageReference saveAndExit(){
        //save();
        FunnelInstallationHelper.saveStep('7');
        return FunnelInstallationHelper.navigateToChecklist();
    }

}