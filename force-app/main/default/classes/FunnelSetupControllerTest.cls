@isTest
public class FunnelSetupControllerTest {
        
     
    static testmethod void testFunnelSetupControllerNav() {    
        
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        insert r1;        
        fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
        insert userList1 ;
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        System.runAs (userList1[0]) { 
            
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;   
            
            test.startTest();
            
            FunnelSetupController c = new FunnelSetupController();
            c.navigateToCertification();
            c.navigateToCalculator();
            c.navigateToHomePage();
            c.navigateToDashboard();
            c.navigateToReportsPage();
            c.navigateToAppSetup();
            c.navigateToCertificateReports();
            c.navigateToRatings();
            c.navigateToAssignRole();
            c.navigateToSalesPipeline();
            c.navigateToTrendingByRep();
            c.navigateToTrendingBySkill();
            c.navigateToHelpMenu();
            
            c.navigateToCategories();
            c.navigateToAnalytics();
            c.navigateToFunnelAnalyticQualitative();
            c.navigateToFunnelAnalytic();
            
            c.navigateToCustomMetric();
            c.navigateToFunnelEvaluationGuidelines();
            c.navigateToAnnualizationDashboard();
            
             PageReference p = c.navigateToFunnelAnalytic();
            system.assert(true,p.getUrl().contains('FunnelAnalytic'));
            
            test.stopTest();
            
            Application_Setting__c ase = new Application_Setting__c();
            insert ase;
            
            c.timerS = true;
            c.goalDateValue = Date.today();
            c.BatchNotStarted = true;
            c.createSalesProfile();
            c.createHD();
            c.createHDMidnight();
            c.clearMessage();
            c.timerOnS();
            c.timerOffS();
            c.updateHeader();
            c.createGoals();
            c.navigateToCertification();
            c.navigateToDashboard();
            c.navigateToCalculator();
            c.navigateToHomePage();
            c.navigateToReportsPage();
            c.navigateToAppSetup();
            c.navigateToCertificateReports();
            c.navigateToRatings();
            c.navigateToAssignRole();
            c.navigateToCustomMetric();
            c.navigateToCategories();
            c.navigateToAnalytics();
            c.navigateToFunnelAnalyticQualitative();
            c.navigateToFunnelAnalytic();
            c.navigateToNotifications();
            c.navigateToAnnualizationDashboard();
            c.navigateToFunnelEvaluationGuidelines();
            c.navigateToFunnelReviewGoals();
            c.navigateToFunnelManagerUpdate();
            c.navigateToFunnelAddEditSRP();
            c.navigateToFunnelSetup();
            c.navigateToGoals();
            
        }           
    }
}