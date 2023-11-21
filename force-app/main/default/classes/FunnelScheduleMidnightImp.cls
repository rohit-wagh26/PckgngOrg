/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelScheduleMidnightImp implements Schedulable {
   
   global void execute(SchedulableContext SC) {
       
      try{   
          
          List<Sales_Rep_Profile_Snapshot__c> ss = [Select id from Sales_Rep_Profile_Snapshot__c Limit 10 ];
          Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues('Current_Year');
         
         if(ss == null || (ss != null && ss.size() == 0)){
                Date fyd  = fy.Start_Date__c;
                Date histDateValue = Date.newinstance(fyd.year(), fyd.month(), date.daysInMonth(fyd.year(), fyd.month()));
                FunnelQuotaUpdateBatch fq = new FunnelQuotaUpdateBatch(histDateValue,true,true);
                Database.executeBatch(fq);
          }
      }
      catch(Exception ex){
            FunnelTriggerBatchHelper.sendErrorMail(ex.getMessage(),ex.getStackTraceString());  
      }   
      
   }
}