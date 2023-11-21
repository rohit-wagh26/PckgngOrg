@isTest
public class Funnel12MonthBatchTest{

    static testmethod void testCalculationOfFields(){
    
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
              
              //Step 1: Deserialized Custom Metadata instance. (Test Records) 
                List<Client_custom_field_mapping__mdt> testolayCustMd = (List<Client_custom_field_mapping__mdt>)Json.deserialize('[{"DeveloperName":"Test","MasterLabel":"Test","FunnelMetrics__Action__c": "SUM","FunnelMetrics__Custom_field_name__c": "FunnelMetrics__Amount_custom_field__c","FunnelMetrics__Record_type_name__c" : "Record type 1","FunnelMetrics__Standard_field_name__c" : "Amount"}]', List<Client_custom_field_mapping__mdt>.class); 

              
              //Step 2
                Test.startTest();
                //Assign Test Records created above to the class property
                Funnel12MonthBatch.lstCustMd = testolayCustMd;
            
            
              Funnel12MonthBatch c = new Funnel12MonthBatch (Date.today(),false,false);
              Database.executeBatch(c);
            
              Test.stopTest();
              Sales_Rep_Profile__c sp1 = [select id,name,X12_Month_Leads_Added__c,Number_of_meetings_per_month__c,Number_of_meetings_per_quarter__c,Number_of_meetings_Rolling_12_months__c,
                                        Number_of_meetings_YTD__c,Monthly_Opportunities_added_to_Qualifie__c,Quarterly_Opportunities_added_to_Qualifi__c,Monthly_opp_won__c,Monthly_Quota_Revenue__c from Sales_Rep_Profile__c where id =:sp[0].id limit 1];
              system.debug('sp1'+sp1);
            
            
              System.assertEquals(1 , sp1.X12_Month_Leads_Added__c );
            
          
        }
      
    }
    
    static testmethod void testCalculationOfFields2(){
    
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
             
              FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
              fw.index = 1;   
              fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;          
             
              UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
              insert r;
              
              DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
			  List<Schema.PicklistEntry> availableValues = describe.getPicklistValues();
			  //Schema.PicklistEntry pl1 = (Schema.PicklistEntry)JSON.deserialize('{"label":"Test1", "value":"Test1"}', Schema.PicklistEntry.class);
			  //Schema.PicklistEntry pl2  = (Schema.PicklistEntry)JSON.deserialize('{"label":"Test2", "value":"Test2"}', Schema.PicklistEntry.class);
              //List<Schema.PicklistEntry> availableValues = new List<Schema.PicklistEntry>{ pl1, pl2 };
              
              Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
              insert noti ;
              
              fw.userRoleId = r.id;
               
              List<User> userList = FunnelDataFactory.createUser(fw,1);
              insert userList;
              system.debug(userList);
             
              List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
              sp[0].Tenure__c = 14;
              sp[0].Role__c = availableValues[0].getValue();
              sp[0].Active__c = true;
              sp[0].Month_1_Quota_Amount__c = 7000;
              //sp[0].Profile_Type__c= 'Hybrid';
              insert sp;
              
              Sales_Rep_Profile_Snapshot__c snap = new Sales_Rep_Profile_Snapshot__c();
              
              snap.Sales_Rep_Profile__c = sp[0].id;
              snap.User_Record_Name__c = userList[0].id;
              snap.Name = 'Test';
              
              snap.Number_of_meetings_YTD__c  = 10;
              snap.X12_Month_Average_Selling_Price__c  = 10;
              snap.X12_Month_Lead_Conv_for_1_oppty__c  = 10;
              snap.X12_Month_Rolling_Close_Rate__c  = 10;
              snap.X12_Month_Rolling_Opportunity_Close_Rate__c  = 10;
              snap.Average_Deal_Size__c  = 10;
              snap.YTD_Revenue__c= 100;
              snap.Active__c = true;
              snap.Annual_Quota_Amount__c= 100;
              snap.Tenure_in_current_role__c  = 13;
              snap.Snapshot_Scheduled_Date__c = date.newInstance(date.today().year() - 1, 12, 31);
              snap.Monthly_Quota_Revenue__c = 700; 
              snap.Role__c = availableValues[0].getValue(); 
              
              insert snap;
              
              Sales_Rep_Profile_Snapshot__c snap1 = new Sales_Rep_Profile_Snapshot__c();
              
              snap1.Sales_Rep_Profile__c = sp[0].id;
              snap1.User_Record_Name__c = userList[0].id;
              snap1.Name = 'Test';
              
              snap1.Number_of_meetings_YTD__c  = 10;
              snap1.X12_Month_Average_Selling_Price__c  = 10;
              snap1.X12_Month_Lead_Conv_for_1_oppty__c  = 10;
              snap1.X12_Month_Rolling_Close_Rate__c  = 10;
              snap1.X12_Month_Rolling_Opportunity_Close_Rate__c  = 10;
              snap1.Average_Deal_Size__c  = 10;
              snap1.YTD_Revenue__c= 100;
              snap1.Active__c = true;
              snap1.Annual_Quota_Amount__c= 100;
              snap1.Tenure_in_current_role__c  = 13;
              snap1.Snapshot_Scheduled_Date__c = date.newInstance(date.today().year() - 1, 12, 31);
              snap1.Monthly_Quota_Revenue__c = 700; 
              snap1.Role__c = availableValues[0].getValue(); 
              
              insert snap1;
              
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
              
              List<event> e1 = FunnelDataFactory.createEventlist(userList);
              insert e1 ;
              
              //Step 1: Deserialized Custom Metadata instance. (Test Records) 
                List<Client_custom_field_mapping__mdt> testolayCustMd = (List<Client_custom_field_mapping__mdt>)Json.deserialize('[{"DeveloperName":"Test","MasterLabel":"Test","FunnelMetrics__Action__c": "SUM","FunnelMetrics__Custom_field_name__c": "FunnelMetrics__Amount_custom_field__c","FunnelMetrics__Record_type_name__c" : "Record type 1","FunnelMetrics__Standard_field_name__c" : "Amount"}]', List<Client_custom_field_mapping__mdt>.class); 

              
             //Step 2
                Test.startTest();
                //Assign Test Records created above to the class property
                Funnel12MonthBatch.lstCustMd = testolayCustMd;
            
              Funnel12MonthBatch c = new Funnel12MonthBatch (Date.today(),false,false);
              Database.executeBatch(c);
            
              Test.stopTest();
              Sales_Rep_Profile__c sp1 = [select id,name,X12_Month_Leads_Added__c,Number_of_meetings_per_month__c,Number_of_meetings_per_quarter__c,Number_of_meetings_Rolling_12_months__c,
                                        Number_of_meetings_YTD__c,Monthly_Opportunities_added_to_Qualifie__c,Quarterly_Opportunities_added_to_Qualifi__c,Monthly_opp_won__c,Monthly_Quota_Revenue__c from Sales_Rep_Profile__c where id =:sp[0].id limit 1];
              system.debug('sp1'+sp1);
            
            
              System.assertEquals(1 , sp1.X12_Month_Leads_Added__c );
            
          
        }
      
    }
    
    static testmethod void testCalculationOfFieldsHybrid(){
    
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
             
              FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
              fw.index = 1;   
              fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;          
             
              UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
              insert r;
              
              DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
              List<PicklistEntry> availableValues = describe.getPicklistValues();
              
              Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
              insert noti ;
              
              fw.userRoleId = r.id;
               
              List<User> userList = FunnelDataFactory.createUser(fw,1);
              insert userList;
              system.debug(userList);
             
              List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
              sp[0].Tenure__c = 14;
              sp[0].Role__c = availableValues[0].getValue();
              sp[0].Active__c = true;
              sp[0].Month_1_Quota_Amount__c = 7000;
              sp[0].Profile_Type__c= 'Hybrid';
              sp[0].Monthly_Quota_Revenue__c= 7000;
              sp[0].Quarterly_Quota_Revenue__c= 7000;
              sp[0].YTD_Revenue__c= 7000;
              insert sp;
              
              Sales_Rep_Profile_Snapshot__c snap = new Sales_Rep_Profile_Snapshot__c();
              
              snap.Sales_Rep_Profile__c = sp[0].id;
              snap.User_Record_Name__c = userList[0].id;
              snap.Name = 'Test';
              
              snap.Number_of_meetings_YTD__c  = 10;
              snap.X12_Month_Average_Selling_Price__c  = 10;
              snap.X12_Month_Lead_Conv_for_1_oppty__c  = 10;
              snap.X12_Month_Rolling_Close_Rate__c  = 10;
              snap.X12_Month_Rolling_Opportunity_Close_Rate__c  = 10;
              snap.Average_Deal_Size__c  = 10;
              snap.YTD_Revenue__c= 100;
              snap.Active__c = true;
              snap.Annual_Quota_Amount__c= 100;
              snap.Tenure_in_current_role__c  = 13;
              snap.Snapshot_Scheduled_Date__c = date.newInstance(date.today().year() - 1, 12, 31);
              snap.Monthly_Quota_Revenue__c = 700; 
              snap.Role__c = availableValues[0].getValue(); 
              
              insert snap;
              
              Sales_Rep_Profile_Snapshot__c snap1 = new Sales_Rep_Profile_Snapshot__c();
              
              snap1.Sales_Rep_Profile__c = sp[0].id;
              snap1.User_Record_Name__c = userList[0].id;
              snap1.Name = 'Test';
              
              snap1.Number_of_meetings_YTD__c  = 10;
              snap1.X12_Month_Average_Selling_Price__c  = 10;
              snap1.X12_Month_Lead_Conv_for_1_oppty__c  = 10;
              snap1.X12_Month_Rolling_Close_Rate__c  = 10;
              snap1.X12_Month_Rolling_Opportunity_Close_Rate__c  = 10;
              snap1.Average_Deal_Size__c  = 10;
              snap1.YTD_Revenue__c= 100;
              snap1.Active__c = true;
              snap1.Annual_Quota_Amount__c= 100;
              snap1.Tenure_in_current_role__c  = 13;
              snap1.Snapshot_Scheduled_Date__c = date.newInstance(date.today().year() - 1, 12, 31);
              snap1.Monthly_Quota_Revenue__c = 700; 
              snap1.Role__c = availableValues[0].getValue(); 
              
              insert snap1;
              
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
              
              List<event> e1 = FunnelDataFactory.createEventlist(userList);
              insert e1 ;
              
              //Step 1: Deserialized Custom Metadata instance. (Test Records) 
                List<Client_custom_field_mapping__mdt> testolayCustMd = (List<Client_custom_field_mapping__mdt>)Json.deserialize('[{"DeveloperName":"Test","MasterLabel":"Test","FunnelMetrics__Action__c": "SUM","FunnelMetrics__Custom_field_name__c": "FunnelMetrics__Amount_custom_field__c","FunnelMetrics__Record_type_name__c" : "Record type 1","FunnelMetrics__Standard_field_name__c" : "Amount"}]', List<Client_custom_field_mapping__mdt>.class); 

              
             //Step 2
                Test.startTest();
                //Assign Test Records created above to the class property
                Funnel12MonthBatch.lstCustMd = testolayCustMd;
            
              Funnel12MonthBatch c = new Funnel12MonthBatch (Date.today(),false,true);
              Database.executeBatch(c);
            
              Test.stopTest();
              Sales_Rep_Profile__c sp1 = [select id,name,X12_Month_Leads_Added__c,Number_of_meetings_per_month__c,Number_of_meetings_per_quarter__c,Number_of_meetings_Rolling_12_months__c,
                                        Number_of_meetings_YTD__c,Monthly_Opportunities_added_to_Qualifie__c,Quarterly_Opportunities_added_to_Qualifi__c,Monthly_opp_won__c,Monthly_Quota_Revenue__c from Sales_Rep_Profile__c where id =:sp[0].id limit 1];
              system.debug('sp1'+sp1);
            
            
              System.assertEquals(1 , sp1.X12_Month_Leads_Added__c );
            
          
        }
      
    }
}