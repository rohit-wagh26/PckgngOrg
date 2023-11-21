@isTest
public class FunnelOverlayBatchTest{

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
              sp[0].Profile_Type__c ='Overlay';
              insert sp;
              system.debug('SP0'+sp[0]);
              
              List<Sales_Rep_Profile_Snapshot__c> rd = FunnelDataFactory.createSalesReplistSnapshot(sp);
              rd[0].Profile_Type__c ='Overlay';
              rd[0].Monthly_Quota_Revenue__c = 7000;
              
              Date sdate = Date.newInstance(date.today().year(),6,30);
              sdate = sdate .addMonths(-1);
              Integer lastDay = Date.daysInMonth(sdate.year(), sdate.month());
              sdate = Date.newInstance(sdate.year(), sdate.month(), lastDay); 
              rd[0].Snapshot_Scheduled_Date__c = sdate ;
              insert rd;
              
              
              //Step 1: Deserialized Custom Metadata instance. (Test Records) 
                List<FunnelMetrics__Funnel_Overlay__mdt> testolayCustMd = (List<Funnel_Overlay__mdt>)Json.deserialize('[{"DeveloperName":"Test","MasterLabel":"Test","FunnelMetrics__Object_Name__c": "Opportunity","FunnelMetrics__Field_Name__c": "Ownerid","FunnelMetrics__Amount_Field_Name__c" : "Amount","FunnelMetrics__Date_Field_Name__c" : "Createddate"}]', List<FunnelMetrics__Funnel_Overlay__mdt>.class); 
                 
                //Step 2
                Test.startTest();
                //Assign Test Records created above to the class property
                FunnelOverlayBatch.olayCustMd = testolayCustMd;
                
                //Create Class instance and proceed further with your testing
                Database.executeBatch(new FunnelOverlayBatch(Date.newInstance(date.today().year(),6,30),false,false));
                Test.stopTest();
                
               
              Sales_Rep_Profile__c sp1 = [select id, Quarterly_Quota_Revenue__c   from Sales_Rep_Profile__c where id =:sp[0].id limit 1];
              system.debug('sp1'+sp1);
            
            
              System.assertEquals(7000 , sp1.Quarterly_Quota_Revenue__c   );
            
          
        }
      
    }
    
    
}