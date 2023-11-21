/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelCertificationTable {
    
    Public Map<String,String> managemenetReports{get;set;}
    
    public FunnelFilterWrapper fw {get; set;}

    public string repStatus{get;set;}
    public list<Certification__c> certiTable{get;set;}
    public list<Certification__c> mngRecord{get;set;}
    public decimal avgTenure{get;set;}
    public list<AggregateResult> avgResult {get;set;}
    public list<AggregateResult> avgResultQuant {get;set;}
    public list<AggregateResult> avgResultQuali {get;set;}
    public list<AggregateResult> avgResultTenure {get;set;}
    public list<AggregateResult> avgAnnualQuotaPer {get;set;}
    
    public Set<Id> certiTableId;
    public boolean updatenoti{get;set;}
    public boolean mngdis{get;set;}
    public boolean isPendingStatusUpdate{get; set;}    
    /* Filters */
            
    //Variable that indicates if logged in user is a manager
    private Boolean mgr;
    
    public Boolean isMgr{
        get{
            return mgr;
        }
        set{
            mgr = value;
        }
    }
    
    
    //Variable that indicates reset button has been clicked
    public boolean isReset {get; set;}
    
    
    //Variables to store the parameters passed in the URL
    public String label1 {get; set;}
    public String label2 {get; set;}
    public String label3 {get; set;}
    public String selectedLevel1 {get; set;}
    public String selectedLevel2 {get; set;}
    public String selectedLevel3 {get; set;}
    public String selectedLevel4 {get; set;}
    
    public String defaultBreadCrumb{get; set;}
    /* Filters */
    
    public String selectedId {get; set;}
    
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    
    Boolean readAccess;
    
    public String crumValue{get;set;}
    public String levelValue{get;set;}
    
    public Boolean RoleOverlay{get;set;}
    public Boolean RepOverlay{get;set;}
    
    public FunnelCertificationTable(){
        try{
            
            
            List<String> fldList1 = new List<String>{prefix+'Sales_Rep_Profile__c',prefix+'Overall_Rating__c',prefix+'Overall_Qualitative_Rating__c',prefix+'Overall_Quantitative_Rating__c'};
                
            readAccess = true;
            
            Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Certification__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList1){
                if(!fieldMap1.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            }
            
            List<String> fldList2 = new List<String>{prefix+'name',prefix+'User_Record_name__c',prefix+'Sales_Manager__c',prefix+'Rep_Staus__c',prefix+'Tenure_in_current_role__c'};                    
            
            Map <String, Schema.SObjectField> fieldMap2 = Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList2){
                
                if(!fieldMap2.get(fldName).getDescribe().isAccessible()){
                    system.debug(' fldName '+fldName);
                    readAccess = false;
                }                           
            }  
            
            List<String> fldList3 = new List<String>{prefix+'Sales_Rep_Profile__c',prefix+'Level_Value__c',prefix+'Level_Name__c'};
            
            Map <String, Schema.SObjectField> fieldMap3 = Schema.getGlobalDescribe().get(prefix+'Company_Level__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList3){
                
                if(!fieldMap3.get(fldName).getDescribe().isAccessible()){
                    system.debug(' fldName '+fldName);
                    readAccess = false;
                }                           
            }
            
            List<String> fldList4 = new List<String>{prefix+'Sales_Rep_Profile__c',prefix+'Company_Level__c'};
            
            Map <String, Schema.SObjectField> fieldMap4 = Schema.getGlobalDescribe().get(prefix+'Sales_Profile_Company_Level_Junction__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList4){
                
                if(!fieldMap4.get(fldName).getDescribe().isAccessible()){
                    system.debug(' fldName '+fldName);
                    readAccess = false;
                }                           
            } 
            
            if(readAccess){
              
                label1 = ApexPages.currentPage().getParameters().get('labelOne');
                label2 = ApexPages.currentPage().getParameters().get('labelTwo');
                label3 = ApexPages.currentPage().getParameters().get('labelThree');
                selectedLevel1 = ApexPages.currentPage().getParameters().get('selectOne');
                selectedLevel2 = ApexPages.currentPage().getParameters().get('selectTwo');
                selectedLevel3 = ApexPages.currentPage().getParameters().get('selectThree');
                selectedLevel4 = ApexPages.currentPage().getParameters().get('selectFour');  
                
                fw = new FunnelFilterWrapper();
                
                fw.userId = UserInfo.getUserId();
                
                FunnelFilterHelper.populateFilters(fw, 
                label1, label2, label3,
                selectedLevel1, selectedLevel2, selectedLevel3);
                
                /*FunnelFilterHelper.populateFilters1(fw, 
                                                   label1, label2, label3,
                                                   selectedLevel1, selectedLevel2, selectedLevel3, selectedLevel4);*/
                
                fw.labelFour = 'Filter By Representative';
                fw.levelFour = FunnelFilterHelper.populateLevelFour(fw,'');
                system.debug('in constructor :: '+fw.levelFour);
                
                if(selectedLevel4 != null && selectedLevel4 != '' && selectedLevel4 != 'ALL'){
                   fw.SelectedLevelFour  = selectedLevel4;
                }
                
                system.debug('fw.selectedLevelThree '+fw.selectedLevelThree);
                system.debug('fw.selectedLevelFour '+fw.selectedLevelFour);
                        
                showUpdated();
                
                defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw);
                system.debug('defaultBreadCrumb  fc contoller'+defaultBreadCrumb ); 
                /*
                managemenetReports = new Map<String,String>();
        
                User u = [SELECT Name, UserPreferencesLightningExperiencePreferred FROM User WHERE id = :UserInfo.getUserId()];
        
                List<String> dashList = new List<String>();
                dashList.add('mXaDybYGcSDujlyIRRJQxUrUEqXiFe');
        
                managemenetReports = FunnelNavigationHelper.fetchDashboards(dashList,u);*/                  
    
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(ex.getMessage()+' '+ex.getStackTraceString());  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }                    
    }
    
    private void findAvgDispNoti(){
        
        if(readAccess){
        //certiTable=[SELECT id,Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Rep_Staus__c,Sales_Rep_Profile__r.Tenure__c,Sales_Rep_Profile__r.id,Overall_Rating__c,Overall_Qualitative_Rating__c,Overall_Quantitative_Rating__c from Certification__c];
        avgResult = new list<AggregateResult>();                
        avgResultQuant = new list<AggregateResult>();
        avgResultTenure = new list<AggregateResult>();  
        avgResultQuali = new list<AggregateResult>();              
            
            //First row displays the average
            certiTableId = new set<id>();
            certiTableId= (new Map<Id,Certification__c>(certiTable)).keySet();
        system.debug(' certiTableId '+certiTableId);
        
        List<Certification__c> cr = [select  YTD_Quota_Percentage__c, Overall_Quantitative_Rating__c, Individual_Qualitative_Rating__c, Management_Qualitative_Score__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.New_or_Tenured__c,Sales_Rep_Profile__r.YTD_Revenue_Quota_Percent__c from Certification__c where id IN :certiTableId AND Sales_rep_profile__r.Active__c = TRUE];
        system.debug(' cr '+cr);        
        
        avgResult =[select  avg(YTD_Quota_Percentage__c) avgytd, avg(Overall_Rating__c) avgoverallFs, avg(Sales_Rep_Profile__r.YTD_Revenue_Quota_Percent__c) avgannualrev, avg(Overall_Qualitative_Rating__c) avgoverallqual, avg(Management_Qualitative_Score__c) avgmng  from Certification__c where id IN :certiTableId AND Sales_rep_profile__r.Active__c = TRUE];
        system.debug(' avgResult '+avgResult);
        
        avgResultTenure =[select avg(Management_Qualitative_Score__c) avgtenure  from Certification__c where id IN :certiTableId AND Sales_rep_profile__r.Active__c = TRUE];
            
            //Find if certifications are pending and set the boolean variable to display the notification
            List<Sales_Rep_Profile__c > cl = [SELECT id, name FROM Sales_Rep_Profile__c WHERE User_Record_Name__c= :UserInfo.getUserId() LIMIT 1];
            system.debug('cl pending'+cl );
           
        Set<id> mgid = new set<id>();
        if(cl != null && cl.size() >0 ){
        mgid.add(cl[0].id);
        }
        
        
        cl = [SELECT id, name  FROM Sales_Rep_Profile__c WHERE Interim_Manager__c IN :mgid ];
        
        for(Sales_Rep_Profile__c im: cl){
            mgid.add(im.id);
        }
        
        List<Sales_Rep_Profile__c> newRepsUnderMgr = [SELECT id FROM Sales_Rep_Profile__c WHERE Sales_Manager__c IN :mgid AND Rep_Staus__c = 'New' AND On_boarding_Date__c <= TODAY AND Active__c = TRUE];   
        
        if(newRepsUnderMgr != null && newRepsUnderMgr.size() > 0){
            isPendingStatusUpdate = true;
        }
        
        list<Sales_Rep_Profile__c > sp =[SELECT id,name from Sales_Rep_Profile__c where Sales_Manager__c IN :mgid AND Active__c = TRUE];
            system.debug('sp pending'+sp);
            
            set<id> spid= new set<id>();
            spid= (new Map<Id,Sales_Rep_Profile__c >(sp)).keySet();
            
            Map<Id,Certification__c> mapCerts = new Map<Id,Certification__c>([SELECT id FROM Certification__c WHERE Sales_Rep_Profile__c IN :spid AND Sales_rep_profile__r.Active__c = TRUE]);
            Set<id> certs = mapCerts.keySet();
            system.debug('certs pending'+certs );
            
            list<Certification_Answer__c> updatecerti = new list<Certification_Answer__c  >();
            updatecerti = [SELECT Rating_Start_Date__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id 
                          FROM Certification_Answer__c  WHERE  Rating_Start_Date__c <= today AND Rating_Score__c = null AND Certifcation__c IN :certs AND Sales_rep_profile__r.Active__c = TRUE];
              
              system.debug('updatecerti pending'+ updatecerti );  
             if(updatecerti != null && updatecerti.size()>0){
                 updatenoti = true;
             }else{
                 updatenoti = false;
             }   
         }
    }
    
    //Action method when level one is changed
    public void levelOneAction(){
        try{
            if(readAccess){
            
                FunnelFilterHelper.levelOneAction(fw);
                
                defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw);
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(ex.getMessage()+' '+ex.getStackTraceString());  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        } 
    }
    
    //Action method when level two is changed
    public void levelTwoAction(){
        try{
            if(readAccess){
            
                FunnelFilterHelper.levelTwoAction(fw);
                system.debug(' fw.labelOne '+fw.labelOne);
                system.debug(' fw.labelTwo '+fw.labelTwo);
                system.debug(' fw.labelThree '+fw.labelThree);
                
                system.debug(' fw.selectedLevelOne '+fw.selectedLevelOne );
                system.debug(' fw.selectedLevelTwo '+fw.selectedLevelTwo );
                system.debug(' fw.selectedLevelThree '+fw.selectedLevelThree );
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(ex.getMessage()+' '+ex.getStackTraceString());  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        } 
    }
    
    /*Filters*/
    //Method called when reset button is selected
    public PageReference reset(){
        /*        
        isReset = true;
        
        fw.userId = UserInfo.getUserId();  
        
        FunnelFilterHelper.reset(fw);
        */
        
            return FunnelNavigationHelper.navigateToCertification('','','','','','','');
             
    }
    
    /*Filters*/                  
    /*Aggregation*/
    public void showUpdated(){
        try{    
            
            RoleOverlay = false; 
            RepOverlay =false;
            fw.labelFour = 'Filter By Representative';

            system.debug('showupdate - mngRecord '+mngrecord);
            mngRecord = new list<Certification__c> ();
            
            isReset = false;
            
            if(readAccess){
                
                system.debug(' show updated '+fw.selectedLevelThree);
                if(fw.selectedLevelThree == 'All' && fw.selectedLevelFour == 'All'){            
                    List<Company_Level__c> cl = [SELECT Sales_Rep_Profile__c FROM Company_Level__c WHERE Level_Value__c = : fw.selectedLevelOne LIMIT 1];
                    system.debug('manager aggregate');
                    mgr = true;
                    //data(cl[0].Sales_Rep_Profile__c,'');
                    aggregate(cl[0].Sales_Rep_Profile__c);                
            
                }
                else if((fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All') || (fw.selectedLevelFour!='All' && fw.selectedLevelFour != null && fw.selectedLevelFour!='')){
                    Set<Id> s = new Set<Id>();
                    if(fw.selectedLevelFour != 'All' && fw.selectedLevelFour != ''){
                        s.add(fw.selectedLevelFour);
                    }else{
                    	s.add(fw.selectedLevelTwo);
                    }
                    
                    fetchSalesProfList(s);   
                    List<Company_Level__c> cl = [SELECT Sales_Rep_Profile__c FROM Company_Level__c WHERE Level_Value__c = : fw.selectedLevelOne LIMIT 1];
                    mgr = false; 
                    //data(cl[0].Sales_Rep_Profile__c,fw.selectedLevelTwo);
                    
                } 
                else if (fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
                    system.debug('role aggregates');
                    mgr = true;
                    aggregateOnRole();
                }
                
                system.debug(' certiTableId in show updated '+certiTableId);
                
                findAvgDispNoti();     
            }  
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(ex.getMessage()+' '+ex.getStackTraceString());  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }       
                           
    }
    
    public void aggregate(Id mgrId){
        
        if(readAccess){
            set<id> profs = new set<id>();
            List<Company_Level__c> cl = [SELECT id, Level_Value__c FROM Company_Level__c WHERE Sales_Rep_Profile__c = :mgrId];
            
        List<Sales_Profile_Company_Level_Junction__c> spCLJun = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :cl[0].Level_Value__c AND Sales_Rep_Profile__c != :mgrId AND Sales_rep_profile__r.Active__c = TRUE];
            
            for(Sales_Profile_Company_Level_Junction__c sj: spCLJun){
                 profs.add(sj.Sales_Rep_Profile__c);
            }
            
        mngRecord =[SELECT id,Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.New_or_Tenured__c,Sales_Rep_Profile__r.YTD_Revenue_Quota_Percent__c,Sales_Rep_Profile__r.Role__c,Sales_Rep_Profile__r.Rep_Staus__c,Sales_Rep_Profile__r.Tenure__c,Sales_Rep_Profile__r.id,Overall_Rating__c,Overall_Qualitative_Rating__c,Overall_Quantitative_Rating__c,YTD_Quota_Percentage__c,Management_Qualitative_Score__c from Certification__c WHERE Sales_Rep_Profile__c = :mgrId limit 1];
        mngdis = true;
        system.debug('aggregate - mngRecord '+mngRecord );
            fetchSalesProfList(profs); 
        }
    }
    
    private void fetchSalesProfList(Set<Id> profIds){
        
        if(readAccess){
                    
            system.debug(' profIds are '+profIds);
            avgAnnualQuotaPer = new list<AggregateResult>();
            Map<Id,Certification__c> mapCerts = new Map<Id,Certification__c>([SELECT id FROM Certification__c WHERE Sales_Rep_Profile__c IN :profIds AND Sales_rep_profile__r.Active__c = TRUE]);
            
            Set<id> certs = mapCerts.keySet();
            
            certiTableId = certs;
            
        	certiTable = [SELECT id,Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.Profile_Type__c,Sales_Rep_Profile__r.YTD_Revenue_Quota_Percent__c,Sales_Rep_Profile__r.New_or_Tenured__c,Sales_Rep_Profile__r.Role__c,Sales_Rep_Profile__r.Rep_Staus__c,Sales_Rep_Profile__r.Tenure__c,Sales_Rep_Profile__r.id,Overall_Rating__c,Overall_Qualitative_Rating__c,Overall_Quantitative_Rating__c,YTD_Quota_Percentage__c,Management_Qualitative_Score__c from Certification__c WHERE id IN :certs AND Sales_rep_profile__r.Active__c = TRUE ORDER BY Overall_Rating__c DESC];
         	avgAnnualQuotaPer = [select avg(Sales_Rep_Profile__r.YTD_Revenue_Quota_Percent__c) avgrev from Certification__c WHERE id IN :certs AND Sales_rep_profile__r.Active__c = TRUE];
            if(certiTable != null && certiTable.size() == 1){
             if(certiTable [0].Sales_Rep_Profile__r.Profile_Type__c != null && certiTable [0].Sales_Rep_Profile__r.Profile_Type__c == 'Overlay'){
                     
                    RepOverlay =true;
                }
         }  
            system.debug(' certiTableId in fetchSalesProfList '+certiTableId);      
        system.debug('fetchSalesProfList- mngrecord'+mngrecord); 
        }         
    }
    
    private void aggregateOnRole(){
        
        if(readAccess){
            
            //Fetch the junction objects that match the company level and role selected
            List<Sales_Profile_Company_Level_Junction__c> sReps = [SELECT Sales_Rep_Profile__c,Sales_Rep_Profile__r.Profile_Type__c, Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.New_or_Tenured__c, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree AND Sales_rep_profile__r.Active__c = TRUE];                
            System.debug('sReps --tc'+sReps);
            Set<String> levels = new Set<String>();
            
            Set<ID> aggregateIds = new Set<Id>();
            
            Set<ID> profIds = new Set<Id>();
            Boolean isOverlay = true;
            for(Sales_Profile_Company_Level_Junction__c s: sReps){
                profIds.add(s.Sales_Rep_Profile__c);
                aggregateIds.add(s.Sales_Rep_Profile__c);
                if(s.Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' ){
                    isOverlay = false;
                }
            }                
            RoleOverlay = isOverlay ;
            fetchSalesProfList(aggregateIds);
        }
    }
    /*Aggregation*/
    
    public List<SelectOption>  getRepSat() {
        
        List<SelectOption> Options = new List<SelectOption>();
        set<string> srpMngname = new set<string>();
        Options.add(new SelectOption('All','All Reps'));
        Options.add(new SelectOption('Tenured','Tenured Reps'));
        Options.add(new SelectOption('New','New Reps'));                
        return Options;
        
    }
              
    public void statusFilter(){
    
        try{
            system.debug(' certiTableId in status action '+certiTableId);
            system.debug(' mngRecord '+mngRecord);
            if(readAccess){
            
                if(repStatus != 'All'){
            certiTable =[SELECT id,Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.New_or_Tenured__c,Sales_Rep_Profile__r.Role__c,Sales_Rep_Profile__r.Rep_Staus__c,Sales_Rep_Profile__r.Tenure__c,Sales_Rep_Profile__r.id,Overall_Qualitative_Rating__c,Overall_Quantitative_Rating__c,Overall_Rating__c,YTD_Quota_Percentage__c,Sales_Rep_Profile__r.YTD_Revenue_Quota_Percent__c,Management_Qualitative_Score__c   from Certification__c where Sales_Rep_Profile__r.New_or_Tenured__c=:repStatus AND id IN :certiTableId AND Sales_rep_profile__r.Active__c = TRUE ORDER BY Overall_Rating__c DESC];
                    
                }else{
            certiTable =[SELECT id,Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.New_or_Tenured__c,Sales_Rep_Profile__r.Role__c,Sales_Rep_Profile__r.Rep_Staus__c,Sales_Rep_Profile__r.Tenure__c,Sales_Rep_Profile__r.id,Overall_Qualitative_Rating__c,Overall_Quantitative_Rating__c,Overall_Rating__c,YTD_Quota_Percentage__c,Sales_Rep_Profile__r.YTD_Revenue_Quota_Percent__c,Management_Qualitative_Score__c   from Certification__c WHERE id IN :certiTableId AND Sales_rep_profile__r.Active__c = TRUE ORDER BY Overall_Rating__c DESC];
                }
                
                Set<Id> filtCertiTableId = new set<id>();
                filtCertiTableId = (new Map<Id,Certification__c>(certiTable)).keySet();
        
        avgResult =[select  avg(YTD_Quota_Percentage__c) avgytd, avg(Overall_Rating__c) avgoverallFsv, avg(Sales_Rep_Profile__r.YTD_Revenue_Quota_Percent__c) avgannualrev,avg(Overall_Qualitative_Rating__c) avgoverallqual,avg(Management_Qualitative_Score__c) avgmng  from Certification__c where id IN :filtCertiTableId AND Sales_rep_profile__r.Active__c = TRUE];
                system.debug('avgResult s'+avgResult );
                /* avgResult =[select  avg(Overall_Rating__c) avgoverall  from Certification__c where id IN :certiTableId AND (Total_Qualitative_Weight__c > 0 OR Total_Quantitative_Weight__c > 0)];
                avgResultQuant =[select avg(Overall_Quantitative_Rating__c) avgoverallquan  from Certification__c where id IN :certiTableId AND  Total_Quantitative_Weight__c  > 0];
                avgResultQuali =[select  avg(Overall_Qualitative_Rating__c) avgoverallqual from Certification__c where id IN :certiTableId AND  Total_Qualitative_Weight__c > 0];
                avgResultTenure =[select avg(Sales_Rep_Profile__r.Tenure_in_current_role__c) avgtenure  from Certification__c where id IN :certiTableId ];
                  */
              }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(ex.getMessage()+' '+ex.getStackTraceString());  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        } 
    }
    
     public void breadCrumClick(){
      //  string role; 
      //  role = fw.SelectedLevelThree;
        fw = new FunnelFilterWrapper();
        fw.labelFour = 'Filter By Representative';
      /* List<Company_Level__c > company =  [SELECT Sales_Rep_Profile__r.User_Record_Name__c FROM Company_Level__c WHERE Level_Value__c = : crumValue LIMIT 1];      
        fw.userId = company[0].Sales_Rep_Profile__r.User_Record_Name__c;
        */
         system.debug('role'+fw.SelectedLevelThree);
        FunnelFilterHelper.onclickpopulateFilters(crumValue,fw);
        
        //defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw);
    }  
    /*Navigation*/
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToDashboard(){
        
        //return FunnelNavigationHelper.navigateToDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToCalculator(){
        
        return FunnelNavigationHelper.navigateToCalculator(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
         
    }
    
    public PageReference navigateToHomePage(){
        
        return FunnelNavigationHelper.navigateToHomePage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
         
    }
    
    //Method called on clicking Reporting on header    
    public PageReference navigateToReportsPage(){
        
        //return FunnelNavigationHelper.navigateToReportsPage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToReportsPage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    //Method called on clicking App Setup on header    
    public PageReference navigateToAppSetup(){
        
        return FunnelNavigationHelper.navigateToAppSetupPage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
         
    }
    public PageReference navigateToCertificateReports(){
        
        return FunnelNavigationHelper.navigateToCertificateReports(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
         
    }  
    
    public PageReference navigateToUpdatePage(){        
        
        PageReference redirect;
                
        if(fw.labelOne != null && fw.labelOne != '')
            redirect = new PageReference('/apex/FunnelCertificationupdate?labelOne='+fw.labelOne+'&labelTwo='+fw.labelTwo+'&labelThree='+fw.labelThree+'&selectOne='+fw.selectedLevelOne+'&selectTwo='+fw.selectedLevelTwo+'&selectThree='+fw.selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelCertificationupdate'); 
 
        redirect.setRedirect(true);     
        return redirect;
         
    } 
    
    public PageReference navigateToUpdateStatusPage(){
        
        PageReference redirect;
                
        if(fw.labelOne != null && fw.labelOne!= '')
            redirect = new PageReference('/apex/FunnelRepStatusUpdate?labelOne='+fw.labelOne+'&labelTwo='+fw.labelTwo+'&labelThree='+fw.labelThree+'&selectOne='+fw.selectedLevelOne+'&selectTwo='+fw.selectedLevelTwo+'&selectThree='+fw.selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelRepStatusUpdate'); 
 
        redirect.setRedirect(true);     
        return redirect;
        
    }
    
   
    
    public PageReference navigateToDetailPage(){        
           
        PageReference redirect;
                
        if(fw.labelOne != null && fw.labelOne != '')
            redirect = new PageReference('/apex/FunnelCerificationDetail?id='+selectedId+'&labelOne='+fw.labelOne+'&labelTwo='+fw.labelTwo+'&labelThree='+fw.labelThree+'&selectOne='+fw.selectedLevelOne+'&selectTwo='+fw.selectedLevelTwo+'&selectThree='+fw.selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelCerificationDetail?id='+selectedId); 
 
        redirect.setRedirect(true);     
        return redirect;
         
    }
    
    public PageReference navigateToAnalytics(){
        
        PageReference redirect;
                
        if(fw.labelOne != null && fw.labelOne != '')
            redirect = new PageReference('/apex/FunnelAnalytic?id='+selectedId+'&labelOne='+fw.labelOne+'&labelTwo='+fw.labelTwo+'&labelThree='+fw.labelThree+'&selectOne='+fw.selectedLevelOne+'&selectTwo='+fw.selectedLevelTwo+'&selectThree='+fw.selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelAnalytic?id='+selectedId); 
 
        redirect.setRedirect(true);     
        return redirect;
         
    }
    
    public PageReference navigateToFunnelAnalyticQualitative(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour); 
    } 
    
    public PageReference navigateToSalesPipeline(){
        
        return FunnelNavigationHelper.navigateToSalesPipeline(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToFunnelAnalytic(){
      
        //return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour); 
    }
    public PageReference navigateToAnnualizationDashboard(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
    	return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    public PageReference navigateToGoals(){
        
        return FunnelNavigationHelper.navigateToGoalsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    public PageReference navigateToTrendingByRep(){
        
        return FunnelNavigationHelper.navigateToTrendingByRep(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToTrndngRep(){
        
        return FunnelNavigationHelper.navigateToTrndngRep(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
        
    }
    
    public PageReference navigateToTrendingBySkill(){
        
        return FunnelNavigationHelper.navigateToTrendingBySkill(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    //Added for Help Menu - Rohit
    public PageReference navigateToHelpMenu(){
        
        return FunnelNavigationHelper.navigateToHelpMenu();
    
    }
    /*Navigation*/
    
}