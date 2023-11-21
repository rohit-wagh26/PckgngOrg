@isTest
public class Funnel12MonthBatchPart2Test{

    static testmethod void testCalculationOfFields(){
    
          FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
          fw1.index = 1;   
          fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
          
         
          UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
          //insert r1;
          
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
              
              Application_Setting__c a = new Application_Setting__c(Name='Test');
              insert a;
           
              List<User> userList = FunnelDataFactory.createUser(fw,1);
              insert userList;
              system.debug(userList);
             
              List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
              insert sp;
              system.debug('SP0'+sp[0]);
              
              List<Opportunity > op= FunnelDataFactory.createopplist(userList);
              insert op;
              system.debug('OP0'+op[0]);
              
               
              Test.startTest();
              Funnel12MonthBatch  c1 = new Funnel12MonthBatch  (Date.today(),false,false);
              Database.executeBatch(c1);
            
              Funnel12MonthBatchPart2 c = new Funnel12MonthBatchPart2 (Date.today(),false,false);
              Database.executeBatch(c);
            
              Test.stopTest();
              Sales_Rep_Profile__c sp1 = [select id,X12_Month_Opprties_Added_to_the_funnel__c,name,X12_Month_Leads_Added__c,Number_of_meetings_per_month__c,Number_of_meetings_per_quarter__c,Number_of_meetings_Rolling_12_months__c,
                                        Number_of_meetings_YTD__c,Monthly_Opportunities_added_to_Qualifie__c,Quarterly_Opportunities_added_to_Qualifi__c,Monthly_opp_won__c,Monthly_Quota_Revenue__c from Sales_Rep_Profile__c where id =:sp[0].id limit 1];
              system.debug('sp1'+sp1);
            
            
              System.assertEquals(1 , sp1.X12_Month_Opprties_Added_to_the_funnel__c);
            
           
          
        }
      
    }
    
    static testmethod void testCalculationOfFieldsHybrid(){
    
          FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
          fw1.index = 1;   
          fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
          
         
          UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
          //insert r1;
          
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
              
              Application_Setting__c a = new Application_Setting__c(Name='Test');
              insert a;
           
              List<User> userList = FunnelDataFactory.createUser(fw,1);
              insert userList;
              system.debug(userList);
             
              List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
              sp[0].Profile_Type__c= 'Hybrid';
              insert sp;
              system.debug('SP0'+sp[0]);
              
              List<Opportunity > op= FunnelDataFactory.createopplist(userList);
              insert op;
              op[0].StageName = 'Closed Lost';
              system.debug('OP0'+op[0]);
              
               
              Test.startTest();
              Funnel12MonthBatch  c1 = new Funnel12MonthBatch  (Date.today(),false,false);
              Database.executeBatch(c1);
            
              Funnel12MonthBatchPart2 c = new Funnel12MonthBatchPart2 (Date.today(),false,true);
              Database.executeBatch(c);
            
              Test.stopTest();
              Sales_Rep_Profile__c sp1 = [select id,X12_Month_Opprties_Added_to_the_funnel__c,name,X12_Month_Leads_Added__c,Number_of_meetings_per_month__c,Number_of_meetings_per_quarter__c,Number_of_meetings_Rolling_12_months__c,
                                        Number_of_meetings_YTD__c,Monthly_Opportunities_added_to_Qualifie__c,Quarterly_Opportunities_added_to_Qualifi__c,Monthly_opp_won__c,Monthly_Quota_Revenue__c from Sales_Rep_Profile__c where id =:sp[0].id limit 1];
              system.debug('sp1'+sp1);
            
            
              System.assertEquals(1 , sp1.X12_Month_Opprties_Added_to_the_funnel__c);
            
           
          
        }
      
    }
}