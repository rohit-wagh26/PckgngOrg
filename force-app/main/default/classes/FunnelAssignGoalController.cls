/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelAssignGoalController {

    public string selectedValue { get;set; }
    string defaultRole;
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    public Decimal Month1{get;set;}
    public Decimal Month2{get;set;}
    public Decimal Month3{get;set;}
    public Decimal Month4{get;set;}
    public Decimal Month5{get;set;}
    public Decimal Month6{get;set;}
    public Decimal Month7{get;set;}
    public Decimal Month8{get;set;}
    public Decimal Month9{get;set;}
    public Decimal Month10{get;set;}
    public Decimal Month11{get;set;}
    public Decimal Month12{get;set;}
    
    public Decimal asp{get;set;}
    public Decimal ltocr{get;set;}
    public Decimal lsc{get;set;}
    public Decimal rcr{get;set;}
    public Decimal mm{get;set;}
    
    
    public FunnelAssignGoalController(){
        getRole();   
        selectedValue = defaultRole;
        Month1 = 0;
        Month2 = 0;
        Month3 = 0;
        Month4 = 0;
        Month5 = 0;
        Month6 = 0;
        Month7 = 0;
        Month8 = 0;
        Month9 = 0;
        Month10 = 0;
        Month11 = 0;
        Month12 = 0;
        
        asp = 0;
        ltocr = 0;
        lsc = 0;
        rcr = 0;
        mm = 0;
    }
    
    public List<SelectOption>  getRole() {
       
       List<SelectOption> Options = new List<SelectOption>();
           
       Schema.DescribeFieldResult statusFieldDescription = Sales_Rep_Profile__c.Role__c.getDescribe();
       
     
       for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues())
       {
           Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
       }
       defaultRole= string.valueOf(options[0].getvalue());
       system.debug('defaultRole---' +defaultRole);
       return Options ;
   }
    
    public void updateQuota(){
        
        List<Sales_Rep_Profile__c> splist = new List<Sales_Rep_Profile__c>();
        splist = [select id, Month_1_Quota_Amount__c,Month_2_Quota_Amount__c,Month_3_Quota_Amount__c,Month_4_Quota_Amount__c,Month_5_Quota_Amount__c,Month_6_Quota_Amount__c,Month_7_Quota_Amount__c,Month_8_Quota_Amount__c,Month_9_Quota_Amount__c,Month_10_Quota_Amount__c,Month_11_Quota_Amount__c,Month_12_Quota_Amount__c,Goal_12m_Avg_Selling_Price__c,Goal_12m_Lead_To_Opp_Conv_Rate__c,Goal_12m_length_of_sales_cycle__c,Goal_12m_rolling_close_rate__c,Goal_of_monthly_meetings__c from Sales_Rep_Profile__c where Role__c =:selectedValue AND Active__c = TRUE];
       
        for(Sales_Rep_Profile__c s: splist){
            s.Month_1_Quota_Amount__c = Month1;
            s.Month_2_Quota_Amount__c = Month2;
            s.Month_3_Quota_Amount__c = Month3;
            s.Month_4_Quota_Amount__c = Month4;
            s.Month_5_Quota_Amount__c = Month5;
            s.Month_6_Quota_Amount__c = Month6;
            s.Month_7_Quota_Amount__c = Month7;
            s.Month_8_Quota_Amount__c = Month8;
            s.Month_9_Quota_Amount__c = Month9;
            s.Month_10_Quota_Amount__c = Month10;
            s.Month_11_Quota_Amount__c = Month11;
            s.Month_12_Quota_Amount__c = Month12;
            
            s.Goal_12m_Avg_Selling_Price__c= asp;
            s.Goal_12m_Lead_To_Opp_Conv_Rate__c= ltocr;
            s.Goal_12m_length_of_sales_cycle__c= lsc;
            s.Goal_12m_rolling_close_rate__c= rcr;
            s.Goal_of_monthly_meetings__c= mm;
             
            
        }
        
        if(Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile__c').getDescribe().isUpdateable()){      
            update splist;
        }
    }
}