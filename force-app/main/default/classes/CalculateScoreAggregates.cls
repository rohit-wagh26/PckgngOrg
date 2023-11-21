/*
Copyright: Funnel Metrics, LLC
*/
public with Sharing class CalculateScoreAggregates{
    
    public static boolean modelDataPull = false;
    /*
    public static void findQuantScoreAggregate() {
        
        Date trigDt = Date.newInstance(2018,05,31);
        
        List<Certification__c> certList = [SELECT id, name, Overall_Quantitative_Rating__c, Individual_Qualitative_Rating__c FROM Certification__c LIMIT 5000];
        Map<string,Certification__c> cerMap = new Map<string,Certification__c>();
        
        for(Certification__c c:certList ){
            cerMap.put(c.name,c);
        }
        
        List<Certification_Snapshot__c> cerSnapList = [SELECT id, name, Certification__c, Overall_Quantitative_Rating__c, Individual_Qualitative_Rating__c FROM Certification_Snapshot__c WHERE Snapshot_Scheduled_Date__c = :trigDt];
        Map<string,Certification_Snapshot__c> snapMap = new Map<string,Certification_Snapshot__c>();
        
        for(Certification_Snapshot__c c: cerSnapList ){
            snapMap.put(c.name,c);
        }
        
        for(Certification_Snapshot__c cs: cerSnapList){
            cerMap.get(cs.name).Overall_Quantitative_Rating__c = cs.Overall_Quantitative_Rating__c;
            cerMap.get(cs.name).Individual_Qualitative_Rating__c = cs.Individual_Qualitative_Rating__c;
        }
        
        update cerMap.values();
                                       
        List<AggregateResult> quanScoreAggr = [SELECT Company_Level__r.Level_Value__c v, AVG(Certification__r.Overall_Quantitative_Rating__c) quan FROM Sales_Profile_Company_Level_Junction__c where Sales_rep_profile__r.Active__c = TRUE GROUP BY Company_Level__r.Level_Value__c];
        
        Map<String,Decimal> mapValQuan = new Map<String,Decimal>();
        
        for(AggregateResult ar: quanScoreAggr){
            mapValQuan.put((String)ar.get('v'),(Decimal)ar.get('quan'));
        }
        
        List<AggregateResult> qualScoreAggr = [SELECT Company_Level__r.Level_Value__c v, AVG(Certification__r.Individual_Qualitative_Rating__c) qual FROM Sales_Profile_Company_Level_Junction__c WHERE Sales_rep_profile__r.Active__c = TRUE GROUP BY Company_Level__r.Level_Value__c LIMIT 5000];
        
        Map<String,Decimal> mapValQual = new Map<String,Decimal>();
        
        for(AggregateResult ar: qualScoreAggr){
            mapValQual.put((String)ar.get('v'),(Decimal)ar.get('qual'));
        }
        
        List<Company_Level__c> cls = [SELECT Certification__c,Certification__r.Overall_Rating__c, Level_Value__c FROM Company_Level__c LIMIT 5000];        
        
        List<Certification__c> crmnglist = new List<Certification__c>();
        
        for(Company_Level__c cl: cls){ 
            
            Certification__c updateMng = new Certification__c(); 
            updateMng.id = cl.Certification__c;
            
            if(mapValQual.get(cl.Level_Value__c) != null){    
                updateMng.Overall_Rating__c  = mapValQual.get(cl.Level_Value__c);
            } 
            
            if(mapValQuan.get(cl.Level_Value__c) != null){    
                updateMng.Overall_Qualitative_Rating__c = mapValQuan.get(cl.Level_Value__c);
            }
            
            crmnglist.add(updateMng);      
        }
        
        update crmnglist;                                
        
        certList = [SELECT id, name, Overall_Rating__c, Overall_Qualitative_Rating__c FROM Certification__c LIMIT 5000];
        cerMap = new Map<string,Certification__c>();
        
        for(Certification__c c:certList ){
            cerMap.put(c.name,c);
        }
        
        cerSnapList = [SELECT id, name, Certification__c, Overall_Rating__c, Overall_Qualitative_Rating__c FROM Certification_Snapshot__c WHERE Snapshot_Scheduled_Date__c = :trigDt];
        snapMap = new Map<string,Certification_Snapshot__c>();
        
        for(Certification_Snapshot__c c: cerSnapList ){
            snapMap.put(c.name,c);
        }
        
        for(Certification__c  c: certList){
            snapMap.get(c.name).Overall_Rating__c= c.Overall_Rating__c;
            snapMap.get(c.name).Overall_Qualitative_Rating__c = c.Overall_Qualitative_Rating__c;
        }
        
        update snapMap.values();
    }*/
    
    /*
    @future
    public static void findScoreAggregate(List<id> cerIds) {
        
        List<id> profs = new List<id>();
        
        List<Certification__c> certs = [SELECT Sales_rep_profile__c FROM Certification__C WHERE id IN:cerIds AND Sales_rep_profile__r.Active__c = TRUE];
        for(Certification__c c:certs){
            profs.add(c.Sales_rep_profile__c);
        }
        
        List<Sales_Profile_Company_Level_Junction__c> juncs = [SELECT Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Sales_rep_profile__c IN :profs AND Sales_rep_profile__r.Active__c = TRUE];
        List<String> levels = new List<String>();
        for(Sales_Profile_Company_Level_Junction__c j:juncs){
            levels.add(j.Company_Level__r.Level_Value__c);
        }
                                
        List<AggregateResult> quanScoreAggr = [SELECT Company_Level__r.Level_Value__c v, AVG(Certification__r.Overall_Quantitative_Rating__c) quan FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels AND Sales_rep_profile__r.Active__c = TRUE GROUP BY Company_Level__r.Level_Value__c];
        
        Map<String,Decimal> mapValQuan = new Map<String,Decimal>();
        
        for(AggregateResult ar: quanScoreAggr){
            mapValQuan.put((String)ar.get('v'),(Decimal)ar.get('quan'));
        }
                
        List<AggregateResult> qualScoreAggr = [SELECT Company_Level__r.Level_Value__c v, AVG(Certification__r.Individual_Qualitative_Rating__c) qual FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels AND Sales_rep_profile__r.Active__c = TRUE GROUP BY Company_Level__r.Level_Value__c];
        
        Map<String,Decimal> mapValQual = new Map<String,Decimal>();
        
        for(AggregateResult ar: qualScoreAggr){
            mapValQual.put((String)ar.get('v'),(Decimal)ar.get('qual'));
        }                
        
        List<Company_Level__c> cls = [SELECT Certification__c, Certification__r.name, Certification__r.Overall_Rating__c, Level_Value__c FROM Company_Level__c WHERE Sales_rep_profile__r.Active__c = TRUE LIMIT 5000];        
        
        Map<id,Certification__c> crMap = new Map<id,Certification__c>([SELECT id, Overall_Rating__c, Overall_Qualitative_Rating__c FROM Certification__c WHERE Sales_rep_profile__r.Active__c = TRUE LIMIT 5000]);                        
        
        for(Company_Level__c cl: cls){ 
            
            if(mapValQuan.get(cl.Level_Value__c) != null){    
                
                if(crMap.get(cl.Certification__c) != null)
                    crMap.get(cl.Certification__c).Overall_Rating__c  = mapValQuan.get(cl.Level_Value__c);
                
            }                         
                                  
            if(mapValQual.get(cl.Level_Value__c) != null){    
                
                if(crMap.get(cl.Certification__c) != null)
                    crMap.get(cl.Certification__c).Overall_Qualitative_Rating__c = mapValQual.get(cl.Level_Value__c);
                
            }            
            
        }       
        
        update crMap.values();
        
        //if(modelDataPull){                          
             
             Map<id,Certification__c> certMap = new Map<id,Certification__c> ([SELECT id,Individual_Qualitative_Rating__c,Overall_Qualitative_Rating__c,Overall_Quantitative_Rating__c,Overall_Rating__c FROM Certification__c WHERE Sales_rep_profile__r.Active__c = TRUE LIMIT 5000]);
                              
             List<Certification_snapshot__c> certSnaps = [SELECT id, Snapshot_scheduled_date__c FROM Certification_snapshot__c WHERE Sales_rep_profile__r.Active__c = TRUE ORDER BY Snapshot_scheduled_date__c DESC LIMIT 1];
                              
             if(certSnaps != null && certSnaps.size() > 0){
             
                 certSnaps = [SELECT id, Certification__c FROM Certification_snapshot__c WHERE Snapshot_scheduled_date__c = :certSnaps[0].Snapshot_scheduled_date__c];
                 
                 for(Certification_snapshot__c cs: certSnaps){
                     if(certMap.get(cs.Certification__c) != null){
                        
                         cs.Individual_Qualitative_Rating__c = certMap.get(cs.Certification__c).Individual_Qualitative_Rating__c;
                         cs.Overall_Qualitative_Rating__c = certMap.get(cs.Certification__c).Overall_Qualitative_Rating__c;
                         cs.Overall_Quantitative_Rating__c = certMap.get(cs.Certification__c).Overall_Quantitative_Rating__c;
                         cs.Overall_Rating__c = certMap.get(cs.Certification__c).Overall_Rating__c;        
                                                  
                     }            
                 }
                 update certSnaps;                    
             }
        //}
    }*/
    
    @future
    public static void findScoreAggregate(List<id> cerIds) {
        
        List<id> profs = new List<id>();
        
        //Fetch sales profiles associated with Certification records
        List<Certification__c> certs = [SELECT Sales_rep_profile__c FROM Certification__C WHERE id IN:cerIds AND Sales_rep_profile__r.Active__c = TRUE];
        for(Certification__c c:certs){
            profs.add(c.Sales_rep_profile__c);
        }
        
        //Fetch the company levels associated with all the updated sales profiles
        List<Sales_Profile_Company_Level_Junction__c> juncs = [SELECT Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Sales_rep_profile__c IN :profs AND Sales_rep_profile__r.Active__c = TRUE];
        List<String> levels = new List<String>();
        for(Sales_Profile_Company_Level_Junction__c j:juncs){
            levels.add(j.Company_Level__r.Level_Value__c);
        }        
        
        //Fetch the total quota for each level                        
        List<AggregateResult> quanScoreAggr = [SELECT Company_Level__r.Level_Value__c v, AVG(Certification__r.Overall_Quantitative_Rating__c) quan, AVG(Certification__r.Individual_Qualitative_Rating__c) qual, SUM(Sales_rep_profile__r.Annual_quota_amount__c) tq FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels AND Sales_rep_profile__r.Active__c = TRUE AND Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' GROUP BY Company_Level__r.Level_Value__c];
                
        Map<String,Decimal> mapTotalQuota = new Map<String,Decimal>();
        
        for(AggregateResult ar: quanScoreAggr){
            mapTotalQuota.put((String)ar.get('v'),(Decimal)ar.get('tq'));
        }
        
        List<AggregateResult> qualScoreAggr = [SELECT Company_Level__r.Level_Value__c v, AVG(Certification__r.Overall_Quantitative_Rating__c) quan, AVG(Certification__r.Individual_Qualitative_Rating__c) qual, SUM(Sales_rep_profile__r.Annual_quota_amount__c) tq FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels AND Sales_rep_profile__r.Active__c = TRUE GROUP BY Company_Level__r.Level_Value__c];
                
        Map<String,Decimal> mapTotalQuotaQual = new Map<String,Decimal>();
        
        for(AggregateResult ar: qualScoreAggr){
            mapTotalQuotaQual.put((String)ar.get('v'),(Decimal)ar.get('tq'));
        }
        
        system.debug(' mapTotalQuota '+mapTotalQuota);
        
        Map<String,Decimal> levelQualScoreMap = new Map<String,Decimal> ();
        Map<String,Decimal> levelQuanScoreMap = new Map<String,Decimal> ();
        //Fetch the sales profile junction records that are associated with the levels that need to be updated along with the individual quota
        List<Sales_Profile_Company_Level_Junction__c> juncts = [SELECT id, Sales_rep_profile__r.Annual_quota_amount__c , Certification__r.Overall_quantitative_rating__c, Certification__r.Individual_qualitative_rating__c, Company_level__r.Level_value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_level__r.Level_value__c IN :levels AND Sales_rep_profile__r.Active__c = TRUE AND Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' AND Sales_rep_profile__r.YTD_Quota__c > 0];
        List<Sales_Profile_Company_Level_Junction__c> junctsQual = [SELECT id, Sales_rep_profile__r.Annual_quota_amount__c , Certification__r.Overall_quantitative_rating__c, Certification__r.Individual_qualitative_rating__c, Company_level__r.Level_value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_level__r.Level_value__c IN :levels AND Sales_rep_profile__r.Active__c = TRUE AND Sales_rep_profile__r.YTD_Quota__c > 0];
        
        for(Sales_Profile_Company_Level_Junction__c s:juncts){
            if(!levelQuanScoreMap.containsKey(s.Company_level__r.Level_value__c)){
                if(s.Certification__r.Overall_quantitative_rating__c > 0){
                    Decimal d = s.Sales_rep_profile__r.Annual_quota_amount__c * s.Certification__r.Overall_quantitative_rating__c;
                    levelQuanScoreMap.put(s.Company_level__r.Level_value__c,d);
                }
            }
            else{
                if(s.Certification__r.Overall_quantitative_rating__c > 0){
                    Decimal sum = levelQuanScoreMap.get(s.Company_level__r.Level_value__c);
                    sum = sum + (s.Sales_rep_profile__r.Annual_quota_amount__c * s.Certification__r.Overall_quantitative_rating__c);
                    levelQuanScoreMap.put(s.Company_level__r.Level_value__c,sum);
                }
            }
            
            
        }
        for(Sales_Profile_Company_Level_Junction__c s:junctsQual){
            if(!levelQualScoreMap.containsKey(s.Company_level__r.Level_value__c)){
                if(s.Certification__r.Individual_qualitative_rating__c > 0){
                    Decimal d = s.Sales_rep_profile__r.Annual_quota_amount__c * s.Certification__r.Individual_qualitative_rating__c;
                    levelQualScoreMap.put(s.Company_level__r.Level_value__c,d);
                }
            }
            else{
                if(s.Certification__r.Individual_qualitative_rating__c > 0){
                    Decimal sum = levelQualScoreMap.get(s.Company_level__r.Level_value__c);
                    sum = sum + (s.Sales_rep_profile__r.Annual_quota_amount__c * s.Certification__r.Individual_qualitative_rating__c);
                    levelQualScoreMap.put(s.Company_level__r.Level_value__c,sum);
                }
            }
        }
        
        for(String level: levelQuanScoreMap.keySet()){
            if(mapTotalQuota.get(level) != null){
                Decimal qs;
                if(levelQuanScoreMap.get(level) != null){
                    qs = (levelQuanScoreMap.get(level)/mapTotalQuota.get(level)).setScale(2);
                    levelQuanScoreMap.put(level,qs);
                    system.debug(' level '+level+' qs '+qs);
                }
                 
            }        
        }  
        for(String level: levelQualScoreMap.keySet()){
            if(mapTotalQuotaQual.get(level) != null){
                Decimal qs;
                 
                if(levelQualScoreMap.get(level) != null){
                    qs = (levelQualScoreMap.get(level)/mapTotalQuotaQual.get(level)).setScale(2);
                    levelQualScoreMap.put(level,qs);
                }
            } 
        }
        
        system.debug(' levelQuanScoreMap '+levelQuanScoreMap);
        
        system.debug(' levelQualScoreMap '+levelQualScoreMap);
        
        List<Company_Level__c> cls = [SELECT Certification__c, Certification__r.name, Certification__r.Overall_Rating__c, Level_Value__c FROM Company_Level__c WHERE Sales_rep_profile__r.Active__c = TRUE LIMIT 5000];        
        
        Map<id,Certification__c> crMap = new Map<id,Certification__c>([SELECT id, Overall_Rating__c, Overall_Qualitative_Rating__c FROM Certification__c WHERE Sales_rep_profile__r.Active__c = TRUE LIMIT 5000]);                        
        
        for(Company_Level__c cl: cls){ 
            
            if(levelQuanScoreMap.get(cl.Level_Value__c) != null){    
                
                if(crMap.get(cl.Certification__c) != null){
                    crMap.get(cl.Certification__c).Overall_Rating__c  = levelQuanScoreMap.get(cl.Level_Value__c);
                }
                
                system.debug(' levelQuanScoreMap.get[cl.Level_Value__c] '+levelQuanScoreMap.get(cl.Level_Value__c)+cl.Level_Value__c);
                system.debug(' crMap.get[cl.Certification__c] '+crMap.get(cl.Certification__c));
            } 
            
            if(levelQualScoreMap.get(cl.Level_Value__c) != null){    
                
                if(crMap.get(cl.Certification__c) != null){
                    crMap.get(cl.Certification__c).Overall_Qualitative_Rating__c  = levelQualScoreMap.get(cl.Level_Value__c);
                }
                
                system.debug(' levelQualScoreMap.get[cl.Level_Value__c] '+levelQualScoreMap.get(cl.Level_Value__c)+cl.Level_Value__c);
                system.debug(' crMap.get[cl.Certification__c] '+crMap.get(cl.Certification__c));
            }                                                                                 
            
        }
        
        system.debug(' crMap.values '+crMap.values());
        update crMap.values();
        
        Map<id,Certification__c> certMap = new Map<id,Certification__c> ([SELECT id,Target_value__c ,Prediction_Value__c,Individual_Qualitative_Rating__c,Overall_Qualitative_Rating__c,Overall_Quantitative_Rating__c,Overall_Rating__c FROM Certification__c WHERE Sales_rep_profile__r.Active__c = TRUE LIMIT 5000]);
                              
        List<Certification_snapshot__c> certSnaps = [SELECT id, Snapshot_scheduled_date__c FROM Certification_snapshot__c WHERE Sales_rep_profile__r.Active__c = TRUE ORDER BY Snapshot_scheduled_date__c DESC LIMIT 1];
                          
        if(certSnaps != null && certSnaps.size() > 0){
         
             certSnaps = [SELECT id, Certification__c FROM Certification_snapshot__c WHERE Snapshot_scheduled_date__c = :certSnaps[0].Snapshot_scheduled_date__c];
             
             for(Certification_snapshot__c cs: certSnaps){
                 if(certMap.get(cs.Certification__c) != null){
                    
                     cs.Individual_Qualitative_Rating__c = certMap.get(cs.Certification__c).Individual_Qualitative_Rating__c;
                     cs.Overall_Qualitative_Rating__c = certMap.get(cs.Certification__c).Overall_Qualitative_Rating__c;
                     cs.Overall_Quantitative_Rating__c = certMap.get(cs.Certification__c).Overall_Quantitative_Rating__c;
                     cs.Overall_Rating__c = certMap.get(cs.Certification__c).Overall_Rating__c; 
                     
                     cs.Prediction_Value__c = certMap.get(cs.Certification__c).Prediction_Value__c ; 
                     cs.Target_value__c = certMap.get(cs.Certification__c).Target_value__c ;        
                                              
                 }            
             }
             
             update certSnaps;                    
        }
        
        /*        
        List<AggregateResult> qualScoreAggr = [SELECT Company_Level__r.Level_Value__c v, AVG(Certification__r.Individual_Qualitative_Rating__c) qual FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels AND Sales_rep_profile__r.Active__c = TRUE GROUP BY Company_Level__r.Level_Value__c];
        
        Map<String,Decimal> mapValQual = new Map<String,Decimal>();
        
        for(AggregateResult ar: qualScoreAggr){
            mapValQual.put((String)ar.get('v'),(Decimal)ar.get('qual'));
        }                
        
        List<Company_Level__c> cls = [SELECT Certification__c, Certification__r.name, Certification__r.Overall_Rating__c, Level_Value__c FROM Company_Level__c WHERE Sales_rep_profile__r.Active__c = TRUE LIMIT 5000];        
        
        Map<id,Certification__c> crMap = new Map<id,Certification__c>([SELECT id, Overall_Rating__c, Overall_Qualitative_Rating__c FROM Certification__c WHERE Sales_rep_profile__r.Active__c = TRUE LIMIT 5000]);                        
        
        for(Company_Level__c cl: cls){ 
            
            if(mapValQuan.get(cl.Level_Value__c) != null){    
                
                if(crMap.get(cl.Certification__c) != null)
                    crMap.get(cl.Certification__c).Overall_Rating__c  = mapValQuan.get(cl.Level_Value__c);
                
            }                         
                                  
            if(mapValQual.get(cl.Level_Value__c) != null){    
                
                if(crMap.get(cl.Certification__c) != null)
                    crMap.get(cl.Certification__c).Overall_Qualitative_Rating__c = mapValQual.get(cl.Level_Value__c);
                
            }            
            
        }       
        
        update crMap.values();
        
        //if(modelDataPull){                          
             
             Map<id,Certification__c> certMap = new Map<id,Certification__c> ([SELECT id,Individual_Qualitative_Rating__c,Overall_Qualitative_Rating__c,Overall_Quantitative_Rating__c,Overall_Rating__c FROM Certification__c WHERE Sales_rep_profile__r.Active__c = TRUE LIMIT 5000]);
                              
             List<Certification_snapshot__c> certSnaps = [SELECT id, Snapshot_scheduled_date__c FROM Certification_snapshot__c WHERE Sales_rep_profile__r.Active__c = TRUE ORDER BY Snapshot_scheduled_date__c DESC LIMIT 1];
                              
             if(certSnaps != null && certSnaps.size() > 0){
             
                 certSnaps = [SELECT id, Certification__c FROM Certification_snapshot__c WHERE Snapshot_scheduled_date__c = :certSnaps[0].Snapshot_scheduled_date__c];
                 
                 for(Certification_snapshot__c cs: certSnaps){
                     if(certMap.get(cs.Certification__c) != null){
                        
                         cs.Individual_Qualitative_Rating__c = certMap.get(cs.Certification__c).Individual_Qualitative_Rating__c;
                         cs.Overall_Qualitative_Rating__c = certMap.get(cs.Certification__c).Overall_Qualitative_Rating__c;
                         cs.Overall_Quantitative_Rating__c = certMap.get(cs.Certification__c).Overall_Quantitative_Rating__c;
                         cs.Overall_Rating__c = certMap.get(cs.Certification__c).Overall_Rating__c;        
                                                  
                     }            
                 }
                 update certSnaps;                    
             }
         */
        //}
    }
}