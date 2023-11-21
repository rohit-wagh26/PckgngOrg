@isTest

public class FunnelCustomMetricHelperTest{

    static testmethod void testhelper(){
    
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;        
        
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        //insert r1;
        
        //fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);               
        
        insert userList1;
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
            
        System.runAs ( userList1[0] ) {
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;   
                                    
            FunnelCustomMetricHelperTest c = new FunnelCustomMetricHelperTest();
            FunnelCustomMetricHelper.triggerDate = system.today(); 
            FunnelCustomMetricHelper.createtimeString('createddate','Current Fiscal year',false);
            FunnelCustomMetricHelper.createtimeString('createddate','Current Quarter',false);
            FunnelCustomMetricHelper.createtimeString('createddate','12 Month Rolling',false);
            string d = FunnelCustomMetricHelper.createtimeString('createddate','Current Month',false);
            system.assertnotequals(d,null);
            
             
        }        
    } 
    
      
}