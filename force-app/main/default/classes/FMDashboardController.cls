public with sharing class FMDashboardController {
    
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getOpportunityCount(List<Sales_Rep_Profile__c> salesRepProfiles) {
        Set<Id> userIdSet = new Set<Id>();
        System.debug(salesRepProfiles);
        For(Sales_Rep_Profile__c sp : salesRepProfiles){
            userIdSet.add(sp.User_Record_Name__c);
        }
        System.debug('userIdSet == '+userIdSet);
        List<AggregateResult> oppList = [SELECT SUM(Amount) totalAmount,StageName, COUNT(Id) oppCount FROM Opportunity WHERE OwnerId IN :userIdSet GROUP BY StageName];
        return oppList;
    }


}