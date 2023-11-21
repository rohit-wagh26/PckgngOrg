@isTest

public class FunnelAddEditCompanyLevelTest{
    
    static testmethod void testUpdation(){
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
         
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        
        List<User> us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u = us[0];
         
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_App_Setup'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id );
        
        List<User> userListcomp = FunnelDataFactory.createUser(fw,10);
        insert userListcomp;
           
        system.runAs(u){
            
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            List<PicklistValueSet__c> pl= new List<PicklistValueSet__c>{
                new PicklistValueSet__c(Name ='role',Level_Name__c='Role',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist1',Level_Name__c='picklist1',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist2',Level_Name__c='picklist2',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist3',Level_Name__c='picklist3',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist4',Level_Name__c='picklist4',Values__c = 'test'),
                new PicklistValueSet__c(Name ='picklist5',Level_Name__c='picklist5',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist6',Level_Name__c='picklist6',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist7',Level_Name__c='picklist7',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist8',Level_Name__c='picklist8',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist9',Level_Name__c='picklist9',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist10',Level_Name__c='picklist10',Values__c = 'Test')
                };
                
            insert pl;
            
            List<CreatePicklistValue__c> cl = new List<CreatePicklistValue__c>{
                new CreatePicklistValue__c(PicklistValueSet__c =pl[1].id,Added__c=false,Value__c = 'Test'),
                new CreatePicklistValue__c(PicklistValueSet__c =pl[2].id,Added__c=false,Value__c = 'Test'),
                new CreatePicklistValue__c(PicklistValueSet__c =pl[3].id,Added__c=false,Value__c = 'Test'),
                new CreatePicklistValue__c(PicklistValueSet__c =pl[4].id,Added__c=false,Value__c = 'Test'),
                new CreatePicklistValue__c(PicklistValueSet__c =pl[5].id,Added__c=false,Value__c = 'Test'),
                new CreatePicklistValue__c(PicklistValueSet__c =pl[6].id,Added__c=false,Value__c = 'Test'),
                new CreatePicklistValue__c(PicklistValueSet__c =pl[7].id,Added__c=false,Value__c = 'Test'),
                new CreatePicklistValue__c(PicklistValueSet__c =pl[8].id,Added__c=false,Value__c = 'Test'),
                new CreatePicklistValue__c(PicklistValueSet__c =pl[9].id,Added__c=false,Value__c = 'Test'),
                new CreatePicklistValue__c(PicklistValueSet__c =pl[10].id,Added__c=false,Value__c = 'Test')
            };
            
            PicklistValueSet__c pVal = new PicklistValueSet__c();
            pVal.Name = 'picklist4';
            pVal.Level_Name__c = 'Company';
            pVal.Values__c = 'test;';
            Insert pVal;
            
            CreatePicklistValue__c createPick = new CreatePicklistValue__c();
            createPick.Value__c = 'test';
            createPick.Added__c = false;
            createPick.PicklistValueSet__c = pVal.id;
            insert createPick;
            
            CreatePicklistValue__c createPick1 = new CreatePicklistValue__c();
            createPick1.Value__c = 'test1';
            createPick1.FunnelMetrics__Added__c = false;
            createPick1.PicklistValueSet__c = pVal.id;
            insert createPick1;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = userListcomp[0].id;
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            spProf.Quarterly_Opportunities_added_to_Qualifi__c = 5;
            spProf.Quarterly_Lead_Added__c = 5;
            spProf.Quarterly_Quota_Revenue__c = 500;
            spProf.Month_1_Quota_Amount__c= 500;
            spProf.YTD_Revenue__c = 500;
            spProf.X12_Month_Rolling_Opportunity_Close_Rate__c = 50;
            spProf.User_record_name__c = userListcomp[0].id;
            insert spProf; 
           
            FunnelAddEditCompanyLevel ftj = new FunnelAddEditCompanyLevel();
            Test.startTest();
            
            ftj.displayEditCmp();
            ftj.updaeSlist();
            BatchToUpdateGlobalPicklistValue m = new BatchToUpdateGlobalPicklistValue();  
            database.executebatch(m);
            Test.stopTest(); 
            Company_Level__c c = new Company_Level__c();
            c.Level_Value__c='test';
            c.Order__c=4;
            insert c;
             
            ftj.compId = c.id;
            ftj.displayEditCmp();
            ftj.save();
            ftj.newVal ='test';
            ftj.oldVal='test1';
           	//ftj.cmpSelected.Picklist_Name__c = 'FunnelMetrics__Level_picklist_4__c';
           
            ftj.SaveCmp();
            ftj.assignVal();
            ftj.delid = c.id;
            ftj.delCmp();
            //ftj.save();             
            system.assertEquals(ftj.adminPer,true);                   
       }       
      
    }
    
    static testmethod void testNavigation(){
    
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
         
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        
        List<User> us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u = us[0];
         
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_App_Setup'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id );
        
        List<User> userListcomp = FunnelDataFactory.createUser(fw,10);
        insert userListcomp;

        system.runAs(u){
            
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            FunnelAddEditCompanyLevel ftj = new FunnelAddEditCompanyLevel();
            Test.startTest();
            ftj.navigateToFunnelSetup();
            ftj.navigateToFunnelAnalyticQualitative();
            ftj.navigateToFunnelAnalytic();
            ftj.navigateToAnnualizationDashboard();
            ftj.navigateToReportsPage();
            ftj.navigateToCertificateReports();
            ftj.navigateToDashboard();
            ftj.navigateToCertification();
            ftj.navigateToHomePage();
            ftj.navigateToFunnelAddEditRole();
            ftj.navigateToFunnelAddEditSRP();
            ftj.navigateToCustomMetric();
            ftj.navigateToFunnelManagerUpdate();
            ftj.navigateToFunnelReviewGoals();
            ftj.navigateToCalculator();
            ftj.navigateToAppSetup();
            ftj.navigateToAssignRole();
            ftj.navigateToRatings();
            ftj.navigateToAnalytics();
            ftj.navigateToNotifications();
            ftj.navigateToFunnelEvaluationGuidelines();
            ftj.navigateToGoals();
            ftj.navigateToSalesPipeline();
            ftj.navigateToTrendingByRep();
            ftj.navigateToTrendingBySkill();
            ftj.navigateToHelpMenu();
            
            system.assertEquals(ftj.adminPer,true); 
            Test.stopTest(); 
            
       }              
      
    }
    
}