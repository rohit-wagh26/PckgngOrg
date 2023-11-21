global with sharing class BatchToUpdateGlobalPicklist {
    /*implements Database.Batchable<sobject>,Database.AllowsCallouts, Database.Stateful{
    
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
    
    public UpdatePicklistValue__c rolepicklist = new UpdatePicklistValue__c();
    public UpdatePicklistValue__c picklistV1 = new UpdatePicklistValue__c();
    public UpdatePicklistValue__c picklistV2 = new UpdatePicklistValue__c();
    public UpdatePicklistValue__c picklistV3 = new UpdatePicklistValue__c();
    public UpdatePicklistValue__c picklistV4 = new UpdatePicklistValue__c();
    public UpdatePicklistValue__c picklistV5 = new UpdatePicklistValue__c();
    public UpdatePicklistValue__c picklistV6 = new UpdatePicklistValue__c();
    public UpdatePicklistValue__c picklistV7 = new UpdatePicklistValue__c();
    public UpdatePicklistValue__c picklistV8 = new UpdatePicklistValue__c();
    public UpdatePicklistValue__c picklistV9 = new UpdatePicklistValue__c();
    public UpdatePicklistValue__c picklistV10 = new UpdatePicklistValue__c();
    List<UpdatePicklistValue__c> updatedPicklist = new List<UpdatePicklistValue__c>();
    
    public Database.QueryLocator start(Database.BatchableContext con){
        String query = ('Select id, name, isUpdated__c, Level_Name__c, Picklist_Value__c From UpdatePicklistValue__c where isUpdated__c = false');
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext con, List<UpdatePicklistValue__c> picVal){
        try{
            if(picVal != null && picVal.size() > 0 ){
                for(UpdatePicklistValue__c p : picVal){
                    if(p.Picklist_Value__c != null && !p.Picklist_Value__c.endsWith(';')){
                        p.Picklist_Value__c +=';';
                    }
                    
                    if(p.Name == 'role'){
                        if(p.Picklist_Value__c != null)
                            roles = p.Picklist_Value__c;
                        rolesName = p.Name;
                        rolepicklist = p;
                    }
                    
                    if(p.Name == 'picklist1'){
                        if(p.Picklist_Value__c != null)
                            picklist1 = p.Picklist_Value__c;
                        picklist1LevelName = p.Level_Name__c ;
                        picklistV1 = p;
                        
                        
                    }
                    system.debug('outside if'+p.name);
                    if(p.Name == 'picklist2'){
                        system.debug('inside If'+p.Picklist_Value__c);
                        if(p.Picklist_Value__c != null)
                            picklist2= p.Picklist_Value__c;
                        picklist2LevelName = p.Level_Name__c ;
                        picklistV2 = p;
                        
                        
                    }
                    if(p.Name == 'picklist3'){
                        if(p.Picklist_Value__c != null)
                            picklist3= p.Picklist_Value__c;
                        picklist3LevelName = p.Level_Name__c ;
                        picklistV3 = p;
                        
                        
                    }
                    if(p.Name == 'picklist4'){
                        if(p.Picklist_Value__c != null)
                            picklist4 = p.Picklist_Value__c;
                        picklist4LevelName = p.Level_Name__c ;
                        picklistV4 = p;
                        
                        
                    }
                    if(p.Name == 'picklist5'){
                        if(p.Picklist_Value__c != null)
                            picklist5 = p.Picklist_Value__c;
                        picklist5LevelName = p.Level_Name__c ;
                        picklistV5 = p;
                        
                        
                    }
                    if(p.Name == 'picklist6'){
                        if(p.Picklist_Value__c != null)
                            picklist6 = p.Picklist_Value__c;
                        picklist6LevelName = p.Level_Name__c ;
                        picklistV6 = p;
                        
                        
                    }
                    if(p.Name == 'picklist7'){
                        if(p.Picklist_Value__c != null)
                            picklist7 = p.Picklist_Value__c;
                        picklist7LevelName = p.Level_Name__c ;
                        picklistV7 = p;
                        
                        
                    }
                    if(p.Name == 'picklist8'){
                        if(p.Picklist_Value__c != null)
                            picklist8 = p.Picklist_Value__c;
                        picklist8LevelName = p.Level_Name__c ;
                        picklistV8 = p;
                        
                        
                    }
                    if(p.Name == 'picklist9'){
                        if(p.Picklist_Value__c != null)
                            picklist9 = p.Picklist_Value__c;
                        picklist9LevelName = p.Level_Name__c ;
                        picklistV9 = p;
                        
                        
                    }
                    if(p.Name == 'picklist10'){
                        if(p.Picklist_Value__c != null)
                            picklist10 = p.Picklist_Value__c;
                        picklist10LevelName = p.Level_Name__c ;
                        picklistV10 = p;
                        
                        
                    }
                    p.isUpdated__c = true;
                    updatedPicklist.add(p);
                }
                //update picVal;
                
            }
            If(roles!= null ){
                List<String> roleList = roles.split(';');
                Set<String> roleSet = new Set<String>(roleList); 
                FunnelInstallationHelper.createPicklistValueSet(roleSet,'FunnelMetrics__Roles','Roles',UserInfo.getSessionId(),false);
            }
            
            If(picklist1 != null ){
                List<String> picklist1List = picklist1.split(';');
                Set<String> picklist1Set = new Set<String>(picklist1List); 
                FunnelInstallationHelper.createPicklistValueSet(picklist1Set ,'FunnelMetrics__Level_Picklist_1','Level Picklist 1',UserInfo.getSessionId(),true);
            }
            
            If(picklist2 != null ){
                List<String> picklist2List = picklist2.split(';');
                Set<String> picklist2Set = new Set<String>(picklist2List);
                FunnelInstallationHelper.createPicklistValueSet(picklist2Set ,'FunnelMetrics__Level_Picklist_2','Level Picklist 2',UserInfo.getSessionId(),true);
            }
            
            If(picklist3 != null ){
                List<String> picklist3List = picklist3.split(';');
                Set<String> picklist3Set = new Set<String>(picklist3List);    
                FunnelInstallationHelper.createPicklistValueSet(picklist3Set ,'FunnelMetrics__Level_Picklist_3','Level Picklist 3',UserInfo.getSessionId(),true);
            }
            
            If(picklist4 != null ){
                List<String> picklist4List = picklist4.split(';');
                Set<String> picklist4Set = new Set<String>(picklist4List);
                FunnelInstallationHelper.createPicklistValueSet(picklist4Set ,'FunnelMetrics__Level_Picklist_4','Level Picklist 4',UserInfo.getSessionId(),true);
            }
            
            If(picklist5 != null ){
                List<String> picklist5List = picklist5.split(';');
                Set<String> picklist5Set = new Set<String>(picklist5List);
                FunnelInstallationHelper.createPicklistValueSet(picklist5Set ,'FunnelMetrics__Level_Picklist_5','Level Picklist 5',UserInfo.getSessionId(),true);
            }
            
            If(picklist6 != null ){
                List<String> picklist6List = picklist6.split(';');
                Set<String> picklist6Set = new Set<String>(picklist6List);
                FunnelInstallationHelper.createPicklistValueSet(picklist6Set ,'FunnelMetrics__Level_Picklist_6','Level Picklist 6',UserInfo.getSessionId(),true);
            }
            
            If(picklist7 != null ){
                List<String> picklist7List = picklist7.split(';');
                Set<String> picklist7Set = new Set<String>(picklist7List); 
                FunnelInstallationHelper.createPicklistValueSet(picklist7Set ,'FunnelMetrics__Level_Picklist_7','Level Picklist 7',UserInfo.getSessionId(),true);
            }
            
            If(picklist8 != null ){
                List<String> picklist8List = picklist8.split(';');
                Set<String> picklist8Set = new Set<String>(picklist8List);
                FunnelInstallationHelper.createPicklistValueSet(picklist8Set ,'FunnelMetrics__Level_Picklist_8','Level Picklist 8',UserInfo.getSessionId(),true);
            }
            
            If(picklist9 != null ){
                List<String> picklist9List = picklist9.split(';');
                Set<String> picklist9Set = new Set<String>(picklist9List);
                FunnelInstallationHelper.createPicklistValueSet(picklist9Set ,'FunnelMetrics__Level_Picklist_9','Level Picklist 9',UserInfo.getSessionId(),true);
            }
            
            If(picklist10 != null ){
                List<String> picklist10List = picklist10.split(';');
                Set<String> picklist10Set = new Set<String>(picklist10List);
                FunnelInstallationHelper.createPicklistValueSet(picklist10Set ,'FunnelMetrics__Level_Picklist_10','Level Picklist 10',UserInfo.getSessionId(),true);
            }
            
            update updatedPicklist;
        }catch(Exception ex){
            
        }
    }
    public void finish(Database.BatchableContext con){
    }*/
    
}