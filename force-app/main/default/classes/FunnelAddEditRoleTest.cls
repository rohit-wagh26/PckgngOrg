@isTest

public class FunnelAddEditRoleTest{
    
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
            
            PicklistValueSet__c pv = new PicklistValueSet__c();
            pv.Name = 'role';
            pv.Values__c = 'test role1;';
            insert pv;
            
            CreatePicklistValue__c roleValue = new CreatePicklistValue__c();
            roleValue.Value__c = 'test role1';
            roleValue.PicklistValueSet__c = pv.id;
            insert roleValue;
            
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
           
            FunnelAddEditRole ftj = new FunnelAddEditRole();
            Test.startTest();
            ftj.rname = 'Test'; 
            ftj.saverole();
             system.assertEquals(ftj.adminPer,true); 
            Test.stopTest();           
                              
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
            
            FunnelAddEditRole ftj = new FunnelAddEditRole();
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
            ftj.navigateToFunnelAddEditCompanyLevel();
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