@isTest
public class FunnelMonthlySalesProfSnapshotBatchTest {
    
    static testmethod void testFieldsCopyingOver() {            
        
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole' , Name = 'My Role');
        insert r;
        
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.profileId = profileId;
        fw.index = 1;
        fw.userRoleId = r.id;
        
        List<User> userList = FunnelDataFactory.createUser(fw,100);
        insert userList;
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_Snapshot_object_access'];
        insert new PermissionSetAssignment(AssigneeId = userList[0].id, PermissionSetId = ps.Id );
   
        System.runAs (userList[0]) { 
                
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
                           
            
            system.debug(userList);
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            sp[0].Rep_start_date__c = Date.today() - 1;
            insert sp;
            
            system.debug(sp);
            
            test.startTest();
            
            FunnelMonthlySalesProfSnapshotBatch c = new FunnelMonthlySalesProfSnapshotBatch (Date.today(),false,false);
            Database.executeBatch(c);            
            
            test.stopTest();
            
            List<Sales_Rep_Profile_Snapshot__c> caList = [SELECT id FROM Sales_Rep_Profile_Snapshot__c];
            
            system.assertEquals(caList.size(),1);
                        
        }               
    }
}