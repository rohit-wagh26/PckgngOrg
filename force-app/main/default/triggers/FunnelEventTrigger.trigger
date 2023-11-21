/*
    Author:  Carine DMello
    Created On: 2/15/2022
    This trigger updates fields on the Sales rep profile object associated with an event
    It is triggered each time an event is inserted or updated
*/

trigger FunnelEventTrigger on Event (after insert, after update) {
    
    New_Data_load_setting__mdt[] mtDt = [SELECT Bypass__c FROM New_Data_load_setting__mdt LIMIT 1];
    Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues('Current_Year');
    
     if((test.isRunningTest() && fy != null   ) || (fy != null  && mtDt != null && mtDt.size() > 0 &&  !mtDt[0].Bypass__c ) || (mtDt == NULL && fy != null ) ){
        Set<id> eventOwnerId = new Set<id>();
        
        for(Event e : Trigger.new){
            
            if(trigger.isInsert){        
                if(e.OwnerId != null){ 
                    eventOwnerId.add(e.OwnerId);
                }
            }
            
            if(trigger.isupdate){            
                if((Trigger.oldMap.get(e.id).OwnerId != Trigger.newMap.get(e.id).OwnerId) || (Trigger.oldMap.get(e.id).Type != Trigger.newMap.get(e.id).Type)){             
                    eventOwnerId.add(e.OwnerId); 
                    if((Trigger.oldMap.get(e.id).OwnerId != Trigger.newMap.get(e.id).OwnerId)){
                         eventOwnerId.add(Trigger.oldMap.get(e.id).OwnerId); 
                    }                                       
                }            
            }
        }
        
        if(eventOwnerId != null && eventOwnerId.size() > 0){
            
            FunnelTriggerBatchHelper.fetchMeetingsFromEvents(eventOwnerId);
        
        }
    }
}