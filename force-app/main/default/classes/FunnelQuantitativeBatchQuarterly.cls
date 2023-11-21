/*
Copyright: Funnel Metrics, LLC
*/
global with Sharing class FunnelQuantitativeBatchQuarterly implements Database.Batchable<sobject>, Database.Stateful{
   
   
    Date triggerDate;
    Boolean chainBatch;
    public Boolean createAccess = true;
    public Boolean updateAccess = true;
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    
    Boolean errorVal = false;

    public FunnelQuantitativeBatchQuarterly(Date scheduleDate,Boolean chain){
        triggerDate = scheduleDate;
        chainBatch = chain;
    }
        
    public Database.QueryLocator start(Database.BatchableContext con){
            
        /*List<String> fldList1 = new List<String>{prefix+'Name',prefix+'Certifcation__c',prefix+'Certifcation_Rating__c',prefix+'Rating_Score__c'};

        Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Certification_Answer__c').getDescribe().fields.getMap();
        
        for(String fldName: fldList1){
            if(!fieldMap1.get(fldName).getDescribe().isCreateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              createAccess = false;
              break;
            }                
        } 
        
        List<String> fldList2 = new List<String>{prefix+'Total_Quantitative_Weighted_Score__c',prefix+'Total_Quantitative_Weight__c',prefix+'Overall_Qualitative_Rating__c',prefix+'Overall_Quantitative_Rating__c',prefix+'Overall_Rating__c'};

        Map <String, Schema.SObjectField> fieldMap2 = Schema.getGlobalDescribe().get(prefix+'Certification__c').getDescribe().fields.getMap();
        
        for(String fldName: fldList2){
            if(!fieldMap2.get(fldName).getDescribe().isUpdateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              updateAccess = false;
              break;
            }                
        }*/
          DateTime tdt = triggerDate;
          String datTim = tdt.format('yyyy-MM-dd');
        
         String query = 'SELECT id,Sales_Rep_Profile__r.Profile_Type__c,Total_Qualitative_Weight__c,Total_Qualitative_Weighted_Score__c,Overall_Qualitative_Rating__c,Overall_Quantitative_Rating__c,Overall_Rating__c,Sales_Rep_Profile__c,Sales_Rep_Profile__r.Quarterly_Lead_Added_Percentage__c,Sales_Rep_Profile__r.X12_Month_Rolling_Close_Rate_percentage__c,Sales_Rep_Profile__r.X12_Month_Rolling_Opp_Close_Rate_perc__c,Sales_Rep_Profile__r.YTD_Avg_Length_of_Sales_Cycle_percentage__c,Sales_Rep_Profile__r.YTD_lead_to_opp_conversion_percentage__c,Sales_Rep_Profile__r.Monthly_close_rate_percentage__c,Sales_Rep_Profile__r.Monthly_opp_close_rate_percentage__c,Sales_Rep_Profile__r.Quarterly_Close_Rate_percentage__c,Sales_Rep_Profile__r.YTD_close_rate_percentage__c,Sales_Rep_Profile__r.YTD_opp_close_rate_percentage__c,Sales_Rep_Profile__r.Quarterly_opp_close_rate_percentage__c,Sales_Rep_Profile__r.Number_of_meetings_per_quarte_percentage__c,Sales_Rep_Profile__r.Quarterly_Opportunitie_Closed_percentage__c, Sales_Rep_Profile__r.Quarterly_Average_Win_Size_percentage__c,Sales_Rep_Profile__r.Role__c,Sales_Rep_Profile__r.Annual_Quota_Amount__c,Sales_Rep_Profile__r.Quarterly_Quota_Performance__c,Sales_Rep_Profile__r.Quarterly_Opp_added_to_Qualif_Percentage__c,Sales_Rep_Profile__r.Quarterly_Close_Rate__c,Sales_Rep_Profile__r.Quarterly_Opportunity_Close_Rate__c,Sales_Rep_Profile__r.Quarterly_Average_Win_Size__c,Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Rep_Staus__c,Sales_Rep_Profile__r.FMCustom_Metric_1_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_2_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_3_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_4_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_5_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_6_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_7_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_8_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_9_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_10_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_11_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_12_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_13_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_14_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_15_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_16_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_17_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_18_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_19_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_20_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_21_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_22_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_23_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_24_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_25_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_26_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_27_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_28_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_29_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_30_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_31_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_32_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_33_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_34_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_35_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_36_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_37_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_38_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_39_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_40_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_41_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_42_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_43_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_44_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_45_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_46_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_47_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_48_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_49_percentage__c,Sales_Rep_Profile__r.FMCustom_Metric_50_percentage__c from Certification__c where Sales_Rep_Profile__r.Annual_Quota_Amount__c > 0 AND Sales_Rep_Profile__r.Active__c = TRUE AND Sales_Rep_Profile__r.Rep_Start_Date__c <= '+datTim;
         return Database.getQueryLocator(query);
    }
    
    
    
    List<Certification_Rating__c> certiRating = [SELECT Id,Reverse_Buckets__c , X0LevelHigh__c, X0LevelLow__c,X1LevelHigh__c,X1LevelLow__c,X2LevelHigh__c,X2LevelLow__c,
                                                 X3LevelHigh__c,X3LevelLow__c,X4LevelHigh__c,X4LevelLow__c,Deactivated__c,Roles_enabled__c,Numeric_Weight__c,Field_Name__c,name,User_Type__c FROM Certification_Rating__c where Assessment_type__c='Quantitative'    AND Field_Name__c != null AND Deactivated__c = false And Timing__c='End of quarter'  ];
    
   
    
    /*
    // weekly certificate answers
    list<Certification_Answer__c> certiweeklyLast =[select id ,createddate From Certification_Answer__c Where Certifcation_Rating__r.Timing__c = 'End of Week' AND Certifcation_Rating__r.Deactivated__c = false AND Certifcation_Rating__r.User_Type__c ='Tenured' order by createddate  Desc limit 1];
   // certiweeklyLast = [select id ,createddate From Certification_Answer__c Where Certifcation_Rating__r.Timing__c = 'End of Week' AND Certifcation_Rating__r.Deactivated__c = false AND Certifcation_Rating__r.User_Type__c ='Tenured' order by createddate  Desc limit 1];
    
    list<AggregateResult> certiweeklyList = new list<AggregateResult>();
    Map<id,AggregateResult> certiweeklyListMap = new Map<id,AggregateResult>();
    */
    
     // Monthly certificate answers
  /*M   list<Certification_Answer__c> certimonthlyLast =[select id ,createddate,Due_Date__c From Certification_Answer__c Where Certifcation_Rating__r.Timing__c = 'End of month' AND Certifcation_Rating__r.Deactivated__c = false AND Certifcation_Rating__r.Assessment_type__c = 'Quantitative' AND Due_Date__c != null order by Due_Date__c  Desc limit 1];
   // certiweeklyLast = [select id ,createddate From Certification_Answer__c Where Certifcation_Rating__r.Timing__c = 'End of Week' AND Certifcation_Rating__r.Deactivated__c = false AND Certifcation_Rating__r.User_Type__c ='Tenured' order by createddate  Desc limit 1];
    
    list<AggregateResult> certimonthlyList = new list<AggregateResult>();
    Map<id,AggregateResult> certimonthlyListMap = new Map<id,AggregateResult>(); M*/
    
    public void execute(Database.BatchableContext con, List<Certification__c> c){
        try{
         if(updateAccess && createAccess ){
         
         Boolean isFirstYear = firstYear();
         if(!isFirstYear){
         List<Certification__c> updateScores = new List<Certification__c>(); // update funnelocity and overall score
         List<Certification_Answer__c> createAnsRecords = new List<Certification_Answer__c>();
    
     /*   if(certiweeklyLast != null && certiweeklyLast.size()>0){
        certiweeklyList=[select Certifcation__c certiId ,sum(Weighted_Score__c) ws,sum(Certifcation_Rating__r.Numeric_Weight__c) wr from Certification_Answer__c WHERE Certifcation__c != null AND Certifcation_Rating__r.Timing__c='End of Week' AND Certifcation_Rating__r.Deactivated__c = false AND Certifcation_Rating__r.User_Type__c ='Tenured' And createddate=:certiweeklyLast[0].createddate GROUP BY Certifcation__c];
        }
        for(AggregateResult q : certiweeklyList ){
                
                if(q.get('certiId') != null && q.get('certiId') != ''){
                
                    certiweeklyListMap.put((id)q.get('certiId'),(q));
                }    
            
        }*/
        
         /* M     if(certimonthlyLast != null && certimonthlyLast.size()>0){
                certimonthlyList=[select Certifcation__c certiId ,sum(Weighted_Score__c) ws,sum(Certifcation_Rating__r.Numeric_Weight__c) wr from Certification_Answer__c WHERE Certifcation__c != null AND Certifcation_Rating__r.Timing__c='End of month' AND Certifcation_Rating__r.Deactivated__c = false AND Certifcation_Rating__r.Assessment_type__c = 'Quantitative'  And Due_Date__c =:certimonthlyLast[0].Due_Date__c GROUP BY Certifcation__c];
            }
            for(AggregateResult q : certimonthlyList ){
                    
                    if(q.get('certiId') != null && q.get('certiId') != ''){
                    
                        certimonthlyListMap.put((id)q.get('certiId'),(q));
                    }    
            
            } M */
        
        if(certiRating != null && certiRating.size() > 0 ){
            
              for(Certification__c s: c){
                  
                  Certification__c updateScr = new Certification__c();
                  //    boolean certiAssigned = false;
                 // integer count = 1;
                 //     decimal quanti=0;
                 //     decimal totalweight=0;
                  
                  for(Certification_Rating__c cr : certiRating){
                          Boolean overlayRevMetric = false;
                          if(cr.Field_Name__c == 'Quarterly_Quota_Performance__c'  || cr.Field_Name__c.contains('FMCustom_Metric_') || cr.Field_Name__c.contains('Number_of_meetings_')){
                              overlayRevMetric = true;
                          }
                          
                          if((s.Sales_Rep_Profile__r.Rep_Staus__c == cr.User_Type__c  || cr.User_Type__c =='Both') && s.Sales_Rep_Profile__r.Annual_Quota_Amount__c > 0 && (s.Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' || (s.Sales_Rep_Profile__r.Profile_Type__c == 'Overlay' && overlayRevMetric ))){
                          Certification_Answer__c insertAns = new Certification_Answer__c();
                           //   certiAssigned = true;
                          insertAns.Name = cr.name;
                          insertAns.Certifcation__c = s.id;
                          insertAns.Certifcation_Rating__c = cr.id;
                              insertAns.Sales_Rep_Profile__c=s.Sales_Rep_Profile__c;
                          
                          string fieldName;
                          fieldName = cr.Field_Name__c;
                          
                          //system.debug('name'+'-'+s.Sales_Rep_Profile__r.name);
                          //system.debug(fieldName+'-'+(Decimal)s.Sales_Rep_Profile__r.get(fieldName));
                          //system.debug('0'+cr.X0LevelLow__c +'---'+cr.X0LevelHigh__c);
                          //system.debug('1'+cr.X1LevelLow__c +'---'+cr.X1LevelHigh__c);
                          //system.debug('2'+cr.X2LevelLow__c +'---'+cr.X2LevelHigh__c);
                          //system.debug('3'+cr.X3LevelLow__c +'---'+cr.X3LevelHigh__c);
                          //system.debug('4'+cr.X4LevelLow__c +'---'+cr.X4LevelHigh__c);
                          
                          if(s.Sales_Rep_Profile__r.get(fieldName) != null){
                             
                              Decimal actual ; 
                              actual = ((Decimal)s.Sales_Rep_Profile__r.get(fieldName)).round(System.RoundingMode.HALF_UP);
                               
                              if(  cr.Reverse_Buckets__c ){
                                 
                                  if(actual <= cr.X4LevelHigh__c ){
                                  insertAns.Rating_Score__c = 10;
                                  //system.debug('inside4');
                                  }else if(actual >= cr.X3LevelLow__c && actual <= cr.X3LevelHigh__c){
                                  insertAns.Rating_Score__c = 8;
                                  //system.debug('inside3');
                                  }else if(actual >= cr.X2LevelLow__c && actual <= cr.X2LevelHigh__c){
                                  insertAns.Rating_Score__c = 5;
                                  //system.debug('inside2');
                                  }else if(actual >= cr.X1LevelLow__c && actual <= cr.X1LevelHigh__c){
                                  insertAns.Rating_Score__c = 2;
                                  //system.debug('inside1');
                                  }else if(actual >= cr.X0LevelLow__c ){
                                  insertAns.Rating_Score__c = 0;
                                  //system.debug('inside0');
                                  }else{
                                      insertAns.Rating_Score__c = 0;
                                      //system.debug('insideelse');
                                  }
                                  
                              }else{
                           
                                 if(actual >= cr.X4LevelLow__c ){
                                      insertAns.Rating_Score__c = 10;
                                      //system.debug('inside4');
                                      }else if(actual >= cr.X3LevelLow__c && actual <= cr.X3LevelHigh__c){
                                      insertAns.Rating_Score__c = 8;
                                      //system.debug('inside3');
                                      }else if(actual >= cr.X2LevelLow__c && actual <= cr.X2LevelHigh__c){
                                      insertAns.Rating_Score__c = 5;
                                      //system.debug('inside2');
                                      }else if(actual >= cr.X1LevelLow__c && actual <= cr.X1LevelHigh__c){
                                      insertAns.Rating_Score__c = 2;
                                      //system.debug('inside1');
                                      }else if(actual >= cr.X0LevelLow__c && actual <= cr.X0LevelHigh__c){
                                  insertAns.Rating_Score__c = 0;
                                  //system.debug('inside0');
                                  }else{
                                      insertAns.Rating_Score__c = 0;
                                      //system.debug('insideelse');
                                  }
                              }
                          }else{
                              insertAns.Rating_Score__c = 0;
                              //system.debug('inside2else if value null');
                          }
                          
                          
                              insertAns.Due_Date__c = triggerDate;
                              if(!Test.isRunningTest()){
                              insertAns.Rating_name_picklist__c = cr.name;
                              }
                          createAnsRecords.add(insertAns);
                          // count ++; 
                          
                          //system.debug('insertAns.Rating_Score__c'+insertAns.Rating_Score__c);
                          //system.debug('cr.Numeric_Weight__c'+cr.Numeric_Weight__c);
                          
                          /*     quanti +=  insertAns.Rating_Score__c *  cr.Numeric_Weight__c;
                          totalweight += cr.Numeric_Weight__c;
                              system.debug('quanti '+quanti );
                              system.debug('totalweight '+totalweight );
                            */   
                      }
                      
                     
                     
                  }
                   //  if(certiAssigned){
                     updateScr.id =s.id;
                         updateScr.Total_Quantitative_Weight__c = 1;
                      
                   /*   if(certiweeklyListMap != null &&  certiweeklyListMap.size()> 0 && certiweeklyListMap.keySet().contains(s.id) ){
                          quanti += (Decimal)certiweeklyListMap.get(s.id).get('ws');
                          totalweight += (Decimal)certiweeklyListMap.get(s.id).get('wr');
                      } */
                      
                   /*M       if(certimonthlyListMap != null &&  certimonthlyListMap.size()> 0 && certimonthlyListMap.keySet().contains(s.id) ){
                          quanti += (Decimal)certimonthlyListMap.get(s.id).get('ws');
                          totalweight += (Decimal)certimonthlyListMap.get(s.id).get('wr');
                      }
                      
                      if(totalweight != 0){
                          updateScr.Overall_Quantitative_Rating__c = quanti/totalweight ;
                          updateScr.Total_Quantitative_Weighted_Score__c = quanti;
                          updateScr.Total_Quantitative_Weight__c  = totalweight ;
                          //system.debug('quanti '+quanti );
                          //system.debug('totalweight '+totalweight );
                          //system.debug('updateScr.Overall_Quantitative_Rating__c'+updateScr.Overall_Quantitative_Rating__c);
                      }else{
                          updateScr.Overall_Quantitative_Rating__c = 0 ;
                      }
                      
                          updateScr.Overall_Rating__c = updateScr.Overall_Quantitative_Rating__c;  M*/
                     
                        /* if(s.Overall_Qualitative_Rating__c != null){
                          updateScr.Overall_Qualitative_Rating__c = s.Overall_Qualitative_Rating__c;
                      }else{
                          updateScr.Overall_Qualitative_Rating__c = 0;
                      }
                      
                        if(s.Total_Qualitative_Weighted_Score__c  != null){
                          quanti += s.Total_Qualitative_Weighted_Score__c ;
                      }
                      if(s.Total_Qualitative_Weight__c != null){
                          totalweight += s.Total_Qualitative_Weight__c ;
                      }
                          updateScr.Overall_Rating__c = quanti/totalweight ; */
                      
                     // updateScr.Overall_Rating__c =(updateScr.Overall_Quantitative_Rating__c+updateScr.Overall_Qualitative_Rating__c )/2 ;
                      updateScores.add(updateScr);
                   //   }
              }
              
        }
        
        //system.debug('createAnsRecords'+createAnsRecords);
        //system.debug('updateScores'+updateScores);
          //if(Schema.getGlobalDescribe().get(prefix+'Certification_Answer__c').getDescribe().isCreateable()){   
          insert createAnsRecords;
          update updateScores;
          }
         }
        }
        catch(Exception e){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelQuantitativeBatchQuarterly '+e.getMessage()+' '+e.getStackTraceString()+ ' line number: '+e.getLineNumber()+' cause '+e.getCause());  
      }
                         
    }        
    
    public void finish(Database.BatchableContext con){
        
      /* M  List<AggregateResult> scoreAggr = [SELECT Company_Level__r.Level_Value__c v,AVG(Certification__r.Overall_Quantitative_Rating__c) quan FROM Sales_Profile_Company_Level_Junction__c where Certification__r.Total_Quantitative_Weight__c > 0  GROUP BY Company_Level__r.Level_Value__c];
        
        Map<String,Decimal> mapValQual = new Map<String,Decimal>();
        
        for(AggregateResult ar: scoreAggr){
            mapValQual.put((String)ar.get('v'),(Decimal)ar.get('quan'));
        }
        
        List<Company_Level__c> cls = [SELECT Certification__c, Level_Value__c FROM Company_Level__c ];        
        
        List<Certification__c> crmnglist = new List<Certification__c>();
       
        for(Company_Level__c cl: cls){ 
            Certification__c updateMng = new Certification__c(); 
             updateMng.id = cl.Certification__c;
             updateMng.Overall_Rating__c  = mapValQual.get(cl.Level_Value__c);
        
             crmnglist.add(updateMng);      
        }
      
        update crmnglist; M */
      /*  if(!errorVal){
      
           
                 
           DateTime Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
           DateTime eleventhMonth = Fyear.addMonths(11);
           Date eleventhMonthDate = Date.newInstance(eleventhMonth.yearGmt(),eleventhMonth.monthGmt(),eleventhMonth.dayGmt());
           
           Integer noOfDays = Date.daysInMonth(eleventhMonth.yearGmt(),eleventhMonth.monthGmt());
           
           Date yearEndDate = Date.newInstance(eleventhMonth.yearGmt(),eleventhMonth.monthGmt(),noOfDays);
           
           
           system.debug(' yearEndDate  '+yearEndDate);
           system.debug(' triggerDate '+triggerDate);
           
           if(yearEndDate == triggerDate){
               FunnelYearlyBatch fm = new FunnelYearlyBatch(triggerDate,chainBatch);
               Database.executeBatch(fm);
           }
       }*/
    }            
     public Boolean firstYear(){
    
       List<Yearly_goals_by_Role__c> ygr= [Select id from Yearly_goals_by_Role__c LIMIT 1];
       
       if(ygr != null && ygr.size()>0){
           return false;
       }else{
           return true;
       }
    }      
}