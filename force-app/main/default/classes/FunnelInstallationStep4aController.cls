public with sharing class FunnelInstallationStep4aController {
    
     
     
    public PageReference navigateToStep3b(){
        //save();
        return FunnelInstallationHelper.navigateToStep3a();
    
    }
    
    public PageReference navigateToStep4b(){
        FunnelInstallationHelper.saveStep('4');
        return FunnelInstallationHelper.navigateToStep4b();
     
    }
    
    public PageReference saveAndExit(){
        //save();
        return FunnelInstallationHelper.navigateToChecklist();
    }


}