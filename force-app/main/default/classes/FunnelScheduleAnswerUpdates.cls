/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelScheduleAnswerUpdates implements Schedulable {
   global void execute(SchedulableContext SC) {
      
      Set<id> profIds = new Set<id>();
      List<AggregateResult> ars = [SELECT Sales_rep_profile__c sr FROM Certification_Answer__c WHERE Rating_Score__c = null AND Due_Date__c < TODAY GROUP BY Sales_rep_profile__c];
      
      for(AggregateResult ar: ars){
          profIds.add((Id)ar.get('sr'));
      }
      
      FunnelUpdateBlankAnswers m = new FunnelUpdateBlankAnswers(profIds);      
      database.executebatch(m);
   }
}