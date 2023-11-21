global class BatchToUpdateGlobalPicklistValue implements Database.Batchable<sobject>,Database.AllowsCallouts, Database.Stateful{
    
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
    
    public CreatePicklistValue__c rolepicklist = new CreatePicklistValue__c();
    public CreatePicklistValue__c picklistV1 = new CreatePicklistValue__c();
    public CreatePicklistValue__c picklistV2 = new CreatePicklistValue__c();
    public CreatePicklistValue__c picklistV3 = new CreatePicklistValue__c();
    public CreatePicklistValue__c picklistV4 = new CreatePicklistValue__c();
    public CreatePicklistValue__c picklistV5 = new CreatePicklistValue__c();
    public CreatePicklistValue__c picklistV6 = new CreatePicklistValue__c();
    public CreatePicklistValue__c picklistV7 = new CreatePicklistValue__c();
    public CreatePicklistValue__c picklistV8 = new CreatePicklistValue__c();
    public CreatePicklistValue__c picklistV9 = new CreatePicklistValue__c();
    public CreatePicklistValue__c picklistV10 = new CreatePicklistValue__c();
    List<CreatePicklistValue__c> updatedPicklist = new List<CreatePicklistValue__c>();
    
    
    Boolean errorVal = false;
    
    public Database.QueryLocator start(Database.BatchableContext con){
        String query = ('Select id, name,Added__c,NewValue__c,Deactivated__c,PicklistValueSet__c,PicklistValueSet__r.name,PicklistValueSet__r.Level_Name__c,Value__c From CreatePicklistValue__c');
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext con, List<CreatePicklistValue__c > picVal){
        try{
			Set<String> roleSet = new Set<String>();
			Set<String> picklist1Set = new Set<String>();
			Set<String> picklist2Set = new Set<String>();
			Set<String> picklist3Set = new Set<String>();
			Set<String> picklist4Set = new Set<String>();
			Set<String> picklist5Set = new Set<String>();
			Set<String> picklist6Set = new Set<String>();
			Set<String> picklist7Set = new Set<String>();
			Set<String> picklist8Set = new Set<String>();
			Set<String> picklist9Set = new Set<String>();
			Set<String> picklist10Set = new Set<String>();
            Map<String,String> picklist1EditMap = new Map<String,String>();
			Map<String,String> picklist2EditMap = new Map<String,String>();
			Map<String,String> picklist3EditMap = new Map<String,String>();
			Map<String,String> picklist4EditMap = new Map<String,String>();
			Map<String,String> picklist5EditMap = new Map<String,String>();
			Map<String,String> picklist6EditMap = new Map<String,String>();
			Map<String,String> picklist7EditMap = new Map<String,String>();
			Map<String,String> picklist8EditMap = new Map<String,String>();
			Map<String,String> picklist9EditMap = new Map<String,String>();
			Map<String,String> picklist10EditMap = new Map<String,String>();
            Map<String,Boolean> picklist1InactMap = new Map<String,Boolean>();
			Map<String,Boolean> picklist2InactMap = new Map<String,Boolean>();
			Map<String,Boolean> picklist3InactMap = new Map<String,Boolean>();
			Map<String,Boolean> picklist4InactMap = new Map<String,Boolean>();
			Map<String,Boolean> picklist5InactMap = new Map<String,Boolean>();
			Map<String,Boolean> picklist6InactMap = new Map<String,Boolean>();
			Map<String,Boolean> picklist7InactMap = new Map<String,Boolean>();
			Map<String,Boolean> picklist8InactMap = new Map<String,Boolean>();
			Map<String,Boolean> picklist9InactMap = new Map<String,Boolean>();
			Map<String,Boolean> picklist10InactMap = new Map<String,Boolean>();
			Set<String> ratingSet = new Set<String>();
			if(picVal != null && picVal.size()>0){
				for(CreatePicklistValue__c p : picVal){
					if(p.PicklistValueSet__r.name == 'role'){
						if(p.Value__c != null)
                            roleSet.add(p.Value__c);
						rolesName = p.PicklistValueSet__r.Level_Name__c;
						p.Added__c = true;
                        rolepicklist = p;
					}if(p.PicklistValueSet__r.name == 'picklist1'){
                        if(p.Value__c != null){
                            if(p.Deactivated__c && !p.Added__c){
                                picklist1EditMap.put(p.Value__c,p.NewValue__c);
                            }else{
                            	picklist1Set.add(p.Value__c);
                            }
                            picklist1InactMap.put(p.Value__c,p.Deactivated__c);
                        }
                        picklist1LevelName = p.PicklistValueSet__r.Level_Name__c ;
						p.Added__c = true;
                        picklistV1 = p;
                    }
                    if(p.PicklistValueSet__r.name == 'picklist2'){
                        if(p.Value__c != null){
                            if(p.Deactivated__c && !p.Added__c){
                                picklist2EditMap.put(p.Value__c,p.NewValue__c);
                            }else{
                            	picklist2Set.add(p.Value__c);
                            }
                            picklist2InactMap.put(p.Value__c,p.Deactivated__c);
                        }
                        picklist2LevelName = p.PicklistValueSet__r.Level_Name__c ;
						p.Added__c = true;
                        picklistV2 = p;
                        
                        
                    }
                    if(p.PicklistValueSet__r.name == 'picklist3'){
                        if(p.Value__c != null){
                            if(p.Deactivated__c && !p.Added__c){
                                picklist3EditMap.put(p.Value__c,p.NewValue__c);
                            }else{
                            	picklist3Set.add(p.Value__c);
                            }
                            picklist3InactMap.put(p.Value__c,p.Deactivated__c);
                        }
                        picklist3LevelName = p.PicklistValueSet__r.Level_Name__c ;
						p.Added__c = true;
                        picklistV3 = p;
                        
                        
                    }
                    if(p.PicklistValueSet__r.name == 'picklist4'){
                        if(p.Value__c != null){
                            if(p.Deactivated__c && !p.Added__c){
                                picklist4EditMap.put(p.Value__c,p.NewValue__c);
                            }else{
                            	picklist4Set.add(p.Value__c);
                            }
                            picklist4InactMap.put(p.Value__c,p.Deactivated__c);
                        }
                        picklist4LevelName = p.PicklistValueSet__r.Level_Name__c ;
						p.Added__c = true;
                        picklistV4 = p;
                        
                        
                    }
                    if(p.PicklistValueSet__r.name == 'picklist5'){
                        if(p.Value__c != null){
                            if(p.Deactivated__c && !p.Added__c){
                                picklist5EditMap.put(p.Value__c,p.NewValue__c);
                            }else{
                            	picklist5Set.add(p.Value__c);
                            }
                            picklist5InactMap.put(p.Value__c,p.Deactivated__c);
                        }
                        picklist5LevelName = p.PicklistValueSet__r.Level_Name__c ;
						p.Added__c = true;
                        picklistV5 = p;
                        
                        
                    }
                    if(p.PicklistValueSet__r.name == 'picklist6'){
                        if(p.Value__c != null){
                            if(p.Deactivated__c && !p.Added__c){
                                picklist6EditMap.put(p.Value__c,p.NewValue__c);
                            }else{
                            	picklist6Set.add(p.Value__c);
                            }
                            picklist6InactMap.put(p.Value__c,p.Deactivated__c);
                        }
                        picklist6LevelName = p.PicklistValueSet__r.Level_Name__c ;
						p.Added__c = true;
                        picklistV6 = p;
                        
                    }
                    if(p.PicklistValueSet__r.name == 'picklist7'){
                        if(p.Value__c != null){
                            if(p.Deactivated__c && !p.Added__c){
                                picklist7EditMap.put(p.Value__c,p.NewValue__c);
                            }else{
                            	picklist7Set.add(p.Value__c);
                            }
                            picklist7InactMap.put(p.Value__c,p.Deactivated__c);
                        }
                        picklist7LevelName = p.PicklistValueSet__r.Level_Name__c ;
						p.Added__c = true;
                        picklistV7 = p;
                        
                        
                    }
                    if(p.PicklistValueSet__r.name == 'picklist8'){
                        if(p.Value__c != null){
                            if(p.Deactivated__c && !p.Added__c){
                                picklist8EditMap.put(p.Value__c,p.NewValue__c);
                            }else{
                            	picklist8Set.add(p.Value__c);
                            }
                            picklist8InactMap.put(p.Value__c,p.Deactivated__c);
                        }
                        picklist8LevelName = p.PicklistValueSet__r.Level_Name__c ;
						p.Added__c = true;
                        picklistV8 = p;
                        
                        
                    }
                    if(p.PicklistValueSet__r.name == 'picklist9'){
                        if(p.Value__c != null){
                            if(p.Deactivated__c && !p.Added__c){
                                picklist9EditMap.put(p.Value__c,p.NewValue__c);
                            }else{
                            	picklist9Set.add(p.Value__c);
                            }
                            picklist9InactMap.put(p.Value__c,p.Deactivated__c);
                        }
                        picklist9LevelName = p.PicklistValueSet__r.Level_Name__c ;
						p.Added__c = true;
                        picklistV9 = p;
                         
                    }
                    if(p.PicklistValueSet__r.name == 'picklist10'){
                        if(p.Value__c != null){
                            if(p.Deactivated__c && !p.Added__c){
                                picklist10EditMap.put(p.Value__c,p.NewValue__c);
                            }else{
                            	picklist10Set.add(p.Value__c);
                            }
                            picklist10InactMap.put(p.Value__c,p.Deactivated__c);
                        }
                        picklist10LevelName = p.PicklistValueSet__r.Level_Name__c ;
						p.Added__c = true;
                        picklistV10 = p;
                        
                    }
                    updatedPicklist.add(p);
				}
			}
            
            If(picklist1EditMap != null && picklist1EditMap.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetAndUpdateSrpUsingBatch(picklist1EditMap ,'FunnelMetrics__Level_Picklist_1','Level Picklist 1',UserInfo.getSessionId(),true,picklist1InactMap);
            }
            
            If(picklist2EditMap != null && picklist2EditMap.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetAndUpdateSrpUsingBatch(picklist2EditMap ,'FunnelMetrics__Level_Picklist_2','Level Picklist 2',UserInfo.getSessionId(),true,picklist2InactMap);
            }
            
            If(picklist3EditMap != null && picklist3EditMap.size()>0 ){  
                FunnelInstallationHelper.createPicklistValueSetAndUpdateSrpUsingBatch(picklist3EditMap ,'FunnelMetrics__Level_Picklist_3','Level Picklist 3',UserInfo.getSessionId(),true,picklist3InactMap);
            }
            
            If(picklist4EditMap != null && picklist4EditMap.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetAndUpdateSrpUsingBatch(picklist4EditMap ,'FunnelMetrics__Level_Picklist_4','Level Picklist 4',UserInfo.getSessionId(),true,picklist4InactMap);
            }
            
            If(picklist5EditMap != null && picklist5EditMap.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetAndUpdateSrpUsingBatch(picklist5EditMap ,'FunnelMetrics__Level_Picklist_5','Level Picklist 5',UserInfo.getSessionId(),true,picklist5InactMap);
            }
            If(picklist6EditMap != null && picklist6EditMap.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetAndUpdateSrpUsingBatch(picklist6EditMap ,'FunnelMetrics__Level_Picklist_6','Level Picklist 6',UserInfo.getSessionId(),true,picklist6InactMap);
            }
            
            If(picklist7EditMap != null && picklist7EditMap.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetAndUpdateSrpUsingBatch(picklist7EditMap ,'FunnelMetrics__Level_Picklist_7','Level Picklist 7',UserInfo.getSessionId(),true,picklist7InactMap);
            }
            
            If(picklist8EditMap != null && picklist8EditMap.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetAndUpdateSrpUsingBatch(picklist8EditMap ,'FunnelMetrics__Level_Picklist_8','Level Picklist 8',UserInfo.getSessionId(),true,picklist8InactMap);
            }
            
            If(picklist9EditMap != null && picklist9EditMap.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetAndUpdateSrpUsingBatch(picklist9EditMap ,'FunnelMetrics__Level_Picklist_9','Level Picklist 9',UserInfo.getSessionId(),true,picklist9InactMap);
            }
            
            If(picklist10EditMap != null && picklist10EditMap.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetAndUpdateSrpUsingBatch(picklist10EditMap ,'FunnelMetrics__Level_Picklist_10','Level Picklist 10',UserInfo.getSessionId(),true,picklist10InactMap);
            }
			If(roleSet!= null && roleSet.size()>0){
                FunnelInstallationHelper.createPicklistValueSetUsingBatch(roleSet,'FunnelMetrics__Roles','Roles',UserInfo.getSessionId(),false);
            }
            
            If(picklist1Set != null && picklist1Set.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetUsingBatch(picklist1Set ,'FunnelMetrics__Level_Picklist_1','Level Picklist 1',UserInfo.getSessionId(),true);
            }
            
            If(picklist2Set != null && picklist2Set.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetUsingBatch(picklist2Set ,'FunnelMetrics__Level_Picklist_2','Level Picklist 2',UserInfo.getSessionId(),true);
            }
            
            If(picklist3Set != null && picklist3Set.size()>0 ){  
                FunnelInstallationHelper.createPicklistValueSetUsingBatch(picklist3Set ,'FunnelMetrics__Level_Picklist_3','Level Picklist 3',UserInfo.getSessionId(),true);
            }
            
            If(picklist4Set != null && picklist4Set.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetUsingBatch(picklist4Set ,'FunnelMetrics__Level_Picklist_4','Level Picklist 4',UserInfo.getSessionId(),true);
            }
            
            If(picklist5Set != null && picklist5Set.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetUsingBatch(picklist5Set ,'FunnelMetrics__Level_Picklist_5','Level Picklist 5',UserInfo.getSessionId(),true);
            }
            
            If(picklist6Set != null && picklist6Set.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetUsingBatch(picklist6Set ,'FunnelMetrics__Level_Picklist_6','Level Picklist 6',UserInfo.getSessionId(),true);
            }
            
            If(picklist7Set != null && picklist7Set.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetUsingBatch(picklist7Set ,'FunnelMetrics__Level_Picklist_7','Level Picklist 7',UserInfo.getSessionId(),true);
            }
            
            If(picklist8Set != null && picklist8Set.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetUsingBatch(picklist8Set ,'FunnelMetrics__Level_Picklist_8','Level Picklist 8',UserInfo.getSessionId(),true);
            }
            
            If(picklist9Set != null && picklist9Set.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetUsingBatch(picklist9Set ,'FunnelMetrics__Level_Picklist_9','Level Picklist 9',UserInfo.getSessionId(),true);
            }
            
            If(picklist10Set != null && picklist10Set.size()>0 ){
                FunnelInstallationHelper.createPicklistValueSetUsingBatch(picklist10Set ,'FunnelMetrics__Level_Picklist_10','Level Picklist 10',UserInfo.getSessionId(),true);
            }
            
        }catch(Exception ex){
            errorVal = true;
            FunnelTriggerBatchHelper.sendErrorMail(' BatchToUpdateGlobalPicklistValue'+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
            
        }
    }
    public void finish(Database.BatchableContext con){
        if(!errorVal){
            update updatedPicklist;
        }
    }

}