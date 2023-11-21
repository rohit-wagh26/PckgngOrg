/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelCalculateHistoricalDataBatch implements Database.Batchable<sobject>, Database.Stateful{
    
    List<Sales_Rep_Profile__c> salesReps = new List<Sales_Rep_Profile__c>();
        
    public Boolean createAccess = true;
    
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    
    Boolean histBatchVal;
    Date histDateVal;
    DateTime histDateTimeVal;
    Boolean errorVal = false;
    
    public FunnelCalculateHistoricalDataBatch(Date histDate, Boolean histBatch){
        histBatchVal = histBatch;
        histDateVal = histDate;
        histDateTimeVal = DateTime.newInstance(histDateVal.year(),histDateVal.month(),histDateVal.day());     
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
         
        return Database.getQueryLocator('SELECT Id, User_Record_Name__c, YTD_Opportunities_won__c, YTD_Opportunities_Added__c FROM Sales_Rep_Profile__c WHERE (Active__c = TRUE OR Annual_Quota_Amount__c > 0)');
    }
    
    public void execute(Database.BatchableContext con, List<Sales_Rep_Profile__c> profs){
        
        try{    
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
                
            //The corresponding YTD fields and correct active opportunities fields are updated
            if(ownerIds != null){       
                profMap =  FunnelHistoricalBatchHelper.fetchCounterRelatedFields(ownerIds,null);           
            }      
                    
            system.debug(' profMap.values() '+profMap.values());
            
            salesReps.addAll(profMap.values());
        }
        catch(Exception ex){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail('FunnelCalculateHistoricalDataBatch '+ex.getMessage()+' '+ex.getStackTraceString()+' '+ex.getLineNumber());
        }
    }
    
    public void finish(Database.BatchableContext con){
        //FunnelTriggerBatchHelper.sendErrorMail(' FunnelCalculateHistoricalDataBatch finish method');
        if(!errorVal){
            
            update salesReps;
            if(!histBatchVal){ 
              //  FunnelTriggerBatchHelper.sendErrorMail(' FunnelCalculateHistoricalDataBatch finish method no error ');
            }
            if(histBatchVal){
                FunnelQuantitativeBatchMonthly fb = new FunnelQuantitativeBatchMonthly(histDateVal,true,histBatchVal);
                Database.executeBatch(fb,100);            
            } 
        }                                    
    }
    
}