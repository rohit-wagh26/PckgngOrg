public with sharing class FunnelCertificationRatingCustom{

    public FunnelCertificationRatingCustom(FunnelInstallationStep7Controller controller) {
        defaultConstructor();
    }

    
    public string syntaxerror{get;set;}
    public  List<SelectOption> options{get;set;}
    public  List<SelectOption> fieldoptions{get;set;}
    public  List<SelectOption> owneroptions{get;set;}
    public  List<SelectOption> dateoptions{get;set;}
    public List<String> RatingNames{get;set;}
    public string selectedValue { get;set; }
    public Decimal goal{get;set;}
    public string metricName{get;set;}
    public string metricgoal;
    public string metricid;
    public decimal dfgoal;
    public Boolean adddisplay{get;set;}
    public List<Metric_Goals__c> roleGoal{get;set;}
    public String whereString{get;set;}
    public id deleteId{get;set;}
     
    
    public id fetchId;
    
    
    Public Map<String,String> managemenetReports{get;set;}
       
    private Map<String,List<Certification_Rating__c>> ratingListValue = new Map<String,List<Certification_Rating__c>>();
    
    public  List<Certification_Rating__c> ratingList{get;set;}
    
    private List<Certification_Rating__c> questListValue = new List<Certification_Rating__c>();
    
    public List<Certification_Rating__c> questList{
        get{
            return questListValue; 
        }
        set{
            questListValue = value;
        }
    }
    
    
    
    public boolean showPanel{get; set;}
    
    public Id ratingId{get; set;}
    public Id cratingId{get; set;}
    
    public Certification_Rating__c ratingSelected{get; set;}
    
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
    
    public Boolean adminPer{get;set;}
    public Boolean isManger{get;set;}
    /* Filters */
    
    public FunnelCertificationRatingCustom(){
         defaultConstructor();
    }
    
    public void defaultConstructor(){
        ratingSelected = new Certification_Rating__c();
        catTextVisible = false;
        syntaxerror ='';
        ratingList = [SELECT Id, OwnerId, IsDeleted,Display_Custom_Metric__c, Name, Timing__c, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Description__c, User_Type__c, Assessment_type__c, Weight__c, Calculation_type__c, Deactivated__c, Roles_enabled__c, X0LevelLow__c, X0LevelHigh__c, X1LevelLow__c, X1LevelHigh__c, X2LevelLow__c, X2LevelHigh__c, X3LevelLow__c, X3LevelHigh__c, X4LevelLow__c, X4LevelHigh__c, Category__c FROM Certification_Rating__c Where Custom_Object_Name__c != null ORDER BY Category__c DESC , Display_Order__c ASC, CreatedDate DESC LIMIT 2000];

         
        
        /*filters*/
        label1 = ApexPages.currentPage().getParameters().get('labelOne');
        label2 = ApexPages.currentPage().getParameters().get('labelTwo');
        label3 = ApexPages.currentPage().getParameters().get('labelThree');
        selectedLevel1 = ApexPages.currentPage().getParameters().get('selectOne');
        selectedLevel2 = ApexPages.currentPage().getParameters().get('selectTwo');
        selectedLevel3 = ApexPages.currentPage().getParameters().get('selectThree');   
        
        List<AggregateResult> asperm = [SELECT count(Id) c FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = 'Funnel_App_Setup'];
        if((asperm != null && asperm.size() > 0 && asperm[0].get('c') != null && (Integer)asperm[0].get('c') > 0)   ){
            adminPer= true;
        }else{
            adminPer= false;
        }
        
        isManger = FunnelTriggerBatchHelper.isManager(UserInfo.getUserId());
        /*
        managemenetReports = new Map<String,String>();
        
        User u = [SELECT Name, UserPreferencesLightningExperiencePreferred FROM User WHERE id = :UserInfo.getUserId()];
        
        List<String> dashList = new List<String>();
        dashList.add('mXaDybYGcSDujlyIRRJQxUrUEqXiFe');
        
        managemenetReports = FunnelNavigationHelper.fetchDashboards(dashList,u);*/
        
        srpfields();
        ratingName();
        checkavlmetric(ratingList );
    
    }
  public void checkavlmetric(List<Certification_Rating__c > crlist){
        if(crlist != null && crlist.size() > 49){
            adddisplay = false;
        }else{
            adddisplay = true;
        }
    
    }
     
  /*public List<SelectOption>  getRole() {
       integer i = 0;
       List<SelectOption> Options = new List<SelectOption>();
       Schema.DescribeFieldResult statusFieldDescription = Certification_Rating__c.Roles_enabled__c.getDescribe();
       for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues()){
           Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
           if(i == 0){
               selectedValue = string.valueOf(pickListEntry.getValue());
               fetchgoal(); 
               i++;
           }
       }
       
        
       return Options ;
   }*/
  public void ratingName(){
      RatingNames =  new List<String>();
      Schema.DescribeFieldResult statusFieldDescription = Certification_Answer__c.Rating_name_picklist__c.getDescribe();
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues()){ 
             RatingNames.add(pickListEntry.getLabel());
        }
     
     }
     
   public Void  srpfields() {
        options = new List<SelectOption>(); 
        list<String> fieldUsed = new list<String>();
        //list<String> fieldaval = new List<String>{'FMCustom_Metric_1__c', 'FMCustom_Metric_2__c', 'FMCustom_Metric_3__c', 'FMCustom_Metric_4__c', 'FMCustom_Metric_5__c', 'FMCustom_Metric_6__c', 'FMCustom_Metric_7__c', 'FMCustom_Metric_8__c', 'FMCustom_Metric_9__c', 'FMCustom_Metric_10__c', 'FMCustom_Metric_11__c', 'FMCustom_Metric_12__c', 'FMCustom_Metric_13__c', 'FMCustom_Metric_14__c', 'FMCustom_Metric_15__c', 'FMCustom_Metric_16__c', 'FMCustom_Metric_17__c', 'FMCustom_Metric_18__c', 'FMCustom_Metric_19__c', 'FMCustom_Metric_20__c', 'FMCustom_Metric_21__c', 'FMCustom_Metric_22__c', 'FMCustom_Metric_23__c', 'FMCustom_Metric_24__c', 'FMCustom_Metric_25__c', 'FMCustom_Metric_26__c', 'FMCustom_Metric_27__c', 'FMCustom_Metric_28__c', 'FMCustom_Metric_29__c', 'FMCustom_Metric_30__c'};
        list<String> fieldaval = new List<String>();
        for(integer i =1;i<=50;i++){
            fieldaval.add('FMCustom_Metric_'+i+'__c'); 
        }
        for( Certification_Rating__c c: [SELECT SRP_Field_Name__c  FROM Certification_Rating__c Where Custom_Object_Name__c != null ]){
            fieldUsed.add(c.SRP_Field_Name__c);
        }
        
        for(String a : fieldaval){
            if(!fieldUsed.contains(a)){
                ratingSelected.SRP_Field_Name__c = a;
                options.add(new SelectOption(a,a));
                break;
            }
        
        }
      
         
    } 
    
    public void displayAddEditRating(){
         
        showPanel = true;    
        system.debug(' ratingId '+ratingId);
        roleGoal = new List<Metric_Goals__c >();
        
        if(ratingId != null){
            ratingSelected = [SELECT Id,Reverse_Buckets__c,Display_Custom_Metric__c,Custom_Object_Name__c,Custom_Field_Name__c,Custom_Related_by__c,SRP_Field_Name__c,Agg__c,Duration_Field__c,Duration_Period__c,Date__c,Where__c,Default_Goal__c, OwnerId, IsDeleted, Name, Timing__c, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Description__c, User_Type__c, Assessment_type__c,  Weight__c, Calculation_type__c, Deactivated__c, Roles_enabled__c, X0LevelLow__c, X0LevelHigh__c, X1LevelLow__c, X1LevelHigh__c, X2LevelLow__c, X2LevelHigh__c, X3LevelLow__c, X3LevelHigh__c, X4LevelLow__c, X4LevelHigh__c, Category__c,Rating_type__c,Training_Url__c FROM Certification_Rating__c WHERE id = :ratingId];
            dfgoal = ratingSelected.Default_Goal__c  ;
            options.add(new SelectOption(ratingSelected.SRP_Field_Name__c,ratingSelected.SRP_Field_Name__c));
            whereString = ratingSelected.Where__c;
        }else{
            ratingSelected = new Certification_Rating__c();
            ratingSelected.Assessment_type__c = 'Quantitative';
            ratingSelected.User_Type__c ='Both';
            ratingSelected.Calculation_type__c ='Bucketed';
            ratingSelected.Category__c = 'Quantitative';
            ratingSelected.Group__c = 'Custom Metrics';
            ratingSelected.Agg__c = 'Sum';
            whereString ='';
        }
        catTextVisible = false;
        fieldnames();
    }
    
    public void cloneRating(){
         
        showPanel = true;    
        system.debug('Clone cratingId '+cratingId);
        roleGoal = new List<Metric_Goals__c >();
        if(cratingId != null){
            
            ratingSelected = new Certification_Rating__c();
            ratingSelected.Assessment_type__c = 'Quantitative';
            ratingSelected.User_Type__c ='Both';
            ratingSelected.Calculation_type__c ='Bucketed';
            ratingSelected.Category__c = 'Quantitative';
            ratingSelected.Group__c = 'Custom Metrics';
            
             
            Certification_Rating__c cloneRatingSelected = [SELECT Id,Group__c ,Reverse_Buckets__c,Display_Custom_Metric__c,Custom_Object_Name__c,Custom_Field_Name__c,Custom_Related_by__c,SRP_Field_Name__c,Agg__c,Duration_Field__c,Duration_Period__c,Date__c,Where__c,Default_Goal__c,  Name, Timing__c,  Description__c, User_Type__c, Assessment_type__c,  Weight__c, Calculation_type__c, Deactivated__c, Roles_enabled__c, X0LevelLow__c, X0LevelHigh__c, X1LevelLow__c, X1LevelHigh__c, X2LevelLow__c, X2LevelHigh__c, X3LevelLow__c, X3LevelHigh__c, X4LevelLow__c, X4LevelHigh__c, Category__c,Rating_type__c FROM Certification_Rating__c WHERE id = :cratingId];
            dfgoal = cloneRatingSelected.Default_Goal__c  ;
            whereString = cloneRatingSelected.Where__c;
             
            ratingSelected  = cloneRatingSelected;
            ratingSelected.SRP_Field_Name__c = '';
            ratingSelected.name += ' - Clone';
            ratingSelected.id = null;
            
        } 
        catTextVisible = false;
        fieldnames();
    }

    public void hideAddEditRating(){

        showPanel = false; 
        ratingId = null; 
        cratingId = null; 
        ratingSelected = new Certification_Rating__c();
            ratingSelected.Assessment_type__c = 'Quantitative';
            ratingSelected.User_Type__c ='Both';
            ratingSelected.Calculation_type__c ='Bucketed';
            ratingSelected.Category__c = 'Quantitative';
            ratingSelected.Group__c = 'Custom Metrics';
            ratingSelected.Agg__c = 'Sum';
        
        goal = null;
        srpfields(); 
        system.debug('hiderating');
        
                
    }
    
    public void saveRating(){
        
        
        try{
        
         
        syntaxerror ='';    
        ratingSelected.Where__c = whereString ;
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
                system.debug('ratingSelected.SRP_Field_Name__c--'+ratingSelected.SRP_Field_Name__c); 
                ratingSelected.Field_Name__c = ratingSelected.SRP_Field_Name__c.replace('__c','_percentage__c');
                ratingSelected.Goal_field_name__c= ratingSelected.SRP_Field_Name__c.replace('__c','Goal__c');
                ratingSelected.Metric_Field_Name__c =ratingSelected.SRP_Field_Name__c;
                /*if(!ratingSelected.Advance__c){
                    ratingSelected.Agg__c = '';
                }*/
                
                String objectName = ratingSelected.Custom_Object_Name__c;
                String fieldName = ratingSelected.Duration_Field__c;
                
                SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
                DescribeSObjectResult d = r.getDescribe();
                //System.debug(d.fields.getMap().get(fieldName).getDescribe().getType());
               if(ratingSelected.Duration_Field__c != null){
                    if(d.fields.getMap().get(fieldName).getDescribe().getType()  == Schema.DisplayType.DATE){
                        ratingSelected.Date__c = true;
                    }else if(d.fields.getMap().get(fieldName).getDescribe().getType()  == Schema.DisplayType.DATETIME){
                        ratingSelected.Date__c = false;
                    }
                }  
                
            }
        
            FunnelCustomMetricHelper.triggerDate = system.today(); 
            String timeperiod = '';
             
            if(ratingSelected.Duration_Field__c != null && ratingSelected.Duration_Period__c != 'No time period'){
                timeperiod = FunnelCustomMetricHelper.createtimeString(ratingSelected.Duration_Field__c,ratingSelected.Duration_Period__c,ratingSelected.Date__c);
            }
            string f;
        
             if(ratingSelected.Agg__c != null && ratingSelected.Agg__c !=''){
                 f = ratingSelected.Custom_Related_by__c +' gb ,'+ ratingSelected.Agg__c+'('+ratingSelected.Custom_Field_Name__c+') '+ ratingSelected.SRP_Field_Name__c;
             }else{
                 f = ratingSelected.Custom_Related_by__c +' gb ,'+ 'SUM'+'('+ratingSelected.Custom_Field_Name__c+') '+ ratingSelected.SRP_Field_Name__c;
             }
             
             List<AggregateResult> cm  = new List<AggregateResult>();
             cm = FunnelCustomMetricHelper.queryObjects(ratingSelected.Custom_Object_Name__c,f,ratingSelected.Where__c,ratingSelected.Custom_Related_by__c,timeperiod);
         
             boolean newmetric = true;
             if(ratingSelected.id != null){
                 newmetric = false;
             }
                             
        if(Schema.getGlobalDescribe().get(prefix+'Certification_Rating__c').getDescribe().isCreateable() && Schema.getGlobalDescribe().get(prefix+'Certification_Rating__c').getDescribe().isUpdateable()){
                upsert ratingSelected;
            }
        
        fetchId = ratingSelected.id;
        metricid =ratingSelected.id;
        metricName = ratingSelected.Name;
        metricgoal = ratingSelected.SRP_Field_Name__c.replace('__c','Goal__c');
        system.debug('ratingSelected.SRP_Field_Name__c--'+ratingSelected.SRP_Field_Name__c);
        system.debug('newmetric--'+newmetric);
        
        if(newmetric){
            createmetricgoal(ratingSelected.id,ratingSelected.name,ratingSelected.Default_Goal__c);
        }
        
        if(ratingSelected.Default_Goal__c != goal){
            applydefaultgoal(ratingSelected.Default_Goal__c,metricgoal);
        }
            
        
        
         roleGoal = new List<Metric_Goals__c >();
         if(metricid != null){
             roleGoal =[select id,goal__c,role__c from Metric_Goals__c where  Certification_Rating__c =:fetchId ];
              
         }
         system.debug('--select id,goal__c,role__c from Metric_Goals__c where  Certification_Rating__c ='+fetchId ); 
         system.debug('roleGoal --'+roleGoal );
       
        hideAddEditRating();
        
        
        ratingList = [SELECT Id, OwnerId, IsDeleted, Name, Timing__c, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Description__c, User_Type__c, Assessment_type__c, Weight__c, Calculation_type__c, Deactivated__c, Roles_enabled__c, X0LevelLow__c, X0LevelHigh__c, X1LevelLow__c, X1LevelHigh__c, X2LevelLow__c, X2LevelHigh__c, X3LevelLow__c, X3LevelHigh__c, X4LevelLow__c, X4LevelHigh__c, Category__c FROM Certification_Rating__c Where Custom_Object_Name__c != null ORDER BY Category__c DESC , Display_Order__c ASC, CreatedDate DESC LIMIT 2000];

        checkavlmetric(ratingList );
        //getfetchgoal();
       /* PageReference redirect = new PageReference('/apex/FunnelSalesCertification?'+'labelOne='+label1+'&labelTwo='+label2+'&labelThree='+label3+'&selectOne='+selectedLevel1+'&selectTwo='+selectedLevel2+'&selectThree='+selectedLevel3); 
        redirect.setRedirect(true);     
        return redirect; */
        }catch(Exception e){
              System.debug('The following exception has occurred: ' + e.getMessage() +e.getlinenumber());
              syntaxerror = 'Syntax Error: '+ e.getMessage();
              System.debug('syntaxerror  ' + syntaxerror );
              FunnelTriggerBatchHelper.sendErrorMail(' FunnelCertificationRatingCustom '+e.getMessage()+' '+e.getStackTraceString()+ ' line number: '+e.getLineNumber()+' cause '+e.getCause());

         }
    }
    public void createmetricgoal(id crtlp, string name, decimal dfg){
        List<Metric_Goals__c> cmlist = new list<Metric_Goals__c>();
        Metric_Goals__c cm = new  Metric_Goals__c();

        Schema.DescribeFieldResult statusFieldDescription = Certification_Rating__c.Roles_enabled__c.getDescribe();
        for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues()){ 
             cm = new  Metric_Goals__c();
             cm.name = name;
             cm.Certification_Rating__c = crtlp;
             cm.Role__c = pickListEntry.getValue();
             cm.goal__c = dfg;
             cmlist.add(cm);
        }
        insert cmlist;
        system.debug('cmlist--'+cmlist);
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
    
        system.debug(' idToDeactivate '+idToDeactivate);
        
        Certification_Rating__c cr = [SELECT id FROM Certification_Rating__c WHERE id =:idToDeactivate];
        
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
                }
        
        system.debug(' deactivated rating '+cr);
    }
    
    public Id idToActivate{get;set;}
    
    public void updateAndActivate(){
    
        system.debug(' idToActivate '+idToActivate);
        Certification_Rating__c cr = [SELECT id,Deactivated__c FROM Certification_Rating__c WHERE id =:idToActivate];
        
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
        
        if(Schema.getGlobalDescribe().get(prefix+'Certification_Rating__c').getDescribe().isUpdateable())
            update cr;
        else 
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
            
        system.debug(' activated rating '+cr);
    }
    
    public String orderIdList {get; set;}
    
    public void updateOrder(){
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
        
         if(Schema.getGlobalDescribe().get(prefix+'Certification_Rating__c').getDescribe().isUpdateable()){
                update certs.values();
            }
    }
    
     public list<selectoption> getSobjectnames() {

    list<schema.sobjecttype> gd= schema.getglobaldescribe().values();
    list<selectoption> options =new list<selectoption>();
    //options.add(new selectoption(' ','Select object'));
    /*for(schema.sobjecttype gh:gd ){
          if(gh.getdescribe().isCreateable() || gh.getdescribe().getname().contains('OpportunityHistory') || gh.getdescribe().getname().contains('OpportunityFieldHistory')){   
               options.add(new selectoption(gh.getdescribe().getname(),gh.getdescribe().getname()));
           }

    }*/
    for(schema.sobjecttype gh:gd ){
          if((gh.getdescribe().getname().contains('Opportunity') 
          || gh.getdescribe().getname().contains('Lead')
          || gh.getdescribe().getname().contains('Event')
          || gh.getdescribe().getname().contains('Sales')
          || gh.getdescribe().getname().contains('Certification')
          || gh.getdescribe().getname().contains('Company')
          || gh.getdescribe().getname().contains('Action')

          )&& gh.getdescribe().isCreateable()){   
               options.add(new selectoption(gh.getdescribe().getname(),gh.getdescribe().getname()));
           }

    }
     return options;

 }
 
  public void fieldnames( ) {
    if(ratingSelected.Custom_Object_Name__c != null && ratingSelected.Custom_Object_Name__c != ''){ 
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(ratingSelected.Custom_Object_Name__c);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        fieldoptions =new list<selectoption>();
        
        set<String> fnames = new set<String>();
        set<String> userref = new set<String>();
        for(String fieldName: fieldMap.keySet()) {
             if(fieldName !='isdeleted' && fieldName !='createddate' && fieldName !='createdbyid' && fieldName !='lastmodifieddate' && fieldName !='lastmodifiedbyid' && fieldName !='systemmodstamp' && fieldName !='lastvieweddate' && fieldName !='lastreferenceddate' && fieldName !='lastactivitydate'){
                 fieldoptions.add(new selectoption(fieldName,fieldName));
                 fnames.add(fieldName);
                  
             } 
            if(fieldName !='isdeleted' &&   fieldName !='lastmodifieddate' && fieldName !='lastmodifiedbyid' && fieldName !='systemmodstamp' && fieldName !='lastvieweddate' && fieldName !='lastreferenceddate' && fieldName !='lastactivitydate'){ 
                fnames.add(fieldName);
            }
        }
        
        SObjectType r = ((SObject)(Type.forName('Schema.'+ratingSelected.Custom_Object_Name__c).newInstance())).getSObjectType();
        DescribeSObjectResult d = r.getDescribe();
        dateoptions = new list<selectoption>();
        owneroptions = new list<selectoption>();
        
        for(String s : fnames){
            if(d.fields.getMap().get(s).getDescribe().getType()  == Schema.DisplayType.DATE || d.fields.getMap().get(s).getDescribe().getType()  == Schema.DisplayType.DATETIME){
                dateoptions.add(new selectoption(s,s));
            }
            if(d.fields.getMap().get(s).getDescribe().getType()  == Schema.DisplayType.REFERENCE ){
                userref.add(s);
            }
            
        }
         
        for(String o : userref){
            Schema.DescribeFieldResult f = Schema.getGlobalDescribe().get(ratingSelected.Custom_Object_Name__c).getDescribe().fields.getMap().get(o).getDescribe();
            //Schema.DescribeFieldResult f = Schema.sObjectType.ob.fields.o;
            //System.debug('Relationship Name: ' + f.getRelationshipName());    

            for(Schema.SObjectType reference : f.getReferenceTo()) {
                System.debug('Lookup reference object name: ' + reference.getDescribe().getName());
                //System.debug('Lookup reference object label: ' + reference.getDescribe().getLabel());
                if(reference.getDescribe().getName() == 'User'){
                    owneroptions.add(new selectoption(o,o));
                }
            }
        }
        
        
        
     }else{
         owneroptions =new list<selectoption>();
         fieldoptions =new list<selectoption>();
         dateoptions=new list<selectoption>();
          
     }
 }
 
     public void applyGoal(){
         update roleGoal ;
         Map<String,Decimal> rolmap = new Map<String,Decimal>();
         for(Metric_Goals__c r:roleGoal ){
             rolmap.put(r.role__c,r.goal__c);
         }
         List<Sales_Rep_Profile__c> srpList = [select id,FMCustom_Metric_1Goal__c,FMCustom_Metric_2Goal__c,FMCustom_Metric_3Goal__c,FMCustom_Metric_4Goal__c,FMCustom_Metric_5Goal__c,FMCustom_Metric_6Goal__c,FMCustom_Metric_7Goal__c,FMCustom_Metric_8Goal__c,FMCustom_Metric_9Goal__c,FMCustom_Metric_10Goal__c,FMCustom_Metric_11Goal__c,FMCustom_Metric_12Goal__c,FMCustom_Metric_13Goal__c,FMCustom_Metric_14Goal__c,FMCustom_Metric_15Goal__c,FMCustom_Metric_16Goal__c,FMCustom_Metric_17Goal__c,FMCustom_Metric_18Goal__c,FMCustom_Metric_19Goal__c,FMCustom_Metric_20Goal__c,FMCustom_Metric_21Goal__c,FMCustom_Metric_22Goal__c,FMCustom_Metric_23Goal__c,FMCustom_Metric_24Goal__c,FMCustom_Metric_25Goal__c,FMCustom_Metric_26Goal__c,FMCustom_Metric_27Goal__c,FMCustom_Metric_28Goal__c,FMCustom_Metric_29Goal__c,FMCustom_Metric_30Goal__c,FMCustom_Metric_31Goal__c,FMCustom_Metric_32Goal__c,FMCustom_Metric_33Goal__c,FMCustom_Metric_34Goal__c,FMCustom_Metric_35Goal__c,FMCustom_Metric_36Goal__c,FMCustom_Metric_37Goal__c,FMCustom_Metric_38Goal__c,FMCustom_Metric_39Goal__c,FMCustom_Metric_40Goal__c,FMCustom_Metric_41Goal__c,FMCustom_Metric_42Goal__c,FMCustom_Metric_43Goal__c,FMCustom_Metric_44Goal__c,FMCustom_Metric_45Goal__c,FMCustom_Metric_46Goal__c,FMCustom_Metric_47Goal__c,FMCustom_Metric_48Goal__c,FMCustom_Metric_49Goal__c,FMCustom_Metric_50Goal__c,Role__c  from Sales_Rep_Profile__c where Role__c != null];
         system.debug('metricgoal'+metricgoal);
         for(Sales_Rep_Profile__c s: srpList ){
             if(s.Role__c != null && rolmap.get(s.Role__c) != null){
                 s.put(metricgoal,rolmap.get(s.Role__c));
             } 
             
         }
         roleGoal = new List<Metric_Goals__c >();
          
          update srpList ;
          
     }
     public void applydefaultgoal(decimal goalp, string mname){
         string Soql = 'Select id ,role__c, '+mname+' from Sales_Rep_Profile__c where '+mname+ ' = '+dfgoal+ ' OR '+mname+ ' = null ';
         System.debug('Soql--'+Soql);
         List<Sales_Rep_Profile__c> srp =  database.query(Soql);
         set<String> rname = new set<String>();
         for(Sales_Rep_Profile__c s: srp){
             s.put(metricgoal,goalp);
             rname.add(s.role__c);
         }
         update srp;
     
     }
     public void getfetchgoal(){
         
     }
     
     public void fetchgoal(){
         system.debug('fetchgoal');
         system.debug('selectedValue fetchgoal--'+selectedValue);
         
     }
     
     public void deleteMetric(){
        system.debug('deleteId'+deleteId);
        Delete[Select id from Certification_Rating__c where id =:deleteId];
        ratingList = [SELECT Id, OwnerId, IsDeleted,Display_Custom_Metric__c, Name, Timing__c, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Description__c, User_Type__c, Assessment_type__c, Weight__c, Calculation_type__c, Deactivated__c, Roles_enabled__c, X0LevelLow__c, X0LevelHigh__c, X1LevelLow__c, X1LevelHigh__c, X2LevelLow__c, X2LevelHigh__c, X3LevelLow__c, X3LevelHigh__c, X4LevelLow__c, X4LevelHigh__c, Category__c FROM Certification_Rating__c Where Custom_Object_Name__c != null ORDER BY Category__c DESC , Display_Order__c ASC, CreatedDate DESC LIMIT 2000];

        //roleGroups = [select name,Roles__c,Group_Name__c from Role_Grouping__c order by createddate asc];
        //updateGroupUpdate();
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
     public PageReference navigateToRatings(){
        
        return FunnelNavigationHelper.navigateToCreateEditRatings(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
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
        
        return FunnelNavigationHelper.navigateToTrendingByRep(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToTrendingBySkill(){
        
        return FunnelNavigationHelper.navigateToTrendingBySkill(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
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
    
    public PageReference navigateToGoals(){
        
        return FunnelNavigationHelper.navigateToGoalsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    public String getsy() {
        return JSON.serialize(syntaxerror);
    }
    public  String  getrname() {
        return JSON.serialize(RatingNames);
    }
    
    //Added for Help Menu - Rohit
    public PageReference navigateToHelpMenu(){
        
        return FunnelNavigationHelper.navigateToHelpMenu();
    
    }
    /*Navigation*/ 
    
     
}