/*
Copyright: Funnel Metrics, LLC
*/
global with Sharing class FunnelUpdateCounters implements Database.Batchable<sobject>, Database.Stateful{
    
     Date triggerDate;
     Boolean chainBatch;
     Boolean histVal;
     
    public FunnelUpdateCounters(Date scheduleDate,Boolean chain, Boolean historical){
        triggerDate = scheduleDate;
        chainBatch = chain;
        histVal = historical;
    }   

    public Database.QueryLocator start(Database.BatchableContext con){
        
        String query = 'SELECT id,Current_Fiscal_Months__c  From  Sales_Rep_Profile__c WHERE (Active__c = TRUE OR Annual_Quota_Amount__c > 0)';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext con, List<Sales_Rep_Profile__c> srp){
        
        try{
            Boolean quarter = false;
            DateTime Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
            Date FyearDate = Date.newInstance(Fyear.yearGmt(),Fyear.monthGmt(),1);
            Integer noOfDays = Date.daysInMonth(FyearDate.year(),FyearDate.month());
    
            Date firstMonthEndDate = Date.newInstance(FyearDate.year(),FyearDate.month(),noOfDays);
            
            Date firstQuarterStart = FyearDate.addMonths(2);
            noOfDays = Date.daysInMonth(firstQuarterStart.year(),firstQuarterStart.month());
            Date firstQuarterEnd = Date.newInstance(firstQuarterStart.year(),firstQuarterStart.month(),noOfDays);
            
            Date secondQuarterStart = firstQuarterStart.addMonths(3);
            noOfDays = Date.daysInMonth(secondQuarterStart.year(),secondQuarterStart.month());
            Date secondQuarterEnd = Date.newInstance(secondQuarterStart.year(),secondQuarterStart.month(),noOfDays);
            
            Date thirdQuarterStart = secondQuarterStart.addMonths(3);
            noOfDays = Date.daysInMonth(thirdQuarterStart.year(),thirdQuarterStart.month());
            Date thirdQuarterEnd = Date.newInstance(thirdQuarterStart.year(),thirdQuarterStart.month(),noOfDays);
            
            Date fourthQuarterStart = thirdQuarterStart.addMonths(3);
            noOfDays = Date.daysInMonth(fourthQuarterStart.year(),fourthQuarterStart.month());
            Date fourthQuarterEnd = Date.newInstance(fourthQuarterStart.year(),fourthQuarterStart.month(),noOfDays);                                
            
            
            
            if(firstQuarterEnd == triggerDate || secondQuarterEnd == triggerDate || thirdQuarterEnd == triggerDate || fourthQuarterEnd == triggerDate){
               quarter = true; 
            }
            
            for(Sales_Rep_Profile__c s: srp){
                s.Close_rate_monthly_opp_amount__c = 0;
                s.Close_rate_monthly_opp_count__c = 0;
                s.Monthly_lost_QO_Amt__c = 0;
                s.Monthly_lost_QO__c =0;
                s.Monthly_QO_added__c = 0;
                
             if(quarter){
                  s.Close_rate_Quarterly_opp_count__c =  0;
                  s.Close_rate_Quarterly_opp_amount__c= 0;
                  s.Quarterly_lost_QO_Amt__c = 0;
                  s.Quarterly_lost_QO__c=0;
                  s.Quarterly_QO_added__c = 0;
              }
              //FunnelTriggerBatchHelper.updateYTDQuota(s);

            }
         update srp;    
        }catch(Exception ex){
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelUpdateCounters '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        }
    }
    
     public void finish(Database.BatchableContext con){
         
            if(chainBatch){
                FunnelMonthlyCertificationSnapshotBatch certiBatch = new FunnelMonthlyCertificationSnapshotBatch(triggerDate,chainBatch,histVal);
                Database.executeBatch(certiBatch);    
            }
        
    }
}