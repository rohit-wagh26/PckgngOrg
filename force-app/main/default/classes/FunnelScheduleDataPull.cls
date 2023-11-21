/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelScheduleDataPull implements Schedulable {
   
   global void execute(SchedulableContext SC) {
       
      /*try{   
          //FunnelGetApis fp = new FunnelGetApis();
          //fp.getandUpdateFSQS();   
          
          FunnelPullScores m = new FunnelPullScores();      
          database.executebatch(m); 
      }
      catch(Exception ex){
            FunnelTriggerBatchHelper.sendErrorMail(ex.getMessage(),ex.getStackTraceString());  
      }*/ 
      
   }
}