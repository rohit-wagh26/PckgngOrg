public with Sharing  class FunnelGoalBatch implements Database.Batchable<sobject>, Database.Stateful{
    
    Boolean chainBatch;
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    Date triggerDate;
    Boolean histVal;
    
    Boolean errorVal = false;
   
    public FunnelGoalBatch(Date scheduleDate, Boolean chain,Boolean historical){
        triggerDate = scheduleDate;
        chainBatch = chain;
        histVal = historical;
    }
       
     public Database.QueryLocator start(Database.BatchableContext con){
         
        return Database.getQueryLocator('SELECT Id,Role__c, User_Record_Name__c, Number_of_meetings_YTD__c,X12_Month_Average_Selling_Price__c,X12_Month_Lead_Conv_for_1_oppty__c,X12_Month_Rolling_Average_Sales_Cycle__c,X12_Month_Rolling_Close_Rate__c,X12_Month_Rolling_Opportunity_Close_Rate__c,Average_Deal_Size__c FROM Sales_Rep_Profile__c Where Active__c = TRUE    ');
    }

    public void execute(Database.BatchableContext con, List<Sales_Rep_Profile__c> srp){
        try{        
            Map<String,GoalWrapper> roleGoalMap = roleMap();
            
            for(Sales_Rep_Profile__c s : srp){
                
                if(roleGoalMap.keySet().contains(s.Role__c)){
                    GoalWrapper goal = roleGoalMap.get(s.Role__c);
                    
                    if(s.Number_of_meetings_YTD__c != null && s.Number_of_meetings_YTD__c > 0 && ((s.Number_of_meetings_YTD__c/12) > goal.Number_of_monthly_meetings)){
                        s.Goal_of_monthly_meetings__c =  (s.Number_of_meetings_YTD__c/12).setScale(0, RoundingMode.HALF_UP); 
                    }else{
                        s.Goal_of_monthly_meetings__c = goal.Number_of_monthly_meetings ;
                    }
                    
                     
                    if(s.X12_Month_Average_Selling_Price__c != null && s.X12_Month_Average_Selling_Price__c > 0 && s.X12_Month_Average_Selling_Price__c > goal.X12_month_avg_selling_price ){
                        s.Goal_12m_Avg_Selling_Price__c = s.X12_Month_Average_Selling_Price__c.setScale(0, RoundingMode.HALF_UP);
                    }else{
                        s.Goal_12m_Avg_Selling_Price__c = goal.X12_month_avg_selling_price ;
                    }
                    
                    if(s.X12_Month_Lead_Conv_for_1_oppty__c != null && s.X12_Month_Lead_Conv_for_1_oppty__c > 0 && s.X12_Month_Lead_Conv_for_1_oppty__c > goal.X12_month_rolling_lead_to_opp_conv_rate ){
                        s.Goal_12m_Lead_To_Opp_Conv_Rate__c  = s.X12_Month_Lead_Conv_for_1_oppty__c.setScale(2, RoundingMode.HALF_UP);
                    }else{
                        s.Goal_12m_Lead_To_Opp_Conv_Rate__c  = goal.X12_month_rolling_lead_to_opp_conv_rate ;
                    }
                    
                    if(s.X12_Month_Rolling_Close_Rate__c != null && s.X12_Month_Rolling_Close_Rate__c > 0 && s.X12_Month_Rolling_Close_Rate__c > goal.X12_month_rolling_amt_close_rate ){
                        s.Goal_12m_rolling_amt_close_rate__c     = s.X12_Month_Rolling_Close_Rate__c.setScale(2, RoundingMode.HALF_UP);
                    }else{
                        s.Goal_12m_rolling_amt_close_rate__c = goal.X12_month_rolling_amt_close_rate ;
                    }
                    
                    if(s.X12_Month_Rolling_Opportunity_Close_Rate__c != null && s.X12_Month_Rolling_Opportunity_Close_Rate__c > 0 && s.X12_Month_Rolling_Opportunity_Close_Rate__c > goal.X12_month_rolling_opp_close_rate ){
                        s.Goal_12m_rolling_close_rate__c     = s.X12_Month_Rolling_Opportunity_Close_Rate__c.setScale(2, RoundingMode.HALF_UP);
                    }else{
                        s.Goal_12m_rolling_close_rate__c = goal.X12_month_rolling_opp_close_rate ;
                    }
                    
                    if(s.Average_Deal_Size__c != null && s.Average_Deal_Size__c > 0 && s.Average_Deal_Size__c > goal.X12_month_rolling_avg_deal_size ){
                        s.Goal_Average_Deal_Size__c  = s.Average_Deal_Size__c.setScale(0, RoundingMode.HALF_UP);
                    }else{
                        s.Goal_Average_Deal_Size__c = goal.X12_month_rolling_avg_deal_size ;
                    }
                    
                    if(s.X12_Month_Rolling_Average_Sales_Cycle__c != null && s.X12_Month_Rolling_Average_Sales_Cycle__c > 0 && s.X12_Month_Rolling_Average_Sales_Cycle__c < goal.X12_month_rolling_avg_sales_cycle ){
                        s.Goal_12m_length_of_sales_cycle__c  = s.X12_Month_Rolling_Average_Sales_Cycle__c.setScale(0, RoundingMode.HALF_UP);
                    }else{
                        s.Goal_12m_length_of_sales_cycle__c = goal.X12_month_rolling_avg_sales_cycle ;
                    }
                    
                    
                    
                }
                
                
            }
             update srp ;
        }
        catch(Exception ex){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelGoalBatch '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
    }
    
    public void finish(Database.BatchableContext con){
        if(!errorVal){
            
            Map<String,GoalWrapper> roleGoalMapinsert = roleMap();
            List<Yearly_goals_by_Role__c> yearlyGoal = new List<Yearly_goals_by_Role__c>(); 
            
            for(String s: roleGoalMapinsert.keySet() ){
                
                Yearly_goals_by_Role__c y = new Yearly_goals_by_Role__c();
                GoalWrapper g = roleGoalMapinsert.get(s);
                y.Role__c = s;
                y.Number_of_monthly_meetings__c =   g.Number_of_monthly_meetings ;
                y.X12_month_rolling_opp_close_rate__c = g.X12_month_rolling_opp_close_rate ;
                y.X12_month_rolling_lead_to_opp_conv_rate__c = g.X12_month_rolling_lead_to_opp_conv_rate ;
                y.X12_month_rolling_avg_sales_cycle__c  = g.X12_month_rolling_avg_sales_cycle ;
                y.X12_month_rolling_avg_deal_size__c = g.X12_month_rolling_avg_deal_size ;
                y.X12_month_rolling_amt_close_rate__c = g.X12_month_rolling_amt_close_rate ;
                y.X12_month_avg_selling_price__c = g.X12_month_avg_selling_price ;
                y.Year__c =  triggerDate.year() +1 ;
                y.Name =s +' Goal';
                yearlyGoal.add(y);
            }
            insert yearlyGoal;
            
            if(chainBatch){
                FunnelYearlyBatch fm = new FunnelYearlyBatch(triggerDate,chainBatch,histVal);
                Database.executeBatch(fm);
            }
             
        }
    }
    
    public class GoalWrapper{
        Decimal X12_month_avg_selling_price;
        Decimal X12_month_rolling_amt_close_rate;
        Decimal X12_month_rolling_avg_deal_size;
        Decimal X12_month_rolling_avg_sales_cycle;
        Decimal X12_month_rolling_lead_to_opp_conv_rate;
        Decimal X12_month_rolling_opp_close_rate;
        Decimal Number_of_monthly_meetings;
        
    }
    
    public Map<String,GoalWrapper> roleMap(){
        
        Map<String,GoalWrapper> returnMap = new Map<String,GoalWrapper>();
        
        List<Sales_Rep_Profile_Snapshot__c>  srpsnap = [Select id, Snapshot_Scheduled_Date__c From Sales_Rep_Profile_Snapshot__c Order by Snapshot_Scheduled_Date__c Desc Limit 1 ];
        
        if(srpsnap != null && srpsnap.size()>0){
            
            Date snapDate  = srpsnap[0].Snapshot_Scheduled_Date__c;
            system.debug('snapDate  --'+snapDate  );
            // Added below condition to call the goal batch independently
            if(!chainBatch){
                snapDate = triggerDate;
            }
             system.debug('snapDate  --'+snapDate  );
            List<AggregateResult> ar=[ SELECT Role__c r, AVG(Number_of_meetings_YTD__c) ytdm , AVG(X12_Month_Average_Selling_Price__c) sp, AVG(X12_Month_Lead_Conv_for_1_oppty__c) lc , AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Rolling_Close_Rate__c) acr, AVG(X12_Month_Rolling_Opportunity_Close_Rate__c) cr ,AVG(Average_Deal_Size__c) ds from Sales_Rep_Profile_Snapshot__c where Snapshot_Scheduled_Date__c = :snapDate AND Annual_Quota_Amount__c > 0 AND Tenure_in_current_role__c >= 12 Group by Role__c];
             system.debug('ar  --  SELECT Role__c r, AVG(Number_of_meetings_YTD__c) ytdm , AVG(X12_Month_Average_Selling_Price__c) sp, AVG(X12_Month_Lead_Conv_for_1_oppty__c) lc , AVG(X12_Month_Rolling_Average_Sales_Cycle__c) sc, AVG(X12_Month_Rolling_Close_Rate__c) acr, AVG(X12_Month_Rolling_Opportunity_Close_Rate__c) cr ,AVG(Average_Deal_Size__c) ds from Sales_Rep_Profile_Snapshot__c where Snapshot_Scheduled_Date__c = '+snapDate+' AND Annual_Quota_Amount__c > 0 AND Tenure_in_current_role__c >= 12 Group by Role__c'   );
            List<Application_Setting__c> asp= [Select Stretch_percentage__c From Application_Setting__c LIMIT 1];
            
            Decimal stretchPercentage = 1.2;
            if(asp != null && asp.size()>0 && asp[0].Stretch_percentage__c != null && asp[0].Stretch_percentage__c >0) {
                stretchPercentage = 1 + (asp[0].Stretch_percentage__c/100);
            }
        
            for(AggregateResult a :ar){
                
                GoalWrapper gw = new GoalWrapper();
                
                if(a.get('r') != null ){
                    
                    if(a.get('ytdm') != null){
                        gw.Number_of_monthly_meetings = (((Decimal)(a.get('ytdm'))/12)*stretchPercentage).setScale(0, RoundingMode.HALF_UP);
                    }else{
                        gw.Number_of_monthly_meetings = 0;
                    }
                    
                    if(a.get('sp') != null){
                        gw.X12_month_avg_selling_price = (((Decimal)(a.get('sp')))*stretchPercentage).setScale(0, RoundingMode.HALF_UP);
                    }else{
                        gw.X12_month_avg_selling_price = 0;
                    }
                    
                    if(a.get('lc') != null){
                        gw.X12_month_rolling_lead_to_opp_conv_rate = (((Decimal)(a.get('lc')))*stretchPercentage).setScale(2, RoundingMode.HALF_UP);
                    }else{
                        gw.X12_month_rolling_lead_to_opp_conv_rate =  0;
                    }
                    
                    if(a.get('sc') != null){
                        gw.X12_month_rolling_avg_sales_cycle =((Decimal)(a.get('sc'))).setScale(0, RoundingMode.HALF_UP);
                    }else{
                        gw.X12_month_rolling_avg_sales_cycle = 0;
                    }
                    
                    if(a.get('acr') != null){
                        gw.X12_month_rolling_amt_close_rate = (((Decimal)(a.get('acr')))*stretchPercentage).setScale(2, RoundingMode.HALF_UP);
                    }else{
                        gw.X12_month_rolling_amt_close_rate = 0;
                    }
                    
                    if(a.get('cr') != null){
                        gw.X12_month_rolling_opp_close_rate = (((Decimal)(a.get('cr')))*stretchPercentage).setScale(2, RoundingMode.HALF_UP);
                    }else{
                        gw.X12_month_rolling_opp_close_rate = 0;
                    }
                    
                    if(a.get('ds') != null){
                        gw.X12_month_rolling_avg_deal_size = (((Decimal)(a.get('ds')))*stretchPercentage).setScale(0, RoundingMode.HALF_UP);
                    }else{
                        gw.X12_month_rolling_avg_deal_size = 0;
                    }
                    returnMap.put((String)a.get('r'),gw);
                }
                
                
            }
        }
        
        return returnMap;
    }
}