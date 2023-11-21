global with sharing class FunnelPullScores implements Database.Batchable<sobject>, Database.Stateful, Database.AllowsCallouts{
     
    public Database.QueryLocator start(Database.BatchableContext con){                
        
        return Database.getQueryLocator('SELECT Id FROM Sales_Rep_Profile__c WHERE Active__c = TRUE LIMIT 5000');
    }
    
    public void execute(Database.BatchableContext con, List<Sales_Rep_Profile__c> srp){
        //try{    
            
            /*Set<id> srps = new Set<id>();
            for(Sales_rep_profile__c s: srp){
                srps.add(s.id);
            }*/
            
            //FunnelTriggerBatchHelper.fromBatch = true;

            /*FunnelGetApis fp = new FunnelGetApis();
            fp.getAccessToken();
            fp.getandUpdateFSQS();  */
                              
        /*}
        catch(Exception ex){
            
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelPullScores '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
             
        }*/
           
    }
    
    public void finish(Database.BatchableContext con){
                                         
    }
}