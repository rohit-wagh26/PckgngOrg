public with sharing class FunnelInstallationStep3bController {


     


     public PageReference navigateToStep3a(){
        //save();
        return FunnelInstallationHelper.navigateToStep3a();
    
    }
    
    public PageReference navigateToStep4a(){
        //saveAndExit();
        return FunnelInstallationHelper.navigateToStep4a();
     
    }
    
    public PageReference saveAndExit(){
        //save();
        return FunnelInstallationHelper.navigateToChecklist();
    }

}