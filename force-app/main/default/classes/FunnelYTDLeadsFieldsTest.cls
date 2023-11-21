@isTest

public class FunnelYTDLeadsFieldsTest{

    static testmethod void testYTDLeadsFields(){

        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        
        
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        insert r1;
        
        fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
        insert userList1;
        
        //PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_Sales_Profile_Company_Level_access'];
        //insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        System.runAs ( userList1[0] ) {
        
            date d = date.newinstance(date.today().year(), 1, 1);
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(d);
            insert fiscalYr;
            
            FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
                    
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            //insert r;
            
            fw.userRoleId = r.id;
            
            List<User> userList = FunnelDataFactory.createUser(fw,100);
            insert userList;
            system.debug(userList);
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            insert sp;
            system.debug('SP0'+sp[0]);
            
            List<Opportunity > op= FunnelDataFactory.createopplist(userList);
            insert op;
            system.debug('OP0'+op[0]);
            
            List<Lead> l= FunnelDataFactory.createLeadlist(userList);
            insert l;
            system.debug('L0'+l[0]);
            
            List<Task> e = FunnelDataFactory.createTasklist(userList);
            insert e ;
            system.debug('E0'+e[0]);
            system.debug('E'+e);
            Test.startTest();
                
            FunnelCalculateYTDLeadsFieldsBatch c = new FunnelCalculateYTDLeadsFieldsBatch(Date.today(),false,false);
            Database.executeBatch(c);
            
            Sales_rep_profile__c sr = [SELECT YTD_leads_added__c FROM Sales_rep_profile__c WHERE id =:sp[0].id];
            system.assertEquals(sr.YTD_leads_added__c,1);
            
            Test.stopTest();
        }
    
    }
          
}