@isTest
public class FunnelMonthlyCertAnswerSnapshotTest {
    
    static testmethod void testFieldsCopyingOver() {    
        
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
            
        System.runAs (userList[0]) { 
            
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;   
            
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            insert sp;                
            
            fw = new FunnelDataFactory.FunnelTestWrapper();            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,sp);
            insert certs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.type = 'Qualitative';
            fw.calcType = 'Y/N';
            fw.category = 'Communication';
            fw.userType = 'Tenured';
            fw.timing = 'End of month';
            fw.weight = '5';
            List<Certification_Rating__c> certRatings = FunnelDataFactory.createCertificationRatings(fw,10);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.certificationId = certs[0].id;
            List<Certification_Answer__c> ans = FunnelDataFactory.createCertificationAnswers(fw,certRatings);
            insert ans;
            
            test.startTest();
            FunnelMonthlyCertiAnswerSnapshotBatch c = new FunnelMonthlyCertiAnswerSnapshotBatch(Date.today());
            Database.executeBatch(c);
            test.stopTest();
            
            List<Certification_Answer_Snapshot__c > caList = [SELECT id FROM Certification_Answer_Snapshot__c ];
            
            system.assertEquals(caList.size(),10);
        }           
    }
}