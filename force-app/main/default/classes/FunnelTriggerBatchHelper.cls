/*
    Author:  Carine DMello
    Created On: 11/20/2017
    This class contains all methods that are called from the triggers    
    Copyright: Funnel Metrics, LLC

*/

public class FunnelTriggerBatchHelper{
    
    public static boolean fromBatch = false;
    
    public static boolean doNotCallSPTrigger = false;
    
    public static boolean histDataBatch = false;
    
    public static Date histDateVal;
    
    public static DateTime histDateTimeVal;
    
    public Static Date getFiscalYearDate(String recName){
    
        Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues(recName);
        
        if(fy != null)
            return fy.Start_Date__c;
        else
            return null;
    }
    
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
     
    public Static Fiscal_Year_Setting__c getFiscalYearRecord(String recName){
    
        Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues(recName);
        
        return fy;
    }
    
    /*new*/
    public Static Set<Id> fetchRelatedOwners(List<Opportunity> newVals, List<Opportunity> oldVals){
        
        //system.debug(' newVals '+newVals);
        
        //system.debug(' oldVals '+oldVals);
        
        Set<Id> ownerIds = new Set<Id>();
        
        Date currentFiscalYear = getFiscalYearDate('Current_Year');
        
        //Fetch all the sales profiles associated with the opportunities (both the old and new values)
        for (Opportunity o : newVals){ 
            
            if(currentFiscalYear == null){
                o.addError('The fiscal year start date is not set');
            }
        
            if(o.OwnerId != null){ 
                 ownerIds.add(o.OwnerId);
            }
                
        }
        
        //Fetch the sales profiles associated with the opportunities before the update
        if(trigger.isUpdate){
            //system.debug(' is update' );
            for (Opportunity o : oldVals){ 
                //system.debug(' old '+o);  
                if(o.OwnerId != null){ 
                     ownerIds.add(o.OwnerId);
                }
            }
        }
        
        return ownerIds;
        
    } 
    
    public Static Set<Id> fetchRelatedLeadOwners(List<Lead> newVals,List<Lead> oldVals){
        
        //system.debug(' newVals '+newVals);
        
        Set<Id> ownerIds = new Set<Id>();
        
        Date currentFiscalYear = getFiscalYearDate('Current_Year');
        
        //Fetch all the sales profiles associated with the leads (both the old and new values)
        for (Lead o : newVals){ 
            
            if(currentFiscalYear == null){
                o.addError('The fiscal year start date is not set');
            }
        
            if(o.OwnerId != null){ 
                 ownerIds.add(o.OwnerId);
            }
                
        }
        
        if(trigger.isUpdate){
            //system.debug(' is update' );
            for (Lead o : oldVals){ 
                //system.debug(' old '+o);  
                if(o.OwnerId != null){ 
                     ownerIds.add(o.OwnerId);
                }
            }
        }
                
        return ownerIds;
        
    }
      
    /*new*/
    public Static Map<Id,Sales_Rep_Profile__c> fetchSalesProfileUpdatedMapFromOwners(Set<Id> ownerIds, DateTime executionDate){
        //try{    
        Decimal userprob = 0;
        List<Application_Setting__c> prob = [SELECT Id, Probability__c FROM Application_Setting__c limit 1];
        if(prob != null && prob.size()>0){
            userprob = prob[0].Probability__c;
        }
        
        //Map to store the sales profiles to be updated
        Map<id, Sales_Rep_Profile__c> profMap = new Map<id, Sales_Rep_Profile__c>();
        
        //Map to store the user id and the corresponding sales profile id
        Map<Id,Id> ownerSalesReps = new Map<Id,Id>();
        
        List<Sales_Rep_Profile__c> salesReps = [SELECT id,Profile_Type__c,User_Record_Name__c FROM Sales_Rep_Profile__c WHERE User_Record_Name__c IN :ownerIds];
        
        for(Sales_Rep_Profile__c sr: salesReps ){
            ownerSalesReps.put(sr.User_Record_Name__c,sr.id);    
        }
                           
        Date currentFiscalYear = getFiscalYearDate('Current_Year');
        DateTime FyearDateTime = getFiscalYearDate('Current_Year');
        /*Start fetching quarterly created opportunities*/
        // Cyear = Date.Today(); Static date
        
        //DateTime Cyear;
        
        //if(executionDate != null)
        //    Cyear = Date.Today();
        //else
        //Cyear = DateTime.newInstance(2018,05,31,0,0,0);
        //Date CyearDate = Date.newInstance(2018,11,30);
        
        //Date CyearDate = Date.Today();
        //DateTime CyearGMT = DateTime.newInstance(2018,11,30,0,0,0);
        //DateTime CyearGMT = Date.Today();
        
        Date CyearDate;
        
        DateTime CyearDateTime;
        
        DateTime CyearGMT;
        
        //system.debug(' hist data in trigger '+FunnelTriggerBatchHelper.histDataBatch);
        
        if(FunnelTriggerBatchHelper.histDataBatch){
            CyearDate = FunnelTriggerBatchHelper.histDateVal;   
            CyearGMT = FunnelTriggerBatchHelper.histDateTimeVal;
            //CyearDateTime = CyearGMT;
        }
        else if( FunnelTriggerBatchHelper.histDateVal != null){
            CyearDate = FunnelTriggerBatchHelper.histDateVal;   
            CyearGMT = FunnelTriggerBatchHelper.histDateTimeVal;
            //CyearDateTime = CyearGMT;
        }
        else{
            CyearDate = Date.today();  
            system.debug(' CyearDate  '+CyearDate );
            CyearDateTime = System.now(); 
            CyearGMT = Date.today();
            system.debug(' CyearGMT '+CyearGMT );
        }
        
        //system.debug('CyearGMT  -->'+CyearGMT );
        Integer offset = UserInfo.getTimezone().getOffset(CyearGMT);
        //Datetime Cyear = CyearGMT.addSeconds(offset/1000);
        Datetime Cyear = CyearGMT;
        system.debug(' Cyear '+Cyear );
        //system.debug(' Cyear '+Cyear);
        String CyearString = Cyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        String CyearStringDate = CyearString.substring(0,10);
        
        //system.debug('Cyear'+Cyear);
        
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
        String dateTimeEndDate = endDate.formatgmt('yyyy-MM-dd\'T\'23:59:59\'Z\'');                
        String omit = 'Omitted';
        if(ownerString != null && ownerString.length() > 0)
            ownerString = ownerString.subString(0,(ownerString.length() - 1));
            
        List<AggregateResult> quarterlyOpp= database.query('SELECT ownerId sr , COUNT(id) cq From Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+ownerString+') And CreatedDate >= '+dateTimeStartDate+' AND CreatedDate <= '+dateTimeEndDate+' GROUP BY OwnerId');
        //system.debug(' quarterlyOpp added--> '+'SELECT ownerId sr , COUNT(id) cq From Opportunity WHERE OwnerId IN  And CreatedDate >= '+dateTimeStartDate+' AND CreatedDate <= '+dateTimeEndDate+' GROUP BY OwnerId');
        //Leadcount=database.query('SELECT COUNT(id) cq From Lead WHERE OwnerId IN ('+ownerString+ ') And CreatedDate >= '+dateTimeFormats +'AND CreatedDate <'+dateTimeFormate );
            
        Map<Id,Integer> repCountQuarCreatedOpps = new Map<Id,Integer>();
        
        //Store map of owner id versus count of opptys created and amount in a map
        for(AggregateResult ar: quarterlyOpp){
            if(ar.get('sr') != null)
                repCountQuarCreatedOpps.put((Id)ar.get('sr'),(Integer)ar.get('cq'));
        }
        //system.debug(' repCountQuarCreatedOpps '+repCountQuarCreatedOpps);
        /*End fetching quarterly created opportunities*/
        
        String dateTimeStartDateCD = dateTimeStartDate;
        
        dateTimeStartDate = dateTimeStartDate.substring(0,10);
        dateTimeEndDate = dateTimeEndDate.substring(0,10);
        
        /*Custom metadata code*/
        createRecordTypeMap();
        
        Map<Id,Decimal> repQuarRevenue  =  fetchRevenueNumbers(ownerString, dateTimeStartDate, dateTimeEndDate, 'closed');  
        System.debug('repQuarRevenue  '+ dateTimeStartDate +' - '+dateTimeEndDate); 
        /*Custom metadata code*/
        
        /*Start fetching quarterly revenue*/
        /*List<AggregateResult> quarOppRevenue = database.query('SELECT ownerId sr , SUM(Amount) a From Opportunity WHERE OwnerId IN ('+ownerString+') And CloseDate >= '+dateTimeStartDate+' AND CloseDate < '+dateTimeEndDate+'  AND isWon = true  GROUP BY OwnerId');
        //system.debug('quarOppRevenue $ -->'+'SELECT ownerId sr , SUM(Amount) a From Opportunity WHERE OwnerId IN And CloseDate >= '+dateTimeStartDate+' AND CloseDate < '+dateTimeEndDate+'  AND isWon = true  GROUP BY OwnerId');
        Map<Id,Decimal> repQuarRevenue = new Map<Id,Decimal>();
        
        //Store map of owner id versus count of opptys created and amount in a map
        for(AggregateResult ar: quarOppRevenue){
            if(ar.get('sr') != null)
                repQuarRevenue.put((Id)ar.get('sr'),(Decimal)ar.get('a'));
        }
        //system.debug(' repQuarRevenue '+repQuarRevenue); */
        /*End fetching quarterly revenue*/ 
        
        /*Start fetching monthly created opportunities*/
        // Cyear = Date.Today(); Static date
        startDate = Datetime.newInstance(Cyear.yearGmt(),Cyear.monthGmt(),1);
        endDate = Datetime.newInstance(Cyear.yearGmt(),Cyear.monthGmt(),Date.daysInMonth(Cyear.yearGmt(),Cyear.monthGmt()));
        
        startDate = startDate.addSeconds(offset/1000);
        endDate = endDate.addSeconds(offset/1000);
        
        dateTimeStartDate = startDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        dateTimeEndDate = endDate.formatgmt('yyyy-MM-dd\'T\'23:59:59\'Z\'');
        
        List<AggregateResult> monthlyOpp = database.query('SELECT ownerId sr , COUNT(id) cq From Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+ownerString+') And CreatedDate >= '+dateTimeStartDate+' AND CreatedDate <= '+dateTimeEndDate+' GROUP BY OwnerId');
        //system.debug(' monthlyOpp added --> '+'SELECT ownerId sr , COUNT(id) cq From Opportunity WHERE OwnerId IN  And CreatedDate >= '+dateTimeStartDate+' AND CreatedDate <= '+dateTimeEndDate+' GROUP BY OwnerId');
        //Leadcount=database.query('SELECT COUNT(id) cq From Lead WHERE OwnerId IN ('+ownerString+ ') And CreatedDate >= '+dateTimeFormats +'AND CreatedDate <'+dateTimeFormate );
            
        Map<Id,Integer> repCountMonCreatedOpps = new Map<Id,Integer>();
        
        //Store map of owner id versus count of opptys created and amount in a map
        for(AggregateResult ar: monthlyOpp){
            if(ar.get('sr') != null)
                repCountMonCreatedOpps.put((Id)ar.get('sr'),(Integer)ar.get('cq'));
        }
        //system.debug(' repCountMonCreatedOpps '+repCountMonCreatedOpps);
        /*End fetching monthly created opportunities*/
        
        dateTimeStartDateCD = dateTimeStartDate;
        dateTimeStartDate = dateTimeStartDate.substring(0,10);
        dateTimeEndDate = dateTimeEndDate.substring(0,10);
                
        /*Custom metadata code*/
        Map<Id,Decimal> repMonRevenue  =  fetchRevenueNumbers(ownerString, dateTimeStartDate, dateTimeEndDate, 'closed');  
        System.debug('repQuarRevenue  '+ dateTimeStartDate +' - '+dateTimeEndDate);  
        Map<Id,Decimal> repCurrentPipeline  =  fetchCurrentPipeline(ownerString);   
       
       /*Custom metadata code*/
               
        /*Start fetching monthly revenue*/
        /*List<AggregateResult> monthlyOppRevenue = database.query('SELECT ownerId sr , SUM(Amount) a From Opportunity WHERE OwnerId IN ('+ownerString+') And CloseDate >= '+dateTimeStartDate+' AND CloseDate < '+dateTimeEndDate+' AND isWon = true GROUP BY OwnerId');
        //system.debug(' monthlyOppRevenue $ -->'+'SELECT ownerId sr , SUM(Amount) a From Opportunity WHERE OwnerId IN ('+ownerString+') And CloseDate >= '+dateTimeStartDate+' AND CloseDate < '+dateTimeEndDate+'  AND isWon = true  GROUP BY OwnerId');
        Map<Id,Decimal> repMonRevenue = new Map<Id,Decimal>();
        
        //Store map of owner id versus count of opptys created and amount in a map
        for(AggregateResult ar: monthlyOppRevenue){
            if(ar.get('sr') != null)
                repMonRevenue.put((Id)ar.get('sr'),(Decimal)ar.get('a'));
        }*/
        //system.debug(' repMonRevenue '+repMonRevenue); 
        /*End fetching monthly revenue*/        
        
        //DateTime Syear = datetime.newInstance(2018,11,30, 0, 0, 0);
        //String Syears = Syear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        
        //This is used under dynamic query for Annual Added             
        String Fisyear =FyearDateTime.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');    
                         
        
        //system.debug(' currentFiscalYear '+currentFiscalYear);
        //system.debug(' CyearDate '+CyearDate);
        
        DateTime currentFiscalYearDT = currentFiscalYear;
        String currentFiscalYearStr = currentFiscalYearDT.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        currentFiscalYearStr = currentFiscalYearStr.substring(0,10);
        
        DateTime CyearDateDT = CyearDate;
        String CyearDateStr = CyearDateDT.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        CyearDateStr = CyearDateStr.substring(0,10);
        
        /*Custom metadata code*/
        Map<Id,Decimal> mapRepsClosedYtd =  fetchRevenueNumbers(ownerString, currentFiscalYearStr, CyearDateStr, 'closed ytd');   
        System.debug('fetchRevenueNumbers  '+ currentFiscalYearStr+' - '+CyearDateStr); 
        /*Custom metadata code*/
        
        List<AggregateResult> listRepsClosedOpps = new List<AggregateResult>();
        //Fetch the count of closed opportunities, sum of revenue, avg of days to close an opportunity for all the sales profiles
        listRepsClosedOpps = database.query('SELECT COUNT(id) c, SUM(Amount) s, OwnerId sr FROM Opportunity WHERE ForecastCategoryName != '+'\''+omit+'\''+'  And isWon = true  AND CloseDate >= '+currentFiscalYearStr+' AND CloseDate <= '+CyearDateStr+' AND OwnerId IN ('+ownerString+') GROUP BY OwnerId');    
        //system.debug('listRepsClosedOpps -->'+'SELECT COUNT(id) c, SUM(Amount) s, OwnerId sr FROM Opportunity WHERE isWon = true  AND CloseDate >= :'+currentFiscalYear+' AND CloseDate <= :'+CyearDate +'AND OwnerId IN :ownerIds GROUP BY OwnerId');
        Map<Id, AggregateResult> mapRepsClosedOpps = new Map<Id, AggregateResult>();
        for(AggregateResult a: listRepsClosedOpps){
            mapRepsClosedOpps.put((Id)a.get('sr'),a);
        }
        
        String FC= Fisyear.substring(0,10);                        
        
        //system.debug(' currentFiscalYear '+currentFiscalYear);
        //system.debug(' listRepsClosedOpps  '+listRepsClosedOpps);
        
        List<FunnelMetrics__Funnel_Opp_Stage_Order__mdt> oppStageOrderList = [SELECT id,FunnelMetrics__Stage_Name__c from FunnelMetrics__Funnel_Opp_Stage_Order__mdt];
        Set<String> stages = new Set<String>();
        For(FunnelMetrics__Funnel_Opp_Stage_Order__mdt os : oppStageOrderList){
            stages.add(os.FunnelMetrics__Stage_Name__c);
        }
        
        //Fetch the count of open opportunities associated with every sales profile
        List<AggregateResult> listRepsOpenOpps = new List<AggregateResult>();
        String str = 'SELECT COUNT(id) c,  OwnerId sr FROM Opportunity WHERE (ForecastCategoryName != '+'\''+omit+'\''+' OR StageName in :stages)  And IsClosed = false AND OwnerId IN ('+ownerString+')GROUP BY OwnerId';
        system.debug('s == '+ str);
        listRepsOpenOpps = database.query('SELECT COUNT(id) c,  OwnerId sr FROM Opportunity WHERE (ForecastCategoryName != '+'\''+omit+'\''+' OR StageName in :stages)  And IsClosed = false AND OwnerId IN ('+ownerString+')GROUP BY OwnerId');
        System.debug('listRepsOpenOpps == '+listRepsOpenOpps);
        Map<Id, AggregateResult> mapRepsOpenOpps = new Map<Id, AggregateResult>();
        for(AggregateResult a: listRepsOpenOpps){
            mapRepsOpenOpps.put((Id)a.get('sr'),a);
        }
        
        //system.debug(' currentFiscalYear '+currentFiscalYear);
        //system.debug(' CyearDate '+CyearDate);
        
        DateTime CyearEndDate = Cyear.addDays(1);
        String CyearEndDateStr = CyearEndDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        String currentFiscalYearStr1 = currentFiscalYearDT.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        
        
        //Fetch the count of open opportunities created by every sales profile in the current fiscal year
        List<AggregateResult> listRepsCreatedOpps = new List<AggregateResult>();
        listRepsCreatedOpps = database.query('SELECT COUNT(id) c,  OwnerId sr FROM Opportunity WHERE ForecastCategoryName != '+'\''+omit+'\''+' And CreatedDate >= '+currentFiscalYearStr1+' AND CreatedDate < '+CyearEndDateStr+' AND OwnerId IN ('+ownerString+') GROUP BY OwnerId'); 
        //system.debug('YTD created -->'+'SELECT COUNT(id) c,  OwnerId sr FROM Opportunity WHERE CreatedDate >= :'+currentFiscalYear+' AND CreatedDate < :'+CyearEndDate+' AND OwnerId IN :ownerIds GROUP BY OwnerId');
        Map<Id, AggregateResult> mapRepsCreatedOpps = new Map<Id, AggregateResult>();
        for(AggregateResult a: listRepsCreatedOpps){
            mapRepsCreatedOpps.put((Id)a.get('sr'),a);
        }
        
        //FunnelTriggerBatchHelper.sendErrorMail(' FunnelCalculateYTDFieldsBatch date fields start date is '+currentFiscalYear+' end date is '+CyearEndDate+' listRepsCreatedOpps '+listRepsCreatedOpps);                                                          

        //Fetch the count of open opportunities created by every sales profile in the current fiscal year
        //List<AggregateResult> listRepsCreatedOpps1 = [SELECT COUNT(id) c,  OwnerId sr FROM Opportunity WHERE CreatedDate >= :currentFiscalYear AND CreatedDate <= :CyearDateTime AND OwnerId IN :ownerIds GROUP BY OwnerId]; 
        
        //FunnelTriggerBatchHelper.sendErrorMail(' FunnelCalculateYTDFieldsBatch date fields start date 1 is '+currentFiscalYear+' end date is '+CyearDateTime+' listRepsCreatedOpps1 '+listRepsCreatedOpps1);                                                          
        
        Map<Id,Integer> repCountCreatedOpps = new Map<Id,Integer>();
        //Store map of owner id versus count of opptys created in a map
        for(AggregateResult ar: listRepsCreatedOpps){
            if(ar.get('sr') != null)
                repCountCreatedOpps.put((Id)ar.get('sr'),(Integer)ar.get('c'));
        }
        
        //system.debug(' repCountCreatedOpps '+repCountCreatedOpps);
        
        for(Sales_Rep_Profile__c s: salesReps){
                
            Boolean associatedWithOpp = false;
                
            if(mapRepsClosedOpps.get(s.User_Record_Name__c) != null){
                s.YTD_Opportunities_won__c = (Integer)(mapRepsClosedOpps.get(s.User_Record_Name__c).get('c')); 
                //s.YTD_Revenue__c = (Decimal)(mapRepsClosedOpps.get(s.User_Record_Name__c).get('s'));
                }    
            else{
                s.YTD_Opportunities_won__c = 0;
                //s.YTD_Revenue__c = 0;
            }
            
            /*Custom metadata code*/
            if(s.Profile_Type__c != 'Hybrid' && s.Profile_Type__c != 'Overlay'){
                if(mapRepsClosedYtd.get(s.User_Record_Name__c) != null){
                    s.YTD_Revenue__c = mapRepsClosedYtd.get(s.User_Record_Name__c);
                    }    
                else{
                    s.YTD_Revenue__c = 0;
                }
            } 
            /*Custom metadata code*/
            
            if(mapRepsOpenOpps.get(s.User_Record_Name__c) != null){
                
                s.Current_Active_Opportunities__c = (Integer)(mapRepsOpenOpps.get(s.User_Record_Name__c).get('c'));
            }
            else{
                s.Current_Active_Opportunities__c = 0;
            }
            
            if(repCountCreatedOpps.get(s.User_Record_Name__c) != null){
                s.YTD_Opportunities_Added__c = repCountCreatedOpps.get(s.User_Record_Name__c);
            }
            else{
                s.YTD_Opportunities_Added__c = 0;
            }
            
            
            //Update Quarterly opportunities added field 
            if(repCountQuarCreatedOpps.get(s.User_Record_Name__c) != null){
                s.Quarterly_Opportunities_added_to_Qualifi__c = repCountQuarCreatedOpps.get(s.User_Record_Name__c);
            }
            else{
                s.Quarterly_Opportunities_added_to_Qualifi__c = 0;
            }
            
            //Update Monthly opportunities added field 
            if(repCountMonCreatedOpps.get(s.User_Record_Name__c) != null){
                s.Monthly_Opportunities_added_to_Qualifie__c = repCountMonCreatedOpps.get(s.User_Record_Name__c);
        }
            else{
                s.Monthly_Opportunities_added_to_Qualifie__c = 0;
            }            
                
            //Update Monthly revenue field 
            if(s.Profile_Type__c != 'Hybrid' && s.Profile_Type__c != 'Overlay'){
                if(repMonRevenue.get(s.User_Record_Name__c) != null){
                    s.Monthly_Quota_Revenue__c = repMonRevenue.get(s.User_Record_Name__c);
                }
                else{
                    s.Monthly_Quota_Revenue__c = 0;
                }
            }
            //Update Quarterly revenue field 
            if(s.Profile_Type__c != 'Hybrid' && s.Profile_Type__c != 'Overlay'){
                 if(repQuarRevenue.get(s.User_Record_Name__c) != null){
                    s.Quarterly_Quota_Revenue__c = repQuarRevenue.get(s.User_Record_Name__c);
                }
                else{
                    s.Quarterly_Quota_Revenue__c = 0;
                }
            }
            
            if(repCurrentPipeline.get(s.User_Record_Name__c) != null){
                s.Current_Pipeline__c = repCurrentPipeline.get(s.User_Record_Name__c);
            }
            else{
                s.Current_Pipeline__c = 0;
            }   
                
           
        
        
        
                profMap.put(s.id,s);
            }
        
        //system.debug(' profMap in helper returned '+profMap);
        return profMap;         
        /*}
        catch(Exception ex){
            //system.debug(' error occured '+ex.getMessage());
            FunnelTriggerBatchHelper.sendErrorMail('fetchSalesProfileUpdatedMapFromOwners'+ex.getMessage()+' '+ex.getStackTraceString()+' '+ex.getLineNumber());
            return null;     
        }*/
    }
    
