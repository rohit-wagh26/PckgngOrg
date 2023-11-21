public with sharing class FMFilteredContainersController {
	@AuraEnabled(cacheable=true)
    public static List<Sales_Rep_Profile__c> getSalesRepProfiles(String companyLevel, String role){
        List<Sales_Rep_Profile__c> srList = new List<Sales_Rep_Profile__c>();

		if (String.isBlank(companyLevel))
			return srList;
		
		for (Sales_Profile_Company_Level_Junction__c spclj : [SELECT Sales_Rep_Profile__r.Id, Sales_Rep_Profile__r.Name,Sales_Rep_Profile__r.User_Record_Name__c, Sales_Rep_Profile__r.Active__c, Sales_Rep_Profile__r.Role__c, Sales_Rep_Profile__r.Annual_Quota_Amount__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__c = :companyLevel ORDER BY Sales_Rep_Profile__r.Name]) {
			if (String.isBlank(role) || role == 'All' || role == spclj.Sales_Rep_Profile__r.Role__c) {
				srList.add(spclj.Sales_Rep_Profile__r);
			}
		}

        return srList;
        
    }
}