@isTest

public class FunnelCalculateActiveOpptysBatchTest{

    static testmethod void testActiveOpptys(){

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
            insert r;
            
            fw.userRoleId = r.id;
            
            List<User> userList = FunnelDataFactory.createUser(fw,1);
            insert userList;
            system.debug(userList);
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            insert sp;            
            
            List<Opportunity > op= FunnelDataFactory.createopplist(userList);
            op[0].StageName = 'Prospecting';
            op[0].CloseDate = Date.today()+1;
            insert op;           
            
            List<Lead> l= FunnelDataFactory.createLeadlist(userList);
            insert l;
            system.debug('L0'+l[0]);
            
            List<Task> e = FunnelDataFactory.createTasklist(userList);
            insert e ;
            system.debug('E0'+e[0]);
            system.debug('E'+e);
            Test.startTest();
                
            FunnelCalculateActiveOpptysBatch c = new FunnelCalculateActiveOpptysBatch(Date.today(),false,false);
            Database.executeBatch(c);
                        
            Test.stopTest();
            
            system.debug('OP0'+op[0]);
            Sales_rep_profile__c sr = [SELECT Current_active_opportunities__c FROM Sales_rep_profile__c WHERE id = :sp[0].id];
            system.debug(' sales prof '+sr);
            system.debug('SP0'+sp[0].user_record_name__c);
            System.assertEquals(1 , sr.Current_active_opportunities__c);
        }
    
    }
          
}