    public Static Map<Id,Sales_Rep_Profile__c> fetchSalesProfileUpdatedMapFromLeadOwners(Set<Id> ownerIds){
        
        Fyear =  FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        Fisyear = Fyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        
        
        if(FunnelTriggerBatchHelper.histDataBatch){
            triggerDate = FunnelTriggerBatchHelper.histDateVal;
            triggerDate  =  triggerDate.addDays(1);
            triggerDateminus1 = FunnelTriggerBatchHelper.histDateVal;
            Cyear =  triggerDate ;
            
        }        
        else if( FunnelTriggerBatchHelper.histDateVal != null){
            triggerDate = FunnelTriggerBatchHelper.histDateVal;
            triggerDate  =  triggerDate.addDays(1);
            triggerDateminus1 = FunnelTriggerBatchHelper.histDateVal;
            Cyear =  triggerDate ;
        }
        else{
            triggerDate = Date.today();
            triggerDate  =  triggerDate.addDays(1);
            triggerDateminus1 = Date.Today();
            Cyear =  triggerDate ;
        }
        
        System.debug('Cyear '+Cyear );
          
        Cisyear = Cyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
       
        Fyeard =  Fisyear.substring(0,10);
        Cyeard =  Cisyear.substring(0,10);
                 
        Q0 =  Fyear ;
        Q1 =  Fyear.addMonths(3);
        Q2 =  Q1.addMonths(3);
        Q3 =  Q2.addMonths(3);
        Q4 =  Q3.addMonths(3);
        
        if( (Q0 <=  Cyear) && (Cyear <= Q1)){
        
            startDate=  Q0;
            endDate =  Q1;
            Quarter =  'Q1';
                      
        }else if((Q1 <=  Cyear) && (Cyear <= Q2)){
        
            startDate=  Q1;
            endDate =  Q2;
            Quarter =  'Q2';
            
        }else if((Q2 <=  Cyear) && (Cyear <= Q3)){
        
            startDate=  Q2;
            endDate =  Q3;
            Quarter =  'Q3';
            
        }else if((Q3 <=  Cyear) && (Cyear <= Q4)){
        
            startDate=  Q3;
            endDate =  Q4;
            Quarter =  'Q4';
        
        }  
       
       if( endDate !=  null && Cyear.Monthgmt() ==  endDate.Monthgmt()-1){
           quat =  true;
       }
       
        startDates =  startDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        endDates =  endDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
        
        Integer yr = Cyear.yearGmt();
        Integer mn = Cyear.monthGmt();
        
        
        
        dateTime dt = triggerDateminus1 ;
        Integer yrtm1 = dt.yearGmt();
        Integer mntm1 = dt.monthGmt();
        
        startDateMonth =  Datetime.newInstance(yrtm1 ,mntm1 ,1);
        endDateMonth =  Datetime.newInstance(yr,mn,Date.daysInMonth(yr,mn));                 
        
        Integer offset = UserInfo.getTimezone().getOffset(startDateMonth);
        
        startDateMonth = startDateMonth.addSeconds(offset/1000);
        endDateMonth = endDateMonth.addSeconds(offset/1000);
        
        startDateMonths =  startDateMonth.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        endDateMonths =  endDateMonth.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
        
        startDateMonthsd =  startDateMonths.substring(0, 10);
        endDateMonthsd =  endDateMonths.substring(0, 10);
        
        endDate12Month =  Cyear;
        startDate12Month =   datetime.newInstance(dt.yearGmt()-1 , dt.monthGmt()+1, 1);
        startDate12Month =   startDate12Month.addSeconds(offset/1000);      
        
        startDate12Months =  startDate12Month.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        endDate12Months =  endDate12Month.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
        
        startDate12Monthsd =  startDate12Months.substring(0, 10);
        endDate12Monthsd =  endDate12Months.substring(0, 10);
        
        startd =  startDates.substring(0, 10);
        endd =  endDates.substring(0, 10);
        Fs =  Fisyear.substring(0, 10);
        Cs=  Cyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        Cs =  cs.substring(0, 10);
        
                    
        
        //Map to store the sales profiles to be updated
        Map<id, Sales_Rep_Profile__c> profMap = new Map<id, Sales_Rep_Profile__c>();
        
        //Map to store the user id and the corresponding sales profile id
        Map<Id,Id> ownerSalesReps = new Map<Id,Id>();
        
        List<Sales_Rep_Profile__c> salesReps = [SELECT id,User_Record_Name__c FROM Sales_Rep_Profile__c WHERE User_Record_Name__c IN :ownerIds];
        
        for(Sales_Rep_Profile__c sr: salesReps ){
            ownerSalesReps.put(sr.User_Record_Name__c,sr.id);    
        }
        
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
        
                        
                        
        if(ownerString != null && ownerString.length() > 0)
            ownerString = ownerString.subString(0,(ownerString.length() - 1));
                    
         Map<Id,Integer> leadCountMapfy =  new Map<Id,Integer>();
         
        String SOQLfy =  'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+ownerString+') AND CreatedDate >= '+Fisyear+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId';
        //System.debug('YTD-->'+'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+ownerString+') AND CreatedDate >= '+Fisyear+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId'); 
        List<AggregateResult> leadAggrListfy =  database.query(SOQLfy);

