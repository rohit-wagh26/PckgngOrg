/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelAnalyticQualitativeController{
    
    /*Public Map<String,String> managemenetReports{get;set;}
    
    
    public FunnelFilterWrapper fw {get; set;}
    public List<String> chartLabels {get;set;}  
    public List<String> chartLabelsM {get;set;} 
    public List<String> chartLabelsMR {get;set;}
    public List<Decimal> chartData {get;set;}
    
    public Date duedate;
    
        public List<Decimal> Lp{get;set;}
        public List<Decimal> Mp{get;set;}
        public List<Decimal> Ap{get;set;}
        public List<Decimal> Sp{get;set;}
        public List<Decimal> Hp{get;set;}
         
        
        public List<Decimal> Ex{get;set;}
        public List<Decimal> Go{get;set;}
        public List<Decimal> Sa{get;set;}
        public List<Decimal> Po{get;set;}
        public List<Decimal> Fa{get;set;}
        
        public List<Decimal> ExR{get;set;}
        public List<Decimal> GoR{get;set;}
        public List<Decimal> SaR{get;set;}
        public List<Decimal> PoR{get;set;}
        public List<Decimal> FaR{get;set;}
        public List<Decimal> FSR{get;set;}
          
        public String calculationType{get;set;} 
        public String role{get;set;}
    
    public List<String> pielabel {get;set;}
    public List<Id> pieid{get;set;}
    
    public List<Decimal> pieimp{get;set;}
    public Decimal piefs{get;set;}
    
    public List<Important_Rating__c> mdisplay{get;set;}
    public Id mid {get;set;}
    public string Mname{get;set;}
    
    public String sname{get;set;}
    
    public Boolean Fs{get;set;}
    public Boolean Ms{get;set;}
    
    public string rcid{get;set;}
    public boolean displayRec{get;set;}
    public List<Certification__c> cdisplay ;
    
    public  List<EvaluationGuidelines__c> guildlineList {get;set;}
    public Boolean displayPopup {get;set;}
    public String popClose{get;set;}
    
            
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
    public String crumValue{get;set;}
    public String levelValue{get;set;} 
    
    private Set<id> ratings;
    private List<Certification_rating__c> ratingRecs;
    
    public Boolean RoleOverlay{get;set;}
    public Boolean RepOverlay{get;set;}
    
    //used to store the value of role for single rep scenario
    private String roleVal;
    
    private List<Important_Rating__c> rats = new List<Important_Rating__c>();
    
    public FunnelAnalyticQualitativeController(){
        
        try{  
            
             displayRec = true;
            cdisplay = new List<Certification__c>();
            cdisplay = [Select Display_Recommendation__c from Certification__c where Sales_Rep_Profile__r.User_Record_Name__c = :UserInfo.getUserId() LIMIT 1];
            
            if(cdisplay != Null && cdisplay.size()>0){
                displayRec =cdisplay[0].Display_Recommendation__c ;
            }  
             
            label1 = ApexPages.currentPage().getParameters().get('labelOne');
            label2 = ApexPages.currentPage().getParameters().get('labelTwo');
            label3 = ApexPages.currentPage().getParameters().get('labelThree');
            selectedLevel1 = ApexPages.currentPage().getParameters().get('selectOne');
            selectedLevel2 = ApexPages.currentPage().getParameters().get('selectTwo');
            selectedLevel3 = ApexPages.currentPage().getParameters().get('selectThree');
            selectedLevel4 = ApexPages.currentPage().getParameters().get('selectFour');  
            
            fw = new FunnelFilterWrapper();
            
            fw.userId = UserInfo.getUserId();
            
            //FunnelFilterHelper.populateFilters(fw, 
            //label1, label2, label3,
            //selectedLevel1, selectedLevel2, selectedLevel3);
            
            FunnelFilterHelper.populateFilters1(fw, 
            label1, label2, label3,
            selectedLevel1, selectedLevel2, selectedLevel3, selectedLevel4);
            
            system.debug('selectedLevel1 '+selectedLevel1);
            system.debug('selectedLevel2 '+selectedLevel2);
            system.debug('selectedLevel3 '+selectedLevel3);
            system.debug('selectedLevel4 '+selectedLevel4);
            
            fetchPerfScores();
                    
            showUpdated();
            
            defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw); 
            
            guildlineList = [select id,name,Description__c,order__c from  EvaluationGuidelines__c ORDER BY order__c ASC limit 5];
            
            //if(fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
            //    fetchImportantMetricsForRole();
            //}         
            
         }
         catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelAnalyticQualitativeController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
         }
    }        
    
    public void fetchImportantMetricsForRole(){
    
        mdisplay = new List<Important_Rating__c>();
        //mdisplay=[Select id,Name,Importance__c From Certification_Rating__c where Important_flag__c = true And Assessment_type__c='Qualitative' order by Importance__c desc Limit 5  ];
        mdisplay= rats;
        
        system.debug(' mdisplay '+mdisplay);
        
        if( mdisplay != null && mdisplay.size()>0){
            mid= mdisplay[0].id;
            //Metric();
        }
        
        pielabel = new List<String>();
        pieimp = new List<Decimal>();
        pieid = new List<Id>();
        
        for(Important_Rating__c cr  : mdisplay ){
            if(cr.Importance_coefficient__c != null){
            pielabel.add(cr.Certification_Rating__r.name);
            pieimp.add(cr.Importance_coefficient__c);
                pieid.add(cr.id);
            }
        }
        system.debug(' pielabel '+pielabel );
    }
     
    //Action method when level one is changed
    public void levelOneAction(){
        FunnelFilterHelper.levelOneAction(fw);
        defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw);
    }
    
    //Action method when level two is changed
    public void levelTwoAction(){
        FunnelFilterHelper.levelTwoAction(fw);        
    }
    
    //Method called when reset button is selected
    public PageReference reset(){
       
        return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative('','','','','','','');
            
    }                 
    
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToDashboard(){
        
        //return FunnelNavigationHelper.navigateToDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
    	return FunnelNavigationHelper.navigateToDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToCalculator(){
        
        return FunnelNavigationHelper.navigateToCalculator(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToHomePage(){
        
        return FunnelNavigationHelper.navigateToHomePage(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
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
    
    public PageReference navigateToCertification(){
        
        //return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
    	return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToFunnelAnalyticQualitative(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
    	return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToTrendingByRep(){
        
        return FunnelNavigationHelper.navigateToTrendingByRep(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToTrendingBySkill(){
        
        return FunnelNavigationHelper.navigateToTrendingBySkill(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
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
    
    //Added for Help Menu - Rohit
    public PageReference navigateToHelpMenu(){
        
        return FunnelNavigationHelper.navigateToHelpMenu();
    
    }
    
    
    
    public void showUpdated(){
        try{ 
            RoleOverlay = false; 
            RepOverlay =false;
            
            rcid ='';
            metric();
             chartLabels = new list<String>();
             chartData = new list<Decimal>();
             Lp = new list<Decimal>();
             Mp = new list<Decimal>();
             Ap = new list<Decimal>();
             Sp = new list<Decimal>();
             Hp = new list<Decimal>();
              metricRowMap = new Map<String, tableWrapper>();      
               
             fetchPerfScores();
             
            system.debug('fw.selectedLevelTwo :: '+ fw.selectedLevelTwo);
            //Aggregates of a particular level value need to be done
            if(fw.selectedLevelThree == 'All'){
                //Fetch the sales profile record associated with that level
                List<Company_Level__c> cl = [SELECT Sales_Rep_Profile__c FROM Company_Level__c WHERE Level_Value__c = : fw.selectedLevelOne LIMIT 1];
                aggregate(cl[0].Sales_Rep_Profile__c);  // team aggregation method
                 mgr = true;
                fetchPerformerSet('team',fw.selectedLevelOne);                       
            }
            //A particular rep has been selected and his values need to be displayed
            else if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All'){
                singleRep(fw.selectedLevelTwo,null);   
                mgr = false;   
                fetchPerformerSet('rep',fw.selectedLevelTwo); 
                Sales_rep_profile__c sr = [SELECT Role__c,Profile_Type__c FROM Sales_rep_profile__c WHERE id = :fw.selectedLevelTwo];
                rcid = sr.id;
                system.debug('sr :: '+sr);
                if(sr.Profile_Type__c != null && sr.Profile_Type__c == 'Overlay'){
                     
                    RepOverlay =true;
                }
                system.debug('sr.Role__c :: '+ sr.Role__c);
                if(sr.Role__c != null){
                    system.debug('inside role');
                    roleVal = sr.Role__c;
                    fetchImpMetrics();  
                    fetchImportantMetricsForRole();  
                }                               
            }
            //A particular role has been selected 
            else if (fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
                system.debug('role aggregates');
                mgr = true;
                aggregateOnRole();
                fetchPerformerSet('role',fw.selectedLevelThree);  
                fetchImpMetrics();  
                fetchImportantMetricsForRole();                                      
              }
          }
          catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelAnalyticQualitativeController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
         }
     }
                    
    private void aggregateOnRole(){ 
           Boolean isOverlay = true;
           list<Certification__c> certlevel = new list<Certification__c>();
            sname = fw.SelectedLevelOne;
            
            //Fetch the company level record associated with the particular level
            List<Company_Level__c> cl = [SELECT id,Sales_Rep_Profile__c, Sales_Rep_Profile__r.name FROM Company_Level__c WHERE Level_Value__c = :fw.SelectedLevelOne];
            
            List<Company_Level__c> c2=[select id, Level_Value__c,Sales_Rep_Profile__c FROM Company_Level__c WHERE Sales_Rep_Profile__r.Sales_Manager__c = :cl[0].Sales_Rep_Profile__c AND Sales_Rep_Profile__r.Active__c = TRUE];
            
            set<string> levelnm = new set<string>();
            Set<id> cmid = new Set<id>();
            for(Company_Level__c c :c2){
                levelnm.add(c.Level_Value__c);
                cmid.add(c.Sales_Rep_Profile__c);
            }
            
            //Fetch the records at the selected level and role
            List<Sales_Profile_Company_Level_Junction__c> sReps = [SELECT Sales_Rep_Profile__c,Sales_Rep_Profile__r.Profile_Type__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree AND Sales_Rep_Profile__r.Active__c = TRUE];                
            
            Set<String> levels = new Set<String>();
            
            //List to store the ids of the reps to be aggregated
            Set<ID> aggregateIds = new Set<Id>();
            
            Set<ID> profIds = new Set<Id>();
            
            //Store the profile ids of the managers
            for(Sales_Profile_Company_Level_Junction__c s: sReps){
                profIds.add(s.Sales_Rep_Profile__c);
                aggregateIds.add(s.Sales_Rep_Profile__c);
                if(s.Sales_Rep_Profile__r.Profile_Type__c != 'Overlay' ){
                    isOverlay = false;
                }
            }
            RoleOverlay = isOverlay ;
            
               
            //Aggregate the results
            List<AggregateResult> r = [SELECT AVG(Overall_Rating__c) avor, AVG(Overall_Qualitative_Rating__c) avoq FROM Certification__c WHERE Sales_Rep_Profile__c IN :aggregateIds AND Sales_Rep_Profile__r.Role__c =:fw.SelectedLevelThree AND Sales_Rep_Profile__r.Active__c = TRUE] ;
            
            //Populate the wrapper
            if(r != null && r.size() > 0 && r[0].get('avoq') != null){   
                chartLabels.add(String.escapeSingleQuotes((String)fw.SelectedLevelOne)+' ('+String.valueOf(((Decimal)r[0].get('avoq')).setScale(2, RoundingMode.HALF_UP))+')');
                piefs = ((Decimal)r[0].get('avoq')).setScale(2, RoundingMode.HALF_UP);
            }else if(r != null && r.size() > 0){
                chartLabels.add(String.escapeSingleQuotes((String)fw.SelectedLevelOne)+' ('+ +')');
                //piefs = ((Decimal)r[0].get('avoq')).setScale(2, RoundingMode.HALF_UP);
            } 
            List<AggregateResult> rl = [SELECT count(id) c FROM Certification__c WHERE Sales_Rep_Profile__c IN :aggregateIds AND Overall_Qualitative_Rating__c < 2 AND Sales_Rep_Profile__r.Role__c =:fw.SelectedLevelThree AND Sales_Rep_Profile__r.Active__c = TRUE] ;
            List<AggregateResult> rm = [SELECT count(id) c FROM Certification__c WHERE Sales_Rep_Profile__c IN :aggregateIds AND Overall_Qualitative_Rating__c >= 2 AND Overall_Qualitative_Rating__c < 4 AND Sales_Rep_Profile__r.Role__c =:fw.SelectedLevelThree AND Sales_Rep_Profile__r.Active__c = TRUE] ;
            List<AggregateResult> ra = [SELECT count(id) c FROM Certification__c WHERE Sales_Rep_Profile__c IN :aggregateIds AND Overall_Qualitative_Rating__c >= 4 AND Overall_Qualitative_Rating__c < 7 AND Sales_Rep_Profile__r.Role__c =:fw.SelectedLevelThree AND Sales_Rep_Profile__r.Active__c = TRUE] ;
            List<AggregateResult> rs = [SELECT count(id) c FROM Certification__c WHERE Sales_Rep_Profile__c IN :aggregateIds AND Overall_Qualitative_Rating__c >= 7 AND Overall_Qualitative_Rating__c < 9 AND Sales_Rep_Profile__r.Role__c =:fw.SelectedLevelThree AND Sales_Rep_Profile__r.Active__c = TRUE] ;
            List<AggregateResult> rh = [SELECT count(id) c FROM Certification__c WHERE Sales_Rep_Profile__c IN :aggregateIds AND Overall_Qualitative_Rating__c >= 9 AND Overall_Qualitative_Rating__c <= 10 AND Sales_Rep_Profile__r.Role__c =:fw.SelectedLevelThree AND Sales_Rep_Profile__r.Active__c = TRUE] ;
            
            if(rl != null && rl .size() > 0){   
               if(rl[0].get('c') != null){
                        Lp.add((Decimal)rl[0].get('c'));
                    } else{
                        Lp.add(0);
                    }
            }
            if(rm != null && rm .size() > 0){   
               if(rm[0].get('c') != null){
                        Mp.add((Decimal)rm[0].get('c'));
                    } else{
                        Mp.add(0);
                    }
            }
            if(ra != null && ra.size() > 0){   
               if(ra[0].get('c') != null){
                        Ap.add((Decimal)ra[0].get('c'));
                    } else{
                        Ap.add(0);
                    }
            }
            if(rs != null && rs.size() > 0){   
               if(rs[0].get('c') != null){
                        Sp.add((Decimal)rs[0].get('c'));
                    } else{
                        Sp.add(0);
                    }
            }
            if(rh != null && rh.size() > 0){   
               if(rh[0].get('c') != null){
                        Hp.add((Decimal)rh[0].get('c'));
                    } else{
                        Hp.add(0);
                    }
            }
            
            
           //
            if( fw.labelTwo != 'Rep'){
                List<AggregateResult> r1 = [SELECT  Company_Level__r.Level_Value__c s, AVG(Certification__r.Overall_Rating__c) avor, AVG(Certification__r.Overall_Qualitative_Rating__c) avoq From Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levelnm AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree AND Sales_Rep_Profile__r.Active__c = TRUE Group by Company_Level__r.Level_Value__c Order by AVG(Certification__r.Overall_Qualitative_Rating__c) desc  ] ;
                    
                List<String> cn = new List<String>();
                for(AggregateResult c : r1){
                     cn.add(String.valueOf(c.get('s')));
                     
                     if(c.get('avoq') != null){
                        chartLabels.add(c.get('s')+' ('+ ((Decimal)(c.get('avoq'))).setScale(2, RoundingMode.HALF_UP)+')');
                     }else{
                        chartLabels.add(c.get('s')+' (0)'); 
                     }  
                    
                }
                
                 rl.clear();  
                 rm.clear();
                 ra.clear();
                 rs.clear();
                 rh.clear();
                 
                 rl = [SELECT  Company_Level__r.Level_Value__c s, count(id) c From Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :cn AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree AND Certification__r.Overall_Qualitative_Rating__c < 2 AND Sales_Rep_Profile__r.Active__c = TRUE Group by Company_Level__r.Level_Value__c Order by Company_Level__r.Level_Value__c asc ] ;
                 rm = [SELECT  Company_Level__r.Level_Value__c s, count(id) c From Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :cn AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree AND Certification__r.Overall_Qualitative_Rating__c >= 2 AND Certification__r.Overall_Qualitative_Rating__c < 4 AND Sales_Rep_Profile__r.Active__c = TRUE Group by Company_Level__r.Level_Value__c Order by Company_Level__r.Level_Value__c asc ] ;
                 ra = [SELECT  Company_Level__r.Level_Value__c s, count(id) c From Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :cn AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree AND Certification__r.Overall_Qualitative_Rating__c >= 4 AND Certification__r.Overall_Qualitative_Rating__c < 7 AND Sales_Rep_Profile__r.Active__c = TRUE Group by Company_Level__r.Level_Value__c Order by Company_Level__r.Level_Value__c asc ] ;
                 rs = [SELECT  Company_Level__r.Level_Value__c s, count(id) c From Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :cn AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree AND Certification__r.Overall_Qualitative_Rating__c >= 7 AND Certification__r.Overall_Qualitative_Rating__c < 9 AND Sales_Rep_Profile__r.Active__c = TRUE Group by Company_Level__r.Level_Value__c Order by Company_Level__r.Level_Value__c asc] ;
                 rh = [SELECT  Company_Level__r.Level_Value__c s, count(id) c From Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :cn AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree AND Certification__r.Overall_Qualitative_Rating__c >= 9 AND Certification__r.Overall_Qualitative_Rating__c <= 10 AND Sales_Rep_Profile__r.Active__c = TRUE Group by Company_Level__r.Level_Value__c Order by Company_Level__r.Level_Value__c asc] ;
                
                 for(String s : cn){
                    list<String> lps = new List<String>();
                    list<String> mps = new List<String>();
                    list<String> aps = new List<String>();
                    list<String> sps = new List<String>();
                    list<String> hps = new List<String>();
                     
                //     chartLabels.add(s);
                     
                     for(AggregateResult r3 : rl){
                         lps.add((String)r3.get('s'));
                         if(r3.get('s') != null && r3.get('s') == s ){
                             Lp.add((Decimal)r3.get('c'));
                         }
                     }
                     if(!lps.contains(s)){
                         Lp.add(0);
                     }
                     
                     for(AggregateResult r3 : rm){
                         mps.add((String)r3.get('s'));
                         if(r3.get('s') != null && r3.get('s') == s ){
                             Mp.add((Decimal)r3.get('c'));
                         }
                     }
                     if(!mps.contains(s)){
                         Mp.add(0);
                     }
                     
                     for(AggregateResult r2 : ra){
                         aps.add((String)r2.get('s'));
                         if(r2.get('s') != null && r2.get('s') == s ){
                             Ap.add((Decimal)r2.get('c'));
                         }
                     }
                     if(!aps.contains(s)){
                         Ap.add(0);
                     }
                     
                     for(AggregateResult r2 : rs){
                         sps.add((String)r2.get('s'));
                         if(r2.get('s') != null && r2.get('s') == s ){
                             Sp.add((Decimal)r2.get('c'));
                         }
                     }
                     if(!sps.contains(s)){
                         Sp.add(0);
                     }
                     
                     for(AggregateResult r4 : rh){
                         hps.add((String)r4.get('s'));
                         if(r4.get('s') != null && r4.get('s') == s ){
                             Hp.add((Decimal)r4.get('c'));
                         }
                     }
                     if(!hps.contains(s)){
                         Hp.add(0);
                     }
                     
                     
                 }
            }else if(fw.labelTwo == 'Rep'){
                
                List<Company_Level__c> cr1 = [SELECT Sales_Rep_Profile__c FROM Company_Level__c WHERE Level_Value__c = : fw.selectedLevelOne LIMIT 1];
                
                certlevel = [Select Overall_Qualitative_Rating__c, Overall_Quantitative_Rating__c, Overall_Rating__c,Sales_Rep_Profile__r.name from    Certification__c   where Sales_Rep_Profile__r.Sales_Manager__c = :cr1[0].Sales_Rep_Profile__c AND Sales_Rep_Profile__r.Role__c =: fw.SelectedLevelThree AND Sales_Rep_Profile__r.Active__c = TRUE order by Overall_Qualitative_Rating__c desc];
            
                for(Certification__c s:  certlevel){
                    if(s.Overall_Qualitative_Rating__c != null){    
                        chartLabels.add(s.Sales_Rep_Profile__r.name+' ('+String.valueOf((s.Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP))+')');
                       if((s.Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP) >= 9){
                        Lp.add(0);
                        Mp.add(0);
                        Ap.add(0);
                        Sp.add(0);
                        Hp.add(1);
                    }else if((s.Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP) >= 7){
                        Lp.add(0);
                        Mp.add(0);
                        Ap.add(0);
                        Sp.add(1);
                        Hp.add(0);
                    }else if((s.Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP) >= 4){
                        Lp.add(0);
                        Mp.add(0);
                        Ap.add(1);
                        Sp.add(0);
                        Hp.add(0);
                    }else if((s.Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP) >= 2){
                        Lp.add(0);
                        Mp.add(1);
                        Ap.add(0);
                        Sp.add(0);
                        Hp.add(0);
                    }else{
                        Lp.add(1);
                        Mp.add(0);
                        Ap.add(0);
                        Sp.add(0);
                        Hp.add(0);
                    }
                         
                        }else{
                         chartLabels.add(s.Sales_Rep_Profile__r.name+' ('+ +')');
                         Lp.add(0);
                         Mp.add(0);
                         Ap.add(0);
                         Sp.add(0);
                         Hp.add(0); 
                        }
                }
                
             }
        }
    
    private void singleRep(Id sr, Id ur){
        
        Set<Id> aggregateIds = new Set<Id>();
        aggregateIds.add(sr);
        
    
                     
        List<Certification__c>    s = new  List<Certification__c>();
          
        if(sr != null){
            s=[Select id,Overall_Qualitative_Rating__c, Overall_Quantitative_Rating__c, Overall_Rating__c,Sales_Rep_Profile__r.name from Certification__c   where Sales_Rep_Profile__c = :String.escapeSingleQuotes(sr) limit  1];
           sname= s[0].Sales_Rep_Profile__r.name;
        }
        
        if(s != null && s.size() > 0){ 
           
            if(s[0].Overall_Qualitative_Rating__c != null){
                chartLabels.add(String.escapeSingleQuotes(s[0].Sales_Rep_Profile__r.name)+' ('+String.valueOf((s[0].Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP))+')');
                piefs =    (s[0].Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP);
                if(s[0].Overall_Qualitative_Rating__c != null){
                    if((s[0].Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP) >= 9){
                        Lp.add(0);
                        Mp.add(0);
                        Ap.add(0);
                        Sp.add(0);
                        Hp.add(1); 
                    }else if((s[0].Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP) >= 7){
                        Lp.add(0);
                        Mp.add(0);
                        Ap.add(0);
                        Sp.add(1);
                        Hp.add(0); 
                    }else if((s[0].Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP) >= 4){
                        Lp.add(0);
                        Mp.add(0);
                        Ap.add(1);
                        Sp.add(0);
                        Hp.add(0); 
                    }else if((s[0].Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP) >= 2){
                        Lp.add(0);
                        Mp.add(1);
                        Ap.add(0);
                        Sp.add(0);
                        Hp.add(0); 
                    }else{
                        Lp.add(1);
                        Mp.add(0);
                        Ap.add(0);
                        Sp.add(0);
                        Hp.add(0); 
                    }
                }else{
                       chartLabels.add(String.escapeSingleQuotes(s[0].Sales_Rep_Profile__r.name)+' ('+ +')');
                       // piefs =    (s[0].Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP);
                        Lp.add(0);
                        Mp.add(0);
                        Ap.add(0);
                        Sp.add(0);
                        Hp.add(0);
                }
            }
               
        } 
              
    }
    
     public void aggregate(Id mgrId){
             sname = fw.SelectedLevelOne;
             list<Certification__c> certlevel = new list<Certification__c>();
             List<Sales_Rep_Profile__c> sRep = new List<Sales_Rep_Profile__c>();
            
            sRep = [Select id,User_Record_Name__c, name from Sales_Rep_Profile__c where id =:mgrId];
            
            List<Certification__c> mngRecord =[SELECT id,Overall_Rating__c,Overall_Qualitative_Rating__c,Overall_Quantitative_Rating__c,Management_Qualitative_Score__c from Certification__c WHERE Sales_Rep_Profile__c = :mgrId limit 1];
            
           
            //Aggregate the results
            
                
            if(mngRecord != null && mngRecord.size() > 0){   
                
                
                if(mngRecord[0].Overall_Qualitative_Rating__c != null){
                chartLabels.add(String.escapeSingleQuotes((String)fw.SelectedLevelOne)+' ('+String.valueOf((mngRecord[0].Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP))+')');
                piefs =(mngRecord[0].Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP);
                
                        chartData.add(mngRecord[0].Overall_Qualitative_Rating__c);
                    } else{
                        chartLabels.add(String.escapeSingleQuotes((String)fw.SelectedLevelOne)+' ('+ +')');
                        chartData.add(0);
                    }
              
              
            } 
            List<AggregateResult> rl = [SELECT count(id) c From Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Certification__r.Overall_Qualitative_Rating__c < 2 AND Sales_Rep_Profile__r.Active__c = TRUE] ;
            List<AggregateResult> rm = [SELECT count(id) c From Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Certification__r.Overall_Qualitative_Rating__c >= 2 AND Certification__r.Overall_Qualitative_Rating__c < 4 AND Sales_Rep_Profile__r.Active__c = TRUE] ;
            List<AggregateResult> ra = [SELECT count(id) c From Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Certification__r.Overall_Qualitative_Rating__c >= 4 AND Certification__r.Overall_Qualitative_Rating__c < 7 AND Sales_Rep_Profile__r.Active__c = TRUE] ;
            List<AggregateResult> rs = [SELECT count(id) c From Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Certification__r.Overall_Qualitative_Rating__c >= 7 AND Certification__r.Overall_Qualitative_Rating__c < 9 AND Sales_Rep_Profile__r.Active__c = TRUE] ;
            List<AggregateResult> rh = [SELECT count(id) c From Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Certification__r.Overall_Qualitative_Rating__c >= 9 AND Certification__r.Overall_Qualitative_Rating__c <= 10 AND Sales_Rep_Profile__r.Active__c = TRUE] ;
            
            if(rl != null && rl .size() > 0){   
               if(rl[0].get('c') != null){
                        Lp.add((Decimal)rl[0].get('c'));
                    } else{
                        Lp.add(0);
                    }
            }
            if(rm != null && rm .size() > 0){   
               if(rm[0].get('c') != null){
                        Mp.add((Decimal)rm[0].get('c'));
                    } else{
                        Mp.add(0);
                    }
            }
            if(ra != null && ra.size() > 0){   
               if(ra[0].get('c') != null){
                        Ap.add((Decimal)ra[0].get('c'));
                    } else{
                        Ap.add(0);
                    }
            }
            if(rs != null && rs.size() > 0){   
               if(rs[0].get('c') != null){
                        Sp.add((Decimal)rs[0].get('c'));
                    } else{
                        Sp.add(0);
                    }
            }
            if(rh != null && rh.size() > 0){   
               if(rh[0].get('c') != null){
                        Hp.add((Decimal)rh[0].get('c'));
                    } else{
                        Hp.add(0);
                    }
            }
            
             if(mgrId != null && fw.labelTwo != 'Rep'){
                system.debug(' 1 inside data  method');
                
                List<Sales_Rep_Profile__c> repundermng = [SELECT id,name FROM Sales_Rep_Profile__c WHERE Sales_Manager__c = :mgrId];
                Set<id> cmid = new Set<id>();
                
                for(Sales_Rep_Profile__c s : repundermng){
                    cmid.add(s.id);
                }
                List<Company_Level__c> complevelname = [select id,Certification__c,Level_Value__c,Certification__r.Overall_Qualitative_Rating__c,Certification__r.Overall_Rating__c,Sales_Rep_Profile__c from Company_Level__c where Sales_Rep_Profile__c IN :cmid AND Sales_Rep_Profile__r.Active__c = TRUE Order by Certification__r.Overall_Qualitative_Rating__c desc] ;
                
                List<String> cn = new List<String>();
                for(Company_Level__c c : complevelname){
                   if(c.Certification__c != null){
                       if(c.Certification__r.Overall_Qualitative_Rating__c != null){
                           chartLabels.add(c.Level_Value__c+' ('+String.valueOf((c.Certification__r.Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP))+')');
                           chartData.add(c.Certification__r.Overall_Qualitative_Rating__c);
                       }else{
                           chartLabels.add(c.Level_Value__c+'( )');
                           chartData.add(0);
                       }
                       
                       cn.add(c.Level_Value__c);
                       
                   }
                }
                
                 rl.clear();
                 rm.clear();
                 ra.clear();
                 rs.clear();                 
                 rh.clear();
                 
                 
                 rl = [SELECT  Company_Level__r.Level_Value__c s, count(id) c From Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :cn AND Certification__r.Overall_Qualitative_Rating__c < 2 AND Sales_Rep_Profile__r.Active__c = TRUE Group by Company_Level__r.Level_Value__c Order by Company_Level__r.Level_Value__c asc ] ;
                 rm = [SELECT  Company_Level__r.Level_Value__c s, count(id) c From Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :cn AND Certification__r.Overall_Qualitative_Rating__c >=2 AND Certification__r.Overall_Qualitative_Rating__c < 4 AND  Sales_Rep_Profile__r.Active__c = TRUE Group by Company_Level__r.Level_Value__c Order by Company_Level__r.Level_Value__c asc ] ;
                 ra = [SELECT  Company_Level__r.Level_Value__c s, count(id) c From Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :cn AND Certification__r.Overall_Qualitative_Rating__c >=4 AND Certification__r.Overall_Qualitative_Rating__c < 7 AND Sales_Rep_Profile__r.Active__c = TRUE Group by Company_Level__r.Level_Value__c Order by Company_Level__r.Level_Value__c asc ] ;
                 rs = [SELECT  Company_Level__r.Level_Value__c s, count(id) c From Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :cn AND Certification__r.Overall_Qualitative_Rating__c >=7 AND Certification__r.Overall_Qualitative_Rating__c < 9 AND Sales_Rep_Profile__r.Active__c = TRUE Group by Company_Level__r.Level_Value__c Order by Company_Level__r.Level_Value__c asc] ;
                 rh = [SELECT  Company_Level__r.Level_Value__c s, count(id) c From Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :cn AND Certification__r.Overall_Qualitative_Rating__c >=9 AND Certification__r.Overall_Qualitative_Rating__c <= 10 AND Sales_Rep_Profile__r.Active__c = TRUE Group by Company_Level__r.Level_Value__c Order by Company_Level__r.Level_Value__c asc] ;
                
                 for(String s : cn){
                    list<String> lps = new List<String>();
                    list<String> aps = new List<String>();
                    list<String> hps = new List<String>();
                    list<String> mps = new List<String>();
                    list<String> sps = new List<String>();
                     
                     //chartLabels.add(s);
                     
                     for(AggregateResult r : rl){
                         lps.add((String)r.get('s'));
                         if(r.get('s') != null && r.get('s') == s ){
                             Lp.add((Decimal)r.get('c'));
                         }
                     }
                     if(!lps.contains(s)){
                         Lp.add(0);
                     }
                     
                     for(AggregateResult r : rm){
                         mps.add((String)r.get('s'));
                         if(r.get('s') != null && r.get('s') == s ){
                             Mp.add((Decimal)r.get('c'));
                         }
                     }
                     if(!mps.contains(s)){
                         Mp.add(0);
                     }
                     
                     for(AggregateResult r2 : ra){
                         aps.add((String)r2.get('s'));
                         if(r2.get('s') != null && r2.get('s') == s ){
                             Ap.add((Decimal)r2.get('c'));
                         }
                     }
                     if(!aps.contains(s)){
                         Ap.add(0);
                     }
                     
                     for(AggregateResult r2 : rs){
                         sps.add((String)r2.get('s'));
                         if(r2.get('s') != null && r2.get('s') == s ){
                             Sp.add((Decimal)r2.get('c'));
                         }
                     }
                     if(!sps.contains(s)){
                         Sp.add(0);
                     }
                     
                     for(AggregateResult r1 : rh){
                         hps.add((String)r1.get('s'));
                         if(r1.get('s') != null && r1.get('s') == s ){
                             Hp.add((Decimal)r1.get('c'));
                         }
                     }
                     if(!hps.contains(s)){
                         Hp.add(0);
                     }
                     
                     
                 }
                 
            }else if(mgrId != null && fw.labelTwo == 'Rep'){
               system.debug(' 2 inside data  method');
               
                  
               //Population of Funnelocity Score
                List<Sales_Profile_Company_Level_Junction__c> cl = [SELECT id,Sales_Rep_Profile__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Active__c = TRUE];
                
                Set<Id> aggregateIds = new Set<Id>();
                
                for(Sales_Profile_Company_Level_Junction__c cj: cl){
                    aggregateIds.add(cj.Sales_Rep_Profile__c);    
                }
                
                certlevel = [Select Overall_Qualitative_Rating__c, Overall_Quantitative_Rating__c, Overall_Rating__c,Sales_Rep_Profile__r.name from    Certification__c   where Sales_Rep_Profile__r.Sales_Manager__c = :mgrId AND Sales_Rep_Profile__r.Active__c = TRUE order by Overall_Qualitative_Rating__c desc];
                
                for(Certification__c s:  certlevel){
                    if(s.Overall_Qualitative_Rating__c != null){    
                    chartLabels.add(s.Sales_Rep_Profile__r.name+' ('+String.valueOf((s.Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP))+')');
                   // chartData.add(s.Overall_Rating__c);
                    if((s.Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP) >= 9){
                        Lp.add(0);
                        Mp.add(0);
                        Ap.add(0);
                        Sp.add(0);
                        Hp.add(1);
                    }else if((s.Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP) >= 7){
                        Lp.add(0);
                        Mp.add(0);
                        Ap.add(0);
                        Sp.add(1);
                        Hp.add(0);
                    }else if((s.Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP) >= 4){
                        Lp.add(0);
                        Mp.add(0);
                        Ap.add(1);
                        Sp.add(0);
                        Hp.add(0);
                    }else if((s.Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP) >= 2){
                        Lp.add(0);
                        Mp.add(1);
                        Ap.add(0);
                        Sp.add(0);
                        Hp.add(0);
                    }else{
                        Lp.add(1);
                        Mp.add(0);
                        Ap.add(0);
                        Sp.add(0);
                        Hp.add(0);
                    }
                     
                    }else{
                     chartLabels.add(s.Sales_Rep_Profile__r.name+' ('+ +')');
                        Lp.add(0);
                        Mp.add(0);
                        Ap.add(0);
                        Sp.add(0);
                        Hp.add(0); 
                }
                }
                
              
            }
            
        }
    
     
    public void metric(){
        try{    
            List<Certification_Answer__c> c =[SELECT Due_Date__c ,Certifcation_Rating__r.name,Certifcation_Rating__r.Calculation_type__c FROM Certification_Answer__c where Certifcation_Rating__c =:mid AND Rating_Score__c != NULL AND Due_Date__c < today AND Sales_Rep_Profile__r.Active__c = TRUE ORDER BY Due_Date__c DESC LIMIT 1];
            if(c != null && c.size() > 0){
                duedate = c[0].Due_Date__c;
                calculationType = c[0].Certifcation_Rating__r.Calculation_type__c;
                Mname = c[0].Certifcation_Rating__r.name; 
            }
            system.debug('c-->'+c);
            system.debug('Mname -->'+Mname );
            
            chartLabelsM = new list<String>();
             Ex = new list<Decimal>();
             Go = new list<Decimal>();
             Sa = new list<Decimal>();
             Po = new list<Decimal>();
             Fa = new list<Decimal>(); 
              
             chartLabelsMR = new list<String>();
             ExR = new list<Decimal>();
             GoR = new list<Decimal>();
             SaR = new list<Decimal>();
             PoR = new list<Decimal>();
             FaR = new list<Decimal>();   
             Fsr= new list<Decimal>();      
             
            //Aggregates of a particular level value need to be done
            if((fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All') || fw.labelTwo == 'Rep' ){
                //Fetch the sales profile record associated with that level
                List<Company_Level__c> cl = [SELECT Sales_Rep_Profile__c,Sales_Rep_Profile__r.Sales_Manager__c FROM Company_Level__c WHERE Level_Value__c = : fw.selectedLevelOne LIMIT 1];
                if(fw.labelTwo == 'Rep'){
                     system.debug('cl[0].Sales_Rep_Profile__r.Sales_Manager__c--,'+ cl[0].Sales_Rep_Profile__r.Sales_Manager__c);
                      aggregateMetric(cl[0].Sales_Rep_Profile__r.Sales_Manager__c );
                } else{
                aggregateMetric(cl[0].Sales_Rep_Profile__c);  // team aggregation method
                }
                
                
                 mgr = true;
            }              
            
            reAssignScore();
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelAnalyticQualitativeController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
    }
    
    public void aggregateMetric(Id mgrId){
            Decimal rex = 0;
            Decimal rgo = 0;
            Decimal rsa = 0;
            Decimal rpo = 0;
            Decimal rfa = 0;
          
            String Level;
                if(fw.SelectedLevelThree == '' && fw.SelectedLevelTwo != 'All'){
                    List<Sales_Rep_Profile__c> srpc =[Select id, Role__c From Sales_Rep_Profile__c where id = :fw.SelectedLevelTwo];
                    role = srpc[0].Role__c ;
                }else{
                    role = fw.SelectedLevelThree;
                }
            list<Certification__c> certlevel = new list<Certification__c>();
            List<Sales_Rep_Profile__c> sRep = new List<Sales_Rep_Profile__c>();
            
            sRep = [Select id,User_Record_Name__c, name from Sales_Rep_Profile__c where id =:mgrId];
            List<Certification__c> mngRecord =[SELECT id,Overall_Rating__c,Overall_Qualitative_Rating__c,Overall_Quantitative_Rating__c,Management_Qualitative_Score__c from Certification__c WHERE Sales_Rep_Profile__c = :mgrId AND Sales_Rep_Profile__r.Active__c = TRUE limit 1];
            
           
            //Aggregate the results
             List<Sales_Profile_Company_Level_Junction__c>  spCLJun  = new List<Sales_Profile_Company_Level_Junction__c>();
            if(fw.labelTwo == 'Rep'){
                List<Company_Level__c> clc =[Select id ,Level_Value__c  from Company_Level__c where Sales_Rep_Profile__c =:mgrId AND Sales_Rep_Profile__r.Active__c = TRUE];
                spCLJun = [SELECT Sales_Rep_Profile__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :clc[0].Level_Value__c AND Sales_Rep_Profile__r.Role__c =:role AND Sales_Rep_Profile__r.Active__c = TRUE ];
                Level = clc[0].Level_Value__c;
            }else{
                spCLJun = [SELECT Sales_Rep_Profile__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c =:role AND Sales_Rep_Profile__r.Active__c = TRUE];
               Level =fw.SelectedLevelOne;
            }
            Set<Id> sr = new Set<Id>();
            for(Sales_Profile_Company_Level_Junction__c sj: spCLJun){
                 sr.add(sj.Sales_Rep_Profile__c);
            }
            List<Certification_Answer__c> crlist = [SELECT name,Certifcation_Rating__r.name, Rating_Score__c From Certification_Answer__c WHERE Sales_Rep_Profile__c IN :sr  AND Certifcation_Rating__c =:mid  AND Due_Date__c =:duedate AND Sales_Rep_Profile__r.Active__c = TRUE];
           // Mname= crlist[0].name;
            for(Certification_Answer__c c : crlist){
                //Mname=c.Certifcation_Rating__r.name;
                if(c.Rating_Score__c != null && c.Rating_Score__c == 10){
                    rex++;
                }else if(c.Rating_Score__c != null && c.Rating_Score__c == 8){
                    rgo++;
                }else if(c.Rating_Score__c != null && c.Rating_Score__c == 5){
                    rsa++;
                }else if(c.Rating_Score__c != null && c.Rating_Score__c == 2){
                    rpo++;
                }else if(c.Rating_Score__c != null && c.Rating_Score__c == 0){
                    rfa++;
                }
                
            }
            Decimal avgRating = 0;
            if(rex+rgo+rsa+rpo+rfa > 0){
                avgRating = ((rex*10) + (rgo*8) + (rsa*5) + (rpo*2) )/(rex+rgo+rsa+rpo+rfa);
            }
            if(mngRecord != null && mngRecord.size() > 0){   
                chartLabelsM.add(String.escapeSingleQuotes((String)Level  +' ('+avgRating.setScale(2, RoundingMode.HALF_UP))+')');
            } 
            
            Ex.add(rex );
            Go.add(rgo);
            Sa.add(rsa);
            Po.add(rpo); 
            Fa.add(rfa); 
             
            //&& fw.labelTwo != 'Rep'
             if(mgrId != null ){
                system.debug(' 1 inside data  method');
                
                List<Sales_Rep_Profile__c> repundermng = [SELECT id,name FROM Sales_Rep_Profile__c WHERE Sales_Manager__c = :mgrId AND Active__c = TRUE];
                Set<id> cmid = new Set<id>();
                
                for(Sales_Rep_Profile__c s : repundermng){
                    cmid.add(s.id);
                }
                List<Company_Level__c> complevelname = [select id,Level_Value__c,Certification__r.Overall_Qualitative_Rating__c,Certification__r.Overall_Rating__c,Sales_Rep_Profile__c from Company_Level__c where Sales_Rep_Profile__c IN :cmid AND Sales_Rep_Profile__r.Active__c = TRUE Order by Level_Value__c asc] ;
                //
                
                List<string> companyList = new List<string>();
                for(Company_Level__c c:complevelname ){
                    companyList.add(c.Level_Value__c);
                }
              
                system.debug(' 3 ');
                spCLJun = [SELECT Sales_Rep_Profile__c ,Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :companyList AND Sales_Rep_Profile__r.Role__c =:role AND Sales_Rep_Profile__r.Active__c = TRUE ]; 
            
                Map<string,Set<id>> companyRepIds = new Map<string,Set<id>>();
                sr = new Set<Id>();
                
                for(Sales_Profile_Company_Level_Junction__c sj1: spCLJun){
                    if(companyRepIds.keyset().contains(sj1.Company_Level__r.Level_Value__c)){
                        companyRepIds.get(sj1.Company_Level__r.Level_Value__c).add(sj1.Sales_Rep_Profile__c);
                    }else{
                         Set<id> wr = new Set<id>();
                         wr.add(sj1.Sales_Rep_Profile__c);
                         companyRepIds.put(sj1.Company_Level__r.Level_Value__c,wr);
                    }
                    sr.add(sj1.Sales_Rep_Profile__c); 
                }
                
                Map<String,List<Certification_Answer__c>> companylevelWithAnsList= new Map<String,List<Certification_Answer__c>>();
                List<Certification_Answer__c> crlistAllrep = [SELECT Rating_Score__c,Sales_Rep_Profile__c  From Certification_Answer__c WHERE Sales_Rep_Profile__c IN :sr  AND Certifcation_Rating__c =:mid  AND Due_Date__c =:duedate AND Sales_Rep_Profile__r.Active__c = TRUE ];
            
                for(String s :companyRepIds.keyset()){
                    set<id> repid = companyRepIds.get(s);
                    for(Certification_Answer__c a:crlistAllrep ){
                        if(companylevelWithAnsList.keyset().contains(s) && repid.contains(a.Sales_Rep_Profile__c )){
                            companylevelWithAnsList.get(s).add(a);
                        }else if(!companylevelWithAnsList.keyset().contains(s) && repid.contains(a.Sales_Rep_Profile__c )){
                             List<Certification_Answer__c> aL = new List<Certification_Answer__c>();
                             aL.add(a);
                             companylevelWithAnsList.put(s,aL);
                        }
                    
                    }
                
                }
                
                
                for(Company_Level__c c : complevelname){
                    
                    
                     rex = 0;
                     rgo = 0;
                     rsa = 0;
                     rpo = 0; 
                     rfa = 0;
                    List<Certification_Answer__c> crlistb = new List<Certification_Answer__c>();
                    if(companylevelWithAnsList.keyset().contains(c.Level_Value__c) && companylevelWithAnsList.get(c.Level_Value__c) != null){
                        crlistb = companylevelWithAnsList.get(c.Level_Value__c);
                    }
                    
                    for(Certification_Answer__c cb : crlistb){
                        
                        if(cb.Rating_Score__c != null && cb.Rating_Score__c == 10){
                            rex++;
                        }else if(cb.Rating_Score__c != null && cb.Rating_Score__c == 8){
                            rgo++;
                        }else if(cb.Rating_Score__c != null && cb.Rating_Score__c == 5){
                            rsa++;
                        }else if(cb.Rating_Score__c != null && cb.Rating_Score__c == 2){
                            rpo++;
                        }else if(cb.Rating_Score__c != null && cb.Rating_Score__c == 0){
                            rfa++;
                        } 
                    
                    }
                
                    Ex.add(rex );
                    Go.add(rgo);
                    Sa.add(rsa);
                    Po.add(rpo); 
                    Fa.add(rfa); 
                   
                    avgRating = 0;
                    if(rex+rgo+rsa+rpo+rfa > 0){
                        avgRating = ((rex*10) + (rgo*8) + (rsa*5) + (rpo*2) )/(rex+rgo+rsa+rpo+rfa);
                    }
                    chartLabelsM.add(c.Level_Value__c+' ('+avgRating.setScale(2, RoundingMode.HALF_UP)+')');
                }
                
                
            }
               Set<Id> aggregateIds = new Set<Id>();
               system.debug(' 6 ');
               if(fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
               system.debug('7');
                    List<Sales_Profile_Company_Level_Junction__c> clR = [SELECT id,Sales_Rep_Profile__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c =:fw.selectedLevelThree AND Sales_Rep_Profile__r.Active__c = TRUE];
                system.debug(' 8 ');     
                    
                    for(Sales_Profile_Company_Level_Junction__c cj: clR ){
                        aggregateIds.add(cj.Sales_Rep_Profile__c);    
                    }
               }else if(fw.SelectedLevelTwo != '' && fw.SelectedLevelTwo != 'All'){
                   aggregateIds.add(fw.SelectedLevelTwo);
                    }
                List<Certification_Answer__c> crlistr = [SELECT Rating_Score__c,Certifcation__r.Overall_Qualitative_Rating__c,Sales_Rep_Profile__r.name From Certification_Answer__c WHERE Sales_Rep_Profile__c IN :aggregateIds  AND Certifcation_Rating__c =:mid  AND Due_Date__c =:duedate AND Sales_Rep_Profile__r.Active__c = TRUE order by Rating_Score__c desc];
            
                    for(Certification_Answer__c cr : crlistr){
                        
                        if(cr.Rating_Score__c != null){
                            chartLabelsMR.add(cr.Sales_Rep_Profile__r.name +' ('+cr.Rating_Score__c+')');
                            
                            if(cr.Certifcation__r.Overall_Qualitative_Rating__c != null){
                                fsr.add((cr.Certifcation__r.Overall_Qualitative_Rating__c).setScale(2, RoundingMode.HALF_UP));
                            }
                             
                            if(cr.Rating_Score__c != null && cr.Rating_Score__c == 10){
                                
                                ExR.add(10);
                                GoR.add(0);
                                SaR.add(0);
                                PoR.add(0); 
                                FaR.add(0); 
                                
                            }else if(cr.Rating_Score__c != null && cr.Rating_Score__c == 8){
                                 
                                ExR.add(0);
                                GoR.add(8);
                                SaR.add(0);
                                PoR.add(0); 
                                FaR.add(0); 
                            }else if(cr.Rating_Score__c != null && cr.Rating_Score__c == 5){
                                 
                                ExR.add(0);
                                GoR.add(0);
                                SaR.add(5);
                                PoR.add(0); 
                                FaR.add(0); 
                            }else if(cr.Rating_Score__c != null && cr.Rating_Score__c == 2){
                                
                                ExR.add(0);
                                GoR.add(0);
                                SaR.add(0);
                                PoR.add(2); 
                                FaR.add(0);  
                            }else if(cr.Rating_Score__c != null && cr.Rating_Score__c == 0){
                       
                                ExR.add(0);
                                GoR.add(0);
                                SaR.add(0);
                                PoR.add(0); 
                                FaR.add(0);  
                            }else{
                                ExR.add(0);
                                GoR.add(0);
                                SaR.add(0);
                                PoR.add(0); 
                                FaR.add(0);  
                            }
                        } 
                   
                    }
                    for(Certification_Answer__c cr : crlistr){
                        
                        if(cr.Rating_Score__c == null){
                            chartLabelsMR.add(cr.Sales_Rep_Profile__r.name +' (Due)');
                            ExR.add(0);
                            GoR.add(0);
                            SaR.add(0);
                            PoR.add(0); 
                            FaR.add(0); 
                        }
                    }
            
        }
    
    /* private void singleRepMetric(Id sr, Id ur){
            
            Set<Id> aggregateIds = new Set<Id>();
            aggregateIds.add(sr);
            
            List<Certification_Answer__c>  s = new  List<Certification_Answer__c>();
              
            if(sr != null){
                s = [SELECT name,Certifcation_Rating__r.name,Rating_Score__c,Sales_Rep_Profile__r.name From Certification_Answer__c where Sales_Rep_Profile__c = :String.escapeSingleQuotes(sr) AND Certifcation_Rating__c =:mid AND Due_Date__c =:duedate AND Sales_Rep_Profile__r.Active__c = TRUE  limit  1];
            }
            
            if(s != null && s.size() > 0){ 
             //  Mname=s[0].Certifcation_Rating__r.name;
               chartLabelsM.add(String.escapeSingleQuotes(s[0].Sales_Rep_Profile__r.name)+' ('+s[0].Rating_Score__c+')');
                
                if(s[0].Rating_Score__c != null){
                    if(s[0].Rating_Score__c == 10){
                            Ex.add(1);
                            Go.add(0);
                            Sa.add(0);
                            Po.add(0); 
                            Fa.add(0); 
                        }else if(s[0].Rating_Score__c == 8){
                            Ex.add(0);
                            Go.add(1);
                            Sa.add(0);
                            Po.add(0); 
                            Fa.add(0); 
                        }else if(s[0].Rating_Score__c == 5){
                            Ex.add(0);
                            Go.add(0);
                            Sa.add(1);
                            Po.add(0); 
                            Fa.add(0); 
                        }else if(s[0].Rating_Score__c == 2){
                            Ex.add(0);
                            Go.add(0);
                            Sa.add(0);
                            Po.add(1); 
                            Fa.add(0);  
                        }else if(s[0].Rating_Score__c == 0){
                            Ex.add(0);
                            Go.add(0);
                            Sa.add(0);
                            Po.add(0); 
                            Fa.add(1);
                        }
                }else{
                        Ex.add(0);
                        Go.add(0);
                        Sa.add(0);
                        Po.add(0); 
                        Fa.add(0); 
                }
                
                   
            } 
                  
        }*/
    
   /* private void aggregateOnRoleMetric(){
            Decimal rex = 0;
            Decimal rgo = 0;
            Decimal rsa = 0;
            Decimal rpo = 0;
            Decimal rfa = 0;
            
            //Fetch the records at the selected level and role
            List<Sales_Profile_Company_Level_Junction__c> sReps = [SELECT Sales_Rep_Profile__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree AND Sales_Rep_Profile__r.Active__c = TRUE];                
            
            Set<String> levels = new Set<String>();
            
            //List to store the ids of the reps to be aggregated
            Set<ID> aggregateIds = new Set<Id>();
            
            Set<ID> profIds = new Set<Id>();
            
            //Store the profile ids of the managers
            for(Sales_Profile_Company_Level_Junction__c s: sReps){
                profIds.add(s.Sales_Rep_Profile__c);
                aggregateIds.add(s.Sales_Rep_Profile__c);
            }
            
            //Fetch the company levels associated with the sales profiles
            List<Company_Level__c> cl = [SELECT id, Level_Value__c FROM Company_Level__c WHERE Sales_Rep_Profile__c IN :profIds AND Sales_Rep_Profile__r.Active__c = TRUE];
            
            levels.clear();
            
            //Store all the levels associated with the managers
            for(Company_Level__c c: cl){
                levels.add(c.Level_Value__c);
            }
            
            //Fetch the sales profiles associated with the levels
            sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels AND Sales_Rep_Profile__r.Active__c = TRUE];
                    
            //Add the sales profiles to the ids to be aggregated        
            for(Sales_Profile_Company_Level_Junction__c s: sReps){
                aggregateIds.add(s.Sales_Rep_Profile__c);
            }
               
            //Aggregate the results
             
            List<Certification_Answer__c> crlist = [SELECT name,Certifcation_Rating__r.name, Rating_Score__c From Certification_Answer__c WHERE Sales_Rep_Profile__c IN :aggregateIds  AND Certifcation_Rating__c =:mid  AND Due_Date__c =:duedate AND Sales_Rep_Profile__r.Active__c = TRUE];
           // Mname= crlist[0].name;
            for(Certification_Answer__c c : crlist){
            //    Mname=c.Certifcation_Rating__r.name;
                if(c.Rating_Score__c != null && c.Rating_Score__c == 10){
                    rex++;
                }else if(c.Rating_Score__c != null && c.Rating_Score__c == 8){
                    rgo++;
                }else if(c.Rating_Score__c != null && c.Rating_Score__c == 5){
                    rsa++;
                }else if(c.Rating_Score__c != null && c.Rating_Score__c == 2){
                    rpo++;
                }else if(c.Rating_Score__c != null && c.Rating_Score__c == 0){
                    rfa++;
                }
                
            }
            Decimal avgRating = 0;
            if(rex+rgo+rsa+rpo+rfa > 0){
                avgRating = ((rex*10) + (rgo*8) + (rsa*5) + (rpo*2) )/(rex+rgo+rsa+rpo+rfa);
            }
              
                chartLabelsM.add(String.escapeSingleQuotes((String)fw.SelectedLevelOne +' ('+avgRating.setScale(2, RoundingMode.HALF_UP))+')');
             
            
            Ex.add(rex );
            Go.add(rgo);
            Sa.add(rsa);
            Po.add(rpo); 
            Fa.add(rfa); 
             
            
        }
      
     //Serealize the json object for VF page
     public String getCharLabels() {
        return JSON.serialize(chartLabels);
     }
     public String getCharLabelsM() {
        return JSON.serialize(chartLabelsM);
     }
     
     public String getCharLabelsMR() {
        return JSON.serialize(chartLabelsMR);
     }

     public String getFScores() {
        return JSON.serialize(chartData); // First graph - Funnelocity Score
     }
     
     public String getLps() {
        return JSON.serialize(Lp);  
     }
     public String getHps() {
        return JSON.serialize(Hp);  
     }
     public String getAps() {
        return JSON.serialize(Ap);  
     }
     public String getMps() {
        return JSON.serialize(Mp);  
     }
     public String getSps() {
        return JSON.serialize(Sp);  
     }
     
     public String getExs() {
        return JSON.serialize(Ex);  
     }
     public String getGos() {
        return JSON.serialize(Go);  
     }
     public String getSas() {
        return JSON.serialize(Sa);  
     }
     public String getPos() {
        return JSON.serialize(Po);  
     }
     public String getFas() {
        return JSON.serialize(Fa);  
     }
     
         public String getExsR() {
            return JSON.serialize(ExR);  
         }
         public String getGosR() {
            return JSON.serialize(GoR);  
         }
         public String getSasR() {
            return JSON.serialize(SaR);  
         }
         public String getPosR() {
            return JSON.serialize(PoR);  
         }
         public String getFasR() {
            return JSON.serialize(FaR);  
         }
         public String getfssr() {
            return JSON.serialize(fsr);  
         }
     public String getMnames() {
        return JSON.serialize(Mname);  
     }
    
     
    Decimal highPerfScore;
    
    Decimal lowPerfScore;
    
    public class tableWrapper implements Comparable{
        public id metricId {get; set;}
        public Integer rank {get; set;}
        public Decimal rankingScore {get; set;}
        public String metricName {get; set;}
        public Decimal imporCoeff {get; set;}
        public Decimal teamScore {get; set;}
        public Decimal lowPerfScore {get; set;}
        public Decimal avgPerfScore {get; set;}
        public Decimal highPerfScore {get; set;}
        public Decimal gap {get; set;} 
        
        
        public Integer compareTo(Object objToCompare) {
        
            if(rankingScore != null && objToCompare != null){
                if(rankingScore > ((tableWrapper)objToCompare).rankingScore){
                    return -1;
                }
                if(rankingScore == ((tableWrapper)objToCompare).rankingScore){
                    return 0;
                }
                return 1;
            }
            return 0;
        }
    }
    
    //Sort by Ranking
    //if(sortBy == SORT_BY.ByRanking){ 
        /*if(rankingScore != null && objToCompare != null){               
                return Integer.valueOf(((tableWrapper)objToCompare).rankingScore - rankingScore);
                //return Integer.valueOf(rankingScore - ((tableWrapper)objToCompare).rankingScore);
            else
                return null;
                
    //}                            
   
    private List<id> metricIds = new List<id>();
    
    public List<tableWrapper> tableVals {get; set;}                                
        
    Map<String, tableWrapper> metricRowMap = new Map<String, tableWrapper>(); 
    
    //List to store all sales profiles in the selected level
    List<id> profs = new List<id>();
    
    Map<Id,Important_Rating__c> certMap = new Map<Id,Important_Rating__c>();
    
    public String firstImp {get; set;}
    
    public String secondImp {get; set;}
    
    public List<Decimal> revenue {get; set;}
    
    public List<Decimal> scores {get; set;}
    
    Decimal revenueAtLevel;
    
    private void fetchPerfScores(){
        
        List<Certification__c> certScores = [SELECT id, Overall_Qualitative_Rating__c FROM Certification__c WHERE Sales_Rep_Profile__r.Active__c = TRUE ORDER BY Overall_Qualitative_Rating__c DESC LIMIT 5000 ];
        
        if(certScores != null && certScores.size() > 0){
            
            Integer i = certScores.size();
            Integer quarSize = (Integer)(i/4);
            
            highPerfScore = certScores[quarSize - 1].Overall_Qualitative_Rating__c;
            lowPerfScore = certScores[(quarSize * 3) - 1].Overall_Qualitative_Rating__c;            
        }
        
        List<AggregateResult> revenueLi = [SELECT AVG(Sales_Rep_Profile__r.YTD_Revenue__c) r, AVG(Overall_Qualitative_Rating__c) ovr FROM Certification__c WHERE Overall_Qualitative_Rating__c >= :highPerfScore AND Sales_Rep_Profile__r.Active__c = TRUE];
        revenue = new List<Decimal>();
        scores = new List<Decimal>();
        
        if(revenueLi != null && revenueLi.size() > 0 && revenueLi[0].get('r') != null){
            revenue.add(((Decimal)revenueLi[0].get('r')).setScale(2, RoundingMode.HALF_UP));                
        }
        else{
            revenue.add(0);
        }
        
        if(revenueLi != null && revenueLi.size() > 0 && revenueLi[0].get('ovr') != null){
            scores.add(((Decimal)revenueLi[0].get('ovr')).setScale(2, RoundingMode.HALF_UP));                
        }
        else{
            scores.add(0);
        }
        
        revenueLi = [SELECT AVG(Sales_Rep_Profile__r.YTD_Revenue__c) r, AVG(Overall_Qualitative_Rating__c) ovr FROM Certification__c WHERE Overall_Qualitative_Rating__c > :lowPerfScore AND Overall_Qualitative_Rating__c < :highPerfScore AND Sales_Rep_Profile__r.Active__c = TRUE];
        
        if(revenueLi != null && revenueLi.size() > 0 && revenueLi[0].get('r') != null){
            revenue.add(((Decimal)revenueLi[0].get('r')).setScale(2, RoundingMode.HALF_UP));    
        }
        else{
            revenue.add(0);
        }
        
        if(revenueLi != null && revenueLi.size() > 0 && revenueLi[0].get('ovr') != null){
            scores.add(((Decimal)revenueLi[0].get('ovr')).setScale(2, RoundingMode.HALF_UP));                
        }
        else{
            scores.add(0);
        }
        
        revenueLi = [SELECT AVG(Sales_Rep_Profile__r.YTD_Revenue__c) r, AVG(Overall_Qualitative_Rating__c) ovr FROM Certification__c WHERE Overall_Qualitative_Rating__c <= :lowPerfScore AND Sales_Rep_Profile__r.Active__c = TRUE];
        
        if(revenueLi != null && revenueLi.size() > 0 && revenueLi[0].get('r') != null){
            revenue.add(((Decimal)revenueLi[0].get('r')).setScale(2, RoundingMode.HALF_UP));    
        }
        else{
            revenue.add(0);
        }
        
        if(revenueLi != null && revenueLi.size() > 0 && revenueLi[0].get('ovr') != null){
            scores.add(((Decimal)revenueLi[0].get('ovr')).setScale(2, RoundingMode.HALF_UP));                
        }
        else{
            scores.add(0);
        }
    }
    
    private void fetchPerformerSet(String scenario, String param){                        
        system.debug(' scenario '+scenario);
        system.debug(' param '+param); 
        profs = new List<id>(); 
             
        if(scenario == 'team'){
        
            List<Sales_Profile_Company_Level_Junction__c> juncs = [SELECT Sales_Rep_Profile__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.level_value__c = :param AND Sales_Rep_Profile__r.Active__c = TRUE];  
            
            for(Sales_Profile_Company_Level_Junction__c j: juncs){
                profs.add(j.Sales_Rep_Profile__c);
            }              
        }
        else if (scenario == 'rep'){
            system.debug(fw.selectedLevelTwo);
            profs.add(fw.selectedLevelTwo);
            
        }
        else if (scenario == 'role'){
            //Fetch the records at the selected level and role
            List<Sales_Profile_Company_Level_Junction__c> sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Sales_Manager__c, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree AND Sales_Rep_Profile__r.Active__c = TRUE];                
            
            Set<String> levels = new Set<String>();
        
            //List to store the ids of the reps to be aggregated
            Set<ID> aggregateIds = new Set<Id>();
            
            Set<ID> profIds = new Set<Id>();
            
            //Store the profile ids of the managers
            for(Sales_Profile_Company_Level_Junction__c s: sReps){
                profIds.add(s.Sales_Rep_Profile__c);
                profs.add(s.Sales_Rep_Profile__c);
            }
            
      /*      //Fetch the company levels associated with the sales profiles
            List<Company_Level__c> cl = [SELECT id, Level_Value__c FROM Company_Level__c WHERE Sales_Rep_Profile__c IN :profIds AND Sales_Rep_Profile__r.Active__c = TRUE];
            
            levels.clear();
            
            //Store all the levels associated with the managers
            for(Company_Level__c c: cl){
                levels.add(c.Level_Value__c);
            }
            
            //Fetch the sales profiles associated with the levels
            sReps = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.Role__c, Company_Level__c, Company_Level__r.Level_Value__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c IN :levels AND Sales_Rep_Profile__r.Active__c = TRUE];
                    
            //Add the sales profiles to the ids to be aggregated        
            for(Sales_Profile_Company_Level_Junction__c s: sReps){
                profs.add(s.Sales_Rep_Profile__c);
            }   
        }
        
        List<AggregateResult>  ares = [SELECT AVG(YTD_Revenue__c) r FROM Sales_Rep_Profile__c WHERE id IN :profs AND Active__c = TRUE];
        if(ares != null && ares.size() > 0 && ares[0].get('r') != null){
            revenue.add(((Decimal)ares[0].get('r')).setScale(2, RoundingMode.HALF_UP));
            revenueAtLevel = ((Decimal)ares[0].get('r')).setScale(2, RoundingMode.HALF_UP);
        }
        else{
            revenue.add(0);
            revenueAtLevel = 0;
        }
        
        system.debug(' piefs is '+piefs);
        if(piefs != null){
            scores.add(piefs);
        }
        else{
            scores.add(0);
        }
        /*ares = [SELECT AVG(Overall_Rating__c) r FROM Certification__c WHERE Sales_Rep_Profile__c IN :profs];

        if(ares != null && ares.size() > 0 && ares[0].get('r') != null){
            scores.add(((Decimal)ares[0].get('r')).setScale(2, RoundingMode.HALF_UP));                
        }
        else{
            scores.add(0);
        } 
        
        system.debug(' profs '+profs);
        system.debug(' profs.size '+profs.size());
        system.debug(' revenue '+revenue);
        system.debug(' scores '+scores);                              
    }
    
    private void fetchImpMetrics (){                      
        
        metricRowMap = new Map<String, tableWrapper>();
        tableVals = new List<tableWrapper>();
        certMap = new Map<Id,Important_Rating__c>();
        
        rats = new List<Important_Rating__c>();
        //List<Certification_Rating__c> rats = [SELECT id, name, Importance__c FROM Certification_Rating__c  WHERE Important_flag__c = true AND Assessment_type__c = 'Qualitative'];
        if(fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All'){
            rats = [Select Importance_coefficient__c, Certification_Rating__c, Certification_Rating__r.name From Important_Rating__c where Role__c = :roleVal AND Certification_rating__r.Assessment_type__c='Qualitative' AND Certification_rating__r.Deactivated__c = false AND Importance_coefficient__c > 0 order by  Importance_coefficient__c desc];        
        }
        else{
            rats = [Select Importance_coefficient__c, Certification_Rating__c, Certification_Rating__r.name From Important_Rating__c where Role__c = :fw.selectedLevelThree AND Certification_rating__r.Assessment_type__c='Qualitative' AND Certification_rating__r.Deactivated__c = false AND Importance_coefficient__c > 0 order by  Importance_coefficient__c desc];        
        }
        
        List<Important_Rating__c> rat70 = new List<Important_Rating__c>();
        Decimal lim = 0;
        system.debug('rats :: '+rats);
        for(Important_Rating__c r :rats){
            if((lim < 70 || rat70.size() < 2) && rat70.size() < 6){
                rat70.add(r);
                lim += r.Importance_coefficient__c;
            }
        }
        
        if( rat70 != null && rat70.size() > 0){
            rats = rat70;
        }else if(rats != null){
            rats.clear();
        }
                
        for(Important_Rating__c r:rats){
            certMap.put(r.Certification_Rating__c,r);    
        }
        
        ratings = new Set<id>();
        
        ratingRecs = new List<Certification_Rating__c>();
        
        ratings = certMap.keySet();
        
        system.debug('ratings :: '+ratings);
        if(ratings != null && ratings.size() > 0){
            
            ratingRecs = [SELECT id FROM Certification_Rating__c WHERE id IN :ratings];
            
            List<AggregateResult> cres = [SELECT MAX(Due_Date__c) d, Certifcation_Rating__r.id cr FROM Certification_Answer__c WHERE Certifcation_rating__c IN :ratingRecs AND Rating_Score__c != null AND Certifcation_Rating__r.Timing__c = 'End of month' AND Certifcation_Rating__r.Assessment_type__c = 'Qualitative' AND Due_Date__c < today AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
            
            Date monthlyDueDate;
            
            if(cres != null && cres.size() > 0){
                monthlyDueDate = (Date)cres[0].get('d');
            }
            
            if(monthlyDueDate != null){        
                
                fetchScores('end of month',monthlyDueDate);                        
                
            }
            
            cres = [SELECT MAX(Due_Date__c) d, Certifcation_Rating__r.id cr FROM Certification_Answer__c WHERE Certifcation_rating__c IN :ratingRecs AND Rating_Score__c != null AND Certifcation_Rating__r.Timing__c = 'End of quarter' AND Certifcation_Rating__r.Assessment_type__c = 'Qualitative' AND Due_Date__c < today AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
            system.debug(' cres val '+cres);
            system.debug(' ratings val '+ratings );
             
            
            Date quarDueDate;
            
            if(cres != null && cres.size() > 0){
                quarDueDate = (Date)cres[0].get('d');
            }
            
            if(quarDueDate != null){        
                fetchScores('end of quarter',quarDueDate);                                    
            }
            
            cres = [SELECT MAX(Due_Date__c) d, Certifcation_Rating__r.id cr FROM Certification_Answer__c WHERE Certifcation_rating__c IN :ratingRecs AND Rating_Score__c != null AND Certifcation_Rating__r.Timing__c = 'Bi-annual' AND Certifcation_Rating__r.Assessment_type__c = 'Qualitative' AND Due_Date__c < today AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
            
            Date biAnnDueDate;
            
            if(cres != null && cres.size() > 0){
                biAnnDueDate = (Date)cres[0].get('d');
            }
            
            if(biAnnDueDate != null){        
                fetchScores('Bi-annual',biAnnDueDate);                                    
            }                   
            
            cres = [SELECT MAX(Due_Date__c) d, Certifcation_Rating__r.id cr FROM Certification_Answer__c WHERE Certifcation_rating__c IN :ratingRecs AND Rating_Score__c != null AND Certifcation_Rating__r.Timing__c = 'Annual' AND Certifcation_Rating__r.Assessment_type__c = 'Qualitative' AND Due_Date__c < today AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
            
            Date annDueDate;
            
            if(cres != null && cres.size() > 0){
                annDueDate = (Date)cres[0].get('d');
            }
            
            if(biAnnDueDate != null){        
                fetchScores('Annual',annDueDate);                                    
            }        
            
            findRankBasedOnGapAndImpCoeff();
            
            tableVals = metricRowMap.values();
                            
            system.debug(' tableVals  '+tableVals);
            
                for(tableWrapper t: tableVals){
                    if(t.teamScore == null){
                        t.teamScore = 0;
                    }
                }
                
            List<tableWrapper> finalTable = new List<tableWrapper>();
            
            for(tableWrapper t: tableVals){
                if(t.teamScore != null){
                    finalTable.add(t);
                }
            }
            
            tableVals = finalTable;
            
            tableVals.sort();
            
            if(tableVals != null && tableVals.size() > 0){        
                firstImp = tableVals[tableVals.size() - 1].metricName;
            }
            
            if(tableVals != null && tableVals.size() > 1){       
                secondImp = tableVals[tableVals.size() - 2].metricName;
            }
            
            findRanking();
            
            tableVals = metricRowMap.values();
                            
            system.debug(' tableVals  '+tableVals);
            
            finalTable = new List<tableWrapper>();
            
            for(tableWrapper t: tableVals){
                    if(t.teamScore == null){
                        t.teamScore = 0;
                    }
                }
                
                for(tableWrapper t: tableVals){
                if(t.teamScore != null){
                    finalTable.add(t);
                }
            }
            
            tableVals = finalTable;
            
            tableVals.sort();
            assignRank();                
            
            system.debug(' sorted tableVals  '+tableVals);
        }
    }
    
    private void fetchScores(String timing, Date dueDate){
        
        List<AggregateResult> ares = [SELECT AVG(Rating_Score__c) r, Certifcation_Rating__r.id rid FROM Certification_Answer__c WHERE Certifcation_Rating__r.timing__c = :timing AND Certifcation_Rating__r.Assessment_type__c = 'Qualitative' AND Certifcation_Rating__c IN :ratingRecs AND Due_Date__c = :dueDate AND Certifcation__r.Overall_Qualitative_Rating__c >= :highPerfScore AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
        system.debug(' ares '+ares);    
        for(AggregateResult r: ares){
            if(r.get('r') != null){
                if(!metricRowMap.containsKey((id)r.get('rid')) && r.get('r') != null){
                    tableWrapper tw = new tableWrapper();
                    tw.metricId = (id)r.get('rid');
                    tw.metricName = certMap.get((id)r.get('rid')).Certification_Rating__r.name;
                    tw.imporCoeff = certMap.get((id)r.get('rid')).Importance_coefficient__c;
                    
                    tw.highPerfScore = ((Decimal)r.get('r')).setScale(2, RoundingMode.HALF_UP);
                    metricRowMap.put(tw.metricId,tw);
                } 
                else{
                    metricRowMap.get((id)r.get('rid')).highPerfScore = ((Decimal)r.get('r')).setScale(2, RoundingMode.HALF_UP);
                
                }   
            }
        }
        
        ares = [SELECT AVG(Rating_Score__c) r, Certifcation_Rating__r.id rid FROM Certification_Answer__c WHERE Certifcation_Rating__r.timing__c = :timing AND Certifcation_Rating__r.Assessment_type__c = 'Qualitative' AND Certifcation_Rating__c IN :ratingRecs AND Due_Date__c = :dueDate AND Certifcation__r.Overall_Qualitative_Rating__c <= :lowPerfScore AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
        
        for(AggregateResult r: ares){
            if(r.get('r') != null){
                if(!metricRowMap.containsKey((id)r.get('rid')) && r.get('r') != null){
                    tableWrapper tw = new tableWrapper();
                    tw.metricId = (id)r.get('rid');
                    tw.metricName = certMap.get((id)r.get('rid')).Certification_rating__r.name;
                    tw.imporCoeff = certMap.get((id)r.get('rid')).Importance_coefficient__c;
                    
                    tw.lowPerfScore = ((Decimal)r.get('r')).setScale(2, RoundingMode.HALF_UP);
                    metricRowMap.put(tw.metricId,tw);
                } 
                else{
                    metricRowMap.get((id)r.get('rid')).lowPerfScore = ((Decimal)r.get('r')).setScale(2, RoundingMode.HALF_UP);
                
                }   
            }
        }                
        
        ares = [SELECT AVG(Rating_Score__c) r, Certifcation_Rating__r.id rid FROM Certification_Answer__c WHERE Certifcation_Rating__r.timing__c = :timing AND Certifcation_Rating__r.Assessment_type__c = 'Qualitative' AND Certifcation_Rating__c IN :ratingRecs AND Due_Date__c = :dueDate AND Certifcation__r.Overall_Qualitative_Rating__c < :highPerfScore AND Certifcation__r.Overall_Qualitative_Rating__c > :lowPerfScore AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
        
        for(AggregateResult r: ares){
            if(r.get('r') != null){
                if(!metricRowMap.containsKey((id)r.get('rid'))){
                    tableWrapper tw = new tableWrapper();
                    tw.metricId = (id)r.get('rid');
                    tw.metricName = certMap.get((id)r.get('rid')).Certification_rating__r.name;
                    tw.imporCoeff = certMap.get((id)r.get('rid')).Importance_coefficient__c;
                    
                    tw.avgPerfScore = ((Decimal)r.get('r')).setScale(2, RoundingMode.HALF_UP);
                    metricRowMap.put(tw.metricId,tw);
                } 
                else{
                    metricRowMap.get((id)r.get('rid')).avgPerfScore = ((Decimal)r.get('r')).setScale(2, RoundingMode.HALF_UP);
                
                }   
            }
        }
        
        ares = [SELECT AVG(Rating_Score__c) r, Certifcation_Rating__r.id rid FROM Certification_Answer__c WHERE Certifcation_Rating__r.timing__c = :timing AND Certifcation_Rating__r.Assessment_type__c = 'Qualitative'AND Certifcation_Rating__c IN :ratingRecs AND Due_Date__c = :dueDate AND Sales_rep_profile__c IN :profs AND Sales_Rep_Profile__r.Active__c = TRUE GROUP BY Certifcation_Rating__r.id];
        system.debug(' team score is '+ares);
        for(AggregateResult r: ares){
            if(r.get('r') != null){
                if(!metricRowMap.containsKey((id)r.get('rid')) && r.get('r') != null){
                    tableWrapper tw = new tableWrapper();
                    tw.metricId = (id)r.get('rid');
                    tw.metricName = certMap.get((id)r.get('rid')).Certification_rating__r.name;
                    tw.imporCoeff = certMap.get((id)r.get('rid')).Importance_coefficient__c;
                    
                    tw.teamScore = ((Decimal)r.get('r')).setScale(2, RoundingMode.HALF_UP);
                    metricRowMap.put(tw.metricId,tw);
                } 
                else{
                    metricRowMap.get((id)r.get('rid')).teamScore = ((Decimal)r.get('r')).setScale(2, RoundingMode.HALF_UP);
                
                } 
            }  
        }
                
    }
    
    private void findRanking(){
        for(String key: metricRowMap.keySet()){
           
            if(metricRowMap.get(key).teamScore  != null && metricRowMap.get(key).highPerfScore != null){
                metricRowMap.get(key).gap = (metricRowMap.get(key).teamScore - metricRowMap.get(key).highPerfScore).setScale(2, RoundingMode.HALF_UP); 
            } 
            
            if(metricRowMap.get(key).imporCoeff != null){
                metricRowMap.get(key).rankingScore = (metricRowMap.get(key).imporCoeff).setScale(6, RoundingMode.HALF_UP);
            }
                       
        }    
    }
    
    private void findRankBasedOnGapAndImpCoeff(){
        for(String key: metricRowMap.keySet()){
           
            if(metricRowMap.get(key).teamScore  != null && metricRowMap.get(key).highPerfScore != null){
                metricRowMap.get(key).gap = (metricRowMap.get(key).teamScore - metricRowMap.get(key).highPerfScore).setScale(2, RoundingMode.HALF_UP); 
            } 
            
            if(metricRowMap.get(key).gap != null && metricRowMap.get(key).imporCoeff != null){
                metricRowMap.get(key).rankingScore = (metricRowMap.get(key).gap * metricRowMap.get(key).imporCoeff).setScale(6, RoundingMode.HALF_UP);
            }
                       
        }    
    }
    
    private void assignRank(){
        Integer i = 1;
        for(tableWrapper t:tableVals){
            t.rank = i;
            i++;
        }
    }
    
    public void reAssignScore(){
        system.debug(' metricRowMap '+metricRowMap);
        if(mId != null && metricRowMap.get(mId) != null){
            scores[0] = metricRowMap.get(mId).highPerfScore; 
            scores[1] = metricRowMap.get(mId).avgPerfScore; 
            scores[2] = metricRowMap.get(mId).lowPerfScore;
            if(metricRowMap.get(mId).teamScore != null){ 
                scores[3] = metricRowMap.get(mId).teamScore;
            } 
            else{
                scores[3] = 0;
            } 
        }           
    }
    
    public void assignFs(){
        fetchPerfScores();
        system.debug(' piefs '+piefs);
        if(piefs != null){
            scores.add(piefs);
        }
        else{
            scores.add(0);
        }
        
        if(revenueAtLevel != null){
            revenue.add(revenueAtLevel);
        }
        else{
            revenue.add(0);
        }
        system.debug(' scores '+scores);
    }
    
   
      
      public void breadCrumClick(){
  
        fw = new FunnelFilterWrapper();
        FunnelFilterHelper.onclickpopulateFilters(crumValue,fw);
     } 
     
     public String selectedId {get; set;}
    public PageReference navigateToDetailPage(){        
           
        PageReference redirect;
                
        if(fw.labelOne != null && fw.labelOne != '')
            redirect = new PageReference('/apex/FunnelCerificationDetail?id='+selectedId+'&labelOne='+fw.labelOne+'&labelTwo='+fw.labelTwo+'&labelThree='+fw.labelThree+'&selectOne='+fw.selectedLevelOne+'&selectTwo='+fw.selectedLevelTwo+'&selectThree='+fw.selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelCerificationDetail?id='+selectedId); 
 
        redirect.setRedirect(true);     
        return redirect;
         
    }   
    
     public void updateRec(){
        if(cdisplay !=null && cdisplay.size()>0){
            cdisplay[0].Display_Recommendation__c = displayRec;
            update cdisplay[0];
        }
    }
    
    public void popup(){
        if(popClose == 'pop'){
            displayPopup = true;
        }else if(popClose == 'close'){
            displayPopup = false;
        }
    }*/
}