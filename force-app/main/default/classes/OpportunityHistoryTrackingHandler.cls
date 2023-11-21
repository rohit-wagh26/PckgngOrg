public class OpportunityHistoryTrackingHandler {
public Static void onAfterUpdate(List<Opportunity> OppList,Map<Id,Opportunity> OppOldMap){
    OpportunityHistoryTrackingBL.trackChanges(OppList,OppOldMap); }
}