@isTest
public class FunnelSalesCycleBatchTest {
    
    static testmethod void testFieldPopulation() {            
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole' , Name = 'My Role');
        //insert r;
        
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.profileId = profileId;
        fw.index = 1;
        //fw.userRoleId = r.id;
        
        List<User> userList = FunnelDataFactory.createUser(fw,10);
        insert userList;
            
        System.runAs (userList[0]) { 
                
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;               
            
            system.debug(userList);
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            insert sp;
            
            system.debug(sp);
            
            Opportunity o = new Opportunity();
            o.Name = 'Oppty 1';
            o.CloseDate = Date.today();
            o.ownerId = userList[0].id;
            o.StageName = 'Closed Won';
            o.Amount = 1000;
            insert o;
            
            test.startTest();
            
            FunnelSalesCycleBatch c = new FunnelSalesCycleBatch (Date.today(),false,false);
            Database.executeBatch(c);            
            
            test.stopTest();
            
            Decimal salesCycle = [SELECT X12_Month_Rolling_Average_Sales_Cycle__c  FROM Sales_Rep_Profile__c WHERE User_Record_Name__c = :userList[0].id].X12_Month_Rolling_Average_Sales_Cycle__c;
            
            system.assertEquals(salesCycle,0);
                        
        }               
    }
}