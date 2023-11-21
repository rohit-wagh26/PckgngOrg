trigger FunnelPlatformEvent on Opportunity_update__e (after insert) {
   Set<Id> salesProfIds = new Set<Id>(); 
   
   
   for(Opportunity_update__e e : Trigger.new){
       salesProfIds.add(e.OwnerId__c);
   }
       
   try{  
       //Map to store the sales profiles to be updated
        Map<id, Sales_Rep_Profile__c> profMap = new Map<id, Sales_Rep_Profile__c>();
       
       //If there are any sales profiles associated to the inserted/updated opportunities
       //The corresponding YTD fields and correct active opportunities fields are updated
       if(salesProfIds != null){       
           profMap =  FunnelTriggerBatchHelper.fetchSalesProfileUpdatedMapFromOwners(salesProfIds,null);           
       } 
       
       system.debug(' profMap.values() '+profMap.values());
                
        //If a sales profile was previously associated with an opportunity and is not associated with any opportunity now
        //Current active opportunities field should be updated to 0     
        if(salesProfIds != null && salesProfIds.size() > 0 && salesProfIds.size() != profMap.values().size()){        
            FunnelTriggerBatchHelper.updateSalesProfsNotAssociatedWithAnyOpptyUsingOwner(salesProfIds,profMap);
        }
         system.debug('Limits afterupdateSalesProfsNotAssociatedWithAnyOpptyUsingOwner trigger'+Limits.getQueries());
        //system.debug(' profMap.values() '+profMap.values());
        
        List<Sales_Rep_Profile__c> profValues = profMap.values();
        
        //Update all the sales representative profiles that have been updated
        if(profMap != null && profMap.size() > 0){
            update profMap.values();
        }
        
        system.debug('Checkpoint 3 trigger'+Limits.getCpuTime());
        
        //system.debug(' profValues are '+profValues);
     }catch(Exception ex){
        System.debug('FunnelPlatformEvent Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
        FunnelTriggerBatchHelper.sendErrorMail(ex.getMessage()+' '+ex.getStackTraceString()); 
     }    
}