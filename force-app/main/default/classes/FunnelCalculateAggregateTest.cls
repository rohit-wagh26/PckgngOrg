@isTest

public class FunnelCalculateAggregateTest{

    static testmethod void testAggregation(){
    
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        insert r1;        
        fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,3);
        
        insert userList1;
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        System.runAs ( userList1[0] ) {
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            /*insert manager record*/
            FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            insert r;            
            fw.userRoleId = r.id;
            
            /*List<User> userList = FunnelDataFactory.createUser(fw,1);
            insert userList;
            system.debug(userList);
            UserRecMgr = userList[0];*/
            List<Sales_Rep_Profile__c> spMgr = FunnelDataFactory.createSalesReplist(userList1);
            insert spMgr;
            /*stop insert manager record*/
            
            spMgr[1].Sales_Manager__c = spMgr[0].id;
            spMgr[2].Sales_Manager__c = spMgr[0].id;
            update spMgr[1];
            update spMgr[2];
            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,spMgr);
            insert certs;
            
            List<Certification_Snapshot__c> certSnaps = FunnelDataFactory.createCertificationSnapshot(certs);
            insert certSnaps;
            
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgr[0].id;
            
            List<Sales_Rep_profile__c> sprofs = new List<Sales_rep_profile__c>();
            sprofs.add(spMgr[0]);
                        
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sprofs);                        
            insert cl;
            
            certs[1].Overall_Qualitative_Rating__c = 5;
            certs[1].Individual_Qualitative_Rating__c = 4;
            
            update certs[1];
            
            Test.startTest();
            
            certs[0].Individual_Qualitative_Rating__c = 4;
            
            update certs[0];
            
            system.assertNotEquals(certs[0].Overall_Qualitative_Rating__c,4);                      
            Test.stopTest();                                                                     
                  
       }              
      
    }
}