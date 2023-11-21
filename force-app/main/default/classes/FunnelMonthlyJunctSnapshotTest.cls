@isTest
public class FunnelMonthlyJunctSnapshotTest {
    
    static testmethod void testFieldsCopyingOver() { 
    
        Id profileId1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
        
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole1' , Name = 'My Role1');
        //insert r1;
        
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.profileId = profileId1;
        fw1.index = 1;
        //fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,100);
        insert userList1;
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_Snapshot_object_access'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );   
        
        System.runAs(userList1[0]){ 
            
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;   
            
            Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole' , Name = 'My Role');
            //insert r;
                            
            FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.profileId = profileId;
            fw.index = 1;
            //fw.userRoleId = r.id;
            
            List<User> userList = FunnelDataFactory.createUser(fw,5);
            insert userList;
            system.debug(userList);
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            insert sp;                
            
            fw = new FunnelDataFactory.FunnelTestWrapper();            
            fw.levelName = 'Test name';
            fw.levelValue = 'Test value';
            List<Company_Level__c> levels = FunnelDataFactory.createCompanyLevel(fw,sp);
            insert levels;
            
            test.startTest();
            FunnelMonthlyLevelJunctionSnapshotBatch c = new FunnelMonthlyLevelJunctionSnapshotBatch(Date.today(),false,false);
            Database.executeBatch(c);
            test.stopTest();
            
            List<Company_Level_Junction_snapshot__c> clList = [SELECT id FROM Company_Level_Junction_snapshot__c];            
            system.assertEquals(clList.size(),5);
        }           
    }
}