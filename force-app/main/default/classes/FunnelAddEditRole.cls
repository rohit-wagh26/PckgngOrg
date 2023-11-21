public with sharing class FunnelAddEditRole {
    
    public Set<String> roleList{get;set;}
    public String rname{get;set;}
    
    //Variables to store the parameters passed in the URL
    public String label1{get; set;}
    public String label2{get; set;}
    public String label3{get; set;}
    public String selectedLevel1{get; set;}
    public String selectedLevel2{get; set;}
    public String selectedLevel3{get; set;}
    
    public Boolean adminPer{get;set;}
    public Boolean isManger{get;set;}
    
    
    
    
    public FunnelAddEditRole (){
       
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
        
        populateRole(); 
         rname ='';                             
    }
    
    
       
     
     
    public void populateRole(){
          
         roleList = new Set<String>();
        
        DescribeSObjectResult objResult = Schema.getGlobalDescribe()
                                            .get('FunnelMetrics__Sales_Rep_Profile__c').getDescribe();
        // Get the field dynamically
        DescribeFieldResult fieldResult = objResult.fields.getMap()
                                          .get('FunnelMetrics__Role__c').getDescribe();
        
        for (Schema.Picklistentry picklistEntry : fieldResult.getPicklistValues()){ 
                 roleList.add(pickListEntry.getLabel() );
        }  
        
        List<CreatePicklistValue__c> CreatePickValues = [Select id, Name ,Value__c,PicklistValueSet__c, PicklistValueSet__r.Name from CreatePicklistValue__c where PicklistValueSet__r.Name = 'role'];
        if(CreatePickValues != null && CreatePickValues.size()>0){
            for(CreatePicklistValue__c c : CreatePickValues){
                roleList.add(c.Value__c);
            }
        }
     
     List<PicklistValueSet__c> picklistValues = [Select id, Name ,Values__c,Level_Name__c from PicklistValueSet__c where Name = 'role'];
            
            if(picklistValues != null && picklistValues.size()>0){
                List<String> listr= picklistValues[0].Values__c.split(';');
                for(String s : listr){
                     roleList.add(s.trim());
                }
               
            }
    }
    
    public void saverole(){
        if(rname != null && rname != ''){
            roleList.add(rname);
            //FunnelInstallationHelper.createPicklistValueSetRole(roleList,'FunnelMetrics__Roles','Roles',UserInfo.getSessionId());
            
            List<PicklistValueSet__c> picklistValues = [Select id, Name ,Values__c,Level_Name__c from PicklistValueSet__c where Name = 'role'];
            CreatePicklistValue__c roleValue = new CreatePicklistValue__c();
            roleValue.Value__c = rname;
            roleValue.PicklistValueSet__c = picklistValues[0].id;
            insert roleValue;
            if(picklistValues != null && picklistValues.size()>0){
                 if(picklistValues[0].Values__c != null && !picklistValues[0].Values__c.endsWith(';')){
                        picklistValues[0].Values__c +=';';
                    }
                    
                    picklistValues[0].Values__c += rname ;
                    update picklistValues;
                
            }
        }
        rname ='';
         
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
    
    public PageReference navigateToFunnelAddEditCompanyLevel(){
        
        return FunnelNavigationHelper.navigateToFunnelAddEditCompanyLevel(label1,label2,label3,selectedLevel1,selectedLevel2,selectedLevel3);
    
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