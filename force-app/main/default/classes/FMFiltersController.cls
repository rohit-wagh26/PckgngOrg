public with sharing class FMFiltersController {
	private static final String PICKLISTVALUESET_ROLE = 'role';
	private static final String ROLE_ALL = 'All';

	@AuraEnabled(cacheable=true)
	public static FilterConfig getFilterConfig() {
		Boolean isAdmin = true;
		FilterConfig returnFc = new FilterConfig();
		returnFc.companyLevels = new List<FilterItem>();
		returnFc.roles = new List<SelectOption>{ new SelectOption(ROLE_ALL, ROLE_ALL)};

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

		for (PicklistValueSet__c pvs : [SELECT Id, Name, Values__c FROM PicklistValueSet__c WHERE Name = :PICKLISTVALUESET_ROLE]) {
			if (String.isBlank(pvs.Values__c)) {
				continue;
			}

			for (String value : pvs.Values__c.split(';')) {
				returnFc.roles.add(new SelectOption(value.trim(), value.trim()));
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

		public SelectOption() { }

		public SelectOption(String label, String value) {
			this.label = label;
			this.value = value;
		}
	}
}