public class CalculateScoreAggregatesOnCertifications{
    /*
    public static void findScoreAggregate() {
                        
        Map<String, Company_Level__c> levelMap = new Map<String, Company_Level__c>();
        List<Company_Level__c> clSnaps = [SELECT Level_Value__c, Certification__c FROM Company_Level__c LIMIT 5000];
        for(Company_Level__c c:clSnaps){
            levelMap.put(c.Level_Value__c,c);
        }
        
        List<Certification__c> certSnaps = [SELECT id, Overall_Rating__c,Overall_Qualitative_Rating__c FROM Certification__c LIMIT 5000];        
        Map<id, Certification__c> certMap = new Map<id, Certification__c>();

        for(Certification__c c:certSnaps ){
            certMap.put(c.id,c);
        }
        
        system.debug(certMap);
        
        List<AggregateResult> quanScoreAggr = [SELECT Company_Level__r.Level_Value__c v, AVG(Certification__r.Overall_quantitative_Rating__c) quan FROM Sales_profile_Company_Level_Junction__c GROUP BY Company_Level__r.Level_Value__c LIMIT 5000];
        system.debug('quanScoreAggr '+quanScoreAggr);
        
        for(AggregateResult ar: quanScoreAggr){
            system.debug(' level '+levelMap.get((String) ar.get('v')));
            certMap.get(levelMap.get((String) ar.get('v')).Certification__c).Overall_Rating__c = (Decimal)ar.get('quan');
            system.debug(' score '+(Decimal)ar.get('quan'));
        }        
        
        List<AggregateResult> qualScoreAggr = [SELECT Company_Level__r.Level_Value__c v, AVG(Certification__r.Individual_Qualitative_Rating__c) qual FROM Sales_profile_Company_Level_Junction__c GROUP BY Company_Level__r.Level_Value__c LIMIT 5000];
        system.debug('qualScoreAggr '+qualScoreAggr );
        
        for(AggregateResult ar: qualScoreAggr){
            system.debug(' level '+levelMap.get((String) ar.get('v')));
            certMap.get(levelMap.get((String) ar.get('v')).Certification__c).Overall_Qualitative_Rating__c = (Decimal)ar.get('qual');
            system.debug(' score '+(Decimal)ar.get('qual'));
        }
        
        update certMap.values();
        
        system.debug(certMap);
    }*/
}