        for(AggregateResult ar: leadAggrListfy){
            leadCountMapfy.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        
        Map<Id,Integer> leadCountMapmn =  new Map<Id,Integer>();
         
        String SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+ownerString+') AND CreatedDate >= '+startDateMonths+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId';
        //System.debug('Mn-->'+'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+ownerString+') AND CreatedDate >= '+startDateMonths+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId'); 
        List<AggregateResult> leadAggrListmn =  database.query(SOQLmn);

        for(AggregateResult ar: leadAggrListmn){
            leadCountMapmn.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        
        Map<Id,Integer> leadCountMapq =  new Map<Id,Integer>();
         
        String SOQLq =  'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+ownerString+') AND CreatedDate >= '+startDates+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId';
        //System.debug('Q -->'+'SELECT OwnerId o, Count(id) c FROM Lead WHERE OwnerId IN ('+ownerString+') AND CreatedDate >= '+startDates+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId'); 
        List<AggregateResult> leadAggrListq =  database.query(SOQLq);

        for(AggregateResult ar: leadAggrListq){
            leadCountMapq.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        
        
         
        //Fetch Lead converted
       // System.debug('Mnc -->'+'SELECT ownerId sr , COUNT(id) cq From Lead WHERE OwnerId IN ('+ownerString+') AND ConvertedDate >= '+startDateMonthsd +' AND ConvertedDate < '+Cyeard +' AND isconverted =  true GROUP BY OwnerId');
        List<AggregateResult> monthlyLeadConverted = database.query('SELECT ownerId sr , COUNT(id) cq From Lead WHERE OwnerId IN ('+ownerString+') AND ConvertedDate >= '+startDateMonthsd +' AND ConvertedDate < '+Cyeard +' AND isconverted =  true GROUP BY OwnerId');
        Map<Id,Integer> repLeadConvertedM = new Map<Id,Integer>();
        for(AggregateResult ar: monthlyLeadConverted ){
            if(ar.get('sr') != null)
                repLeadConvertedM.put((Id)ar.get('sr'),(Integer)ar.get('cq'));
        }
        
        //System.debug('Qc -->'+'SELECT ownerId sr , COUNT(id) cq From Lead WHERE OwnerId IN ('+ownerString+') AND ConvertedDate >= '+startd +' AND ConvertedDate < '+Cyeard +' AND isconverted =  true GROUP BY OwnerId');
        List<AggregateResult> qLeadConverted = database.query('SELECT ownerId sr , COUNT(id) cq From Lead WHERE OwnerId IN ('+ownerString+') AND ConvertedDate >= '+startd +' AND ConvertedDate < '+Cyeard +' AND isconverted =  true GROUP BY OwnerId');
        Map<Id,Integer> repLeadConvertedQ = new Map<Id,Integer>();
        for(AggregateResult ar: qLeadConverted ){
            if(ar.get('sr') != null)
                repLeadConvertedQ .put((Id)ar.get('sr'),(Integer)ar.get('cq'));
        }
        
        //System.debug('YTDc -->'+'SELECT ownerId sr , COUNT(id) cq From Lead WHERE OwnerId IN ('+ownerString+') AND ConvertedDate >= '+Fyeard  +' AND ConvertedDate < '+Cyeard +' AND isconverted =  true GROUP BY OwnerId');
        
        List<AggregateResult> yLeadConverted = database.query('SELECT ownerId sr , COUNT(id) cq From Lead WHERE OwnerId IN ('+ownerString+') AND ConvertedDate >= '+Fyeard  +' AND ConvertedDate < '+Cyeard +' AND isconverted =  true GROUP BY OwnerId');
        Map<Id,Integer> repLeadConvertedY = new Map<Id,Integer>();
        for(AggregateResult ar: yLeadConverted ){
            if(ar.get('sr') != null)
                repLeadConvertedY .put((Id)ar.get('sr'),(Integer)ar.get('cq'));
        }
        
        //
        
        for(Sales_Rep_Profile__c s: salesReps){
            
            
            if(leadCountMapmn.get(s.User_Record_Name__c) != null){
                s.Monthly_Lead_Added__c = leadCountMapmn.get(s.User_Record_Name__c);
            }
            else{
                s.Monthly_Lead_Added__c = 0;
            }
            
            if(leadCountMapq.get(s.User_Record_Name__c) != null){
                s.Quarterly_Lead_Added__c = leadCountMapq.get(s.User_Record_Name__c);
            }
            else{
                s.Quarterly_Lead_Added__c = 0;
            }
            
            if(leadCountMapfy.get(s.User_Record_Name__c) != null){
                s.YTD_Leads_Added__c = leadCountMapfy.get(s.User_Record_Name__c);
            }
            else{
                s.YTD_Leads_Added__c = 0;
            }
            
            if(repLeadConvertedM.get(s.User_Record_Name__c) != null){
                s.Monthly_lead_converted__c= repLeadConvertedM.get(s.User_Record_Name__c);
            }
            else{
                s.Monthly_lead_converted__c= 0;
            }
            
            if(repLeadConvertedQ.get(s.User_Record_Name__c) != null){
                s.Quarterly_Lead_Converted__c= repLeadConvertedQ.get(s.User_Record_Name__c);
            }
            else{
                s.Quarterly_Lead_Converted__c= 0;
            }
            
            if(repLeadConvertedY.get(s.User_Record_Name__c) != null){
                s.YTD_Lead_Converted__c= repLeadConvertedY.get(s.User_Record_Name__c);
            }
            else{
                s.YTD_Lead_Converted__c= 0;
            }
            profMap.put(s.id,s);    
                 
        }
        
        /*
        for(AggregateResult ar: listCreatedLeads){
            
            //Populate the fields on the sales profile related to closed opportunities
            Sales_Rep_Profile__c s = new Sales_Rep_Profile__c(); 
            s.id = ownerSalesReps.get((Id)ar.get('sr'));
            s.YTD_Leads_Added__c = (Integer)ar.get('c'); 
            
            //Update Quarterly leads added field 
            if(repCountQuarLeads.get((Id)ar.get('sr')) != null){
                s.Quarterly_Lead_Added__c = repCountQuarLeads.get((Id)ar.get('sr'));
            }
            
            //Update Monthly leads added field 
            if(repCountMonCreatedLeads.get((Id)ar.get('sr')) != null){
                s.Monthly_Lead_Added__c = repCountMonCreatedLeads.get((Id)ar.get('sr'));
            }
                        
            profMap.put(s.id,s);     
            //system.debug(' profMap in helper '+profMap);     
        }
        */
        
        //Fetch the below fields
        /*
        YTD opportunities added
        Quarterly opportunities added
        Monthly opportunities added
        
        YTD leads added
        Quarterly leads added
        Monthly leads added
        //Daily leads added
        
        Quarterly Revenue
        Monthly Revenue
        */
        
        //system.debug(' currentFiscalYear '+currentFiscalYear);
        
        return profMap;         
    
    }
    
    /*new*/
    public Static void updateSalesProfsNotAssociatedWithAnyOpptyUsingOwner(Set<Id> ownerIds, Map<Id,Sales_Rep_Profile__c> profMap){
        //try{ 
        Set<Id> salesRepIds = new Set<Id>();
        
        List<Sales_Rep_Profile__c> salesReps = [SELECT id, User_Record_Name__c FROM Sales_Rep_Profile__c WHERE User_Record_Name__c IN :ownerIds];
        
        for(Sales_Rep_Profile__c sr: salesReps ){
            
            salesRepIds.add(sr.id);    
        }
                
        //Remove the ids that have already been added to the map that is being updated
        salesRepIds.removeAll(profMap.keySet());
        
        //The current active opportunities field should be updated to 0
        for(Id i: salesRepIds){
            Sales_Rep_Profile__c s = new Sales_Rep_Profile__c();
            s.id = i;
            s.Current_Active_Opportunities__c = 0; 
            profMap.put(s.id,s);
        }  
        /*}catch(Exception ex){
            //system.debug(' error occured '+ex.getMessage());
            FunnelTriggerBatchHelper.sendErrorMail('updateSalesProfsNotAssociatedWithAnyOpptyUsingOwner'+ex.getMessage()+' '+ex.getStackTraceString()+' '+ex.getLineNumber());
        }*/         
    }            
    
    /*
    public Static void updateSalesProfsNotAssociatedWithAnyLeadUsingOwner(Set<Id> ownerIds, Map<Id,Sales_Rep_Profile__c> profMap){
        
        Set<Id> salesRepIds = new Set<Id>();
        
        List<Sales_Rep_Profile__c> salesReps = [SELECT id, User_Record_Name__c FROM Sales_Rep_Profile__c WHERE User_Record_Name__c IN :ownerIds];
        
        for(Sales_Rep_Profile__c sr: salesReps ){
            
            salesRepIds.add(sr.id);    
        }
                
        //Remove the ids that have already been added to the map that is being updated
        salesRepIds.removeAll(profMap.keySet());
        
        //The current active opportunities field should be updated to 0
        for(Id i: salesRepIds){
            Sales_Rep_Profile__c s = new Sales_Rep_Profile__c();
            s.id = i;
            s.YTD_Leads_Added__c = 0; 
            profMap.put(s.id,s);
        }            
    }*/
    
    /*new*/
    
    
    /*  This Method update the counter when a Qulifiled opp is created  */
    public static void updateSalesProfsCounterQO(Map<id,Opportunity> oppNewmap , List<Opportunity> triggernew){
         system.debug('inside updateSalesProfsCounterQO');
         system.debug('Quries Limits Start of updateSalesProfsCounterQO'+Limits.getQueries());  
         
         Decimal userprob = 10;
        List<Application_Setting__c> prob = [SELECT Id, Probability__c FROM Application_Setting__c limit 1];
        if(prob != null && prob.size()>0){
            userprob = prob[0].Probability__c;
        }
        
        /*Custom metadata code*/
        createRecordTypeMap(); 
         
        set<id> srpid = new set<id>();
        for(Opportunity o : triggernew){
            srpid.add(o.ownerid);
        }
        
        system.debug('srpid'+srpid);
        
        list<Sales_Rep_Profile__c> splist = [select id,User_Record_Name__c,Monthly_QO_added__c,Quarterly_QO_added__c,Ytd_QO_added__c from Sales_Rep_Profile__c where User_Record_Name__c IN : srpid];
        map<id,Sales_Rep_Profile__c> splistmap = new map<id,Sales_Rep_Profile__c>();
        
        system.debug('Quries Limits after splist '+Limits.getQueries());   
        
        for(Sales_Rep_Profile__c s : splist){
            splistmap.put(s.User_Record_Name__c, s);
        }
        list<Sales_Rep_Profile__c> updatesplist = new list<Sales_Rep_Profile__c>();
        Map<id,Sales_Rep_Profile__c> updateMap = new Map<id,Sales_Rep_Profile__c>();
        Sales_Rep_Profile__c sp = new Sales_Rep_Profile__c();
        
          for(Opportunity o : triggernew){
              Boolean custMdPresent = false;
                if((lstCustMd == null || lstCustMd.isEmpty() ) || (recTypeFldMap.get(recTypeIdNameMap.get((String)o.get('RecordTypeId'))) != null && recTypeFldMap.get(recTypeIdNameMap.get((String)o.get('RecordTypeId'))).size()>0 )){
                    custMdPresent = true;
                }
                if(custMdPresent ){
                    system.debug('triggernew Name'+o.name+ 'Probability '+oppNewmap.get(o.id).Probability );
                    
                    if(oppNewmap.get(o.id).Probability >= userprob){
                    
                        system.debug('triggernew Name inside'+o.name);
                        
                       if(updateMap.containsKey(o.ownerid)){
                            sp = updateMap.get(o.ownerid);                                                
                        }
                        else{
                            sp = splistmap.get(o.ownerid);                                            
                        } 
                        system.debug('triggernew sp '+sp);
                        if(sp != null){
                            
                            if(sp.Monthly_QO_added__c != null){
                              sp.Monthly_QO_added__c = sp.Monthly_QO_added__c+ 1;
                            }else{
                              sp.Monthly_QO_added__c =  1;
                            }
                            
                            if(sp.Quarterly_QO_added__c != null){
                              sp.Quarterly_QO_added__c = sp.Quarterly_QO_added__c+ 1;
                            }else{
                              sp.Quarterly_QO_added__c =  1;
                            }
                            
                            if(sp.Ytd_QO_added__c != null){
                              sp.Ytd_QO_added__c = sp.Ytd_QO_added__c+ 1;
                            }else{
                              sp.Ytd_QO_added__c =  1;
                            }
                            
                            updateMap.put(sp.id,sp); 
                            system.debug('updateMap'+updateMap);
                        }                   
                    }
                }
        }
        FunnelTriggerBatchHelper.doNotCallSPTrigger = true; 
        update updateMap.values();  
        FunnelTriggerBatchHelper.doNotCallSPTrigger = false;
    }
    
    /*
        This Method update the counter on the salesprofile when the QO 
        is moved out of the month or quarter and QO moved in the current month or quarter 
    */
        public static List<Client_custom_field_mapping__mdt> lstCustMd ;
        public static List<RecordType> recTypes;
        public static Map<String,List<String>>  recTypeFldMap;
        public static Map<String,String> recTypeNameIdMap;
        public static Map<String,String> recTypeIdNameMap ;
        public static Map<id,String> recTypeIdActionMap;
        public static Map<String,String> recTypeActionMap = new Map<String,String>(); 
        public static Map<String, Decimal> conversionRates = new Map<String, Decimal>();
        public static Boolean multiCurrencyEnabled;
        
    public static Decimal amountValue( opportunity op){
        decimal totAmt = 0;
        
        if(lstCustMd != null && lstCustMd.size() > 0){
             string recId = (String)op.get('RecordTypeId');
             List<String> flds = recTypeFldMap.get(recTypeIdNameMap.get(recId));
          //   if(flds != null && flds.size() > 0){
                 if(recTypeIdActionMap.get(recId) == 'Add'){
                                                                
                        if(op.amount != null)
                            totAmt  += op.amount;
                    }
                        
                    for(Integer i = 0; i < flds.size(); i++){
                        if(op.get(flds[i]) != null)
                            totAmt += (Decimal)op.get(flds[i]);       
                    }
          //      }      
        }else if(op.amount != null){
            totAmt = op.amount;
        }
        
        
        if(multiCurrencyEnabled && totAmt > 0){
            String currencyCode = (String)op.get('CurrencyIsoCode');
            String cr = 'CurrencyIsoCode';    
            totAmt = totAmt / conversionRates.get(currencyCode);
        }   
           // //system.debug('totAmt'+totAmt);
            return totAmt;
    }
    
    public static void createConvertionRateMap(){
         
            string isoCode;
            Decimal convertionRate;
            String s;
            
            s = 'SELECT Id, isoCode, Conversionrate, nextStartDate, startDate FROM DatedConversionRate ORDER BY NextStartDate DESC';
            List<Sobject> rates =  database.query(s);
            for(Sobject r: rates){
                isoCode = (String)r.get('isocode');
                convertionRate = (Decimal)r.get('Conversionrate');
                
                if(!conversionRates.containsKey(isoCode )){
                    conversionRates.put(isoCode,convertionRate);
                }
            }
            
            s = 'SELECT Id, isoCode, Conversionrate FROM CurrencyType';
            List<Sobject> crates  =  database.query(s);
            
            for(Sobject r: crates){
                isoCode = (String)r.get('isocode');
                convertionRate = (Decimal)r.get('Conversionrate');
                
                if(!conversionRates.containsKey(isoCode)){
                    conversionRates.put(isoCode,convertionRate);
                }
           }   
         
    }
    
    public Static void updateSalesProfsCounter(Map<id,Opportunity> oppNewmap , Map<id,Opportunity> oppOldmap , List<Opportunity> triggernew){
        
       createRecordTypeMap();
       
        multiCurrencyEnabled = Schema.getGlobalDescribe().containsKey('CurrencyType');
        if(multiCurrencyEnabled){
            createConvertionRateMap();
        }
        
        Decimal userprob = 0;
        List<Application_Setting__c> prob = [SELECT Id, Probability__c FROM Application_Setting__c limit 1];
        if(prob != null && prob.size()>0){
            userprob = prob[0].Probability__c;
        }
        
        date presentDate  = date.today();
        //system.debug('close rate trigger ');
        date endDate = date.newInstance(presentDate.year(), presentDate.month(),Date.daysInMonth(presentDate.year(), presentDate.month()));
        ////system.debug('endDate '+endDate);
        
        system.debug('Limits  before fetching FS trigger'+Limits.getQueries());
        
        date Fyear = getFiscalYearDate('Current_Year');
        
        system.debug('Limits  after fetching FS trigger'+Limits.getQueries());
        
        date Q0 = Fyear ;
        date Q1 = Fyear.addMonths(3);
        date Q2 = Q1.addMonths(3);
        date Q3 = Q2.addMonths(3);
        date Q4 = Q3.addMonths(3);
        date endDateq;
        if( (Q0 <= presentDate) && (presentDate < Q1)){
              endDateq = Q1;
        }else if((Q1 <= presentDate) && (presentDate < Q2)){
              endDateq = Q2;
            
        }else if((Q2 <= presentDate) && (presentDate < Q3)){
              endDateq = Q3;
        
        }else if((Q3 <= presentDate) && (presentDate < Q4)){
              endDateq = Q4;
        
        }  
        set<id> srpid = new set<id>();
        for(Opportunity o : triggernew){
            srpid.add(o.ownerid);
        }
        list<Sales_Rep_Profile__c> splist = [select id,User_Record_Name__c,Monthly_QO_added__c,Quarterly_QO_added__c,Ytd_QO_added__c,Monthly_lost_QO_Amt__c,Quarterly_lost_QO_Amt__c,Ytd_lost_QO_Amt__c,Monthly_lost_QO__c,Quarterly_lost_QO__c,Ytd_lost_QO__c,Close_rate_monthly_opp_count__c ,Close_rate_monthly_opp_amount__c,Close_rate_YTD_opp_count__c,Close_rate_YTD_opp_amount__c,Close_rate_Quarterly_opp_count__c,Close_rate_Quarterly_opp_amount__c  from Sales_Rep_Profile__c where User_Record_Name__c IN : srpid];
        map<id,Sales_Rep_Profile__c> splistmap = new map<id,Sales_Rep_Profile__c>();
        
        for(Sales_Rep_Profile__c s : splist){
            splistmap.put(s.User_Record_Name__c, s);
        }
        list<Sales_Rep_Profile__c> updatesplist = new list<Sales_Rep_Profile__c>();
        Map<id,Sales_Rep_Profile__c> updateMap = new Map<id,Sales_Rep_Profile__c>();
        Sales_Rep_Profile__c sp = new Sales_Rep_Profile__c();
        
        List<String> fldList1 = new List<String>{prefix+'close_rate_monthly_opp_count__c',prefix+'close_rate_monthly_opp_amount__c',prefix+'close_rate_ytd_opp_count__c',prefix+'close_rate_ytd_opp_amount__c',prefix+'close_rate_quarterly_opp_count__c',prefix+'close_rate_quarterly_opp_amount__c'};
            
        Boolean updateAccess = true;
        
        /*            
        Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile__c').getDescribe().fields.getMap();
        
        for(String fldName: fldList1){
            if(!fieldMap1.get(fldName).getDescribe().isUpdateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              updateAccess = false;
            }                           
        }*/ 
        
        if(updateAccess){
            
            
            
            
            for(Opportunity o : triggernew){
                 //sp = new Sales_Rep_Profile__c();
                 
               /* if((oppOldmap != null && oppNewmap != null && ( oppOldmap.get(o.id) != null && oppOldmap.get(o.id).CloseDate != oppNewmap.get(o.id).CloseDate) && (oppNewmap.get(o.id) != null && oppNewmap.get(o.id).CloseDate > endDate)) 
                    || (oppOldmap != null && oppNewmap != null && (oppOldmap != null && oppOldmap.get(o.id) != null && oppOldmap.get(o.id).IsClosed == false && oppNewmap.get(o.id).IsClosed == true && oppNewmap.get(o.id).IsWon  == false)) 
                    || (oppOldmap != null && oppOldmap.get(o.id) != null && oppOldmap.get(o.id).Probability < userprob && oppNewmap.get(o.id).Probability >= userprob ) 
                    || (oppOldmap != null && oppNewmap != null && (oppOldmap.get(o.id) != null && oppOldmap.get(o.id).CloseDate != oppNewmap.get(o.id).CloseDate) && (oppNewmap.get(o.id) != null && oppNewmap.get(o.id).CloseDate < endDateq) && oppNewmap.get(o.id).Probability >= userprob) ){
                    //system.debug(' inside 1st  if----> > endDate'+endDate);
                */
                Boolean custMdPresent = false;
                if((lstCustMd == null || lstCustMd.isEmpty() ) || (recTypeFldMap.get(recTypeIdNameMap.get((String)o.get('RecordTypeId'))) != null && recTypeFldMap.get(recTypeIdNameMap.get((String)o.get('RecordTypeId'))).size()>0 )){
                    custMdPresent = true;
                }
                if(custMdPresent ){
                                 
                        if(updateMap.containsKey(o.ownerid)){
                            sp = updateMap.get(sp.id);                                                
                        }
                        else{
                            sp = splistmap.get(o.ownerid);                                            
                        } 
                        
                        if(sp != null){
                        
                                    /* When QO is moved out*/
                                    
                            if(oppOldmap.get(o.id).CloseDate != oppNewmap.get(o.id).CloseDate && oppNewmap.get(o.id).CloseDate > endDate && oppNewmap.get(o.id).Probability  >= userprob  ){
                                    //system.debug(' inside if opp moved---->endDate'+endDate);
                                   
                                if(sp.Close_rate_monthly_opp_count__c != null){
                                  sp.Close_rate_monthly_opp_count__c = sp.Close_rate_monthly_opp_count__c+1;
                                }else{
                                  sp.Close_rate_monthly_opp_count__c = 1;
                                }
                              
                                if(sp.Close_rate_monthly_opp_amount__c != null){
                                  sp.Close_rate_monthly_opp_amount__c = sp.Close_rate_monthly_opp_amount__c+ amountValue(o);
                                }else{
                                  sp.Close_rate_monthly_opp_amount__c =  amountValue(o);
                                }
                                
                                if(sp.Close_rate_YTD_opp_count__c != null){
                                  sp.Close_rate_YTD_opp_count__c = sp.Close_rate_YTD_opp_count__c+1;
                                }else{
                                  sp.Close_rate_YTD_opp_count__c = 1;
                                }
                              
                                if(sp.Close_rate_YTD_opp_amount__c != null){
                                  sp.Close_rate_YTD_opp_amount__c = sp.Close_rate_YTD_opp_amount__c+ amountValue(o);
                                }else{
                                  sp.Close_rate_YTD_opp_amount__c =  amountValue(o);
                                }
                              
                              if( oppNewmap.get(o.id).CloseDate >= endDateq ){
                                  if(sp.Close_rate_Quarterly_opp_count__c != null){
                                      sp.Close_rate_Quarterly_opp_count__c = sp.Close_rate_Quarterly_opp_count__c+ 1;
                                  }else{
                                     sp.Close_rate_Quarterly_opp_count__c =  1;
                                  } 
                                  if(sp.Close_rate_Quarterly_opp_amount__c != null){
                                      sp.Close_rate_Quarterly_opp_amount__c = sp.Close_rate_Quarterly_opp_amount__c+ amountValue(o);
                                  }else{
                                      sp.Close_rate_Quarterly_opp_amount__c =  amountValue(o);
                                  } 
                                }  
                                
                            }
                            /* When QO is Lost*/
                            if( oppOldmap.get(o.id).IsClosed == false && oppNewmap.get(o.id).IsClosed == true && oppNewmap.get(o.id).IsWon  == false && oppOldmap.get(o.id).Probability  >= userprob ){
                                //system.debug(' inside  if opp lost---->');
                                if(sp.Monthly_lost_QO__c != null){
                                  sp.Monthly_lost_QO__c = sp.Monthly_lost_QO__c+1;
                                }else{
                                  sp.Monthly_lost_QO__c = 1;
                                }
                                if(sp.Quarterly_lost_QO__c != null){
                                  sp.Quarterly_lost_QO__c = sp.Quarterly_lost_QO__c+1;
                                }else{
                                  sp.Quarterly_lost_QO__c = 1;
                                }
                                if(sp.Ytd_lost_QO__c != null){
                                  sp.Ytd_lost_QO__c = sp.Ytd_lost_QO__c+1;
                                }else{
                                  sp.Ytd_lost_QO__c = 1;
                                }
                                if(sp.Monthly_lost_QO_Amt__c != null){
                                  sp.Monthly_lost_QO_Amt__c = sp.Monthly_lost_QO_Amt__c+ amountValue(o);
                                }else{
                                  sp.Monthly_lost_QO_Amt__c = amountValue(o);
                                }
                                if(sp.Quarterly_lost_QO_Amt__c != null){
                                  sp.Quarterly_lost_QO_Amt__c = sp.Quarterly_lost_QO_Amt__c+ amountValue(o);
                                }else{
                                  sp.Quarterly_lost_QO_Amt__c =  amountValue(o);
                                }
                                if(sp.Ytd_lost_QO_Amt__c != null){
                                  sp.Ytd_lost_QO_Amt__c = sp.Ytd_lost_QO_Amt__c+ amountValue(o);
                                }else{
                                  sp.Ytd_lost_QO_Amt__c =  amountValue(o);
                                }
                                 
                            }
                            /* When opp become QO  */
                            if(oppOldmap.get(o.id).Probability < userprob && oppNewmap.get(o.id).Probability >= userprob ){
                                if(sp.Monthly_QO_added__c != null){
                                    sp.Monthly_QO_added__c = sp.Monthly_QO_added__c+ 1;
                                }else{
                                    sp.Monthly_QO_added__c =  1;
                                }
                            
                                if(sp.Quarterly_QO_added__c != null){
                                    sp.Quarterly_QO_added__c = sp.Quarterly_QO_added__c+ 1;
                                }else{
                                    sp.Quarterly_QO_added__c =  1;
                                }
                            
                                if(sp.Ytd_QO_added__c != null){
                                    sp.Ytd_QO_added__c = sp.Ytd_QO_added__c+ 1;
                                }else{
                                    sp.Ytd_QO_added__c =  1;
                                }
                            }
                            /* When QO is moved in*/
                             //system.debug('->-M'+ oppNewmap.get(o.id).CloseDate +'<='+ endDate +' &&'+ oppOldmap.get(o.id).CloseDate +' >'+ endDate);
                             //system.debug('->-Q'+oppNewmap.get(o.id).CloseDate +'<'+ endDateq +' &&'+  oppOldmap.get(o.id).CloseDate +'>='+ endDateq);
                            
                            if(oppOldmap.get(o.id).CloseDate != oppNewmap.get(o.id).CloseDate &&  oppNewmap.get(o.id).CloseDate < endDateq  && oppNewmap.get(o.id).Probability >= userprob ){
                                
                                if(oppNewmap.get(o.id).CloseDate <= endDate && oppOldmap.get(o.id).CloseDate > endDate ){
                                    if(sp.Monthly_QO_added__c != null){
                                        sp.Monthly_QO_added__c = sp.Monthly_QO_added__c+ 1;
                                    }else{
                                        sp.Monthly_QO_added__c =  1;
                                    }
                                    
                                    if(sp.Ytd_QO_added__c != null){
                                        sp.Ytd_QO_added__c = sp.Ytd_QO_added__c+ 1;
                                    }else{
                                        sp.Ytd_QO_added__c =  1;
                                    }
                                }
                                if(oppNewmap.get(o.id).CloseDate < endDateq && oppOldmap.get(o.id).CloseDate >= endDateq ){
                                    
                                    if(sp.Quarterly_QO_added__c != null){
                                        sp.Quarterly_QO_added__c = sp.Quarterly_QO_added__c+ 1;
                                    }else{
                                        sp.Quarterly_QO_added__c =  1;
                                    }
                                }
                            }
                      //updatesplist.add(sp); 
                      
                      updateMap.put(sp.id,sp);
                      
                    }
                }
           // }
                   
                  
            }
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
        }
        
        //if(Schema.sObjectType.Sales_Rep_Profile__c.isUpdateable()){
           // update updatesplist;
           FunnelTriggerBatchHelper.doNotCallSPTrigger = true; 
           update updateMap.values();  
           FunnelTriggerBatchHelper.doNotCallSPTrigger = false; 
        //}
        /*else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
        }*/
    }
    
    public static void updateYTDQuotaOnCert(Set<Id> spIds){
        
        List<Certification__c> crReplist = new List<Certification__c>();

        //For the reps
        List<Certification__c> certRecs = [SELECT Sales_Rep_Profile__r.YTD_Quota_Percentage__c  FROM Certification__c WHERE Sales_Rep_Profile__c IN :spIds AND Sales_rep_profile__r.Active__c = TRUE];
        for(Certification__c c:certRecs){
            c.YTD_Quota_Percentage__c  = c.Sales_Rep_Profile__r.YTD_Quota_Percentage__c;
            crReplist.add(c);
        }
        
        //system.debug(' cert updated '+crReplist);
        //if(Schema.getGlobalDescribe().get(prefix+'Certification__c').getDescribe().isUpdateable()){ 
            update crReplist;
        //}
    }
    
    public static void calculateAggregateScoreForManagers(Set<Id> spIds){
                        
        //For manager aggregates
        
        List<Certification__c> crmnglist = new List<Certification__c>();
        
        List<AggregateResult> levels = [SELECT Company_Level__r.Level_Value__c v FROM Sales_Profile_Company_Level_Junction__c WHERE Sales_Rep_Profile__c IN :spIds GROUP BY Company_Level__r.Level_Value__c];
        
        List<String> levelVals = new List<String>();                
        
        for(AggregateResult ar: levels){
            levelVals.add((String)ar.get('v'));
        }
        
        //system.debug(' levelVals '+levelVals);
        
        List<AggregateResult> scoreAggr = [SELECT Company_Level__r.Level_Value__c v,AVG(Sales_Rep_Profile__r.YTD_Quota_Percentage__c) ytd FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levelVals AND Sales_Rep_Profile__r.Annual_Quota_Amount__c > 0 GROUP BY Company_Level__r.Level_Value__c];
        
        Map<String,Decimal> mapValYtd = new Map<String,Decimal>();
        
        for(AggregateResult ar: scoreAggr){
            mapValYtd.put((String)ar.get('v'),(Decimal)ar.get('ytd'));
        }
        
        //system.debug(' mapValYtd '+mapValYtd);
        
        List<Company_Level__c> cls = [SELECT id,Certification__c, Level_Value__c FROM Company_Level__c WHERE Level_Value__c IN :levelVals];        
                
        for(Company_Level__c cl: cls){ 
            if(cl.Certification__c != null){
                Certification__c updateMng = new Certification__c(); 
                updateMng.id = cl.Certification__c;
                updateMng.YTD_Quota_Percentage__c = mapValYtd.get(cl.Level_Value__c);
                 
                crmnglist.add(updateMng);  
            }    
        }
        
        //system.debug(' crmnglist '+crmnglist);                        
        
        //if(Schema.getGlobalDescribe().get(prefix+'Certification__c').getDescribe().isUpdateable()){ 
            update crmnglist;
        //}            
        
    }
     public static void sendErrorMail(String errorMessage){              
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String>();
        
        Admin_Email__mdt[] adminEmails = [SELECT Email_Address__c FROM Admin_Email__mdt LIMIT 20];

        for (Admin_Email__mdt em: adminEmails) {
            toAddresses.add(em.Email_Address__c);    
        }
        if(toAddresses.size() > 0){
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Apex error message');
            mail.setSubject('Error from Org : ' + UserInfo.getOrganizationName());
            mail.setPlainTextBody(errorMessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
   }
    @future
    public static void updateSalesProfsInactive(List<Id> recIds){
        
        List<Sales_Rep_Profile__c> profs = [SELECT id,Active__c FROM Sales_Rep_Profile__c WHERE User_Record_Name__c IN :recIds];  
        
        List<Sales_Rep_Profile__c> updatedProfs = new List<Sales_Rep_Profile__c>();
        
        for(Sales_Rep_Profile__c s:profs){
            if(s.Active__c){
                s.Active__c = false;
                updatedProfs.add(s);
            }
        }
        
        if(updatedProfs.size() > 0)
            update updatedProfs; 
    }
    
    @future
    public static void updateSalesProfsActive(List<Id> recIds){
        
        List<Sales_Rep_Profile__c> profs = [SELECT id,Active__c FROM Sales_Rep_Profile__c WHERE User_Record_Name__c IN :recIds];  
        
        List<Sales_Rep_Profile__c> updatedProfs = new List<Sales_Rep_Profile__c>();
        
        for(Sales_Rep_Profile__c s:profs){
            if(!s.Active__c){
                s.Active__c = true;
                updatedProfs.add(s);
            }
        }
        
        if(updatedProfs.size() > 0)
            update updatedProfs; 
    }
    
    @future
    public static void createSalesProfs(List<Id> recIds){
        
        List<User> userRecs = [SELECT id,name,Username,ManagerId FROM User WHERE id IN :recIds];
        
        Map<id,User> usersMap = new Map<id,User>();
        for(User u: userRecs){
            usersMap.put(u.id,u);
        }
                
        List<Sales_Rep_Profile__c> sReps = [select id, User_Record_Name__c from Sales_Rep_Profile__c limit 5000];    
    
        Map<Id,Id> userProfMap = new Map<Id,Id>();
        
        for(Sales_Rep_Profile__c s: sReps){
            userProfMap.put(s.User_Record_Name__c,s.id);
        }
    
        List<Sales_Rep_Profile__c> newSReps = new List<Sales_Rep_Profile__c> ();

        for(Id i:recIds){            
            Sales_Rep_Profile__c s = new Sales_Rep_Profile__c();
            s.User_Record_Name__c = i;
            s.Name = usersMap.get(i).name;
            s.Active__c = true;
            if(usersMap.get(i) != null && usersMap.get(i).ManagerId != null && userProfMap.get(usersMap.get(i).ManagerId) != null){
                s.Sales_Manager__c = userProfMap.get(usersMap.get(i).ManagerId);
            }
            newSReps.add(s);
        }
        
        insert newSReps;
        //system.debug(' new reps '+newSReps);
    }
    
    @future
    public static void deleteJunctionRecords(Set<Id> recIds){
        
        List<Sales_Profile_Company_Level_Junction__c> juncs = [SELECT id FROM Sales_Profile_Company_Level_Junction__c WHERE id IN :recIds];  
        
        delete juncs; 
    }
    
    @future
    public static void sendEmail(Set<String> srpName){
                
        List<Funnel_Org_Wide_Address__mdt> owMd = [SELECT label FROM Funnel_Org_Wide_Address__mdt LIMIT 1];
        Id owEmailId;
        
        if(owMd != null && owMd.size() > 0){
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :owMd[0].label];
            if(owea != null && owea.size() > 0){
                owEmailId = owea[0].id;
            }
        }
        
        List<FM_Admins__mdt > ad= [SELECT label FROM FM_Admins__mdt LIMIT 100];
        List<String> sentTo = new List<String>();
        
        for(FM_Admins__mdt a : ad){
            sentTo.add(a.label);
        }
        
        String srpnameString = '';
        for(String s:srpname) {
           srpnameString += (srpnameString ==''?'':',')+s;
        }
                
        Messaging.SingleEmailMessage  mail = new Messaging.SingleEmailMessage();
        
        if(owEmailId != null) 
            mail.setOrgWideEmailAddressId(owEmailId);
        
        mail.setSubject('Sales Rep profile not created');
        //system.debug('srpname---'+srpname);
        String body;
        
        String headerURL = '';
        List<Application_Setting__c> prob = [SELECT Id, Header_Image__c FROM Application_Setting__c limit 1];
        if(prob != null && prob.size()>0){
          headerURL = prob[0].Header_Image__c;
        }
        
        body='For the following users create Sales profile :'+srpnameString ;
        mail.setHtmlBody('<html><body><img src="' +headerURL+ '"/><br/>'+body+'</body></html>');  
        
        if(sentTo != null && sentTo.size()>0) {
            mail.setToAddresses(sentTo);
            Messaging.sendEmail(new Messaging.Singleemailmessage[] {mail});
   
        }
    }

    public static void sendErrorMail(String errorMessage, String getStackTraceString){              
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String>();
        
        /*List<FM_Admins__mdt > ad= [SELECT label FROM FM_Admins__mdt LIMIT 5000];

        for(FM_Admins__mdt a : ad){
            toAddresses.add(a.label);
        }*/
        
        Admin_Email__mdt[] adminEmails = [SELECT Email_Address__c FROM Admin_Email__mdt LIMIT 20];

        for (Admin_Email__mdt em: adminEmails) {
            toAddresses.add(em.Email_Address__c);    
        }
                
        if(toAddresses.size() > 0){
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Apex error message');
            mail.setSubject('Error from Org : ' + UserInfo.getOrganizationName());
            mail.setPlainTextBody(' errorMessage '+errorMessage+' '+getStackTraceString);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    /* Custom metadata code */
        public static void createRecordTypeMap(){
            
            lstCustMd = new List<Client_custom_field_mapping__mdt>();
            lstCustMd = [SELECT Action__c, Custom_field_name__c, Standard_field_name__c, Record_type_name__c FROM Client_custom_field_mapping__mdt WHERE Standard_field_name__c = 'Amount'];
            
            //recTypes = new List<RecordType>();
            //recTypes = [SELECT id, Name FROM RecordType WHERE SobjectType='Opportunity'];
            
            recTypeFldMap = new Map<String,List<String>>();                                                                
            
            recTypeNameIdMap = new Map<String,String>();
             
            recTypeIdNameMap = new Map<String,String>();
            
            recTypeIdActionMap = new Map<id,String>();
          
            List<String> rectypeNames = new List<String>();                
            
            for(Client_custom_field_mapping__mdt cm: lstCustMd){
                rectypeNames.add(cm.Record_type_name__c);
            }
            
            List<RecordType> lstRT = [SELECT id, name FROM RecordType WHERE name IN :rectypeNames];
            for(RecordType r:lstRT ){
                recTypeNameIdMap.put(r.name,r.id);
                recTypeIdNameMap.put(r.id,r.name);
            }
            
            if(lstCustMd != null && lstCustMd.size() > 0){
                for(Client_custom_field_mapping__mdt cm: lstCustMd){
                    if(recTypeFldMap.containsKey(cm.Record_type_name__c)){
                        recTypeFldMap.get(cm.Record_type_name__c).add(cm.Custom_field_name__c);
                    }
                    else{
                        List<String> flds = new List<String>();
                        flds.add(cm.Custom_field_name__c);
                        recTypeFldMap.put(cm.Record_type_name__c,flds);
                        recTypeIdActionMap.put(recTypeNameIdMap.get(cm.Record_type_name__c),cm.Action__c);
                        recTypeActionMap.put(cm.Record_type_name__c,cm.Action__c);
                
                    }
                    
                    
                }
            }    
            
        }
        
            
    /* Custom metadata code */ 
    
    /* Custom metadata code */
    
    public static Map<id,Decimal> fetchRevenueNumbers(String SOQL_IDs, String startDate12Monthsd, String Cyeard, String scenario){
        
        Map<id,Decimal> ownerAmtMap = new Map<id,Decimal>();
            
        List<AggregateResult> oppAggrAmt = new List<AggregateResult>();                         
        
        String q;
                  
        if(lstCustMd != null && lstCustMd.size() > 0){                    
            
            for (String recTypeName : recTypeFldMap.keySet()){
                
                
                q = 'SELECT ownerId o ';
        
                if(recTypeActionMap.get(recTypeName) == 'Add'){
                    q += ', SUM(amount) s ';
                }
            
                List<String> flds = recTypeFldMap.get(recTypeName);
                
                for(Integer i = 0; i < flds.size(); i++){
                    q += ', SUM('+flds[i]+') '+flds[i];       
                }
                
                if(scenario == 'closed ytd')
                    q += ' FROM Opportunity WHERE OwnerId IN ('+SOQL_IDs+') AND CloseDate >=  '+ startDate12Monthsd+' AND CloseDate <=  '+ Cyeard;
                else
                    q += ' FROM Opportunity WHERE OwnerId IN ('+SOQL_IDs+') AND CloseDate >=  '+ startDate12Monthsd+' AND CloseDate <  '+ Cyeard;
                
                if(scenario == 'closed' || scenario == 'closed ytd'){
                    q += ' AND  iswon = true ';
                }
                
                String orgid = Userinfo.getOrganizationId();
                String omit = 'Omitted' ;
                q += ' And ForecastCategoryName != '+omit;
                //if(!orgid.contains('00D3C0000004dw9')){ 
                    q += ' AND RecordTypeId = '+'\''+recTypeNameIdMap.get(recTypeName)+'\'';
                //}
                //else{*/
                //    q +=' AND Symbol_Reserved__c  = '+'\''+recTypeName+'\'';
                //} 
            
                q += ' GROUP BY OwnerId';                
                
                // system.debug(' final query is '+q);
                // system.debug(' recTypeNameIdMap'+recTypeNameIdMap);
                
                //FunnelTriggerBatchHelper.sendErrorMail('final query is '+q);                                                                
                
                oppAggrAmt = database.query(q);
                
                //system.debug(' oppAggrAmt '+oppAggrAmt);
                
                for(AggregateResult ar: oppAggrAmt){
                    
                    Decimal totAmt = 0;
                    
                    if(recTypeActionMap.get(recTypeName) == 'Add'){
                                                    
                        if(ar.get('s') != null)
                            totAmt  += (Decimal)ar.get('s');
                    }
                        
                    for(Integer i = 0; i < flds.size(); i++){
                        if(ar.get(flds[i]) != null)
                            totAmt += (Decimal)ar.get(flds[i]);       
                    }                            
                
                    if(!ownerAmtMap.containsKey((id)ar.get('o'))){
                        ownerAmtMap.put((id)ar.get('o'),(Decimal)totAmt);        
                    }
                    else{
                        Decimal amt = ownerAmtMap.get((id)ar.get('o'));
                        amt += totAmt;                           
                        ownerAmtMap.put((id)ar.get('o'),amt);
                    }
                       
                } 
                
                                   
            }                                
                            
            /*for(Client_custom_field_mapping__mdt cm: lstCustMd){
                q += ', SUM('+cm.Custom_field_name__c+') '+cm.Custom_field_name__c;    
            }*/
               
        }
        else{
            String omit ='Omitted';
            if(scenario == 'closed'){
                q = 'SELECT ownerId o, SUM(amount) s FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND  iswon = true AND CloseDate >=  '+ startDate12Monthsd+' AND CloseDate <  '+ Cyeard+' GROUP BY OwnerId'; 
            }
            else if(scenario == 'closed ytd'){
                q = 'SELECT ownerId o, SUM(amount) s FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND  iswon = true AND CloseDate >=  '+ startDate12Monthsd+' AND CloseDate <=  '+ Cyeard+' GROUP BY OwnerId';
            }
            
            
                                                            
            ////system.debug('q--'+q);
            oppAggrAmt = database.query(q);
            
            for(AggregateResult ar: oppAggrAmt){                    
                if(ar.get('s') != null){
                    ownerAmtMap.put((id)ar.get('o'),(Decimal)ar.get('s'));        
                }
            }
        }
        
        return ownerAmtMap;
    } 
    
     public static Map<id,Decimal> fetchCurrentPipeline(String SOQL_IDs){
        
        Map<id,Decimal> ownerAmtMap = new Map<id,Decimal>();
            
        List<AggregateResult> oppAggrAmt = new List<AggregateResult>();                         
        
        String q;
                  
        if(lstCustMd != null && lstCustMd.size() > 0){                    
            
            for (String recTypeName : recTypeFldMap.keySet()){
                
                
                q = 'SELECT ownerId o ';
        
                if(recTypeActionMap.get(recTypeName) == 'Add'){
                    q += ', SUM(amount) s ';
                }
            
                List<String> flds = recTypeFldMap.get(recTypeName);
                
                for(Integer i = 0; i < flds.size(); i++){
                    q += ', SUM('+flds[i]+') '+flds[i];       
                }
                String omit = 'Omitted';
                q += ' FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND  IsClosed = false AND RecordTypeId = '+'\''+recTypeNameIdMap.get(recTypeName)+'\'';
                
                q += ' GROUP BY OwnerId';                
                
                                                                             
                
                oppAggrAmt = database.query(q);
                
                //system.debug(' oppAggrAmt '+oppAggrAmt);
                
                for(AggregateResult ar: oppAggrAmt){
                    
                    Decimal totAmt = 0;
                    
                    if(recTypeActionMap.get(recTypeName) == 'Add'){
                                                    
                        if(ar.get('s') != null)
                            totAmt  += (Decimal)ar.get('s');
                    }
                        
                    for(Integer i = 0; i < flds.size(); i++){
                        if(ar.get(flds[i]) != null)
                            totAmt += (Decimal)ar.get(flds[i]);       
                    }                            
                
                    if(!ownerAmtMap.containsKey((id)ar.get('o'))){
                        ownerAmtMap.put((id)ar.get('o'),(Decimal)totAmt);        
                    }
                    else{
                        Decimal amt = ownerAmtMap.get((id)ar.get('o'));
                        amt += totAmt;                           
                        ownerAmtMap.put((id)ar.get('o'),amt);
                    }
                       
                } 
                
                                   
            }                                
                            
            
               
        }
        else{
            String omit = 'Omitted';
            q = 'SELECT ownerId o, SUM(amount) s, Count(id) c FROM Opportunity WHERE ForecastCategoryName !=: omit And OwnerId IN ('+SOQL_IDs+') AND   IsClosed = false GROUP BY OwnerId'; 
            
            system.debug(' final query is '+q);                                                
            oppAggrAmt = database.query(q);
            
            for(AggregateResult ar: oppAggrAmt){                    
                if(ar.get('s') != null){
                    ownerAmtMap.put((id)ar.get('o'),(Decimal)ar.get('s'));        
                }
            }
        }
        
        return ownerAmtMap;
    }
    
    /* Custom metadata code */ 
   
    public static void installationMail(String subject, String msg){
    
    List<Funnel_Org_Wide_Address__mdt> owMd = [SELECT label FROM Funnel_Org_Wide_Address__mdt LIMIT 1];
    Id owEmailId;
        
    if(owMd != null && owMd.size() > 0){
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :owMd[0].label];
        if(owea != null && owea.size() > 0){
            owEmailId = owea[0].id;
        }
    }
        
    List<Admin_Email__mdt> ad= [SELECT Email_Address__c  FROM Admin_Email__mdt LIMIT 100];
    List<String> sentTo = new List<String>();
        
    for(Admin_Email__mdt a : ad){
        sentTo.add(a.Email_Address__c );
    }
    
    List<PermissionSetAssignment> psa = [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Funnel_App_Setup'];
    if(psa != null && psa.size()>0){
        Set<id> userId = new Set<id>();
        for(PermissionSetAssignment p :psa){
            userId.add(p.AssigneeId);
        }
        List<User> users = [Select Email from User where id IN :userId];
        if(users != null && users.size()>0){
            for(User u : users ){
                 sentTo.add(u.Email);
            }
        }
    } 
             
    Messaging.SingleEmailMessage  mail = new Messaging.SingleEmailMessage();
        
    if(owEmailId != null) 
        mail.setOrgWideEmailAddressId(owEmailId);
    
    mail.setSubject(subject);
    String body;
        
    String headerURL = '';
    List<Application_Setting__c> prob = [SELECT Id, Header_Image__c FROM Application_Setting__c limit 1];
    if(prob != null && prob.size()>0){
      headerURL = prob[0].Header_Image__c;
    }
    
    body= msg+'Our automation process has calculated suggested goals for all of your roles. Please log in to review and save these goals. You can then allow managers to customize these goals for their teams.' ;
    
    
    body += '<br/>'+'Review the suggested goals <a href="https://'+URL.getSalesforceBaseUrl().getHost()+'/apex/FunnelMetrics__FunnelInstallationStep9?source=email">here.</a>';   
        
    mail.setHtmlBody('<html><body><img src="' +headerURL+ '"/><br/>'+body+'</body></html>');  
    
    if(sentTo != null && sentTo.size()>0) {
        mail.setToAddresses(sentTo);
        Messaging.sendEmail(new Messaging.Singleemailmessage[] {mail});
         
    }
} 

 public static void activateTrigger(){
     if(!Test.isRunningTest()){
         Map<String, Object> maptest = new Map<String, Object>();
         maptest.put('FunnelMetrics__Bypass__c',false);
         FMCreateUpdateMetadataUtils.createUpdateMetadata('FunnelMetrics__New_Data_load_setting.FunnelMetrics__Trigger','Bypass Funnel opp & lead triggers',maptest);
     }
  
 }
     
 public static void schActivateTrigger(){
    
    Date todayDate = Date.today();
                         
    Integer day = todayDate.day();
    Integer month= todayDate.month();
    Integer year= todayDate.year();
    
    datetime NOW  = system.now();
    NOW = NOW.addMinutes(3);
     
    Integer hr =NOW.hour();
    Integer sc = NOW.minute();

    List<CronTrigger> cornList = new List<CronTrigger>();
    cornList =[SELECT Id, CronJobDetail.name, State FROM CronTrigger where CronJobDetail.name='FM Activate Trigger'];
    
    if(cornList == NULL || (cornList != null && cornList.size() == 0)){    
        FunnelTriggerActivateFrombatch sb = new FunnelTriggerActivateFrombatch();
        String sch = '0 '+sc+' '+hr+' '+day+' '+month+ ' ? '+year;
        system.schedule('FM Activate Trigger', sch, sb);
    } 
 }
 
   public static void ManagerUpdateMail(){
    
        List<Funnel_Org_Wide_Address__mdt> owMd = [SELECT label FROM Funnel_Org_Wide_Address__mdt LIMIT 1];
        Id owEmailId;
            
        if(owMd != null && owMd.size() > 0){
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :owMd[0].label];
            if(owea != null && owea.size() > 0){
                owEmailId = owea[0].id;
            }
        }
            
        //List<Admin_Email__mdt> ad= [SELECT Email_Address__c  FROM Admin_Email__mdt LIMIT 100];
        List<String> sentTo = new List<String>();
        
        List<Company_Level__c> ad =[Select Sales_Rep_Profile__r.User_Record_Name__r.Email from Company_Level__c Limit 1000];    
        for(Company_Level__c a : ad){
            sentTo.add(a.Sales_Rep_Profile__r.User_Record_Name__r.Email);
        }
        
        /*List<PermissionSetAssignment> psa = [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Funnel_App_Setup'];
        if(psa != null && psa.size()>0){
            Set<id> userId = new Set<id>();
            for(PermissionSetAssignment p :psa){
                userId.add(p.AssigneeId);
            }
            List<User> users = [Select Email from User where id IN :userId];
            if(users != null && users.size()>0){
                for(User u : users ){
                     sentTo.add(u.Email);
                }
            }
        } */
            
        Messaging.SingleEmailMessage  mail = new Messaging.SingleEmailMessage();
            
        if(owEmailId != null) 
            mail.setOrgWideEmailAddressId(owEmailId);
        
        mail.setSubject('Review Goals');
        String body;
            
        String headerURL = '';
        List<Application_Setting__c> prob = [SELECT Id, Header_Image__c FROM Application_Setting__c limit 1];
        if(prob != null && prob.size()>0){
          headerURL = prob[0].Header_Image__c;
        }
        
        body='Suggested goals have been calculated for your team. Please log in to review and save these goals. You can customize them per person if necessary.' ;
        body += '<br/>'+'Review the suggested goals <a href="https://'+URL.getSalesforceBaseUrl().getHost()+'/apex/FunnelMetrics__FunnelManagerUpdate?source=email">here.</a>';   
        
        mail.setHtmlBody('<html><body><img src="' +headerURL+ '"/><br/>'+body+'</body></html>');  
        
        if(sentTo != null && sentTo.size()>0) {
            mail.setToAddresses(sentTo);
            Messaging.sendEmail(new Messaging.Singleemailmessage[] {mail});
             
        }
    }   
    
    public static  Boolean isManager(String id){
        boolean ismgr = false;
        List<Company_Level__c> mgr = [Select id from Company_Level__c where Sales_Rep_Profile__r.User_Record_Name__c = :id LIMIT 1];
        
        if(mgr!= null && mgr.size()>0){
            ismgr = true;
        }
       // system.debug('ismgr ---'+ismgr );
        return ismgr;
    
    }
    
    /* Action plan */
    
    public static void createActionPlanSnapshot(List<Action_Plan__c> triggernew){
        List<Action_Plan_Snapshot__c> ActionPlanList = new List<Action_Plan_Snapshot__c>();
        for(Action_Plan__c a: triggernew){
            Action_Plan_Snapshot__c aps = new Action_Plan_Snapshot__c();
            aps.Name = a.name;
            aps.Action_Plan__c = a.id;
            aps.Action_Step__c = a.Action_Step__c;
            aps.Active__c = a.Active__c;
            aps.Custom_Field_1__c = a.Custom_Field_1__c;
            aps.Custom_Field_2__c = a.Custom_Field_2__c;
            aps.Custom_Field_3__c = a.Custom_Field_3__c;
            aps.Due_Date__c = a.Due_Date__c;
            aps.Employee_Name__c = a.Employee_Name__c;
            aps.Employee_Response__c = a.Employee_Response__c;
            aps.Manager_Name__c = a.Manager_Name__c;
            aps.Measurement_Criteria__c = a.Measurement_Criteria__c;
            aps.Metric_Skill__c = a.Metric_Skill__c;
            aps.Notes__c = a.Notes__c;
            aps.Period__c = a.Period__c;
            aps.Result__c = a.Result__c;
            aps.Result_Rating__c = a.Result_Rating__c;
            aps.Sales_Rep_Profile__c = a.Sales_Rep_Profile__c;
            aps.Status__c = a.Status__c;
            ActionPlanList.add(aps); 
            
        }
        
        if(ActionPlanList!= null && ActionPlanList.size() > 0){
            insert ActionPlanList;
        }
        
        }
        
        public static void deleteActionPlanSnapshots(Set<id> actionPlanId){
            List<Action_Plan_Snapshot__c> aps = [Select id,Action_Plan__c  from Action_Plan_Snapshot__c where Action_Plan__c IN :actionPlanId order by Createddate desc];
            Map<id,List<Action_Plan_Snapshot__c >> apsMap = new Map<id,List<Action_Plan_Snapshot__c >>();
            
            List<Action_Plan_Snapshot__c> deleteRecord = new List<Action_Plan_Snapshot__c>();
            system.debug('aps ---'+aps );
            for(Action_Plan_Snapshot__c a : aps ){
                if(apsMap.containsKey(a.Action_Plan__c )){
                        apsMap.get(a.Action_Plan__c ).add(a);
                        system.debug('apsMap.get(a.Action_Plan__c).size()---'+apsMap.get(a.Action_Plan__c).size());
                        if(apsMap.get(a.Action_Plan__c).size()>10){
                            deleteRecord.add(a);
                        }
                    }
                    else{
                        List<Action_Plan_Snapshot__c > snapList= new List<Action_Plan_Snapshot__c >();
                        snapList.add(a);
                        apsMap.put(a.Action_Plan__c,snapList);
                         
                    }
            }
            if(deleteRecord != null && deleteRecord.size() > 0){
                delete deleteRecord;
            }
        }
        
    
    
    private static Map<Id,Decimal>  fetchYtdRevenue( String ytdStartDate, String ytdEndDatedate){
        System.debug('ytdStartDate'+ytdStartDate);
        System.debug('ytdEndDatedate'+ytdEndDatedate);
        Map<Id,Decimal> listYtdRevenue  =  new  Map<Id,Decimal>();
       
        String SOQLYtd =  'SELECT Sales_Rep_Profile__c i, SUM(Direct_Revenue__c) mqr    FROM Funnelocity_Revenue_data__c WHERE Snapshot_Scheduled_Date__c  >=  '+ ytdStartDate+' AND Snapshot_Scheduled_Date__c <='+ ytdEndDatedate+' AND (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_Quota_Amount__c > 0) GROUP BY Sales_Rep_Profile__c';
        
        List<AggregateResult> arYtdrevenue =  database.query(SOQLYtd);

        for(AggregateResult ar: arYtdrevenue){
            listYtdRevenue.put((Id)ar.get('i'),  (Decimal)ar.get('mqr')   );
        }
          
         return listYtdRevenue;
        
    }
    
     private static Map<Id,Decimal>  fetchQtRevenue(String qStartdate, String qEndDate){
        System.debug('qStartdate'+qStartdate);
        System.debug('qEndDate'+qEndDate);
        Map<Id,Decimal> listQtRevenue  =  new  Map<Id,Decimal>();
       
        String SOQLQt =  'SELECT Sales_Rep_Profile__c i, SUM(Direct_Revenue__c) mqr    FROM Funnelocity_Revenue_data__c WHERE Snapshot_Scheduled_Date__c  >=  '+ qStartdate+' AND Snapshot_Scheduled_Date__c <='+ qEndDate+' AND (Sales_rep_profile__r.Active__c = TRUE OR Sales_rep_profile__r.Annual_Quota_Amount__c > 0) GROUP BY Sales_Rep_Profile__c';
        
        List<AggregateResult> arQtrevenue =  database.query(SOQLQt);

        for(AggregateResult ar: arQtrevenue){
            listQtRevenue.put((Id)ar.get('i'), (Decimal)ar.get('mqr') );
        } 
        
        return listQtRevenue;
    }
    
    private static Map<Id,Decimal>  fetchMnRevenue(){
        
         System.debug('Date.today().year()'+Date.today().year());
        System.debug('Date.today().month()'+Date.today().month());
         List<Funnelocity_Revenue_data__c> fmRevenue =  database.query('SELECT Direct_Revenue__c, Sales_Rep_Profile__c FROM Funnelocity_Revenue_data__c WHERE  Year__c =' +Date.today().year()+ ' AND Month__c = '+Date.today().month());                           
           Map<Id, Decimal> fmMonthlyRevenue =  new Map<Id,Decimal>();
           for(Funnelocity_Revenue_data__c a:fmRevenue){
                fmMonthlyRevenue.put(a.Sales_Rep_Profile__c,a.Direct_Revenue__c);
            }
            
        return fmMonthlyRevenue;
    }
    
     public Static Map<Id,Sales_Rep_Profile__c> updateHybridRevenue(Set<Id> srpId){
         
        List<Sales_Rep_Profile__c> salesReps = [SELECT id,Profile_Type__c,User_Record_Name__c FROM Sales_Rep_Profile__c WHERE id IN :srpId AND Profile_Type__c ='Hybrid'];
        Map<id, Sales_Rep_Profile__c> profMap = new Map<id, Sales_Rep_Profile__c>();
         
        Date currentFiscalYear = getFiscalYearDate('Current_Year');
        DateTime FyearDateTime = getFiscalYearDate('Current_Year');
        Date CyearDate;
        DateTime CyearDateTime;
        DateTime CyearGMT;
         
        if(FunnelTriggerBatchHelper.histDataBatch){
            CyearDate = FunnelTriggerBatchHelper.histDateVal;   
            CyearGMT = FunnelTriggerBatchHelper.histDateTimeVal;
            
        }
        else if( FunnelTriggerBatchHelper.histDateVal != null){
            CyearDate = FunnelTriggerBatchHelper.histDateVal;   
            CyearGMT = FunnelTriggerBatchHelper.histDateTimeVal;
             
        }
        else{
            CyearDate = date.newInstance(Date.today().year(),Date.today().month(), date.daysInMonth(Date.today().year(), Date.today().month()));  
            system.debug(' CyearDate  '+CyearDate );
            CyearDateTime = System.now(); 
            CyearGMT = Date.today();
            system.debug(' CyearGMT '+CyearGMT );
        }
        
        //system.debug('CyearGMT  -->'+CyearGMT );
        Integer offset = UserInfo.getTimezone().getOffset(CyearGMT);
        //Datetime Cyear = CyearGMT.addSeconds(offset/1000);
        Datetime Cyear = CyearGMT;
        system.debug(' Cyear '+Cyear );
        //system.debug(' Cyear '+Cyear);
        String CyearString = Cyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        String CyearStringDate = CyearString.substring(0,10);
        
         
        
        DateTime Q0 = FyearDateTime ;
        DateTime Q1 = FyearDateTime.addMonths(3);
        DateTime Q2 = Q1.addMonths(3);
        DateTime Q3 = Q2.addMonths(3);
        DateTime Q4 = Q3.addMonths(3);
        
        DateTime startDate;
        DateTime endDate;
        
       
        
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
        String dateTimeEndDate = endDate.formatgmt('yyyy-MM-dd\'T\'23:59:59\'Z\'');                
        System.debug('dateTimeStartDate 1'+dateTimeStartDate);
        
        String dateTimeStartDateCD = dateTimeStartDate;
        
        dateTimeStartDate = dateTimeStartDate.substring(0,10);
        dateTimeEndDate = dateTimeEndDate.substring(0,10);
        
        //startDate = Datetime.newInstance(Cyear.yearGmt(),Cyear.monthGmt(),1);
        endDate = Datetime.newInstance(Cyear.yearGmt(),Cyear.monthGmt(),Date.daysInMonth(Cyear.yearGmt(),Cyear.monthGmt()));
        
        //startDate = startDate.addSeconds(offset/1000);
        endDate = endDate.addSeconds(offset/1000);
        
        dateTimeStartDate = startDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        dateTimeEndDate = endDate.formatgmt('yyyy-MM-dd\'T\'23:59:59\'Z\'');
         
        dateTimeStartDateCD = dateTimeStartDate;
        dateTimeStartDate = dateTimeStartDate.substring(0,10);
        dateTimeEndDate = dateTimeEndDate.substring(0,10);
                
               
        String Fisyear =FyearDateTime.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');    
                         
       
        DateTime currentFiscalYearDT = currentFiscalYear;
        String currentFiscalYearStr = currentFiscalYearDT.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        currentFiscalYearStr = currentFiscalYearStr.substring(0,10);
        
        DateTime CyearDateDT = CyearDate;
        String CyearDateStr = CyearDateDT.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        CyearDateStr = CyearDateStr.substring(0,10);
        
        System.debug('dateTimeStartDate1'+dateTimeStartDate);
        Map<Id,Decimal> mapRepsYtdRev =  fetchYtdRevenue( currentFiscalYearStr, CyearDateStr);   
        Map<Id,Decimal> mapRepsQtdRev =  fetchQtRevenue(dateTimeStartDate, dateTimeEndDate);   
        Map<Id,Decimal> mapRepsMnRev =  fetchMnRevenue();   
        
       
         
        
        
        for(Sales_Rep_Profile__c s: salesReps){
                
                 /*Custom metadata code*/
                if(s.Profile_Type__c == 'Hybrid'){
                    if(mapRepsYtdRev.get(s.id) != null){
                        s.YTD_Revenue__c = mapRepsYtdRev.get(s.id);
                        }    
                    else{
                        s.YTD_Revenue__c = 0;
                    }
                    
                    if(mapRepsQtdRev.get(s.id) != null){
                        s.Quarterly_Quota_Revenue__c = mapRepsQtdRev.get(s.id);
                    }
                    else{
                        s.Quarterly_Quota_Revenue__c = 0;
                    }
                    
                    if(mapRepsMnRev.get(s.id) != null){
                        s.Monthly_Quota_Revenue__c = mapRepsMnRev.get(s.id);
                    }
                    else{
                        s.Monthly_Quota_Revenue__c = 0;
                    }
                }
                 
                 profMap.put(s.id,s);
                
            }
        
         
        return profMap;         
         
    }
    
    // Called from FunnelCompanyLevelMetadata to update the Manager on srp when srp on company level is updated
    public static void updateManger(Map<id,List<Sales_Rep_Profile__c>> updateMap){
        List<Sales_Rep_Profile__c> updateSrp = new List<Sales_Rep_Profile__c>();
        for( id manager : updateMap.keySet()){
            
            for(Sales_Rep_Profile__c s: updateMap.get(manager)){
                s.Sales_Manager__c = manager;
                updateSrp.add(s);
            }
            
        }
        
        if(updateSrp != null && updateSrp.size()>0){
            update updateSrp; 
        }
          
    }
    
    //Should be called from monthly batch and whenever quota is updated
    public static void updateYTDQuota(Sales_rep_profile__c sr){
        
        system.debug(' ytd quota updated '+sr.YTD_Quota_updated__c);
        
         IF(sr.Current_Fiscal_Months__c == 1){
            sr.YTD_Quota_updated__c = checkQuota(sr.Month_1_Quota_Amount__c);
        }
        else IF(sr.Current_Fiscal_Months__c == 2){
            sr.YTD_Quota_updated__c = checkQuota(sr.Month_1_Quota_Amount__c)+checkQuota(sr.Month_2_Quota_Amount__c);
        }
        else IF(sr.Current_Fiscal_Months__c == 3){
            sr.YTD_Quota_updated__c = checkQuota(sr.Q1_Quota_Amount__c);
        }
        else IF(sr.Current_Fiscal_Months__c == 4){
            sr.YTD_Quota_updated__c = checkQuota(sr.Q1_Quota_Amount__c)+checkQuota(sr.Month_4_Quota_Amount__c);
        }
        else IF(sr.Current_Fiscal_Months__c == 5){
            sr.YTD_Quota_updated__c = checkQuota(sr.Q1_Quota_Amount__c)+checkQuota(sr.Month_4_Quota_Amount__c)+checkQuota(sr.Month_5_Quota_Amount__c);
        }
        else IF(sr.Current_Fiscal_Months__c == 6){
            sr.YTD_Quota_updated__c = checkQuota(sr.Q1_Quota_Amount__c)+checkQuota(sr.Q2_Quota_Amount__c);
        }
        else IF(sr.Current_Fiscal_Months__c == 7){
            sr.YTD_Quota_updated__c = checkQuota(sr.Q1_Quota_Amount__c)+checkQuota(sr.Q2_Quota_Amount__c)+checkQuota(sr.Month_7_Quota_Amount__c);
        }
        else IF(sr.Current_Fiscal_Months__c == 8){
            sr.YTD_Quota_updated__c = checkQuota(sr.Q1_Quota_Amount__c)+checkQuota(sr.Q2_Quota_Amount__c)+checkQuota(sr.Month_7_Quota_Amount__c)+checkQuota(sr.Month_8_Quota_Amount__c);
        }
        else IF(sr.Current_Fiscal_Months__c == 9){
            sr.YTD_Quota_updated__c = checkQuota(sr.Q1_Quota_Amount__c)+checkQuota(sr.Q2_Quota_Amount__c)+checkQuota(sr.Q3_Quota_Amount__c);
        }
        else IF(sr.Current_Fiscal_Months__c == 10){
            sr.YTD_Quota_updated__c = checkQuota(sr.Q1_Quota_Amount__c)+checkQuota(sr.Q2_Quota_Amount__c)+checkQuota(sr.Q3_Quota_Amount__c)+checkQuota(sr.Month_10_Quota_Amount__c);
        }
        else IF(sr.Current_Fiscal_Months__c == 11){
            sr.YTD_Quota_updated__c = checkQuota(sr.Q1_Quota_Amount__c)+checkQuota(sr.Q2_Quota_Amount__c)+checkQuota(sr.Q3_Quota_Amount__c)+checkQuota(sr.Month_10_Quota_Amount__c)+checkQuota(sr.Month_11_Quota_Amount__c);
        }
        else IF(sr.Current_Fiscal_Months__c == 12){
            sr.YTD_Quota_updated__c = checkQuota(sr.Q1_Quota_Amount__c)+checkQuota(sr.Q2_Quota_Amount__c)+checkQuota(sr.Q3_Quota_Amount__c)+checkQuota(sr.Q4_Quota_Amount__c);
        }
         
        String s1  =  'Month_'+sr.Current_Fiscal_Months__c+'_Quota_Amount__c';
        
        s1  = s1.remove('.0');
        System.debug('s1'+s1);
        
        Decimal mq = checkQuota((Decimal)sr.get(s1));
        sr.Monthly_quota__c = mq;
        
        if(sr.Current_Fiscal_Months__c <= 3){
            sr.Quarterly_quota__c = checkQuota(sr.Q1_Quota_Amount__c);
        }
        else if (sr.Current_Fiscal_Months__c <= 6){
            sr.Quarterly_quota__c = checkQuota(sr.Q2_Quota_Amount__c);
        }
        else if (sr.Current_Fiscal_Months__c <= 9){
            sr.Quarterly_quota__c = checkQuota(sr.Q3_Quota_Amount__c);
        }
        else if (sr.Current_Fiscal_Months__c <= 12){
            sr.Quarterly_quota__c = checkQuota(sr.Q4_Quota_Amount__c);
        }
        
        system.debug(' ytd quota updated '+sr.YTD_Quota_updated__c);
        
    }
    
    public static Decimal checkQuota(Decimal d){
        
        Decimal result = 0;
        
        if(d != null){
            result = d;
        }
        
        return result;
    
    }
    
    public static String SOQL_IDs;
    public static string startDate12Monthsd;
    public static String Cyeard;                        
    public static string startDateMonthsd;
    public static string startd;
    public static string Fs;
    public static DateTime Fyear;
    public static String Fisyear;
    public static Date triggerDate;
    public static DateTime Cyear; 
    public static String Cisyear;
    public static String Fyeard;
    public static DateTime Q0;                            
    public static DateTime Q1;                            
    public static DateTime Q2;                            
    public static DateTime Q3;                            
    public static DateTime Q4;  
    public static DateTime startDate;                     
    public static DateTime endDate;   
    public static String Quarter;
    public static boolean quat =  false;
    public static string startDates;
    public static string endDates;
    public static Date triggerDateminus1;
    public static DateTime startDateMonth;
    public static DateTime endDateMonth;
   
    public static DateTime startDate12Month;
    public static DateTime endDate12Month;
    
    public static string startDate12Months;
    public static string endDate12Months;
    
    public static string startDateMonths;
    public static string endDateMonths;
    
    public static string endDateMonthsd;
    public static string endDate12Monthsd;
    
    public static string endd;
    public static string Cs;
    public static Decimal userprob = 0;
    public static String MeetingValues;

    public static void generateSoqlId(Set<Id> userIds){
                
        SOQL_IDs = '';
        
        for (Id id : userIds) {
        
            String id_in_quotes =  '\''+id+'\'';
           
            if (SOQL_IDs !=  '') { 
                SOQL_IDs+= ','; 
            }
           
            SOQL_IDs +=  id_in_quotes;
        }

    }
    
    //Method to generate dates for ytd, monthly and quarterly metrics that need to be updated from the trigger
    private static void generateDates(){
    
        Fyear =  FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        Fisyear = Fyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        system.debug('Fisyear :: '+Fisyear+' Fyear :: '+Fyear);
        triggerDate = Date.today();
        system.debug('triggerDate :: '+triggerDate);
        triggerDate  =  triggerDate.addDays(1);
        Cyear =  triggerDate ;  
        Cisyear = Cyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        
        Fyeard =  Fisyear.substring(0,10);
        Cyeard =  Cisyear.substring(0,10);
                 
        Q0 =  Fyear ;
        Q1 =  Fyear.addMonths(3);
        Q2 =  Q1.addMonths(3);
        Q3 =  Q2.addMonths(3);
        Q4 =  Q3.addMonths(3);
        system.debug('Fyeard :: '+Fyeard);
        system.debug('Q0 :: '+Q0+'Cyear :: '+Cyear);
        if( (Q0 <=  Cyear) && (Cyear <= Q1)){
        
            startDate=  Q0;
            endDate =  Q1;
            Quarter =  'Q1';
                      
        }else if((Q1 <=  Cyear) && (Cyear <= Q2)){
        
            startDate=  Q1;
            endDate =  Q2;
            Quarter =  'Q2';
            
        }else if((Q2 <=  Cyear) && (Cyear <= Q3)){
        
            startDate=  Q2;
            endDate =  Q3;
            Quarter =  'Q3';
            
        }else if((Q3 <=  Cyear) && (Cyear <= Q4)){
        
            startDate=  Q3;
            endDate =  Q4;
            Quarter =  'Q4';
        
        }  
       
       if( endDate !=  null && Cyear.Monthgmt() ==  endDate.Monthgmt()-1){
           quat =  true;
       }
       system.debug('startDate :: '+startDate);
       system.debug('endDate :: '+endDate);
       startDates =  startDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
       endDates =  endDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
        
        Integer yr = Cyear.yearGmt();
        Integer mn = Cyear.monthGmt();
        
        triggerDateminus1 = Date.Today();
        
        dateTime dt = triggerDateminus1 ;
        Integer yrtm1 = dt.yearGmt();
        Integer mntm1 = dt.monthGmt();
        
        startDateMonth =  Datetime.newInstance(yrtm1 ,mntm1 ,1);
        endDateMonth =  Datetime.newInstance(yr,mn,Date.daysInMonth(yr,mn));                 
        
        Integer offset = UserInfo.getTimezone().getOffset(startDateMonth);
        
        startDateMonth = startDateMonth.addSeconds(offset/1000);
        endDateMonth = endDateMonth.addSeconds(offset/1000);
        
        startDateMonths =  startDateMonth.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        endDateMonths =  endDateMonth.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
        
        startDateMonthsd =  startDateMonths.substring(0, 10);
        endDateMonthsd =  endDateMonths.substring(0, 10);
        
        endDate12Month =  Cyear;
        startDate12Month =   datetime.newInstance(dt.yearGmt()-1 , dt.monthGmt()+1, 1);
        startDate12Month =   startDate12Month.addSeconds(offset/1000);      
        
        startDate12Months =  startDate12Month.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        endDate12Months =  endDate12Month.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
        
        startDate12Monthsd =  startDate12Months.substring(0, 10);
        endDate12Monthsd =  endDate12Months.substring(0, 10);
        
        startd =  startDates.substring(0, 10);
        endd =  endDates.substring(0, 10);
        Fs =  Fisyear.substring(0, 10);
        Cs=  Cyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        Cs =  cs.substring(0, 10);
          
    }
    
    //Method called from the events trigger to update the metrics related to monthly, quarterly and YTD meetings on the sales rep profile
    public Static void fetchMeetingsFromEvents(Set<Id> ownerIds){
        
        generateSoqlId(ownerIds);
        generateDates();
           
        Date CyearDate;
        DateTime CyearDateTime;
        
        DateTime CyearGMT;   
        
        Date currentFiscalYear = getFiscalYearDate('Current_Year');
        
        String MeetingValues;
        String MeetingObject;//Added for FM : ICE Meeting Change -Rohit
        
        //This is used under dynamic query for Monthly Added   
        List<Application_Setting__c> prob = [SELECT Id,Meetings_Values__c,Object_for_Meeting__c FROM Application_Setting__c limit 1];//Added Object_for_Meeting__c in the query for FM : ICE Meeting Change -Rohit
        
        if(prob != null && prob.size()>0){
            MeetingValues = prob[0].Meetings_Values__c;
            MeetingObject = prob[0].Object_for_Meeting__c;//Added for FM : ICE Meeting Change -Rohit
        } 
        
        CyearDate = Date.today();   
        CyearDateTime = System.now();
        CyearGMT = Date.today();
        
        Integer offset = UserInfo.getTimezone().getOffset(CyearGMT);
        Datetime Cyear = CyearGMT;
        String CyearString = Cyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        String CyearStringDate = CyearString.substring(0,10);
                
        //Map to store the sales profiles to be updated
        Map<id, Sales_Rep_Profile__c> profMap = new Map<id, Sales_Rep_Profile__c>();
        
        //Map to store the user id and the corresponding sales profile id
        Map<Id,Id> ownerSalesReps = new Map<Id,Id>();
        Map<Id,Sales_rep_profile__c> ownerSmap = new Map<Id,Sales_rep_profile__c>();
        
        List<Sales_Rep_Profile__c> salesReps = [SELECT id,User_Record_Name__c FROM Sales_Rep_Profile__c WHERE User_Record_Name__c IN :ownerIds];
        
        for(Sales_Rep_Profile__c sr: salesReps ){
            ownerSalesReps.put(sr.User_Record_Name__c,sr.id);    
            ownerSmap.put(sr.User_record_name__c, sr);
        }
        
        DateTime CyearEndDate = Cyear.addDays(1);
                
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
        
        DateTime FyearDateTime = getFiscalYearDate('Current_Year');
        
        DateTime Q0 = FyearDateTime ;
        DateTime Q1 = FyearDateTime.addMonths(3);
        DateTime Q2 = Q1.addMonths(3);
        DateTime Q3 = Q2.addMonths(3);
        DateTime Q4 = Q3.addMonths(3);
        
        DateTime startDate;
        DateTime endDate;
        
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
        String dateTimeEndDate = endDate.formatgmt('yyyy-MM-dd\'T\'23:59:59\'Z\'');                
                        
        if(ownerString != null && ownerString.length() > 0)
            ownerString = ownerString.subString(0,(ownerString.length() - 1));
                    
        list<Map<Id,Integer>> meetingCountMapList =  new list<Map<Id,Integer>>();
        Map<Id,Integer> meetingCountMap =  new Map<Id,Integer>();
        
         List<String> meetingValuesList = new List<String>();
         List<String> meetingValuesList2 = new List<String>();
         String mVal = '';
         
         if(MeetingValues != null && MeetingValues !=''){
             meetingValuesList = MeetingValues.split(';');
          
             for(String s: meetingValuesList){
                 system.debug(s.trim());
                 meetingValuesList2.add(s.trim());
             } 
            
            for (string id : meetingValuesList2) {
            
                String id_in_quotes =  '\''+id+'\'';
               
                if (mVal !=  '') { 
                    mVal+= ','; 
                }
               
                mVal +=  id_in_quotes;
            }
         }
         
        string m = '%Meeting%';
        
        String SOQL ;
        
        /*if(mVal == ''){
             SOQL =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND ActivityDate >= '+startDate12Monthsd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
        }else{
             SOQL =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type IN  ('+mVal+')  AND ActivityDate >= '+startDate12Monthsd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
        }
        system.debug('12 month meeting created --->'+'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN - AND Type Like  '+'\''+m+ '\''+' AND ActivityDate >= '+startDate12Months+' AND ActivityDate < '+Cisyear+' GROUP BY OwnerId');
        
        List<AggregateResult> MeetingAggrList =  database.query(SOQL);

        for(AggregateResult ar: MeetingAggrList){
            meetingCountMap.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
                         
        meetingCountMapList.add(meetingCountMap);*/
        
        Map<Id,Integer> meetingCountMapmonth =  new Map<Id,Integer>();
         
        String SOQLmn;
        String SOQLmn1;//Added for FM : ICE Meeting Change -Rohit
        //commented for FM : ICE Meeting Change -Rohit
        /*if(mVal == ''){
             SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND ActivityDate >= '+startDateMonthsd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
        }else{
             SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type IN  ('+mVal+')  AND ActivityDate >= '+startDateMonthsd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
        }*/
        //Added for FM : ICE Meeting Change -Rohit [START]
        if(MeetingObject == 'Event & Task'){
            if(mVal == ''){
                SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND ActivityDate >= '+startDateMonthsd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
                SOQLmn1 = 'SELECT OwnerId o, Count(id) c FROM Task WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND ActivityDate >= '+startDateMonthsd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
            }else{
                SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type IN  ('+mVal+')  AND ActivityDate >= '+startDateMonthsd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
                SOQLmn1 = 'SELECT OwnerId o, Count(id) c FROM Task WHERE OwnerId IN ('+SOQL_IDs+') AND Type IN  ('+mVal+')  AND ActivityDate >= '+startDateMonthsd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
            }
        }else if(MeetingObject == 'Task'){
            if(mVal == ''){
                SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Task WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND ActivityDate >= '+startDateMonthsd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
            }else{
                SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Task WHERE OwnerId IN ('+SOQL_IDs+') AND Type IN  ('+mVal+')  AND ActivityDate >= '+startDateMonthsd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
            }
        }else{           
            if(mVal == ''){
                SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND ActivityDate >= '+startDateMonthsd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
            }else{
                SOQLmn =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type IN  ('+mVal+')  AND ActivityDate >= '+startDateMonthsd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
            }
        }
        //Added for FM : ICE Meeting Change -Rohit [END]
        system.debug('monthly meeting --->'+'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN - AND Type Like  '+'\''+m+ '\''+' AND CreatedDate >= '+startDateMonthsd+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId');
        
        List<AggregateResult> meetingAggrListmn =  database.query(SOQLmn);

        for(AggregateResult ar: meetingAggrListmn){
            meetingCountMapmonth.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        //Added for FM : ICE Meeting Change -Rohit [START]
        if(MeetingObject == 'Event & Task'){
            List<AggregateResult> meetingAggrListmn1 =  database.query(SOQLmn1);
            for(AggregateResult ar: meetingAggrListmn1){
                if(meetingCountMapmonth.get((Id)ar.get('o')) != null && meetingCountMapmonth.get((Id)ar.get('o')) >0 ){
                    Integer meetings = meetingCountMapmonth.get((Id)ar.get('o')) + (Integer)ar.get('c');
                    meetingCountMapmonth.put((Id)ar.get('o'),meetings);
                }else{
                    meetingCountMapmonth.put((Id)ar.get('o'), (Integer)ar.get('c'));
                }
            }
        }
        //Added for FM : ICE Meeting Change -Rohit [END]
        Map<Id,Integer> meetingCountMapq =  new Map<Id,Integer>();
         
        String SOQLq ;
        String SOQLq1;//Added for FM : ICE Meeting Change -Rohit
        //commented for FM : ICE Meeting Change -Rohit
        /*if(mVal == ''){
             SOQLq =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND ActivityDate >= '+startd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
        }else{
             SOQLq =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type IN  ('+mVal+')  AND ActivityDate >= '+startd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
        }*/
        //Added for FM : ICE Meeting Change -Rohit [START]
        if(MeetingObject == 'Event & Task'){
            if(mVal == ''){
                SOQLq =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND ActivityDate >= '+startd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
                SOQLq1 = 'SELECT OwnerId o, Count(id) c FROM Task WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND ActivityDate >= '+startd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
            }else{
                SOQLq =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type IN  ('+mVal+')  AND ActivityDate >= '+startd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
                SOQLq1 = 'SELECT OwnerId o, Count(id) c FROM Task WHERE OwnerId IN ('+SOQL_IDs+') AND Type IN  ('+mVal+')  AND ActivityDate >= '+startd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
            }
        }else if(MeetingObject == 'Task'){
            if(mVal == ''){
                SOQLq =  'SELECT OwnerId o, Count(id) c FROM Task WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND ActivityDate >= '+startd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
            }else{
                SOQLq =  'SELECT OwnerId o, Count(id) c FROM Task WHERE OwnerId IN ('+SOQL_IDs+') AND Type IN  ('+mVal+')  AND ActivityDate >= '+startd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
            }
        }else{           
            if(mVal == ''){
                SOQLq =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND ActivityDate >= '+startd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
            }else{
                SOQLq =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type IN  ('+mVal+')  AND ActivityDate >= '+startd+' AND ActivityDate < '+Cyeard+' GROUP BY OwnerId';
            }
        }
        //Added for FM : ICE Meeting Change -Rohit [END]
        system.debug('quaterly meeting --->'+'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN - AND Type Like  '+'\''+m+ '\''+' AND CreatedDate >= '+startDates+' AND CreatedDate < '+Cisyear+' GROUP BY OwnerId');
        
        List<AggregateResult> meetingAggrListq =  database.query(SOQLq);

        for(AggregateResult ar: meetingAggrListq){
            meetingCountMapq.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        //Added for FM : ICE Meeting Change -Rohit [START]
        if(MeetingObject == 'Event & Task'){
            List<AggregateResult> meetingAggrListq1 =  database.query(SOQLq1);
            for(AggregateResult ar: meetingAggrListq1){
                if(meetingCountMapq.get((Id)ar.get('o')) != null && meetingCountMapq.get((Id)ar.get('o')) >0 ){
                    Integer meetings = meetingCountMapq.get((Id)ar.get('o')) + (Integer)ar.get('c');
                    meetingCountMapq.put((Id)ar.get('o'),meetings);
                }else{
                    meetingCountMapq.put((Id)ar.get('o'), (Integer)ar.get('c'));
                }
            }
        }
        //Added for FM : ICE Meeting Change -Rohit [END]
        Map<Id,Integer> meetingCountMapytd =  new Map<Id,Integer>();
        String SOQLytd;
        String SOQLytd1;//Added for FM : ICE Meeting Change -Rohit
        //commented for FM : ICE Meeting Change -Rohit
        /*if(mVal == ''){
             SOQLytd =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+')AND Type Like '+'\''+m+ '\''+' AND ActivityDate >= '+Fs+' AND ActivityDate < '+Cs+'   GROUP BY OwnerId';
        }else{
             SOQLytd =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type IN  ('+mVal+')  AND ActivityDate >= '+Fs+' AND ActivityDate < '+Cs+'   GROUP BY OwnerId';
        }*/
        //Added for FM : ICE Meeting Change -Rohit [START]
        if(MeetingObject == 'Event & Task'){
            if(mVal == ''){
                SOQLytd =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND ActivityDate >= '+Fs+' AND ActivityDate < '+Cs+' GROUP BY OwnerId';
                SOQLytd1 = 'SELECT OwnerId o, Count(id) c FROM Task WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND ActivityDate >= '+Fs+' AND ActivityDate < '+Cs+' GROUP BY OwnerId';
            }else{
                SOQLytd =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type IN  ('+mVal+')  AND ActivityDate >= '+Fs+' AND ActivityDate < '+Cs+' GROUP BY OwnerId';
                SOQLytd1 = 'SELECT OwnerId o, Count(id) c FROM Task WHERE OwnerId IN ('+SOQL_IDs+') AND Type IN  ('+mVal+')  AND ActivityDate >= '+Fs+' AND ActivityDate < '+Cs+' GROUP BY OwnerId';
            }
        }else if(MeetingObject == 'Task'){
            if(mVal == ''){
                SOQLytd =  'SELECT OwnerId o, Count(id) c FROM Task WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND ActivityDate >= '+Fs+' AND ActivityDate < '+Cs+' GROUP BY OwnerId';
            }else{
                SOQLytd =  'SELECT OwnerId o, Count(id) c FROM Task WHERE OwnerId IN ('+SOQL_IDs+') AND Type IN  ('+mVal+')  AND ActivityDate >= '+Fs+' AND ActivityDate < '+Cs+' GROUP BY OwnerId';
            }
        }else{           
            if(mVal == ''){
                SOQLytd =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type Like  '+'\''+m+ '\''+' AND ActivityDate >= '+Fs+' AND ActivityDate < '+Cs+' GROUP BY OwnerId';
            }else{
                SOQLytd =  'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN ('+SOQL_IDs+') AND Type IN  ('+mVal+')  AND ActivityDate >= '+Fs+' AND ActivityDate < '+Cs+' GROUP BY OwnerId';
            }
        }
        //Added for FM : ICE Meeting Change -Rohit [END]
        system.debug('ytd meeting --->'+'SELECT OwnerId o, Count(id) c FROM Event WHERE OwnerId IN - AND Type Like  '+'\''+m+ '\''+' AND CreatedDate >= '+Fisyear+' AND CreatedDate < '+Cisyear+'   GROUP BY OwnerId');
        
        List<AggregateResult> meetingAggrListytd =  database.query(SOQLytd);

        for(AggregateResult ar: meetingAggrListytd){
            meetingCountMapytd.put((Id)ar.get('o'), (Integer)ar.get('c'));
        }
        //Added for FM : ICE Meeting Change -Rohit [START]
        if(MeetingObject == 'Event & Task'){
            List<AggregateResult> meetingAggrListytd1 =  database.query(SOQLytd1);
            for(AggregateResult ar: meetingAggrListytd1){
                if(meetingCountMapytd.get((Id)ar.get('o')) != null && meetingCountMapytd.get((Id)ar.get('o')) >0 ){
                    Integer meetings = meetingCountMapytd.get((Id)ar.get('o')) + (Integer)ar.get('c');
                    meetingCountMapytd.put((Id)ar.get('o'),meetings);
                }else{
                    meetingCountMapytd.put((Id)ar.get('o'), (Integer)ar.get('c'));
                }
            }
        }
        //Added for FM : ICE Meeting Change -Rohit [END]
        for(Id i: ownerSmap.keySet()){
            /*if(meetingCountMap.get(i) != null){
                ownerSmap.get(i).Number_of_meetings_Rolling_12_months__c = meetingCountMap.get(i);
                system.debug(' Number_of_meetings_Rolling_12_months__c '+ownerSmap.get(i).Number_of_meetings_Rolling_12_months__c);
            }*/
            
            if(meetingCountMapmonth.get(i) != null){
                ownerSmap.get(i).Number_of_meetings_per_month__c = meetingCountMapmonth.get(i);
                system.debug(' Number_of_meetings_per_month__c '+ownerSmap.get(i).Number_of_meetings_per_month__c);
            }
            
            if(meetingCountMapq.get(i) != null){
                ownerSmap.get(i).Number_of_meetings_per_quarter__c = meetingCountMapq.get(i);
                system.debug(' Number_of_meetings_per_quarter__c '+ownerSmap.get(i).Number_of_meetings_per_quarter__c);
            }
            
            if(meetingCountMapytd.get(i) != null){
                ownerSmap.get(i).Number_of_meetings_YTD__c = meetingCountMapytd.get(i);
                system.debug(' Number_of_meetings_YTD__c '+ownerSmap.get(i).Number_of_meetings_YTD__c);

            }
        }
        
        update(ownerSmap.values());
        
    }

   /* public static Boolean isLastDay(Date triggerDate){
        Integer dayOfMonth = triggerDate.day();
        Integer monthOfYear = triggerDate.month();
        Integer year = triggerDate.year();

        // Check if the date is the last day of the month
        if (dayOfMonth == Date.daysInMonth(year, monthOfYear)) {
            return true;
        } else {
           return false;
        }
    } */
}