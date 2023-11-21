/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelScheduleDataPush implements Schedulable {
   
   global void execute(SchedulableContext SC) {
      /*
      FunnelPostAPIs fp = new FunnelPostAPIs();
      fp.getAccessToken();
      fp.createQualRating();
      fp.createQuantRating();
          
      List<Sales_rep_profile_snapshot__c> snaps = new List<Sales_rep_profile_snapshot__c>();
      
      snaps = [SELECT Snapshot_scheduled_date__c FROM Sales_rep_profile_snapshot__c ORDER BY Snapshot_scheduled_date__c DESC LIMIT 1];
      
      if(snaps != null && snaps.size() > 0){
          
          Date snapDate = snaps[0].Snapshot_scheduled_date__c;
                    
          fp.dtSnapShot = snapDate;
          fp.createQuantMetric();
          
      }            
      
      List<Certification_Answer__c> ans = new List<Certification_Answer__c>();
      
      ans = [SELECT Due_date__c FROM Certification_Answer__c WHERE Rating_score__c != null AND Due_date__c != null AND Certifcation_Rating__r.Assessment_type__c = 'Qualitative' ORDER BY Due_date__c DESC LIMIT 1];
      
      if(snaps != null && snaps.size() > 0){
          
          Date qualSnapDate = ans[0].Due_date__c;          
          
          fp.dtSnapShot = qualSnapDate;
          fp.createQualMetric();           

      }
      
   */   
   }
}