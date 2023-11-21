public with sharing class FunnelCustomMetricBatchPart2 implements Database.Batchable<sobject>,Database.Stateful{
 
    public List<Sales_Rep_Profile__c> srps{get;set;} 
    public List<Certification_Rating__c> certification_rating{get;set;}     //Fetch the custom ratings From certification rating
    public Map<string,List<string>> objectnfield{get;set;}               //Store the map of object and field to qurey the object
    public List<AggregateResult> cm{get;set;}                                    //Store the value of qurey
    public Map<id,AggregateResult> storeMetricVal{get;set;}                       //Store the map of relatedby id and the object
    public Map<string,string> storerelnobj{get;set;}                      //Storce the map of relateby it and object name
    
    public string timeperiod;
    Date  triggerDateVal;
    Boolean chainBatch;
    Boolean histVal;
    Boolean errorVal = false;
    
     public FunnelCustomMetricBatchPart2 (Date triggerDate, Boolean chain, Boolean historical){    
                       
         triggerDateVal = triggerDate;  
         chainBatch = chain;
         histVal = historical; 
         system.debug(' constructor triggerDate '+triggerDateVal);  
     }
     
     public Database.QueryLocator start(Database.BatchableContext con){
         system.debug(' start triggerDate '+triggerDateVal);
         //return Database.getQueryLocator('Select id,User_Record_Name__c,FMCustom_Metric_1__c,FMCustom_Metric_2__c ,FMCustom_Metric_3__c ,FMCustom_Metric_4__c ,FMCustom_Metric_5__c ,FMCustom_Metric_6__c ,FMCustom_Metric_7__c ,FMCustom_Metric_8__c ,FMCustom_Metric_9__c ,FMCustom_Metric_10__c,FMCustom_Metric_11__c,FMCustom_Metric_12__c,FMCustom_Metric_13__c,FMCustom_Metric_14__c,FMCustom_Metric_15__c,FMCustom_Metric_16__c,FMCustom_Metric_17__c,FMCustom_Metric_18__c,FMCustom_Metric_19__c,FMCustom_Metric_20__c,FMCustom_Metric_21__c,FMCustom_Metric_22__c,FMCustom_Metric_23__c,FMCustom_Metric_24__c,FMCustom_Metric_25__c,FMCustom_Metric_26__c,FMCustom_Metric_27__c,FMCustom_Metric_28__c From Sales_Rep_Profile__c WHERE Active__c = TRUE');
         return Database.getQueryLocator('SELECT Id, Name, SRP_Field_Name__c, Field_Name__c, Custom_Object_Name__c, Custom_Field_Name__c, Custom_Related_by__c,Agg__c,Where__c,Date__c,Duration_Field__c,Duration_Period__c FROM Certification_Rating__c where Custom_Object_Name__c != null And Custom_Field_Name__c != null AND Custom_Related_by__c != null AND Custom_Field_Name__c!= null AND Deactivated__c = false AND Custom_Object_Name__c = \'FunnelMetrics__Sales_Rep_Profile__c\'');
     }
     
     
     public void execute(Database.BatchableContext con, List<Certification_Rating__c> cr){
         try{   
             storeMetricVal = new Map<id,AggregateResult>();
             objectnfield = new Map<string,List<string>>();
             storerelnobj = new  Map<string,string>();
            
             srps = [Select id,User_Record_Name__c,FMCustom_Metric_1__c,FMCustom_Metric_2__c ,FMCustom_Metric_3__c ,FMCustom_Metric_4__c ,FMCustom_Metric_5__c ,FMCustom_Metric_6__c ,FMCustom_Metric_7__c ,FMCustom_Metric_8__c ,FMCustom_Metric_9__c ,FMCustom_Metric_10__c,FMCustom_Metric_11__c,FMCustom_Metric_12__c,FMCustom_Metric_13__c,FMCustom_Metric_14__c,FMCustom_Metric_15__c,FMCustom_Metric_16__c,FMCustom_Metric_17__c,FMCustom_Metric_18__c,FMCustom_Metric_19__c,FMCustom_Metric_20__c,FMCustom_Metric_21__c,FMCustom_Metric_22__c,FMCustom_Metric_23__c,FMCustom_Metric_24__c,FMCustom_Metric_25__c,FMCustom_Metric_26__c,FMCustom_Metric_27__c,FMCustom_Metric_28__c,FMCustom_Metric_29__c,FMCustom_Metric_30__c,FMCustom_Metric_31__c,FMCustom_Metric_32__c,FMCustom_Metric_33__c,FMCustom_Metric_34__c,FMCustom_Metric_35__c,FMCustom_Metric_36__c,FMCustom_Metric_37__c,FMCustom_Metric_38__c,FMCustom_Metric_39__c,FMCustom_Metric_40__c,FMCustom_Metric_41__c,FMCustom_Metric_42__c,FMCustom_Metric_43__c,FMCustom_Metric_44__c,FMCustom_Metric_45__c,FMCustom_Metric_46__c,FMCustom_Metric_47__c,FMCustom_Metric_48__c,FMCustom_Metric_49__c,FMCustom_Metric_50__c From Sales_Rep_Profile__c WHERE Active__c = TRUE ];
             //Fetch the sales rep profile for update
             //List<Sales_Rep_Profile__c> srprecord =[Select id,User_Record_Name__c,FMCustom_Metric_1__c,FMCustom_Metric_2__c ,FMCustom_Metric_3__c ,FMCustom_Metric_4__c ,FMCustom_Metric_5__c ,FMCustom_Metric_6__c ,FMCustom_Metric_7__c ,FMCustom_Metric_8__c ,FMCustom_Metric_9__c ,FMCustom_Metric_10__c From Sales_Rep_Profile__c limit 100];
             
             //Fetch the Custom Rating
             //certification_rating = [SELECT Id, Name, SRP_Field_Name__c, Field_Name__c, Custom_Object_Name__c, Custom_Field_Name__c, Custom_Related_by__c,Agg__c,Where__c,Date__c,Duration_Field__c,Duration_Period__c FROM Certification_Rating__c where Custom_Object_Name__c != null And Custom_Field_Name__c != null AND Custom_Related_by__c != null AND Custom_Field_Name__c!= null AND Deactivated__c = false  ];
            
             for(Certification_Rating__c c : cr ){
                 
                 if(c.Duration_Field__c != null && c.Duration_Period__c != 'No time period'){
                     FunnelCustomMetricHelper.triggerDate = triggerDateVal;
                     timeperiod = FunnelCustomMetricHelper.createtimeString(c.Duration_Field__c,c.Duration_Period__c,c.Date__c);
                 }else{
                     timeperiod = '';
                 }
                 
                 string f;
                 if(c.Agg__c != null){
                     f = c.Custom_Related_by__c +' gb ,'+ c.Agg__c+'('+c.Custom_Field_Name__c+') '+ c.SRP_Field_Name__c;
                 }else{
                     f = c.Custom_Related_by__c +' gb ,'+ 'SUM'+'('+c.Custom_Field_Name__c+') '+ c.SRP_Field_Name__c;
                 }
                 
                 FunnelCustomMetricHelper.triggerDate = triggerDateVal;                          
                 cm  = new List<AggregateResult>();             
                 cm = FunnelCustomMetricHelper.queryObjects(c.Custom_Object_Name__c,f,c.Where__c,c.Custom_Related_by__c,timeperiod);
                 storeMetricVal = new Map<id,AggregateResult>();
                
                 for(AggregateResult s :cm  ){
                      storeMetricVal.put((Id)s.get('gb'),s);
                 }
                  
                 for(Sales_Rep_Profile__c srp: srps){
                    
                    if(storeMetricVal.containsKey(srp.User_Record_Name__c)){
                        srp.put(c.SRP_Field_Name__c,(Decimal)storeMetricVal.get(srp.User_Record_Name__c).get(c.SRP_Field_Name__c));
                        system.debug('srp-----'+srp);
                    }else{
                        srp.put(c.SRP_Field_Name__c,0);
                    }
                    
                 }
             }
                           
             update srps;
               
         }
         catch(Exception ex){
            errorVal = true;
            system.debug(' ex.getStackTraceString '+ex.getStackTraceString());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelCustomMetricBatch '+ex.getMessage()+' '+ex.getStackTraceString()+' '+ex.getLineNumber());
         } 
     }
     
     public void finish(Database.BatchableContext con){
         //FunnelTriggerBatchHelper.sendErrorMail(' FunnelCustomMetricBatch finish method');
         if(!errorVal){ 
             if(!histVal){
                 //FunnelTriggerBatchHelper.sendErrorMail(' FunnelCustomMetricBatch finish method no error ');
             }
            
            system.debug(' triggerDate '+triggerDateVal);
   
            if(histVal){
                FunnelCalculateActiveOpptysBatch fm = new FunnelCalculateActiveOpptysBatch(triggerDateVal,chainBatch,histVal);
                Database.executeBatch(fm);
            }
            ///else if(chainBatch && FunnelTriggerBatchHelper.isLastDay(triggerDateVal)){
            else if(chainBatch){
                FunnelQuantitativeBatchMonthly fb = new FunnelQuantitativeBatchMonthly(triggerDateVal,chainBatch,histVal);
                Database.executeBatch(fb,100);
            }
        }
     }
               
}