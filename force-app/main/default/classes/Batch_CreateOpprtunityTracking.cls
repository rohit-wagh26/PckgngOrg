global class Batch_CreateOpprtunityTracking implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([select id,StageName,createddate, LastModifiedDate from opportunity where ForecastCategoryName != 'Omitted']);
    }
    global void execute(Database.BatchableContext BC, List<opportunity> OppList) {
        list<FunnelMetrics__OpportunityTrackingHistory__c> oppoTrack = new list<FunnelMetrics__OpportunityTrackingHistory__c>();
        list<FunnelMetrics__OpportunityTrackingHistory__c> oppoHist = new list<FunnelMetrics__OpportunityTrackingHistory__c>();
        oppoHist = [select id, Opportunity__c,OldValue__c,NewValue__c,Last_Date__c from OpportunityTrackingHistory__c];
        List<String> oppId = new List<String>();
        if(oppoHist != null && oppoHist.size()>0){
            for(OpportunityTrackingHistory__c o : oppoHist){
                oppId.add(o.Opportunity__c);
            }
        }
        
        for(Opportunity opp:OppList){
            if(!(oppId.Contains(opp.id))){
                system.debug('opp.id :: '+opp.id);
                system.debug('opp.StageName :: '+opp.StageName);
                system.debug('opp.createddate :: '+opp.createddate);
                FunnelMetrics__OpportunityTrackingHistory__c oppoTrack1=new FunnelMetrics__OpportunityTrackingHistory__c();
                oppoTrack1.FunnelMetrics__OldValue__c = opp.StageName;
                oppoTrack1.FunnelMetrics__NewValue__c = opp.StageName;
                oppoTrack1.name  = 'Stage';  
                oppoTrack1.FunnelMetrics__Last_Date__c = opp.createddate;
                oppoTrack1.FunnelMetrics__Opportunity__c=opp.Id;
                oppoTrack.add(oppoTrack1);
            }
        }        
        try{
            Database.SaveResult[] result = database.insert(oppoTrack);
            
        }Catch(Exception e){
            System.debug('line20:::'+e);
        }
        
    }   
    global void finish(Database.BatchableContext BC){
    }
}