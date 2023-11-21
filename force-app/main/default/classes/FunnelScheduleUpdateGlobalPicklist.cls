global class FunnelScheduleUpdateGlobalPicklist implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        
        //BatchToUpdateGlobalPicklist m = new BatchToUpdateGlobalPicklist();   
        BatchToUpdateGlobalPicklistValue m = new BatchToUpdateGlobalPicklistValue();  
        database.executebatch(m);
        RescheduleJob();
    }
    
    public void RescheduleJob(){
        // If job currently scheduled remove it
       	List<CronTrigger> SchJobs = [SELECT Id FROM CronTrigger where CronJobDetail.Name = 'Funnel Update Global Picklist'];
        String MyJobID;
        if (SchJobs.size() > 0){
            MyJobID = SchJobs[0].Id;
            // removing the job from the schedule
            System.abortjob(MyJobID); 
        }
        // calculating the minute mark which is 5 minutes from now
        DateTime Cdatetime = DateTime.now();  
        DateTime NewDateTime;
        NewDateTime = Cdatetime.addMinutes(2);                        // Reschedule job in 2 minutes from time job finishes
        Integer min = NewDateTime.minute();
        // scheduling job for a certain minute of the hour
        String sch = '0 ' + string.valueOf(min) + ' * * * ? ';
        // rescheduling the job
        System.schedule('Funnel Update Global Picklist', sch, new FunnelScheduleUpdateGlobalPicklist());        
    }
}