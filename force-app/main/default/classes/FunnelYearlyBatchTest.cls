@isTest
public class FunnelYearlyBatchTest {
    
    static testmethod void testYearlyFieldsNullification() {    
                
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole' , Name = 'My Role');
        insert r;
                        
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.profileId = profileId;
        fw.index = 1;
        fw.userRoleId = r.id;
        
        List<User> userList = FunnelDataFactory.createUser(fw,1);
        insert userList;
        system.debug(userList);
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_Snapshot_object_access'];
        insert new PermissionSetAssignment(AssigneeId = userList[0].id, PermissionSetId = ps.Id );                
        
        ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_Sales_Profile_Company_Level_access'];
        insert new PermissionSetAssignment(AssigneeId = userList[0].id, PermissionSetId = ps.Id );
        
        System.runas(userList[0]){
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;        
        
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            sp[0].Month_1_Quota_Amount__c = 1000;
            sp[0].Rep_start_date__c = Date.today() - 1;

            insert sp;
        
            Test.startTest();
    
            FunnelYearlyBatch c = new FunnelYearlyBatch(Date.today(),false,false);
            Database.executeBatch(c);
    
            Test.stopTest();
        
            YTD_Quota_Revenue__c[] quotaList = [SELECT Id, Month_1_Quota_Amount__c FROM YTD_Quota_Revenue__c WHERE Sales_Rep_Profile__c = :sp[0].id];
            
            sp = [SELECT Id, Month_1_Quota_Amount__c FROM Sales_Rep_Profile__c WHERE id = :sp[0].id];
    
            System.assertEquals(1000,quotaList[0].Month_1_Quota_Amount__c);
            
        }
    }
}