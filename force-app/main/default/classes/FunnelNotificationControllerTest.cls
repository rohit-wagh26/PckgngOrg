@isTest
public class FunnelNotificationControllerTest {
        
    static testmethod void testNotificationUpdation() {    
        
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
            
            Notification_Setting__c insertnoti = new Notification_Setting__c();
            insertnoti.name ='Notification';
            insertnoti.Enable_Notifications__c = false;
            insertnoti.Advance_Reminders__c = '7 days prior';
            insertnoti.Notification_Frequency__c = 'Daily';
            insertnoti.Escalation__c= '5 days prior';   
            insert insertnoti;
                                 
            test.startTest();
            FunnelNotificationController c = new FunnelNotificationController();
            c.insertnoti.Advance_Reminders__c = '3 days prior';
            c.save();
            
            Notification_Setting__c n = [SELECT Advance_Reminders__c FROM Notification_Setting__c WHERE id = :c.insertnoti.id];
            system.assertEquals(n.Advance_Reminders__c,'3 days prior');
            test.stopTest();
        }           
    }
    
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
            FunnelNotificationController c = new FunnelNotificationController();
            c.edvanceReminders = '7 days prior';
            c.enableNotifications = false;
            c.notificationFrequency = 'Daily';
            c.escalation = '10 days overdue';
            c.save();
            
            List<Notification_Setting__c> n = [SELECT id FROM Notification_Setting__c];
            system.assertEquals(n.size(),1);
            
            c.navigateToCertification();
            c.navigateToCalculator();
            c.navigateToHomePage();
            c.navigateToDashboard();
            c.navigateToReportsPage();
            c.navigateToAppSetup();
            c.navigateToCertificateReports();
            c.navigateToRatings();
            c.navigateToAssignRole();
            
            c.navigateToCategories();
            c.navigateToAnalytics();
            c.navigateToFunnelAnalyticQualitative();
            c.navigateToFunnelAnalytic();
            
            c.navigateToCustomMetric();
            c.navigateToFunnelEvaluationGuidelines();
            c.navigateToAnnualizationDashboard();
            c.navigateToFunnelSetup();
            
            c.navigateToFunnelManagerUpdate();
            c.navigateToFunnelReviewGoals();
            
            test.stopTest();
        }           
    }
}