/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelUpdateBlankAnswers implements Database.Batchable<sobject>, Database.Stateful, Database.AllowsCallouts{
    
    Set<id> profIds = new Set<id>();
    
    String prof = '';
    
    Map<id,Map<id,Certification_answer__c>> profRatingAnswerMap;
    
    Boolean errorVal = false;
           
    public FunnelUpdateBlankAnswers(Set<id> profIds){
        
        profIds = profIds;
        
        for(id i:profIds){
            if(prof == ''){
                prof = prof +'\''+i+'\'';
            }
            else{
                prof = prof +',\''+i+'\'';
            }
        }
        
        system.debug(' prof '+prof);
    }
       
    public Database.QueryLocator start(Database.BatchableContext con){
         system.debug(' prof '+prof);
         String query;
         if(prof != ''){
              query = 'SELECT Id FROM Sales_rep_profile__c WHERE id In ('+prof+')';
         }else{
              query = 'SELECT Id FROM Sales_rep_profile__c Limit 1';
             system.debug(' query '+query );
         }
         
         return Database.getQueryLocator(query);
    }        
    
    public void execute(Database.BatchableContext con, List<Sales_rep_profile__c> sp){                
        try{    
            system.debug(' profs '+sp);     
            if(prof != ''){
                Set<id> reps = new Set<id>();
                
                for(Sales_rep_profile__c s: sp){
                    reps.add(s.id);
                }
                
                profRatingAnswerMap = new Map<id,Map<id,Certification_answer__c>>();
                
                List<Certification_Answer__c> prevAns = [SELECT Sales_rep_profile__c, Certifcation_Rating__c, Rating_score__c FROM Certification_Answer__c WHERE Rating_Score__c != NULL AND ((Certifcation_Rating__r.Timing__c = 'End of month' AND Due_Date__c = LAST_N_DAYS :40) OR (Certifcation_Rating__r.Timing__c = 'End of Quarter' AND Due_Date__c = LAST_N_DAYS :98) OR (Certifcation_Rating__r.Timing__c = 'Bi-annual' AND Due_Date__c = LAST_N_DAYS :189) OR (Certifcation_Rating__r.Timing__c = 'Annual' AND Due_Date__c = LAST_N_DAYS :360)) AND Sales_rep_profile__c IN :reps ORDER BY Due_date__c DESC];                                
            
                for(Certification_Answer__c c: prevAns){
                    if(profRatingAnswerMap.containskey(c.Sales_rep_profile__c)){
                        if(!profRatingAnswerMap.get(c.Sales_rep_profile__c).containsKey(c.Certifcation_Rating__c)){
                            profRatingAnswerMap.get(c.Sales_rep_profile__c).put(c.Certifcation_Rating__c,c);
                        }
                    }
                    else{
                        Map<id,Certification_answer__c> ratAnsMap = new Map<id,Certification_answer__c>();
                        ratAnsMap.put(c.Certifcation_rating__c,c);
                        profRatingAnswerMap.put(c.Sales_rep_profile__c,ratAnsMap);
                    }
                }
                
                List<Certification_Answer__c> blankAns = [SELECT Sales_rep_profile__c, Rating_score__c, Certifcation_Rating__c FROM Certification_Answer__c WHERE Rating_Score__c = NULL AND Due_date__c < TODAY AND Sales_rep_profile__c IN :reps];                                
                
                system.debug(' blankAns '+blankAns);
                
                for(Certification_Answer__c b: blankAns){
                    system.debug(' cert id '+b.id);
                    
                    if(profRatingAnswerMap.get(b.Sales_rep_profile__c) != null && profRatingAnswerMap.get(b.Sales_rep_profile__c).get(b.Certifcation_Rating__c) != null){
                        b.Rating_score__c = profRatingAnswerMap.get(b.Sales_rep_profile__c).get(b.Certifcation_Rating__c).Rating_score__c;
                        system.debug(' b.Rating_score__c '+b.Rating_score__c);
                    }
                    else{
                        b.Rating_score__c = 0;
                        system.debug(' b.Rating_score__c blank '+b.Rating_score__c);
                    }
                    b.Auto_updated__c = true;
                    
                    system.debug(' cert score '+b.rating_score__c);
                }
                
                system.debug(' blankAns '+blankAns);
                
                update blankAns;                         
                
                Set<id> deleteAns = new Set<id>();
                system.debug(' profIds to create answers '+reps);
                FunnelCreateCertAnswers_Controller.deleteAndCreateCertAnswers(deleteAns,reps,'batch'); 
            }
        }
        catch(Exception ex){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelUpdateBlankAnswers '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        }              
            
    }        
    
    public void finish(Database.BatchableContext con){                 
        
        try{    
            system.debug(' profRatingAnswerMap '+profRatingAnswerMap);                                        
            
            if(!Test.isRunningTest() && !errorVal){
            
                //FunnelPostAPIs fp = new FunnelPostAPIs();
                //fp.getAccessToken();
                
                /*FunnelPushQuantData fpu = new FunnelPushQuantData();
                database.executeBatch(fpu);
                  
                FunnelPushQualData fq = new FunnelPushQualData();
                database.executeBatch(fq);*/
            }                                 
        
        }
        catch(Exception ex){
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelUpdateBlankAnswers '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        }
          
    }
    
    //SELECT Id, Certifcation_Rating__c, Certifcation_Rating__r.Timing__c, Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Rating_Score__c, Due_Date__c FROM Certification_Answer__c WHERE Certifcation_Rating__r.Timing__c = 'end of month' ORDER BY Certifcation_Rating__c ASC, Sales_Rep_Profile__r.name ASC
    
}