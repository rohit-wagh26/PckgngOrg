/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelCalculateYTDFieldsBatch implements Database.Batchable<sobject>, Database.Stateful{
    
    List<Sales_Rep_Profile__c> salesReps = new List<Sales_Rep_Profile__c>();
        
    public Boolean createAccess = true;
    
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    
    Boolean histBatchVal;
    Boolean chainVal;
    Date histDateVal;
    DateTime histDateTimeVal;
    
    Boolean errorVal = false;
    List<Sales_Rep_Profile__c> srp =[SELECT Id, User_Record_Name__c FROM Sales_Rep_Profile__c WHERE Active__c = TRUE OR Annual_Quota_Amount__c > 0];    
   
    
    public FunnelCalculateYTDFieldsBatch(Date histDate, Boolean chain, Boolean historical){
        
        //FunnelTriggerBatchHelper.sendErrorMail(' in constructor ');
        
        histBatchVal = historical;
        chainVal = chain;
        histDateVal = histDate;
        system.debug(' histDateVal '+histDateVal);
         system.debug(' srp '+srp );
        if(histDate != null)
            histDateTimeVal = DateTime.newInstance(histDate.year(),histDate.month(),histDate.day(),0,0,0);
    }
    
    
    public Database.QueryLocator start(Database.BatchableContext con){
        
        /*List<String> fldList1 = new List<String>{prefix+'weighted_score__c',prefix+'tenatative_rating_score__c',prefix+'snapshot_scheduled_date__c',prefix+'rating_start_date__c',prefix+'rating_score__c',prefix+'manager_email_date__c',prefix+'escalation_email_date__c',prefix+'due_date__c',prefix+'certification__c',prefix+'certification_rating__c',prefix+'certification_answer__c'};

        Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Certification_Answer_Snapshot__c').getDescribe().fields.getMap();
        
        for(String fldName: fldList1){
            if(!fieldMap1.get(fldName).getDescribe().isCreateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              createAccess = false;
              break;
            }                
        } */
        
        //FunnelTriggerBatchHelper.sendErrorMail(' in start method');
          
        return Database.getQueryLocator('SELECT Id, User_Record_Name__c FROM Sales_Rep_Profile__c WHERE (Active__c = TRUE OR Annual_Quota_Amount__c > 0)');
    }
    
    public void execute(Database.BatchableContext con, List<Sales_Rep_Profile__c> profs){
        
        try{    
            
            //FunnelTriggerBatchHelper.sendErrorMail(' in execute method');
            System.debug('Inside execute');
            Set<Id> ownerIds = new Set<Id>();
            
            //Fetch all the users associated with the sales profiles    
            for(Sales_Rep_Profile__c sp: profs){
                if(sp.User_Record_Name__c != null){
                    ownerIds.add(sp.User_Record_Name__c);
                }
            }
            
            system.debug(' ownerIds '+ownerIds);
               
            //Map to store the sales profiles to be updated
            Map<id, Sales_Rep_Profile__c> profMap = new Map<id, Sales_Rep_Profile__c>();    
            
            FunnelTriggerBatchHelper.histDataBatch = histBatchVal;
            
            FunnelTriggerBatchHelper.histDateVal = histDateVal;
            
            FunnelTriggerBatchHelper.histDateTimeVal = histDateTimeVal;
            
            //FunnelTriggerBatchHelper.sendErrorMail(' before calling batch helper '); 
                
            //The corresponding YTD fields and correct active opportunities fields are updated
            if(ownerIds != null){       
                profMap =  FunnelTriggerBatchHelper.fetchSalesProfileUpdatedMapFromOwners(ownerIds,null);           
            }      
            
            if(ownerIds != null && ownerIds.size() > 0 && ownerIds.size() != profMap.values().size()){        
                FunnelTriggerBatchHelper.updateSalesProfsNotAssociatedWithAnyOpptyUsingOwner(ownerIds,profMap);
            }
            
            system.debug(' profMap.values() '+profMap.values());
            
            salesReps.addAll(profMap.values());
            
            system.debug(' in execute '+FunnelTriggerBatchHelper.histDataBatch);
            
            //FunnelTriggerBatchHelper.sendErrorMail(' end of execute method '); 
            
            update salesReps;
        }
        catch(Exception ex){
            //FunnelTriggerBatchHelper.sendErrorMail(' catch block '); 
            errorVal = true;
            system.debug(' error occured '+ex.getMessage());
            FunnelTriggerBatchHelper.sendErrorMail('FunnelCalculateYTDFieldsBatch '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        }
    }
    
    public void finish(Database.BatchableContext con){
        
        //FunnelTriggerBatchHelper.sendErrorMail(' in finish method');
        
        if(!errorVal){
            
            try{
                
                
                if(chainVal){
                    FunnelCalculateYTDLeadsFieldsBatch  fb1 = new FunnelCalculateYTDLeadsFieldsBatch(histDateVal, chainVal, histBatchVal);
                    Database.executeBatch(fb1);
                }
            }
            catch(Exception ex){
                FunnelTriggerBatchHelper.sendErrorMail(' FunnelCalculateYTDFieldsBatch update failed '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());                                                          
            }
             
        }                                              
    }
    
}