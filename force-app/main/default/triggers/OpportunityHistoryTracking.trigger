trigger OpportunityHistoryTracking on Opportunity (after Update, after insert) 
{
if(trigger.isUpdate){
   OpportunityHistoryTrackingHandler.onAfterUpdate(trigger.new,trigger.oldmap);
   }
   if(trigger.isInsert){
   OpportunityHistoryTrackingHandler.onAfterUpdate(trigger.new,Null);
   }
}