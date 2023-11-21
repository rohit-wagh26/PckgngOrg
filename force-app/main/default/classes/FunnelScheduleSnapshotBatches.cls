/*
Copyright: Funnel Metrics, LLC
*/
global with Sharing class FunnelScheduleSnapshotBatches implements Schedulable {
   
   global void execute(SchedulableContext SC) {
      //FunnelMonthlySalesProfSnapshotBatch m = new FunnelMonthlySalesProfSnapshotBatch(Date.today());      
      FunnelSalesCycleBatch myBatchObject = new FunnelSalesCycleBatch(Date.today(),true,false); 
      Id batchId = Database.executeBatch(myBatchObject);
   }
}