/*
Copyright: Funnel Metrics, LLC
*/
global with Sharing class FunnelFSCalculation implements Database.Batchable<sobject>, Database.Stateful{
    
    List<Important_Rating__c> importantRating = [Select id,Certification_Rating__r.Field_Name__c, Certification_Rating__c,Importance_coefficient__c,Role__c,Importance_Flag__c,Intercept__c from Important_Rating__c where Importance_Flag__c >0];
    
    public Database.QueryLocator start(Database.BatchableContext con){
        
         return Database.getQueryLocator('Select id,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Role__c,Sales_Rep_Profile__r.X12_Month_Rolling_Opportunity_Close_Rate__c,Sales_Rep_Profile__r.Number_of_meetings_YTD_percentage__c,Sales_Rep_Profile__r.X12_Month_Rolling_Close_Rate__c,Sales_Rep_Profile__r.YTD_Opportunities_Added_percentage__c,Sales_Rep_Profile__r.Quarterly_Quota_Performance__c,Sales_Rep_Profile__r.YTD_Quota_Percentage__c,Sales_Rep_Profile__r.YTD_Close_Rate__c,Sales_Rep_Profile__r.Lead_to_Opportunity_Conversion_Rate__c,Sales_Rep_Profile__r.YTD_Opportunity_Close_Rate__c,Sales_Rep_Profile__r.YTD_Opportunities_Closed_percentage__c,Sales_Rep_Profile__r.Quarterly_Opp_added_to_Qualif_Percentage__c,Sales_Rep_Profile__r.Quarterly_Opportunitie_Closed_percentage__c,Sales_Rep_Profile__r.Quarterly_Opportunity_Close_Rate__c,Sales_Rep_Profile__r.Quarterly_Average_Win_Size__c,Sales_Rep_Profile__r.Number_of_meetings_per_quarte_percentage__c,Sales_Rep_Profile__r.X12_Month_Rolling_Opptys_Won_percentage__c,Sales_Rep_Profile__r.X12_Month_Opportunities_added_percentage__c,Sales_Rep_Profile__r.YTD_Average_win_size__c,Sales_Rep_Profile__r.Monthly_Quota_Performance__c,Sales_Rep_Profile__r.Number_of_meetings_per_month_percentage__c,Sales_Rep_Profile__r.Monthly_Close_Rate__c,Sales_Rep_Profile__r.Monthly_Opportunity_Close_Rate__c,Sales_Rep_Profile__r.Number_of_meetings_12_months_percentage__c,Sales_Rep_Profile__r.Monthly_Average_Win_size__c,Sales_Rep_Profile__r.X12_Month_Rolling_Quota_Performance__c,Sales_Rep_Profile__r.X12_Month_Average_Selling_Price__c,Sales_Rep_Profile__r.Monthly_Opportunities_Closed_percentage__c,Sales_Rep_Profile__r.Monthly_Opp_added_to_Qualif_Percentage__c,Sales_Rep_Profile__r.YTD_Average_Sales_Cycle__c from Certification__c where id IN (\'a041H00000gJo2E\',\'a041H00000gJo2Y\')');
    }
    
    
    public void execute(Database.BatchableContext con, List<Certification__c> cert){
        System.debug('cert'+cert);
        Map<String,List<Important_Rating__c>> roleRatingMap = generateRoleRatingMap(importantRating);
        
        for(Certification__c s : cert){
            
            Decimal rawFs = 0;
            System.debug('role'+s.Sales_Rep_Profile__r.Role__c); 
            
            for(Important_Rating__c r : roleRatingMap.get(s.Sales_Rep_Profile__r.Role__c)){
            
                if(rawFs == 0 && r.Intercept__c != null){
                    rawFs += r.Intercept__c;
                }
                if(s.Sales_Rep_Profile__r.get(r.Certification_Rating__r.Field_Name__c) != null && r.Importance_coefficient__c != null){
                    
                    rawFs += ((Decimal)s.Sales_Rep_Profile__r.get(r.Certification_Rating__r.Field_Name__c))* r.Importance_coefficient__c;
                }
            }
            s.Overall_Rating__c =rawFs;
            System.debug(s.Sales_Rep_Profile__r.name +' --> '+rawFs);
        }
    }
    
    public void finish(Database.BatchableContext con){
        
    }
    
    public Map<String,List<Important_Rating__c>> generateRoleRatingMap(List<Important_Rating__c> ratingList){
        
        Map<String,List<Important_Rating__c>> returnMap = new Map<String,List<Important_Rating__c>>();
        
        for(Important_Rating__c r : ratingList){
            
            if(returnMap.containsKey(r.Role__c)){
                returnMap.get(r.Role__c).add(r);
            }else{
                List<Important_Rating__c> rList = new List<Important_Rating__c>();
                rList.add(r);
                returnMap.put(r.Role__c,rList);
            }
        }
        system.debug(returnMap);
        return returnMap;
        
    }
    
}