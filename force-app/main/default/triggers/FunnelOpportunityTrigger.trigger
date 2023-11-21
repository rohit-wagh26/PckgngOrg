/*
    Author:  Carine DMello
    Created On: 11/3/2017
    This trigger updates fields on the Sales rep profile object associated with an opportunity
    It is triggered each time an opportunity is inserted or updated
    Copyright: Funnel Metrics LLC
*/

trigger FunnelOpportunityTrigger on Opportunity (after insert, after update) {
    if(trigger.isUpdate){
        OpportunityHistoryTrackingHandler.onAfterUpdate(trigger.new,trigger.oldmap);
    }
    if(trigger.isInsert){
        OpportunityHistoryTrackingHandler.onAfterUpdate(trigger.new,Null);
    }
     system.debug('Quries Limits Start of trigger'+Limits.getQueries());   
     system.debug('cuptime Limits Start of trigger '+Limits.getCpuTime());
    //Set to store the sales rep id's that are associated with the inserted/updated opportunities
    Set<Id> salesProfIds = new Set<Id>();        
    
    New_Data_load_setting__mdt[] mtDt = [SELECT Bypass__c FROM New_Data_load_setting__mdt LIMIT 1];
    Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues('Current_Year');
    
    if((test.isRunningTest() && fy != null   ) || (fy != null  && mtDt != null && mtDt.size() > 0 &&  !mtDt[0].Bypass__c ) || (mtDt == NULL && fy != null ) ){
     
        system.debug(' inside oppty trigger ');
        
        Map<id,Opportunity> oppNewmap = new Map<id,Opportunity>();
        Map<id,Opportunity> oppOldmap = new Map<id,Opportunity>();
        List<Opportunity> triggernew = new List<Opportunity>();
        
        List<Opportunity_update__e> eventlist = new List<Opportunity_update__e>();
        Set<id> oppownerId = new Set<id>();
        
        try{
            //Increment/Decrement the counter fields on sales profile
            //Close rate monthly/quarterly/ytd opp count/amount
            if(trigger.isinsert){
                system.debug(' insert scenario ');
                
                FunnelTriggerBatchHelper.updateSalesProfsCounterQO(Trigger.newMap,Trigger.new);
                system.debug('Limits after updateSalesProfsCounterQO trigger'+Limits.getQueries());
            }
            
           for(Opportunity o : Trigger.new){
                
                if(o.OwnerId != null){ 
                     oppownerId.add(o.OwnerId);
                }
                
                 if(trigger.isupdate){
                    if((Trigger.oldMap.get(o.id).Probability != Trigger.newMap.get(o.id).Probability) || (Trigger.oldMap.get(o.id).CloseDate != Trigger.newMap.get(o.id).CloseDate) || (Trigger.oldMap.get(o.id).IsClosed == false && Trigger.newMap.get(o.id).IsClosed == true && Trigger.newMap.get(o.id).IsWon  == false) ){ 
                       
                        triggernew.add(o);
                        oppNewmap.put(o.id,Trigger.newMap.get(o.id)) ;
                        oppOldmap.put(o.id,Trigger.oldMap.get(o.id)) ;             
                                       
                      }
                      
                      if(Trigger.oldMap.get(o.id).OwnerId != null){
                           oppownerId.add(Trigger.oldMap.get(o.id).OwnerId);
                      }
                  }
            }
            
            if(trigger.isupdate){
                if(triggernew != null && triggernew.size()>0){
                    FunnelTriggerBatchHelper.updateSalesProfsCounter(oppNewmap,oppOldmap,triggernew);
                }
                  
             }
             
            for(ID i : oppownerId){
                Opportunity_update__e ou = new Opportunity_update__e(OwnerId__c= i);
                eventlist.add(ou);
            } 
            
            List<Database.SaveResult> s = EventBus.publish(eventlist);
            // Inspect publishing result
            for(Database.SaveResult sr :s){
                if (sr.isSuccess()) {
                    System.debug('Successfully published event.');
                } else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Error returned: ' +
                                     err.getStatusCode() +
                                     ' - ' +
                                     err.getMessage());
                    }
                }
            }
            
         }
         catch(Exception ex){
            System.debug('FunnelOpportunityTrigger Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(ex.getMessage()+' '+ex.getStackTraceString()); 
         } 
         
         system.debug('Quries Limits after update'+Limits.getQueries());   
         system.debug('Cuptime Limits after update '+Limits.getCpuTime());
         
           
    }
    
}