/*
Copyright: Funnel Metrics, LLC
*/
public with Sharing class FunnelCalculationHelper{

     public static String prefix{ get{return 'FunnelMetrics__';} set; }
     
     public Static String convert(decimal d , string s){
            string dr;
            Decimal rounded ;
                if(math.abs(d) >= 1000000000){
                    rounded = d/1000000000;
                     rounded   = rounded.setScale(2, RoundingMode.HALF_UP);
                     
                    if(d >= 0){
                        if(s == '$'){
                            dr= s + rounded.format() + 'B';
                        }else{
                            dr= rounded.format() + 'B' + s;
                        }
                         
                     }else{
                          if(s == '$'){
                            dr= s + rounded.format() + 'B';
                            }else{
                                dr= rounded.format() + 'B' + s;
                            }
                         dr = '('+ dr.remove('-') +')';
                     }
                }
                else if(math.abs(d) >= 1000000){
                     rounded = d/1000000 ;
                     rounded   = rounded.setScale(2, RoundingMode.HALF_UP);
                     
                     if(rounded >= 1000){
                        rounded =rounded/1000 ;
                         
                         if(d >= 0){
                             if(s == '$'){
                                 if(rounded.format().contains('.')){
                                     dr= s + rounded.format() + 'B';
                                 }else{
                                     dr= s + rounded.format() + '.00'+'B';
                                 }
                                    
                            }else{
                                dr= rounded.format() + 'B' + s;
                            }
                         }else{
                             if(s == '$'){
                                if(rounded.format().contains('.')){
                                     dr= s + rounded.format() + 'B';
                                 }else{
                                     dr= s + rounded.format() + '.00'+'B';
                                 }
                            }else{
                                dr= rounded.format() + 'B' + s;
                            }
                             dr = '('+ dr.remove('-') +')';
                         }
                     }else{
                         if(d >= 0){
                             if(s == '$'){
                                 if(rounded.format().contains('.')){
                                     dr= s + rounded.format() + 'M';
                                 }else{
                                     dr= s + rounded.format() + '.00'+'M';
                                 }
                                
                            }else{
                                dr= rounded.format() + 'M' + s;
                            }
                         }else{
                             if(s == '$'){
                                if(rounded.format().contains('.')){
                                     dr= s + rounded.format() + 'M';
                                 }else{
                                     dr= s + rounded.format() + '.00'+'M';
                                 }
                            }else{
                                dr= rounded.format() + 'M' + s;
                            }
                             dr = '('+ dr.remove('-') +')';
                         }
                     }
                         
                
                }
                else if(math.abs(d) >= 10000){
                     rounded =d/1000 ;
                     rounded   = rounded .setScale(2, RoundingMode.HALF_UP);
                     
                     if(rounded >= 1000  ){
                        rounded =rounded/1000 ;
                         if(d >= 0){
                             if(s == '$'){
                                if(rounded.format().contains('.')){
                                     dr= s + rounded.format() + 'M';
                                 }else{
                                     dr= s + rounded.format() + '.00'+'M';
                                 }
                            }else{
                                dr= rounded.format() + 'M' + s;
                            }
                         }else{
                             if(s == '$'){
                                if(rounded.format().contains('.')){
                                     dr= s + rounded.format() + 'M';
                                 }else{
                                     dr= s + rounded.format() + '.00'+'M';
                                 }
                            }else{
                                dr= rounded.format() + 'M' + s;
                            }
                             dr = '('+ dr.remove('-') +')';
                         }
                     
                     }else{
                         d= d.setScale(2, RoundingMode.HALF_UP);
                         if(d >= 0){
                             if(s == '$'){
                                dr= s + rounded.format() + 'K';
                            }else{
                                dr= rounded.format() + 'K' + s;
                            }
                         }else{
                             if(s == '$'){
                                dr= s + rounded.format() + 'K';
                            }else{
                                dr= rounded.format() + 'K' + s;
                            }
                             dr = '('+ dr.remove('-') +')';
                         }
                     }
                     
                }else
                {
                    system.debug(' decimal '+d);
                    system.debug(' string '+s);
                    if( s == '%'){
                        d =d.setScale(2, RoundingMode.HALF_UP);
                    }
                    else if( s == 'score'){
                        d =d.setScale(2, RoundingMode.HALF_UP);
                        return String.valueOf(d);
                    }
                    else{
                        d =d.setScale(0, RoundingMode.HALF_UP);
                    }
                    if(d >= 0){
                        if(s == '$'){
                            dr= s + d.format() ;
                        }else{
                            dr= d.format() + s;
                        }
                         
                     }else{
                         if(s == '$'){
                            dr= s + d.format() ;
                        }else{
                            dr= d.format() + s;
                        }
                         dr = '('+ dr.remove('-') +')';
                     }
                }
            system.debug(' final dec '+dr);
            return dr;
        }
    
    public static Decimal findAggregateScore(Set<Id> aggregateIds){
    
        //Finding the average funnelocity Score        
        List<AggregateResult> aRes = [SELECT AVG(Overall_Rating__c) av FROM Certification__c WHERE Sales_Rep_Profile__c IN :aggregateIds AND Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' AND (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_Quota_Amount__c > 0)];
        
        system.debug(' aRes '+aRes);
        
        if(aRes != null && aRes.size() > 0){
            if(aRes[0].get('av') != null){
                return Decimal.valueOf(FunnelCalculationHelper.convert((Decimal)aRes[0].get('av'),'score'));
            }
            else
                return 0;
        }else{
            return 0;
        }
    }
    
    public static DateTime getQuarterStartDate(){
    
        DateTime Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        //Fyeard = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        String Fisyear =Fyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        DateTime Cyear = Date.Today();
        String Fyeard = Fisyear.substring(0,10);
        //This is used under dynamic query for Annual Added             
        
        DateTime startDate;
        DateTime endDate;
        String Quarter; 
        
        DateTime Q0 = Fyear ;
        DateTime Q1 = Fyear.addMonths(3);
        DateTime Q2 = Q1.addMonths(3);
        DateTime Q3 = Q2.addMonths(3);
        DateTime Q4 = Q3.addMonths(3);
        
        if((Q0 <= Cyear) && (Cyear < Q1)){
        
            startDate= Q0;
            endDate = Q1;
            Quarter = 'Q1';
                      
        }else if((Q1 <= Cyear) && (Cyear < Q2)){
        
            startDate= Q1;
            endDate = Q2;
            Quarter = 'Q2';
            
        }else if((Q2 <= Cyear) && (Cyear < Q3)){
        
            startDate= Q2;
            endDate = Q3;
            Quarter = 'Q3';
            
        }else if((Q3 <= Cyear) && (Cyear < Q4)){
        
            startDate= Q3;
            endDate = Q4;
            Quarter = 'Q4';
        
        }
        
        return startDate;  
    }
        
    public static DateTime getQuarterEndDate(Date scheduleDate){
    
        DateTime Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        //Fyeard = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        String Fisyear =Fyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        DateTime Cyear = scheduleDate;
        String Fyeard = Fisyear.substring(0,10);
        //This is used under dynamic query for Annual Added             
        
        DateTime startDate;
        DateTime endDate;
        String Quarter; 
        
        DateTime Q0 = Fyear ;
        DateTime Q1 = Fyear.addMonths(3);
        DateTime Q2 = Q1.addMonths(3);
        DateTime Q3 = Q2.addMonths(3);
        DateTime Q4 = Q3.addMonths(3);
        
        if((Q0 <= Cyear) && (Cyear < Q1)){
        
            startDate= Q0;
            endDate = Q1;
            Quarter = 'Q1';
                      
        }else if((Q1 <= Cyear) && (Cyear < Q2)){
        
            startDate= Q1;
            endDate = Q2;
            Quarter = 'Q2';
            
        }else if((Q2 <= Cyear) && (Cyear < Q3)){
        
            startDate= Q2;
            endDate = Q3;
            Quarter = 'Q3';
            
        }else if((Q3 <= Cyear) && (Cyear < Q4)){
        
            startDate= Q3;
            endDate = Q4;
            Quarter = 'Q4';
        
        }
        
        return endDate;  
    }   
    
    public static Date getQuarterEndInDateFormat(Date trigDt){
    
        DateTime Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        
        Date FyearDate = Date.newInstance(Fyear.yearGMT(),Fyear.monthGMT(),1);
        /*List<Sales_Rep_Profile_Snapshot__c> snapList = [Select id from Sales_Rep_Profile_Snapshot__c Limit 100];
        if(!(snapList != null && snapList.size()>0)){
             FyearDate = Date.newInstance(trigDt.year(),Fyear.monthGMT(),1);
        }
        */
        System.debug('Fyear --->'+Fyear );
        System.debug('FyearDate --->'+FyearDate );
        System.debug('trigDt--->'+trigDt);
        
        
        Date Q1 = FyearDate;
        Date Q2 = Q1.addmonths(3);
        Date Q3 = Q2.addmonths(3);
        Date Q4 = Q3.addmonths(3);
        Date nxtYr = Q4.addmonths(3);
        
        Date endDate;
        
        if((Q1 <= trigDt) && (trigDt < Q2)){
                    
            endDate = Q1.addmonths(2);
                      
        }else if((Q2 <= trigDt) && (trigDt < Q3)){
        
            endDate = Q2.addmonths(2);
            
        }else if((Q3 <= trigDt) && (trigDt < Q4)){
        
            endDate = Q3.addmonths(2);
            
        }else if((Q4 <= trigDt) && (trigDt < nxtYr)){
        
            endDate = Q4.addmonths(2);
        
        }
        
        System.debug('endDate --->'+endDate );
        Integer noOfDays = Date.daysInMonth(endDate.year(),endDate.month());
        endDate = Date.newInstance(endDate.year(),endDate.month(),noOfDays);
        
        return endDate;  
    }
    
    public static void calculateAggregateScoreForManagers(List<Certification__c> c){
        
        List<AggregateResult> levels = [SELECT Company_Level__r.Level_Value__c v FROM Sales_Profile_Company_Level_Junction__c WHERE Sales_Rep_Profile__c = :c[0].Sales_Rep_Profile__c AND Sales_rep_profile__r.Active__c = TRUE GROUP BY Company_Level__r.Level_Value__c];
        
        List<String> levelVals = new List<String>();                
        
        for(AggregateResult ar: levels){
            levelVals.add((String)ar.get('v'));
        }
        
        system.debug(' levelVals '+levelVals);
        
        List<AggregateResult> scoreAggr = [SELECT Company_Level__r.Level_Value__c v,AVG(Certification__r.Individual_Qualitative_Rating__c) qual FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levelVals AND Sales_rep_profile__r.Active__c = TRUE GROUP BY Company_Level__r.Level_Value__c];
        
        Map<String,Decimal> mapValQual = new Map<String,Decimal>();
        
        for(AggregateResult ar: scoreAggr){
            mapValQual.put((String)ar.get('v'),(Decimal)ar.get('qual'));
        }
        
        system.debug(' mapValQual '+mapValQual);
        
        List<Company_Level__c> cls = [SELECT id,Certification__c, Level_Value__c FROM Company_Level__c WHERE Level_Value__c IN :levelVals AND Sales_rep_profile__r.Active__c = TRUE];        
        
        List<Certification__c> crmnglist = new List<Certification__c>();
        
        for(Company_Level__c cl: cls){ 
            if(cl.Certification__c != null){
                Certification__c updateMng = new Certification__c(); 
                updateMng.id = cl.Certification__c;
                updateMng.Overall_Qualitative_Rating__c = mapValQual.get(cl.Level_Value__c);
                 
                crmnglist.add(updateMng);     
            } 
        }
        
        system.debug(' crmnglist '+crmnglist);
        
        if(Schema.getGlobalDescribe().get(prefix+'Certification__c').getDescribe().isUpdateable()){ 
            update crmnglist;
        }            
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
        }
    }
    
    public static boolean findIfManager(List<Certification__c> c){

        List<Sales_Rep_Profile__c> sRepsUnderMgr = [SELECT id FROM Sales_Rep_Profile__c WHERE Sales_Manager__c = :c[0].Sales_Rep_Profile__c AND Active__c = TRUE];
        
        if(sRepsUnderMgr != null && sRepsUnderMgr.size() > 0){
            return true;
        }
        else{
            return false;
        }
    }
}