public with Sharing  class FunnelQuotaUpdateBatch implements Database.Batchable<sobject>, Database.Stateful{
    
    public Date fiscalYr;
    
    public Date nextYr;
    
    public Boolean createAccess = true;
    
    Boolean chainBatch;
    public Boolean updateAccess = true;
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    Date histDateVal;
    Boolean hisVal;
    
    Boolean errorVal = false;
   
    public FunnelQuotaUpdateBatch(Date scheduleDate, Boolean chain, Boolean historical){
        histDateVal = scheduleDate;
        chainBatch = chain;
        hisVal = historical;
    }
       
     public Database.QueryLocator start(Database.BatchableContext con){
        
        
        return Database.getQueryLocator('SELECT Id, User_Record_Name__c   FROM Sales_Rep_Profile__c ');
    }

    public void execute(Database.BatchableContext con, List<Sales_Rep_Profile__c> srp){
        try{        
         
            Map<id,Sales_Rep_Quota__c> quotaMap = fetchQuotaMap();
                             
          
            for(Sales_Rep_Profile__c s : srp){
                if(quotaMap != null && quotaMap.size() > 0 && quotaMap.keySet().contains(s.id)){
                    
                    Sales_Rep_Quota__c sq = quotaMap.get(s.id);
                    system.debug('sa annual amt :: '+sq.Annual_Quota_Amount__c);
                    s.Month_1_Quota_Amount__c = sq.Annual_Quota_Amount__c/12 ;
                    s.Month_2_Quota_Amount__c = sq.Annual_Quota_Amount__c/12 ;
                    s.Month_3_Quota_Amount__c = sq.Annual_Quota_Amount__c/12 ;
                    s.Month_4_Quota_Amount__c = sq.Annual_Quota_Amount__c/12 ;
                    s.Month_5_Quota_Amount__c = sq.Annual_Quota_Amount__c/12 ;
                    s.Month_6_Quota_Amount__c = sq.Annual_Quota_Amount__c/12 ;
                    s.Month_7_Quota_Amount__c = sq.Annual_Quota_Amount__c/12 ;
                    s.Month_8_Quota_Amount__c = sq.Annual_Quota_Amount__c/12 ;
                    s.Month_9_Quota_Amount__c = sq.Annual_Quota_Amount__c/12 ;
                    s.Month_10_Quota_Amount__c = sq.Annual_Quota_Amount__c/12 ;
                    s.Month_11_Quota_Amount__c = sq.Annual_Quota_Amount__c/12 ;
                    s.Month_12_Quota_Amount__c = sq.Annual_Quota_Amount__c/12 ;
                    
                    /*if(sq.Goal_of_monthly_meetings__c != null){
                        s.Goal_of_monthly_meetings__c = sq.Goal_of_monthly_meetings__c;
                    }
                    if(sq.Goal_12m_Avg_Selling_Price__c != null){
                        s.Goal_12m_Avg_Selling_Price__c = sq.Goal_12m_Avg_Selling_Price__c;
                    }
                    if(sq.Goal_12m_Lead_To_Opp_Conv_Rate__c != null){
                        s.Goal_12m_Lead_To_Opp_Conv_Rate__c = sq.Goal_12m_Lead_To_Opp_Conv_Rate__c;
                    }
                    if(sq.Goal_12m_length_of_sales_cycle__c != null){
                        s.Goal_12m_length_of_sales_cycle__c = sq.Goal_12m_length_of_sales_cycle__c;
                    }
                    if(sq.Goal_12m_rolling_close_rate__c != null){
                        s.Goal_12m_rolling_close_rate__c = sq.Goal_12m_rolling_close_rate__c;
                    }
                    
                    if(sq.Goal_Average_Deal_Size__c != null){
                        s.Goal_Average_Deal_Size__c = sq.Goal_Average_Deal_Size__c;
                    }
                     */
                     
                     
                }else{
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
                
            }
            
            
            update srp;
            system.debug(' updated sales profiles Quotas '+srp);                  
          
        }
        catch(Exception ex){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelQuotaUpdateBatch'+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
    }
    
    public void finish(Database.BatchableContext con){
        if(!errorVal){
           // FunnelTriggerBatchHelper.sendErrorMail('Quotas updated');
            
            FunnelCalculateYTDFieldsBatch fb = new FunnelCalculateYTDFieldsBatch(histDateVal,chainBatch ,hisVal );
            Database.executeBatch(fb);        
        }
    }
    
    public Map<id,Sales_Rep_Quota__c> fetchQuotaMap(){
        Map<id,Sales_Rep_Quota__c> srpQuotaMap = new Map<id,Sales_Rep_Quota__c>();
        
        fiscalYr = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');  
        decimal year = fiscalYr.year();
        
        List<Sales_Rep_Quota__c> srpQ = [Select Sales_Rep_Profile__c, Annual_Quota_Amount__c,Year__c From Sales_Rep_Quota__c Where Year__c = :year And Annual_Quota_Amount__c > 0    ];
        
        for(Sales_Rep_Quota__c s : srpQ){
            srpQuotaMap.put(s.Sales_Rep_Profile__c, s);
        }
        
        return srpQuotaMap;
    }
}