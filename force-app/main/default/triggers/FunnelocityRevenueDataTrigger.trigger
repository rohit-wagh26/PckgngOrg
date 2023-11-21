/*
    Author:  Arfiyan Shaikh
    Created On: 4/20/2021
     
    Copyright: Funnel Metrics LLC
*/

trigger FunnelocityRevenueDataTrigger on Funnelocity_Revenue_data__c (after insert, after update) {
    
    Set<Id> salesProfIds = new Set<Id>();        
    
    New_Data_load_setting__mdt[] mtDt = [SELECT Bypass__c FROM New_Data_load_setting__mdt LIMIT 1];
    Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues('Current_Year');
    
    if((test.isRunningTest() && fy != null   ) || (fy != null  && mtDt != null && mtDt.size() > 0 &&  !mtDt[0].Bypass__c ) || (mtDt == NULL && fy != null ) ){
      
         
         try{        
             
            for(Funnelocity_Revenue_data__c r : Trigger.new){
				salesProfIds.add(r.Sales_Rep_Profile__c);
			}
            system.debug(' salesProfIds '+salesProfIds);
                
            //Map to store the sales profiles to be updated
            Map<id, Sales_Rep_Profile__c> profMap = new Map<id, Sales_Rep_Profile__c>();    
        
            
            if(salesProfIds != null){       
                profMap =  FunnelTriggerBatchHelper.updateHybridRevenue(salesProfIds);           
            }    
             
            List<Sales_Rep_Profile__c> profValues = profMap.values();
            
            if(profMap != null && profMap.size() > 0){
                update profMap.values();
            }
            
             system.debug(' profValues are '+profValues);
         }
         catch(Exception ex){
            System.debug('FunnelocityRevenueDataTrigger Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(ex.getMessage()+' '+ex.getStackTraceString()); 
         }
    }
     
}