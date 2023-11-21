trigger FunnelActionPlanSnapshotTrigger on FunnelMetrics__Action_Plan_Snapshot__c (after insert){
    
    Set<id> actionPlanId = new Set<id>();
    for(Action_Plan_Snapshot__c aps : Trigger.new){
        actionPlanId.add(aps.Action_Plan__c );
    }
    if(actionPlanId!= null && actionPlanId.size()>0){
        FunnelTriggerBatchHelper.deleteActionPlanSnapshots(actionPlanId);
    }
}