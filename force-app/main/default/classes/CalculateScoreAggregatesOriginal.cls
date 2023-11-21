public class CalculateScoreAggregatesOriginal{
    /*
    public static void findQuantScoreAggregate() {
    
        List<AggregateResult> quanScoreAggr = [SELECT Company_Level__r.Level_Value__c v, AVG(Certification__r.Overall_Quantitative_Rating__c) quan FROM Sales_Profile_Company_Level_Junction__c where Certification__r.Total_Quantitative_Weight__c > 0  GROUP BY Company_Level__r.Level_Value__c];
        system.debug('quanScoreAggr '+quanScoreAggr);
        
        Map<String,Decimal> mapValQuan = new Map<String,Decimal>();
        
        for(AggregateResult ar: quanScoreAggr){
            mapValQuan.put((String)ar.get('v'),(Decimal)ar.get('quan'));
        }
                
        List<AggregateResult> qualScoreAggr = [SELECT Company_Level__r.Level_Value__c v, AVG(Certification__r.Individual_Qualitative_Rating__c) qual FROM Sales_Profile_Company_Level_Junction__c where Certification__r.Total_Qualitative_Weight__c > 0  GROUP BY Company_Level__r.Level_Value__c];
        system.debug('qualScoreAggr'+qualScoreAggr);
        
        Map<String,Decimal> mapValQual = new Map<String,Decimal>();
        
        for(AggregateResult ar: qualScoreAggr){
            mapValQual.put((String)ar.get('v'),(Decimal)ar.get('qual'));
        }                
        
        List<Company_Level__c> cls = [SELECT Certification__c, Certification__r.name, Certification__r.Overall_Rating__c, Level_Value__c FROM Company_Level__c LIMIT 5000 ];        
        
        List<Certification__c> crmnglist = new List<Certification__c>();
        
        for(Company_Level__c cl: cls){ 
            
            Certification__c updateMng = new Certification__c(); 
            updateMng.id = cl.Certification__c;            
            system.debug(' certification name '+cl.Certification__r.name);
            if(mapValQuan.get(cl.Level_Value__c) != null){    
                updateMng.Overall_Rating__c  = mapValQuan.get(cl.Level_Value__c);
                system.debug(' overall rating '+updateMng.Overall_Rating__c);  
            } 
                                  
            if(mapValQual.get(cl.Level_Value__c) != null){    
                updateMng.Overall_Qualitative_Rating__c = mapValQual.get(cl.Level_Value__c);
                system.debug(' overall qual rating '+updateMng.Overall_Qualitative_Rating__c);  
                
            }            
            
            crmnglist.add(updateMng);      
        }
        
        system.debug(' crmnglist '+crmnglist);
        update crmnglist;
    }*/
}