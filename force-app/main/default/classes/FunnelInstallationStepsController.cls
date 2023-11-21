public  with sharing class FunnelInstallationStepsController {
    
    public Decimal Controllerstage{get;set;}
    
    
    public FunnelInstallationStepsController (){
        Controllerstage = 0;
        
        List<FM_Installation__mdt> installMdt = [SELECT Saved_Page__c,label FROM FM_Installation__mdt LIMIT 500];
        if(installMdt != null && installMdt.size()>0 ){
            Controllerstage = Decimal.valueof(installMdt[0].Saved_Page__c);
        }    
        
        for(integer i = 1; i<=9;i++){
            String pageName = ApexPages.currentPage().getUrl();
            if(pageName.contains('Step'+string.valueof(i)) && Controllerstage <i){
                Controllerstage = i;
            }
       }     
    
    }
    
    public PageReference navigateToStepOne(){
             
                return null;
             
        }

}