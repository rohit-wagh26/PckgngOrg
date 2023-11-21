/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelUpdateRatings_Controller{
    
    public  List<EvaluationGuidelines__c> guildlineList {get;set;}
    public Boolean displayPopup {get;set;}
    public List <Certification_Answer__c> prevCa {get;set;}
    public List <Certification_Answer__c> prevCmnt {get;set;}
    public String popClose{get;set;}
    
    Public Map<String,String> managemenetReports{get;set;}
    
    List<Certification_Answer__c> completeList = new List <Certification_Answer__c>();    
    
    public static String prefix{ get{return 'FunnelMetrics__';} set; }

    Map<String,List<Certification_Answer__c>> updateMap = new Map<String,List<Certification_Answer__c>>();
    
    public Map<String,List<Certification_Answer__c>> updateMapValue{
        get{
            return updateMap;
        }
        set{
            updateMap = value;
        }
    }
    
    List<Certification_Answer__c> updateList = new List<Certification_Answer__c>();
    
    public List<Certification_Answer__c> updateListValue{
        get{
            return updateList;
        }
        set{
            updateList = value;
        }
    }
    
    Map<String,List<Certification_Answer__c>> staticMap = new Map<String,List<Certification_Answer__c>>();
    
    public Map<String,List<Certification_Answer__c>> staticMapValue{
        get{
            return staticMap;
        }
        set{
            staticMap = value;
        }
    }
    
    List<Certification_Answer__c> staticList = new List<Certification_Answer__c>();
    
    public List<Certification_Answer__c> staticListValue{
        get{
            return staticList;
        }
        set{
            staticList = value;
        }
    }
    
    Boolean monthlyUpdateable = false;
    
    Boolean quarterlyUpdateable = false;
    
    Boolean biannualUpdateable = false;
    
    Boolean annualUpdateable = false;
    
    public Sales_Rep_Profile__c sr {get;set;}
    public Id salesRepId {get;set;}
        
    private Date monthlyDueDate;
    private Date quarterlyDueDate;
    private Date biannualDueDate;
    private Date annualDueDate;

    Boolean initialRatings = false;
   
    private Date initialMonthlyDueDate;
    private Date initialQuarterlyDueDate;
    private Date initialBiannualDueDate;
    private Date initialAnnualDueDate;

    private Date impDt;
    
    public Certification__c c;
    
    
    //Variables to store the parameters passed in the URL
    private String label1;
    private String label2;
    private String label3;
    private String selectedLevel1;
    private String selectedLevel2;
    private String selectedLevel3;
    
    DateTime Fyear;
    Date Q1;
    Date Q2;
    Date Q3;
    Date Q4;
    Date B1;
    Date B2;
    Date Y1;
    Date EOM;
    
    public Date todaysDate {get;set;}
    public boolean updatenoti{get;set;}
    
    public Boolean Req{get;set;}
    public Boolean opt{get;set;}
    
    public FunnelUpdateRatings_Controller() {     
        
        try{       
            
            salesRepId = ApexPages.currentPage().getParameters().get('id');
            if(salesRepId  != null){
            sr = [SELECT id,Profile_Type__c, Name, Annual_Quota_Amount__c, User_Record_Name__r.title, Role__c, Rep_Staus__c, Territory__c, Sales_Manager__r.Name, Tenure_in_current_role__c, User_Record_Name__r.CreatedDate FROM Sales_Rep_Profile__c WHERE id = :salesRepId];
                
            c = [SELECT id, Sales_Rep_Profile__c, Overall_Qualitative_Rating__c, Overall_Quantitative_Rating__c, Total_Quantitative_Weight__c, Total_Quantitative_Weighted_Score__c FROM Certification__c WHERE Sales_Rep_Profile__c = : sr.id Limit 1];
            }
            todaysDate = Date.today();
            
            Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        
            populateEndDates();
        
            Boolean readAccess = true;
            
            Map <String,List<Certification_Answer__c>> prevCaMap = new Map <String,List<Certification_Answer__c>>();
            prevCa = new List<Certification_Answer__c>();
            prevCmnt = new List<Certification_Answer__c>();
            
            List<String> fldList1 = new List<String>{prefix+'User_Record_name__c',prefix+'name',prefix+'Role__c',prefix+'Sales_Manager__c',prefix+'Territory__c',prefix+'Tenure_in_current_role__c'};                    
            
            Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList1){
                if(!fieldMap1.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            }
            
            List<String> fldList2 = new List<String>{prefix+'Certifcation_Rating__c',prefix+'Rating_Score__c'};                    
            
            Map <String, Schema.SObjectField> fieldMap2 = Schema.getGlobalDescribe().get(prefix+'Certification_Answer__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList2){
                if(!fieldMap2.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            }
            
            
            //Find if the ratings are the initial set of ratings
        List<Application_Setting__c> appSet = [SELECT Implementation_Date__c FROM Application_Setting__c LIMIT 1];
            
        impDt = appSet[0].Implementation_Date__c;
            
        List<Certification_Answer__c> cans = [SELECT id, Rating_Start_date__c, Due_date__c FROM Certification_answer__c WHERE Rating_start_date__c = :impDt AND Certifcation_rating__r.assessment_type__c = 'Qualitative' AND Rating_Score__c = NULL AND Sales_rep_profile__c = :salesRepId] ;
        
        if(cans != null && cans.size() > 0){
            
            initialRatings = true;                           
            
            Date nextMonth = cans[0].Due_date__c.addMonths(1);
            
            Integer noOfDays = Date.daysInMonth(nextMonth.year(),nextMonth.month());                
            initialMonthlyDueDate = Date.newInstance(nextMonth.year(),nextMonth.month(),noOfDays);     
            
            initialQuarterlyDueDate = FunnelCalculationHelper.getQuarterEndInDateFormat(nextMonth);            
            
            DateTime month6Start = Fyear.addMonths(5);  
            system.debug(' month6Start '+month6Start);                          
            noOfDays = Date.daysInMonth(month6Start.yearGMT(),month6Start.monthGMT());                            
            Date dueDate = Date.newInstance(month6Start.yearGMT(),month6Start.monthGMT(),noOfDays);
            system.debug(' dueDate '+dueDate);  
            
            if(nextMonth  > dueDate){
                dueDate = dueDate.addMonths(6);
                noOfDays = Date.daysInMonth(dueDate.year(),dueDate.month());
                dueDate = Date.newInstance(dueDate.year(),dueDate.month(),noOfDays);
            }
            system.debug(' dueDate '+dueDate); 
            
            initialBiannualDueDate = dueDate;
                        
            DateTime month12Start = Fyear.addMonths(11);
            system.debug(' month12Start '+month12Start); 
                                        
            noOfDays = Date.daysInMonth(month12Start.yearGMT(),month12Start.monthGMT());                            
            dueDate = Date.newInstance(month12Start.yearGMT(),month12Start.monthGMT(),noOfDays); 
            
            if(nextMonth  > dueDate){
                dueDate = dueDate.addMonths(12);  
                noOfDays = Date.daysInMonth(dueDate.year(),dueDate.month());
                dueDate = Date.newInstance(dueDate.year(),dueDate.month(),noOfDays);              
            }
            system.debug(' dueDate '+dueDate);
            
            initialAnnualDueDate = dueDate;
                           
        }
        
        if(readAccess){
    
                //Find the monthly ratings
                
            List<Certification_Answer__c> monthlyDate = [SELECT Rating_Start_Date__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id FROM Certification_Answer__c WHERE Certifcation__r.Sales_Rep_Profile__c = :salesRepId AND Certifcation_Rating__r.Timing__c = 'End of month' AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative'  AND Rating_Score__c = null ORDER BY Rating_Start_Date__c DESC LIMIT 1];
                
                system.debug(' monthlyDate '+monthlyDate);
                
                if(monthlyDate != null && monthlyDate.size() > 0){
                                          
                    List<Certification_Answer__c> monthlyRatings = new List<Certification_Answer__c> ();
                    
            monthlyRatings =  [SELECT name,Comment__c,Certifcation_Rating__r.Name,Certifcation_Rating__r.Timing__c,Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Calculation_type__c, Certifcation_Rating__r.Weight__c, Certifcation_Rating__r.Category__c, Rating_Start_Date__c, Tenatative_rating_score__c, Weighted_Score__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id FROM Certification_Answer__c WHERE Certifcation__r.Sales_Rep_Profile__c = :salesRepId AND Certifcation_Rating__r.Timing__c = 'End of month' AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative' AND Rating_Start_Date__c = :monthlyDate[0].Rating_Start_Date__c AND Rating_Score__c = null]; 
                
                    if(monthlyDate[0].Rating_Score__c == null){
                        monthlyUpdateable = true;
                        monthlyDueDate = monthlyDate[0].Due_Date__c;
                        updateList.addAll(monthlyRatings);
                    }
                    else{
                        staticList.addAll(monthlyRatings);
                    }
                }
                
                system.debug(' updateList '+updateList);
                //Find the quarterly ratings
                
            List<Certification_Answer__c> quarterlyDate = [SELECT Rating_Start_Date__c, Certifcation_Rating__r.Weight__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id FROM Certification_Answer__c WHERE Certifcation__r.Sales_Rep_Profile__c = :salesRepId AND Certifcation_Rating__r.Timing__c = 'End of quarter' AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative'   AND Rating_Score__c = null ORDER BY Rating_Start_Date__c DESC LIMIT 1];
                
                if(quarterlyDate != null && quarterlyDate.size() > 0){
                                          
                    List<Certification_Answer__c> quarterlyRatings = new List<Certification_Answer__c> ();                        
                                                                   
            quarterlyRatings =  [SELECT name,Comment__c,Certifcation_Rating__r.Name,Certifcation_Rating__r.Timing__c,Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Calculation_type__c, Certifcation_Rating__r.Weight__c, Certifcation_Rating__r.Category__c, Rating_Start_Date__c, Tenatative_rating_score__c, Weighted_Score__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id FROM Certification_Answer__c WHERE Certifcation__r.Sales_Rep_Profile__c = :salesRepId AND Certifcation_Rating__r.Timing__c = 'End of quarter' AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative'  AND Rating_Start_Date__c = :quarterlyDate[0].Rating_Start_Date__c AND Rating_Score__c = null]; 
        
                    if(quarterlyDate[0].Rating_Score__c == null){
                        if(quarterlyDate[0].Rating_Start_Date__c <= todaysDate){
                            quarterlyUpdateable = true;
                        }
                        quarterlyDueDate = quarterlyDate[0].Due_Date__c; 
                        updateList.addAll(quarterlyRatings);
                        system.debug(' quarterlyDueDate  '+quarterlyDueDate );
                        system.debug(' quarterlyDate[0].Due_Date__c '+quarterlyDate[0].Due_Date__c);
                    }
                    else{
                        staticList.addAll(quarterlyRatings);
                    }               
                    system.debug(' quarterlyDueDate  '+quarterlyDueDate );
                }
                
                //Find the biannual ratings
                
        List<Certification_Answer__c> biannualDate = [SELECT Rating_Start_Date__c,Certifcation_Rating__r.Calculation_type__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id FROM Certification_Answer__c WHERE Certifcation__r.Sales_Rep_Profile__c = :salesRepId AND Certifcation_Rating__r.Timing__c = 'Bi-annual'   AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative' AND Rating_Score__c = null ORDER BY Rating_Start_Date__c DESC LIMIT 1];
            
                if(biannualDate != null && biannualDate.size() > 0){
                                          
                    List<Certification_Answer__c> biannualRatings = new List<Certification_Answer__c> ();                        
                                            
            biannualRatings =  [SELECT name,Comment__c,Certifcation_Rating__r.Name,Certifcation_Rating__r.Timing__c,Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Calculation_type__c, Certifcation_Rating__r.Weight__c, Certifcation_Rating__r.Category__c, Rating_Start_Date__c, Tenatative_rating_score__c, Weighted_Score__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id FROM Certification_Answer__c WHERE Certifcation__r.Sales_Rep_Profile__c = :salesRepId AND Certifcation_Rating__r.Timing__c = 'Bi-annual' AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative'  AND Rating_Start_Date__c = :biannualDate[0].Rating_Start_Date__c AND Rating_Score__c = null]; 
                
                    if(biannualDate[0].Rating_Score__c == null){
                        if(biannualDate[0].Rating_Start_Date__c <= todaysDate){
                            biannualUpdateable = true;
                        }
                        biannualDueDate = biannualDate[0].Due_Date__c;
                        updateList.addAll(biannualRatings);
                    }
                    else{
                        staticList.addAll(biannualRatings);
                    }
                }
                
                //Find the annual ratings
                
        List<Certification_Answer__c> annualDate = [SELECT Rating_Start_Date__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id FROM Certification_Answer__c WHERE Certifcation__r.Sales_Rep_Profile__c = :salesRepId AND Certifcation_Rating__r.Timing__c = 'Annual' AND  Certifcation_Rating__r.Assessment_Type__c = 'Qualitative' AND Rating_Score__c = null ORDER BY Rating_Start_Date__c DESC LIMIT 1];
            
                if(annualDate != null && annualDate.size() > 0){
                                          
                    List<Certification_Answer__c> annualRatings = new List<Certification_Answer__c> ();                        
                    
            annualRatings =  [SELECT name,Comment__c,Certifcation_Rating__r.Name,Certifcation_Rating__r.Timing__c,Certifcation_Rating__r.Description__c,Certifcation_Rating__r.Calculation_type__c, Certifcation_Rating__r.Weight__c, Certifcation_Rating__r.Category__c, Rating_Start_Date__c, Tenatative_rating_score__c, Weighted_Score__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id FROM Certification_Answer__c WHERE Certifcation__r.Sales_Rep_Profile__c = :salesRepId AND Certifcation_Rating__r.Timing__c = 'Annual' AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative'  AND Rating_Start_Date__c = :annualDate[0].Rating_Start_Date__c AND Rating_Score__c = null]; 
                
                    if(annualDate[0].Rating_Score__c == null){
                        if(annualDate[0].Rating_Start_Date__c <= todaysDate){
                            annualUpdateable = true;
                        }
                        annualDueDate = annualDate[0].Due_Date__c;
                        updateList.addAll(annualRatings);
                    }
                    else{
                        staticList.addAll(annualRatings);
                    }
                }
                
                system.debug( ' updateList '+updateList);
                Req = false;
                 Opt = false;
                for(Certification_Answer__c ca: updateList){
                     
                     
                    
                    
                     if(ca.Rating_Start_Date__c <= todaysDate ){
                          Req = true;
                     }else{
                          Opt = true;
                     }
                    
                     
                    
                    system.debug(' ca.Rating_Score__c '+ca.Rating_Score__c);
                    system.debug(' ca.Tentative_Rating_Score__c '+ca.Rating_Score__c);
                    if((ca.Rating_Score__c == null) && (ca.Tenatative_rating_score__c != null)){
                        ca.Rating_Score__c = ca.Tenatative_rating_score__c;
                    }
                    List<Certification_Answer__c> preca = [select Certifcation_Rating__c, Comment__c,Due_Date__c, name,Due_Date_Month__c, Rating_Score__c from Certification_Answer__c where Sales_rep_profile__c =: salesRepId And name =: ca.name And Certifcation_Rating__c =: ca.Certifcation_Rating__c And Due_Date__c <: ca.Due_Date__c Order by Due_Date__c desc limit 3];                    
                    
                    if(preca != null && preca.size() > 0){
                        for(Certification_Answer__c pca:preca){
                            if(!prevCaMap.containsKey(pca.name)){
                                prevCaMap.put(pca.name,new List<Certification_Answer__c>{pca});
                                prevCa.add(pca);
                            }
                            prevCmnt.add(pca);
                        }
                    }
                    system.debug(' preca '+preca);
                    system.debug(' prevca '+prevCa+' precmnt :: '+prevCmnt );                      
                    system.debug(' ca '+ca);
                               
                    if(ca.Certifcation_Rating__r.Category__c != null && ca.Certifcation_Rating__r.Category__c != '' && ! updateMap.keySet().contains(ca.Certifcation_Rating__r.Category__c)){
                        system.debug(' does not contain ');
                        List<Certification_Answer__c > wr = new List<Certification_Answer__c >();        
                        wr.add(ca);
                        updateMap.put(ca.Certifcation_Rating__r.Category__c,wr);
                    }    
                    else if(ca.Certifcation_Rating__r.Category__c != null && ca.Certifcation_Rating__r.Category__c != '' && updateMap.keySet().contains(ca.Certifcation_Rating__r.Category__c)){
                        system.debug(' already contains ');
                        updateMap.get(ca.Certifcation_Rating__r.Category__c).add(ca);
                    }                        
                    system.debug(' updateMap '+updateMap);
                }
                
                system.debug( 'staticList '+staticList);
        
                for(Certification_Answer__c ca: staticList){
                    
                    if(ca.Certifcation_Rating__r.Category__c != null && ca.Certifcation_Rating__r.Category__c != '' && ! staticMap.keySet().contains(ca.Certifcation_Rating__r.Category__c)){
                    
                        List<Certification_Answer__c > wr = new List<Certification_Answer__c >();        
                        wr.add(ca);
                        staticMap.put(ca.Certifcation_Rating__r.Category__c,wr);
                    }    
                    else if(ca.Certifcation_Rating__r.Category__c != null && ca.Certifcation_Rating__r.Category__c != '' && staticMap.keySet().contains(ca.Certifcation_Rating__r.Category__c)){
                        
                        staticMap.get(ca.Certifcation_Rating__r.Category__c).add(ca);
                    }                        
                    
                }
                system.debug( 'staticMap '+staticMap);
                
                completeList.addAll(updateList);
                
                completeList.addAll(staticList);
                
                label1 = ApexPages.currentPage().getParameters().get('labelOne');
                label2 = ApexPages.currentPage().getParameters().get('labelTwo');
                label3 = ApexPages.currentPage().getParameters().get('labelThree');
                selectedLevel1 = ApexPages.currentPage().getParameters().get('selectOne');
                selectedLevel2 = ApexPages.currentPage().getParameters().get('selectTwo');
                selectedLevel3 = ApexPages.currentPage().getParameters().get('selectThree');
                
                system.debug(' inside constructor '+completeList);
                
                for(Certification_Answer__c ca:completeList){
                    system.debug('weighted score '+ca.Weighted_Score__c);
                    system.debug('weight '+ca.Certifcation_Rating__r.Weight__c);
                }
                
                /*
                managemenetReports = new Map<String,String>();
        
                User u = [SELECT Name, UserPreferencesLightningExperiencePreferred FROM User WHERE id = :UserInfo.getUserId()];
        
                List<String> dashList = new List<String>();
                dashList.add('mXaDybYGcSDujlyIRRJQxUrUEqXiFe');
        
                managemenetReports = FunnelNavigationHelper.fetchDashboards(dashList,u);*/
                displayPopup = false;
                guildlineList = [select id,name,Description__c,order__c from  EvaluationGuidelines__c ORDER BY order__c ASC limit 5];
    
            }
            
            // To show submit button if a rating is present whos rating start date is less den today
            id userId;  
            userId = UserInfo.getUserId();
            
            List<Sales_Rep_Profile__c > cl = [SELECT id, name, Rep_Staus__c, On_boarding_Date__c   FROM Sales_Rep_Profile__c WHERE User_Record_Name__c= :userId LIMIT 1];
            
            Set<id> mgid = new set<id>();
            id mid;
            if(cl != null && cl.size()>0){
            mgid.add(cl[0].id);
                mid = cl[0].id;
            }
            
            cl = [SELECT id, name  FROM Sales_Rep_Profile__c WHERE Interim_Manager__c IN :mgid ];
            system.debug(' mgid  '+mgid + ' cl '+cl);
            for(Sales_Rep_Profile__c im: cl){
                mgid.add(im.id);
            }
            
            list<Sales_Rep_Profile__c > sp =[SELECT id,name from Sales_Rep_Profile__c where Sales_Manager__c IN :mgid];
                system.debug('sp pending'+sp);
                
                set<id> spid= new set<id>();
                spid= (new Map<Id,Sales_Rep_Profile__c >(sp)).keySet();
               
                Boolean reppresent =spid.contains(salesRepId);
               
                Map<Id,Certification__c> mapCerts = new Map<Id,Certification__c>([SELECT id FROM Certification__c WHERE Sales_Rep_Profile__c = :salesRepId And Sales_Rep_Profile__c  != :mid]);
                Set<id> certs = mapCerts.keySet();
                system.debug('certs pending'+certs );
            
                list<Certification_Answer__c> updatecerti = new list<Certification_Answer__c  >();
                updatecerti = [SELECT Rating_Start_Date__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id 
                              FROM Certification_Answer__c  WHERE Rating_Start_Date__c <= today AND Rating_Score__c = null AND Certifcation__c IN :certs AND Sales_rep_profile__r.Active__c = TRUE];
                  
                  system.debug('updatecerti pending'+ updatecerti );
                    
                 if(updatecerti != null && updatecerti.size()>0 && reppresent ){
                     updatenoti = true;
                 }else{
                     updatenoti = false;
                 }   
                
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelUpdateRatings_Controller '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());  
        } 
    }
    public void popup(){
    
        if(popClose == 'pop'){
            displayPopup = true;
        }else if(popClose == 'close'){
            displayPopup = false;
        }
     
    }
    public void populateEndDates(){
        
        Date FyearStartDate = Date.newInstance(FYear.yeargmt(),FYear.monthgmt(),1);
        Integer noOfDays = Date.daysInMonth(FYear.yeargmt(),FYear.monthgmt());
        
        Date FYearDate = Date.newInstance(FYear.yeargmt(),FYear.monthgmt(),noOfDays);
        
        Q1 = FyearStartDate.addMonths(2);
        noOfDays = Date.daysInMonth(Q1.year(),Q1.month());
        Q1 = Date.newInstance(Q1.year(),Q1.month(),noOfDays);
        
        Q2 = FyearStartDate.addMonths(5);
        noOfDays = Date.daysInMonth(Q2.year(),Q2.month());
        Q2 = Date.newInstance(Q2.year(),Q2.month(),noOfDays);
        
        Q3 = FyearStartDate.addMonths(8);
        noOfDays = Date.daysInMonth(Q3.year(),Q3.month());
        Q3 = Date.newInstance(Q3.year(),Q3.month(),noOfDays);
        
        Q4 = FyearStartDate.addMonths(11);
        noOfDays = Date.daysInMonth(Q4.year(),Q4.month());
        Q4 = Date.newInstance(Q4.year(),Q4.month(),noOfDays);
        
        B1 = Q2;
        B2 = Q4;
        Y1 = B2;
        
        noOfDays = Date.daysInMonth(Date.today().year(),Date.today().month());
        EOM = Date.newInstance(Date.today().year(),Date.today().month(),noOfDays);
        
        system.debug(' populateEndDates method '+Q1);
        system.debug(' populateEndDates method '+Q2);
        system.debug(' populateEndDates method '+Q3);
        system.debug(' populateEndDates method '+Q4);
       
    }
    
    public List<SelectOption>  getsurveyVal() {
       
        List<SelectOption> Options = new List<SelectOption>();
        Options.add(new SelectOption('','Select Score'));
        Options.add(new SelectOption('10','Greatly exceeds expectations'));
        Options.add(new SelectOption('8','Exceeds expectations'));
        Options.add(new SelectOption('5','Meets expectations'));
        Options.add(new SelectOption('2','Below expectations'));
        Options.add(new SelectOption('0','Greatly below expectations'));
        
        return options;
    }
    
    public PageReference submit(){
        try{    
            system.debug('inside submit');
            
            updateList = new List<Certification_Answer__c> ();
            
            for (String key : updateMap.keySet()) {
                
                List<Certification_Answer__c> upd = updateMap.get(key);
                updateList.addAll(upd);
            }
            
            List<String> fldList1 = new List<String>{prefix+'Rating_Score__c'};
                
            Boolean updateAccess = true;
                        
            Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Certification_Answer__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList1){
                if(!fieldMap1.get(fldName).getDescribe().isUpdateable()){
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                  updateAccess = false;
                }                           
            } 
            List<Certification_Answer__c > ReqRating = new List<Certification_Answer__c >();
            if(updateAccess){
            
                
            
                for(Certification_Answer__c ca: updateList){            
                                    
                    if(ca.Rating_Score__c == null){
                        ca.Rating_Score__c = 0;
                    }
                    
                    if(ca.Rating_Start_Date__c <= todaysDate){
                        ReqRating.add(ca);
                    }
                     
                    system.debug(' ca.Rating_Score__c '+ca.Rating_Score__c);
                }
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                return null;
            }
            
            if(Schema.getGlobalDescribe().get(prefix+'Certification_Answer__c').getDescribe().isUpdateable()){                      
                //update updateList;
                update ReqRating;
                 
            }            
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                return null;
            }
                    
            system.debug(completeList + '  completeList');
            List<Certification__c> cert = new List<Certification__c>();
            cert.add(c);
            
            if(FunnelCalculationHelper.findIfManager(cert)){
                calculateScore(completeList,true);
            } 
            if(!FunnelCalculationHelper.findIfManager(cert) && sr.Profile_Type__c == 'Overlay'){
                calculateScore(completeList,false);
            }
            
            
            createNewRatings();
            
            PageReference p = new PageReference('/apex/FunnelCerificationDetail?id='+sr.id+'&labelOne='+label1+'&labelTwo='+label2+'&labelThree='+label3+'&selectOne='+selectedLevel1+'&selectTwo='+selectedLevel2+'&selectThree='+selectedLevel3);
            return p;
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelUpdateRatings_Controller '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());  
            return null;
        } 
    } 
    
    private void calculateScore(List<Certification_Answer__c> cl, Boolean isManager){
        
        List<Id> idsToQuery = new List<Id>();
        
        for(Certification_Answer__c ca: cl){
            idsToQuery.add(ca.id);    
        }    
        
        List<AggregateResult> li = new List<AggregateResult>();
        
        li = [SELECT  COUNT(id) c, SUM(Rating_score__c) s  FROM Certification_Answer__c WHERE Rating_Start_Date__c <= :todaysDate AND id IN :idsToQuery];                
        
        List<String> fldList1 = new List<String>{prefix+'Overall_Qualitative_Rating__c',prefix+'Total_Qualitative_Weighted_Score__c',prefix+'Total_Qualitative_Weight__c',prefix+'Overall_Rating__c'};
            
        Boolean updateAccess = true;
                    
        Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Certification__c').getDescribe().fields.getMap();
        
        for(String fldName: fldList1){
            if(!fieldMap1.get(fldName).getDescribe().isUpdateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              updateAccess = false;
            }                           
        }
        
        if(updateAccess){
            
           if(isManager){ 
                 c.Management_Qualitative_Score__c  = (Decimal)li[0].get('s')/(Decimal)li[0].get('c');
            }else{ 
                c.Individual_Qualitative_Rating__c = (Decimal)li[0].get('s')/(Decimal)li[0].get('c'); 
                c.Overall_Qualitative_Rating__c = (Decimal)li[0].get('s')/(Decimal)li[0].get('c');
            }
            c.Total_Qualitative_Weight__c = 1;
                                                            
            /* M  c.Overall_Qualitative_Rating__c  = (Decimal)li[0].get('s')/(Decimal)li[0].get('w');
            c.Individual_Qualitative_Rating__c = c.Overall_Qualitative_Rating__c;
            //system.debug(' c.Overall_Qualitative_Rating__c'+c.Overall_Qualitative_Rating__c);
            
            c.Total_Qualitative_Weighted_Score__c = (Decimal)li[0].get('s');
            c.Total_Qualitative_Weight__c = (Decimal)li[0].get('w');         M */
           
            /* M if(FunnelCalculationHelper.findIfManager(c)){
                c.Management_Qualitative_Score__c = c.Overall_Qualitative_Rating__c;
            }  
               M */
            /*
            Decimal sumOfWeights = 0;
            system.debug(' c.Total_Qualitative_Weight__c '+c.Total_Qualitative_Weight__c);
            if(c.Total_Qualitative_Weight__c != null && c.Total_Qualitative_Weight__c > 0){
                sumOfWeights += c.Total_Qualitative_Weight__c ;
            }
            system.debug(' c.Total_Quantitative_Weight__c  '+c.Total_Quantitative_Weight__c);   
            if(c.Total_Quantitative_Weight__c != null && c.Total_Quantitative_Weight__c > 0){
               sumOfWeights += c.Total_Quantitative_Weight__c;
            }
               
            if(sumOfWeights > 0){
            
               Decimal sumOfWeightedScores = 0;
               system.debug(' c.Total_Qualitative_Weighted_Score__c  '+c.Total_Qualitative_Weighted_Score__c );
               if(c.Total_Qualitative_Weighted_Score__c != null && c.Total_Qualitative_Weighted_Score__c > 0){
                   sumOfWeightedScores += c.Total_Qualitative_Weighted_Score__c;
               }
               system.debug(' c.Total_Quantitative_Weighted_Score__c  '+c.Total_Quantitative_Weighted_Score__c );
               if(c.Total_Quantitative_Weighted_Score__c != null && c.Total_Quantitative_Weighted_Score__c > 0){
                   sumOfWeightedScores += c.Total_Quantitative_Weighted_Score__c;
               }
               
               system.debug(' sumOfWeightedScores  '+sumOfWeightedScores);
               
               system.debug(' sumOfWeights '+sumOfWeights);
               
               c.Overall_Rating__c = sumOfWeightedScores / sumOfWeights;
            }
            */
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
        }
        
        if(Schema.getGlobalDescribe().get(prefix+'Certification__c').getDescribe().isUpdateable()){ 
            update c;
            system.debug(c.Sales_Rep_Profile__c);
            /*List<Certification__c> cert = new List<Certification__c>();
            cert.add(c);
            
            FunnelCalculationHelper.calculateAggregateScoreForManagers(cert);*/
            
        }            
        else{
            system.debug(' error '); 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
        }
    }    
    
    private void createNewRatings(){
        
        Notification_Setting__c ns = [SELECT Id, Enable_Notifications__c, Advance_Reminders__c, Notification_Frequency__c, Escalation__c,Last_Date_for_submit__c FROM Notification_Setting__c LIMIT 1];
        
        List<Certification_Answer__c> newAnsList = new List<Certification_Answer__c>();
        
        List<Certification_Rating__c> questions = new List<Certification_Rating__c>();
        
        Integer i = 1;
                
        List<String> fldList1 = new List<String>{prefix+'escalation_email_date__c',prefix+'rating_start_date__c',prefix+'manager_email_date__c',prefix+'due_date__c',prefix+'certifcation_rating__c',prefix+'certifcation__c',prefix+'name'};
            
        Boolean createAccess = true;
                    
        Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Certification_Answer__c').getDescribe().fields.getMap();
        
        for(String fldName: fldList1){
            if(!fieldMap1.get(fldName).getDescribe().isCreateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              createAccess = false;
            }                
        } 
        
        //Create a map of certification id and sales profile
        Map<id,id> certSalesProfMap = new Map<id,id>();
        List<Certification__c> certs = [SELECT id, Sales_rep_profile__c FROM Certification__c LIMIT 10000];
        
        for(Certification__c c:certs){
            certSalesProfMap.put(c.id,c.Sales_rep_profile__c);    
        }
            
        if(createAccess){                                
                
                //if(monthlyUpdateable){
                
                    questions = [SELECT Id, name, User_Type__c, Assessment_type__c, Deactivated__c, Roles_enabled__c, Timing__c FROM Certification_Rating__c WHERE Assessment_type__c = 'Qualitative' AND Deactivated__c = false AND (User_Type__c = :sr.Rep_Staus__c OR User_Type__c='Both') AND Timing__c = 'End of month' AND Roles_enabled__c includes (:sr.Role__c)];        
                    system.debug(' monthly '+questions);
                    
                    Date dueDate;
                    
                    if(!initialRatings){
                        system.debug(' monthlyDueDate '+monthlyDueDate);
                        
                        if(monthlyDueDate != null){
                        
                            Date nextDue = monthlyDueDate.addMonths(1);
                            
                            Integer noOfDays = Date.daysInMonth(nextDue.year(),nextDue.month());
                            
                            dueDate = Date.newInstance(nextDue.year(),nextDue.month(),noOfDays);
                            
                            system.debug(' nextDue  '+nextDue);
                        
                            system.debug(' noOfDays '+noOfDays);
                        
                            system.debug(' dueDate '+dueDate);
                        
                        }
                        else{
                            
                            Integer noOfDays = Date.daysInMonth(Date.today().year(),Date.today().month()+1);
                            dueDate = Date.newInstance(Date.today().year(),Date.today().month()+1,noOfDays);
                        
                        }
                                                
                    }
                    else{
                        dueDate = initialMonthlyDueDate;
                    
                    }
                    //Date dueDateVal = Date.newInstance(nextDue.yearGMT(),nextDue.monthGMT(),noOfDays);
                    
                    //Datetime dueDate = DateTime.newInstance(nextDue.yearGMT(),nextDue.monthGMT(),noOfDays,0,0,0);
                    
                    //localTime = localTime.addHours(dueDate﻿.hour());
                    //localTime = localTime.addMinutes(dueDate﻿.minute());
                    //localTime = localTime.addSeconds(dueDate.second());
                    
                    //dueDate = localTime;                    
                    
                    for(Certification_Rating__c cr: questions){
                        Certification_Answer__c ca = new Certification_Answer__c();
                        ca.Name = cr.name;
                        if(!Test.isRunningTest()){
                             ca.Rating_name_picklist__c = cr.name;
                        }
                        ca.Certifcation__c = c.id;
                        ca.Sales_rep_profile__c = certSalesProfMap.get(c.id);
                        ca.Certifcation_Rating__c = cr.id;                        
                        ca.Due_Date__c = dueDate;
                        ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                        
                        if(ns.Enable_Notifications__c ){
                            if(ns.Advance_Reminders__c == '1 day prior'){
                                ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-1);
                                //ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-1);
                            }
                            else if(ns.Advance_Reminders__c == '3 days prior'){
                                ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-3);
                                //ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-3);
                            }
                            else if(ns.Advance_Reminders__c == '7 days prior'){
                                ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-7);
                                //ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                            }
                            
                            if(ns.Escalation__c == '1 day prior'){
                                ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 1);
                            }
                            else if(ns.Escalation__c == '2 days prior'){
                                ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 2);
                            }
                            else if(ns.Escalation__c == '3 days prior'){
                                ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 3);
                            }
                            else if(ns.Escalation__c == '4 days prior'){
                                ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 4);
                            }
                            else if(ns.Escalation__c == '5 days prior'){
                                ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 5);
                            }
                        }
                        i ++;
                        newAnsList.add(ca);
                    }
                //}
                
                questions = new List<Certification_Rating__c>();
                if(quarterlyUpdateable){                                        
                    
                    questions = [SELECT Id, name, User_Type__c, Assessment_type__c, Deactivated__c, Roles_enabled__c, Timing__c FROM Certification_Rating__c WHERE Assessment_type__c = 'Qualitative' AND Deactivated__c = false AND (User_Type__c = :sr.Rep_Staus__c OR User_Type__c='Both') AND Timing__c = 'End of quarter' AND Roles_enabled__c includes (:sr.Role__c)];        
                    system.debug(' quarterly '+questions);
                    system.debug(' quarterlyDueDate '+quarterlyDueDate);                    
                    
                    if(!initialRatings){
                    
                        Date nextDue = quarterlyDueDate.addMonths(3);
                        
                        Integer noOfDays = Date.daysInMonth(nextDue.year(),nextDue.month());                
                        
                        dueDate = Date.newInstance(nextDue.year(),nextDue.month(),noOfDays);
                        
                        system.debug(' nextDue  '+nextDue);
                    
                        system.debug(' noOfDays '+noOfDays);
                    
                        system.debug(' dueDate '+dueDate);                    
                    
                    }
                    else{
                        
                        dueDate = initialQuarterlyDueDate;
                    
                    }
                    
                }
                /*removed for testing else{
                    
                    questions = [SELECT Id, name, User_Type__c, Assessment_type__c, Deactivated__c, Roles_enabled__c, Timing__c FROM Certification_Rating__c WHERE Assessment_type__c = 'Qualitative' AND Deactivated__c = false AND (User_Type__c = :sr.Rep_Staus__c OR User_Type__c='Both') AND Timing__c = 'End of quarter' AND Roles_enabled__c includes (:sr.Role__c)]; 
                    dueDate = FunnelCalculationHelper.getQuarterEndInDateFormat(Date.today());                     
                          
                }*/
                
                    //DateTime dueDate = Date.newInstance(nextDue.year(),nextDue.month(),noOfDays);
                    
                    for(Certification_Rating__c cr: questions){
                        Certification_Answer__c ca = new Certification_Answer__c();
                        ca.Name = cr.name;
                        if(!Test.isRunningTest()){
                             ca.Rating_name_picklist__c = cr.name;
                        }
                        ca.Certifcation__c = c.id;
                        ca.Sales_rep_profile__c = certSalesProfMap.get(c.id);
                        ca.Certifcation_Rating__c = cr.id;
                        ca.Due_Date__c = dueDate;
                        ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                        
                        if(ns.Enable_Notifications__c ){
                            if(ns.Advance_Reminders__c == '1 day prior'){
                                ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-1);
                                //ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-1);
                            }
                            else if(ns.Advance_Reminders__c == '3 days prior'){
                                ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-3);
                                //ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-3);
                            }
                            else if(ns.Advance_Reminders__c == '7 days prior'){
                                ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-7);
                                //ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                            }
                            
                            if(ns.Escalation__c == '1 day prior'){
                                ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 1);
                            }
                            else if(ns.Escalation__c == '2 days prior'){
                                ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 2);
                            }
                            else if(ns.Escalation__c == '3 days prior'){
                                ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 3);
                            }
                            else if(ns.Escalation__c == '4 days prior'){
                                ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 4);
                            }
                            else if(ns.Escalation__c == '5 days prior'){
                                ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 5);
                            }
                        }
                        i ++;
                        newAnsList.add(ca);
                    }
                                
                questions = new List<Certification_Rating__c>();
                if(biannualUpdateable){
                
                    questions = [SELECT Id, Name, User_Type__c, Assessment_type__c, Deactivated__c, Roles_enabled__c, Timing__c FROM Certification_Rating__c WHERE Assessment_type__c = 'Qualitative' AND Deactivated__c = false AND (User_Type__c = :sr.Rep_Staus__c OR User_Type__c='Both') AND Timing__c = 'Bi-annual' AND Roles_enabled__c includes (:sr.Role__c)];        
                    system.debug(' biannual '+questions);
                                        
                    if(!initialRatings){
                    
                        Date nextDue = biannualDueDate.addMonths(6);
                        
                        Integer noOfDays = Date.daysInMonth(nextDue.year(),nextDue.month());
                        
                        dueDate = Date.newInstance(nextDue.year(),nextDue.month(),noOfDays);
                    }
                    else{
                    
                        dueDate = initialBiannualDueDate;
                    
                    }
                    //DateTime dueDate = Date.newInstance(nextDue.yearGMT(),nextDue.monthGMT(),noOfDays);
                 }
                 /*else if  ((EOM == B1 ) || (EOM == B2)){
                    
                    questions = [SELECT Id, Name, User_Type__c, Assessment_type__c, Deactivated__c, Roles_enabled__c, Timing__c FROM Certification_Rating__c WHERE Assessment_type__c = 'Qualitative' AND Deactivated__c = false AND (User_Type__c = :sr.Rep_Staus__c OR User_Type__c='Both') AND Timing__c = 'Bi-annual' AND Roles_enabled__c includes (:sr.Role__c)];
                    dueDate = EOM.addMonths(6);   
                    Integer noOfDays = Date.daysInMonth(dueDate.year(),dueDate.month());
                    dueDate = Date.newInstance(dueDate.year(),dueDate.month(),noOfDays);    
                 } */
                 /*Removed for testing else{
                    
                    questions = [SELECT Id, Name, User_Type__c, Assessment_type__c, Deactivated__c, Roles_enabled__c, Timing__c FROM Certification_Rating__c WHERE Assessment_type__c = 'Qualitative' AND Deactivated__c = false AND (User_Type__c = :sr.Rep_Staus__c OR User_Type__c='Both') AND Timing__c = 'Bi-annual' AND Roles_enabled__c includes (:sr.Role__c)];
                    
                    if(EOM > B1)
                        dueDate = B2;   
                    else
                        dueDate = B1;    
                 }*/
                   
                    for(Certification_Rating__c cr: questions){
                        
                        Certification_Answer__c ca = new Certification_Answer__c();
                        ca.Name = cr.Name;
                        if(!Test.isRunningTest()){
                             ca.Rating_name_picklist__c = cr.name;
                        }
                        ca.Certifcation__c = c.id;
                        ca.Sales_rep_profile__c = certSalesProfMap.get(c.id);
                        ca.Certifcation_Rating__c = cr.id;
                        ca.Due_Date__c = dueDate;
                        ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                        
                        if(ns.Enable_Notifications__c ){
                            if(ns.Advance_Reminders__c == '1 day prior'){
                                ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-1);
                                //ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-1);
                            }
                            else if(ns.Advance_Reminders__c == '3 days prior'){
                                ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-3);
                                //ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-3);
                            }
                            else if(ns.Advance_Reminders__c == '7 days prior'){
                                ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-7);
                                //ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                            }
                            
                            if(ns.Escalation__c == '1 day prior'){
                                ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 1);
                            }
                            else if(ns.Escalation__c == '2 days prior'){
                                ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 2);
                            }
                            else if(ns.Escalation__c == '3 days prior'){
                                ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 3);
                            }
                            else if(ns.Escalation__c == '4 days prior'){
                                ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 4);
                            }
                            else if(ns.Escalation__c == '5 days prior'){
                                ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 5);
                            }
                        }
                        i ++;
                        newAnsList.add(ca);
                    }
                                                    
                questions = new List<Certification_Rating__c>();
                if(annualUpdateable){
                
                    questions = [SELECT Id, Name, User_Type__c, Assessment_type__c, Deactivated__c, Roles_enabled__c, Timing__c FROM Certification_Rating__c WHERE Assessment_type__c = 'Qualitative' AND Deactivated__c = false AND (User_Type__c = :sr.Rep_Staus__c OR User_Type__c='Both') AND Timing__c = 'Annual' AND Roles_enabled__c includes (:sr.Role__c)];        
                    system.debug(' annual '+questions);
                                        
                    if(!initialRatings){
                    
                        Date nextDue = annualDueDate.addMonths(12);
                    
                        Integer noOfDays = Date.daysInMonth(nextDue.year(),nextDue.month());                                        
                    
                        dueDate = Date.newInstance(nextDue.year(),nextDue.month(),noOfDays);
                    }
                    else{
                        dueDate = initialAnnualDueDate;
                    }
                }
                /*Removed for testing else{
                    
                    questions = [SELECT Id, Name, User_Type__c, Assessment_type__c, Deactivated__c, Roles_enabled__c, Timing__c FROM Certification_Rating__c WHERE Assessment_type__c = 'Qualitative' AND Deactivated__c = false AND (User_Type__c = :sr.Rep_Staus__c OR User_Type__c='Both') AND Timing__c = 'Annual' AND Roles_enabled__c includes (:sr.Role__c)];        
                    dueDate = Y1;     
                    
                 }*/
                    //DateTime dueDate = Date.newInstance(nextDue.year(),nextDue.month(),noOfDays);
                    
                 for(Certification_Rating__c cr: questions){
                    Certification_Answer__c ca = new Certification_Answer__c();
                    ca.Name = cr.Name;
                    if(!Test.isRunningTest()){
                             ca.Rating_name_picklist__c = cr.name;
                        }
                    ca.Certifcation__c = c.id;
                    ca.Sales_rep_profile__c = certSalesProfMap.get(c.id);
                    ca.Certifcation_Rating__c = cr.id;
                    ca.Due_Date__c = dueDate;
                    ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                    
                    if(ns.Enable_Notifications__c ){
                        if(ns.Advance_Reminders__c == '1 day prior'){
                            ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-1);
                            //ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-1);
                        }
                        else if(ns.Advance_Reminders__c == '3 days prior'){
                            ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-3);
                            //ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-3);
                        }
                        else if(ns.Advance_Reminders__c == '7 days prior'){
                            ca.Manager_Email_Date__c = ca.Due_Date__c.addDays(-7);
                            //ca.Rating_Start_Date__c = ca.Due_Date__c.addDays(-7);
                        }
                        
                        if(ns.Escalation__c == '1 day prior'){
                            ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 1);
                        }
                        else if(ns.Escalation__c == '2 days prior'){
                            ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 2);
                        }
                        else if(ns.Escalation__c == '3 days prior'){
                            ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 3);
                        }
                        else if(ns.Escalation__c == '4 days prior'){
                            ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 4);
                        }
                        else if(ns.Escalation__c == '5 days prior'){
                            ca.Escalation_Email_Date__c = ca.Due_Date__c.addDays((Integer)ns.Last_Date_for_submit__c - 5);
                        }
                    }
                    i ++;
                    newAnsList.add(ca);
                 }
                
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
        }
        
        system.debug(' newAnsList '+newAnsList);
        
        if(Schema.sObjectType.Certification_Answer__c.isCreateable()){                      
            insert newAnsList;
        }            
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
        }
        
    
    }
    
    public PageReference saveForLater(){
        try{    
            system.debug(' save for later ');
            
            updateList = new List<Certification_Answer__c> ();
            
            for (String key : updateMap.keySet()) {
                
                List<Certification_Answer__c> upd = updateMap.get(key);
                updateList.addAll(upd);
            }
            
            List<String> fldList1 = new List<String>{prefix+'Rating_Score__c',prefix+'Tenatative_rating_score__c'};
                
            Boolean updateAccess = true;
                        
            Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Certification_Answer__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList1){
                if(!fieldMap1.get(fldName).getDescribe().isUpdateable()){
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                  updateAccess = false;
                }                           
            } 
            
            system.debug(' fields are editable');
            if(updateAccess){
                for(Certification_Answer__c ca: updateList){
                    system.debug(' ca.Rating_Score__c '+ca.Rating_Score__c);
                    ca.Tenatative_rating_score__c = ca.Rating_Score__c;
                    ca.Rating_Score__c = null;
                }
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                return null;
            }
            
            system.debug('update list save for later '+updateList);
            
            if(Schema.getGlobalDescribe().get(prefix+'Certification_Answer__c').getDescribe().isUpdateable()){                      
                update updateList;
            }            
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                return null;
            }
                            
            PageReference p = new PageReference('/apex/FunnelCerificationDetail?id='+sr.id+'&labelOne='+label1+'&labelTwo='+label2+'&labelThree='+label3+'&selectOne='+selectedLevel1+'&selectTwo='+selectedLevel2+'&selectThree='+selectedLevel3);
            return p;
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelUpdateRatings_Controller '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());  
            return null;
        } 
    } 
    
    /*Navigation*/
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToCertification(){
        
        //return FunnelNavigationHelper.navigateToCertification(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToCertification(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    //Method called on clicking Performance Dashboard on header
    public PageReference navigateToCalculator(){
        
        return FunnelNavigationHelper.navigateToCalculator(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    //Method called on clicking Home on header    
    public PageReference navigateToHomePage(){
        
        return FunnelNavigationHelper.navigateToHomePage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToDashboard(){
        
        //return FunnelNavigationHelper.navigateToDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    //Method called on clicking Reporting on header    
    public PageReference navigateToReportsPage(){
        
        //return FunnelNavigationHelper.navigateToReportsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        return FunnelNavigationHelper.navigateToReportsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    //Method called on clicking App Setup on header    
    public PageReference navigateToAppSetup(){
        
        return FunnelNavigationHelper.navigateToAppSetupPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToCertificateReports(){
        
        return FunnelNavigationHelper.navigateToCertificateReports(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }   
    
    public PageReference navigateToAnalytics(){
        
        return FunnelNavigationHelper.navigateToAnalytics(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
                
    } 
    public PageReference navigateToFunnelAnalyticQualitative(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    public PageReference navigateToTrendingByRep(){
        
        return FunnelNavigationHelper.navigateToTrendingByRep(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToTrendingBySkill(){
        
        return FunnelNavigationHelper.navigateToTrendingBySkill(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToFunnelAnalytic(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalytic(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToFunnelAnalytic(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    public PageReference navigateToAnnualizationDashboard(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    public PageReference navigateToFunnelAddEditSRP(){
        
        return FunnelNavigationHelper.navigateToFunnelAddEditSrp(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    public PageReference navigateToFunnelReviewGoals(){
        
        return FunnelNavigationHelper.navigateToFunnelReviewGoals(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    public PageReference navigateToFunnelSetup(){
        
        return FunnelNavigationHelper.navigateToFunnelSetup(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    public PageReference navigateToGoals(){
        
        return FunnelNavigationHelper.navigateToGoalsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    /*Navigation*/       
}