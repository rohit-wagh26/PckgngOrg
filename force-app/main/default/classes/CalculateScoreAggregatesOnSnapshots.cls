public class CalculateScoreAggregatesOnSnapshots{
    /*
    public static void findScoreAggregate(Date triggerDt) {
                        
        Map<String, Company_Levels_snapshot__c> levelMap = new Map<String, Company_Levels_snapshot__c>();
        List<Company_Levels_snapshot__c> clSnaps = [SELECT Level_Value__c, Certification_Snapshot__c FROM Company_Levels_snapshot__c WHERE Snapshot_scheduled_date__c = :triggerDt];
        for(Company_Levels_snapshot__c c:clSnaps){
            levelMap.put(c.Level_Value__c,c);
        }
        
        List<Certification_Snapshot__c> certSnaps = [SELECT id, Overall_Rating__c,Overall_Qualitative_Rating__c FROM Certification_Snapshot__c WHERE Snapshot_scheduled_date__c = :triggerDt];        
        Map<id, Certification_Snapshot__c> certMap = new Map<id, Certification_Snapshot__c>();

        for(Certification_Snapshot__c c:certSnaps ){
            certMap.put(c.id,c);
        }
        
        system.debug(certMap);
        
        List<AggregateResult> quanScoreAggr = [SELECT Company_Levels_snapshot__r.Level_Value__c v, AVG(Certification_snapshot__r.Overall_quantitative_Rating__c) quan FROM Company_Level_Junction_snapshot__c WHERE Snapshot_scheduled_date__c = :triggerDt GROUP BY Company_Levels_snapshot__r.Level_Value__c];
        system.debug('quanScoreAggr '+quanScoreAggr);
        
        for(AggregateResult ar: quanScoreAggr){
            system.debug(' level '+levelMap.get((String) ar.get('v')));
            certMap.get(levelMap.get((String) ar.get('v')).Certification_Snapshot__c).Overall_Rating__c = (Decimal)ar.get('quan');
            system.debug(' score '+(Decimal)ar.get('quan'));
        }        
        
        List<AggregateResult> qualScoreAggr = [SELECT Company_Levels_snapshot__r.Level_Value__c v, AVG(Certification_snapshot__r.Individual_Qualitative_Rating__c) qual FROM Company_Level_Junction_snapshot__c WHERE Snapshot_scheduled_date__c = :triggerDt GROUP BY Company_Levels_snapshot__r.Level_Value__c];                
        
        for(AggregateResult ar: qualScoreAggr){
            system.debug(' level '+levelMap.get((String) ar.get('v')));
            certMap.get(levelMap.get((String) ar.get('v')).Certification_Snapshot__c).Overall_Qualitative_Rating__c = (Decimal)ar.get('qual');
            system.debug(' score '+(Decimal)ar.get('qual'));
        }
        
        //update certMap.values();
        
        system.debug(certMap);
    }*/
}