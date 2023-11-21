public with sharing class FunnelAddEditCompanyLevel {
    
    public List<Company_Level__c> clList{get;set;}
    public Company_Level__c  cmpSelected{get;set;}
    public id compId{get;set;}
    public String newVal{get;set;}
    public String oldVal{get;set;}
    
    
    public String picklist1{get;set;}
    public String picklist2{get;set;}
    public String picklist3{get;set;}
    public String picklist4{get;set;}
    public String picklist5{get;set;}
    public String picklist6{get;set;}
    public String picklist7{get;set;}
    public String picklist8{get;set;}
    public String picklist9{get;set;}
    public String picklist10{get;set;}
    
    public String picklist1LevelName{get;set;}
    public String picklist2LevelName{get;set;}
    public String picklist3LevelName{get;set;}
    public String picklist4LevelName{get;set;}
    public String picklist5LevelName{get;set;}
    public String picklist6LevelName{get;set;}
    public String picklist7LevelName{get;set;}
    public String picklist8LevelName{get;set;}
    public String picklist9LevelName{get;set;}
    public String picklist10LevelName{get;set;}
    
    public PicklistValueSet__c picklistV1 = new PicklistValueSet__c();
    public PicklistValueSet__c picklistV2 = new PicklistValueSet__c();
    public PicklistValueSet__c picklistV3 = new PicklistValueSet__c();
    public PicklistValueSet__c picklistV4 = new PicklistValueSet__c();
    public PicklistValueSet__c picklistV5 = new PicklistValueSet__c();
    public PicklistValueSet__c picklistV6 = new PicklistValueSet__c();
    public PicklistValueSet__c picklistV7 = new PicklistValueSet__c();
    public PicklistValueSet__c picklistV8 = new PicklistValueSet__c();
    public PicklistValueSet__c picklistV9 = new PicklistValueSet__c();
    public PicklistValueSet__c picklistV10 = new PicklistValueSet__c();
    
    
    public List<PicklistValueSet__c> picklistValues = new List<PicklistValueSet__c>();
    
    //Variables to store the parameters passed in the URL
    public String label1{get; set;}
    public String label2{get; set;}
    public String label3{get; set;}
    public String selectedLevel1{get; set;}
    public String selectedLevel2{get; set;}
    public String selectedLevel3{get; set;}
    
    public Boolean adminPer{get;set;}
    public Boolean isManger{get;set;}
    
    public  Map<Id,List<Id>> profMgrMap {get;set;}
    public  Map<Id,Boolean> displayDel{get;set;}
    public id delId{get;set;}
    
    public  List<SelectOption> SrpsList{get;set;}
    
    public FunnelAddEditCompanyLevel (){
        
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
        
        //createList();
        clList = new List<Company_Level__c>();
        clList = [Select id,Picklist_Name__c, Level_Name__c,Level_Value__c,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name,Sub_order__c from Company_Level__c order by order__c asc, Sub_order__c asc Limit 5000];
        
        SrpsList= new List<SelectOption>();
        
        for(Sales_Rep_Profile__c cr :[Select id , name from Sales_Rep_Profile__c  order by Name asc Limit 5000]){
            SrpsList.add(new SelectOption(cr.id,cr.name)); 
        }
        defaultCont();
    }
    
    public void defaultCont(){
        picklistValues = [Select id, Name ,Values__c,Level_Name__c from PicklistValueSet__c Limit 5000];
        picklist1 = '';
        picklist2 = '';
        picklist3 = '';
        picklist4 = '';
        picklist5 = '';
        picklist6 = '';
        picklist7 = '';
        picklist8 = '';
        picklist9 = '';
        picklist10 = '';
        
        if(picklistValues != null && picklistValues.size()>0){
            
            for(PicklistValueSet__c p: picklistValues ){
                
                if(p.Values__c != null && !p.Values__c.endsWith(';')){
                    p.Values__c +=';';
                }
                
                if(p.Name == 'picklist1'){
                    if(p.Values__c != null)
                        picklist1 = p.Values__c;
                    picklist1LevelName = p.Level_Name__c ;
                    picklistV1 = p;
                    
                    
                }
                if(p.Name == 'picklist2'){
                    if(p.Values__c != null)
                        picklist2= p.Values__c;
                    picklist2LevelName = p.Level_Name__c ;
                    picklistV2 = p;
                    
                    
                }
                if(p.Name == 'picklist3'){
                    if(p.Values__c != null)
                        picklist3= p.Values__c;
                    picklist3LevelName = p.Level_Name__c ;
                    picklistV3 = p;
                    
                    
                }
                if(p.Name == 'picklist4'){
                    if(p.Values__c != null)
                        picklist4 = p.Values__c;
                    picklist4LevelName = p.Level_Name__c ;
                    picklistV4 = p;
                    
                    
                }
                if(p.Name == 'picklist5'){
                    if(p.Values__c != null)
                        picklist5 = p.Values__c;
                    picklist5LevelName = p.Level_Name__c ;
                    picklistV5 = p;
                    
                    
                }
                if(p.Name == 'picklist6'){
                    if(p.Values__c != null)
                        picklist6 = p.Values__c;
                    picklist6LevelName = p.Level_Name__c ;
                    picklistV6 = p;
                    
                    
                }
                if(p.Name == 'picklist7'){
                    if(p.Values__c != null)
                        picklist7 = p.Values__c;
                    picklist7LevelName = p.Level_Name__c ;
                    picklistV7 = p;
                    
                    
                }
                if(p.Name == 'picklist8'){
                    if(p.Values__c != null)
                        picklist8 = p.Values__c;
                    picklist8LevelName = p.Level_Name__c ;
                    picklistV8 = p;
                    
                    
                }
                if(p.Name == 'picklist9'){
                    if(p.Values__c != null)
                        picklist9 = p.Values__c;
                    picklist9LevelName = p.Level_Name__c ;
                    picklistV9 = p;
                    
                    
                }
                if(p.Name == 'picklist10'){
                    if(p.Values__c != null)
                        picklist10 = p.Values__c;
                    picklist10LevelName = p.Level_Name__c ;
                    picklistV10 = p;
                    
                    
                }
                
            }
            
        }
    }
    
    public void displayEditCmp(){
        
        
        if(compId != null){
            cmpSelected= [Select id,Picklist_Name__c,order__c, Level_Name__c,Level_Value__c,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name,Sub_order__c from Company_Level__c  where id =: compId Limit 1];
        } 
        
        newVal = '';
        oldVal= '';
        
    }
    
    public void save(){
        
        Map<String,String> valueIdMap = new Map<String,String>();
        List<CreatePicklistValue__c> createPickList = new List<CreatePicklistValue__c>();
        List<CreatePicklistValue__c> upsertCreatePickList = new List<CreatePicklistValue__c>();
        List<PicklistValueSet__c> upsertList = new List<PicklistValueSet__c>();
        List<Company_Level__c> upsertListCompanyLevels = new List<Company_Level__c>();
        List<Company_Level__c> delListCompanyLevels = new List<Company_Level__c>();
        
        createPickList = [select id, Value__c, PicklistValueSet__c from CreatePicklistValue__c Limit 5000];
        
        for(CreatePicklistValue__c c : createPickList){
            valueIdMap.put(c.Value__c,c.id);
        }
        
        List<PicklistValueSet__c> picklistValues1 = [Select id, Name ,Values__c,Level_Name__c from PicklistValueSet__c where Name = 'picklist1'];
        
        system.debug('picklist1 :: '+picklist1);
        List<String> picklist1List = picklist1.split(';');
        Set<String> picklist1Set = new Set<String>(picklist1List);
        system.debug('picklist1Set :: '+picklist1Set);
        
        picklistV1 .name = 'picklist1';
        picklistV1 .Level_Name__c = picklist1LevelName;
        picklistV1 .Values__c= picklist1;
        
        for(String p : picklist1Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                system.debug('p :: '+p);
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                system.debug('p1 :: '+p);
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistValues1[0].id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        upsertList.add(picklistV1 );
        
        List<Company_Level__c> c1 = [Select id, Level_Name__c,Level_Value__c,Order__c from Company_Level__c where Order__c = 1 limit 1];
        Company_Level__c c1up = new Company_Level__c();
        if(c1 != null && c1.size()>0){
            c1up = c1[0];
        }
        c1up.Level_Name__c = picklist1LevelName;
        
        if(picklist1List != null ){
            c1up.Level_Value__c= picklist1List[0];
        }
        c1up.Order__c =1;
        
        upsertListCompanyLevels.add(c1up);
        
        picklistV2 .name = 'picklist2';
        picklistV2 .Level_Name__c = picklist2LevelName;
        picklistV2 .Values__c= picklist2;
        
        
        List<PicklistValueSet__c> picklistValues2 = [Select id, Name ,Values__c,Level_Name__c from PicklistValueSet__c where Name = 'picklist2'];
        List<String> picklist2List = picklist2.split(';');
        Set<String> picklist2Set = new Set<String>(picklist2List);
        for(String p : picklist2Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistValues2[0].id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        upsertList.add(picklistV2 );
        
        if(picklist2List != null && picklist2List.size()>0){ 
            Map<String,List<Company_Level__c>> c2Map = delAndUpserId(picklist2List,picklist2LevelName,2);
            
            if(c2Map != null && c2Map.keySet().contains('Del') && c2Map.get('Del') != null){
                delListCompanyLevels.addAll( c2Map.get('Del')); 
            }
            if(c2Map != null && c2Map.keySet().contains('Ups') && c2Map.get('Ups') != null){
                upsertListCompanyLevels.addAll( c2Map.get('Ups')); 
            }
        }
        
        picklistV3 .name = 'picklist3';
        picklistV3 .Level_Name__c = picklist3LevelName;
        picklistV3 .Values__c= picklist3;
        
        
        List<PicklistValueSet__c> picklistValues3 = [Select id, Name ,Values__c,Level_Name__c from PicklistValueSet__c where Name = 'picklist3'];
        List<String> picklist3List = picklist3.split(';');
        Set<String> picklist3Set = new Set<String>(picklist3List);
        for(String p : picklist3Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistValues3[0].id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        upsertList.add(picklistV3 );
        //upsert picklistV3 ;
        
        if(picklist3List != null && picklist3List.size()>0){ 
            Map<String,List<Company_Level__c>> c3Map = delAndUpserId(picklist3List,picklist3LevelName,3);
            
            if(c3Map != null && c3Map.keySet().contains('Del') && c3Map.get('Del') != null){
                delListCompanyLevels.addAll( c3Map.get('Del')); 
            }
            if(c3Map != null && c3Map.keySet().contains('Ups') && c3Map.get('Ups') != null){
                upsertListCompanyLevels.addAll( c3Map.get('Ups')); 
            }
        }
        
        picklistV4 .name = 'picklist4';
        picklistV4 .Level_Name__c = picklist4LevelName;
        picklistV4 .Values__c= picklist4;
        
        
        List<PicklistValueSet__c> picklistValues4 = [Select id, Name ,Values__c,Level_Name__c from PicklistValueSet__c where Name = 'picklist4'];
        List<String> picklist4List = picklist4.split(';');
        Set<String> picklist4Set = new Set<String>(picklist4List);
        for(String p : picklist4Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistValues4[0].id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        upsertList.add(picklistV4 );
        //upsert picklistV4 ;
        
        if(picklist4List != null && picklist4List.size()>0){ 
            Map<String,List<Company_Level__c>> c4Map = delAndUpserId(picklist4List,picklist4LevelName,4);
            
            if(c4Map != null && c4Map.keySet().contains('Del') && c4Map.get('Del') != null){
                delListCompanyLevels.addAll( c4Map.get('Del')); 
            }
            if(c4Map != null && c4Map.keySet().contains('Ups') && c4Map.get('Ups') != null){
                upsertListCompanyLevels.addAll( c4Map.get('Ups')); 
            }
        }
        
        
        picklistV5 .name = 'picklist5';
        picklistV5 .Level_Name__c = picklist5LevelName;
        picklistV5 .Values__c= picklist5;
        
        List<PicklistValueSet__c> picklistValues5 = [Select id, Name ,Values__c,Level_Name__c from PicklistValueSet__c where Name = 'picklist5'];
        List<String> picklist5List = picklist5.split(';');
        Set<String> picklist5Set = new Set<String>(picklist5List);
        for(String p : picklist5Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistValues5[0].id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        upsertList.add(picklistV5 );
        //upsert picklistV5 ;
        
        if(picklist5List != null && picklist5List.size()>0){ 
            Map<String,List<Company_Level__c>> c5Map = delAndUpserId(picklist5List,picklist5LevelName,5);
            
            if(c5Map != null && c5Map.keySet().contains('Del') && c5Map.get('Del') != null){
                delListCompanyLevels.addAll( c5Map.get('Del')); 
            }
            if(c5Map != null && c5Map.keySet().contains('Ups') && c5Map.get('Ups') != null){
                upsertListCompanyLevels.addAll( c5Map.get('Ups')); 
            }
        } 
        
        
        picklistV6 .name = 'picklist6';
        picklistV6 .Level_Name__c = picklist6LevelName;
        picklistV6 .Values__c= picklist6;
        
        List<PicklistValueSet__c> picklistValues6 = [Select id, Name ,Values__c,Level_Name__c from PicklistValueSet__c where Name = 'picklist6'];
        List<String> picklist6List = picklist6.split(';');
        Set<String> picklist6Set = new Set<String>(picklist6List);
        for(String p : picklist6Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistValues6[0].id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        upsertList.add(picklistV6 );
        //upsert picklistV6 ;
        
        if(picklist6List != null && picklist6List.size()>0){ 
            Map<String,List<Company_Level__c>> c6Map = delAndUpserId(picklist6List,picklist6LevelName,6);
            
            if(c6Map != null && c6Map.keySet().contains('Del') && c6Map.get('Del') != null){
                delListCompanyLevels.addAll( c6Map.get('Del')); 
            }
            if(c6Map != null && c6Map.keySet().contains('Ups') && c6Map.get('Ups') != null){
                upsertListCompanyLevels.addAll( c6Map.get('Ups')); 
            }
        }
        
        picklistV7 .name = 'picklist7';
        picklistV7 .Level_Name__c = picklist7LevelName;
        picklistV7 .Values__c= picklist7;
        
        List<PicklistValueSet__c> picklistValues7 = [Select id, Name ,Values__c,Level_Name__c from PicklistValueSet__c where Name = 'picklist7'];
        List<String> picklist7List = picklist7.split(';');
        Set<String> picklist7Set = new Set<String>(picklist7List);
        for(String p : picklist7Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistValues7[0].id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        upsertList.add(picklistV7 );
        //upsert picklistV7 ;
        
        if(picklist7List != null && picklist7List.size()>0){ 
            Map<String,List<Company_Level__c>> c7Map = delAndUpserId(picklist7List,picklist7LevelName,7);
            
            if(c7Map != null && c7Map.keySet().contains('Del') && c7Map.get('Del') != null){
                delListCompanyLevels.addAll( c7Map.get('Del')); 
            }
            if(c7Map != null && c7Map.keySet().contains('Ups') && c7Map.get('Ups') != null){
                upsertListCompanyLevels.addAll( c7Map.get('Ups')); 
            }
        } 
        
        picklistV8 .name = 'picklist8';
        picklistV8 .Level_Name__c = picklist8LevelName;
        picklistV8 .Values__c= picklist8;
        
        List<PicklistValueSet__c> picklistValues8 = [Select id, Name ,Values__c,Level_Name__c from PicklistValueSet__c where Name = 'picklist8'];
        List<String> picklist8List = picklist8.split(';');
        Set<String> picklist8Set = new Set<String>(picklist8List);
        for(String p : picklist8Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistValues8[0].id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        upsertList.add(picklistV8 );
        //upsert picklistV8 ;
        if(picklist8List != null && picklist8List.size()>0){ 
            Map<String,List<Company_Level__c>> c8Map = delAndUpserId(picklist8List,picklist8LevelName,8);
            system.debug('c8Map :: '+c8Map);
            system.debug('delAndUpserId :: '+ delAndUpserId(picklist8List,picklist8LevelName,8));
            if(c8Map != null && c8Map.keySet().contains('Del') && c8Map.get('Del') != null){
                delListCompanyLevels.addAll( c8Map.get('Del')); 
            }
            if(c8Map != null && c8Map.keySet().contains('Ups') && c8Map.get('Ups') != null){
                upsertListCompanyLevels.addAll( c8Map.get('Ups')); 
            }
        }
        
        picklistV9 .name = 'picklist9';
        picklistV9 .Level_Name__c = picklist9LevelName;
        picklistV9 .Values__c= picklist9;
        
        List<PicklistValueSet__c> picklistValues9 = [Select id, Name ,Values__c,Level_Name__c from PicklistValueSet__c where Name = 'picklist9'];
        List<String> picklist9List = picklist9.split(';');
        Set<String> picklist9Set = new Set<String>(picklist9List);
        for(String p : picklist9Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistValues9[0].id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        upsertList.add(picklistV9 );
        //upsert picklistV9 ;
        if(picklist9List != null && picklist9List.size()>0){ 
            Map<String,List<Company_Level__c>> c9Map = delAndUpserId(picklist9List,picklist9LevelName,9);
            
            if(c9Map != null && c9Map.keySet().contains('Del') && c9Map.get('Del') != null){
                delListCompanyLevels.addAll( c9Map.get('Del')); 
            }
            if(c9Map != null && c9Map.keySet().contains('Ups') && c9Map.get('Ups') != null){
                upsertListCompanyLevels.addAll( c9Map.get('Ups')); 
            }
        }
        
        picklistV10.name = 'picklist10';
        picklistV10.Level_Name__c = picklist10LevelName;
        picklistV10.Values__c= picklist10;
        
        List<PicklistValueSet__c> picklistValues10 = [Select id, Name ,Values__c,Level_Name__c from PicklistValueSet__c where Name = 'picklist10'];
        List<String> picklist10List = picklist10.split(';');
        Set<String> picklist10Set = new Set<String>(picklist10List);
        for(String p : picklist10Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistValues10[0].id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        upsertList.add(picklistV10 );
        //upsert picklistV10 ;
        if(picklist10List != null && picklist10List.size()>0){ 
            Map<String,List<Company_Level__c>> c10Map = delAndUpserId(picklist10List,picklist10LevelName,10);
            
            if(c10Map != null && c10Map.keySet().contains('Del') && c10Map.get('Del') != null){
                delListCompanyLevels.addAll( c10Map.get('Del')); 
            }
            if(c10Map != null && c10Map.keySet().contains('Ups') && c10Map.get('Ups') != null){
                upsertListCompanyLevels.addAll( c10Map.get('Ups')); 
            }
        }
        
        if(upsertList != null && upsertList.size()>0){
            upsert upsertList;
        }
        
        System.debug('delListCompanyLevels:::'+delListCompanyLevels);
        System.debug('upsertListCompanyLevels:::'+upsertListCompanyLevels);
        
        if(delListCompanyLevels!= null && delListCompanyLevels.size()>0){
            Delete delListCompanyLevels;
        }
        
        if(upsertListCompanyLevels != null && upsertListCompanyLevels.size()>0){
            upsert upsertListCompanyLevels;
        }
        
        if(upsertCreatePickList != null && upsertCreatePickList.size()>0){
            upsert upsertCreatePickList; 
        }
        
        
    }
    
    
    public void SaveCmp(){
        system.debug('newVal '+newVal );
        system.debug('oldVal '+oldVal );
        
        if( newVal != '' && oldVal != '' && newVal != oldVal){
            
            Set<String> levelList = new Set<String>();
            // Get the describe for the object
            DescribeSObjectResult objResult = Schema.getGlobalDescribe()
                .get('FunnelMetrics__Sales_Rep_Profile__c').getDescribe();
            // Get the field dynamically
            DescribeFieldResult fieldResult = objResult.fields.getMap()
                .get(cmpSelected.Picklist_Name__c).getDescribe();
            
            for (Schema.Picklistentry picklistEntry : fieldResult.getPicklistValues()){ 
                levelList.add(pickListEntry.getLabel());
            }                                 
            system.debug('levelList'+levelList);
            levelList.add(newVal);
            system.debug('levelList'+levelList);
            
            //FunnelInstallationHelper.createPicklistValueSetAndUpdateSrp(levelList,cmpSelected.Picklist_Name__c,'Level Picklist '+cmpSelected.order__c,UserInfo.getSessionId(),oldVal,newVal);
            
            List<PicklistValueSet__c> updatepick = new List<PicklistValueSet__c>();
            List<CreatePicklistValue__c> updateCreatepick = new List<CreatePicklistValue__c>();
            
            String pickName = 'picklist'+cmpSelected.order__c;
            pickName =  pickName.Substring(0,pickName.length()-3);
            
            system.debug('pickName '+cmpSelected );
            system.debug('q picklist'+ 'select id ,Values__c from PicklistValueSet__c where name =' + pickName );
            
            updatepick =  [select id ,Values__c from PicklistValueSet__c where name = :pickName limit 1];
            system.debug('updatepick '+updatepick );
            updateCreatepick = [select id, Value__c, Added__c, Deactivated__c, PicklistValueSet__c from CreatePicklistValue__c where PicklistValueSet__c =: updatepick[0].id];
            
            
            for(CreatePicklistValue__c cp : updateCreatepick){
                if(cp.Value__c == oldVal){
                    cp.Deactivated__c = true;
                    cp.NewValue__c = newVal;
                    cp.Added__c = false;
                }
            }
            CreatePicklistValue__c newPicklist = new CreatePicklistValue__c();
            newPicklist.Value__c = newVal;
            newPicklist.PicklistValueSet__c = updatepick[0].id ;
            insert newPicklist;
            
            if(updatepick != null && updatepick.size()>0){
                List<String> picklistVal = updatepick[0].Values__c.split(';'); 
                List<String> pick = new List<String>();
                
                for(String s : picklistVal ){
                    s = s.replace('\n','');
                    s = s.replace('\r','');
                    s = s.trim();
                    
                    if(s == oldVal){
                        s = newVal;
                    }
                    pick.add(s);
                }
                
                Update updateCreatepick;
                
                system.debug('pick'+pick);
                updatepick[0].Values__c = String.join( pick, ';' );  
                update  updatepick;
            }
        }
        
        update cmpSelected;
        clList = [Select id,Picklist_Name__c, Level_Name__c,Level_Value__c,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name,Sub_order__c from Company_Level__c order by order__c asc, Sub_order__c asc Limit 5000];
        
        //FunnelInstallationHelper.createPermsissions();
        //createList();
        
    }
    
    public void updaeSlist(){
        clList = [Select id, Picklist_Name__c,Level_Name__c,Level_Value__c,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name,Sub_order__c from Company_Level__c order by order__c asc, Sub_order__c asc Limit 5000];
    }
    
    public void assignVal(){
        
        system.debug('newVal'+newVal);
        system.debug('oldVal'+oldVal);
    }
    
    public void delCmp(){
        
        Company_Level__c  c = [Select id,order__c,Level_Value__c from Company_Level__c  where id = :delId Limit 1];
        
        List<PicklistValueSet__c> updatepick = new List<PicklistValueSet__c>();
        List<CreatePicklistValue__c> updateCreatepick = new List<CreatePicklistValue__c>();
        List<CreatePicklistValue__c> deleteCreatepick = new List<CreatePicklistValue__c>();   
        
        String pickName = 'picklist'+c.order__c;
        pickName =  pickName.Substring(0,pickName.length()-3);
        
        system.debug('pickName '+pickName );
        system.debug('q picklist'+ 'select id ,Values__c from PicklistValueSet__c where name =' + pickName );
        
        updatepick =  [select id ,Values__c from PicklistValueSet__c where name = :pickName limit 1];
        updateCreatepick = [select id, Value__c, Added__c, PicklistValueSet__c from CreatePicklistValue__c where PicklistValueSet__c =: updatepick[0].id];   
        system.debug('updatepick '+updatepick );
        system.debug('updateCreatepick '+updateCreatepick);
        
        if(updatepick != null && updatepick.size()>0){
            List<String> picklistVal = updatepick[0].Values__c.split(';'); 
            List<String> pick = new List<String>();
            
            for(String s : picklistVal ){
                s = s.replace('\n','');
                s = s.replace('\r','');
                s = s.trim();
                
                if(s == c.Level_Value__c){
                    
                }else{
                    pick.add(s);
                }
                
            }
            
            system.debug('pick'+pick);
            updatepick[0].Values__c = String.join( pick, ';' );  
            update  updatepick;
            
            if(updateCreatepick != null && updateCreatepick.size()>0){
                for(CreatePicklistValue__c cp : updateCreatepick){
                    if(cp.Value__c == c.Level_Value__c){
                        deleteCreatepick.add(cp);
                    }
                }
            }
            delete c;
            delete deleteCreatepick;
            updaeSlist();
            
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
    public PageReference navigateToCustomMetric(){
        
        return FunnelNavigationHelper.navigateToCustomMetric(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToFunnelAddEditSrp(){
        
        return FunnelNavigationHelper.navigateToFunnelAddEditSrp(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToFunnelAddEditRole(){
        
        return FunnelNavigationHelper.navigateToFunnelAddEditRole(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToGoals(){
        
        return FunnelNavigationHelper.navigateToGoalsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    //Added for Help Menu - Rohit
    public PageReference navigateToHelpMenu(){
        
        return FunnelNavigationHelper.navigateToHelpMenu();
        
    }
    /*Navigation*/
    
    public Map<String,List<Company_Level__c>> delAndUpserId(List<String> picklistList, String picklistLevelName , Decimal order  ){
        
        Map<String,List<Company_Level__c>> retunMap = new Map<String,List<Company_Level__c>>();
        System.debug('picklistList:::'+picklistList);
        System.debug('picklistLevelName :::'+picklistLevelName );
        System.debug('order  :::'+order  );
        List<String> pick = new List<String>();
        for(String s : picklistList){
            s = s.replace('\n','');
            s = s.replace('\r','');
            s = s.trim();
            pick.add(s);
        }
        picklistList =pick;
        System.debug('picklistList:::'+picklistList);
        
        if(picklistList != null  && picklistList.size()>0){//
            Map<string,Company_Level__c> compMap = new Map<string,Company_Level__c> ();
            List<Company_Level__c> c2 = [Select id, Level_Name__c,Level_Value__c,Order__c,Sub_order__c from Company_Level__c where Order__c = :order]; //
            for(Company_Level__c cm: c2){
                compMap.put(cm.Level_Value__c,cm);
            }
            System.debug('compMap:::'+compMap);
            
            List<String> existingLevelVal = new List<String>();
            List<Company_Level__c> c2Delete = new List<Company_Level__c>();
            List<Company_Level__c> c2upsert = new List<Company_Level__c>();
            
            
            for(Company_Level__c c :c2){
                System.debug('c:::'+c);
                existingLevelVal.add(c.Level_Value__c);
                if(!picklistList.contains(c.Level_Value__c)){
                    System.debug('c.Level_Value__c:::'+c.Level_Value__c);
                    c2Delete.add(c); 
                }
            }
            if(c2Delete != null && c2Delete.size()>0){
                retunMap.put('Del',c2Delete);
            }
            
            integer suborder = 0;
            for(String pVal : picklistList){
                if(pVal != ''){
                    Company_Level__c c = new Company_Level__c();
                    if( compMap != null && compMap.size()>0 && compMap.keySet().contains(pVal)){
                        c = compMap.get(pVal);
                    }
                    suborder ++;
                    c.Order__c = order; //
                    c.Level_Name__c = picklistLevelName; //
                    c.Level_Value__c = pVal;
                    c.Sub_order__c = suborder ;
                    c2upsert.add(c);
                }
            }
            
            if(c2upsert != null && c2upsert.size()>0){
                retunMap.put('Ups',c2upsert);
            }
            
            
        }
        return  retunMap;
    } 
    
}