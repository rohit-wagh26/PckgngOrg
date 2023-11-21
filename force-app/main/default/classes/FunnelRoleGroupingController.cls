/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelRoleGroupingController{

    public FunnelRoleGroupingController(FunnelAddEditRole controller) {
        defaultConstructor();
    }


    public FunnelRoleGroupingController(FunnelInstallationStep3bController controller) {
        defaultConstructor();
    }


    public List<Role_Grouping__c> roleGroups{get;set;}
    public Role_Grouping__c groupSelected{get; set;}
    public Role_Grouping__c copyGroupSelected{get; set;}
    public Id groupId{get; set;}
    public String SelectedValue {get;set;}
    public List<string> selectedValueList{get;set;}
    public id deleteId{get;set;}
    //Variables to store the parameters passed in the URL
    public String label1{get; set;}
    public String label2{get; set;}
    public String label3{get; set;}
    public String selectedLevel1{get; set;}
    public String selectedLevel2{get; set;}
    public String selectedLevel3{get; set;}
    
    public Boolean adminPer{get;set;}
    public Boolean isManger{get;set;}
    
    public string dfRole{get;set;}
    public  List<SelectOption> dfRoleoptions{get;set;}
    /* Filters */
    
    public static String prefix{ get{return 'FunnelMetrics__';} set; }

    public FunnelRoleGroupingController(){
        defaultConstructor();
    }
    
    public void defaultConstructor(){
        try{
        
           
            selectedValueList = new List<String>(); 
            
            System.debug('Start');
            List<String> fldList = new List<String>{prefix+'Name', prefix+'Description__c'};
                
            Boolean readAccess = true;
            
            Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(prefix+'EvaluationGuidelines__c').getDescribe().fields.getMap();
            
            for(String fldName: fldList){
                if(!fieldMap.get(fldName).getDescribe().isAccessible()){
                    readAccess = false;
                }                           
            }
            if(true){ 
                roleGroups = [select name,Roles__c,Group_Name__c from Role_Grouping__c order by createddate asc Limit 5000];
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
         
     
            } 
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number: '+ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelRoleGroupingController'+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
    
    
    }
     
    public void dfRoles(){
        dfRoleoptions  = new List<SelectOption>(); 
           
          system.debug('SelectedValue'+SelectedValue);
          SelectedValue = SelectedValue.remove('[');
          SelectedValue  =SelectedValue .remove(']');
          List<String> newRoles = new List<String>();
          List<String> roles = SelectedValue.split(', ');
          system.debug('roles '+roles );
          
           Schema.DescribeFieldResult statusFieldDescription = Certification_Rating__c.Roles_enabled__c.getDescribe();
           dfRoleoptions.add(new SelectOption('','None'));
           for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues())
           {
               if(roles .contains(pickListEntry.getValue())){
                   dfRoleoptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                }
           }
           
    }
     
     public List<SelectOption>  getRole() {
           List<SelectOption> Options = new List<SelectOption>(); 
           
           Set<string> rolesInOtherGroup = new set<string>();
           
           for(Role_Grouping__c r: [select name,Roles__c,Group_Name__c from Role_Grouping__c Limit 5000]){
           
               List<String> rolesList = r.Roles__c.split(';');
               for(String s : rolesList ){
                   rolesInOtherGroup.add(s);
               }
           }
           
           
           Schema.DescribeFieldResult statusFieldDescription = Certification_Rating__c.Roles_enabled__c.getDescribe();
           
           for (Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues())
           {
               if( rolesInOtherGroup == null || !rolesInOtherGroup.contains(pickListEntry.getValue()) || selectedValueList.contains(pickListEntry.getValue())){
                   Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
               }
           }
           
            
           
           return Options ;
    }
     public void displayAddEditRoleGroup(){
           system.debug(' groupId'+groupId);
            dfRole =''; 
           selectedValueList = new List<String>(); 
            if(groupId != null){ 
                    groupSelected= [select name,Roles__c,Group_Name__c from Role_Grouping__c WHERE id = :groupId];
                    SelectedValue = groupSelected.Roles__c;
                    selectedValueList = SelectedValue.split(';');
                    copyGroupSelected = [select name,Roles__c,Group_Name__c from Role_Grouping__c WHERE id = :groupId];
                    System.debug('copyGroupSelected --'+copyGroupSelected );
                }
           else{
                groupSelected= new Role_Grouping__c ();
               
        }
        getRole();
    }
    
    public void hideAddEditGroup(){
        groupId = null; 
        copyGroupSelected  = new Role_Grouping__c();
        groupSelected= new Role_Grouping__c ();
        selectedValueList = new List<String>();  
    }
    
    public void deleteGroup(){
        system.debug('deleteId'+deleteId);
        Delete[Select id from Role_Grouping__c  where id =:deleteId];
        roleGroups = [select name,Roles__c,Group_Name__c from Role_Grouping__c order by createddate asc Limit 5000];
        updateGroupUpdate();
    }
    
    public void updateGroupUpdate(){
        List<Application_Setting__c> appSet = [Select id,Role_Group_updated__c from Application_Setting__c Limit 1];   
        if(appSet != null && appSet.size()>0){
            appSet[0].Role_Group_updated__c = true;
            update appSet;
        }
    
    }
    
    public void save(){
        try{    
          system.debug('SelectedValue'+SelectedValue);
          SelectedValue = SelectedValue.remove('[');
          SelectedValue  =SelectedValue .remove(']');
          List<String> newRoles = new List<String>();
          List<String> roles = SelectedValue.split(', ');
          system.debug('roles'+roles);
              String  r = '';
               
              for(String s : roles){
                  if(r == ''){
                    r = s;
                }else{
                    r += ';'+s;
                }
              }
             
              system.debug('r'+r);
              groupSelected.Roles__c = r;
              upsert groupSelected;
              
             
              
          if(groupId != null && copyGroupSelected  != null ){
              List<String> oldRoles = copyGroupSelected.Roles__c.split(';');
              system.debug('oldRoles '+oldRoles ); 
              for(String s : roles ){
                  if(!oldRoles.contains(s)){
                      newRoles.add(s);
                  }
              }
              
              if(oldRoles.size() != newRoles.size()){
                  updateGroupUpdate();
              }
              
              if(newRoles != null && newRoles.size()>0){
                  String deleteRole ='';
                  for(String s : newRoles){
                      if(deleteRole  == ''){
                            deleteRole  = s;
                        }else{
                            deleteRole  += ';'+s;
                        }
                  }
             
                    
                   system.debug('deleteRole '+deleteRole );  
                  
                    Set<id> deleteCert = new Set<id>();
                    
                     
                    list<string> rlsd = new List<string>();
                    for(string s: newRoles){
                        rlsd.add(String.escapeSingleQuotes(s));
                    }
                    String value = '(\'' + String.join(rlsd, '\',\'') + '\')';
                    String queryString = 'SELECT Id,Roles_enabled__c FROM Certification_Rating__c WHERE Assessment_type__c = \'Qualitative\' AND Roles_enabled__c INCLUDES ' + value;
                    List<Certification_Rating__c> delList= DataBase.query(queryString);
                    system.debug('delList'+delList); 
                    
                    for(Certification_Rating__c  cr: delList){
                        deleteCert.add(cr.id);
                        for(String s : newRoles){
             
                            System.debug('s---'+s);
                            if(cr.Roles_enabled__c != null && checkcontain(cr.Roles_enabled__c,s))
                                cr.Roles_enabled__c  = cr.Roles_enabled__c.replaceAll(';?'+s+'?','');     
                        }
                    }
                    
                    if(deleteCert != null && deleteCert.size()>0){
                          FunnelCreateCertAnswers_Controller.deleteAndCreateCertAnswersAppSetup(deleteCert,false,true,deleteRole);
                      }
                    update delList;
                      
                    Set<id> createCert = new Set<id>();
                    
                    list<string> rlsc = new List<string>();
                    for(string s: oldRoles){
                        rlsc.add(String.escapeSingleQuotes(s));
                    }
                    String oldvalue = '(\'' + String.join(rlsc, '\',\'') + '\')';
              
                    system.debug('oldvalue'+oldvalue);
                    String oldqueryString = 'SELECT Id,Roles_enabled__c  FROM Certification_Rating__c WHERE Deactivated__c = false AND Assessment_type__c = \'Qualitative\' AND Roles_enabled__c INCLUDES ' + oldvalue;
                    system.debug('oldqueryString '+oldqueryString ); 
                    List<Certification_Rating__c> creList= DataBase.query(oldqueryString);
                    for(Certification_Rating__c  cr: creList){
                        createCert.add(cr.id);
                        for(String s : newRoles){
                            
                            System.debug('s---'+s);
                            if(cr.Roles_enabled__c != null){
                                if(!checkcontain(cr.Roles_enabled__c,s)){
                                    cr.Roles_enabled__c  = cr.Roles_enabled__c+';'+s; 
                                }   
                            }else{
                                cr.Roles_enabled__c  = s;
                            } 
                          }
                        
                    }
                    update creList;
                    if(createCert != null && createCert.size()>0){
                        FunnelCreateCertAnswers_Controller.deleteAndCreateCertAnswersAppSetup(createCert,true,false,deleteRole);
                    }
                    updateGroupUpdate();
                    
              }
              
          }else{
                system.debug('NEW Group delete');
                String deleteRole ='';
                system.debug('dfRole'+dfRole  );
                  for(String s : roles ){
                      if(s != dfRole){
                          if(deleteRole  == ''){
                                deleteRole  = s;
                            }else{
                                deleteRole  += ';'+s;
                            }
                        }
                  }
                system.debug('deleteRole  '+deleteRole  );
          
                 
                Set<id> deleteCert = new Set<id>();
                list<string> rls = new List<string>();
                for(string s:roles){
                    if(s != dfRole)
                    rls.add(String.escapeSingleQuotes(s));
                }
                String value = '(\'' + String.join(rls, '\',\'') + '\')';
        
                String queryString = 'SELECT Id,Roles_enabled__c FROM Certification_Rating__c WHERE Assessment_type__c = \'Qualitative\' AND Roles_enabled__c INCLUDES ' + value;
                
                system.debug('queryString '+queryString );
                
                List<Certification_Rating__c> delList= DataBase.query(queryString);
                
                system.debug('delList'+delList);
                
                for(Certification_Rating__c  cr: delList){
                    deleteCert.add(cr.id);
                    for(String s : roles ){
                         if(s != dfRole){
                            System.debug('s---'+s);
                            if(cr.Roles_enabled__c != null && checkcontain(cr.Roles_enabled__c,s))
                                cr.Roles_enabled__c  = cr.Roles_enabled__c.replaceAll(';?'+s+'?','');  
                            }   
                    }
                }
                system.debug('delList updat'+delList);
               FunnelCreateCertAnswers_Controller.deleteAndCreateCertAnswersAppSetup(deleteCert,false,true,deleteRole);
               
               updateGroupUpdate();
               update delList;
               
               if(dfRole !='' && dfRole != null){
                   Set<id> createCert = new Set<id>();
                    
                    list<string> rlsc = new List<string>();
                    rlsc.add(String.escapeSingleQuotes(dfRole));
                     
                    String oldvalue = '(\'' + String.join(rlsc, '\',\'') + '\')';
              
                    system.debug('oldvalue'+oldvalue);
                    String oldqueryString = 'SELECT Id,Roles_enabled__c  FROM Certification_Rating__c WHERE Deactivated__c = false AND Assessment_type__c = \'Qualitative\' AND Roles_enabled__c INCLUDES ' + oldvalue;
                    system.debug('oldqueryString '+oldqueryString ); 
                    List<Certification_Rating__c> creList= DataBase.query(oldqueryString);
                    for(Certification_Rating__c  cr: creList){
                        createCert.add(cr.id);
                        for(String s : roles ){
                            
                            System.debug('s---'+s);
                            if(cr.Roles_enabled__c != null){
                                if(!checkcontain(cr.Roles_enabled__c,s)){
                                    cr.Roles_enabled__c  = cr.Roles_enabled__c+';'+s; 
                                }   
                            }else{
                                cr.Roles_enabled__c  = s;
                            } 
                          }
                        
                    }
                    update creList;
                    if(createCert != null && createCert.size()>0){
                        FunnelCreateCertAnswers_Controller.deleteAndCreateCertAnswersAppSetup(createCert,true,false,deleteRole);
                    }
                }
          } 
           roleGroups = [select name,Roles__c,Group_Name__c from Role_Grouping__c order by createddate asc Limit 5000];
               
        }
        catch(Exception ex){
            System.debug('Exception occured: '+ ex+' Line number  FunnelRoleGroupingController: '+ex.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            FunnelTriggerBatchHelper.sendErrorMail(' FunnelRoleGroupingController '+ex.getMessage()+' '+ex.getStackTraceString()+ ' line number: '+ex.getLineNumber()+' cause '+ex.getCause());
        } 
        //if(Schema.sObjectType.Notification_Setting__c.isCreateable() && Schema.sObjectType.Notification_Setting__c.isUpdateable()){ 
        //if(Schema.getGlobalDescribe().get('Notification_Setting__c').getDescribe().isCreateable()){
            
        //}
    }
    public boolean checkcontain(string ro, string cp){
        list<string> str = new list<string>();
        boolean f ;
        system.debug('ro---'+ro);
        if(ro != null){
           str =  ro.split(';');
            if(str.contains(cp)){
                f = true;
            }else{
                f= false;
            } 
        }else{
                f= false;
        }
        
        return f;
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
    
    public PageReference navigateToRatings(){
        
        return FunnelNavigationHelper.navigateToCreateEditRatings(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
        
    }
    
    public PageReference navigateToAssignRole(){
        
        return FunnelNavigationHelper.navigateToAssignRole(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);    
        
    }
    public PageReference navigateToCustomMetric(){
        
        return FunnelNavigationHelper.navigateToCustomMetric(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);    
        
    }
    
    public PageReference navigateToCategories(){
        
        return FunnelNavigationHelper.navigateToCategories(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    }
    
    public PageReference navigateToAnalytics(){
        
        return FunnelNavigationHelper.navigateToAnalytics(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    
    public PageReference navigateToFunnelAnalyticQualitative(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToFunnelAnalyticQualitative(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    
    public PageReference navigateToFunnelAnalytic(){
        
        //return FunnelNavigationHelper.navigateToFunnelAnalytic(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    	return FunnelNavigationHelper.navigateToFunnelAnalytic(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3,'');
    }
    public PageReference navigateToNotifications(){
        
        return FunnelNavigationHelper.navigateToNotifications(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
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
    public PageReference navigateToFunnelEvaluationGuidelines(){
        
        return FunnelNavigationHelper.navigateToFunnelEvaluationGuidelines(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    public PageReference navigateToGoals(){
        
        return FunnelNavigationHelper.navigateToGoalsPage(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
    }
    /*Navigation*/

}