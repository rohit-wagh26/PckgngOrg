/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelCertificationDetail {
    
    Public Map<String,String> managemenetReports{get;set;}
    
    public List<Certification_Answer__c>  cerificateAnswer{get;set;}
    public Map<String,List<Certification_Answer__c >> cerificationList{get;set;}
    public Map<String,Decimal> categoryScoreList {get;set;}
    public List<Certification_Answer__c>  cerificateAnswerQuantitative{get;set;}
    public Map<String,List<Certification_Answer__c >> cerificationListQuantitative{get;set;}
    public Map<String,Decimal> categoryScoreListQuantitative {get;set;}
    public list<Sales_Rep_Profile__c> salesProfile{get;set;}
    public string spDate{get;set;}
    public String srId {get;set;}
    public decimal Fcscore{get;set;}
    public decimal ytdScore{get; set;}
    public boolean updatenoti{get;set;}
    public boolean isPendingStatusUpdate{get; set;}    
    
    //Variables to store the parameters passed in the URL
    public String label1 {get; set;}
    public String label2 {get; set;}
    public String label3 {get; set;}
    public String selectedLevel1 {get; set;}
    public String selectedLevel2 {get; set;}
    public String selectedLevel3 {get; set;}
    
    public boolean renderInfoMessage {get; set;}
    
    public String lastMonthScore {get; set;}
    public String lastQuarterScore {get; set;}
    public String priorYearScore {get; set;}
    
    public Decimal Quantitative{get;set;}
    public Decimal Qualitative{get;set;}
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    public Map <String,Decimal> goalValueMap {get;set;}
    public Map <String,Decimal> actualValueMap {get;set;}
    
    public Map <String,Decimal> fieldValueMap {get;set;}
    
    public DateTime qdate;
    
    public List<Action_Plan__c> apList{get;set;}
    public String des{get;set;}
    
    public Boolean displayMetric{get;set;}
    public String monthlyDate{get;set;}
    public String quarterlyDate{get;set;}
    
    public  List<EvaluationGuidelines__c> guildlineList {get;set;}
    public Boolean displayPopup {get;set;}
    public String popClose{get;set;}
    
    Boolean readAccess;
    
    public FunnelCertificationDetail (){
        
        try{    
            
            displayMetric = false;
            
            
            readAccess = true;
            
            List<String> fldList1 = new List<String>{prefix+'User_Record_name__c',prefix+'name',prefix+'Role__c',prefix+'Sales_Manager__c',prefix+'Tenure_in_current_role__c',prefix+'Territory__c'};                    
                
                Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList1){
                if(!fieldMap1.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            }
            
            List<String> fldList2 = new List<String>{prefix+'Certifcation_Rating__c',prefix+'Rating_Score__c',prefix+'Due_Date__c',prefix+'Certifcation__c',prefix+'Manager_Email_Date__c',prefix+'Escalation_Email_Date__c',prefix+'Rating_Start_Date__c'};                 
                
                Map <String, Schema.SObjectField> fieldMap2 = Schema.getGlobalDescribe().get(prefix+'Certification_Answer__c').getDescribe().fields.getMap();
            system.debug(' fieldMap2 '+fieldMap2);
            for(String fldName: fldList2){
                system.debug(' fieldMap2.get(fldName) '+fieldMap2.get(fldName));
                if(!fieldMap2.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            }
            
            List<String> fldList3 = new List<String>{prefix+'Sales_Rep_Profile__c',prefix+'Level_Value__c',prefix+'Level_Name__c'};
                
                Map <String, Schema.SObjectField> fieldMap3 = Schema.getGlobalDescribe().get(prefix+'Company_Level__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList3){
                
                if(!fieldMap3.get(fldName).getDescribe().isAccessible()){
                    system.debug(' fldName '+fldName);
                    readAccess = false;
                }                           
            }
            
            List<String> fldList4 = new List<String>{prefix+'Sales_Rep_Profile__c',prefix+'Company_Level__c'};
                
                Map <String, Schema.SObjectField> fieldMap4 = Schema.getGlobalDescribe().get(prefix+'Sales_Profile_Company_Level_Junction__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList4){
                
                if(!fieldMap4.get(fldName).getDescribe().isAccessible()){
                    system.debug(' fldName '+fldName);
                    readAccess = false;
                }                           
            } 
            
            List<String> fldList5 = new List<String>{prefix+'Overall_Rating__c'};                    
                
                Map <String, Schema.SObjectField> fieldMap5 = Schema.getGlobalDescribe().get(prefix+'Certification__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList5){
                if(!fieldMap5.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            }
            
            srId = ApexPages.currentPage().getParameters().get('id');
            System.debug('srId --'+srId );
            if(readAccess){ 
                label1 = ApexPages.currentPage().getParameters().get('labelOne');
                label2 = ApexPages.currentPage().getParameters().get('labelTwo');
                label3 = ApexPages.currentPage().getParameters().get('labelThree');
                selectedLevel1 = ApexPages.currentPage().getParameters().get('selectOne');
                selectedLevel2 = ApexPages.currentPage().getParameters().get('selectTwo');
                selectedLevel3 = ApexPages.currentPage().getParameters().get('selectThree');   
                
                id userId;  
                userId = UserInfo.getUserId();
                
                //Find if certifications are pending and set the boolean variable to display the notification
                List<Sales_Rep_Profile__c > cl = [SELECT id, name, Rep_Staus__c, On_boarding_Date__c   FROM Sales_Rep_Profile__c WHERE User_Record_Name__c= :userId LIMIT 1];
                system.debug('cl pending'+cl );
                
                Set<id> mgid = new set<id>();
                id mid;
                if(cl != null && cl.size()>0){
                    mgid.add(cl[0].id);
                    mid = cl[0].id;
                }
                
                cl = [SELECT id, name  FROM Sales_Rep_Profile__c WHERE Interim_Manager__c IN :mgid ];
                system.debug(' mgid  '+mgid + ' cl '+cl);
                for(Sales_Rep_Profile__c im: cl){
                    mgid.add(im.id);
                }
                
                Sales_Rep_Profile__c repRec = [SELECT id, name, Rep_Staus__c, On_boarding_Date__c, Sales_Manager__c FROM Sales_Rep_Profile__c WHERE id =:srId];
                
                if(mgid.contains(repRec.Sales_Manager__c) && repRec.Rep_Staus__c == 'New' && repRec.On_boarding_Date__c <= Date.today()){
                    isPendingStatusUpdate = true;
                }
                
                list<Sales_Rep_Profile__c > sp =[SELECT id,name from Sales_Rep_Profile__c where Sales_Manager__c IN :mgid];
                system.debug('sp pending'+sp);
                
                set<id> spid= new set<id>();
                spid= (new Map<Id,Sales_Rep_Profile__c >(sp)).keySet();
                
                Boolean reppresent =spid.contains(srId );
                
                Map<Id,Certification__c> mapCerts = new Map<Id,Certification__c>([SELECT id FROM Certification__c WHERE Sales_Rep_Profile__c = :srid And Sales_Rep_Profile__c  != :mid]);
                Set<id> certs = mapCerts.keySet();
                system.debug('certs pending'+certs );
                
                list<Certification_Answer__c> updatecerti = new list<Certification_Answer__c  >();
                updatecerti = [SELECT Rating_Start_Date__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id 
                               FROM Certification_Answer__c  WHERE  Rating_Score__c = null AND Certifcation__c IN :certs AND Sales_rep_profile__r.Active__c = TRUE];
                
                system.debug('updatecerti pending'+ updatecerti );
                
                if(updatecerti != null && updatecerti.size()>0 && reppresent ){
                    updatenoti = true;
                }else{
                    updatenoti = false;
                }   
                
                
                
                cerificateAnswer = new list<Certification_Answer__c>();
                cerificateAnswerQuantitative = new list<Certification_Answer__c>();
                
                list<Certification_Answer__c> cerificateAnswerMonthly = new list<Certification_Answer__c>();
                list<Certification_Answer__c> cerificateAnswerQuaterly = new list<Certification_Answer__c>();
                list<Certification_Answer__c> cerificateAnswerBiannual = new list<Certification_Answer__c>();
                list<Certification_Answer__c> cerificateAnswerAnnual  = new list<Certification_Answer__c>();
                list<Certification_Answer__c> cerificateAnswerWeeklyQuantitative = new list<Certification_Answer__c>();
                list<Certification_Answer__c> cerificateAnswerMonthlyQuantitative = new list<Certification_Answer__c>();
                list<Certification_Answer__c> cerificateAnswerQuarterlyQuantitative = new list<Certification_Answer__c>();
                set<id> certiAnswerId = new set<id>();
                set<id> certiAnswerQuantitativeId = new set<id>();
                set<id>managerId = new set<id>();
                
                List<Company_Level__c> mg =[Select id,Sales_Rep_Profile__c From Company_Level__c LIMIT 5000];
                for(Company_Level__c c : mg){
                    managerId.add(c.Sales_Rep_Profile__c );
                }
                
                Certification__c  cerId = new Certification__c();
                cerId = [select id,Overall_Rating__c,Overall_Qualitative_Rating__c,Overall_Quantitative_Rating__c,Management_Qualitative_Score__c  from Certification__c where Sales_Rep_Profile__c =:srId Limit 1 ];
                System.debug('cerId --'+cerId );
                if( cerId != null  && cerId.Overall_Quantitative_Rating__c != null  )
                    Quantitative = cerId.Overall_Quantitative_Rating__c;
                
                if( cerId != null ){
                    
                    if(managerId.contains(srId) && cerId.Management_Qualitative_Score__c  != null){
                        Qualitative = cerId.Management_Qualitative_Score__c;
                    }else if(cerId.Overall_Qualitative_Rating__c != null){
                        Qualitative = cerId.Overall_Qualitative_Rating__c ;
                    }
                }
                
                Set<Id> spIds = new Set<Id>();
                spIds.add(srId);
                
                //Fcscore = FunnelCalculationHelper.findAggregateScore(spIds);
                
                Date fiscalYr = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
                
                Fcscore = [SELECT Overall_Rating__c FROM Certification__c WHERE Sales_Rep_Profile__c = :srId].Overall_Rating__c;
                
                if(Fcscore != null){
                    Fcscore = Fcscore.setScale(2, RoundingMode.HALF_UP);
                }
                
                List<AggregateResult> aRes = [SELECT AVG(Overall_rating__c) ovr FROM Certification_Snapshot__c WHERE Snapshot_scheduled_Date__c > :fiscalYr AND Sales_Rep_Profile__c =:srId];
                system.debug('aRes --'+aRes );
                if(aRes != null && aRes.size() > 0 && ares[0].get('ovr') != null){
                    ytdScore = ((Decimal)ares[0].get('ovr')).setScale(2, RoundingMode.HALF_UP);
                }        
                
                List<Certification_Snapshot__c> cs = [SELECT Overall_Rating__c FROM Certification_Snapshot__c where Sales_Rep_Profile__c =:srId ORDER BY Snapshot_scheduled_Date__c DESC LIMIT 1];
                
                if(cs != null && cs.size() > 0 && cs[0].Overall_Rating__c != null)
                    lastMonthScore = FunnelCalculationHelper.convert(cs[0].Overall_Rating__c,'score');
                
                cs = [SELECT Overall_Rating__c FROM Certification_Snapshot__c WHERE Snapshot_scheduled_Date__c < :fiscalYr AND Sales_Rep_Profile__c =:srId ORDER BY Snapshot_scheduled_Date__c DESC LIMIT 1];
                
                if(cs != null && cs.size() > 0 && cs[0].Overall_Rating__c != null)
                    priorYearScore = FunnelCalculationHelper.convert(cs[0].Overall_Rating__c,'score');
                
                /*DateTime currQuarStartDate = getQuarterStartDate();
System.debug('currQuarStartDate --'+currQuarStartDate ); 
Date quarStartDate = Date.newInstance(currQuarStartDate.year(),currQuarStartDate.month(),currQuarStartDate.day());
*/
                
                Date quarStartDate = getQuarterStartDate();
                
                if(quarStartDate != null){        
                    cs = [SELECT Overall_Rating__c FROM Certification_Snapshot__c WHERE Snapshot_scheduled_Date__c < :quarStartDate AND Sales_Rep_Profile__c =:srId ORDER BY Snapshot_scheduled_Date__c DESC LIMIT 1];
                    
                    if(cs != null && cs.size() > 0 && cs[0].Overall_Rating__c != null)
                        lastQuarterScore = FunnelCalculationHelper.convert(cs[0].Overall_Rating__c,'score');       
                }    
                
                //Fcscore=cerId.Overall_Rating__c  ;
                
                cerificationList = new  Map<String,List<Certification_Answer__c >> ();
                cerificationListQuantitative = new  Map<String,List<Certification_Answer__c >> ();
                //cerificateAnswer = [Select Weighted_Score__c, Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Category__c from Certification_Answer__c where Certifcation__c =:cerId.id];
                
                //Get the monthly Answer
                
                list<Certification_Answer__c> cerDuedateMonthly = new list<Certification_Answer__c>();
                
                cerDuedateMonthly  =[select id, Due_Date__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c where Certifcation__c =:cerId.id And Certifcation_Rating__r.Timing__c = 'End of month' And Rating_Score__c != null AND Due_Date__c  != null AND  Certifcation_Rating__r.Assessment_type__c='Qualitative' AND (Certifcation_Rating__r.User_Type__c='Both' OR  Certifcation_Rating__r.User_Type__c = :repRec.Rep_Staus__c ) order by Due_Date__c  Desc limit 1];
                
                if(cerDuedateMonthly != null && cerDuedateMonthly.size()>0){
                    System.debug('repRec.Rep_Staus__c --'+repRec.Rep_Staus__c );       
                    cerificateAnswerMonthly =[select id, Comment__c,Due_Date__c , Weighted_Score__c,Rating_Score__c, Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Category__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c where Certifcation__c =:cerId.id And Certifcation_Rating__r.Timing__c = 'End of month' And Rating_Score__c != null And Due_Date__c=:cerDuedateMonthly[0].Due_Date__c AND  Certifcation_Rating__r.Assessment_type__c='Qualitative'  AND (Certifcation_Rating__r.User_Type__c='Both' OR  Certifcation_Rating__r.User_Type__c = :repRec.Rep_Staus__c ) ];
                }
                
                if(cerificateAnswerMonthly != null && cerificateAnswerMonthly.size()>0){
                    cerificateAnswer.addAll(cerificateAnswerMonthly);
                }
                System.debug('cerificateAnswerMonthly --'+cerificateAnswerMonthly );   
                //Get the Quaterly Answer
                
                list<Certification_Answer__c> cerDuedateQuartly  = new list<Certification_Answer__c>();
                
                cerDuedateQuartly   =[select id, Due_Date__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c where Certifcation__c =:cerId.id And Certifcation_Rating__r.Timing__c = 'End of quarter' And Rating_Score__c != null AND Due_Date__c  != null AND  Certifcation_Rating__r.Assessment_type__c='Qualitative' AND (Certifcation_Rating__r.User_Type__c='Both' OR  Certifcation_Rating__r.User_Type__c = :repRec.Rep_Staus__c )  order by Due_Date__c  Desc limit 1];
                
                if(cerDuedateQuartly  != null && cerDuedateQuartly.size()>0){
                    System.debug('repRec.Rep_Staus__c --'+repRec.Rep_Staus__c ); 
                    cerificateAnswerQuaterly =[select id,Comment__c, Due_Date__c , Weighted_Score__c,Rating_Score__c, Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Category__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c where Certifcation__c =:cerId.id And Certifcation_Rating__r.Timing__c = 'End of quarter' And Rating_Score__c != null And Due_Date__c=:cerDuedateQuartly[0].Due_Date__c AND  Certifcation_Rating__r.Assessment_type__c='Qualitative'  AND (Certifcation_Rating__r.User_Type__c='Both' OR  Certifcation_Rating__r.User_Type__c = :repRec.Rep_Staus__c ) ];
                }
                
                if(cerificateAnswerQuaterly != null && cerificateAnswerQuaterly.size()>0){
                    cerificateAnswer.addAll(cerificateAnswerQuaterly );
                }
                System.debug('cerificateAnswerQuaterly --'+cerificateAnswerQuaterly ); 
                
                //Get the Bi-annual Answer
                
                list<Certification_Answer__c> cerDuedateBiannual  = new list<Certification_Answer__c>();
                
                cerDuedateBiannual   =[select id, Due_Date__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c where Certifcation__c =:cerId.id And Certifcation_Rating__r.Timing__c = 'Bi-annual' And Rating_Score__c != null AND Due_Date__c  != null AND  Certifcation_Rating__r.Assessment_type__c='Qualitative' AND (Certifcation_Rating__r.User_Type__c='Both' OR  Certifcation_Rating__r.User_Type__c = :repRec.Rep_Staus__c )  order by Due_Date__c  Desc limit 1];
                
                if(cerDuedateBiannual  != null && cerDuedateBiannual.size()>0){
                    
                    cerificateAnswerBiannual =[select id, Comment__c,Due_Date__c , Weighted_Score__c,Rating_Score__c, Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Category__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c where Certifcation__c =:cerId.id And Certifcation_Rating__r.Timing__c = 'Bi-annual' And Rating_Score__c != null And Due_Date__c=:cerDuedateBiannual[0].Due_Date__c AND  Certifcation_Rating__r.Assessment_type__c='Qualitative'  AND (Certifcation_Rating__r.User_Type__c='Both' OR  Certifcation_Rating__r.User_Type__c = :repRec.Rep_Staus__c ) ];
                }
                
                if(cerificateAnswerBiannual != null && cerificateAnswerBiannual.size()>0){
                    cerificateAnswer.addAll(cerificateAnswerBiannual);
                }
                System.debug('cerificateAnswerBiannual --'+cerificateAnswerBiannual );
                //Get the Annual Answer
                
                list<Certification_Answer__c> cerDuedateAnnual  = new list<Certification_Answer__c>();
                
                cerDuedateAnnual   =[select id, Due_Date__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c where Certifcation__c =:cerId.id And Certifcation_Rating__r.Timing__c = 'Annual' And Rating_Score__c != null AND Due_Date__c  != null AND  Certifcation_Rating__r.Assessment_type__c='Qualitative' AND (Certifcation_Rating__r.User_Type__c='Both' OR  Certifcation_Rating__r.User_Type__c = :repRec.Rep_Staus__c )  order by Due_Date__c  Desc limit 1];
                
                if(cerDuedateAnnual  != null && cerDuedateAnnual.size()>0){
                    
                    cerificateAnswerAnnual  =[select id, Due_Date__c ,Comment__c, Weighted_Score__c,Rating_Score__c, Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Category__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c where Certifcation__c =:cerId.id And Certifcation_Rating__r.Timing__c = 'Annual' And Rating_Score__c !=  null And Due_Date__c=:cerDuedateAnnual[0].Due_Date__c AND  Certifcation_Rating__r.Assessment_type__c='Qualitative' AND (Certifcation_Rating__r.User_Type__c='Both' OR  Certifcation_Rating__r.User_Type__c = :repRec.Rep_Staus__c ) ];
                }
                
                if(cerificateAnswerAnnual  != null && cerificateAnswerAnnual.size()>0){
                    cerificateAnswer.addAll(cerificateAnswerAnnual);
                }
                
                System.debug('cerificateAnswerAnnual  --'+cerificateAnswerAnnual  );  
                if(cerificateAnswer != null && cerificateAnswer.size() > 0){
                    Set<Id> qualId = (new Map<Id,Certification_Answer__c >(cerificateAnswer)).keySet();
                    cerificateAnswer.clear();
                    cerificateAnswer =[select id, Due_Date__c ,Comment__c, Weighted_Score__c,Rating_Score__c, Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Name,Certifcation_Rating__r.Category__c,Certifcation_Rating__r.Calculation_type__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c where Id IN :qualId ORDER BY Certifcation_Rating__r.Display_Order__c ASC, Certifcation_Rating__r.CreatedDate DESC];
                    
                }
                
                for(Certification_Answer__c q : cerificateAnswer ){
                    
                    if(q.Certifcation_Rating__r.Category__c != null && q.Certifcation_Rating__r.Category__c != '' && !cerificationList.keySet().contains(q.Certifcation_Rating__r.Category__c)){
                        
                        List<Certification_Answer__c > wr = new List<Certification_Answer__c >();        
                        wr.add(q);    
                        
                        cerificationList.put(q.Certifcation_Rating__r.Category__c,wr);
                    }    
                    else if(q.Certifcation_Rating__r.Category__c != null && q.Certifcation_Rating__r.Category__c != '' && cerificationList.keySet().contains(q.Certifcation_Rating__r.Category__c)){
                        
                        cerificationList.get(q.Certifcation_Rating__r.Category__c).add(q);
                    }
                    
                    certiAnswerId.add(q.id);
                }
                //system.debug('cerificationList---'+cerificationList);
                salesProfile = [select id,Rep_Staus__c,New_or_Tenured__c ,User_Record_Name__r.name,rep_start_date__c,User_Record_Name__r.title,User_Record_Name__r.CreatedDate,Tenure_in_current_role__c,name,Role__c,Sales_Manager__c,Sales_Manager__r.name,Sales_Rep_Start_Date__c,Territory__c  from Sales_Rep_Profile__c where id =:srId  limit 1];
                /*Datetime strDt = salesProfile[0].User_Record_Name__r.CreatedDate;
if(strDt != null){
spDate = strDt.format('MM/dd/yyyy');
}*/
                
                if(salesProfile[0].Rep_start_date__c != null){
                    spDate = salesProfile[0].Rep_start_date__c.format();
                }
                
                list<AggregateResult> categoryScore = new list<AggregateResult>();
                
                categoryScore =[select Certifcation_Rating__r.Category__c  c,sum(Weighted_Score__c) ws , sum(Certifcation_Rating__r.Numeric_Weight__c) w from Certification_Answer__c where id IN :certiAnswerId  GROUP BY Certifcation_Rating__r.Category__c ];
                
                categoryScoreList = new Map<String,Decimal>();
                
                for(AggregateResult q : categoryScore ){
                    
                    if(q.get('c') != null && q.get('c') != ''){
                        
                        
                        
                        //    categoryScoreList.put((string)q.get('c'),((Decimal)q.get('ws')/(Decimal)q.get('w')).setScale(2, RoundingMode.HALF_UP));
                    }    
                    
                }
                //Get the weekly Answer Quantitative
                
                list<Certification_Answer__c> certiweeklyLast =[select id ,createddate,Certifcation_Rating__r.Training_Url__c From Certification_Answer__c Where Certifcation_Rating__r.Timing__c = 'End of Week' AND Certifcation_Rating__r.Deactivated__c = false AND   Certifcation_Rating__r.Assessment_type__c='Quantitative' AND (Certifcation_Rating__r.User_Type__c='Both' OR  Certifcation_Rating__r.User_Type__c = :repRec.Rep_Staus__c )  order by createddate  Desc limit 1];
                
                if(certiweeklyLast != null && certiweeklyLast.size()>0){
                    Date createdDt = Date.newInstance(certiweeklyLast[0].createddate.yearGmt(),certiweeklyLast[0].createddate.monthGmt(),certiweeklyLast[0].createddate.dayGmt());        
                    cerificateAnswerWeeklyQuantitative =[select id , Weighted_Score__c,Rating_Score__c,Certifcation_Rating__r.Field_Name__c,Certifcation_Rating__r.Goal_field_name__c,Certifcation_Rating__r.Rating_type__c ,Certifcation_Rating__r.Metric_field_name__c,Certifcation_Rating__r.Name, Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Category__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c WHERE Certifcation__c =:cerId.id AND Certifcation_Rating__r.Timing__c='End of Week' AND Certifcation_Rating__r.Deactivated__c = false AND  createddate >=:createdDt AND  Certifcation_Rating__r.Assessment_type__c='Quantitative'  AND (Certifcation_Rating__r.User_Type__c='Both' OR  Certifcation_Rating__r.User_Type__c = :repRec.Rep_Staus__c) ];
                }
                
                if(cerificateAnswerWeeklyQuantitative != null && cerificateAnswerWeeklyQuantitative.size()>0){
                    cerificateAnswerQuantitative.addAll(cerificateAnswerWeeklyQuantitative);
                }
                
                //Get the monthly Answer Quantitative
                
                list<Certification_Answer__c> certimonthlyLast =[select id ,createddate,Due_Date__c,Certifcation_Rating__r.Training_Url__c  From Certification_Answer__c Where Certifcation_Rating__r.Timing__c = 'End of month' AND Certifcation_Rating__r.Deactivated__c = false AND   Certifcation_Rating__r.Assessment_type__c='Quantitative' AND Due_Date__c != null AND (Certifcation_Rating__r.User_Type__c='Both' OR  Certifcation_Rating__r.User_Type__c = :repRec.Rep_Staus__c )  order by Due_Date__c Desc limit 1];
                
                system.debug(' certimonthlyLast  '+certimonthlyLast);
                
                
                if(certimonthlyLast != null && certimonthlyLast.size()>0){
                    
                    cerificateAnswerMonthlyQuantitative =[select id ,Certifcation_Rating__r.Group__c,Certifcation_Rating__r.Display_Custom_Metric__c, createdDate, Weighted_Score__c,Rating_Score__c,Certifcation_Rating__r.Field_Name__c,Certifcation_Rating__r.Goal_field_name__c,Certifcation_Rating__r.Rating_type__c ,Certifcation_Rating__r.Metric_field_name__c,Certifcation_Rating__r.Name, Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Category__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c WHERE Certifcation__c =:cerId.id AND Certifcation_Rating__r.Timing__c='End of month' AND Certifcation_Rating__r.Deactivated__c = false AND  Due_Date__c = :certimonthlyLast[0].Due_Date__c  AND  Certifcation_Rating__r.Assessment_type__c='Quantitative'  AND (Certifcation_Rating__r.User_Type__c='Both' OR  Certifcation_Rating__r.User_Type__c = :repRec.Rep_Staus__c ) ];
                    monthlyDate = 'Monthly Ratings scored on '+ certimonthlyLast[0].Due_Date__c.month() +'/'+certimonthlyLast[0].Due_Date__c.Day() +'/'+certimonthlyLast[0].Due_Date__c.Year()  +'      ' ;
                }
                
                system.debug(' cerificateAnswerMonthlyQuantitative  '+cerificateAnswerMonthlyQuantitative );
                
                if(cerificateAnswerMonthlyQuantitative != null && cerificateAnswerMonthlyQuantitative.size()>0){
                    cerificateAnswerQuantitative.addAll(cerificateAnswerMonthlyQuantitative);
                }
                
                //Get the quarterly Answer Quantitative
                
                list<Certification_Answer__c> certiquarterlyLast =[select id ,createddate,Due_Date__c  From Certification_Answer__c Where Certifcation_Rating__r.Timing__c = 'End of quarter' AND Certifcation_Rating__r.Deactivated__c = false AND   Certifcation_Rating__r.Assessment_type__c='Quantitative' AND (Certifcation_Rating__r.User_Type__c='Both' OR  Certifcation_Rating__r.User_Type__c = :repRec.Rep_Staus__c )  AND Due_Date__c != null order by Due_Date__c Desc limit 1];
                
                if(certiquarterlyLast != null && certiquarterlyLast.size()>0){
                    cerificateAnswerQuarterlyQuantitative =[select id ,Certifcation_Rating__r.Group__c,Certifcation_Rating__r.Display_Custom_Metric__c,  Weighted_Score__c,Rating_Score__c,Certifcation_Rating__r.Field_Name__c,Certifcation_Rating__r.Goal_field_name__c,Certifcation_Rating__r.Rating_type__c ,Certifcation_Rating__r.Metric_field_name__c ,Certifcation_Rating__r.Name, Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Category__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c WHERE Certifcation__c =:cerId.id AND Certifcation_Rating__r.Timing__c='End of quarter' AND Certifcation_Rating__r.Deactivated__c = false AND  Due_Date__c = :certiquarterlyLast[0].Due_Date__c AND  Certifcation_Rating__r.Assessment_type__c='Quantitative'  AND (Certifcation_Rating__r.User_Type__c='Both' OR  Certifcation_Rating__r.User_Type__c = :repRec.Rep_Staus__c ) ];
                    qdate = certiquarterlyLast[0].Due_Date__c;
                    quarterlyDate  = 'Quarterly Ratings scored on '+ certiquarterlyLast[0].Due_Date__c.month() +'/'+certiquarterlyLast[0].Due_Date__c.Day() +'/'+certiquarterlyLast[0].Due_Date__c.Year()  ;
                    
                }
                
                if(cerificateAnswerQuarterlyQuantitative != null && cerificateAnswerQuarterlyQuantitative.size()>0){
                    cerificateAnswerQuantitative.addAll(cerificateAnswerQuarterlyQuantitative);
                }
                
                
                
                
                
                
                if(cerificateAnswerQuantitative!= null && cerificateAnswerQuantitative.size() > 0){
                    Set<Id> quanId = (new Map<Id,Certification_Answer__c >(cerificateAnswerQuantitative)).keySet();
                    cerificateAnswerQuantitative.clear();
                    
                    List<Certification_Answer__c > ca = new List<Certification_Answer__c >();
                    ca = [select id, Due_Date__c ,Certifcation_Rating__r.Group__c,Certifcation_Rating__r.Display_Custom_Metric__c, Weighted_Score__c,Rating_Score__c,Certifcation_Rating__r.Field_Name__c,Certifcation_Rating__r.Goal_field_name__c,Certifcation_Rating__r.Rating_type__c ,Certifcation_Rating__r.Metric_field_name__c,Certifcation_Rating__r.Name, Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Category__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c where Id IN :quanId And Certifcation_Rating__r.SRP_Field_Name__c != null ORDER BY Certifcation_Rating__r.Display_Order__c ASC, Certifcation_Rating__r.CreatedDate DESC];
                    cerificateAnswerQuantitative.addAll(ca);
                    ca.clear();
                    ca=[select id, Due_Date__c ,Certifcation_Rating__r.Group__c,Certifcation_Rating__r.Display_Custom_Metric__c, Weighted_Score__c,Rating_Score__c,Certifcation_Rating__r.Field_Name__c,Certifcation_Rating__r.Goal_field_name__c,Certifcation_Rating__r.Rating_type__c ,Certifcation_Rating__r.Metric_field_name__c,Certifcation_Rating__r.Name, Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Category__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c where Id IN :quanId And Certifcation_Rating__r.SRP_Field_Name__c = null ORDER BY Certifcation_Rating__r.Display_Order__c ASC, Certifcation_Rating__r.CreatedDate DESC];
                    cerificateAnswerQuantitative.addAll(ca);
                    
                    Set<Id> finalquanId = (new Map<Id,Certification_Answer__c >(cerificateAnswerQuantitative)).keySet();
                    List<Application_Setting__c> aps = [Select Leads_used__c,Meetings_used__c From Application_Setting__c Limit 1];
                    Boolean LeadUsed = false;
                    Boolean MeetingUsed = false;
                    if(aps != null && aps.size() > 0){
                        LeadUsed = aps[0].Leads_used__c;
                        MeetingUsed = aps[0].Meetings_used__c ;
                    }
                    
                    if(!LeadUsed  && !MeetingUsed ){
                        cerificateAnswerQuantitative.clear();
                        cerificateAnswerQuantitative =[select id, Due_Date__c , Weighted_Score__c,Rating_Score__c,Certifcation_Rating__r.Group__c,Certifcation_Rating__r.Display_Custom_Metric__c,Certifcation_Rating__r.Field_Name__c,Certifcation_Rating__r.Goal_field_name__c,Certifcation_Rating__r.Rating_type__c ,Certifcation_Rating__r.Metric_field_name__c,Certifcation_Rating__r.Name, Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Category__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c where Id IN :finalquanId AND Certifcation_Rating__r.Metric_field_name__c NOT IN ('Lead_to_Opportunity_Conversion_Rate__c','Monthly_Lead_Added__c','Quarterly_Lead_Added__c','YTD_Leads_Added__c','X12_Month_Leads_Added__c','Number_of_meetings_Rolling_12_months__c','Number_of_meetings_per_month__c','Number_of_meetings_per_quarter__c','Number_of_meetings_YTD__c' ) ORDER BY Certifcation_Rating__r.Display_Order__c ASC, Certifcation_Rating__r.CreatedDate DESC ];
                    }else if(!LeadUsed){
                        cerificateAnswerQuantitative.clear();
                        cerificateAnswerQuantitative =[select id, Due_Date__c , Weighted_Score__c,Rating_Score__c,Certifcation_Rating__r.Group__c,Certifcation_Rating__r.Display_Custom_Metric__c,Certifcation_Rating__r.Field_Name__c,Certifcation_Rating__r.Goal_field_name__c,Certifcation_Rating__r.Rating_type__c ,Certifcation_Rating__r.Metric_field_name__c,Certifcation_Rating__r.Name, Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Category__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c where Id IN :finalquanId AND Certifcation_Rating__r.Metric_field_name__c NOT IN ('Lead_to_Opportunity_Conversion_Rate__c','Monthly_Lead_Added__c','Quarterly_Lead_Added__c','YTD_Leads_Added__c','X12_Month_Leads_Added__c' ) ORDER BY Certifcation_Rating__r.Display_Order__c ASC, Certifcation_Rating__r.CreatedDate DESC ];
                    }else if(!MeetingUsed){
                        cerificateAnswerQuantitative.clear();
                        cerificateAnswerQuantitative =[select id, Due_Date__c , Weighted_Score__c,Rating_Score__c,Certifcation_Rating__r.Group__c,Certifcation_Rating__r.Display_Custom_Metric__c,Certifcation_Rating__r.Field_Name__c,Certifcation_Rating__r.Goal_field_name__c,Certifcation_Rating__r.Rating_type__c ,Certifcation_Rating__r.Metric_field_name__c,Certifcation_Rating__r.Name, Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Category__c,Certifcation_Rating__r.Training_Url__c from Certification_Answer__c where Id IN :finalquanId AND Certifcation_Rating__r.Metric_field_name__c NOT IN ('Number_of_meetings_Rolling_12_months__c','Number_of_meetings_per_month__c','Number_of_meetings_per_quarter__c','Number_of_meetings_YTD__c') ORDER BY Certifcation_Rating__r.Display_Order__c ASC, Certifcation_Rating__r.CreatedDate DESC ];
                    }
                }
                
                for(Certification_Answer__c q : cerificateAnswerQuantitative ){
                    
                    
                    if(q.Certifcation_Rating__r.Category__c != null && q.Certifcation_Rating__r.Category__c != '' && !cerificationListQuantitative.keySet().contains(q.Certifcation_Rating__r.Category__c)){
                        
                        List<Certification_Answer__c > wrq = new List<Certification_Answer__c >();        
                        wrq.add(q);    
                        
                        cerificationListQuantitative.put(q.Certifcation_Rating__r.Category__c,wrq);
                    }    
                    else if(q.Certifcation_Rating__r.Category__c != null && q.Certifcation_Rating__r.Category__c != '' && cerificationListQuantitative.keySet().contains(q.Certifcation_Rating__r.Category__c)){
                        
                        cerificationListQuantitative.get(q.Certifcation_Rating__r.Category__c).add(q);
                    }
                    
                    
                    certiAnswerQuantitativeId.add(q.id);
                    
                }
                
                
                
                
                list<AggregateResult> categoryScoreQuantitative = new list<AggregateResult>();
                
                categoryScoreQuantitative =[select Certifcation_Rating__r.Category__c  c,sum(Weighted_Score__c) ws , sum(Certifcation_Rating__r.Numeric_Weight__c) w from Certification_Answer__c where id IN :certiAnswerQuantitativeId  GROUP BY Certifcation_Rating__r.Category__c ];
                
                categoryScoreListQuantitative = new Map<String,Decimal>();
                
                for(AggregateResult q : categoryScoreQuantitative ){
                    
                    if(q.get('c') != null && q.get('c') != ''){
                        
                        
                        
                        //           categoryScoreListQuantitative.put((string)q.get('c'),((Decimal)q.get('ws')/(Decimal)q.get('w')).setScale(2, RoundingMode.HALF_UP));
                    }    
                    
                }
                
                if((cerificationList == null || cerificationList.size() < 1) && (cerificationListQuantitative == null || cerificationListQuantitative.size() < 1)){
                    renderInfoMessage = true;
                }
                
                /*
managemenetReports = new Map<String,String>();

User u = [SELECT Name, UserPreferencesLightningExperiencePreferred FROM User WHERE id = :UserInfo.getUserId()];

List<String> dashList = new List<String>();
dashList.add('mXaDybYGcSDujlyIRRJQxUrUEqXiFe');

managemenetReports = FunnelNavigationHelper.fetchDashboards(dashList,u);*/
                
            }
            
            guildlineList = [select id,name,Description__c,order__c from  EvaluationGuidelines__c ORDER BY order__c ASC limit 5];
            apList = new List<Action_Plan__c>();
            apList = [SELECT Id,Name,Metric_Skill__r.Name,Action_Step__c,Active__c,Due_Date__c,Employee_Name__c,Employee_Response__c,Manager_Name__c,Measurement_Criteria__c,Notes__c,Period__c,Result__c,Result_Rating__c,Sales_Rep_Profile__c,Status__c,Metric_Skill__c,Custom_Field_1__c,Custom_Field_2__c,Custom_Field_3__c From Action_Plan__c Where Active__c = true AND Sales_Rep_Profile__c = :srid Order By Due_Date__c Asc NULLS Last];
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelCertificationDetail '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());  
        }
        
        createGoalActualMap(); 
    }
    
    /*Navigation*/
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToCertification(){
        
        //return FunnelNavigationHelper.navigateToCertification(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        return FunnelNavigationHelper.navigateToCertification(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    public Date getQuarterStartDate(){
        
        DateTime Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        
        Date FyearDt = Date.newInstance(Fyear.yearGMT(),Fyear.monthGMT(),Fyear.dayGMT());
        
        Date Cyear = Date.today();
        
        Date Q0 = FyearDt;
        Date Q1 = Q0.addMonths(3);
        Date Q2 = Q1.addMonths(3);
        Date Q3 = Q2.addMonths(3);
        Date Q4 = Q3.addMonths(3);
        
        Date startDate;
        
        if((Q0 <= Cyear) && (Cyear < Q1)){
            
            startDate= Q0;            
            
        }else if((Q1 <= Cyear) && (Cyear < Q2)){
            
            startDate= Q1;            
            
        }else if((Q2 <= Cyear) && (Cyear < Q3)){
            
            startDate= Q2;
            
        }else if((Q3 <= Cyear) && (Cyear < Q4)){
            
            startDate= Q3;
            
        }
        
        return startDate;
        
        /*
//Fyeard = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
String Fisyear =Fyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
//DateTime Cyear = DateTime.newInstance(2018,12,15,0,0,0);
DateTime Cyear = system.today();
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
*/
    }
    
    //Method called on clicking Performance Dashboard on header
    public PageReference navigateToCalculator(){
        
        return FunnelNavigationHelper.navigateToCalculator(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    //Method called on clicking Home on header    
    public PageReference navigateToHomePage(){
        
        return FunnelNavigationHelper.navigateToHomePage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToDashboard(){
        
        //return FunnelNavigationHelper.navigateToDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        return FunnelNavigationHelper.navigateToDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    //Method called on clicking Reporting on header    
    public PageReference navigateToReportsPage(){
        
        //return FunnelNavigationHelper.navigateToReportsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        return FunnelNavigationHelper.navigateToReportsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    //Method called on clicking Reporting on header    
    public PageReference navigateToAppSetup(){
        
        return FunnelNavigationHelper.navigateToAppSetupPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToCertificateReports(){
        
        return FunnelNavigationHelper.navigateToCertificateReports(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToUpdateRatings(){
        
        PageReference redirect;
        
        if(label1 != null && label1 != '')
            redirect = new PageReference('/apex/FunnelCertificationUpdateRatings?id='+srId+'&labelOne='+label1+'&labelTwo='+label2+'&labelThree='+label3+'&selectOne='+selectedLevel1+'&selectTwo='+selectedLevel2+'&selectThree='+selectedLevel3); 
        else
            redirect = new PageReference('/apex/FunnelCertificationUpdateRatings?id='+srId); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }    
    
    public PageReference navigateToIndividualDashboard(){
        
        List<Company_Level__c> cls = [SELECT id, Level_name__c, Level_value__c FROM Company_level__c WHERE Sales_rep_profile__c = :srId];
        
        return FunnelNavigationHelper.navigateToDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,srId);
        
        //If company level record does not exist, fetch the company level of the manger of the rep
        /*if(cls == null || cls.size() == 0){
            
            Id mgrId = [SELECT Sales_manager__c FROM Sales_rep_profile__c WHERE id = :srId].Sales_manager__c;
            
            List<Company_Level__c> clsMgr = [SELECT id, Level_name__c, Level_value__c FROM Company_level__c WHERE Sales_rep_profile__c = :mgrId];
            
            if(clsMgr != null && clsMgr.size() > 0){
                return FunnelNavigationHelper.navigateToDashboard(clsMgr[0].level_name__c,'Rep','Role',clsMgr[0].level_value__c,srId,'All');    
            }
            else{
                //the level above the rep is also not associated with a company level, so stay on the same page
                return null;
            }
        }
        //if company level record exists, check if company level record exists for the people under the rep
        else{
            List<Company_level__c> clSubor = [SELECT Level_name__c FROM Company_Level__c WHERE Sales_rep_profile__r.Sales_Manager__c = :srId];
            //People below the manager are also managers
            if(clSubor != null && clSubor.size() > 0){
                return FunnelNavigationHelper.navigateToDashboard(cls[0].level_name__c,clSubor[0].Level_name__c,'Role',cls[0].level_value__c,'All','All'); 
            }
            //There are reps below the manager
            else{
                return FunnelNavigationHelper.navigateToDashboard(cls[0].level_name__c,'Rep','Role',cls[0].level_value__c,'All','All');
            }
        }*/
        
        /*
if(label1 != null && label1 != '')
redirect = new PageReference('/apex/FunnelCertificationUpdateRatings?id='+srId+'&labelOne='+label1+'&labelTwo='+label2+'&labelThree='+label3+'&selectOne='+selectedLevel1+'&selectTwo='+selectedLevel2+'&selectThree='+selectedLevel3); 
else
redirect = new PageReference('/apex/FunnelCertificationUpdateRatings?id='+srId); */        
        
    }
    
    public PageReference navigateToStatusUpdatePage(){
        
        PageReference redirect;
        
        if(label1 != null && label1 != '')
            redirect = new PageReference('/apex/FunnelRepStatusUpdate?id='+srId+'&labelOne='+label1+'&labelTwo='+label2+'&labelThree='+label3+'&selectOne='+selectedLevel1+'&selectTwo='+selectedLevel2+'&selectThree='+selectedLevel3); 
        else
            redirect = new PageReference('/apex/FunnelRepStatusUpdate?id='+srId); 
        
        redirect.setRedirect(true);     
        return redirect;
    }
    
    public PageReference navigateToAnalytics(){
        
        return FunnelNavigationHelper.navigateToAnalytics(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    public PageReference navigateToFunnelAnalyticQualitative(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    } 
    
    public PageReference navigateToSalesPipeline(){
        
        return FunnelNavigationHelper.navigateToSalesPipeline(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    public PageReference navigateToTrendingByRep(){
        
        return FunnelNavigationHelper.navigateToTrendingByRep(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToTrendingBySkill(){
        
        return FunnelNavigationHelper.navigateToTrendingBySkill(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToFunnelAnalytic(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalytic(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        return FunnelNavigationHelper.navigateToFunnelAnalytic(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }      
    public PageReference navigateToAnnualizationDashboard(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    public PageReference navigateToGoals(){
        
        return FunnelNavigationHelper.navigateToGoalsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    /*Navigation*/  
    
    /*Fetching the goals*/
    private void createGoalActualMap(){
        List<Certification_Rating__c> ratings = [SELECT Field_Name__c,Goal_field_name__c, Metric_Field_Name__c,Training_Url__c FROM Certification_Rating__c  WHERE Assessment_type__c = 'Quantitative' AND Goal_field_name__c != null AND Metric_field_name__c != null AND Timing__c = 'End of month'];
        List<String> goalFieldList = new List<String>();
        List<String> actualFieldList = new List<String>();
        
        Set<String> goalFieldSet = new Set<String>();
        Set<String> actualFieldSet = new Set<String>();
        
        goalValueMap = new Map<String,Decimal>();
        actualValueMap = new Map<String,Decimal>();
        
        Map<String,String> fieldAndGoalName = new Map<String,String>();
        fieldValueMap = new Map<String,Decimal>();
        //Map<String,Decimal> GoalNameAndGoalValue = new Map<String,Decimal>();
        
        for(Certification_Rating__c r: ratings){
            
            fieldAndGoalName.put(r.Field_Name__c,r.Goal_field_name__c);
            if(!goalFieldSet.contains(r.Goal_field_name__c)){
                system.debug('added 1 '+r.Goal_field_name__c);
                goalFieldList.add(r.Goal_field_name__c);
                goalFieldSet.add(r.Goal_field_name__c);    
            } 
            system.debug(' actal '+r.Metric_Field_Name__c);
            if(!goalFieldSet.contains(r.Metric_Field_Name__c)){
                system.debug('added 2 '+r.Metric_Field_Name__c);
                actualFieldList.add(r.Metric_Field_Name__c);
                goalFieldSet.add(r.Metric_Field_Name__c);       
            }   
        }
        
        system.debug(' goalFieldSet '+goalFieldSet);
        system.debug(' actualFieldSet '+actualFieldSet);
        
        if(goalFieldList != null && goalFieldList.size() > 0){
            String query = 'SELECT ';
            
            for(integer i = 0; i < (goalFieldList.size() - 1); i++){
                query = query +goalFieldList[i]+', ';       
            }
            
            for(integer i = 0; i < (actualFieldList.size() - 1); i++){
                query = query +actualFieldList[i]+', ';       
            }
            
            query += goalFieldList[(goalFieldList.size() - 1)]+', '+actualFieldList[(actualFieldList.size() - 1)]+' FROM Sales_Rep_Profile_Snapshot__c WHERE Sales_Rep_Profile__c = '+'\''+String.escapeSingleQuotes(srId)+'\' order by Snapshot_Scheduled_Date__c Desc limit 1';
            
            system.debug(' query '+query);
            
            
            List<Sales_Rep_Profile_Snapshot__c> reps = Database.query(query);
            
            
            if(reps != null && reps.size()>0){
                for(integer i = 0; i < (goalFieldList.size()); i++){
                    system.debug(' goalValueMap '+goalFieldList[i]);
                    if(reps[0].get(goalFieldList[i]) != null){
                        goalValueMap.put(goalFieldList[i],(Decimal)reps[0].get(goalFieldList[i]));
                    }  
                    else{
                        goalValueMap.put(goalFieldList[i],0);
                    }
                    
                    
                    
                }
                
                for(integer i = 0; i < (actualFieldList.size()); i++){
                    system.debug(' actualValueMap '+actualFieldList[i]);
                    if(reps[0].get(actualFieldList[i]) != null){
                        system.debug(' actualValueMap val '+actualFieldList[i]);
                        actualValueMap.put(actualFieldList[i],(Decimal)reps[0].get(actualFieldList[i]));
                    }  
                    else{
                        system.debug(' actualValueMap val '+actualFieldList[i]);
                        actualValueMap.put(actualFieldList[i],0);
                    }
                    
                }
                displayMetric = true;
            }
            
            
            for(String s : fieldAndGoalName.keySet()){
                fieldValueMap.put(s,goalValueMap.get(fieldAndGoalName.get(s)));
            }
            system.debug(' goalValueMap '+goalValueMap);
            system.debug(' actualValueMap '+actualValueMap);
        }    
        
        ratings = [SELECT Field_Name__c,Goal_field_name__c, Metric_Field_Name__c,Training_Url__c FROM Certification_Rating__c  WHERE Assessment_type__c = 'Quantitative' AND Goal_field_name__c != null AND Metric_field_name__c != null AND Timing__c = 'End of quarter'];
        goalFieldList = new List<String>();
        actualFieldList = new List<String>();
        
        goalFieldSet = new Set<String>();
        actualFieldSet = new Set<String>();
        
        fieldAndGoalName = new Map<String,String>();
        goalValueMap = new Map<String,Decimal>();
        
        
        for(Certification_Rating__c r: ratings){
            
            fieldAndGoalName.put(r.Field_Name__c,r.Goal_field_name__c);
            
            if(!goalFieldSet.contains(r.Goal_field_name__c)){
                system.debug('added 1 '+r.Goal_field_name__c);
                goalFieldList.add(r.Goal_field_name__c);
                goalFieldSet.add(r.Goal_field_name__c);    
            } 
            system.debug(' actal '+r.Metric_Field_Name__c);
            if(!goalFieldSet.contains(r.Metric_Field_Name__c)){
                system.debug('added 2 '+r.Metric_Field_Name__c);
                actualFieldList.add(r.Metric_Field_Name__c);
                goalFieldSet.add(r.Metric_Field_Name__c);       
            }   
        }
        
        system.debug(' goalFieldSet '+goalFieldSet);
        system.debug(' actualFieldSet '+actualFieldSet);
        
        if(goalFieldList != null && goalFieldList.size() > 0){
            String query = 'SELECT ';
            
            for(integer i = 0; i < (goalFieldList.size() - 1); i++){
                query = query +goalFieldList[i]+', ';       
            }
            
            for(integer i = 0; i < (actualFieldList.size() - 1); i++){
                query = query +actualFieldList[i]+', ';       
            }
            
            if(qdate!= null){
                String qduedate = qdate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
                qduedate =  qduedate.substring(0, 10);
                
                query += goalFieldList[(goalFieldList.size() - 1)]+', '+actualFieldList[(actualFieldList.size() - 1)]+' FROM Sales_Rep_Profile_Snapshot__c WHERE Sales_Rep_Profile__c= '+'\''+srId+'\' AND Snapshot_Scheduled_Date__c='+qduedate;
                
                system.debug(' query '+query);
                
                List<Sales_Rep_Profile_Snapshot__c> reps = Database.query(query);
                
                if(reps != null && reps.size()>0){
                    for(integer i = 0; i < (goalFieldList.size()); i++){
                        system.debug(' goalValueMap '+goalFieldList[i]);
                        if(reps[0].get(goalFieldList[i]) != null){
                            goalValueMap.put(goalFieldList[i],(Decimal)reps[0].get(goalFieldList[i]));
                        }  
                        else{
                            goalValueMap.put(goalFieldList[i],0);
                        }
                        
                        
                        
                    }
                    
                    for(integer i = 0; i < (actualFieldList.size()); i++){
                        system.debug(' actualValueMap '+actualFieldList[i]);
                        if(reps[0].get(actualFieldList[i]) != null){
                            system.debug(' actualValueMap val '+actualFieldList[i]);
                            actualValueMap.put(actualFieldList[i],(Decimal)reps[0].get(actualFieldList[i]));
                        }  
                        else{
                            system.debug(' actualValueMap val '+actualFieldList[i]);
                            actualValueMap.put(actualFieldList[i],0);
                        }
                        
                    }
                    displayMetric = true;
                }
            }
            for(String  s : fieldAndGoalName.keySet()){
                fieldValueMap.put(s,goalValueMap.get(fieldAndGoalName.get(s)));
            }
            system.debug(' goalValueMap '+goalValueMap);
            system.debug(' actualValueMap '+actualValueMap);
        }    
        
    }
    
    /*Fetching the goals*/  
    
    /*Action plan */
    
    public boolean showPanel{get; set;}
    public boolean newActionPlan{get;set;}
    public Id actionPlanId{get; set;}
    public Action_Plan__c   actionPlanSelected{get; set;}
    public  List<SelectOption> CertRatings{get;set;}
    public String calText{get;set;}
    public Date DueDate{get;set;}
    
    Map<id,string> desMap = new Map<id,string>();
    
    
    public void displayAddEditActionPlan(){
        CertRatings  = new List<SelectOption>();
        showPanel = true; 
        system.debug(' ActionPlanId '+actionPlanId);
        des ='';
        
        if(actionPlanId != null){
            newActionPlan = false;
            actionPlanSelected = [SELECT Id,Metric_Skill__r.Name,Metric_Skill__r.Description__c,Name,Action_Step__c,Active__c,Due_Date__c,Employee_Name__c,Employee_Response__c,Manager_Name__c,Measurement_Criteria__c,Notes__c,Period__c,Result__c,Result_Rating__c,Sales_Rep_Profile__c,Status__c,Metric_Skill__c,Custom_Field_1__c,Custom_Field_2__c,Custom_Field_3__c From Action_Plan__c   WHERE id = :actionPlanId];
            DueDate = actionPlanSelected.Due_Date__c;  
            des = actionPlanSelected.Metric_Skill__r.Description__c;
        }else{
            newActionPlan = true;
            calText = 'This field is calculated upon save';
            actionPlanSelected = new Action_Plan__c();
            actionPlanSelected.Sales_Rep_Profile__c=srid;
            actionPlanSelected.Active__c=true;
            
            
        }
        
        
        for (Certification_Rating__c  cr : [Select id,Description__c, name from Certification_Rating__c Limit 5000]){ 
            CertRatings.add(new SelectOption(cr.id,cr.name)); 
            desMap.put(cr.id,cr.Description__c );
        }
        
        
    }
    
    public void popup(){
        if(popClose == 'pop'){
            displayPopup = true;
        }else if(popClose == 'close'){
            displayPopup = false;
        }
    }
    
    
    public void desUpdate(){
        system.debug('actionPlanSelected.Metric_Skill__c'+actionPlanSelected.Metric_Skill__c);
        des = desMap.get(actionPlanSelected.Metric_Skill__c);
    }
    
    public void hideAddEditActionPlan(){
        
        showPanel = false; 
        actionPlanId = null; 
        actionPlanSelected = new Action_Plan__c();
        DueDate = null;     
        
    }
    
    public void saveRating(){
        actionPlanSelected.Due_Date__c = DueDate ;
        DueDate = null; 
        upsert actionPlanSelected;
        apList = [SELECT Id,Name,Metric_Skill__r.Name,Action_Step__c,Active__c,Due_Date__c,Employee_Name__c,Employee_Response__c,Manager_Name__c,Measurement_Criteria__c,Notes__c,Period__c,Result__c,Result_Rating__c,Sales_Rep_Profile__c,Status__c,Metric_Skill__c,Custom_Field_1__c,Custom_Field_2__c,Custom_Field_3__c From Action_Plan__c Where Active__c = true AND Sales_Rep_Profile__c = :srid Order By Due_Date__c Asc NULLS Last];
    }
    
    /*Action plan */
}