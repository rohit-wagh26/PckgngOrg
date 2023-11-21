public with sharing class FetchFiscalYearController{
    
    public Date strtDate {get; set;}
    
    Fiscal_Year_Setting__c fy;
    
    public FetchFiscalYearController(){
        
        Fiscal_Year_Setting__c fy = FunnelTriggerBatchHelper.getFiscalYearRecord('Current_Year');
        
        if (fy != null){
        
            strtDate = fy.Start_Date__c;
        
        }
        else{
        
            List<Organization> org = [SELECT FiscalYearStartMonth FROM Organization Limit 1];
            
            Integer currYr = Date.today().year();
                
            Integer firstYr = currYr - 3;
                
            if(org != null && org.size() > 0 && org[0].FiscalYearStartMonth != null) {
                            
                Integer fisMnth = org[0].FiscalYearStartMonth; 
                
                strtDate = Date.newInstance(firstYr, fisMnth, 1);
            
                system.debug(' strtDate '+strtDate);    
            }
            else{
                
                Integer fisMnth = 1; 
                
                strtDate = Date.newInstance(firstYr, fisMnth, 1);
            }
            
        
        }
                  
        
               
    }
    
    public void updateSetting(){
        
        fy = FunnelTriggerBatchHelper.getFiscalYearRecord('Current_Year');
        
        if (fy != null){
            fy.Start_Date__c = strtDate;
            update fy;
        }
        else{
            fy = new Fiscal_Year_Setting__c ();
            fy.name = 'Current_Year';   
            fy.start_Date__c = strtDate;
            insert fy; 
        }
        
    }
}