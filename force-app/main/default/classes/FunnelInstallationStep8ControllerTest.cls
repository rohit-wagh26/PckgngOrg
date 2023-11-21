@isTest 
public class FunnelInstallationStep8ControllerTest {
        
     
    static testmethod void test8() {    
        
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        insert r1;        
        fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
        insert userList1 ;
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        System.runAs (userList1[0]) { 
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;   
            
            FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
              fw.index = 1;   
              fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;          
             
              UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
              insert r;
              
              fw.userRoleId = r.id;
               
              List<User> userList = FunnelDataFactory.createUser(fw,1);
              insert userList;
              
             List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
             insert sp;
             
             Sales_Rep_Quota__c spq = new Sales_Rep_Quota__c(Sales_Rep_Profile__c =sp[0].id );
             insert spq;
            test.startTest();
            
            
            FunnelInstallationStep8Controller c = new FunnelInstallationStep8Controller(); 
            c.navigateToStep9();
            
            String str = 'ID,Name,User Name,Year,Annual Quota,\r\n'+spq.id+',Adam "R"odgers,arodger@fmproject.com.dev,2020,20201';
            Blob csvFileBody = Blob.valueOf(str);
            c.contentFile = csvFileBody;
            c.uploadSrp(); 
            
            Sales_Rep_Quota__c s = [Select name,Annual_Quota_Amount__c from Sales_Rep_Quota__c where id = :spq.id ];                 
            system.AssertEquals(20201, s.Annual_Quota_Amount__c);  
            
                      
            test.stopTest();
            
            
        }           
    }
}