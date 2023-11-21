public with Sharing  class FunnelQualScoreBatch implements Database.Batchable<sobject>, Database.Stateful{
        
    Boolean errorVal = false;
    
    Map<String,List<id>> roleRatIdMap = new Map<String,List<id>>();
    
    public FunnelQualScoreBatch(){
        
        //Fetch the important metrics for all roles    
        //Create a map of role and important ratings
        
        List<Important_Rating__c> ratsQual = [Select Importance_coefficient__c, Certification_Rating__c, Role__c, Certification_Rating__r.name From Important_Rating__c where Certification_rating__r.Assessment_type__c='Qualitative' AND Certification_rating__r.Deactivated__c = false AND Importance_coefficient__c > 0 order by  Importance_coefficient__c desc];        
        
        Map<String, List<Important_Rating__c>> roleRatMap = new Map<String, List<Important_Rating__c>>();
        system.debug(' ratsQual '+ratsQual);
        for(Important_Rating__c i: ratsQual){
            if(roleRatMap.keySet().contains(i.Role__c)){
                roleRatMap.get(i.Role__c).add(i);
            }
            else{
                List<Important_Rating__c> impLi = new List<Important_Rating__c>();
                impLi.add(i);
                roleRatMap.put(i.Role__c, impLi);
            }
        }

        system.debug(' roleRatMap '+roleRatMap);
       
        for(String role: roleRatMap.keySet()){
            
            ratsQual = roleRatMap.get(role);
            
            List<Important_Rating__c> rat70Qual = new List<Important_Rating__c>();
            Decimal limQual = 0;
            
            for(Important_Rating__c r :ratsQual){
                if((limQual < 70 || rat70Qual.size() < 2) && rat70Qual.size() < 6){
                    rat70Qual.add(r);
                    limQual += r.Importance_coefficient__c;
                }
            }
            
            if( rat70Qual != null && rat70Qual.size() > 0){
                ratsQual = rat70Qual;
            }else if(ratsQual != null){
                ratsQual.clear();
            }
            
            List<id> certIds = new List<id>();
             
            for(Important_Rating__c r:ratsQual){
                certIds.add(r.Certification_Rating__c);    
            }
            
            roleRatIdMap.put(role,certIds);
        }
        
        system.debug(' roleRatIdMap '+roleRatIdMap);
    }
       
    public Database.QueryLocator start(Database.BatchableContext con){
         
        return Database.getQueryLocator('SELECT Id,Role__c, User_Record_Name__c, Number_of_meetings_YTD__c,X12_Month_Average_Selling_Price__c,X12_Month_Lead_Conv_for_1_oppty__c,X12_Month_Rolling_Average_Sales_Cycle__c,X12_Month_Rolling_Close_Rate__c,X12_Month_Rolling_Opportunity_Close_Rate__c,Average_Deal_Size__c FROM Sales_Rep_Profile__c Where Active__c = TRUE    ');
    }

    public void execute(Database.BatchableContext con, List<Sales_Rep_Profile__c> srp){
        try{
            
            Set<id> userIds = new Set<id>();
            
            for(Sales_rep_profile__c s: srp){
                userIds.add(s.id);
            }        
            
            Date monthlyDue;
            
            list<Certification_Answer__c> cerDuedateMonthly = new list<Certification_Answer__c>();
                
            cerDuedateMonthly  =[select id, Due_Date__c from Certification_Answer__c where Certifcation_Rating__r.Timing__c = 'End of month' And Rating_Score__c != null AND Due_Date__c  != null AND  Certifcation_Rating__r.Assessment_type__c='Qualitative' AND Due_Date__c < TODAY order by Due_Date__c  Desc limit 1];
               
            if(cerDuedateMonthly != null && cerDuedateMonthly.size()>0){
                monthlyDue = cerDuedateMonthly[0].Due_Date__c;
            }
            
            system.debug(' monthlyDue '+monthlyDue);
            
            Date quarterlyDue;
            
            list<Certification_Answer__c> cerDuedateQuarterly = new list<Certification_Answer__c>();
                
            cerDuedateQuarterly  =[select id, Due_Date__c from Certification_Answer__c where Certifcation_Rating__r.Timing__c = 'End of quarter' And Rating_Score__c != null AND Due_Date__c  != null AND  Certifcation_Rating__r.Assessment_type__c='Qualitative' AND Due_Date__c < TODAY order by Due_Date__c  Desc limit 1];
               
            if(cerDuedateQuarterly != null && cerDuedateQuarterly.size()>0){
                quarterlyDue = cerDuedateQuarterly[0].Due_Date__c;
            }
            
            system.debug(' quarterlyDue '+quarterlyDue);
            
            Date biAnnDue;
            
            list<Certification_Answer__c> cerDuedateBiann = new list<Certification_Answer__c>();
                
            cerDuedateBiann  =[select id, Due_Date__c from Certification_Answer__c where Certifcation_Rating__r.Timing__c = 'Bi-annual' And Rating_Score__c != null AND Due_Date__c  != null AND  Certifcation_Rating__r.Assessment_type__c='Qualitative' AND Due_Date__c < TODAY order by Due_Date__c  Desc limit 1];
               
            if(cerDuedateBiann != null && cerDuedateBiann.size()>0){
                biAnnDue = cerDuedateBiann[0].Due_Date__c;
            }

            system.debug(' biAnnDue '+biAnnDue);
            
            Date annDue;
            
            list<Certification_Answer__c> cerDuedateAnn = new list<Certification_Answer__c>();
                
            cerDuedateAnn  =[select id, Due_Date__c from Certification_Answer__c where Certifcation_Rating__r.Timing__c = 'Annual' And Rating_Score__c != null AND Due_Date__c  != null AND  Certifcation_Rating__r.Assessment_type__c='Qualitative' AND Due_Date__c < TODAY order by Due_Date__c  Desc limit 1];
               
            if(cerDuedateAnn != null && cerDuedateAnn.size()>0){
                annDue = cerDuedateAnn[0].Due_Date__c;
            }

            system.debug(' annDue '+annDue);
                            
            //Fetch the answers with the latest due date for the sales profiles, Create a map of rep versus answers
           
            
            Map<Id, Map<id,Decimal>> repRatingScore = new Map<Id, Map<id,Decimal>> (); 
            //Iterate through each set of answers fetch only the important ratings and calculate the average score
            List<Certification_answer__c> ans = [SELECT Certifcation_rating__c, Certifcation__c, Sales_rep_profile__r.Role__c, Rating_score__c FROM Certification_Answer__c WHERE Sales_rep_profile__c IN :userIds AND ((Certifcation_Rating__r.Timing__c = 'Annual' AND Due_Date__c = :annDue) OR (Certifcation_Rating__r.Timing__c = 'Bi-annual' AND Due_Date__c = :biAnnDue) OR (Certifcation_Rating__r.Timing__c = 'End of quarter' AND Due_Date__c = :quarterlyDue) OR (Certifcation_Rating__r.Timing__c = 'End of month' AND Due_Date__c = :monthlyDue)) AND Rating_score__c != null];
            
            system.debug(' cert ans '+ans);
            
            for(Certification_answer__c ca: ans){
            
                system.debug(' repRatingScore '+roleRatIdMap.get(ca.Sales_rep_profile__r.Role__c));
                system.debug(' ca.Sales_rep_profile__r.Role__c '+ca.Sales_rep_profile__r.Role__c);
                system.debug(' ca.Certifcation_rating__c '+ca.Certifcation_rating__c);
                system.debug(' ca.Rating_score__c '+ca.Rating_score__c);
                
                if (roleRatIdMap.get(ca.Sales_rep_profile__r.Role__c) != null && roleRatIdMap.get(ca.Sales_rep_profile__r.Role__c).contains(ca.Certifcation_rating__c)){
                    Map<id,Decimal> ratScoreMap = new Map<id,Decimal>();
                    ratScoreMap.put(ca.Certifcation_rating__c,ca.Rating_score__c);
                    repRatingScore.put(ca.Certifcation__c,ratScoreMap);
                }
            }
            
            system.debug(' repRatingScore '+repRatingScore);
            
            List<Certification__c> certs = new List<Certification__c>();
            
            //Calculate average and populate it in the qualitative score field

            for(Id k:repRatingScore.keySet()){
                
                if(repRatingScore.get(k) != null){
                    List<Decimal> scores = repRatingScore.get(k).values();
                    Decimal total = 0;
                    Double dAvg;

                    for (Decimal d : scores) {
                        total += d;
                    }
                    
                    dAvg = Double.valueOf(total) / scores.size();
                    system.debug(' avg '+dAvg);
                    Certification__c c = new Certification__c();
                    c.id = k;
                    c.Overall_Qualitative_Rating__c = dAvg;
                    c.Individual_Qualitative_Rating__c = dAvg;
                    certs.add(c);
                }
                
            }
            
            //update certifications
            system.debug(' certs '+certs);
            update certs;
        }
        catch(Exception ex){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelQualScoreBatch '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
    }
    
    public void finish(Database.BatchableContext con){
        if(!errorVal){
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelQualScoreBatch Qual scores are successfully updated ');                         
        }
    }
    
}