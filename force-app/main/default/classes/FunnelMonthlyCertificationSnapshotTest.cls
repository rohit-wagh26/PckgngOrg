@isTest
public class FunnelMonthlyCertificationSnapshotTest {
    
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
            
            List<User> userList = FunnelDataFactory.createUser(fw,10);
            insert userList;
            system.debug(userList);
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            sp[0].Rep_start_date__c = Date.today() - 1;

            insert sp;                
            
            fw = new FunnelDataFactory.FunnelTestWrapper();            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,sp);
            insert certs;
            
            test.startTest();
            FunnelMonthlyCertificationSnapshotBatch c = new FunnelMonthlyCertificationSnapshotBatch(Date.today(),false,false);
            Database.executeBatch(c);
            test.stopTest();
            
            List<Certification_Snapshot__c> certList = [SELECT id FROM Certification_Snapshot__c];
            
            system.assertEquals(certList.size(),1);
        }           
    }
}