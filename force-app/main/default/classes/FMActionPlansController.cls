public with sharing class FMActionPlansController {
    @AuraEnabled(cacheable=true)
    public static List<Action_Plan__c> getActionPlans(List<Sales_Rep_Profile__c> salesRepProfiles){
        return [SELECT Id, Employee_Name__c, FunnelMetrics__Due_Date__c, Name, Sales_Rep_Profile__r.Name FROM Action_Plan__c WHERE Sales_Rep_Profile__c IN :salesRepProfiles];      
    }
}