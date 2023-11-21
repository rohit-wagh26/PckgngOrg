trigger FunnelActionPlanTrigger on FunnelMetrics__Action_Plan__c (after update) {
    
    List<Action_Plan__c> ActionPlanList = new List<Action_Plan__c>();
    
    for(Action_Plan__c a: Trigger.new){
        if( Trigger.oldMap.get(a.id).Action_Step__c  != Trigger.newMap.get(a.id).Action_Step__c || Trigger.oldMap.get(a.id).Active__c != Trigger.newMap.get(a.id).Active__c || Trigger.oldMap.get(a.id).Custom_Field_1__c != Trigger.newMap.get(a.id).Custom_Field_1__c || Trigger.oldMap.get(a.id).Custom_Field_2__c != Trigger.newMap.get(a.id).Custom_Field_2__c ||Trigger.oldMap.get(a.id).Custom_Field_3__c != Trigger.newMap.get(a.id).Custom_Field_3__c || Trigger.oldMap.get(a.id).Due_Date__c != Trigger.newMap.get(a.id).Due_Date__c  || Trigger.oldMap.get(a.id).Employee_Name__c != Trigger.newMap.get(a.id).Employee_Name__c || Trigger.oldMap.get(a.id).Employee_Response__c != Trigger.newMap.get(a.id).Employee_Response__c || Trigger.oldMap.get(a.id).Manager_Name__c != Trigger.newMap.get(a.id).Manager_Name__c || Trigger.oldMap.get(a.id).Measurement_Criteria__c != Trigger.newMap.get(a.id).Measurement_Criteria__c || Trigger.oldMap.get(a.id).Metric_Skill__c != Trigger.newMap.get(a.id).Metric_Skill__c || Trigger.oldMap.get(a.id).Notes__c != Trigger.newMap.get(a.id).Notes__c || Trigger.oldMap.get(a.id).Period__c != Trigger.newMap.get(a.id).Period__c || Trigger.oldMap.get(a.id).Result__c != Trigger.newMap.get(a.id).Result__c || Trigger.oldMap.get(a.id).Result_Rating__c != Trigger.newMap.get(a.id).Result_Rating__c || Trigger.oldMap.get(a.id).Sales_Rep_Profile__c != Trigger.newMap.get(a.id).Sales_Rep_Profile__c || Trigger.oldMap.get(a.id).Status__c != Trigger.newMap.get(a.id).Status__c  ){
           ActionPlanList.add(Trigger.oldMap.get(a.id));
            
        }
    }
    
    if(ActionPlanList != null && ActionPlanList.size() > 0){
         FunnelTriggerBatchHelper.createActionPlanSnapshot(ActionPlanList);
    }
     
}