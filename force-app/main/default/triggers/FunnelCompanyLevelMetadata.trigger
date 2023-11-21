trigger FunnelCompanyLevelMetadata on Company_Level__c (after insert , after update, before update, before insert) {

   
    Map<id,id> salesProfCertMap = new Map<id,id>();
    List<Certification__c> certRecords = [SELECT id,Sales_Rep_Profile__c FROM Certification__c LIMIT 5000];
    for(Certification__c c:certRecords){
        salesProfCertMap.put(c.Sales_Rep_Profile__c,c.id);       
    }

  /*  Set<String> LevelNames = new Set<String>();
    Set<String> OldLevelNames = new Set<String>();
    Schema.DescribeFieldResult statusFieldDescription = Sales_Profile_Company_Level_Junction__c.Company_Level_Picklist__c.getDescribe();
    for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues()){ 
             LevelNames.add(pickListEntry.getLabel());
            OldLevelNames.add(pickListEntry.getLabel());
    }
    
    Set<id> tn =  new Set<id>(); */
    
    //List to store the company levels for which the sales profile is updated
    List<Id> updatedLevelIds = new List<Id>();

    Map<Id,Id> levelNewSPMap = new Map<Id,Id>();

    List<Id> removeJuncsFromProfs = new List<Id>();
    
    //Map of manager and reps under
    Map<Id,List<Id>> profMgrMap = new Map<Id,List<Id>>();
    
    //Map of manager and reps under
    Map<Id,List<Sales_Rep_Profile__c>> profMgrMapSrp = new Map<Id,List<Sales_Rep_Profile__c>>();
    Map<Id,List<Sales_Rep_Profile__c>> updateProfMgrMapSrp = new Map<Id,List<Sales_Rep_Profile__c>>();
    
    List<Sales_Profile_Company_Level_Junction__c> junc = new List<Sales_Profile_Company_Level_Junction__c>();
    
    List<Sales_Rep_Profile__c> allProfs = [SELECT id, Sales_Manager__c FROM Sales_Rep_Profile__c LIMIT 2000];                    
            
    for(Sales_Rep_Profile__c s:allProfs){
        if(s.Sales_Manager__c != null){
            if(profMgrMap == null || (!profMgrMap.keySet().contains(s.Sales_Manager__c))){
                List<Id> suborList = new List<Id>();
                suborList.add(s.Id);
                profMgrMap.put(s.Sales_Manager__c,suborList);
                
                List<Sales_Rep_Profile__c> suborListSrp = new List<Sales_Rep_Profile__c>();
                suborListSrp.add(s);
                profMgrMapSrp.put(s.Sales_Manager__c,suborListSrp);
                
            }
            else if(profMgrMap.containsKey(s.Sales_Manager__c)){
                profMgrMap.get(s.Sales_Manager__c).add(s.id);
                profMgrMapSrp.get(s.Sales_Manager__c).add(s);
            }
        }
    }
    
    
    
    for(Company_Level__c  s : Trigger.new){ 
        
     /*   LevelNames.add(s.Level_Value__c); */
        
         
        if(trigger.isBefore && s.Sales_Rep_Profile__c != null && salesProfCertMap.get(s.Sales_Rep_Profile__c) != null) 
            s.Certification__c = salesProfCertMap.get(s.Sales_Rep_Profile__c);
        else if(trigger.isBefore && s.Sales_Rep_Profile__c == null){
            s.Certification__c = null;
        }
        
    /*   if(trigger.isAfter) 
            tn.add(s.id); */
            
        //If the company level record has been updated, and the sales profile value on the record is changed
        if(trigger.isAfter && trigger.isUpdate && Trigger.oldMap.get(s.id).Sales_Rep_Profile__c != s.Sales_Rep_Profile__c){
            system.debug(' sales profile record has been changed to '+s.Sales_Rep_Profile__c);
            updatedLevelIds.add(s.id);
            if(s.Sales_Rep_Profile__c != null){
                levelNewSPMap.put(s.id,s.Sales_Rep_Profile__c);    
            }
            
            // Maintenance US update the Reps with new Manager
            // Added to update the manager on srp records when srp in company level is updated
            if(profMgrMapSrp.get(Trigger.oldMap.get(s.id).Sales_Rep_Profile__c) != null && profMgrMapSrp.get(Trigger.oldMap.get(s.id).Sales_Rep_Profile__c).size() > 0){
                updateProfMgrMapSrp.put(s.Sales_Rep_Profile__c,profMgrMapSrp.get(Trigger.oldMap.get(s.id).Sales_Rep_Profile__c));
            }
            
            /*
            else if(s.Sales_Rep_Profile__c == null){
                system.debug(' sales profile has been made blank on the company level');
                //Sales profile has been removed, just delete all junction recs associated with the level
                removeJuncsFromProfs.add(s.id);
            } */ 

            
            
        }        
    }
    
    
    
   /* if(! LevelNames.equals(OldLevelNames)){
        
        if(trigger.isupdate && trigger.isAfter)
            FunnelUpdateMetaData.createCompanyLevel(LevelNames,tn , false , UserInfo.getSessionId());
        
        if(trigger.isinsert && trigger.isAfter)
            FunnelUpdateMetaData.createCompanyLevel(LevelNames , tn , true , UserInfo.getSessionId());
        
    }
    else */ if(trigger.isinsert){
                            
        for(Company_Level__c c:trigger.new){
            if(trigger.isAfter){
                if(c.Sales_Rep_Profile__c != null){
                                        
                    List<Id> mgrIds = new List<Id>();
                    mgrIds.add(c.Sales_Rep_Profile__c);
                    
                    List<Id> junctsToBeCreated = new List<Id>();
                    junctsToBeCreated.add(c.Sales_Rep_Profile__c);
                    
                    while(mgrIds != null && mgrIds.size()>0){
                        List<Id> newMgrIds = new List<Id>();
                        for(Id mgrId:mgrIds){
                            if(profMgrMap.get(mgrId) != null){
                                junctsToBeCreated.addAll(profMgrMap.get(mgrId)); 
                                newMgrIds.addAll(profMgrMap.get(mgrId));
                            }          
                        }
                        mgrIds = new List<Id>();
                        mgrIds.addAll(newMgrIds);
                    }
                    
                    system.debug(' junctsToBeCreated '+junctsToBeCreated);                              
            
                    for(Id sp : junctsToBeCreated){    
                        Sales_Profile_Company_Level_Junction__c j = new Sales_Profile_Company_Level_Junction__c();
                        j.Company_Level__c = c.id;
                        j.Sales_Rep_Profile__c = sp;
                        j.Certification__c = salesProfCertMap.get(sp);
                   /*     j.Company_Level_Picklist__c = c.Level_Value__c; */
                        junc.add(j);   
                    }            
                }
            }
                  
        }
        
        if(trigger.isafter && junc != null && junc.size()>0){
            insert junc;
        }
    }
    
    if(updatedLevelIds != null && updatedLevelIds.size() > 0){
        Map<id,Sales_Profile_Company_Level_Junction__c> levelsToBeDeletedMap = new Map<id,Sales_Profile_Company_Level_Junction__c>([SELECT id FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__c IN :updatedLevelIds]);
        
        FunnelTriggerBatchHelper.deleteJunctionRecords(levelsToBeDeletedMap.keySet());
        //DELETE levelsToBeDeleted;
    }
    
    /*
    if(removeJuncsFromProfs != null && removeJuncsFromProfs.size() > 0){
        system.debug(' removing the junction records as the sales profile on the company record has been removed');
        
        Map<id,Sales_Profile_Company_Level_Junction__c> levelsToBeDeletedMap = new Map<id,Sales_Profile_Company_Level_Junction__c>([SELECT id FROM Sales_Profile_Company_Level_Junction__c WHERE Company_Level__c IN :removeJuncsFromProfs ]);
        
        FunnelTriggerBatchHelper.deleteJunctionRecords(levelsToBeDeletedMap.keySet());
        //DELETE levelsToBeDeleted;
    }*/
    
    if(levelNewSPMap != null && levelNewSPMap.size() > 0){
        
        junc = new List<Sales_Profile_Company_Level_Junction__c>();
    
        system.debug(' sales prof on level has been changed ');
        Map<Id,Company_level__c> idLevelMap = new Map<Id,Company_Level__c>();
        
        List<Company_Level__c> clist = [SELECT id, Level_Value__c FROM Company_Level__c WHERE id IN :levelNewSPMap.keySet()];
        
        for(Company_Level__c c: clist){
            idLevelMap.put(c.id,c);
        }
        
        List<Sales_Profile_Company_Level_Junction__c> junc = new List<Sales_Profile_Company_Level_Junction__c>();
        
        for (id key: levelNewSPMap.keySet()){
            
            List<Id> mgrIds = new List<Id>();
            mgrIds.add(levelNewSPMap.get(key));
            
            List<Id> junctsToBeCreated = new List<Id>();
            junctsToBeCreated.add(levelNewSPMap.get(key));
            
            while(mgrIds != null && mgrIds.size()>0){
                List<Id> newMgrIds = new List<Id>();
                for(Id mgrId:mgrIds){
                    if(profMgrMap.get(mgrId) != null){
                        junctsToBeCreated.addAll(profMgrMap.get(mgrId)); 
                        newMgrIds.addAll(profMgrMap.get(mgrId));
                    }          
                }
                mgrIds = new List<Id>();
                mgrIds.addAll(newMgrIds);
            }
            
            for(Id sp : junctsToBeCreated){    
                Sales_Profile_Company_Level_Junction__c j = new Sales_Profile_Company_Level_Junction__c();
                j.Company_Level__c = key;
                j.Sales_Rep_Profile__c = sp;
                j.Certification__c = salesProfCertMap.get(sp);
            /*    j.Company_Level_Picklist__c = idLevelMap.get(key).Level_Value__c; */
                junc.add(j);   
            }                                          
        }  
        
        if(junc.size() > 0){
            insert junc;
        }
        
        system.debug(' new junctions to be created '+junc);       
    }
    
    // Added to update the manager on srp records when srp in company level is updated
    if(updateProfMgrMapSrp != null && updateProfMgrMapSrp.size()>0){
        FunnelTriggerBatchHelper.updateManger(updateProfMgrMapSrp);
        
    }

}