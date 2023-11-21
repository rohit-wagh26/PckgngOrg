public with sharing class FMFilterController {
    public FMFilterController() {

    }
    @AuraEnabled(cacheable=true)
	public static FilterConfig getFilterConfig() {
		Boolean isAdmin = true;
		FilterConfig returnFc = new FilterConfig();
		returnFc.companyLevels = new List<FilterItem>();

		Map<String, List<FilterItem>> filterItems = new Map<String, List<FilterItem>>();

		List<Company_Level__c> cls = [SELECT Id, Name, Sales_Rep_Profile__c, Sales_Rep_Profile__r.Name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.User_Record_Name__c, Order__c, Sub_order__c, Level_Name__c, Level_Value__c, Picklist_Name__c, CreatedDate FROM Company_Level__c WHERE Sales_Rep_Profile__c != null ORDER BY Level_Value__c];
		
		for (Company_Level__c cl : cls) {
			FilterItem fi = new FilterItem(cl);

			if (filterItems.containsKey(cl.Sales_Rep_Profile__c)) {
				filterItems.get(cl.Sales_Rep_Profile__c).add(fi);
			} else {
				filterItems.put(cl.Sales_Rep_Profile__c, new List<FilterItem>{ fi });
			}

			if (cl.Sales_Rep_Profile__r.User_Record_Name__c == UserInfo.getUserId() || (isAdmin && String.isBlank(cl.Sales_Rep_Profile__r.Sales_Manager__c))) {
				returnFc.companyLevels.add(fi);
			}
		}

		for (Company_Level__c cl : cls) {
			if (!filterItems.containsKey(cl.Sales_Rep_Profile__r.Sales_Manager__c)) {
				continue;
			}

			for (FilterItem fi : filterItems.get(cl.Sales_Rep_Profile__r.Sales_Manager__c)) {
				Set<String> itemIds = new Set<String>();
				for (FilterItem fii : fi.items) {
					itemIds.add(fii.name);
				}

				for (FilterItem fiii : filterItems.get(cl.Sales_Rep_Profile__c)) {
					if (!itemIds.contains(fiii.name)) {
						fi.items.add(fiii);
					}
				}
			}
		}

		return returnFc;
	}

	public class FilterConfig {
		@AuraEnabled
		public List<FilterItem> companyLevels {get; set;}
		@AuraEnabled
		public List<SelectOption> roles {get; set;}

		public FilterConfig() { }
	}

	public class FilterItem {
		@AuraEnabled
		public String label {get; set;}
		@AuraEnabled
		public String name {get; set;}
		@AuraEnabled
		public String managerName {get; set;}
		@AuraEnabled
		public Boolean expanded {get; set;}
		@AuraEnabled
		public Boolean disabled {get; set;}
		@AuraEnabled
		public List<FilterItem> items {get; set;}

		public FilterItem() { 
			this.expanded = true;
			this.items = new List<FilterItem>();
		}

		public FilterItem(Company_Level__c companyLevel) {
			this();
			this.label = companyLevel.Level_Value__c;
			this.name = companyLevel.Id;
			this.managerName = companyLevel.Sales_Rep_Profile__r.Name;
		}
	}

	public class SelectOption {
		@AuraEnabled
		public String label {get; set;}
		@AuraEnabled
		public String value {get; set;}
	}
}