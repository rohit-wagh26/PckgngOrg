global with sharing class FunnelPushQuantData implements Database.Batchable<sobject>, Database.Stateful, Database.AllowsCallouts{
    
    //Date snapDate;
    
    //Boolean errorVal = false;
    
    public FunnelPushQuantData(){
        
        /*List<Sales_Rep_Profile_Snapshot__c> snapshotRecsToBeInserted = new List<Sales_Rep_Profile_Snapshot__c>();   
            
        List<Sales_rep_profile_snapshot__c> snaps = new List<Sales_rep_profile_snapshot__c>();
        
        snaps = [SELECT Snapshot_scheduled_date__c FROM Sales_rep_profile_snapshot__c ORDER BY Snapshot_scheduled_date__c DESC LIMIT 1];
        
        if(snaps != null && snaps.size()>0){
            snapDate = snaps[0].Snapshot_scheduled_date__c;   
        }*/
         
    }
    
    //public static String prefix{ get{return '';} set; }

    public Database.QueryLocator start(Database.BatchableContext con){                
        
        return Database.getQueryLocator('SELECT Id FROM Sales_Rep_Profile__c WHERE Active__c = TRUE AND Dont_send_to_model__c = False  AND YTD_Quota__c > 0 AND Profile_Type__c != \'Overlay\' AND Tenure__c > 1  AND Rep_Staus__c = \'Tenured\' LIMIT 5000');
    }
    
    public void execute(Database.BatchableContext con, List<Sales_Rep_Profile__c> srp){
        /*try{    
            
            if(snapDate != null){
                
                Set<id> sid = new Set<id>();
                Set<id> srIds= new Set<id>();
                
                for(Sales_Rep_Profile__c s: srp){
                    sid.add(s.id);
                }
                
                List<AggregateResult> srpsSnap = [SELECT COUNT(id) c, Sales_rep_profile__c o FROM Sales_rep_profile_snapshot__c WHERE Monthly_Quota_Revenue__c >0 AND Sales_rep_profile__c IN :sid  GROUP BY Sales_rep_profile__c HAVING Count(Id) >= 2];
                
                for( AggregateResult r : srpsSnap ){
                    srIds.add((Id)r.get('o'));
                }
                
                List<Sales_rep_profile__c> srpsSend = [SELECT Id FROM Sales_Rep_Profile__c where ID IN :srIds];*/
                
                /*if(srpsSend != null && srpsSend.size()>0){
                    //FunnelPostAPIs fp = new FunnelPostAPIs();
                    //fp.getAccessToken();        
                    //fp.dtSnapShot = snapDate;
                    //fp.createQuantMetric(srpsSend);
                    //system.debug(' fp.msg '+fp.msg);
                }*/
               
            /*}      
                              
        }
        catch(Exception ex){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelPushQuantData '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            system.debug(' error has occured '+ex.getMessage());
        }*/
           
    }
    
    public void finish(Database.BatchableContext con){
                                         
    }
}