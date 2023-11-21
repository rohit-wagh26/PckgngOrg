/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelAnnualizationDashboardController{
    
    Public Map<String,String> managemenetReports{get;set;}
        
    public FunnelFilterWrapper fw {get; set;}
    public List<String> chartLabels {get;set;}  
    public List<Decimal> chartData {get;set;}
    
    public List<String> chart24Months {get;set;}  
    public List<Decimal> chart24Data {get;set;}
    
    public List<String> chart12Months {get;set;}  
    public List<Decimal> chart12Data {get;set;}
    
    public Decimal avg12MonthRevenue{get;set;}
    public Decimal avgYTD{get;set;}
    public Decimal chart1YaxisMax{get;set;}
    public Decimal chart2YaxisMax{get;set;}
    public Decimal chart3YaxisMax{get;set;}
    
    public Decimal chart4YaxisMax{get;set;}
    public Decimal chart4XaxisMax{get;set;}
    
    public Decimal chart5XaxisMax{get;set;}
    
    
    public String role{get;set;}
    public String sname{get;set;}
    
     
    public Map<String, Decimal> roleValue ;  
     public Map<String, Decimal> roleYTDValue ;  
    public Date snapLastYear ; 
    public Integer fiscalYear{get;set;}  
    
    
    public Map<String,List<Decimal>> newReplist{get;set;}
    public List<Certification__c> bubblechart{get;set;}
    
    public List<Certification__c> bubblechart2{get;set;}
    
    public Decimal needimprovement{get;set;}
    public Decimal marginal{get;set;}
    public Decimal average{get;set;}
    public Decimal strong{get;set;}
    
    public Decimal needimprovementYTD{get;set;}
    public Decimal marginalYTD{get;set;}
    public Decimal averageYTD{get;set;}
    public Decimal strongYTD{get;set;}
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
    public String crumValue{get;set;}
    public String levelValue{get;set;}
      
    public Boolean RoleOverlay{get;set;}
    public Boolean RepOverlay{get;set;} 
    
    /* Filters */        
    
    //used to store the value of role for single rep scenario
    private String roleVal;
    
    
    
    public FunnelAnnualizationDashboardController(){
        try{ 
            
             needimprovement = 0 ;
             marginal = 0 ;
             average = 0 ;
             strong = 0 ;
             
             needimprovementYTD = 0 ;
             marginalYTD = 0 ;
             averageYTD = 0 ;
             strongYTD = 0 ;
          
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
            selectedLevel1, selectedLevel2, selectedLevel3,selectedLevel4);*/
            
            system.debug('fw.selectedLevelThree '+fw.selectedLevelThree);
            
            
            fw.labelFour = 'Filter By Representative';
            fw.levelFour = FunnelFilterHelper.populateLevelFour(fw,'');
            system.debug('in constructor :: '+fw.levelFour);
            
            if(selectedLevel4 != null && selectedLevel4 != '' && selectedLevel4 != 'ALL'){
                fw.SelectedLevelFour  = selectedLevel4;
            }
            
            createMapOfRoleAndAvgRevenue(); 
            createMapOfRoleAndAvgYTD();
            showUpdated();
            
            defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw); 
            
            /*
            if(fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
                fetchImportantMetricsForRole();
            }*/      

         }
         catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());  
                 
               
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
    }        
    
    
     
     
    //Action method when level one is changed
    public void levelOneAction(){
        FunnelFilterHelper.levelOneAction(fw);
        defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw);
    }
    
    //Action method when level two is changed
    public void levelTwoAction(){
        FunnelFilterHelper.levelTwoAction(fw);
        defaultBreadCrumb = FunnelFilterHelper.fetchDefaultBreadCrumbs(fw);       
    }
    
    /*Filters*/
    //Method called when reset button is selected
    public PageReference reset(){
       
        return FunnelNavigationHelper.navigateToFunnelAnalytic('','','','','','','');
            
    }
    /*Filters*/                  
    
    
    
    
    public void showUpdated(){
        try{
            system.debug('fw.selectedLevelThree '+fw.selectedLevelThree);
             
             RoleOverlay = false; 
             RepOverlay =false;
             fw.labelFour = 'Filter By Representative';
             
             chartLabels = new list<String>();
             chartData = new list<Decimal>();
             
             chart24Months = new list<String>();
             chart24Data = new list<Decimal>();
             
             chart12Months = new list<String>();
             chart12Data = new list<Decimal>();
             
             newReplist = new Map<String,List<Decimal>>();
            
            //Aggregates of a particular level value need to be done
            if(fw.selectedLevelThree == 'All' && fw.selectedLevelFour == 'All'){
                //Fetch the sales profile record associated with that level
                List<Company_Level__c> cl = [SELECT Sales_Rep_Profile__c FROM Company_Level__c WHERE Level_Value__c = : fw.selectedLevelOne LIMIT 1];
                aggregate(cl[0].Sales_Rep_Profile__c);  // team aggregation method
                 mgr = true;
                                       
            }
            //A particular rep has been selected and his values need to be displayed
            else if((fw.labelTwo == 'Rep' && fw.selectedLevelTwo != 'All') || (fw.selectedLevelFour!='All' && fw.selectedLevelFour != null && fw.selectedLevelFour!='')){
                 String role = '';
                if(fw.selectedLevelFour != 'All' && fw.selectedLevelFour != ''){
                    role = [Select id , Role__c from Sales_Rep_Profile__c  where id =:fw.selectedLevelFour].Role__c;
                    populateAvg12MonthRevenue(role);
                    singleRep(fw.selectedLevelFour,null); 
                	monthChart24(role);   
                	Sales_rep_profile__c sr = [SELECT id, name,Role__c,Profile_Type__c FROM Sales_rep_profile__c WHERE id = :fw.selectedLevelFour]; 
                }else{
                    role = [Select id , Role__c from Sales_Rep_Profile__c  where id =:fw.selectedLevelTwo].Role__c;
                    populateAvg12MonthRevenue(role);
                    
                    singleRep(fw.selectedLevelTwo,null); 
                    monthChart24(role);
                    mgr = false;   
                    Sales_rep_profile__c sr = [SELECT id, name,Role__c,Profile_Type__c FROM Sales_rep_profile__c WHERE id = :fw.selectedLevelTwo]; 
                    if(sr.Profile_Type__c != null && sr.Profile_Type__c == 'Overlay'){
                        
                        RepOverlay =true;
                    } 
                }
            }
            //A particular role has been selected 
            else if (fw.selectedLevelThree != '' && fw.selectedLevelThree != 'All'){
                system.debug('role aggregates');
                mgr = true;
                populateAvg12MonthRevenue(fw.selectedLevelThree);
                aggregateOnRole();
                monthChart24(fw.selectedLevelThree);                   
            }
              
          }
          catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());                
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
          }
     }
     
    private void populateAvg12MonthRevenue(String rol){
        
         needimprovement = 0.1 ;
         marginal = 0 ;
         average = 0 ;
         strong = 0 ;
         
         needimprovementYTD = 0.1 ;
         marginalYTD = 0 ;
         averageYTD = 0 ;
         strongYTD = 0 ;
             
        if(roleValue.keySet().contains(rol)){
            avg12MonthRevenue = roleValue.get(rol).setScale(0, RoundingMode.HALF_UP);
            avg12MonthRevenue = avg12MonthRevenue.setScale(2, RoundingMode.HALF_UP);
        }else{
            avg12MonthRevenue = 0.00;
        }
         
        role = rol;
        chart1YaxisMax = avg12MonthRevenue + 1000;
        chart2YaxisMax = avg12MonthRevenue + 1000;
        chart3YaxisMax = avg12MonthRevenue + 1000;
        chart4XaxisMax = avg12MonthRevenue + 1000;
        chart5XaxisMax = avg12MonthRevenue + 1000;
       
        if(roleYTDValue.keySet().contains(rol)){
            avgYTD= roleYTDValue.get(rol).setScale(2, RoundingMode.HALF_UP);
           // avgYTD= avgYTD.setScale(2, RoundingMode.HALF_UP);
        }else{
            avgYTD= 0.00;
        }
        
        chart4YaxisMax = avgYTD+ 10;
        
        List<Sales_Rep_Profile__c > topsp =[Select Avg_ann_Rev_Perf_of_Tenured_Rep__c from Sales_Rep_Profile__c where Role__c =:rol AND Avg_ann_Rev_Perf_of_Tenured_Rep__c > 0 order by Avg_ann_Rev_Perf_of_Tenured_Rep__c desc Limit 1];
        
        if(topsp != null && topsp.size() > 0){
           Decimal topvalue = topsp[0].Avg_ann_Rev_Perf_of_Tenured_Rep__c;
           needimprovement =   (0.2 * topvalue ).setScale(2, RoundingMode.HALF_UP) +0.01;
           marginal =   (0.4 * topvalue ).setScale(2, RoundingMode.HALF_UP) +0.01;
           average =   (0.6 * topvalue ).setScale(2, RoundingMode.HALF_UP) +0.01;
           strong =   (0.8 * topvalue ).setScale(2, RoundingMode.HALF_UP) +0.01;
        }
        
        List<Sales_Rep_Profile__c > topspYTD =[Select YTD_Revenue__c from Sales_Rep_Profile__c where Role__c =:rol AND YTD_Revenue__c > 0 order by YTD_Revenue__c desc Limit 1];
        
        if(topspYTD != null && topspYTD.size() > 0){
           Decimal topvalueYTD = topspYTD[0].YTD_Revenue__c;
           needimprovementYTD =   (0.2 * topvalueYTD ).setScale(2, RoundingMode.HALF_UP) +0.01;
           marginalYTD =   (0.4 * topvalueYTD ).setScale(2, RoundingMode.HALF_UP) +0.01;
           averageYTD =   (0.6 * topvalueYTD ).setScale(2, RoundingMode.HALF_UP) +0.01;
           strongYTD =   (0.8 * topvalueYTD ).setScale(2, RoundingMode.HALF_UP) +0.01;
        } 
    }
    
     
     
        
                    
    private void aggregateOnRole(){ 
        
        String salesRepLastyearSnap ='SELECT Sales_Rep_Profile__r.name,Sales_Rep_Profile_Snapshot__r.User_Record_Name__c,Sales_Rep_Profile_Snapshot__r.Role__c,Sales_Rep_Profile_Snapshot__r.YTD_Revenue__c FROM Company_Level_Junction_snapshot__c WHERE  Company_Level__r.Level_Value__c =\''+String.escapeSingleQuotes(fw.SelectedLevelOne)+'\' AND Sales_Rep_Profile_Snapshot__r.Role__c = \'' +String.escapeSingleQuotes(fw.SelectedLevelThree) +'\'  AND (Sales_Rep_Profile_Snapshot__r.Tenure_in_current_role__c >= 12 OR ( Sales_Rep_Profile_Snapshot__r.Role_change_date__c = null AND Sales_Rep_Profile_Snapshot__r.Tenure__c >=12))   AND  (Sales_Rep_Profile_Snapshot__r.Active__c = TRUE AND Sales_Rep_Profile_Snapshot__r.Annual_Quota_Amount__c > 0 ) AND Sales_Rep_Profile_Snapshot__r.Snapshot_Scheduled_Date__c  = '+ String.escapeSingleQuotes(String.valueOf(snapLastYear).removeEnd(' 00:00:00')) + ' AND Snapshot_Scheduled_Date__c  = '+ String.escapeSingleQuotes(String.valueOf(snapLastYear).removeEnd(' 00:00:00')) +'Order by Sales_Rep_Profile_Snapshot__r.YTD_Revenue__c desc';
        List<Company_Level_Junction_snapshot__c> srpSnapList = database.query(salesRepLastyearSnap); 
        
        for(Company_Level_Junction_snapshot__c s: srpSnapList ){
            chartLabels.add(s.Sales_Rep_Profile__r.name);
            if(s.Sales_Rep_Profile_Snapshot__r.YTD_Revenue__c!= null){
                chartData.add(s.Sales_Rep_Profile_Snapshot__r.YTD_Revenue__c);
               
                if(s.Sales_Rep_Profile_Snapshot__r.YTD_Revenue__c > chart1YaxisMax ){
                    chart1YaxisMax = s.Sales_Rep_Profile_Snapshot__r.YTD_Revenue__c + 1000;
                }
            }else{
                chartData.add(0);
            }
        }
        
        system.debug('avg12MonthRevenue '+avg12MonthRevenue );
        
        //new repcode
        List<Sales_Profile_Company_Level_Junction__c> spCLJun = [SELECT Sales_Rep_Profile__c, Sales_Rep_Profile__r.name, Sales_Rep_Profile__r.User_record_name__c, Company_Level__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne  AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree  AND Sales_Rep_Profile__r.Active__c = TRUE AND Sales_Rep_Profile__r.Annual_quota_amount__c > 0  AND Sales_Rep_Profile__r.Tenure__c <= 12];
        
        Set<Id> sr = new Set<Id>();
        
        for(Sales_Profile_Company_Level_Junction__c sj: spCLJun){
             sr.add(sj.Sales_Rep_Profile__c);
        }
        
        List<Sales_Rep_Profile_Snapshot__c> newSalesRepSnap =[Select Sales_Rep_Profile__r.name, Monthly_Quota_Revenue__c ,Tenure__c From Sales_Rep_Profile_Snapshot__c Where Sales_Rep_Profile__c IN :sr AND Sales_Rep_Profile__r.Annual_quota_amount__c > 0 AND Tenure__c > 0 Order by Sales_Rep_Profile__r.name asc ,Tenure__c asc];
         
        for(Sales_Rep_Profile_Snapshot__c ss : newSalesRepSnap){
            if(newReplist.keySet().contains(ss.Sales_Rep_Profile__r.name)){
                Decimal previousMonth = newReplist.get(ss.Sales_Rep_Profile__r.name)[newReplist.get(ss.Sales_Rep_Profile__r.name).size() - 1];
                previousMonth += ss.Monthly_Quota_Revenue__c;
                newReplist.get(ss.Sales_Rep_Profile__r.name).add(previousMonth );
                if(chart3YaxisMax < previousMonth ){
                     chart3YaxisMax  = previousMonth +1000;
                }
            }else{
                List<Decimal> month = new List<Decimal>();
                month.add(ss.Monthly_Quota_Revenue__c);
                newReplist.put(ss.Sales_Rep_Profile__r.name,month);
                if(chart3YaxisMax < ss.Monthly_Quota_Revenue__c){
                     chart3YaxisMax  = ss.Monthly_Quota_Revenue__c+1000;
                }
            }
             
        }
        System.debug('newReplist-'+newReplist);
        
        List<Sales_Profile_Company_Level_Junction__c> spCLJunChart4 = [SELECT Sales_Rep_Profile__c  FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__r.Level_Value__c = :fw.SelectedLevelOne  AND Sales_Rep_Profile__r.Role__c = :fw.SelectedLevelThree  AND Sales_Rep_Profile__r.Active__c = TRUE AND Sales_Rep_Profile__r.Annual_quota_amount__c > 0  AND Sales_Rep_Profile__r.Tenure__c  >= 12];
        
        Set<Id> src = new Set<Id>();
        
        for(Sales_Profile_Company_Level_Junction__c sj: spCLJunChart4){
             src.add(sj.Sales_Rep_Profile__c);
        }
        chart4(src);
    }
    
    private void singleRep(Id sr, Id ur){
        
        List<Sales_Rep_Profile_Snapshot__c> s = new  List<Sales_Rep_Profile_Snapshot__c>();
          
        if(sr != null){
            s =[Select id,Role__c,name,Profile_Type__c,YTD_Revenue__c from Sales_Rep_Profile_Snapshot__c where Sales_Rep_Profile__c = :String.escapeSingleQuotes(sr) AND (Tenure_in_current_role__c >= 12 OR (Role_change_date__c = null AND Tenure__c >=12))  AND Active__c = TRUE AND  Annual_Quota_Amount__c > 0  AND Snapshot_Scheduled_Date__c  = :snapLastYear limit  1  ];
        }
        System.debug('s--'+s);
        if(s != null && s.size()>0){
            
            role = s[0].Role__c; 
            if(roleValue.keySet().contains(s[0].Role__c)){
                avg12MonthRevenue = roleValue.get(s[0].Role__c).setScale(0, RoundingMode.HALF_UP);
                avg12MonthRevenue = avg12MonthRevenue.setScale(2, RoundingMode.HALF_UP);
            }else{
                avg12MonthRevenue = 0.00;
            }
            chart1YaxisMax = avg12MonthRevenue + 1000;
             
            chartLabels.add(s[0].name);
            
            if(s[0].YTD_Revenue__c  != null){
                chartData.add(s[0].YTD_Revenue__c); 
            }else{
                chartData.add(0); 
            }
            
            if(s[0].YTD_Revenue__c > chart1YaxisMax ){
                chart1YaxisMax = s[0].YTD_Revenue__c + 1000;
            }
        }else{
             
             chartLabels.add('');
             chartData.add(0);  
         }
 
                 
       List<Sales_Rep_Profile_Snapshot__c > sps = new List<Sales_Rep_Profile_Snapshot__c >();
       if(sr != null){
           sps =[Select Sales_Rep_Profile__r.name, Monthly_Quota_Revenue__c ,Tenure__c From Sales_Rep_Profile_Snapshot__c Where Sales_Rep_Profile__c =:String.escapeSingleQuotes(sr) AND Sales_Rep_Profile__r.Tenure__c <= 12  AND  Sales_Rep_Profile__r.Annual_quota_amount__c > 0 AND Tenure__c > 0 Order by Sales_Rep_Profile__r.name asc ,Tenure__c asc ];
        }
        system.debug('sps --'+sps );
        if(sps != null && sps.size()>0){
            for(Sales_Rep_Profile_Snapshot__c ss : sps ){
            if(newReplist.keySet().contains(ss.Sales_Rep_Profile__r.name)){
                Decimal previousMonth = newReplist.get(ss.Sales_Rep_Profile__r.name)[newReplist.get(ss.Sales_Rep_Profile__r.name).size() - 1];
                previousMonth += ss.Monthly_Quota_Revenue__c;
                newReplist.get(ss.Sales_Rep_Profile__r.name).add(previousMonth );
                if(chart3YaxisMax < previousMonth ){
                    chart3YaxisMax = previousMonth +1000;
                }
            }else{
                List<Decimal> month = new List<Decimal>();
                month.add(ss.Monthly_Quota_Revenue__c);
                newReplist.put(ss.Sales_Rep_Profile__r.name,month);
                if(chart3YaxisMax < ss.Monthly_Quota_Revenue__c){
                    chart3YaxisMax = ss.Monthly_Quota_Revenue__c+1000;
                }
            }
             
        }
        }
        
        Set<id> src = new Set<id>();
        src.add(sr);
        chart4(src);
    }
    
    private void monthChart24(String role){ 
        
        Map<Decimal,Decimal> monthAmt = new Map<Decimal,Decimal>();
        Map<Decimal,Decimal> repCount = new Map<Decimal,Decimal>();
        
        List<Sales_Rep_Profile_Snapshot__c> snap =[SELECT User_Record_Name__c,Role__c,Monthly_Quota_Revenue__c,Tenure_in_current_role__c  FROM Sales_Rep_Profile_Snapshot__c  WHERE Sales_Rep_Profile__r.Tenure__c >12 AND Sales_Rep_Profile__r.Tenure__c <=36 AND Active__c = TRUE AND Role__c = :role AND  Annual_Quota_Amount__c > 0];
        
        for(Sales_Rep_Profile_Snapshot__c s: snap){
            if(s.Tenure_in_current_role__c <= 24){
                if(monthAmt.keySet().contains(s.Tenure_in_current_role__c)){
                    Decimal amt = monthAmt.get(s.Tenure_in_current_role__c);
                    amt += s.Monthly_Quota_Revenue__c;                           
                    monthAmt.put(s.Tenure_in_current_role__c,amt);
                    
                    Decimal count = repCount.get(s.Tenure_in_current_role__c);
                    count += 1;                           
                    repCount.put(s.Tenure_in_current_role__c,count);
                }else{
                    monthAmt.put(s.Tenure_in_current_role__c,s.Monthly_Quota_Revenue__c);
                    repCount.put(s.Tenure_in_current_role__c,1);
                }
            }
        }
       
        for(Decimal i = 1 ; i <= 24 ; i++){
             
            chart24Months.add('Month '+i);
            if(monthAmt.keyset().contains(i) && monthAmt.get(i) > 0){
                Decimal preMon = 0;
                if(chart24Data.size() > 0){
                    preMon = chart24Data[chart24Data.size() - 1];
                }
                preMon += (monthAmt.get(i)/repCount.get(i));
                chart24Data.add(preMon);
                
                if(chart2YaxisMax < preMon ){
                    chart2YaxisMax =  preMon  + 1000;
                }
                 
            }else{
                chart24Data.add(0);
            }
        }
         
         
          for(Decimal i = 1 ; i <= 12 ; i++){
             
            chart12Months.add('Month '+i);
            if(monthAmt.keyset().contains(i) && monthAmt.get(i) > 0){
                
                Decimal preMon = 0;
                if(chart12Data.size() > 0){
                    preMon = chart12Data[chart12Data.size() - 1];
                }
                preMon += (monthAmt.get(i)/repCount.get(i));
                chart12Data.add(preMon);
               
                if(chart3YaxisMax < preMon ){
                    chart3YaxisMax =  preMon  + 1000;
                }
                 
            }else{
                chart12Data.add(0);
            }
        }
        System.debug('chart24Data'+chart24Data);
        System.debug('chart24Months'+chart24Months);    
    } 
    
    public void createMapOfRoleAndAvgRevenue(){
        Date fiscalYr =  FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        Integer year = fiscalYr.year() - 1;
        fiscalYear = year;
        Integer month = fiscalYr.month();
        if(month == 1){
            month = 12;
        }else{
            month = month -1;
        }
        Integer day = date.daysInMonth(year, month);
        snapLastYear = date.newInstance(year, month, day);
         
        
        Map<String,Decimal> roleAmount = new Map<String,Decimal>();
        Map<String,Decimal> roleCount = new Map<String,Decimal>();
         
        roleValue =  new Map<String,Decimal>();
        
        String salesRep ='SELECT User_Record_Name__c,Role__c,YTD_Revenue__c  FROM Sales_Rep_Profile_Snapshot__c  WHERE (Tenure_in_current_role__c >= 12 OR ( Role_change_date__c = null AND Tenure__c >=12))  AND (Active__c = TRUE AND Annual_Quota_Amount__c > 0) AND Snapshot_Scheduled_Date__c  = '+ String.valueOf(snapLastYear).removeEnd(' 00:00:00');
       
        List<Sales_Rep_Profile_Snapshot__c> srpList = database.query(salesRep);
        
        for(Sales_Rep_Profile_Snapshot__c s : srpList){
            
             if(!roleAmount.containsKey(s.Role__c) && s.YTD_Revenue__c  != null){
                roleAmount.put(s.Role__c,s.YTD_Revenue__c );
                roleCount.put(s.Role__c,1);
                
            }else if(s.YTD_Revenue__c  != null){
                Decimal amt = roleAmount.get(s.Role__c);
                amt += s.YTD_Revenue__c;
                roleAmount.put(s.Role__c,amt);
                
                Decimal count = roleCount.get(s.Role__c);
                count += 1;
                roleCount.put(s.Role__c,count);
            }
            
        }
        
        for(String s :roleAmount.keySet() ){
            Decimal amt = roleAmount.get(s)/roleCount.get(s);
            roleValue.put(s,amt);
        } 
        
    }
    
    public void createMapOfRoleAndAvgYTD(){
        
        roleYTDValue =  new Map<String,Decimal>();
        List<AggregateResult> srp = [Select Role__c role, Sum(YTD_Revenue__c) sr , Sum(YTD_Quota__c) sq From Sales_Rep_Profile__c where Tenure__c  >= 12 AND Active__c = TRUE AND Annual_Quota_Amount__c > 0 Group by Role__c  ];
        
        for(AggregateResult a: srp){
            if((Decimal)(a.get('sq')) > 0 ){
                roleYTDValue.put((String)a.get('role'),(((Decimal)a.get('sr') *100)/(Decimal)(a.get('sq'))));
            }
            
        }
    }
    
    public void chart4(Set<id> repids){
        bubblechart = new List<Certification__c> ();
        bubblechart =[Select Overall_Rating__c ,Overall_Qualitative_Rating__c,Overall_Quantitative_Rating__c,Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.YTD_Revenue__c ,Sales_Rep_Profile__r.X12_Month_Rolling_Revenue__c,Sales_Rep_Profile__r.YTD_Quota_Percentage__c,Sales_Rep_Profile__r.Avg_ann_Rev_Perf_of_Tenured_Rep__c  From Certification__c where Sales_Rep_Profile__c IN :repids AND Sales_Rep_Profile__r.Tenure__c >=12];
         
        for(Certification__c c :bubblechart ){
         if(c.Sales_Rep_Profile__r.X12_Month_Rolling_Revenue__c != null && c.Sales_Rep_Profile__r.X12_Month_Rolling_Revenue__c > chart4XaxisMax ){
             chart4XaxisMax = c.Sales_Rep_Profile__r.X12_Month_Rolling_Revenue__c;
         }
         if(c.Sales_Rep_Profile__r.YTD_Revenue__c != null && c.Sales_Rep_Profile__r.YTD_Revenue__c >chart5XaxisMax ){
             chart5XaxisMax = c.Sales_Rep_Profile__r.YTD_Revenue__c ;
         }
         if(c.Sales_Rep_Profile__r.YTD_Quota_Percentage__c  != null && c.Sales_Rep_Profile__r.YTD_Quota_Percentage__c >chart4YaxisMax ){
             chart4YaxisMax = c.Sales_Rep_Profile__r.YTD_Quota_Percentage__c;
         }
        }
        chart4XaxisMax = 1.25 * chart4XaxisMax ;
        chart5XaxisMax = 1.25 * chart5XaxisMax ;
        chart4YaxisMax += 10;
    }
    
    
    public void aggregate(Id mgrId){
         
        
    } 
    
     
    
    
    
    
   
   
      
     //Serealize the json object for VF page
     public String getCharLabelsChart() {   // First graph - Funnelocity Score
        return JSON.serialize(chartLabels);
     }
      
     public String getChartDataChart() {
        return JSON.serialize(chartData); 
     }
     
     public String getChart24MonthsChart() {   // second graph - Funnelocity Score
        return JSON.serialize(chart24Months);
     }
      
     public String getChart24DataChart () {
        return JSON.serialize(chart24Data); 
     }
     
     public String getChart12MonthsChart() {   // third graph - Funnelocity Score
        return JSON.serialize(chart12Months);
     }
      
     public String getChart12DataChart () {
        return JSON.serialize(chart12Data); 
     }
     
     public String  getChartNewRep(List<Decimal> repRev) {
        return JSON.serialize(repRev); 
     }
    
    public void breadCrumClick(){
  
        fw = new FunnelFilterWrapper();
        fw.labelFour = 'Filter By Representative';
        FunnelFilterHelper.onclickpopulateFilters(crumValue,fw);
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
    
    public PageReference navigateToCertification(){
        
        //return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
    	return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToFunnelAnalyticQualitative(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
    	return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    } 
    
    public PageReference navigateToSalesPipeline(){
        
        return FunnelNavigationHelper.navigateToSalesPipeline(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
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
    
    public PageReference navigateToFunnelAnalytic(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
    	return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToGoals(){
        
        return FunnelNavigationHelper.navigateToGoalsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    //Added for Help Menu - Rohit
    public PageReference navigateToHelpMenu(){
        
        return FunnelNavigationHelper.navigateToHelpMenu();
    
    }
     
    /*Navigation*/
     
}