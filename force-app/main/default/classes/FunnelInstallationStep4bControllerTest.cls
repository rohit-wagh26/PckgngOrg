@isTest
public class FunnelInstallationStep4bControllerTest {
        
     
    static testmethod void test4b() {    
        
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
            
            
            FunnelInstallationStep4bController c = new FunnelInstallationStep4bController ();                   
            c.checkratings(); 
            c.navigateToStep4a();
            c.saveAndExit();
             PageReference p = c.navigateToStep5();
            system.assert(true,p.getUrl().contains('FunnelInstallationStep5a'));               
            test.stopTest();
        }           
    }
}