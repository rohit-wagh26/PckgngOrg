/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelHistoricalBatchHelper{

    public Static Map<Id,Sales_Rep_Profile__c> fetchCounterRelatedFields(Set<Id> ownerIds, Date executionDate){
                
        //Map to store the sales profiles to be updated
        Map<id, Sales_Rep_Profile__c> profMap = new Map<id, Sales_Rep_Profile__c>();
        
        //Map to store the user id and the corresponding sales profile id
        Map<Id,Id> ownerSalesReps = new Map<Id,Id>();
        
        List<Sales_Rep_Profile__c> salesReps = [SELECT id,User_Record_Name__c,X12_Month_funnel_amt__c,X12_Month_Rolling_Revenue__c,Ytd_QO_added__c,Quarterly_QO_added__c,Monthly_QO_added__c, YTD_Opportunities_won__c, YTD_Opportunities_Added__c, YTD_Leads_Added__c, Quarterly_Opportunities_added_to_Qualifi__c, Monthly_Opportunities_added_to_Qualifie__c, X12_Month_Rolling_Opptys_Won__c, X12_Month_Opprties_Added_to_the_funnel__c, Monthly_Quota_Revenue__c, Monthly_Opportunities_Added_amt__c, Monthly_opp_won__c, Quarterly_Quota_Revenue__c, Quarterly_Opportunities_Added_amt__c,  Quarterly_opp_won__c, YTD_Revenue__c, YTD_Opportunities_Added_amt__c, Ytd_QO_added_Quantitative__c, Quarterly_QO_added_Quantitative__c, Monthly_QO_added_Quantitative__c, X12_Month_Rolling_Close_Rate__c,  Monthly_Close_Rate__c, Monthly_Opportunity_Close_Rate__c, Quarterly_Close_Rate__c, Quarterly_Opportunity_Close_Rate__c, YTD_Close_Rate__c, YTD_Opportunity_Close_Rate__c  FROM Sales_Rep_Profile__c WHERE User_Record_Name__c IN :ownerIds AND Active__c = TRUE];
        
        for(Sales_Rep_Profile__c sr: salesReps ){
            ownerSalesReps.put(sr.User_Record_Name__c,sr.id); 
            profMap.put(sr.id,sr); 
            
        }
                           
        Date currentFiscalYear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        DateTime FyearDateTime = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');        
        
        Date CyearDate;
        
        DateTime CyearGMT;
        
        if(FunnelTriggerBatchHelper.histDataBatch){
            CyearDate = FunnelTriggerBatchHelper.histDateVal;   
            CyearGMT = FunnelTriggerBatchHelper.histDateTimeVal;
        }
        else{
            CyearDate = Date.today();   
            CyearGMT = Date.Today();
        }
        
        system.debug('CyearGMT  -->'+CyearGMT );
        Integer offset = UserInfo.getTimezone().getOffset(CyearGMT);
        Datetime Cyear = CyearGMT.addSeconds(offset/1000);
        system.debug(' Cyear '+Cyear);
        String CyearString = Cyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        String CyearStringDate = CyearString.substring(0,10);
        
        system.debug('Cyear'+Cyear);
        
        String ownerString = '';
        
        //Create a string of all the owners associated with the sales profiles
        for(Id i : ownerIds){
            
            if (ownerString == ''){
                ownerString = '\''+i+'\''+','; 
            }
            else{
            
                ownerString += '\''+i+'\''+',';
            }
           
        }
        
        DateTime Q0 = FyearDateTime ;
        DateTime Q1 = FyearDateTime.addMonths(3);
        DateTime Q2 = Q1.addMonths(3);
        DateTime Q3 = Q2.addMonths(3);
        DateTime Q4 = Q3.addMonths(3);
        
        DateTime startDate;
        DateTime endDate;
        
        system.debug(' Cyear '+Cyear);
        system.debug(' Q0 '+Q0);
        system.debug(' Q1 '+Q1);
        system.debug(' Q2 '+Q2);
        system.debug(' Q3 '+Q3);
        
        //To find which quarter we are lying in
        if( (Q0 <= Cyear) && (Cyear < Q1)){
        
            startDate= Q0;
            endDate = Q1;
                  
        }else if((Q1 <= Cyear) && (Cyear < Q2)){
        
            startDate= Q1;
            endDate = Q2;
        
        }else if((Q2 <= Cyear) && (Cyear < Q3)){
        
            startDate= Q2;
            endDate = Q3;
            
        }else if((Q3 <= Cyear) && (Cyear < Q4)){
        
            startDate= Q3;
            endDate = Q4;
            
        } 
         
        system.debug('startDate'+startDate);
        system.debug('endDate'+endDate);       
        String dateTimeStartDate = startDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        String dateTimeEndDate = endDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');                
        
        if(ownerString != null && ownerString.length() > 0)
            ownerString = ownerString.subString(0,(ownerString.length() - 1));
                
        Decimal histPerc = 0;
        Boolean leadsUsed = false;
        List<Application_Setting__c> prob = [SELECT Id, Qualified_Percentage__c, Leads_used__c FROM Application_Setting__c limit 1];
        
        if(prob != null && prob.size()>0){
            histPerc = prob[0].Qualified_Percentage__c;
            leadsUsed = prob[0].Leads_used__c;
        }
        
        system.debug(' histPerc '+histPerc);
        /*       
        //1. YTD opptys added to qualified funnel
        
        //Fetch the count of open opportunities created by every sales profile in the current fiscal year
        List<AggregateResult> listRepsCreatedOpps = [SELECT COUNT(id) c,  OwnerId sr FROM Opportunity WHERE CreatedDate >= :currentFiscalYear AND CreatedDate <= :CyearDate AND OwnerId IN :ownerIds GROUP BY OwnerId]; 
        System.debug('YTD created -->'+'SELECT COUNT(id) c,  OwnerId sr FROM Opportunity WHERE CreatedDate >= :'+currentFiscalYear+' AND CreatedDate <= :'+CyearDate+' AND OwnerId IN :ownerIds GROUP BY OwnerId');
        Map<Id, AggregateResult> mapRepsCreatedOpps = new Map<Id, AggregateResult>();
        for(AggregateResult a: listRepsCreatedOpps){
            mapRepsCreatedOpps.put((Id)a.get('sr'),a);
        }
        
        Map<Id,Integer> repCountCreatedOpps = new Map<Id,Integer>();
        //Store map of owner id versus count of opptys created in a map
        for(AggregateResult ar: listRepsCreatedOpps){
            if(ar.get('sr') != null)
                repCountCreatedOpps.put((Id)ar.get('sr'),(Integer)(histPerc*(Integer)ar.get('c')));
        }
        
        system.debug(' repCountCreatedOpps '+repCountCreatedOpps);
                
        // 2. Quarterly opps added to qualified funnel
        
        List<AggregateResult> quarterlyOpp= database.query('SELECT ownerId sr , COUNT(id) cq From Opportunity WHERE OwnerId IN ('+ownerString+') And CreatedDate >= '+dateTimeStartDate+' AND CreatedDate < '+dateTimeEndDate+' AND CreatedDate <= '+CyearString+' GROUP BY OwnerId');
        system.debug(' quarterlyOpp added--> '+'SELECT ownerId sr , COUNT(id) cq From Opportunity WHERE OwnerId IN  And CreatedDate >= '+dateTimeStartDate+' AND CreatedDate < '+dateTimeEndDate+' AND CreatedDate <= '+CyearString+' GROUP BY OwnerId');
        //Leadcount=database.query('SELECT COUNT(id) cq From Lead WHERE OwnerId IN ('+ownerString+ ') And CreatedDate >= '+dateTimeFormats +'AND CreatedDate <'+dateTimeFormate );
            
        Map<Id,Integer> repCountQuarCreatedOpps = new Map<Id,Integer>();
        
        //Store map of owner id versus count of opptys created and amount in a map
        for(AggregateResult ar: quarterlyOpp){
            if(ar.get('sr') != null)
                repCountQuarCreatedOpps.put((Id)ar.get('sr'),(Integer)(histPerc*(Integer)ar.get('cq')));
        }
        system.debug(' repCountQuarCreatedOpps '+repCountQuarCreatedOpps);
        
        // 3. Monthly opptys added to qualified funnel
        
        startDate = Datetime.newInstance(Cyear.yearGmt(),Cyear.monthGmt(),1);
        endDate = Datetime.newInstance(Cyear.yearGmt(),Cyear.monthGmt(),Date.daysInMonth(Cyear.yearGmt(),Cyear.monthGmt()));
        
        startDate = startDate.addSeconds(offset/1000);
        endDate = endDate.addSeconds(offset/1000);
        
        dateTimeStartDate = startDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        dateTimeEndDate = endDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        
        List<AggregateResult> monthlyOpp = database.query('SELECT ownerId sr , COUNT(id) cq From Opportunity WHERE OwnerId IN ('+ownerString+') And CreatedDate >= '+dateTimeStartDate+' AND CreatedDate <= '+dateTimeEndDate+' GROUP BY OwnerId');
        system.debug(' monthlyOpp added --> '+'SELECT ownerId sr , COUNT(id) cq From Opportunity WHERE OwnerId IN  And CreatedDate >= '+dateTimeStartDate+' AND CreatedDate <= '+dateTimeEndDate+' GROUP BY OwnerId');
        //Leadcount=database.query('SELECT COUNT(id) cq From Lead WHERE OwnerId IN ('+ownerString+ ') And CreatedDate >= '+dateTimeFormats +'AND CreatedDate <'+dateTimeFormate );
            
        Map<Id,Integer> repCountMonCreatedOpps = new Map<Id,Integer>();
        
        //Store map of owner id versus count of opptys created and amount in a map
        for(AggregateResult ar: monthlyOpp){
            if(ar.get('sr') != null)
                repCountMonCreatedOpps.put((Id)ar.get('sr'),(Integer)(histPerc*(Integer)ar.get('cq')));
        }
        system.debug(' repCountMonCreatedOpps '+repCountMonCreatedOpps);
        */                    
        
        histPerc = histPerc/100;
                         
        for(Sales_Rep_Profile__c s: salesReps){
            
            if(profMap.get(s.id).YTD_Opportunities_Added__c != null){
                profMap.get(s.id).Ytd_QO_added_Quantitative__c = (histPerc * profMap.get(s.id).YTD_Opportunities_Added__c).setScale(0, RoundingMode.HALF_UP);
                profMap.get(s.id).Ytd_QO_added__c = (histPerc * profMap.get(s.id).YTD_Opportunities_Added__c).setScale(0, RoundingMode.HALF_UP);                
            }
            else{
                profMap.get(s.id).Ytd_QO_added_Quantitative__c = 0;
                profMap.get(s.id).Ytd_QO_added__c = 0;
            }                        
            
            if(profMap.get(s.id).Quarterly_Opportunities_added_to_Qualifi__c != null){
                profMap.get(s.id).Quarterly_QO_added_Quantitative__c = (histPerc * profMap.get(s.id).Quarterly_Opportunities_added_to_Qualifi__c).setScale(0, RoundingMode.HALF_UP);
                profMap.get(s.id).Quarterly_QO_added__c= (histPerc * profMap.get(s.id).Quarterly_Opportunities_added_to_Qualifi__c).setScale(0, RoundingMode.HALF_UP);
            }
            else{
                profMap.get(s.id).Quarterly_QO_added_Quantitative__c = 0;
                profMap.get(s.id).Quarterly_QO_added__c = 0;
            }
            
            if(profMap.get(s.id).Monthly_Opportunities_added_to_Qualifie__c != null){
                profMap.get(s.id).Monthly_QO_added_Quantitative__c = (histPerc * profMap.get(s.id).Monthly_Opportunities_added_to_Qualifie__c).setScale(0, RoundingMode.HALF_UP);
                profMap.get(s.id).Monthly_QO_added__c= (histPerc * profMap.get(s.id).Monthly_Opportunities_added_to_Qualifie__c).setScale(0, RoundingMode.HALF_UP);
            }
            else{
                profMap.get(s.id).Monthly_QO_added_Quantitative__c = 0;
                profMap.get(s.id).Monthly_QO_added__c= 0;
            }  
            
          /*  if(profMap.get(s.id).Monthly_Opportunities_added_to_Qualifie__c != null && profMap.get(s.id).X12_Month_Rolling_Opptys_Won__c != null && (histPerc * profMap.get(s.id).X12_Month_Opprties_Added_to_the_funnel__c) > 0){
                profMap.get(s.id).X12_Month_Rolling_Opportunity_Close_Rate__c= (profMap.get(s.id).X12_Month_Rolling_Opptys_Won__c / (histPerc * profMap.get(s.id).X12_Month_Opprties_Added_to_the_funnel__c))*100;
            }
            else{
                profMap.get(s.id).X12_Month_Rolling_Opportunity_Close_Rate__c= 0;
            }  
            
            if(profMap.get(s.id).X12_Month_Rolling_Revenue__c != null && profMap.get(s.id).X12_Month_funnel_amt__c!= null && (histPerc * profMap.get(s.id).X12_Month_funnel_amt__c) > 0){
                profMap.get(s.id).X12_Month_Rolling_Close_Rate__c= (profMap.get(s.id).X12_Month_Rolling_Revenue__c/(histPerc * profMap.get(s.id).X12_Month_funnel_amt__c))*100;
            }
            else{
                profMap.get(s.id).X12_Month_Rolling_Close_Rate__c= 0;
            }
                                              
            
            if(profMap.get(s.id).Monthly_Quota_Revenue__c != null && profMap.get(s.id).Monthly_Opportunities_Added_amt__c != null && (histPerc * profMap.get(s.id).Monthly_Opportunities_Added_amt__c) > 0){
                profMap.get(s.id).Monthly_Close_Rate__c = (profMap.get(s.id).Monthly_Quota_Revenue__c/(histPerc * profMap.get(s.id).Monthly_Opportunities_Added_amt__c))*100;
            }
            else{
                profMap.get(s.id).Monthly_Close_Rate__c = 0;
            }
            
            if(profMap.get(s.id).Monthly_opp_won__c != null && profMap.get(s.id).Monthly_Opportunities_added_to_Qualifie__c != null && (histPerc * profMap.get(s.id).Monthly_Opportunities_added_to_Qualifie__c) > 0){
                profMap.get(s.id).Monthly_Opportunity_Close_Rate__c = (profMap.get(s.id).Monthly_opp_won__c/(histPerc * profMap.get(s.id).Monthly_Opportunities_added_to_Qualifie__c))*100;
            }
            else{
                profMap.get(s.id).Monthly_Opportunity_Close_Rate__c = 0;
            }
            
            if(profMap.get(s.id).Quarterly_Quota_Revenue__c != null && profMap.get(s.id).Quarterly_Opportunities_Added_amt__c != null && (histPerc * profMap.get(s.id).Quarterly_Opportunities_Added_amt__c) > 0){
                profMap.get(s.id).Quarterly_Close_Rate__c = (profMap.get(s.id).Quarterly_Quota_Revenue__c /(histPerc * profMap.get(s.id).Quarterly_Opportunities_Added_amt__c))*100;
            }
            else{
                profMap.get(s.id).Quarterly_Close_Rate__c = 0;
            }
                                    
            if(profMap.get(s.id).Quarterly_opp_won__c != null && profMap.get(s.id).Quarterly_Opportunities_added_to_Qualifi__c != null && (histPerc * profMap.get(s.id).Quarterly_Opportunities_added_to_Qualifi__c) > 0){
                profMap.get(s.id).Quarterly_Opportunity_Close_Rate__c = (profMap.get(s.id).Quarterly_opp_won__c/(histPerc * profMap.get(s.id).Quarterly_Opportunities_added_to_Qualifi__c))*100;
            }
            else{
                profMap.get(s.id).Quarterly_Opportunity_Close_Rate__c = 0;
            }
            
            if(profMap.get(s.id).YTD_Revenue__c != null && profMap.get(s.id).YTD_Opportunities_Added_amt__c != null && (histPerc * profMap.get(s.id).YTD_Opportunities_Added_amt__c) > 0){
                profMap.get(s.id).YTD_Close_Rate__c = (profMap.get(s.id).YTD_Revenue__c/(histPerc * profMap.get(s.id).YTD_Opportunities_Added_amt__c))*100;
            }
            else{
                profMap.get(s.id).YTD_Close_Rate__c = 0;
            }
            
            if(profMap.get(s.id).YTD_Opportunities_won__c != null && profMap.get(s.id).YTD_Opportunities_Added__c != null && (histPerc * profMap.get(s.id).YTD_Opportunities_Added__c) > 0){
                profMap.get(s.id).YTD_Opportunity_Close_Rate__c = (profMap.get(s.id).YTD_Opportunities_won__c/(histPerc * profMap.get(s.id).YTD_Opportunities_Added__c))*100;
            }
            else{
                profMap.get(s.id).YTD_Opportunity_Close_Rate__c = 0;
            }
            */
            if(leadsUsed){
                //profMap.get(s.id).Lead_to_Opportunity_Conversion_Rate__c = prob[0].Qualified_Percentage__c;
                               
                if(profMap.get(s.id).Ytd_leads_added__c != null && profMap.get(s.id).Ytd_leads_added__c != 0)
                    profMap.get(s.id).Lead_to_Opportunity_Conversion_Rate__c = profMap.get(s.id).Ytd_QO_added_Quantitative__c/profMap.get(s.id).Ytd_leads_added__c;
                 else
                    profMap.get(s.id).Lead_to_Opportunity_Conversion_Rate__c = 0;                
            }                        
            
            //profMap.put(s.id,s);
        }
        
        system.debug(' profMap in helper returned '+profMap);
        return profMap;         
    
    }
}