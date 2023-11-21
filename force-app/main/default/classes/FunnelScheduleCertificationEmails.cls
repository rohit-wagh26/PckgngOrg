/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelScheduleCertificationEmails implements Schedulable {
   global void execute(SchedulableContext SC) {
       
          //FunnelTestBatch1 M = new FunnelTestBatch1(Date.today()+2);
          FunnelCertificationsDailyBatch m = new FunnelCertificationsDailyBatch();      
          database.executebatch(m);
       
   }
}