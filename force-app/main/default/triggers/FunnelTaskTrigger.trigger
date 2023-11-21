trigger FunnelTaskTrigger on Task (after insert, after update) {
    
    New_Data_load_setting__mdt[] mtDt = [SELECT Bypass__c FROM New_Data_load_setting__mdt LIMIT 1];
    Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues('Current_Year');
    
     if((test.isRunningTest() && fy != null   ) || (fy != null  && mtDt != null && mtDt.size() > 0 &&  !mtDt[0].Bypass__c ) || (mtDt == NULL && fy != null ) ){
        Set<id> taskOwnerId = new Set<id>();
        
        for(Task t : Trigger.new){
            
            if(trigger.isInsert){        
                if(t.OwnerId != null){ 
                    taskOwnerId.add(t.OwnerId);
                }
            }
            
            if(trigger.isupdate){            
                if((Trigger.oldMap.get(t.id).OwnerId != Trigger.newMap.get(t.id).OwnerId) || (Trigger.oldMap.get(t.id).Type != Trigger.newMap.get(t.id).Type)){             
                    taskOwnerId.add(t.OwnerId); 
                    if((Trigger.oldMap.get(t.id).OwnerId != Trigger.newMap.get(t.id).OwnerId)){
                         taskOwnerId.add(Trigger.oldMap.get(t.id).OwnerId); 
                    }                                       
                }            
            }
        }
        
        if(taskOwnerId != null && taskOwnerId.size() > 0){
            
            FunnelTriggerBatchHelper.fetchMeetingsFromEvents(taskOwnerId);
        
        }
    }
}