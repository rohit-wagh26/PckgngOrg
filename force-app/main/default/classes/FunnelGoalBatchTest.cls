@isTest
public class FunnelGoalBatchTest{

    static testmethod void test1(){
    
          FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
          fw1.index = 1;   
          fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
          
         
          UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
          insert r1;
          
          fw1.userRoleId = r1.id;
           
          List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
          insert userList1;
          
          PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_Sales_Profile_Company_Level_access'];
          insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
          
          System.runAs ( userList1[0] ) {
          
              date d = date.newinstance(date.today().year(), 1, 1);
              Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(d);
              insert fiscalYr;
              
               Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
             
              FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
              fw.index = 1;   
              fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;          
             
              UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
              insert r;
              
              fw.userRoleId = r.id;
               
              List<User> userList = FunnelDataFactory.createUser(fw,1);
              insert userList;
              system.debug(userList);
              
              DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
              List<PicklistEntry> availableValues = describe.getPicklistValues();
            
              List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
               insert sp;
              sp[0].Role__c = availableValues[0].getValue();
              
              sp[0].Number_of_meetings_YTD__c  = 100;
              sp[0].X12_Month_Rolling_Revenue__c= 1000;
              sp[0].X12_Month_Rolling_Opptys_Won__c= 10;
              sp[0].X12_Month_QO_added__c = 10;
              sp[0].X12_Month_Leads_Added__c= 10;
              sp[0].X12_Month_Rolling_Close_Rate__c  = 100;
              sp[0].X12_Month_Rolling_Opportunity_Close_Rate__c  = 100;
              sp[0].Average_Deal_Size__c  = 100;
              sp[0].X12_Month_Rolling_Average_Sales_Cycle__c = 100;
              update sp;
              
              Sales_Rep_Profile_Snapshot__c snap = new Sales_Rep_Profile_Snapshot__c();
              
              snap.Sales_Rep_Profile__c = sp[0].id;
              snap.Name = 'Test';
              
              snap.Number_of_meetings_YTD__c  = 10;
              snap.X12_Month_Average_Selling_Price__c  = 10;
              snap.X12_Month_Lead_Conv_for_1_oppty__c  = 10;
              snap.X12_Month_Rolling_Close_Rate__c  = 10;
              snap.X12_Month_Rolling_Opportunity_Close_Rate__c  = 10;
              snap.Average_Deal_Size__c  = 10;
              snap.Goal_12m_length_of_sales_cycle__c   = 10;
              snap.Tenure_in_current_role__c  =13;
              snap.Snapshot_Scheduled_Date__c = Date.today();
              snap.Annual_Quota_Amount__c = 700; 
              snap.Role__c = availableValues[0].getValue(); 
              
              insert snap;
              
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
              
              List<event> e1 = FunnelDataFactory.createEventlist(userList);
              insert e1 ;
              
              
              Test.startTest();
            
            
              FunnelGoalBatch c = new FunnelGoalBatch (Date.today(),false,false);
              Database.executeBatch(c);
            
              Test.stopTest();
              Sales_Rep_Profile__c sp1 = [select id,Goal_12m_Avg_Selling_Price__c ,name,X12_Month_Leads_Added__c,Number_of_meetings_per_month__c,Number_of_meetings_per_quarter__c,Number_of_meetings_Rolling_12_months__c,
                                        Number_of_meetings_YTD__c,Monthly_Opportunities_added_to_Qualifie__c,Quarterly_Opportunities_added_to_Qualifi__c,Monthly_opp_won__c,Monthly_Quota_Revenue__c from Sales_Rep_Profile__c where id =:sp[0].id limit 1];
              system.debug('sp1'+sp1);
            
            
              System.assertEquals(100 , sp1.Goal_12m_Avg_Selling_Price__c );
            
             
          
        }
      
    }
    
    static testmethod void test2(){
    
          FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
          fw1.index = 1;   
          fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
          
         
          UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
          insert r1;
          
          fw1.userRoleId = r1.id;
           
          List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
          insert userList1;
          
          PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_Sales_Profile_Company_Level_access'];
          insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
          
          System.runAs ( userList1[0] ) {
          
              date d = date.newinstance(date.today().year(), 1, 1);
              Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(d);
              insert fiscalYr;
              
               Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
             
              FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
              fw.index = 1;   
              fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;          
             
              UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
              insert r;
              
              fw.userRoleId = r.id;
               
              List<User> userList = FunnelDataFactory.createUser(fw,1);
              insert userList;
              system.debug(userList);
              
              DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
              List<PicklistEntry> availableValues = describe.getPicklistValues();
            
              List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
               insert sp;
              sp[0].Role__c = availableValues[0].getValue();
              
              sp[0].Number_of_meetings_YTD__c  = 100;
              sp[0].X12_Month_Rolling_Revenue__c= 1000;
              sp[0].X12_Month_Rolling_Opptys_Won__c= 10;
              sp[0].X12_Month_QO_added__c = 10;
              sp[0].X12_Month_Leads_Added__c= 10;
              sp[0].X12_Month_Rolling_Close_Rate__c  = 100;
              sp[0].X12_Month_Rolling_Opportunity_Close_Rate__c  = 100;
              sp[0].Average_Deal_Size__c  = 100;
              sp[0].X12_Month_Rolling_Average_Sales_Cycle__c = 100;
              update sp;
              
              Sales_Rep_Profile_Snapshot__c snap = new Sales_Rep_Profile_Snapshot__c();
              
              snap.Sales_Rep_Profile__c = sp[0].id;
              snap.Name = 'Test';
              
              snap.Number_of_meetings_YTD__c  = 1000;
              snap.X12_Month_Average_Selling_Price__c  = 1000;
              snap.X12_Month_Lead_Conv_for_1_oppty__c  = 1000;
              snap.X12_Month_Rolling_Close_Rate__c  = 1000;
              snap.X12_Month_Rolling_Opportunity_Close_Rate__c  = 1000;
              snap.Average_Deal_Size__c  = 1000;
              snap.Goal_12m_length_of_sales_cycle__c   = 1000;
              snap.Tenure_in_current_role__c  =13;
              snap.Snapshot_Scheduled_Date__c = Date.today();
              snap.Annual_Quota_Amount__c = 700; 
              snap.Role__c = availableValues[0].getValue(); 
              
              insert snap;
              
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
              
              List<event> e1 = FunnelDataFactory.createEventlist(userList);
              insert e1 ;
              
              
              Test.startTest();
            
            
              FunnelGoalBatch c = new FunnelGoalBatch (Date.today(),false,false);
              Database.executeBatch(c);
            
              Test.stopTest();
              Sales_Rep_Profile__c sp1 = [select id,Goal_12m_Avg_Selling_Price__c ,name,X12_Month_Leads_Added__c,Number_of_meetings_per_month__c,Number_of_meetings_per_quarter__c,Number_of_meetings_Rolling_12_months__c,
                                        Number_of_meetings_YTD__c,Monthly_Opportunities_added_to_Qualifie__c,Quarterly_Opportunities_added_to_Qualifi__c,Monthly_opp_won__c,Monthly_Quota_Revenue__c from Sales_Rep_Profile__c where id =:sp[0].id limit 1];
              system.debug('sp1'+sp1);
            
            
              System.assertEquals(1200 , sp1.Goal_12m_Avg_Selling_Price__c );
            
             
          
        }
      
    }
    
     
}