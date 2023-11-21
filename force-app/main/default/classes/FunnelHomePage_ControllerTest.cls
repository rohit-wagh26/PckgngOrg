@isTest
public class FunnelHomePage_ControllerTest {
        
     
    static testmethod void testNotificationCreation() {    
        
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
            
            FunnelHomePage_Controller c = new FunnelHomePage_Controller();
            c.navigateToCertification();
            c.navigateToCalculator();
           // c.navigateToHomePage();
            c.navigateToDashboard();
            c.navigateToReportsPage();
            c.navigateToAppSetup();
            c.navigateToCertificateReports();
           // c.navigateToRatings();
          //  c.navigateToAssignRole();
            
           // c.navigateToCategories();
            c.navigateToAnalytics();
        //    c.navigateToFunnelAnalyticQualitative();
          
             PageReference p = c.navigateToAnalytics();
             system.assert(true,p.getUrl().contains('Analytic'));
            
            
            test.stopTest();
        }           
    }
}