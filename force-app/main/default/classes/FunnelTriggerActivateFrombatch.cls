/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelTriggerActivateFrombatch implements Schedulable {
   
   global void execute(SchedulableContext SC) {
       
      try{   
          FunnelTriggerBatchHelper.activateTrigger();
          
      }
      catch(Exception ex){
            FunnelTriggerBatchHelper.sendErrorMail(ex.getMessage(),ex.getStackTraceString());  
      }   
      
   }
}