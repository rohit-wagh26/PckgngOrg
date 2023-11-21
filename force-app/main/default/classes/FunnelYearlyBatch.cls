public with Sharing  class FunnelYearlyBatch implements Database.Batchable<sobject>, Database.Stateful{
    
    public Date fiscalYr;
    
    public Date nextYr;
    
    public Boolean createAccess = true;
    
    Boolean chainBatch;
    public Boolean updateAccess = true;
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    Date triggerDate;
    Boolean histVal;
    
    Boolean errorVal = false;
   
    public FunnelYearlyBatch(Date scheduleDate, Boolean chain,Boolean historical){
        triggerDate = scheduleDate;
        chainBatch = chain;
        histVal = historical;
    }
       
     public Database.QueryLocator start(Database.BatchableContext con){
        /*
        List<String> fldList1 = new List<String> {prefix+'of_annual_qualified_opptys__c',   prefix+'of_daily_leads_to_achieve_quota__c',    prefix+'of_leads_for_1_qualified_oppty__c', prefix+'of_leads_for_1_win__c', prefix+'of_monthly_leads_to_achieve_quota__c',  prefix+'of_monthly_qualified_opptys__c',    prefix+'of_quarterly_leads_to_achieve_quota__c',    prefix+'of_quarterly_qualified_opptys__c',  prefix+'of_wins_to_achieve_annual_quota__c',    prefix+'of_wins_to_achieve_monthly_quota__c',   prefix+'of_wins_to_achieve_quarterly_quota__c', prefix+'X12_Month_Average_Selling_Price__c',    prefix+'X12_Month_Lead_Conv_for_1_oppty__c',    prefix+'X12_Month_Leads_Added__c',  prefix+'X12_Month_Opprties_Added_to_the_funnel__c', prefix+'X12_Month_Rolling_Average_Sales_Cycle__c',  prefix+'X12_Month_Rolling_Opportunity_Close_Rate__c',   prefix+'X12_Month_Rolling_Win_Percentage__c',   prefix+'Goal_of_monthly_meetings__c',   prefix+'Goal_of_monthly_opptys_added_to_funnel__c', prefix+'Goal_of_wins_to_achieve_monthly_quota__c',  prefix+'Month_10_Quota_Amount__c',  prefix+'Month_11_Quota_Amount__c',  prefix+'Month_12_Quota_Amount__c',  prefix+'Month_1_Quota_Amount__c',   prefix+'Month_2_Quota_Amount__c',   prefix+'Month_3_Quota_Amount__c',   prefix+'Month_4_Quota_Amount__c',   prefix+'Month_5_Quota_Amount__c',   prefix+'Month_6_Quota_Amount__c',   prefix+'Month_7_Quota_Amount__c',   prefix+'Month_8_Quota_Amount__c',   prefix+'Month_9_Quota_Amount__c',   prefix+'Monthly_Lead_Added__c', prefix+'Monthly_Opportunities_added_to_Qualifie__c',    prefix+'Monthly_Quota_Revenue__c',  prefix+'Quarterly_Lead_Added__c',   prefix+'Quarterly_Opportunities_added_to_Qualifi__c',   prefix+'Quarterly_Quota_Revenue__c',    prefix+'Sales_Manager__c',  prefix+'Sales_Rep_Profile__c',  prefix+'Start_date__c', prefix+'User_Record__c',    prefix+'YTD_Average_Sales_Cycle__c',    prefix+'YTD_Leads_Added__c',    prefix+'YTD_Opportunities_Added__c',    prefix+'YTD_Opportunities_Won__c',  prefix+'YTD_Revenue__c',    prefix+'YTD_Revenue_Close_Rate__c', prefix+'YTD_Revenue_Quota_Percent__c',  prefix+'YTD_Win_Percentage__c'};
                                        
        Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'YTD_Quota_Revenue__c').getDescribe().fields.getMap();
        
        for(String fldName: fldList1){
            if(!fieldMap1.get(fldName).getDescribe().isCreateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              createAccess = false;
              break;
            }                
        }
        
        List<String> fldList2 = new List<String> {prefix+'Month_1_Quota_Amount__c',prefix+'Month_2_Quota_Amount__c',prefix+'Month_3_Quota_Amount__c',prefix+'Month_4_Quota_Amount__c',prefix+'Month_5_Quota_Amount__c',prefix+'Month_6_Quota_Amount__c',prefix+'Month_7_Quota_Amount__c',prefix+'Month_8_Quota_Amount__c',prefix+'Month_9_Quota_Amount__c',prefix+'Month_10_Quota_Amount__c',prefix+'Month_11_Quota_Amount__c',prefix+'Month_12_Quota_Amount__c',prefix+'YTD_Opportunities_won__c',prefix+'YTD_Leads_Added__c',prefix+'YTD_Opportunities_Added__c',prefix+'YTD_Revenue__c',prefix+'YTD_Average_Sales_Cycle__c'};
                                        
        Map <String, Schema.SObjectField> fieldMap2 = Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile__c').getDescribe().fields.getMap();
        
        for(String fldName: fldList2){
            if(!fieldMap2.get(fldName).getDescribe().isUpdateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              updateAccess = false;
              break;
            }                
        }*/ 
        
        DateTime tdt = triggerDate;
        String datTim = tdt.format('yyyy-MM-dd');
        
        return Database.getQueryLocator('SELECT Id, User_Record_Name__c,Goal_of_monthly_leads_to_achieve_quota__c, YTD_Opportunities_won__c, X12_Month_Average_Selling_Price__c, X12_Month_Leads_Added__c, Monthly_Lead_Added__c, X12_Month_Rolling_Opportunity_Close_Rate__c, YTD_Leads_Added__c, YTD_Opportunities_Added__c, YTD_Revenue__c, YTD_Revenue_Quota_Percent__c, X12_Month_Rolling_Win_Percentage__c, YTD_Win_Percentage__c, YTD_Average_Sales_Cycle__c, YTD_Revenue_Close_Rate__c, Month_1_Quota_Amount__c, Month_2_Quota_Amount__c, Month_3_Quota_Amount__c, Month_4_Quota_Amount__c, Month_5_Quota_Amount__c, Month_6_Quota_Amount__c, Month_7_Quota_Amount__c, Month_9_Quota_Amount__c, Month_8_Quota_Amount__c, Month_10_Quota_Amount__c, Month_11_Quota_Amount__c, Month_12_Quota_Amount__c, Annual_Quota_Amount__c, Q1_Quota_Amount__c, Q2_Quota_Amount__c, Q3_Quota_Amount__c, Q4_Quota_Amount__c, Sales_Manager__c, of_annual_qualified_opptys__c,of_daily_leads_to_achieve_quota__c,of_leads_for_1_qualified_oppty__c,of_leads_for_1_win__c,of_monthly_leads_to_achieve_quota__c,of_monthly_qualified_opptys__c,of_quarterly_leads_to_achieve_quota__c,of_quarterly_qualified_opptys__c,of_wins_to_achieve_annual_quota__c,of_wins_to_achieve_monthly_quota__c,of_wins_to_achieve_quarterly_quota__c,X12_Month_Lead_Conv_for_1_oppty__c,X12_Month_Opprties_Added_to_the_funnel__c, Monthly_Opportunities_added_to_Qualifie__c, Monthly_Quota_Revenue__c, Quarterly_Lead_Added__c, Quarterly_Opportunities_added_to_Qualifi__c, Quarterly_Quota_Revenue__c, X12_Month_Rolling_Average_Sales_Cycle__c,Goal_of_monthly_meetings__c,Goal_of_monthly_opptys_added_to_funnel__c,Goal_of_wins_to_achieve_monthly_quota__c, Active__c FROM Sales_Rep_Profile__c WHERE (Active__c = TRUE OR Annual_Quota_Amount__c > 0) AND Rep_Start_Date__c <= '+datTim);
    }

    public void execute(Database.BatchableContext con, List<Sales_Rep_Profile__c> srp){
        try{        
        //Fetch the previous fiscal year start date to fetch the data stored for last year
        fiscalYr = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');        
        nextYr = Date.newInstance((fiscalYr.year() + 1), fiscalYr.month(), fiscalYr.day());                
        
        List<YTD_Quota_Revenue__c> quotaRecsToBeInserted = new List<YTD_Quota_Revenue__c>();   
        
        if(createAccess){                     
            for(Sales_Rep_Profile__c s : srp){
        
                YTD_Quota_Revenue__c yq = new YTD_Quota_Revenue__c();                        
                                    
                yq.Month_1_Quota_Amount__c = s.Month_1_Quota_Amount__c;
                yq.Month_2_Quota_Amount__c = s.Month_2_Quota_Amount__c;
                yq.Month_3_Quota_Amount__c = s.Month_3_Quota_Amount__c;
                yq.Month_4_Quota_Amount__c = s.Month_4_Quota_Amount__c;
                yq.Month_5_Quota_Amount__c = s.Month_5_Quota_Amount__c;
                yq.Month_6_Quota_Amount__c = s.Month_6_Quota_Amount__c;
                yq.Month_7_Quota_Amount__c = s.Month_7_Quota_Amount__c;
                yq.Month_8_Quota_Amount__c = s.Month_8_Quota_Amount__c;
                yq.Month_9_Quota_Amount__c = s.Month_9_Quota_Amount__c;
                yq.Month_10_Quota_Amount__c = s.Month_10_Quota_Amount__c;
                yq.Month_11_Quota_Amount__c = s.Month_11_Quota_Amount__c;
                yq.Month_12_Quota_Amount__c = s.Month_12_Quota_Amount__c;                            
                yq.of_annual_qualified_opptys__c = s.of_annual_qualified_opptys__c;
                yq.of_daily_leads_to_achieve_quota__c = s.of_daily_leads_to_achieve_quota__c;
                yq.of_leads_for_1_qualified_oppty__c = s.of_leads_for_1_qualified_oppty__c;
                yq.of_leads_for_1_win__c = s.of_leads_for_1_win__c;
                yq.of_monthly_leads_to_achieve_quota__c = s.of_monthly_leads_to_achieve_quota__c;
                yq.of_monthly_qualified_opptys__c = s.of_monthly_qualified_opptys__c;
                yq.of_quarterly_leads_to_achieve_quota__c = s.of_quarterly_leads_to_achieve_quota__c;
                yq.of_quarterly_qualified_opptys__c = s.of_quarterly_qualified_opptys__c;
                yq.of_wins_to_achieve_annual_quota__c = s.of_wins_to_achieve_annual_quota__c;
                yq.of_wins_to_achieve_monthly_quota__c = s.of_wins_to_achieve_monthly_quota__c;
                yq.of_wins_to_achieve_quarterly_quota__c = s.of_wins_to_achieve_quarterly_quota__c;
                yq.X12_Month_Lead_Conv_for_1_oppty__c = s.X12_Month_Lead_Conv_for_1_oppty__c;
                yq.X12_Month_Opprties_Added_to_the_funnel__c = s.X12_Month_Opprties_Added_to_the_funnel__c;
                yq.X12_Month_Rolling_Average_Sales_Cycle__c = s.X12_Month_Rolling_Average_Sales_Cycle__c;
                yq.X12_Month_Rolling_Win_Percentage__c = s.X12_Month_Rolling_Win_Percentage__c;                            
                yq.Sales_Rep_Profile__c = s.id;
                yq.Start_date__c = fiscalYr;
                yq.YTD_Opportunities_Won__c = s.YTD_Opportunities_won__c;
                yq.YTD_Revenue__c = s.YTD_Revenue__c;
                yq.YTD_Average_Sales_Cycle__c = s.YTD_Average_Sales_Cycle__c;
                yq.YTD_Revenue_Close_Rate__c = s.YTD_Revenue_Close_Rate__c;
                yq.YTD_Revenue_Quota_Percent__c = s.YTD_Revenue_Quota_Percent__c;
                yq.YTD_Win_Percentage__c = s.YTD_Win_Percentage__c;
                yq.User_Record__c = s.User_Record_Name__c;
                yq.Sales_Manager__c = s.Sales_Manager__c;
                yq.Goal_of_monthly_meetings__c = s.Goal_of_monthly_meetings__c;
                yq.Goal_of_monthly_opptys_added_to_funnel__c = s.Goal_of_monthly_opptys_added_to_funnel__c;
                yq.Goal_of_wins_to_achieve_monthly_quota__c = s.Goal_of_wins_to_achieve_monthly_quota__c;
                yq.X12_Month_Average_Selling_Price__c  =    s.X12_Month_Average_Selling_Price__c;
                yq.X12_Month_Leads_Added__c  =  s.X12_Month_Leads_Added__c;
                yq.X12_Month_Rolling_Opportunity_Close_Rate__c  =   s.X12_Month_Rolling_Opportunity_Close_Rate__c;
                yq.Monthly_Lead_Added__c  = s.Monthly_Lead_Added__c;
                yq.Monthly_Opportunities_added_to_Qualifie__c  =    s.Monthly_Opportunities_added_to_Qualifie__c;
                yq.Monthly_Quota_Revenue__c  =  s.Monthly_Quota_Revenue__c;
                yq.Quarterly_Lead_Added__c  =   s.Quarterly_Lead_Added__c;
                yq.Quarterly_Opportunities_added_to_Qualifi__c  =   s.Quarterly_Opportunities_added_to_Qualifi__c;
                yq.Quarterly_Quota_Revenue__c  =    s.Quarterly_Quota_Revenue__c;
                yq.YTD_Leads_Added__c  =    s.YTD_Leads_Added__c;
                yq.YTD_Opportunities_Added__c  =    s.YTD_Opportunities_Added__c;
                
                yq.Goal_of_monthly_leads_to_achieve_quota__c=    s.Goal_of_monthly_leads_to_achieve_quota__c;
                quotaRecsToBeInserted.add(yq); 
            
                if(updateAccess){                     
                    
                    // We still need to decide if these should be nullified - During v1.2     
                    
                    //Updated on 11/28, if the sales profile is inactive, update the quotas - to be tested
                    if(!s.Active__c){                
                        s.Month_1_Quota_Amount__c = 0;
                        s.Month_2_Quota_Amount__c = 0;
                        s.Month_3_Quota_Amount__c = 0;
                        s.Month_4_Quota_Amount__c = 0;
                        s.Month_5_Quota_Amount__c = 0;
                        s.Month_6_Quota_Amount__c = 0;
                        s.Month_7_Quota_Amount__c = 0;
                        s.Month_8_Quota_Amount__c = 0;
                        s.Month_9_Quota_Amount__c = 0;
                        s.Month_10_Quota_Amount__c = 0;
                        s.Month_11_Quota_Amount__c = 0;
                        s.Month_12_Quota_Amount__c = 0;
                    }
                    
                    s.YTD_Opportunities_won__c = 0;
                    s.YTD_Leads_Added__c = 0;
                    s.YTD_Opportunities_Added__c = 0;
                    s.YTD_Revenue__c = 0;
                    s.YTD_Average_Sales_Cycle__c = 0;
                    s.Quarterly_Opportunities_added_to_Qualifi__c = 0;
                    s.Monthly_Opportunities_added_to_Qualifie__c = 0;
                    s.Monthly_Quota_Revenue__c = 0;
                    s.Quarterly_Quota_Revenue__c = 0;
                    s.Monthly_Lead_Added__c = 0;
                    s.Quarterly_Lead_Added__c = 0;
                    s.YTD_Leads_Added__c = 0;
                    
                    
                    s.Ytd_lost_QO__c = 0;
                    s.Ytd_lost_QO_Amt__c = 0;  
                    s.Close_rate_YTD_opp_amount__c = 0;
                    s.Close_rate_YTD_opp_count__c = 0; 
                    s.Ytd_QO_added__c = 0; 
                    
                }   
            }
            
            //if(Schema.sObjectType.YTD_Quota_Revenue__c.isCreateable())
            // if(Schema.getGlobalDescribe().get(prefix+'YTD_Quota_Revenue__c').getDescribe().isCreateable()){   
                 insert quotaRecsToBeInserted;
            // }
        
            system.debug(' inserted successfully '+quotaRecsToBeInserted);
            // if(Schema.sObjectType.Sales_Rep_Profile__c.isUpdateable())
            //if(Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile__c').getDescribe().isUpdateable()){   
                    update srp;
            //     }
            system.debug(' updated sales profiles '+srp);                  
          }
        }
        catch(Exception ex){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelYearlyBatch '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
    }
    
    public void finish(Database.BatchableContext con){
        if(!errorVal){
        
            List<String> fldList1 = new List<String>{prefix+'Start_Date__c'};
                
            Boolean updateAccess = true;
            /*           
            Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Fiscal_Year_Setting__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList1){
                if(!fieldMap1.get(fldName).getDescribe().isUpdateable()){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                  updateAccess = false;
                }                            
            } 
            */
            Fiscal_Year_Setting__c fy = FunnelTriggerBatchHelper.getFiscalYearRecord('Current_Year');
    
            if(updateAccess){
                fy.Start_Date__c = nextYr;
            }
            
            //if(Schema.getGlobalDescribe().get(prefix+'Fiscal_Year_Setting__c').getDescribe().isUpdateable()){   
                update fy;
            //} 
          // FunnelTriggerBatchHelper.sendErrorMail(' All batches completed '+triggerDate ); 
           
           /*Automation*/
           
           Date tDNM = triggerDate.addMonths(1);
           Date triggerDateNextmonth =  Date.newinstance(tDNM.year(),tDNM.month(),date.daysInMonth(tDNM.year(),tDNM.month()));
           
           //Date imptestDate =  Date.newinstance(2018,12,6);
           if((triggerDateNextmonth  < Date.today() )&& histVal ){
           
           //if((triggerDateNextmonth  < imptestDate )&& histVal ){
               FunnelQuotaUpdateBatch fq = new FunnelQuotaUpdateBatch(triggerDateNextmonth,true,true);
               Database.executeBatch(fq);   
           }else if(histVal){
               FunnelTriggerBatchHelper.schActivateTrigger();
               
               Date d = Date.newInstance(Date.today().year(),Date.today().month(), date.daysInMonth(Date.today().year(), Date.today().month()));  
            
                Funnel12MonthBatch fbc = new Funnel12MonthBatch(d,false,true);
                Database.executebatch(fbc); 
                
                Funnel12MonthBatchPart2 fbc2 = new Funnel12MonthBatchPart2 (d,false,true);
                Database.executebatch(fbc2); 
                
                FunnelTriggerBatchHelper.installationMail('Funnelocity installation completed','Funnelocity installation has been completed. ');
               
          }
          
          if(!histVal){
              FunnelTriggerBatchHelper.installationMail('Review Goals',' ');
          }      
        }
    }
}