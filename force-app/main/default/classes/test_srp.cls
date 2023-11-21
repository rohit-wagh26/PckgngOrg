public with sharing class test_srp {
    Public List <Sales_Rep_Profile__c> srpList {get;set;}
    
    public test_srp(){
        srpList = [Select id,Name,User_Record_Name__c,User_Record_Name__r.username,Profile_Type__c,Sales_Manager__c,Sales_Manager__r.Name from Sales_Rep_Profile__c LIMIT 100];
    }
}