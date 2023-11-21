global with sharing class FunnelQualDataPull implements Database.Batchable<sobject>, Database.Stateful, Database.AllowsCallouts{
     
    public Database.QueryLocator start(Database.BatchableContext con){                
        
        return Database.getQueryLocator('SELECT Id FROM Sales_Rep_Profile__c WHERE Active__c = TRUE LIMIT 5000');
    }
    
    public void execute(Database.BatchableContext con, List<Sales_Rep_Profile__c> srp){
        //try{    
            
             /*FunnelGetApis fp = new FunnelGetApis();
             fp.getAccessToken();
             fp.getAndUpdateQualStatsSnap();*/
                              
        /*}
        catch(Exception ex){
            
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelQualDataPull '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
             
        }*/
           
    }
    
    public void finish(Database.BatchableContext con){
                                         
    }
}