/*
Copyright: Funnel Metrics, LLC
*/
global with sharing class FunnelMonthlyCertificationSnapshotBatch implements Database.Batchable<sobject>, Database.Stateful{
    
    Date triggerDate;
    
    public Boolean createAccess = true;
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    
    Boolean chainBatch;
    Boolean histVal;
    
    Boolean errorVal = false;
    
    public FunnelMonthlyCertificationSnapshotBatch(Date scheduleDate, Boolean chain,Boolean historical){
        triggerDate = scheduleDate;
         chainBatch = chain;
         histVal = historical;
    }
     
    
    Map<id,id> salesProfSnapshotMap = new Map<id,id>();   
           
    public Database.QueryLocator start(Database.BatchableContext con){
        
        /*
        List<String> fldList1 = new List<String>{prefix+'total_quantitative_weighted_score_c__c',prefix+'total_quantitative_weight__c',prefix+'total_qualitative_weighted_score__c',prefix+'total_qualitative_weight__c',prefix+'snapshot_scheduled_date__c',prefix+'sales_rep_profile__c',prefix+'overall_rating__c',prefix+'overall_quantitative_rating__c',prefix+'overall_qualitative_rating__c',prefix+'certification__c',prefix+'Management_Qualitative_Score__c'};

        Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Certification_Snapshot__c').getDescribe().fields.getMap();
        
        for(String fldName: fldList1){
            if(!fieldMap1.get(fldName).getDescribe().isCreateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              createAccess = false;
              break;
            }                
        }*/
        
        List<Sales_Rep_Profile_Snapshot__c> spSnapShots = [SELECT id, Sales_Rep_Profile__c FROM Sales_Rep_Profile_Snapshot__c WHERE Snapshot_Scheduled_Date__c = :triggerDate];
        
        for(Sales_Rep_Profile_Snapshot__c ss: spSnapShots){
            salesProfSnapshotMap.put(ss.Sales_Rep_Profile__c,ss.id);
        }
        
        DateTime tdt = triggerDate;
        String datTim = tdt.format('yyyy-MM-dd');
         
        return Database.getQueryLocator('SELECT Id, name,Prediction_Value__c,Target_value__c, Overall_Qualitative_Rating__c, Overall_Quantitative_Rating__c, Overall_Rating__c, individual_qualitative_rating__c, Management_Qualitative_Score__c, Sales_Rep_Profile__c, Total_Qualitative_Weight__c, Total_Qualitative_Weighted_Score__c, Total_Quantitative_Weight__c, Total_Quantitative_Weighted_Score__c FROM Certification__c WHERE (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_quota_amount__c > 0) AND Sales_rep_profile__r.Rep_Start_Date__c <= '+datTim);
    }
    
    public void execute(Database.BatchableContext con, List<Certification__c> certis){
        try{    
        
        List<Certification_Snapshot__c> snapshotRecsToBeInserted = new List<Certification_Snapshot__c>();   
        
        if(createAccess){
                             
            for(Certification__c cc : certis){
            
                Certification_Snapshot__c cs = new Certification_Snapshot__c();
                cs.name = cc.name;
                cs.Overall_Qualitative_Rating__c    =   cc.Overall_Qualitative_Rating__c;
                cs.Overall_Quantitative_Rating__c   =   cc.Overall_Quantitative_Rating__c;
                cs.Overall_Rating__c    =   cc.Overall_Rating__c;
                cs.individual_qualitative_rating__c = cc.individual_qualitative_rating__c;
                cs.Sales_Rep_Profile__c =   cc.Sales_Rep_Profile__c;
                cs.Management_Qualitative_Score__c = cc.Management_Qualitative_Score__c;
                    
                if(salesProfSnapshotMap != null && salesProfSnapshotMap.containsKey(cc.Sales_Rep_Profile__c)){
                    cs.Sales_Rep_Profile_Snapshot__c = salesProfSnapshotMap.get(cc.Sales_Rep_Profile__c);
                }
                    
                cs.Total_Qualitative_Weight__c  =   cc.Total_Qualitative_Weight__c;
                cs.Total_Qualitative_Weighted_Score__c  =   cc.Total_Qualitative_Weighted_Score__c;
                cs.Total_Quantitative_Weight__c =   cc.Total_Quantitative_Weight__c;
                cs.Total_Quantitative_Weighted_Score_c__c   =   cc.Total_Quantitative_Weighted_Score__c;
                
                cs.Prediction_Value__c =   cc.Prediction_Value__c;
                cs.Target_value__c =   cc.Target_value__c;
    
                cs.Certification__c =   cc.id;
                
                cs.Snapshot_Scheduled_Date__c = triggerDate;      
                
                /*
                if(date.today().day() >=1 && date.today().day() <= 27){
                    Date newDate = date.today() - 27;   
                    Integer dayVal = Date.daysInMonth(newDate.year(), newDate.month());
                    Date snapDate = Date.newInstance(newDate.year(), newDate.month(), dayVal);
                    cs.Snapshot_Scheduled_Date__c = snapDate;
                    
                    DateTime actualDateTime = snapDate;
             
                    actualDateTime = actualDateTime.addHours(actualDateTime.hour());
                    actualDateTime = actualDateTime.addMinutes(actualDateTime.minute());
                    actualDateTime = actualDateTime.addSeconds(actualDateTime.second());
                    cs.CreatedDate = actualDateTime;
                }*/                                                                                                                                                
                
                /*
                //DateTime todaysDateTime = Date.today();
                DateTime todaysDateTime = Date.newInstance(2017,12,31);
                
                todaysDateTime = todaysDateTime.addHours(todaysDateTime.hour());
                todaysDateTime = todaysDateTime.addMinutes(todaysDateTime.minute());
                todaysDateTime = todaysDateTime.addSeconds(todaysDateTime.second());
                cs.CreatedDate = todaysDateTime;
                    
                cs.Snapshot_Scheduled_Date__c = Date.newInstance(2017,12,31);
                */
                
                snapshotRecsToBeInserted.add(cs);  
                                          
            }
        }
        
        //if(Schema.sObjectType.Certification_Snapshot__c.isCreateable())
         //if(Schema.getGlobalDescribe().get(prefix+'Certification_Snapshot__c').getDescribe().isCreateable()){   
            insert snapshotRecsToBeInserted;
            //}
            
            system.debug(' certification snapshot inserted successfully '+snapshotRecsToBeInserted);        
        }
        catch(Exception ex){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelMonthlyCertificationSnapshotBatch '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        }
        
    }
    
    public void finish(Database.BatchableContext con){
        if(!errorVal){      
            if(chainBatch){
        
                FunnelMonthlyCompanyLevelSnapshotBatch compLevelBatch = new FunnelMonthlyCompanyLevelSnapshotBatch(triggerDate,chainBatch,histVal);
                Database.executeBatch(compLevelBatch); 
            }
        }
    }
}