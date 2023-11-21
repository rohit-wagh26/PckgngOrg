public with sharing class FunnelInstallationHelper{
    
    @future
    public static void addDelUserLicenses(String function, List<id> ul){
        
        List<PackageLicense> pList = [SELECT Id FROM PackageLicense WHERE NamespacePrefix = 'FunnelMetrics'];
        PackageLicense pl;
        
        if(pList != null && pList.size()>0){
            
            pl = pList[0];
        }
        
        if(pl != null){
            
            if(function == 'insert'){           
                
                List<UserPackageLicense> ulist = new List<UserPackageLicense>();
                
                for(id i:ul){
                    UserPackageLicense up = new UserPackageLicense(UserId = i, PackageLicenseId = pl.id);
                    ulist.add(up);                  
                }
                
                insert ulist;
            }
            
            if (function == 'delete'){
                
                List<UserPackageLicense> ulist = new List<UserPackageLicense>();
                
                if(ul.size() > 0)
                    ulist = [SELECT id FROM UserPackageLicense WHERE UserId IN :ul AND PackageLicenseId = :pl.id];
                
                if(ulist != null && ulist.size() > 0)
                    DELETE ulist;
            } 
        }  
    }
    
    
    @future(callout=true)
    public static void saveStep(String Step){
        
        List<FM_Installation__mdt> installMdt = [SELECT Saved_Page__c,label FROM FM_Installation__mdt LIMIT 500];
        System.debug('install save step installMdt '+installMdt );
        if(installMdt != null && installMdt.size()>0 ){
            System.debug('install save Step '+Step);
            if(integer.valueof(installMdt[0].Saved_Page__c) < integer.valueof(Step)){
                Map<String, Object> maptest = new Map<String, Object>();
                maptest.put('FunnelMetrics__Saved_Page__c',Step);
                // Metadataname.developername,Materlable,fields
                if(!test.isRunningTest())
                    FMCreateUpdateMetadataUtils.createUpdateMetadata('FunnelMetrics__FM_Installation.Step','Saved Step',maptest);
            }
        }else{
            System.debug('install save Step else'+Step);
            Map<String, Object> maptest = new Map<String, Object>();
            maptest.put('FunnelMetrics__Saved_Page__c','0');
            if(!test.isRunningTest())
                FMCreateUpdateMetadataUtils.createUpdateMetadata('FunnelMetrics__FM_Installation.Step','Saved Step',maptest);
        }
        
    }   
    
    
    @future(callout=true)
    Public static void createOrgEmail(String e){
        Map<String, Object> maptest = new Map<String, Object>();
        
        if(!test.isRunningTest())
            FMCreateUpdateMetadataUtils.createUpdateMetadata('FunnelMetrics__Funnel_Org_Wide_Address.noReply_FM_com',e,maptest);
    }
    
    @future(callout=true)
    Public static void createAdminEmail(String adminEmailMtd ,String copyadminEmailMtd, String sessionId ){
        List<FM_Admins__mdt> adminMdt = [SELECT label FROM FM_Admins__mdt LIMIT 500];
        if(adminMdt != null && adminMdt.size()>0 && adminEmailMtd != copyadminEmailMtd ){
            MetadataService.MetadataPort service = new  MetadataService.MetadataPort();
            service.SessionHeader = new MetadataService.SessionHeader_element();
            service.SessionHeader.sessionId = UserInfo.getSessionId();
            //service.SessionHeader.sessionId = sessionId ;
            //service.SessionHeader.sessionId = '{!$FM_API.OAuthToken}';
            List<String> recordsToDelete = new List<String>();
            for(FM_Admins__mdt admtd : [SELECT DeveloperName , label FROM FM_Admins__mdt LIMIT 5000]){
                String s = 'FunnelMetrics__FM_Admins.'+admtd.DeveloperName ;
                recordsToDelete.add(s);
            }
            
            if (!test.isRunningTest())
                service.deleteMetadata('CustomMetadata', recordsToDelete);
        }
        
        List<String> adminEmailMtdList = adminEmailMtd.split(';');
        List<string> sList = new List<String>();
        List<string> eList = new List<String>();
        List<Map<String, Object>> maptestList= new List<Map<String, Object>>();
        
        if(adminEmailMtdList != null && adminEmailMtdList.size()>0){
            integer count = 1;
            for(String e : adminEmailMtdList ){
                Map<String, Object> maptest = new Map<String, Object>();
                String s = 'FunnelMetrics__FM_Admins.admin_'+String.valueOf(count );
                sList.add(s);
                eList.add(e);
                maptestList.add(maptest);
                count ++;
            } 
        }
        
        if (!test.isRunningTest())
            FMCreateUpdateMetadataUtils.createUpdateMetadataList(sList,eList,maptestList);
    }
    
    @future(callout=true)
    Public static void createPicklistValueSet(Set<String> names , String picklistName,String masterLabelName, String sessionId, Boolean fromMaintenance)
    {      
        system.debug('names '+names );
        
        if(fromMaintenance){
            String picklistApiName = picklistName + '__c';
            DescribeSObjectResult objResult = Schema.getGlobalDescribe()
                .get('FunnelMetrics__Sales_Rep_Profile__c').getDescribe();
            // Get the field dynamically
            DescribeFieldResult fieldResult = objResult.fields.getMap()
                .get(picklistApiName).getDescribe();
            
            for (Schema.Picklistentry picklistEntry : fieldResult.getPicklistValues()){ 
                names.add(pickListEntry.getLabel());
            }
        }
        
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        //service.SessionHeader.sessionId = sessionId;
        //service.SessionHeader.sessionId = '{!$FM_API.OAuthToken}';
        
        
        MetadataService.GlobalValueSet  globalValueSet = new MetadataService.GlobalValueSet ();
        //globalValueSet.masterLabel = 'Rating Names';
        globalValueSet.masterLabel = masterLabelName;
        //globalValueSet.fullName ='FunnelMetrics__Rating_Names';
        globalValueSet.fullName = picklistName;
        
        Boolean del = true;
        List<MetadataService.customValue> mc = new list<MetadataService.customValue>();
        for(String s : names ){
            if(s != ''){ 
                MetadataService.customValue c1 = new MetadataService.CustomValue();
                c1.default_x = false;
                c1.isActive = true;
                c1.fullName = s;
                mc.add(c1);
                del = false;
            }
        }
        
        if(del){
            
            MetadataService.customValue c1 = new MetadataService.CustomValue();
            c1.default_x = false;
            c1.isActive = false;
            c1.fullName = 'Del';
            mc.add(c1);
        }
        globalValueSet.customValue = mc;
        if(!test.isRunningTest()){
            List<MetadataService.SaveResult> results = service.updateMetadata(new MetadataService.Metadata[] { globalValueSet });
        }
    }
    
    //@future(callout=true)
    Public static void createPicklistValueSetUsingBatch(Set<String> names , String picklistName,String masterLabelName, String sessionId, Boolean fromMaintenance)
    {      
        
        if(fromMaintenance){
            String picklistApiName = picklistName + '__c';
            DescribeSObjectResult objResult = Schema.getGlobalDescribe()
                .get('FunnelMetrics__Sales_Rep_Profile__c').getDescribe();
            // Get the field dynamically
            DescribeFieldResult fieldResult = objResult.fields.getMap()
                .get(picklistApiName).getDescribe();
            
            for (Schema.Picklistentry picklistEntry : fieldResult.getPicklistValues()){ 
                names.add(pickListEntry.getLabel());
            }
        }
        
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        //service.SessionHeader.sessionId = sessionId;
        //service.SessionHeader.sessionId = '{!$FM_API.OAuthToken}';
        
        
        MetadataService.GlobalValueSet  globalValueSet = new MetadataService.GlobalValueSet ();
        //globalValueSet.masterLabel = 'Rating Names';
        globalValueSet.masterLabel = masterLabelName;
        //globalValueSet.fullName ='FunnelMetrics__Rating_Names';
        globalValueSet.fullName = picklistName;
        
        
        Boolean del = true;
        List<MetadataService.customValue> mc = new list<MetadataService.customValue>();
        for(String s : names ){
            if(s != ''){ 
                MetadataService.customValue c1 = new MetadataService.CustomValue();
                c1.default_x = false;
                c1.isActive = true;
                c1.fullName = s;
                mc.add(c1);
                del = false;
            }
        }
        
        if(del){
            
            MetadataService.customValue c1 = new MetadataService.CustomValue();
            c1.default_x = false;
            c1.isActive = false;
            c1.fullName = 'Del';
            mc.add(c1);
        }
        globalValueSet.customValue = mc;
        if(!test.isRunningTest()){
            List<MetadataService.SaveResult> results = service.updateMetadata(new MetadataService.Metadata[] { globalValueSet });
        }
        
        
        
    }
    
    Public static void createPicklistValueSetAndUpdateSrpUsingBatch(Map<String,String> namesMap , String picklistName,String masterLabelName, String sessionId, Boolean fromMaintenance,Map<String,Boolean> inactValMap){      
        Set<String> names = new Set<String>(namesMap.keySet());
        if(fromMaintenance){
            String picklistApiName = picklistName + '__c';
            DescribeSObjectResult objResult = Schema.getGlobalDescribe()
                .get('FunnelMetrics__Sales_Rep_Profile__c').getDescribe();
            // Get the field dynamically
            DescribeFieldResult fieldResult = objResult.fields.getMap()
                .get(picklistApiName).getDescribe();
            
            for (Schema.Picklistentry picklistEntry : fieldResult.getPicklistValues()){ 
                names.add(pickListEntry.getLabel());
            }
        }
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        //service.SessionHeader.sessionId = sessionId;
        //service.SessionHeader.sessionId = '{!$FM_API.OAuthToken}';
        
        
        MetadataService.GlobalValueSet  globalValueSet = new MetadataService.GlobalValueSet ();
        //globalValueSet.masterLabel = 'Rating Names';
        globalValueSet.masterLabel = masterLabelName;
        //globalValueSet.fullName ='FunnelMetrics__Rating_Names';
        
        String s2 = picklistName.Substring(0,picklistName.length()-3);
        globalValueSet.fullName = picklistName;
        Boolean del = true;
        List<MetadataService.customValue> mc = new list<MetadataService.customValue>();
        for(String s : inactValMap.keySet() ){
            if(s != '' && inactValMap.get(s) != true){ 
                MetadataService.customValue c1 = new MetadataService.CustomValue();
                c1.default_x = false;
                c1.isActive = true;
                c1.fullName = s;
                mc.add(c1);
                del = false;
            }
            
        }
        
        if(del){
            MetadataService.customValue c1 = new MetadataService.CustomValue();
            c1.default_x = false;
            c1.isActive = false;
            c1.fullName = 'Del';
            mc.add(c1);
        }
        globalValueSet.customValue = mc;
        if(!test.isRunningTest()){
            List<MetadataService.SaveResult> results = service.updateMetadata(new MetadataService.Metadata[] { globalValueSet });
        }
        
        List<Sales_Rep_Profile__c> updateSrpLevel = new List<Sales_Rep_Profile__c>();
        Set<String> namesKey = namesMap.keySet();
        String pname;
        
        if(namesKey != null && namesKey.size()>0){
            for(String k : namesKey){
                if(pname == null || pname == ''){
                    pname ='\''+k+'\'';  
                }else{
                    pname+= ',\''+k+'\'';
                }
            }
        }
        String pickQueryName = picklistName+'__c';
        if(namesKey != null && namesKey.size()>0){
            String q = 'Select id,'+pickQueryName+' from Sales_Rep_Profile__c where '+ pickQueryName +' IN ('+pname+')';
            updateSrpLevel =  Database.query(q);
        }
        
        if(updateSrpLevel != null && updateSrpLevel.size()>0){
            for(Sales_Rep_Profile__c s : updateSrpLevel){
                String newVal = namesMap.get(String.valueOf(s.get(pickQueryName)));
                s.put(pickQueryName,newVal);
                
            }
            
            FunnelTriggerBatchHelper.doNotCallSPTrigger = true;
            update updateSrpLevel;  
            FunnelTriggerBatchHelper.doNotCallSPTrigger = false;
        }
        
        List<Sales_Rep_Profile_Snapshot__c > updateSrpLevelSnap = new List<Sales_Rep_Profile_Snapshot__c >();
        if(namesKey != null && namesKey.size()>0){
            String qs = 'Select id,'+pickQueryName+' from Sales_Rep_Profile_Snapshot__c where '+ pickQueryName +' IN ('+pname+')';
            updateSrpLevelSnap =  Database.query(qs);
        }
        if(updateSrpLevelSnap != null && updateSrpLevelSnap .size()>0){
            for(Sales_Rep_Profile_Snapshot__c s : updateSrpLevelSnap){
                String newVal = namesMap.get(String.valueOf(s.get(pickQueryName)));
                s.put(pickQueryName,newVal);
                
            }
            
            
            update updateSrpLevelSnap;  
            
        }
    }
    
    
    @future(callout=true)
    public static void createPermsissions(){
        System.debug('createPermsissions:::');
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
        PermissionSet readAllpermission = [SELECT Id  ,name FROM PermissionSet where name ='FunnelReadAccessAllObjs'];
        System.debug('readAllpermission:::'+readAllpermission);
        
        List<string> existingRealAllUserList = new List<string>();
        List<PermissionSetAssignment> FunnelReadAll = [Select AssigneeId FROM PermissionSetAssignment WHERE  PermissionSet.Name = 'FunnelReadAccessAllObjs'];
        
        
        for(PermissionSetAssignment p: FunnelReadAll){
            existingRealAllUserList.add(p.AssigneeId);
            
        }
        System.debug('existingRealAllUserList:::'+existingRealAllUserList);
        
        List<Sales_Rep_Profile__c> srpList =[Select id ,name, User_Record_Name__c  from Sales_Rep_Profile__c Where User_Record_Name__c != null AND User_Record_Name__r.IsActive = true];
        for(Sales_Rep_Profile__c s : srpList){
            System.debug('s:::'+s.name);
            if(!existingRealAllUserList.contains(s.User_Record_Name__c)){
                System.debug('s inside:::'+s.name);
                PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = readAllpermission.id, AssigneeId = s.User_Record_Name__c);
                permissionSetList.add(psa); 
            }
            
        }
        
        try{
            if(permissionSetList != null)
                upsert permissionSetList;
        }catch(exception e){
            system.debug('exception caught' + e);
        }
        
        permissionSetList = new List<PermissionSetAssignment>();
        PermissionSet certUpdatepermission  = [SELECT Id  ,name FROM PermissionSet where name ='Funnel_Certification_Updates'];
        
        List<string> existingCertUpdateList = new List<string>();
        List<PermissionSetAssignment> FunnelcertUpdate = [Select AssigneeId FROM PermissionSetAssignment WHERE  PermissionSet.Name = 'Funnel_Certification_Updates'];
        for(PermissionSetAssignment p: FunnelcertUpdate){
            existingCertUpdateList.add(p.AssigneeId);
            
        }
        
        srpList = new List<Sales_Rep_Profile__c> ();
        srpList =[Select id ,User_Record_Name__c, Sales_Manager__r.User_Record_Name__c  from Sales_Rep_Profile__c Where Sales_Manager__c != null And Sales_Manager__r.User_Record_Name__c != null AND Sales_Manager__r.User_Record_Name__r.IsActive = true];
        List<string> addedManager = new List<string>();
        
        for(Sales_Rep_Profile__c s : srpList){
            if(!existingCertUpdateList.contains(s.Sales_Manager__r.User_Record_Name__c) && !addedManager.contains(s.Sales_Manager__r.User_Record_Name__c)){
                PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = certUpdatepermission.id, AssigneeId = s.Sales_Manager__r.User_Record_Name__c);
                permissionSetList.add(psa); 
                addedManager.add(s.Sales_Manager__r.User_Record_Name__c);
            }
            
        }
        
        List<Company_Level__c  > clist = [Select id,Sales_Rep_Profile__c,Sales_Rep_Profile__r.User_Record_Name__c    from Company_Level__c  where Sales_Rep_Profile__c != null];
        for(Company_Level__c  c : clist){
            if(!existingCertUpdateList.contains(c.Sales_Rep_Profile__r.User_Record_Name__c) && !addedManager.contains(c.Sales_Rep_Profile__r.User_Record_Name__c)){
                PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = certUpdatepermission.id, AssigneeId = c.Sales_Rep_Profile__r.User_Record_Name__c);
                permissionSetList.add(psa); 
                addedManager.add(c.Sales_Rep_Profile__r.User_Record_Name__c);
            }
        }
        
        try{
            if(permissionSetList != null)
                upsert permissionSetList;
        }catch(exception e){
            system.debug('exception caught' + e);
        }
        
        permissionSetList = new List<PermissionSetAssignment>();
        PermissionSet appSetuppermission  = [SELECT Id  ,name FROM PermissionSet where name ='Funnel_App_Setup'];
        permissionSet srpUpdatepermission  = [SELECT Id  ,name FROM PermissionSet where name ='FunnelSalesProfileUpdateAccess'];
        
        List<string> existingAppSetupList = new List<string>();
        List<PermissionSetAssignment> FunnelAppSetup = [Select AssigneeId FROM PermissionSetAssignment WHERE  PermissionSet.Name = 'Funnel_App_Setup'];
        for(PermissionSetAssignment p: FunnelAppSetup){
            existingAppSetupList.add(p.AssigneeId);
            
        }
        
        List<string> existingSrpUpdateList = new List<string>();
        List<PermissionSetAssignment> FunnelSrpUpdate = [Select AssigneeId FROM PermissionSetAssignment WHERE  PermissionSet.Name = 'FunnelSalesProfileUpdateAccess'];
        for(PermissionSetAssignment p: FunnelSrpUpdate){
            existingSrpUpdateList.add(p.AssigneeId);
            
        }
        
        
        for (User u : [SELECT ID,name  FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true]){  
            if(!existingAppSetupList.contains(u.Id)){
                PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = appSetuppermission.id, AssigneeId = u.Id);
                permissionSetList.add(psa);
            }
            if(!existingSrpUpdateList.contains(u.Id)){
                PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = srpUpdatepermission.id, AssigneeId = u.Id);
                permissionSetList.add(psa);
            }
        }
        
        try{
            if(permissionSetList != null)
                upsert permissionSetList;
        }catch(exception e){
            system.debug('exception caught' + e);
        }
    }
    
    public static PageReference navigateToIntro(){
        
        PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationIntro?Wiz=false'); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }
    
    public static PageReference navigateToIntroFromWiz(){
        
        PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationIntro?Wiz=true'); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }
    
    public static PageReference navigateToStep1(){
        
        PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationStep1'); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }
    
    public static PageReference navigateToStep2(){
        
        PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationStep2'); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }
    
    
    
    public static PageReference navigateToStep3a(){
        
        PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationStep3a'); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }
    
    public static PageReference navigateToStep3b(){
        
        PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationStep3b'); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }
    
    public static PageReference navigateToStep4a(){
        
        PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationStep4a'); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }
    
    public static PageReference navigateToStep4b(){
        
        PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationStep4b'); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }
    
    public static PageReference navigateToStep5a(){
        
        PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationStep5a'); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }
    
    public static PageReference navigateToStep5b(){
        
        PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationStep5b'); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }
    public static PageReference navigateToStep6(){
        
        PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationStep6'); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }
    public static PageReference navigateToStep7(){
        
        PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationStep7'); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }
    
    public static PageReference navigateToStep8(){
        
        PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationStep8'); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }
    
    public static PageReference navigateToStep9(){
        
        PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationStep9'); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }
    
    public static PageReference navigateToChecklist(){
        
        PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationChecklist'); 
        
        redirect.setRedirect(true);     
        return redirect;
        
    }
    
    public static PageReference naveToSavedPage(){
        
        String nav = 'Intro';
        List<FM_Installation__mdt> installMdt = [SELECT Saved_Page__c,label FROM FM_Installation__mdt LIMIT 500];
        if(installMdt != null && installMdt.size()>0 ){
            if(installMdt[0].Saved_Page__c == '3' || installMdt[0].Saved_Page__c == '4' || installMdt[0].Saved_Page__c == '5' ){
                nav = 'Step'+installMdt[0].Saved_Page__c+'a';
            }else{
                nav = 'Step'+installMdt[0].Saved_Page__c;
            }
        }
        
        PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallation'+nav); 
        
        redirect.setRedirect(true);     
        return redirect;
        //return null;
        
    }
    
    //@future(callout=true)
    Public static void createPicklistValueSetAndUpdateSrp(Set<String> names , String picklistName,String masterLabelName, String sessionId, String oldVal, String newVal)
    {      
        system.debug('names '+names );
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        //service.SessionHeader.sessionId = sessionId;
        //service.SessionHeader.sessionId = '{!$FM_API.OAuthToken}';
        
        
        MetadataService.GlobalValueSet  globalValueSet = new MetadataService.GlobalValueSet ();
        //globalValueSet.masterLabel = 'Rating Names';
        globalValueSet.masterLabel = masterLabelName.Substring(0,masterLabelName.length()-3);
        //globalValueSet.fullName ='FunnelMetrics__Rating_Names';
        
        String s2 = picklistName.Substring(0,picklistName.length()-3);
        s2 = s2.replace('picklist', 'Picklist');
        globalValueSet.fullName = s2;
        system.debug('s2 :: '+s2);
        Boolean del = true;
        List<MetadataService.customValue> mc = new list<MetadataService.customValue>();
        for(String s : names ){
            if(s != ''){ 
                MetadataService.customValue c1 = new MetadataService.CustomValue();
                c1.default_x = false;
                c1.isActive = true;
                c1.fullName = s;
                mc.add(c1);
                del = false;
            }
            
            system.debug('del :: '+del);
        }
        
        if(del){
            system.debug('inside if del');
            MetadataService.customValue c1 = new MetadataService.CustomValue();
            c1.default_x = false;
            c1.isActive = false;
            c1.fullName = 'Del';
            mc.add(c1);
        }
        globalValueSet.customValue = mc;
        if(!test.isRunningTest()){
            List<MetadataService.SaveResult> results = service.updateMetadata(new MetadataService.Metadata[] { globalValueSet });
            system.debug('results '+results );
        }
        
        List<Sales_Rep_Profile__c> updateSrpLevel = new List<Sales_Rep_Profile__c>();
        
        String q = 'Select id from Sales_Rep_Profile__c where '+ picklistName +' = \''+oldVal + '\'';
        updateSrpLevel =  Database.query(q);
        
        if(updateSrpLevel != null && updateSrpLevel.size()>0){
            for(Sales_Rep_Profile__c s : updateSrpLevel){
                s.put(picklistName,newVal);
                
            }
            
            FunnelTriggerBatchHelper.doNotCallSPTrigger = true;
            system.debug(' updateSrpLevel '+updateSrpLevel);
            update updateSrpLevel;  
            FunnelTriggerBatchHelper.doNotCallSPTrigger = false;
        }
        
        List<Sales_Rep_Profile_Snapshot__c > updateSrpLevelSnap = new List<Sales_Rep_Profile_Snapshot__c >();
        
        String qs = 'Select id from Sales_Rep_Profile_Snapshot__c where '+ picklistName +' = \''+oldVal + '\'';
        updateSrpLevelSnap =  Database.query(qs);
        
        if(updateSrpLevelSnap != null && updateSrpLevelSnap .size()>0){
            for(Sales_Rep_Profile_Snapshot__c s : updateSrpLevelSnap){
                s.put(picklistName,newVal);
                
            }
            
            
            //system.debug(' updateSrpLevelSnap'+updateSrpLevelSnap);
            update updateSrpLevelSnap;  
            
        }
    }
    
    @future(callout=true)
    Public static void createPicklistValueSetRole(Set<String> names , String picklistName,String masterLabelName, String newVal)
    {      
        system.debug('names '+names );
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        //service.SessionHeader.sessionId = sessionId;
        //service.SessionHeader.sessionId = '{!$FM_API.OAuthToken}';
        
        MetadataService.GlobalValueSet  globalValueSet = new MetadataService.GlobalValueSet ();
        //globalValueSet.masterLabel = 'Rating Names';
        globalValueSet.masterLabel = masterLabelName;
        //globalValueSet.fullName ='FunnelMetrics__Rating_Names';
        globalValueSet.fullName = picklistName;
        
        Boolean del = true;
        List<MetadataService.customValue> mc = new list<MetadataService.customValue>();
        for(String s : names ){
            if(s != ''){ 
                MetadataService.customValue c1 = new MetadataService.CustomValue();
                c1.default_x = false;
                c1.isActive = true;
                c1.fullName = s;
                mc.add(c1);
                del = false;
            }
        }
        
        if(del){
            
            MetadataService.customValue c1 = new MetadataService.CustomValue();
            c1.default_x = false;
            c1.isActive = false;
            c1.fullName = 'Del';
            mc.add(c1);
        }
        globalValueSet.customValue = mc;
        if(!test.isRunningTest()){
            List<MetadataService.SaveResult> results = service.updateMetadata(new MetadataService.Metadata[] { globalValueSet });
            system.debug('results '+results );
        }
        
        List<Metric_Goals__c> createMg = new List<Metric_Goals__c>();
        List<Certification_Rating__c> cr = [Select id,Name,Default_Goal__c From Certification_Rating__c where Group__c ='Custom Metrics'];
        for(Certification_Rating__c c :cr){
            Metric_Goals__c m = new Metric_Goals__c();
            m.Certification_Rating__c = c.id;
            m.Name= c.Name;
            m.Goal__c = c.Default_Goal__c;
            m.Role__c = newVal;
            createMg.add(m);
        }
        
        if(createMg != null && createMg.size()>0){
            insert createMg;
        }
        
    }
}