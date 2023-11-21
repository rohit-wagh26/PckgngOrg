@isTest
public class FunnelEvaluationGuidelinesControllerTest {
        
     
    static testmethod void testFunnelEvaluationGuidelinesControllerNav() {    
        
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
            
            FunnelEvaluationGuidelinesController c = new FunnelEvaluationGuidelinesController();
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
            
            PageReference p = c.navigateToFunnelAnalytic();
            system.assert(true,p.getUrl().contains('FunnelAnalytic'));
            c.navigateToCustomMetric();
           // c.navigateToFunnelEvaluationGuidelines();
            c.navigateToAnnualizationDashboard();
            
            c.navigateToFunnelSetup();
            c.navigateToNotifications();
            c.navigateToFunnelReviewGoals();
            c.navigateToFunnelManagerUpdate();
            
            
            test.stopTest();
        }           
    }
    
    static testmethod void testFunnelEvaluationGuidelinesController() {    
        
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
            
            insert new EvaluationGuidelines__c (Name='Outstanding' , Description__c= 'Outstanding' ,order__c = 1);
            insert new EvaluationGuidelines__c (Name='Outstanding' , Description__c= 'Outstanding' ,order__c = 2);
            insert new EvaluationGuidelines__c (Name='Outstanding' , Description__c= 'Outstanding' ,order__c = 3);
            insert new EvaluationGuidelines__c (Name='Outstanding' , Description__c= 'Outstanding' ,order__c = 4);
            insert new EvaluationGuidelines__c (Name='Outstanding' , Description__c= 'Outstanding' ,order__c = 5);
            
            test.startTest();
            
            FunnelEvaluationGuidelinesController c = new FunnelEvaluationGuidelinesController();
            c.evalName ='Outstanding';
            c.onEdit();
            c.save();
            
            c.evalName ='Strong';
            c.onEdit();
            c.save();
            
            c.evalName ='Average';
            c.onEdit();
            c.save();
            
            c.evalName ='Marginal';
            c.onEdit();
            c.save();
            
            c.evalName ='NeedsImprovement';
            c.onEdit();
            c.save();
            
            List<EvaluationGuidelines__c> e =[Select id from EvaluationGuidelines__c];
             system.assertEquals(5,e.size());
            test.stopTest();
        }           
    }
}