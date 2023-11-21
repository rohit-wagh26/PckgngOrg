global with sharing class FMScheduledUpdateManagerFSQS Implements Schedulable{

   /* public Interface IScheduleDispached{
        void execute(SchedulableContext sc);
    }
*/
    global void execute(SchedulableContext sc){
       /* Type targetType = Type.forName('FMManagerAggregateAfterDataPull');
        if(targetType != null){
            IScheduleDispached obj = (IScheduleDispached)targetType.newInstance();
            obj.execute(sc);
        }*/
        List<id> certsScoreUpdate = new List<Id>();
        for(Certification__c c : [Select id from Certification__c Limit 5000] ){
            certsScoreUpdate.add(c.id);
        
        }
        
        if(certsScoreUpdate.size() > 0){
            CalculateScoreAggregates.findScoreAggregate(certsScoreUpdate);
            system.debug(' score updates completed ');
        }
    }


}