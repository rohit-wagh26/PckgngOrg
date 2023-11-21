@isTest

public class FunnelTriggerBatchHelperTest{

    static testmethod void testOpptyCounter(){

        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        
        
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        insert r1;
        
        fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
        insert userList1;
        
        Set<String> sName = new set<String>();
        Set<Id> idSet = new Set<Id>();
        List<Id> idLst = new List<Id>();
        for(User u:userList1){
            sName.add(u.Name);
            idSet.add(u.id);
            idLst.add(u.id);
        }
            
        //PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_Sales_Profile_Company_Level_access'];
        //insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        System.runAs ( userList1[0] ) {
        
            date d = date.newinstance(date.today().year(), 1, 1);
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(d);
            insert fiscalYr;
            
            Application_Setting__c appSet = new Application_Setting__c(Probability__c=20);
            insert appSet;
        
            FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
                    
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            insert r;
            
            fw.userRoleId = r.id;
            
            List<User> userList = FunnelDataFactory.createUser(fw,2);
            insert userList;
            system.debug(userList);
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            insert sp;
            
            sp[0].Sales_Manager__c = sp[1].id;
            update sp[0];                       
            
            List<Opportunity > op= FunnelDataFactory.createopplist(userList);
            op[0].Probability = 10;
            op[0].CloseDate = Date.today()+1;
            insert op;           
            
            Test.startTest();
            
            op[0].Probability = 30;
            op[0].CloseDate = Date.today()+40;
            update op;
            
            List<Lead> l= FunnelDataFactory.createLeadlist(userList);
            insert l;
                                                
            Sales_rep_profile__c sr = [SELECT Monthly_QO_Added__c FROM Sales_rep_profile__c WHERE id = :sp[0].id];
            System.assertEquals(1 , sr.Monthly_QO_Added__c);
            
            op[0].StageName = 'Closed/Lost';
            update op;
            
            Task t = new Task();
            t.Type = 'Meeting';
            t.ActivityDate = Date.today();
            insert t;
            
            Event e = new Event();
            e.ActivityDate = Date.today();
            e.Type = 'Call';
            e.DurationInMinutes = 30;
            e.ActivityDateTime = Date.today();
            insert e;
            
            
            FunnelTriggerBatchHelper.sendErrorMail('Error');
            FunnelTriggerBatchHelper.sendEmail(sName);
            FunnelTriggerBatchHelper.deleteJunctionRecords(idSet);
            FunnelTriggerBatchHelper.createSalesProfs(idLst);
            FunnelTriggerBatchHelper.updateSalesProfsActive(idLst);
            FunnelTriggerBatchHelper.updateSalesProfsInactive(idLst);
            FunnelTriggerBatchHelper.sendErrorMail('Error','Null Pointer');
            
            List<Application_Setting__c> asList = [Select Id from Application_Setting__c];
            delete asList;
            
            Application_Setting__c appSet2 = new Application_Setting__c(Probability__c=20,Object_for_Meeting__c='Event & Task',Meetings_Values__c='task');
            insert appSet2;
            
            Task t2 = new Task();
            t2.Type = 'Meeting';
            t2.ActivityDate = Date.today();
            insert t2;
            
            Event e2 = new Event();
            e2.ActivityDate = Date.today();
            e2.Type = 'Call';
            e2.DurationInMinutes = 30;
            e2.ActivityDateTime = Date.today();
            insert e2;
            
            List<Application_Setting__c> asList2 = [Select Id from Application_Setting__c];
            delete asList2;
            
            Application_Setting__c appSet3 = new Application_Setting__c(Probability__c=20,Object_for_Meeting__c='Task',Meetings_Values__c='task');
            insert appSet3;
            
            Event e3 = new Event();
            e3.ActivityDate = Date.today();
            e3.Type = 'Call';
            e3.DurationInMinutes = 30;
            e3.ActivityDateTime = Date.today();
            insert e3;
            Test.stopTest();
            
        }
    
    }
    
    static testmethod void testRevenuedatatrigger(){

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
            
            Application_Setting__c appSet = new Application_Setting__c(Probability__c=20);
            insert appSet;
        
            FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
                    
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            insert r;
            
            fw.userRoleId = r.id;
            
            List<User> userList = FunnelDataFactory.createUser(fw,2);
            insert userList;
            system.debug(userList);
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            sp[0].Profile_Type__c ='Hybrid';
            insert sp;     
            
                 
            
            sp[0].Sales_Manager__c = sp[1].id;
            update sp[0];                       
            
 
            
            Test.startTest();
             List<Funnelocity_Revenue_data__c> rd = FunnelDataFactory.createRevenueData(sp);
             insert rd;  
                              
            Sales_rep_profile__c sr = [SELECT Monthly_Quota_Revenue__c FROM Sales_rep_profile__c WHERE id = :sp[0].id];
            System.assertEquals(7000 , sr.Monthly_Quota_Revenue__c);
            
            Test.stopTest();
            
        }
    
    }      
}