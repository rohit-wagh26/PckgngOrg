public with sharing class FunnelHelpPageHelper{

    public static List<Help_page__c > fetchHelpPage(String pageName){
        List<Help_page__c > hList = new List<Help_page__c >();
        hList = [Select help__c from Help_page__c where Name = :pageName];
        return hList ;
    }
}