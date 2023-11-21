@isTest
public class FunnelSRPCreateControllerTest {
        
     
    static testmethod void test5() {    
        
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
            
            FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
              fw.index = 1;   
              fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;          
             
              UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
              insert r;
              
              fw.userRoleId = r.id;
               
              List<User> userList = FunnelDataFactory.createUser(fw,1);
              insert userList;
              
             List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
             insert sp;
            
            test.startTest();
            
            
            FunnelSRPCreateController c = new FunnelSRPCreateController(); 
            c.usrLst[0].selectBox = true;
            //c.oriUsrLst[0].selectBox = false;
            c.save();
            c.hideAddEditPlaceholder();
            c.displayAddEditPlaceholder();
            c.srpPlaceholderEdit.name = 'Test placeholder';
            c.savePlaceholder(); 
            
            c.saveAndExit();
            c.search();
            c.navigateToStep4b();
            c.deletePlaceholder();
            c.licenseAvailable = true;
            c.strKey = '';
            c.placeholderName = '';
            
            PageReference p = c.navigateToStep5b();
            system.assert(true,p.getUrl().contains('FunnelInstallationStep5'));
                      
            test.stopTest();
            
            
        }           
    }
    
     
}