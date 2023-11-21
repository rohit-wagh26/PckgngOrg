/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelCertificationRating_Controller{

    public FunnelCertificationRating_Controller(FunnelInstallationStep4aController controller) {
        defaultConstructor();
    }

    
    public List<String> RatingNames{get;set;}

    Public Map<String,String> managemenetReports{get;set;}
       
    private Map<String,List<Certification_Rating__c>> ratingListValue = new Map<String,List<Certification_Rating__c>>();
    
    public Map<String,List<Certification_Rating__c>> ratingList{
    
        get{
            return ratingListValue; 
        }
        set{
            ratingListValue = value;
        }
    }
    
    private List<Certification_Rating__c> questListValue = new List<Certification_Rating__c>();
    
    public List<Certification_Rating__c> questList{
        get{
            return questListValue; 
        }
        set{
            questListValue = value;
        }
    }
    
    private List<SelectOption> catListValue = new List<SelectOption>();
    
    public List<SelectOption> catList{
        get{
            return catListValue; 
        }
        set{
            catListValue = value;
        }
    }
    
    public boolean showPanel{get; set;}
    
    public Id ratingId{get; set;}
    
    public Certification_Rating__c ratingSelected{get; set;}
    public Certification_Rating__c copyratingSelected{get;set;}
    public Boolean callAnsCreateDelete;
    
    private Boolean sRep;
    
    public Boolean isRep{
        get{
            return sRep;
        }
        set{
            sRep = value;
        }
    }        
    
    /* Filters */    
    public FunnelFilterWrapper fw {get; set;}
    
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
    
    public static String prefix{ get{return 'FunnelMetrics__';} set; }
    
    //Variable that indicates reset button has been clicked
    public boolean isReset {get; set;}
        
    //Variables to store the parameters passed in the URL
    public String label1{get; set;}
    public String label2{get; set;}
    public String label3{get; set;}
    public String selectedLevel1{get; set;}
    public String selectedLevel2{get; set;}
    public String selectedLevel3{get; set;}
    public Boolean readAccess = true;
    /* Filters */
    
     public Boolean adminPer{get;set;}
    public Boolean isManger{get;set;}
    
    public Integer apiIdentifierQual{get; set;}
    
    public FunnelCertificationRating_Controller(){
        defaultConstructor();
           
    }
    
    public void defaultConstructor(){
        try{    
            catTextVisible = false;
            
            List<AggregateResult> asperm = [SELECT count(Id) c FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = 'Funnel_App_Setup'];
            if((asperm != null && asperm.size() > 0 && asperm[0].get('c') != null && (Integer)asperm[0].get('c') > 0)   ){
                adminPer= true;
            }else{
                adminPer= false;
            }
            
            isManger = FunnelTriggerBatchHelper.isManager(UserInfo.getUserId());
            /*List<String> fldList1 = new List<String>{prefix+'Name', prefix+'Weight__c', prefix+'User_Type__c', prefix+'Timing__c', prefix+'Roles_enabled__c', prefix+'Rating_type__c', prefix+'Numeric_Weight__c', prefix+'Field_Name__c',prefix+'Display_Order__c',prefix+'Description__c',prefix+'Deactivated__c',prefix+'Category__c',prefix+'Calculation_type__c',prefix+'Assessment_type__c',prefix+'X4LevelLow__c',prefix+'X4LevelHigh__c',prefix+'X3LevelLow__c',prefix+'X3LevelHigh__c',prefix+'X2LevelLow__c',prefix+'X2LevelHigh__c',prefix+'X1LevelLow__c',prefix+'X1LevelHigh__c',prefix+'X0LevelLow__c',prefix+'X0LevelHigh__c'};                            
            
            Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Certification_Rating__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList1){
                if(!fieldMap1.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            }*/
            
            if(readAccess){ 
            
                questListValue = [SELECT Id, OwnerId, IsDeleted, Name, Timing__c, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Description__c, User_Type__c, Assessment_type__c, Weight__c, Calculation_type__c, Deactivated__c, Roles_enabled__c, X0LevelLow__c, X0LevelHigh__c, X1LevelLow__c, X1LevelHigh__c, X2LevelLow__c, X2LevelHigh__c, X3LevelLow__c, X3LevelHigh__c, X4LevelLow__c, X4LevelHigh__c, Category__c FROM Certification_Rating__c where Custom_Object_Name__c ='' ORDER BY Category__c DESC , Display_Order__c ASC, CreatedDate DESC LIMIT 2000];
                                
                for(Certification_Rating__c q : questListValue){
                    
            if(q.Category__c != null && q.Category__c != '' && q.Category__c == 'Qualitative' && !ratingListValue.keySet().contains('b')){
                    
                        List<Certification_Rating__c> wr = new List<Certification_Rating__c>();        
                        wr.add(q);    
                ratingListValue.put('b',wr);
            }else if(q.Category__c != null && q.Category__c != '' && q.Category__c == 'Quantitative' && !ratingListValue.keySet().contains('a')){
                List<Certification_Rating__c> wr = new List<Certification_Rating__c>();        
                wr.add(q);
                ratingListValue.put('a',wr);
            }else if(q.Category__c != null && q.Category__c != '' && q.Category__c == 'Qualitative' && ratingListValue.keySet().contains('b')){
                ratingListValue.get('b').add(q);
            }else if(q.Category__c != null && q.Category__c != ''  && q.Category__c == 'Quantitative' && ratingListValue.keySet().contains('a')){
                ratingListValue.get('a').add(q);
                    }
                }
                
                fetchCategory();
            }
            
            if(ratingListValue.get('b') != null){
                apiIdentifierQual = ratingListValue.get('b').size();
                //system.debug('apiIdentifierQual --'+apiIdentifierQual );
            }else{
                apiIdentifierQual = 0;
            }
            /*filters*/
            label1 = ApexPages.currentPage().getParameters().get('labelOne');
            label2 = ApexPages.currentPage().getParameters().get('labelTwo');
            label3 = ApexPages.currentPage().getParameters().get('labelThree');
            selectedLevel1 = ApexPages.currentPage().getParameters().get('selectOne');
            selectedLevel2 = ApexPages.currentPage().getParameters().get('selectTwo');
            selectedLevel3 = ApexPages.currentPage().getParameters().get('selectThree'); 
        
        /*
        managemenetReports = new Map<String,String>();
        
        User u = [SELECT Name, UserPreferencesLightningExperiencePreferred FROM User WHERE id = :UserInfo.getUserId()];
        
        List<String> dashList = new List<String>();
        dashList.add('mXaDybYGcSDujlyIRRJQxUrUEqXiFe');
        
        managemenetReports = FunnelNavigationHelper.fetchDashboards(dashList,u);*/
        ratingName();
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelCertificationRating_Controller '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        }
    
    }
     public void ratingName(){
     /* RatingNames =  new List<String>();
      Schema.DescribeFieldResult statusFieldDescription = Certification_Answer__c.Rating_name_picklist__c.getDescribe();
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues()){ 
             RatingNames.add(pickListEntry.getLabel());
        }
     */
     }

    
    private void fetchCategory(){
        if(readAccess){ 
            List<AggregateResult> li = [SELECT Category__c c FROM Certification_Rating__c WHERE Category__c != null GROUP BY Category__c Order By Category__c  DESC];
        
            for(AggregateResult ar: li){
                catListValue.add(new SelectOption((String)ar.get('c'),(String)ar.get('c')));        
            }
         }
    }
    
    public void displayAddEditRating(){
        if(readAccess){ 
            showPanel = true;    
            system.debug(' ratingId '+ratingId);
            copyratingSelected = new Certification_Rating__c();
            callAnsCreateDelete = false;
            if(ratingId != null){ 
                    ratingSelected = [SELECT Id, OwnerId, IsDeleted, Name, Timing__c, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Description__c, User_Type__c, Assessment_type__c,  Weight__c, Calculation_type__c, Deactivated__c, Roles_enabled__c, X0LevelLow__c, X0LevelHigh__c, X1LevelLow__c, X1LevelHigh__c, X2LevelLow__c, X2LevelHigh__c, X3LevelLow__c, X3LevelHigh__c, X4LevelLow__c, X4LevelHigh__c, Category__c,Rating_type__c,Field_Name__c,Training_Url__c FROM Certification_Rating__c WHERE id = :ratingId];
                    
                    copyratingSelected  = [SELECT Id, OwnerId, IsDeleted, Name, Timing__c, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Description__c, User_Type__c, Assessment_type__c,  Weight__c, Calculation_type__c, Deactivated__c, Roles_enabled__c, X0LevelLow__c, X0LevelHigh__c, X1LevelLow__c, X1LevelHigh__c, X2LevelLow__c, X2LevelHigh__c, X3LevelLow__c, X3LevelHigh__c, X4LevelLow__c, X4LevelHigh__c, Category__c,Rating_type__c,Field_Name__c,Training_Url__c FROM Certification_Rating__c WHERE id = :ratingId];
                    System.debug('copyratingSelected  --'+copyratingSelected  );
                }
           else{
                ratingSelected = new Certification_Rating__c();
                ratingSelected.Assessment_type__c = 'Qualitative';
                Integer csize = 1;
                /*List<Certification_Rating__c> crlApi = [Select id from Certification_Rating__c Where Assessment_type__c = 'Qualitative'];
                if(crlApi != null && crlApi.size() > 0){
                    csize = crlApi.size() + 1;
                }
                ratingSelected.API_Identifier_Qual__c = csize;*/
                callAnsCreateDelete = true;
            }
            catTextVisible = false;
        }
    }
    

    public void hideAddEditRating(){

        showPanel = false; 
        ratingId = null; 
        callAnsCreateDelete = false;  
                
    }
    
    public void saveRating(){
        
        try{ 
            system.debug('ratingSelected'+ratingSelected);
            List<String> fldList1 = new List<String>{prefix+'Category__c',prefix+'Assessment_type__c'};
                
            Boolean updateAccess = true;
                        
            Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Certification_Rating__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList1){
                if(!fieldMap1.get(fldName).getDescribe().isUpdateable()){
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                  updateAccess = false;
                }
                if(!fieldMap1.get(fldName).getDescribe().isCreateable()){
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                  updateAccess = false;
                }                
            }
            
            if(updateAccess ){
                if(ratingSelected.Category__c != 'Quantitative'){
                    ratingSelected.Category__c = 'Qualitative';
                    
                    
                    if((ratingSelected.Timing__c != copyratingSelected.Timing__c) || (ratingSelected.User_Type__c != copyratingSelected.User_Type__c)){
                        callAnsCreateDelete = true;
                    }
               }  
                //system.debug('API_Identifier_Qual__c '+ratingSelected.API_Identifier_Qual__c);
            }
                                  
            if(Schema.getGlobalDescribe().get(prefix+'Certification_Rating__c').getDescribe().isCreateable() && Schema.getGlobalDescribe().get(prefix+'Certification_Rating__c').getDescribe().isUpdateable()){
                upsert ratingSelected;
                system.debug('callAnsCreateDelete --'+callAnsCreateDelete );
                if(callAnsCreateDelete){
                     Set<id> certidA = new Set<id>();
                     certidA.add(ratingSelected.id);
                     FunnelCreateCertAnswers_Controller.deleteAndCreateCertAnswersAppSetup(certidA,true,true,'All');
                    //ansCreDel();
                }
            }
            
            hideAddEditRating();
        
        
        questListValue = [SELECT Id, OwnerId, IsDeleted, Name, Timing__c, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Description__c, User_Type__c, Assessment_type__c, Weight__c, Calculation_type__c, Deactivated__c, Roles_enabled__c, X0LevelLow__c, X0LevelHigh__c, X1LevelLow__c, X1LevelHigh__c, X2LevelLow__c, X2LevelHigh__c, X3LevelLow__c, X3LevelHigh__c, X4LevelLow__c, X4LevelHigh__c, Category__c FROM Certification_Rating__c where Custom_Object_Name__c ='' ORDER BY Display_Order__c ASC, CreatedDate DESC LIMIT 2000];
           ratingListValue.clear();
           for(Certification_Rating__c q : questListValue){
                
                if(q.Category__c != null && q.Category__c != '' && q.Category__c == 'Qualitative' && !ratingListValue.keySet().contains('b')){
                   
                    List<Certification_Rating__c> wr = new List<Certification_Rating__c>();        
                    wr.add(q);
                    ratingListValue.put('b',wr);
                }else if(q.Category__c != null && q.Category__c != '' && q.Category__c == 'Quantitative' && !ratingListValue.keySet().contains('a')){
                    List<Certification_Rating__c> wr = new List<Certification_Rating__c>();        
                    wr.add(q);
                    ratingListValue.put('a',wr);
                }else if(q.Category__c != null && q.Category__c != '' && q.Category__c == 'Qualitative' && ratingListValue.keySet().contains('b')){
                    ratingListValue.get('b').add(q);
                }else if(q.Category__c != null && q.Category__c != ''  && q.Category__c == 'Quantitative' && ratingListValue.keySet().contains('a')){
                    ratingListValue.get('a').add(q);
            }
          }
          apiIdentifierQual = ratingListValue.get('b').size();
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelCertificationRating_Controller '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
          
        } 
    }
    
    public boolean catTextVisible{get; set;}
    
    public String newCategory{get; set;}
    
    public void showText(){
        catTextVisible = true;
        system.debug('Select');
    }
    
    public void hideText(){
        catTextVisible = false;
        system.debug('ADD');
    }
    
    public Id idToDeactivate{get;set;}
    
    public void updateAndDeactivate(){
        
        try{
            system.debug(' idToDeactivate '+idToDeactivate);
            if(readAccess){ 
                Certification_Rating__c cr = [SELECT id ,Assessment_type__c FROM Certification_Rating__c WHERE id =:idToDeactivate];
            
                List<String> fldList1 = new List<String>{prefix+'Deactivated__c'};
                    
                Boolean updateAccess = true;
                            
                Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Certification_Rating__c').getDescribe().fields.getMap();
                
                for(String fldName: fldList1){
                    if(!fieldMap1.get(fldName).getDescribe().isUpdateable()){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                      updateAccess = false;
                    }                           
                }
                
                if(updateAccess){
                    cr.Deactivated__c = true;
                }
                
                if(Schema.getGlobalDescribe().get(prefix+'Certification_Rating__c').getDescribe().isUpdateable()){
                    update cr;
                    if(cr.Assessment_type__c == 'Qualitative'){
                        Set<id> certidA = new Set<id>();
                        certidA.add(cr.id);
                        FunnelCreateCertAnswers_Controller.deleteAndCreateCertAnswersAppSetup(certidA,true,true,'All');
                        //ansCreDel();
                    }
                    
                }
                       
                system.debug(' deactivated rating '+cr);
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelCertificationRating_Controller '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
    }
    
    public Id idToActivate{get;set;}
    
    public void updateAndActivate(){
        try{    
            system.debug(' idToActivate '+idToActivate);
            if(readAccess){ 
                Certification_Rating__c cr = [SELECT id,Assessment_type__c ,Deactivated__c FROM Certification_Rating__c WHERE id =:idToActivate];
            
                List<String> fldList1 = new List<String>{prefix+'Deactivated__c'};
                    
                Boolean updateAccess = true;
                            
                Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Certification_Rating__c').getDescribe().fields.getMap();
                
                for(String fldName: fldList1){
                    if(!fieldMap1.get(fldName).getDescribe().isUpdateable()){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                      updateAccess = false;
                    }                           
                }
                
                if(updateAccess){
                
                    if (cr.Deactivated__c == false){
                        cr.Deactivated__c = true;
                    }
                    else if(cr.Deactivated__c == true){
                        cr.Deactivated__c = false;
                    }
                }
                
                //if(Schema.sObjectType.Certification_Rating__c.isUpdateable())
                if(Schema.getGlobalDescribe().get(prefix+'Certification_Rating__c').getDescribe().isUpdateable()){
                    update cr;
                    if(cr.Assessment_type__c == 'Qualitative'){
                        Set<id> certidA = new Set<id>();
                        certidA.add(cr.id);
                        FunnelCreateCertAnswers_Controller.deleteAndCreateCertAnswersAppSetup(certidA,true,true,'All');
                       // ansCreDel();
                    }
                }else{ 
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                }    
                system.debug(' activated rating '+cr);
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelCertificationRating_Controller '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
    }
    
   /* public void ansCreDel(){
        List<Sales_Rep_Profile__c> srplist = [Select id from Sales_Rep_Profile__c where Active__c = true];
        if(srplist != null && srplist.size() > 0){
            Set<Id> profsForAnsCreation = new Set<Id>();
            for(Sales_Rep_Profile__c s : srplist ){
                profsForAnsCreation.add(s.id);
            }
             FunnelCreateCertAnswers_Controller.deleteAndCreateCertAnswers(profsForAnsCreation,profsForAnsCreation);    
        }
    
    }*/
    
    public String orderIdList {get; set;}
    
    public void updateOrder(){
        try{
            system.debug(' orderIdList '+orderIdList);
            List<String> idList = new List<String>();
            
            if (orderIdList != null && orderIdList != ''){
                idList = orderIdList.split(',');
                system.debug(idList);
            }
            
            List<Id> certIds = new List<Id>();
            
            if(idList != null && idList.size() > 0){
                for(String s: idList){
                    if(s != null && s != '')
                        certIds.add(s);
                }
            }
            
            system.debug(' certIds '+certIds);
            
            if(readAccess){ 
                Map<Id, Certification_Rating__c> certs = new Map<Id, Certification_Rating__c>([SELECT id, Display_Order__c FROM Certification_Rating__c WHERE id IN :certIds]);
            
                Integer order = 1;
                
                List<Certification_Rating__c> certToUpdate = new List<Certification_Rating__c>();
                
                List<String> fldList1 = new List<String>{prefix+'Display_Order__c'};
                    
                Boolean updateAccess = true;
                            
                Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get(prefix+'Certification_Rating__c').getDescribe().fields.getMap();
                
                for(String fldName: fldList1){
                    if(!fieldMap1.get(fldName).getDescribe().isUpdateable()){
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                      updateAccess = false;
                    }                            
                } 
                
                if(updateAccess){    
                    for(Id i: certIds){
                        certs.get(i).Display_Order__c = order;
                        order ++;
                    }
                }
                
                system.debug(certs.values());
                
                //if(Schema.sObjectType.Certification_Rating__c.isUpdateable()){
                if(Schema.getGlobalDescribe().get(prefix+'Certification_Rating__c').getDescribe().isUpdateable()){
                    update certs.values();
                }
            }
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelCertificationRating_Controller '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
    }
    
    /*Navigation*/
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToCertification(){
        
        //return FunnelNavigationHelper.navigateToCertification(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToCertification(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    //Method called on clicking on View Scoring Dashboard
    public PageReference navigateToDashboard(){
        
        //return FunnelNavigationHelper.navigateToDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    //Method called on clicking Performance Dashboard on header
    public PageReference navigateToCalculator(){
        
        return FunnelNavigationHelper.navigateToCalculator(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    //Method called on clicking Home on header    
    public PageReference navigateToHomePage(){
        
        return FunnelNavigationHelper.navigateToHomePage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
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
    
    public PageReference navigateToAssignRole(){
        
        return FunnelNavigationHelper.navigateToAssignRole(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);    
        
    }
    public PageReference navigateToCustomMetric(){
        
        return FunnelNavigationHelper.navigateToCustomMetric(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);    
        
    }
    
    public PageReference navigateToNotifications(){
        
        return FunnelNavigationHelper.navigateToNotifications(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    }
    
    public PageReference navigateToAnalytics(){
        
        return FunnelNavigationHelper.navigateToAnalytics(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    public PageReference navigateToFunnelAnalyticQualitative(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    } 
    
    public PageReference navigateToSalesPipeline(){
        
        return FunnelNavigationHelper.navigateToSalesPipeline(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    public PageReference navigateToTrendingByRep(){
        
        return FunnelNavigationHelper.navigateToTrendingByRep(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToTrendingBySkill(){
        
        return FunnelNavigationHelper.navigateToTrendingBySkill(fw.labelOne,fw.labelTwo,fw.labelThree,fw.selectedLevelOne,fw.selectedLevelTwo,fw.selectedLevelThree);
        
    }
    
    public PageReference navigateToFunnelAnalytic(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalytic(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToFunnelAnalytic(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    public PageReference navigateToFunnelEvaluationGuidelines(){
        
        return FunnelNavigationHelper.navigateToFunnelEvaluationGuidelines(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    public PageReference navigateToAnnualizationDashboard(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToFunnelAnnualizationDashboard(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    public PageReference navigateToFunnelSetup(){
        
        return FunnelNavigationHelper.navigateToFunnelSetup(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
     public PageReference navigateToFunnelReviewGoals(){
        
        return FunnelNavigationHelper.navigateToFunnelReviewGoals(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    public PageReference navigateToFunnelManagerUpdate(){
        
        return FunnelNavigationHelper.navigateToFunnelManagerUpdate(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    public  String  getrname() {
        return JSON.serialize(RatingNames);
    }
    
    public PageReference navigateToFunnelAddEditSRP(){
        
        return FunnelNavigationHelper.navigateToFunnelAddEditSrp(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
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