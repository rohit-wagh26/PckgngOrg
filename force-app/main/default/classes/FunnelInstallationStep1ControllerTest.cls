@isTest
public class FunnelInstallationStep1ControllerTest {
        
     
    static testmethod void testcreateAppSetting() {    
        
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
            
            FunnelInstallationStep1Controller c = new FunnelInstallationStep1Controller();
            c.selectedMonth = '7';  
            c.leadUsed = true;
            c.meetingUsed = true;
            c.meetingvalue = '5';
            c.qualifiedPercentage = 10;
            c.historicPercentage = 15;
            c.stretchPercentage = 20;                    
            c.save();
            
            List<Application_Setting__c> asList = [SELECT id FROM Application_Setting__c];
            
            system.assert(true, asList != null && asList.size() > 0);
                        
            test.stopTest();
        }           
    }
    
    static testmethod void testcreateAppSettinginsert() {    
        
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
           // insert fiscalYr;   
            
             Application_Setting__c a = new Application_Setting__c(Name='App',Leads_used__c = true,Probability__c = 10,Implementation_Date__c = Date.newInstance(System.Today().year(), 1, 1));
             insert a;
             
            test.startTest();
            
            FunnelInstallationStep1Controller c = new FunnelInstallationStep1Controller();
            c.getMonths();
            c.selectedMonth = '7';  
            c.FiscalYearDate =  Date.newInstance(System.Today().year(), 1, 1);              
            c.save();
            c.navigateToIntro();
            c.navigateToStep2();
            c.FiscalYearDate = system.today();
            c.fsdate.Implementation_Date__c = system.today();
            c.ChangeDate();
            c.saveAndExit();
            
            List<Application_Setting__c> asList = [SELECT id FROM Application_Setting__c];
            
            system.assert(true, asList != null && asList.size() > 0);
                        
            test.stopTest();
        }           
    }
}