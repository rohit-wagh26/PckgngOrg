@isTest(SeeAllData=true)
public class FunnelInstallationStep5bControllerTest {
        
     
    static testmethod void test5b() {    
        
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
            fiscalYr.name ='Historic_Year';
            insert fiscalYr; 
            
            Fiscal_Year_Setting__c fyc = Fiscal_Year_Setting__c.getValues('Current_Year');
            fyc.Start_Date__c =  System.Today()-1;
            update fyc;
            
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
              
             List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
             insert sp;
            
            test.startTest();
            
            
            FunnelInstallationStep5bController c = new FunnelInstallationStep5bController (); 
            c.createHistoricQuotaRecord();
            
            String str = 'ID,Name,User Name,Start Date,Onboarded,Role,Profile Type,Manager \r\n,,,(MM/DD/YYYY) or (MM-DD-YYYY),,,,\r\n'+sp[0].id+',Adam Rod"g"ers,arodger@fmproject.com.dev,01-04-2019,No,Account Executive,,Oleg Goodwin';
            Blob csvFileBody = Blob.valueOf(str);
            c.contentFile = csvFileBody;
            c.uploadSrp(); 
            
            Sales_Rep_Profile__c s = [Select name from Sales_Rep_Profile__c where id = :sp[0].id ];                 
            //system.AssertEquals('Test SRP 1', s.name);  
            
                      
            test.stopTest();
            
            
        }           
    }
    
    static testmethod void test5bNav() {    
        
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
              fiscalYr.name ='Historic_Year';
           // insert fiscalYr;
            
            Fiscal_Year_Setting__c fiscalYrC = FunnelDataFactory.setFiscalYear(System.Today()-1);
           // insert fiscalYrC;   
            
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
              
             List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
             insert sp;
            
            test.startTest();
            
            
            FunnelInstallationStep5bController c = new FunnelInstallationStep5bController (); 
            c.navigateToStep5a();
            c.saveAndExit();
            c.navigateToStep6();
             
             PageReference p = c.navigateToStep6();
            system.assert(true,p.getUrl().contains('FunnelInstallationStep6'));                  
                      
            test.stopTest();
        }           
    }
}