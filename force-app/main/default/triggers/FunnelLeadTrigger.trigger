/*
    Author:  Carine DMello
    Created On: 4/17/2017
    This trigger updates fields on the Sales rep profile object associated with an lead
    It is triggered each time a lead is inserted
*/

trigger FunnelLeadTrigger on Lead (after insert, after update) {
    
    Boolean ownerChanged = false;
        
    for(Lead o : Trigger.new){
        if(trigger.isupdate){
            if(Trigger.oldMap.get(o.id).OwnerId != Trigger.newMap.get(o.id).OwnerId ){ 
               
                ownerChanged = true;             
                               
              }
              
        }
    }
            
    if(trigger.isinsert || ownerChanged ){      
        //Set to store the sales rep id's that are associated with the inserted/updated leads
        Set<Id> salesProfIds = new Set<Id>();        
        
        New_Data_load_setting__mdt[] mtDt = [SELECT Bypass__c FROM New_Data_load_setting__mdt LIMIT 1];
        Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues('Current_Year');
        
        if((test.isRunningTest() && fy != null   ) || (fy != null  && mtDt != null && mtDt.size() > 0 &&  !mtDt[0].Bypass__c ) || (mtDt == NULL && fy != null ) ){
        
        //if(mtDt == NULL || (mtDt != null && mtDt.size() == 0) || test.isRunningTest() || (mtDt != null && mtDt.size() > 0 && !mtDt[0].Bypass__c)){
        
            try{
                system.debug(' Trigger.new '+Trigger.new);
                
                //Fetch all the sales profiles that are associated with the updated leads
                salesProfIds = FunnelTriggerBatchHelper.fetchRelatedLeadOwners(Trigger.new, Trigger.old);
                
                system.debug(' salesProfIds '+salesProfIds);
                
                //Map to store the sales profiles to be updated
                Map<id, Sales_Rep_Profile__c> profMap = new Map<id, Sales_Rep_Profile__c>();
                
                //If there are any sales profiles associated to the inserted/updated leads
                //The corresponding YTD fields are updated
                profMap =  FunnelTriggerBatchHelper.fetchSalesProfileUpdatedMapFromLeadOwners(salesProfIds);   
                
                system.debug(' profMap.values() '+profMap.values());
            
                List<Sales_Rep_Profile__c> profValues = profMap.values();
                
                //Update all the sales representative profiles that have been updated
                if(profMap != null && profMap.size() > 0){
                    update profMap.values();
                }            
            }
            catch(Exception ex){
                System.debug('FunnelLeadTrigger Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
                FunnelTriggerBatchHelper.sendErrorMail(ex.getMessage()+' '+ex.getStackTraceString()); 
            }  
        }  
    }
}