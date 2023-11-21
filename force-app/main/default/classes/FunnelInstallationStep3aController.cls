public with sharing class FunnelInstallationStep3aController {

    public FunnelInstallationStep3aController(FunnelAddEditRole controller) {

    }


    


    public String roles{get;set;}
    
    public String rolesName{get;set;}
    
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
    
    public PicklistValueSet__c rolepicklist = new PicklistValueSet__c();
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
    public Map<String,String> pickValueMap = new Map<String,String>();
    public Boolean compHierarchy = false;
    
    public FunnelInstallationStep3aController(FunnelAddEditCompanyLevel controller) {
        defaultCont();
        createList();
        compHierarchy = true;
    }
    
    public FunnelInstallationStep3aController (){
        
        defaultCont();
        compHierarchy = false;
        
    }
    
    public void defaultCont(){
        picklistValues = [Select id, Name ,Values__c,Level_Name__c from PicklistValueSet__c Limit 5000];
        roles = '';
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
                    
                if(p.Name == 'role'){
                    if(p.Values__c != null)
                    roles = p.Values__c;
                    rolesName = p.Name;
                    rolepicklist = p;
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
    
    public void save(){
        
        if(!compHierarchy){
            FunnelInstallationHelper.saveStep('3');
        }
        
        Map<String,String> valueIdMap = new Map<String,String>();
        List<CreatePicklistValue__c> createPickList = new List<CreatePicklistValue__c>();
        List<CreatePicklistValue__c> upsertCreatePickList = new List<CreatePicklistValue__c>();
        
		createPickList = [select id, Value__c, PicklistValueSet__c from CreatePicklistValue__c Limit 5000];
        
        if(createPickList != null && createPickList.size()>0){
            for(CreatePicklistValue__c c : createPickList){
                valueIdMap.put(c.Value__c,c.id);
            }
        }
		        
        List<PicklistValueSet__c> upsertList = new List<PicklistValueSet__c>();
        List<Company_Level__c> upsertListCompanyLevels = new List<Company_Level__c>();
        List<Company_Level__c> delListCompanyLevels = new List<Company_Level__c>();
        
        List<String> roleList = roles.split(';');
        Set<String> roleSet = new Set<String>(roleList);
        System.debug('roleSet'+ roleSet);
        FunnelInstallationHelper.createPicklistValueSet(roleSet,'FunnelMetrics__Roles','Roles',UserInfo.getSessionId(),false);
        
        rolepicklist.name = 'role';
        rolepicklist.Level_Name__c = 'Role';
        rolepicklist.Values__c= roles ;
        
        upsert rolepicklist;
        
        for(String r : roleSet){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(r)){
                levelValue.id = valueIdMap.get(r);
                levelValue.Value__c = r;
            }else{
                levelValue.Value__c = r;
                levelValue.PicklistValueSet__c = rolepicklist.id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        
        List<String> picklist1List = picklist1.split(';');
        Set<String> picklist1Set = new Set<String>(picklist1List);
        
        
        if(compHierarchy){
            FunnelInstallationHelper.createPicklistValueSet(picklist1Set ,'FunnelMetrics__Level_Picklist_1','Level Picklist 1',UserInfo.getSessionId(),true);
        }
        else{
            FunnelInstallationHelper.createPicklistValueSet(picklist1Set ,'FunnelMetrics__Level_Picklist_1','Level Picklist 1',UserInfo.getSessionId(),false);
        }
        
        
        
        picklistV1 .name = 'picklist1';
        picklistV1 .Level_Name__c = picklist1LevelName;
        picklistV1 .Values__c= picklist1;
        
        upsertList.add(picklistV1 );
        //upsert picklistV1 ;
        
      	
        
        
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
        
        
        List<String> picklist2List = picklist2.split(';');
        Set<String> picklist2Set = new Set<String>(picklist2List);
        
        if(compHierarchy){
            FunnelInstallationHelper.createPicklistValueSet(picklist2Set ,'FunnelMetrics__Level_Picklist_2','Level Picklist 2',UserInfo.getSessionId(),true);
        }
        else{
            FunnelInstallationHelper.createPicklistValueSet(picklist2Set ,'FunnelMetrics__Level_Picklist_2','Level Picklist 2',UserInfo.getSessionId(),false);
        }
        
        
        picklistV2 .name = 'picklist2';
        picklistV2 .Level_Name__c = picklist2LevelName;
        picklistV2 .Values__c= picklist2;
        
        upsertList.add(picklistV2 );
        //upsert picklistV2 ;
        
        if(picklist2List != null && picklist2List.size()>0){ 
            Map<String,List<Company_Level__c>> c2Map = delAndUpserId(picklist2List,picklist2LevelName,2);
            
            if(c2Map != null && c2Map.keySet().contains('Del') && c2Map.get('Del') != null){
                delListCompanyLevels.addAll( c2Map.get('Del')); 
            }
            if(c2Map != null && c2Map.keySet().contains('Ups') && c2Map.get('Ups') != null){
                upsertListCompanyLevels.addAll( c2Map.get('Ups')); 
            }
        }
        
        List<String> picklist3List = picklist3.split(';');
        Set<String> picklist3Set = new Set<String>(picklist3List);
        
        if(compHierarchy){
            FunnelInstallationHelper.createPicklistValueSet(picklist3Set ,'FunnelMetrics__Level_Picklist_3','Level Picklist 3',UserInfo.getSessionId(),true);
        }
        else{
            FunnelInstallationHelper.createPicklistValueSet(picklist3Set ,'FunnelMetrics__Level_Picklist_3','Level Picklist 3',UserInfo.getSessionId(),false);
        }
        
        
        picklistV3 .name = 'picklist3';
        picklistV3 .Level_Name__c = picklist3LevelName;
        picklistV3 .Values__c= picklist3;
        
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
        
        List<String> picklist4List = picklist4.split(';');
        Set<String> picklist4Set = new Set<String>(picklist4List);
        
        if(compHierarchy){
            FunnelInstallationHelper.createPicklistValueSet(picklist4Set ,'FunnelMetrics__Level_Picklist_4','Level Picklist 4',UserInfo.getSessionId() ,true);
        }
        else{
            FunnelInstallationHelper.createPicklistValueSet(picklist4Set ,'FunnelMetrics__Level_Picklist_4','Level Picklist 4',UserInfo.getSessionId() ,false);
        }
        
        
        
        picklistV4 .name = 'picklist4';
        picklistV4 .Level_Name__c = picklist4LevelName;
        picklistV4 .Values__c= picklist4;
        
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
        
        List<String> picklist5List = picklist5.split(';');
        Set<String> picklist5Set = new Set<String>(picklist5List);
        
        if(compHierarchy){
            FunnelInstallationHelper.createPicklistValueSet(picklist5Set ,'FunnelMetrics__Level_Picklist_5','Level Picklist 5',UserInfo.getSessionId() ,true);
        }
        else{
            FunnelInstallationHelper.createPicklistValueSet(picklist5Set ,'FunnelMetrics__Level_Picklist_5','Level Picklist 5',UserInfo.getSessionId() ,false);
        }
        
        
        
        picklistV5 .name = 'picklist5';
        picklistV5 .Level_Name__c = picklist5LevelName;
        picklistV5 .Values__c= picklist5;
        
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
        
        List<String> picklist6List = picklist6.split(';');
        Set<String> picklist6Set = new Set<String>(picklist6List);
        
        if(compHierarchy){
            FunnelInstallationHelper.createPicklistValueSet(picklist6Set ,'FunnelMetrics__Level_Picklist_6','Level Picklist 6',UserInfo.getSessionId() ,true);
        }
        else{
            FunnelInstallationHelper.createPicklistValueSet(picklist6Set ,'FunnelMetrics__Level_Picklist_6','Level Picklist 6',UserInfo.getSessionId() ,false);
        }
        
        
        picklistV6 .name = 'picklist6';
        picklistV6 .Level_Name__c = picklist6LevelName;
        picklistV6 .Values__c= picklist6;
        
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
        
        List<String> picklist7List = picklist7.split(';');
        Set<String> picklist7Set = new Set<String>(picklist7List);
        
        if(compHierarchy){
            FunnelInstallationHelper.createPicklistValueSet(picklist7Set ,'FunnelMetrics__Level_Picklist_7','Level Picklist 7',UserInfo.getSessionId() ,true);
        }
        else{
            FunnelInstallationHelper.createPicklistValueSet(picklist7Set ,'FunnelMetrics__Level_Picklist_7','Level Picklist 7',UserInfo.getSessionId() ,false);
        }
        
        
        picklistV7 .name = 'picklist7';
        picklistV7 .Level_Name__c = picklist7LevelName;
        picklistV7 .Values__c= picklist7;
        
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
        
        List<String> picklist8List = picklist8.split(';');
        Set<String> picklist8Set = new Set<String>(picklist8List);
        
        if(compHierarchy){
            FunnelInstallationHelper.createPicklistValueSet(picklist8Set ,'FunnelMetrics__Level_Picklist_8','Level Picklist 8',UserInfo.getSessionId() ,true);
        }
        else{
            FunnelInstallationHelper.createPicklistValueSet(picklist8Set ,'FunnelMetrics__Level_Picklist_8','Level Picklist 8',UserInfo.getSessionId() ,false);
        }
        
        
        
        picklistV8 .name = 'picklist8';
        picklistV8 .Level_Name__c = picklist8LevelName;
        picklistV8 .Values__c= picklist8;
        
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
        
        
        List<String> picklist9List = picklist9.split(';');
        Set<String> picklist9Set = new Set<String>(picklist9List);
        
        if(compHierarchy){
            FunnelInstallationHelper.createPicklistValueSet(picklist9Set ,'FunnelMetrics__Level_Picklist_9','Level Picklist 9',UserInfo.getSessionId() ,true);
        }
        else{
            FunnelInstallationHelper.createPicklistValueSet(picklist9Set ,'FunnelMetrics__Level_Picklist_9','Level Picklist 9',UserInfo.getSessionId(),false);
        }
        
        
        
        picklistV9 .name = 'picklist9';
        picklistV9 .Level_Name__c = picklist9LevelName;
        picklistV9 .Values__c= picklist9;
        
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
        
        
        List<String> picklist10List = picklist10.split(';');
        Set<String> picklist10Set = new Set<String>(picklist10List);
        
        if(compHierarchy){
            FunnelInstallationHelper.createPicklistValueSet(picklist10Set ,'FunnelMetrics__Level_Picklist_10','Level Picklist 10',UserInfo.getSessionId() ,true);
        }
        else{
            FunnelInstallationHelper.createPicklistValueSet(picklist10Set ,'FunnelMetrics__Level_Picklist_10','Level Picklist 10',UserInfo.getSessionId(),false);
        }
        
        picklistV10.name = 'picklist10';
        picklistV10.Level_Name__c = picklist10LevelName;
        picklistV10.Values__c= picklist10;
        
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
        
        for(String p : picklist1Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                system.debug('p :: '+p);
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                system.debug('p1 :: '+p);
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistV1.id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        for(String p : picklist2Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistV2.id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        for(String p : picklist3Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistV3.id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        
        for(String p : picklist4Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistV4.id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        for(String p : picklist5Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistV5.id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        for(String p : picklist6Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistV6.id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        for(String p : picklist7Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistV7.id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        for(String p : picklist8Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistV8.id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        for(String p : picklist9Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistV9.id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        for(String p : picklist10Set){
            CreatePicklistValue__c levelValue = new CreatePicklistValue__c();
            if(valueIdMap.containsKey(p)){
                levelValue.id = valueIdMap.get(p);
                levelValue.Value__c = p;
            }else{
                levelValue.Value__c = p;
                levelValue.PicklistValueSet__c = picklistV10.id;
            }
            upsertCreatePickList.add(levelValue);
        }
        
        System.debug('delListCompanyLevels:::'+delListCompanyLevels);
        System.debug('upsertListCompanyLevels:::'+upsertListCompanyLevels);
        System.debug('upsertCreatePickList:::'+upsertCreatePickList);
        
        if(delListCompanyLevels!= null && delListCompanyLevels.size()>0){
            Delete delListCompanyLevels;
        }
        
        if(upsertListCompanyLevels != null && upsertListCompanyLevels.size()>0){
            upsert upsertListCompanyLevels;
        }
        
        if(upsertCreatePickList != null && upsertCreatePickList.size()>0){
            upsert upsertCreatePickList;
        }
        
        if(compHierarchy){
            createList();
        }
        
    }
    
    
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
            
             
    public PageReference navigateToStep2(){
        save();
        return FunnelInstallationHelper.navigateToStep2();
    
    }
    
    public PageReference navigateToStep3b(){
        save();
         
            List<Certification_Rating__c> CRList = [Select id from Certification_Rating__c LIMIT 5000];
            system.debug('CRList size'+CRList.size());
            if(CRList == null || !(CRList  != null && CRList.size() > 0)){
                insertCR();
            }
        
        return FunnelInstallationHelper.navigateToStep4a();
    
    }
    
    public void insertCR(){
        StaticResource FMCertificationRating  = [SELECT Id, Body FROM StaticResource WHERE Name = 'FMCertificationRatings' LIMIT 1];
        String bodyCR = FMCertificationRating.Body.toString();
        System.debug('bodyCR :::'+bodyCR );
        String[] filelines = new String[]{};
        filelines = bodyCR.split('\r\n'); 
        System.debug('filelines :::'+filelines );
        List<Certification_Rating__c> CRList = new List<Certification_Rating__c>();
        for(Integer i=1;i<filelines.size();i=i+1){
             
            String s = filelines[i];
            Integer startIndex;
            Integer endIndex;
            String prevLine = s;
            while(s.indexOf('"') > -1){
                System.debug('s.indexOf'+ s.indexOf('"'));
                if(startIndex == null){
                    startIndex = s.indexOf('"');
                    System.debug('startIndex'+startIndex);
                    s = s.substring(0, startIndex) + ':quotes:' + s.substring(startIndex+1, s.length());
                    System.debug('s'+s);
                }else{
                    if(endIndex == null){
                        endIndex = s.indexOf('"');
                        s = s.substring(0, endIndex) + ':quotes:' + s.substring(endIndex+1, s.length());
                    }
                }
                
                if(startIndex != null && endIndex != null){
                    String sub = s.substring(startIndex, endIndex);
                    sub = sub.replaceAll(',', ':comma:');
                    s = s.substring(0, startIndex) + sub + s.substring(endIndex, s.length());
                    startIndex = null;
                    endIndex = null;
                }
            }
        
            System.debug('prevLine:::'+prevLine);
            System.debug('s:::'+s);
            
            List<String> colList = new List<String>();
            
            for(String column : s.split(',')){
              column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
              colList.add(column);
              //System.debug('column::'+column);
            }
            
            if(colList != null ){
                Certification_Rating__c cr = new Certification_Rating__c();
                
                if(colList[0] != null && colList[0] != ''){
                    cr.API_IDENTIFIER_QUAL__C = Decimal.valueof(colList[0]);
                }
                if(colList[1] != null){
                    cr.ASSESSMENT_TYPE__C = colList[1];
                }
                if(colList[2] != null){
                    cr.CALCULATION_TYPE__C = colList[2];
                }
                if(colList[3] != null){
                    cr.CATEGORY__C = colList[3];
                }
                if(colList[4] != null){
                    cr.DESCRIPTION__C = colList[4];
                }
                if(colList[5] != null && colList[5] != ''){
                    cr.DISPLAY_ORDER__C = Decimal.valueof(colList[5]);
                }
                if(colList[6] != null){
                    cr.FIELD_NAME__C = colList[6];
                }
                if(colList[7] != null){
                    cr.METRIC_FIELD_NAME__C = colList[7];
                }
                if(colList[8] != null){
                    cr.Goal_field_name__c = colList[8];
                }
                if(colList[9] != null){
                    cr.Group__c = colList[9];
                }
                if(colList[10] != null){
                    cr.RATING_TYPE__C = colList[10];
                }
                if(colList[11] != null){
                    cr.TIMING__C = colList[11];
                }
                if(colList[12] != null){
                    cr.USER_TYPE__C = colList[12];
                }
                if(colList[13] != null && colList[13] != ''){
                    cr.X0LEVELHIGH__C = Decimal.valueof(colList[13]);
                }
                if(colList[14] != null && colList[14] != ''){
                    cr.X0LEVELLOW__C = Decimal.valueof(colList[14]);
                }
                if(colList[15] != null && colList[15] != ''){
                    cr.X1LEVELHIGH__C = Decimal.valueof(colList[15]);
                }
                if(colList[16] != null && colList[16] != ''){
                    cr.X1LEVELLOW__C = Decimal.valueof(colList[16]);
                }
                if(colList[17] != null && colList[17] != ''){
                    cr.X2LEVELHIGH__C = Decimal.valueof(colList[17]);
                }
                if(colList[18] != null && colList[18] != ''){
                    cr.X2LEVELLOW__C = Decimal.valueof(colList[18]);
                }
                if(colList[19] != null && colList[19] != ''){
                    cr.X3LEVELHIGH__C = Decimal.valueof(colList[19]);
                }
                if(colList[20] != null && colList[20] != ''){
                    cr.X3LEVELLOW__C = Decimal.valueof(colList[20]);
                }
                if(colList[21] != null && colList[21] != ''){
                    cr.X4LEVELHIGH__C = Decimal.valueof(colList[21]);
                }
                if(colList[22] != null && colList[22] != ''){
                    cr.X4LEVELLOW__C = Decimal.valueof(colList[22]);
                }
                if(colList[23] != null){
                    cr.NAME = colList[23];
                }
                if(colList[24] != null){
                    if(colList[24] == 'true'){
                        cr.Deactivated__c= true;
                    }else{
                        cr.Deactivated__c= false;
                    }
                    
                }
                System.debug('CR-----'+CR);
                CRList.add(cr); 
            }
        }
        
        if(CRList!= null && CRList.size()>0){
            insert CRList;
        }
    
    
    }
    
    public PageReference saveAndExit(){
        save();
        return FunnelInstallationHelper.navigateToChecklist();
    }
    
    
    public  Map<Id,List<Id>> profMgrMap {get;set;}
    public  Map<Id,Boolean> displayDel{get;set;}
    
    public void createList(){
         List<Sales_Rep_Profile__c> allProfs = [SELECT id, Sales_Manager__c FROM Sales_Rep_Profile__c LIMIT 2000];
 
        
        profMgrMap = new Map<Id,List<Id>>();
        displayDel = new Map<Id,Boolean>();
        
        for(Sales_Rep_Profile__c s:allProfs){
            if(s.Sales_Manager__c != null){
                if(profMgrMap == null || (!profMgrMap.keySet().contains(s.Sales_Manager__c))){
                    List<Id> suborList = new List<Id>();
                    suborList.add(s.Id);
                    profMgrMap.put(s.Sales_Manager__c,suborList);
                }
                else if(profMgrMap.containsKey(s.Sales_Manager__c)){
                    profMgrMap.get(s.Sales_Manager__c).add(s.id);
                }
            }
        }
        
         List<Company_Level__c> clListex = new List<Company_Level__c>();
        clListex = [Select id,Picklist_Name__c, Level_Name__c,Level_Value__c,Sales_Rep_Profile__c,Sales_Rep_Profile__r.name,Sub_order__c from Company_Level__c order by order__c asc, Sub_order__c asc LIMIT 5000];
    
        for(Company_Level__c  c : clListex){
            if(profMgrMap.get(c.Sales_Rep_Profile__c) != null){
                
                displayDel.put(c.Sales_Rep_Profile__c, false);
            }else{
                displayDel.put(c.Sales_Rep_Profile__c, true);
            }
        
        }
        
        List <Sales_Rep_Profile__c> srlist = [select id from Sales_Rep_Profile__c LIMIT 5000];
        for(Sales_Rep_Profile__c s : srlist){
            if(!profMgrMap.keyset().contains(s.id)){
                displayDel.put(s.id,true);
            }
        
        }
    }
}