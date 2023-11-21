@isTest

public class FunnelHistBatchTest{

    static testmethod void testHistFieldsPopulation(){

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
            
            Application_Setting__c appse = new Application_Setting__c();
            appse.Qualified_Percentage__c = 100;
            insert appse;
            
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
            system.debug('SP0'+sp[0]);
            
            
            List<Opportunity > op= FunnelDataFactory.createopplist(userList);
            insert op;
            system.debug('OP0'+op);
            List<Opportunity_update__e> oul = new List<Opportunity_update__e>();
            for(Opportunity o: op){
                Opportunity_update__e ou = new Opportunity_update__e(OwnerId__c = o.ownerid);
                oul.add(ou);
            }
            
            
            List<Database.SaveResult> sre = EventBus.publish(oul);   
            System.assertEquals(true, sre[0].isSuccess());
            Sales_rep_profile__c srae = [SELECT id, X12_Month_Rolling_Revenue__c, YTD_Revenue__c, Ytd_QO_added_Quantitative__c, YTD_Opportunities_Added__c FROM Sales_rep_profile__c WHERE id = :sp[0].id];
            system.debug(' sales repae '+srae);                       
                       
            
            List<Lead> l= FunnelDataFactory.createLeadlist(userList);
            insert l;
            system.debug('L0'+l[0]);
            
            List<Task> e = FunnelDataFactory.createTasklist(userList);
            insert e ;
            system.debug('E0'+e[0]);
            system.debug('E'+e);
            Test.startTest();
            
            
            FunnelCalculateHistoricalDataBatch c = new FunnelCalculateHistoricalDataBatch(date.today()+1,true);
            Database.executeBatch(c);                       
                       
            Test.stopTest();
             
            
            Sales_rep_profile__c sr = [SELECT id, X12_Month_Rolling_Revenue__c, YTD_Revenue__c, Ytd_QO_added_Quantitative__c, YTD_Opportunities_Added__c FROM Sales_rep_profile__c WHERE id = :sp[0].id];
            system.debug(' sales rep '+sr);
            System.assertEquals(sr.Ytd_QO_added_Quantitative__c,1);
                        
        }
    
    }
          
}