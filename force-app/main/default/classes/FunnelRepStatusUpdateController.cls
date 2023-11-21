/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelRepStatusUpdateController {
    
    public  List<EvaluationGuidelines__c> guildlineList {get;set;}
    public List <Certification_Answer__c> prevCa {get;set;}
    public List <Certification_Answer__c> prevCmnt {get;set;}
    public Boolean displayPopup {get;set;}
    public String popClose{get;set;}
    
    Public Map<String,String> managemenetReports{get;set;}
    
    public FunnelFilterWrapper fw {get; set;}
    public id mgId;
    public Map<id,string> updateListtop{get;set;}
    public Map<id,string> updateListtoplogin{get;set;}
    public Map<String,Map<id,string>> updateListtopMap  {get;set;}
    public String mnamelogin{get;set;}
    public boolean mapsizelogin{get;set;}
    public boolean tab{get;set;}
    
    //Variables to store the parameters passed in the URL
    public String label1 {get; set;}
    public String label2 {get; set;}
    public String label3 {get; set;}
    public String selectedLevel1 {get; set;}
    public String selectedLevel2 {get; set;}
    public String selectedLevel3 {get; set;}
    
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    
    //
    List<Certification_Answer__c> completeList = new List <Certification_Answer__c>();    
    
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
    
    public Certification__c c;
    //
    public String selectedId {get; set;}
    Boolean readAccess;
    public Integer mapSize {get; set;}
    
    public PageReference checkThemeAndNavigate(){        
        
        String source = ApexPages.currentPage().getParameters().get('source');
        system.debug(' source '+source);
        system.debug(' UserInfo.getUiThemeDisplayed() '+UserInfo.getUiThemeDisplayed());
        
        User u = [SELECT Name, UserPreferencesLightningExperiencePreferred FROM User WHERE id = :UserInfo.getUserId()];
        
        if(source == 'email' && u.UserPreferencesLightningExperiencePreferred  == true){            
            PageReference p = new PageReference('/one/one.app#/alohaRedirect/apex/FunnelMetrics__FunnelRepStatusUpdate');
            return p;
        }
        else{
            return null;
        }
    }
    
    public FunnelRepStatusUpdateController(){
        
        try{ 
            
            readAccess = true;
            
            List<String> fldList1 = new List<String>{prefix+'User_Record_name__c',prefix+'name',prefix+'Role__c',prefix+'Sales_Manager__c',prefix+'Tenure_in_current_role__c',prefix+'Territory__c'};                    
                
                Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList1){
                if(!fieldMap1.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            }
            
            List<String> fldList2 = new List<String>{prefix+'Certifcation_Rating__c',prefix+'Rating_Score__c',prefix+'Due_Date__c',prefix+'Certifcation__c',prefix+'Manager_Email_Date__c',prefix+'Escalation_Email_Date__c',prefix+'Rating_Start_Date__c'};                 
                
                Map <String, Schema.SObjectField> fieldMap2 = Schema.getGlobalDescribe().get(prefix+'Certification_Answer__c').getDescribe().fields.getMap();
            system.debug(' fieldMap2 '+fieldMap2);
            for(String fldName: fldList2){
                system.debug(' fieldMap2.get(fldName) '+fieldMap2.get(fldName));
                if(!fieldMap2.get(fldName).getDescribe().isAccessible()){
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
            
            List<String> fldList5 = new List<String>{prefix+'Overall_Rating__c',prefix+'Overall_Qualitative_Rating__c',prefix+'Overall_Quantitative_Rating__c',prefix+'Total_Quantitative_Weight__c',prefix+'Total_Quantitative_Weighted_Score__c'};                    
                
                Map <String, Schema.SObjectField> fieldMap5 = Schema.getGlobalDescribe().get(prefix+'Certification__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList5){
                if(!fieldMap5.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            }
            
            List<String> fldList6 = new List<String>{prefix+'Name', prefix+'Weight__c', prefix+'User_Type__c', prefix+'Timing__c', prefix+'Roles_enabled__c', prefix+'Rating_type__c', prefix+'Numeric_Weight__c', prefix+'Field_Name__c',prefix+'Display_Order__c',prefix+'Description__c',prefix+'Deactivated__c',prefix+'Category__c',prefix+'Calculation_type__c',prefix+'Assessment_type__c',prefix+'X4LevelLow__c',prefix+'X4LevelHigh__c',prefix+'X3LevelLow__c',prefix+'X3LevelHigh__c',prefix+'X2LevelLow__c',prefix+'X2LevelHigh__c',prefix+'X1LevelLow__c',prefix+'X1LevelHigh__c',prefix+'X0LevelLow__c',prefix+'X0LevelHigh__c'};
                
                Map <String, Schema.SObjectField> fieldMap6 = Schema.getGlobalDescribe().get(prefix+'Certification_Rating__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList6){
                if(!fieldMap6.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            }
            
            List<String> fldList = new List<String>{prefix+'Name', prefix+'Advance_Reminders__c',prefix +'Enable_Notifications__c',prefix+'Escalation__c',prefix+'Notification_Frequency__c'};
                
                Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(prefix+'Notification_Setting__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList){
                if(!fieldMap.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            }   
            
            mgId = UserInfo.getUserId();
            if(readAccess){ 
                label1 = ApexPages.currentPage().getParameters().get('labelOne');
                label2 = ApexPages.currentPage().getParameters().get('labelTwo');
                label3 = ApexPages.currentPage().getParameters().get('labelThree');
                selectedLevel1 = ApexPages.currentPage().getParameters().get('selectOne');
                selectedLevel2 = ApexPages.currentPage().getParameters().get('selectTwo');
                selectedLevel3 = ApexPages.currentPage().getParameters().get('selectThree');
                
                fw = new FunnelFilterWrapper();
                
                fw.userId = UserInfo.getUserId();
                
                FunnelFilterHelper.populateFilters(fw, 
                                                   label1, label2, label3,
                                                   selectedLevel1, selectedLevel2, selectedLevel3);
                
                
                List<Sales_Rep_Profile__c > cl = [SELECT id, name   FROM Sales_Rep_Profile__c WHERE User_Record_Name__c= : mgId  LIMIT 1];
                mnamelogin = cl[0].name;
                system.debug('cl pending'+cl );
                
                Set<id> mgrid = new set<id>();
                mgrid.add(cl[0].id);
                cl = [SELECT id, name  FROM Sales_Rep_Profile__c WHERE Interim_Manager__c IN :mgrid ];
                
                for(Sales_Rep_Profile__c im: cl){
                    mgrid.add(im.id);
                }
                
                list<Sales_Rep_Profile__c > sp =[SELECT id,name from Sales_Rep_Profile__c where Sales_Manager__c IN :mgrid AND Active__c = TRUE];
                system.debug('sp pending'+sp);
                
                Set<Id> repIds = new Set<Id>();
                
                for(Sales_Rep_Profile__c s: sp){
                    repIds.add(s.id);    
                    system.debug(' s.name '+s.name);
                }
                
                List<Sales_Rep_Profile__c> pendingSReps = [SELECT id, name,Manger_Name__c FROM Sales_Rep_Profile__c WHERE id in :repIds AND On_boarding_Date__c <= :System.today() AND Rep_Staus__c = 'New' AND Active__c = TRUE];
                system.debug(' pendingSReps '+pendingSReps);
                
                updateListtop = new Map<id,string>();
                updateListtoplogin =  new Map<id,string>();
                updateListtopMap = new Map<String,Map<id,string>>();
                
                for(Sales_Rep_Profile__c s : pendingSReps){
                    updateListtop = new Map<id,string>();                       
                    updateListtop.put(s.id,s.name);
                    
                    if(s.Manger_Name__c != null && s.Manger_Name__c != '' && !updateListtopMap.keySet().contains(s.Manger_Name__c) && s.Manger_Name__c != mnamelogin){
                        updateListtopMap.put(s.Manger_Name__c,updateListtop); 
                    }else if(s.Manger_Name__c != null && s.Manger_Name__c != '' && updateListtopMap.keySet().contains(s.Manger_Name__c)){
                        updateListtopMap.get(s.Manger_Name__c).putAll(updateListtop); 
                    }else if( s.Manger_Name__c == mnamelogin){
                        updateListtoplogin.put(s.id,s.name);
                    }
                    
                }
                
                if(updateListtop != null && updateListtop.size() > 0){
                    mapSize = updateListtop.size();
                }
                else{
                    mapSize = 0;
                }
                /*
set<id> spid= new set<id>();
spid= (new Map<Id,Sales_Rep_Profile__c >(sp)).keySet();

Map<Id,Certification__c> mapCerts = new Map<Id,Certification__c>([SELECT id FROM Certification__c WHERE Sales_Rep_Profile__c IN :spid]);
Set<id> certs = mapCerts.keySet();
system.debug('certs pending'+certs );

list<Certification_Answer__c> updatecerti = new list<Certification_Answer__c  >();
updatecerti = [SELECT Rating_Start_Date__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c,Certifcation__r.Sales_Rep_Profile__c,Certifcation__r.Sales_Rep_Profile__r.name, Due_Date__c, Certifcation_Rating__c, Id 
FROM Certification_Answer__c  WHERE  Rating_Start_Date__c <= today AND Rating_Score__c = null AND Certifcation__c IN :certs ];


updateListtop = new Map<id,string>();

for(Certification_Answer__c  c : updatecerti ){

system.debug('updatecerti pending'+c.Certifcation__r.Sales_Rep_Profile__c ); 

if( c.Certifcation__r.Sales_Rep_Profile__c != null  &&  (string)c.Certifcation__r.Sales_Rep_Profile__c != '' && !updateListtop.keySet().contains(c.Certifcation__r.Sales_Rep_Profile__c)){

updateListtop.put(c.Certifcation__r.Sales_Rep_Profile__c,c.Certifcation__r.Sales_Rep_Profile__r.name);
}    
}*/
                mapsizelogin = updateListtoplogin.isEmpty();
                tab =false;
                
                FunnelUpdate();
                
                /*
managemenetReports = new Map<String,String>();

User u = [SELECT Name, UserPreferencesLightningExperiencePreferred FROM User WHERE id = :UserInfo.getUserId()];

List<String> dashList = new List<String>();
dashList.add('mXaDybYGcSDujlyIRRJQxUrUEqXiFe');

managemenetReports = FunnelNavigationHelper.fetchDashboards(dashList,u);*/
                displayPopup = false;
                guildlineList = [select id,name,Description__c,order__c from  EvaluationGuidelines__c ORDER BY order__c ASC limit 5];
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelRepStatusUpdateController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());  
        } 
    }
    public void popup(){
        
        if(popClose == 'pop'){
            displayPopup = true;
        }else if(popClose == 'close'){
            displayPopup = false;
        }
        
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
    
    public void FunnelUpdate() {            
        if(readAccess){
            salesRepId = ApexPages.currentPage().getParameters().get('id');
            system.debug(' salesRepId is '+salesRepId);
            Map <String,List<Certification_Answer__c>> prevCaMap = new Map <String,List<Certification_Answer__c>>();
            prevCa = new List<Certification_Answer__c>();
            prevCmnt = new List<Certification_Answer__c>();
            if(salesRepId != null){
                
                sr = [SELECT id,Profile_Type__c , Name, Annual_Quota_Amount__c, User_Record_Name__r.title, Role__c, Rep_Staus__c, Territory__c, Sales_Manager__r.Name, Tenure_in_current_role__c, User_Record_Name__r.CreatedDate FROM Sales_Rep_Profile__c WHERE id = :salesRepId];
                
                List<Certification__c> cList = [SELECT id, Sales_Rep_Profile__c  FROM Certification__c WHERE Sales_Rep_Profile__c = :sr.id];
                
                c = cList[0];
                system.debug('c --'+c );
                
                
                if(cList != null && cList.size() > 0){
                    
                    //List<Certification_Rating__c> ratings = [SELECT id, Category__c, Description FROM Certification_Rating__c WHERE Deactivated = false AND Roles_enabled__c INCLUDES :sr.Role__c AND Assessment_type__c = 'Qualitative' AND (User_Type__c = :sr.Rep_Staus__c  OR User_Type__c = 'Both')];         
                    List<Certification_Rating__c> ratings = [SELECT id, name, Calculation_type__c, Category__c, Assessment_Type__c, Description__c FROM Certification_Rating__c WHERE Deactivated__c = FALSE AND Assessment_Type__c = 'Qualitative' AND Roles_enabled__c INCLUDES (:sr.Role__c) AND (User_Type__c = 'Tenured' OR User_Type__c = 'Both') ORDER BY Display_Order__c];
                    
                    for(Certification_Rating__c cr: ratings){
                        
                        Certification_Answer__c ca = new Certification_Answer__c();
                        ca.Certifcation__c = cList[0].id;
                        ca.Certifcation_Rating__c = cr.id;
                        ca.Rating_description__c = cr.Description__c;
                        ca.Rating_Start_Date__c = Date.today();
                        Integer noOfDays = Date.daysInMonth(Date.today().year(),Date.today().month());
                        ca.Due_Date__c = Date.newInstance(Date.today().year(),Date.today().month(),noOfDays);
                        
                        ca.Rating_Calculation_type__c = cr.Calculation_type__c;
                        ca.Name = cr.Name;
                        ca.Sales_rep_profile__c = salesRepId;
                        
                        system.debug(' ca.Certifcation_Rating__r.Description__c '+ca.Certifcation_Rating__r.Description__c);
                        system.debug(' cr.id '+cr.id);
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
                        if(updateMap == null || updateMap.size() <= 0){
                            List<Certification_Answer__c> caList = new List<Certification_Answer__c>();
                            caList.add(ca);
                            updateMap.put('Qualitative Ratings',caList);
                        }
                        else{
                            updateMap.get('Qualitative Ratings').add(ca);
                        }
                        
                        system.debug(' update map value '+ca);
                    }
                    system.debug(' prevCa '+prevCa);
                }
                
                
                /*
c = [SELECT id, Overall_Qualitative_Rating__c, Overall_Quantitative_Rating__c, Total_Quantitative_Weight__c, Total_Quantitative_Weighted_Score__c FROM Certification__c WHERE Sales_Rep_Profile__c = : sr.id];

Date todaysDate = Date.today();

//Find the monthly ratings

List<Certification_Answer__c> monthlyDate = [SELECT Rating_Start_Date__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id FROM Certification_Answer__c WHERE Certifcation__r.Sales_Rep_Profile__c = :salesRepId AND Certifcation_Rating__r.Timing__c = 'End of month' AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative' AND Rating_Start_Date__c <= :todaysDate ORDER BY Rating_Start_Date__c DESC LIMIT 1];

system.debug(' monthlyDate '+monthlyDate);

if(monthlyDate != null && monthlyDate.size() > 0){

List<Certification_Answer__c> monthlyRatings = new List<Certification_Answer__c> ();

monthlyRatings =  [SELECT Certifcation_Rating__r.Description__c, Certifcation_Rating__r.Weight__c, Certifcation_Rating__r.Category__c, Rating_Start_Date__c, Tenatative_rating_score__c, Weighted_Score__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id FROM Certification_Answer__c WHERE Certifcation__r.Sales_Rep_Profile__c = :salesRepId AND Certifcation_Rating__r.Timing__c = 'End of month' AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative' AND Rating_Start_Date__c = :monthlyDate[0].Rating_Start_Date__c]; 

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

List<Certification_Answer__c> quarterlyDate = [SELECT Rating_Start_Date__c, Certifcation_Rating__r.Weight__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id FROM Certification_Answer__c WHERE Certifcation__r.Sales_Rep_Profile__c = :salesRepId AND Certifcation_Rating__r.Timing__c = 'End of quarter' AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative'  AND Rating_Start_Date__c <= :todaysDate ORDER BY Rating_Start_Date__c DESC LIMIT 1];

if(quarterlyDate != null && quarterlyDate.size() > 0){

List<Certification_Answer__c> quarterlyRatings = new List<Certification_Answer__c> ();                        

quarterlyRatings =  [SELECT Certifcation_Rating__r.Description__c, Certifcation_Rating__r.Weight__c, Certifcation_Rating__r.Category__c, Rating_Start_Date__c, Tenatative_rating_score__c, Weighted_Score__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id FROM Certification_Answer__c WHERE Certifcation__r.Sales_Rep_Profile__c = :salesRepId AND Certifcation_Rating__r.Timing__c = 'End of quarter' AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative'  AND Rating_Start_Date__c = :quarterlyDate[0].Rating_Start_Date__c]; 

if(quarterlyDate[0].Rating_Score__c == null){
quarterlyUpdateable = true;
quarterlyDueDate = quarterlyDate[0].Due_Date__c; 
updateList.addAll(quarterlyRatings);
}
else{
staticList.addAll(quarterlyRatings);
}
}

//Find the biannual ratings

List<Certification_Answer__c> biannualDate = [SELECT Rating_Start_Date__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id FROM Certification_Answer__c WHERE Certifcation__r.Sales_Rep_Profile__c = :salesRepId AND Certifcation_Rating__r.Timing__c = 'Bi-annual' AND Rating_Start_Date__c <= :todaysDate AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative'  ORDER BY Rating_Start_Date__c DESC LIMIT 1];

if(biannualDate != null && biannualDate.size() > 0){

List<Certification_Answer__c> biannualRatings = new List<Certification_Answer__c> ();                        

biannualRatings =  [SELECT Certifcation_Rating__r.Description__c, Certifcation_Rating__r.Weight__c, Certifcation_Rating__r.Category__c, Rating_Start_Date__c, Tenatative_rating_score__c, Weighted_Score__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id FROM Certification_Answer__c WHERE Certifcation__r.Sales_Rep_Profile__c = :salesRepId AND Certifcation_Rating__r.Timing__c = 'Bi-annual' AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative'  AND Rating_Start_Date__c = :biannualDate[0].Rating_Start_Date__c]; 

if(biannualDate[0].Rating_Score__c == null){
biannualUpdateable = true;
biannualDueDate = biannualDate[0].Due_Date__c;
updateList.addAll(biannualRatings);
}
else{
staticList.addAll(biannualRatings);
}
}

//Find the annual ratings

List<Certification_Answer__c> annualDate = [SELECT Rating_Start_Date__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id FROM Certification_Answer__c WHERE Certifcation__r.Sales_Rep_Profile__c = :salesRepId AND Certifcation_Rating__r.Timing__c = 'Annual' AND Rating_Start_Date__c <= :todaysDate AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative'  ORDER BY Rating_Start_Date__c DESC LIMIT 1];

if(annualDate != null && annualDate.size() > 0){

List<Certification_Answer__c> annualRatings = new List<Certification_Answer__c> ();                        

annualRatings =  [SELECT Certifcation_Rating__r.Description__c, Certifcation_Rating__r.Weight__c, Certifcation_Rating__r.Category__c, Rating_Start_Date__c, Tenatative_rating_score__c, Weighted_Score__c, Rating_Score__c, Escalation_Email_Date__c, Manager_Email_Date__c, Certifcation__c, Due_Date__c, Certifcation_Rating__c, Id FROM Certification_Answer__c WHERE Certifcation__r.Sales_Rep_Profile__c = :salesRepId AND Certifcation_Rating__r.Timing__c = 'Annual' AND Certifcation_Rating__r.Assessment_Type__c = 'Qualitative'  AND Rating_Start_Date__c = :annualDate[0].Rating_Start_Date__c]; 

if(annualDate[0].Rating_Score__c == null){
annualUpdateable = true;
annualDueDate = annualDate[0].Due_Date__c;
updateList.addAll(annualRatings);
}
else{
staticList.addAll(annualRatings);
}
}

system.debug( ' updateList '+updateList);

for(Certification_Answer__c ca: updateList){

system.debug(' ca.Rating_Score__c '+ca.Rating_Score__c);
system.debug(' ca.Tentative_Rating_Score__c '+ca.Rating_Score__c);
if((ca.Rating_Score__c == null) && (ca.Tenatative_rating_score__c != null)){
ca.Rating_Score__c = ca.Tenatative_rating_score__c;
}

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



system.debug(' inside constructor '+completeList);

for(Certification_Answer__c ca:completeList){
system.debug('weighted score '+ca.Weighted_Score__c);
system.debug('weight '+ca.Certifcation_Rating__r.Weight__c);
}*/
                
                tab =true;
            }
            else{
                tab =false;
            }
        }
    }
    
    public PageReference submit(){
        try{    
            system.debug('inside submit');
            
            updateList = new List<Certification_Answer__c>();
            
            for (String key : updateMap.keySet()) {
                
                List<Certification_Answer__c> upd = updateMap.get(key);
                updateList.addAll(upd);
            }
            
            Boolean updateAccess = true;
            
            List<String> fldList1 = new List<String>{prefix+'Rating_Score__c'};
                
                Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Certification_Answer__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList1){
                if(!fieldMap1.get(fldName).getDescribe().isUpdateable()){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                    updateAccess = false;
                    system.debug(' cannot update score ');
                }                           
            } 
            
            if(updateAccess){
                
                for(Certification_Answer__c ca: updateList){            
                    
                    if(ca.Rating_Score__c == null){
                        ca.Rating_Score__c = 0;
                    }
                    
                    system.debug(' ca.Rating_Score__c '+ca.Rating_Score__c);
                }
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                system.debug(' cannot update score ');
                return null;
            }
            
            if(Schema.getGlobalDescribe().get(prefix+'Certification_Answer__c').getDescribe().isCreateable()){                      
                insert updateList;
            }            
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                system.debug(' cannot create ratings ');
                return null;
            }
            
            system.debug(updateList+ '  updateList ');
            
            system.debug(' Schema.getGlobalDescribe.isDeletable '+Schema.getGlobalDescribe().get(prefix+'Certification_Answer__c').getDescribe().isDeletable());
            
            if(Schema.getGlobalDescribe().get(prefix+'Certification_Answer__c').getDescribe().isDeletable()){                      
                deleteRatings();
            }
            
            List<Certification__c> cert = new List<Certification__c>();
            cert.add(c);
            
            if(FunnelCalculationHelper.findIfManager(cert)){            
                calculateScore(updateList,true);            
            }
            if(!FunnelCalculationHelper.findIfManager(cert) && sr.Profile_Type__c == 'Overlay'){
                calculateScore(updateList,false);
            }
            
            updateAccess = true;
            
            List<String> fldList2 = new List<String>{prefix+'Rep_Staus__c'};
                
                Map <String, Schema.SObjectField> fieldMap2 = Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList2){
                if(!fieldMap2.get(fldName).getDescribe().isUpdateable()){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                    updateAccess = false;
                }                           
            }
            
            if(updateAccess){
                sr.Rep_Staus__c = 'Tenured';
            }
            
            if(Schema.getGlobalDescribe().get(prefix+'Sales_Rep_Profile__c').getDescribe().isUpdateable()){ 
                update sr;
            }            
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
            }
            
            createNewRatings();    
            
            PageReference p = new PageReference('/apex/FunnelRepStatusUpdate?labelOne='+label1+'&labelTwo='+label2+'&labelThree='+label3+'&selectOne='+selectedLevel1+'&selectTwo='+selectedLevel2+'&selectThree='+selectedLevel3);
            p.setRedirect(true);
            return p;
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelRepStatusUpdateController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());  
            return null;
        } 
        
    } 
    
    private void calculateScore(List<Certification_Answer__c> cl, Boolean isManager){
        
        List<Id> idsToQuery = new List<Id>();
        
        for(Certification_Answer__c ca: cl){
            idsToQuery.add(ca.id);    
        }    
        
        List<AggregateResult> li = new List<AggregateResult>();
        
        system.debug(' answers to query '+idsToQuery);
        
        li = [SELECT  COUNT(id) c, SUM(Rating_score__c) s FROM Certification_Answer__c WHERE id IN :idsToQuery];                
        
        Boolean updateAccess = true;
        
        List<String> fldList1 = new List<String>{prefix+'Overall_Qualitative_Rating__c',prefix+'overall_rating__c',prefix+'total_qualitative_weight__c',prefix+'total_qualitative_weighted_score__c'};
            
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
            
            /* M c.Overall_Qualitative_Rating__c  = (Decimal)li[0].get('s')/(Decimal)li[0].get('w');
c.Individual_Qualitative_Rating__c = c.Overall_Qualitative_Rating__c;

c.Total_Qualitative_Weighted_Score__c = (Decimal)li[0].get('s');
c.Total_Qualitative_Weight__c = (Decimal)li[0].get('w'); M */
            
            /*M   if(FunnelCalculationHelper.findIfManager(c)){
c.Management_Qualitative_Score__c = c.Overall_Qualitative_Rating__c;
} M*/
            /*
Decimal Sum = 0;

if(c.Overall_Qualitative_Rating__c != null)
sum += c.Overall_Qualitative_Rating__c;

if(c.Overall_Quantitative_Rating__c != null)
sum += c.Overall_Quantitative_Rating__c;

c.Overall_Rating__c = (Decimal)sum/2;
system.debug(' c.Overall_Rating__c '+c.Overall_Rating__c);            

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
            system.debug(' error '); 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
        }
        
        if(Schema.getGlobalDescribe().get(prefix+'Certification__c').getDescribe().isUpdateable()){ 
            system.debug(' updated ');                     
            update c;
            List<Certification__c> cert = new List<Certification__c>();
            cert.add(c);
            
            FunnelCalculationHelper.calculateAggregateScoreForManagers(cert);            
        }            
        else{
            system.debug(' error '); 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
        }
        
        
    }            
    
    private void deleteRatings(){
        
        List<Certification_Answer__c> cans = [SELECT id FROM Certification_Answer__c WHERE Certifcation_Rating__r.Assessment_Type__c = 'Qualitative' AND Rating_Score__c = null AND Certifcation__c = :c.id];
        
        if(Schema.sObjectType.Certification_Answer__c.isDeletable()){ 
            DELETE cans;
        }
    }
    
    private void createNewRatings(){
        
        Notification_Setting__c ns = [SELECT Id, Enable_Notifications__c, Advance_Reminders__c, Notification_Frequency__c, Escalation__c,Last_Date_for_submit__c  FROM Notification_Setting__c LIMIT 1];
        
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
            
            /*Creation of monthly ratings*/
            
            questions = [SELECT Id, Name, User_Type__c, Assessment_type__c, Deactivated__c, Roles_enabled__c, Timing__c FROM Certification_Rating__c WHERE Assessment_type__c = 'Qualitative' AND Deactivated__c = false AND (User_Type__c = :sr.Rep_Staus__c OR User_Type__c='Both') AND Timing__c = 'End of month' AND Roles_enabled__c includes (:sr.Role__c)];        
            
            //Date nextDue = monthlyDueDate.addMonths(1);
            
            Integer noOfDays = Date.daysInMonth(Date.today().year(),Date.today().month());
            
            Date dueDate = Date.newInstance(Date.today().year(),Date.today().month(),noOfDays);
            
            //DateTime dueDate = Date.newInstance(nextDue.year(),nextDue.month(),noOfDays);
            
            system.debug(' noOfDays '+noOfDays);
            
            system.debug(' dueDate '+dueDate);
            
            for(Certification_Rating__c cr: questions){
                
                Certification_Answer__c ca = new Certification_Answer__c();
                ca.Name = cr.Name;
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
                system.debug(' newAnsList is '+newAnsList);
            }
            
            /*Creation of quarterly ratings*/
            
            questions = [SELECT Id, Name, User_Type__c, Assessment_type__c, Deactivated__c, Roles_enabled__c, Timing__c FROM Certification_Rating__c WHERE Assessment_type__c = 'Qualitative' AND Deactivated__c = false AND (User_Type__c = :sr.Rep_Staus__c OR User_Type__c='Both') AND Timing__c = 'End of quarter' AND Roles_enabled__c includes (:sr.Role__c)];        
            system.debug(' quarterly '+questions);
            system.debug(' quarterlyDueDate '+quarterlyDueDate);
            
            /*DateTime quarStartDateTime = FunnelCalculationHelper.getQuarterStartDate();
quarStartDateTime = quarStartDateTime.addMonths(2);

noOfDays = Date.daysInMonth(quarStartDateTime.year(),quarStartDateTime.month());

dueDate = Date.newInstance(quarStartDateTime.year(),quarStartDateTime.month(),noOfDays);*/
            
            dueDate = FunnelCalculationHelper.getQuarterEndInDateFormat(Date.today());
            
            //DateTime dueDate = Date.newInstance(nextDue.yearGMT(),nextDue.monthGMT(),noOfDays);
            
            //system.debug(' noOfDays '+noOfDays);
            
            system.debug(' dueDate '+dueDate);
            
            for(Certification_Rating__c cr: questions){
                
                Certification_Answer__c ca = new Certification_Answer__c();
                ca.Name = cr.Name;
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
            
            /*Creation of biannual ratings*/
            
            questions = [SELECT Id, Name, User_Type__c, Assessment_type__c, Deactivated__c, Roles_enabled__c, Timing__c FROM Certification_Rating__c WHERE Assessment_type__c = 'Qualitative' AND Deactivated__c = false AND (User_Type__c = :sr.Rep_Staus__c OR User_Type__c='Both') AND Timing__c = 'Bi-annual' AND Roles_enabled__c includes (:sr.Role__c)];        
            system.debug(' biannual '+questions);
            
            DateTime Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
            
            DateTime month6Start = Fyear.addMonths(5);
            system.debug(' month6Start '+month6Start);
            
            noOfDays = Date.daysInMonth(month6Start.yeargmt(),month6Start.monthgmt());
            
            dueDate = Date.newInstance(month6Start.yeargmt(),month6Start.monthgmt(),noOfDays);
            system.debug(' dueDate '+dueDate);
            
            if(Date.today() > dueDate){
                dueDate = dueDate.addMonths(6);
                noOfDays = Date.daysInMonth(dueDate.year(),dueDate.month());
                dueDate = Date.newInstance(dueDate.year(),dueDate.month(),noOfDays);
            }
            //DateTime dueDate = Date.newInstance(nextDue.year(),nextDue.month(),noOfDays);
            
            for(Certification_Rating__c cr: questions){
                
                Certification_Answer__c ca = new Certification_Answer__c();
                ca.Name = cr.Name;
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
            
            /*Creation of annual ratings*/  
            
            
            questions = [SELECT Id, Name, User_Type__c, Assessment_type__c, Deactivated__c, Roles_enabled__c, Timing__c FROM Certification_Rating__c WHERE Assessment_type__c = 'Qualitative' AND Deactivated__c = false AND (User_Type__c = :sr.Rep_Staus__c OR User_Type__c='Both') AND Timing__c = 'Annual' AND Roles_enabled__c includes (:sr.Role__c)];        
            system.debug(' annual '+questions);
            
            Fyear = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
            DateTime month12Start = Fyear.addMonths(11);
            
            noOfDays = Date.daysInMonth(month12Start.yeargmt(),month12Start.monthgmt());
            
            dueDate = Date.newInstance(month12Start.yeargmt(),month12Start.monthgmt(),noOfDays);
            //DateTime dueDate = Date.newInstance(nextDue.year(),nextDue.month(),noOfDays);
            
            for(Certification_Rating__c cr: questions){
                Certification_Answer__c ca = new Certification_Answer__c();
                ca.Name = cr.Name;
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
    /*
public PageReference saveForLater(){

updateList = new List<Certification_Answer__c> ();

for (String key : updateMap.keySet()) {

List<Certification_Answer__c> upd = updateMap.get(key);
updateList.addAll(upd);
}

Boolean updateAccess = true;

List<String> fldList1 = new List<String>{prefix+'Tenatative_rating_score__c',prefix+'Rating_Score__c'};

Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Certification_Answer__c').getDescribe().fields.getMap();

for(String fldName: fldList1){
if(!fieldMap1.get(fldName).getDescribe().isUpdateable()){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
updateAccess = false;
}                           
} 

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

PageReference p = new PageReference('/apex/FunnelCertificationupdate?labelOne='+label1+'&labelTwo='+label2+'&labelThree='+label3+'&selectOne='+selectedLevel1+'&selectTwo='+selectedLevel2+'&selectThree='+selectedLevel3);
system.debug('p'+p);
p.setRedirect(true);
return p;

} */
    
    /*Navigation*/
    public PageReference navigateToDashboard(){
        
        //return FunnelNavigationHelper.navigateToDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToCertification(){
        
        //return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToCertification(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    //Method called on clicking Performance Dashboard on header
    public PageReference navigateToCalculator(){
        
        return FunnelNavigationHelper.navigateToCalculator(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    //Method called on clicking Home on header    
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
    
    public PageReference navigateToAnalytics(){
        
        return FunnelNavigationHelper.navigateToAnalytics(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToTrendingByRep(){
        
        return FunnelNavigationHelper.navigateToTrendingByRep(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToFunnelAnalytic(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToFunnelAnalytic(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToSalesPipeline(){
        
        return FunnelNavigationHelper.navigateToSalesPipeline(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToTrendingBySkill(){
        
        return FunnelNavigationHelper.navigateToTrendingBySkill(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    } 
    
    public PageReference navigateToDetailPage(){
        
        PageReference redirect;
        
        if(label1 != null && label1 != '')
            redirect = new PageReference('/apex/FunnelRepStatusUpdate?id='+selectedId+'&labelOne='+fw.labelOne+'&labelTwo='+fw.labelTwo+'&labelThree='+fw.labelThree+'&selectOne='+fw.selectedLevelOne+'&selectTwo='+fw.selectedLevelTwo+'&selectThree='+fw.selectedLevelThree); 
        else
            redirect = new PageReference('/apex/FunnelRepStatusUpdate?id='+selectedId); 
        
        redirect.setRedirect(true);     
        return redirect;
    }    
    
    public PageReference navigateToFunnelAnalyticQualitative(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    
    public PageReference navigateToAnnualizationDashboard(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree,fw.selectedLevelFour);
    }
    public PageReference navigateToGoals(){
        
        return FunnelNavigationHelper.navigateToGoalsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    /*Navigation*/ 
    
    
}