@isTest

public class FunnelCertificationTableTest{

    static testmethod void testAggregation(){
    
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        insert r1;        
        fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
        
        insert userList1;
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        System.runAs ( userList1[0] ) {
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            /*insert manager record*/
            FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            //insert r;            
            fw.userRoleId = r.id;
            
            /*List<User> userList = FunnelDataFactory.createUser(fw,1);
            insert userList;
            system.debug(userList);
            UserRecMgr = userList[0];*/
            List<Sales_Rep_Profile__c> spMgr = FunnelDataFactory.createSalesReplist(userList1);
            insert spMgr;
            /*stop insert manager record*/
            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,spMgr);
            insert certs;
            
            /*insert profile record*/
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            insert r;            
            fw.userRoleId = r.id;
            
            List<User> userList = FunnelDataFactory.createUser(fw,1);
            insert userList;
            system.debug(userList);
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            sp[0].Sales_Manager__c = spMgr[0].id;
            insert sp;
            
            certs = FunnelDataFactory.createCertification(fw,sp);
            insert certs;
                       
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgr[0].id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr[0]);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            List<Opportunity > op= FunnelDataFactory.createopplist(userList);
            insert op;
            system.debug('OP0'+op[0]);                                    
                      
            /*stop insert profile record*/  
            
            Test.startTest();
            
            FunnelCertificationTable ft = new FunnelCertificationTable();
            
            system.assertEquals(ft.certiTable.size(),1);                      
            Test.stopTest();                                                                     
                  
       }              
      
    }
    
    static testmethod void testRepScenario() {           
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
         
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        
        List<User> us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 2;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u2 = us[0];
        system.debug(' user '+u2);
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps.Id );
        
        system.runAs(u2){
            test.startTest();
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgr;
            
            List<Sales_Rep_Profile__c> srList = new List<Sales_Rep_Profile__c>();
            srList.add(spMgr);
            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,srList);
            insert certs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            insert spProf;
            
            srList = new List<Sales_Rep_Profile__c>();
            srList.add(spProf);
            
            certs = FunnelDataFactory.createCertification(fw,srList);
            insert certs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
                        
            FunnelCertificationTable ft = new FunnelCertificationTable();
            system.assertEquals(ft.certiTable.size(),1);                      

            test.stopTest();
        }
                            
    }
    
    static testmethod void testRoleAggregationScenario() {           
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
         
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        
        List<User> us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 2;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u2 = us[0];
        system.debug(' user '+u2);
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps.Id );
        
        system.runAs(u2){
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            
            insert spMgr;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            
            //List<Certification__c> certs = FunnelDataFactory.createCertification(fw,sp);
            //insert certs;
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            String val = availableValues[0].getValue();
            spProf.Role__c = val;
            insert spProf;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spProf);
            
            //certs = FunnelDataFactory.createCertification(fw,sp);
            //insert certs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgr.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            test.startTest();
            
            FunnelCertificationTable ft = new FunnelCertificationTable();

            ft.fw.labelOne = 'Country';
            ft.fw.labelTwo = 'Rep';
            ft.fw.labelThree = 'Role';
            ft.fw.SelectedLevelOne = 'US';
            ft.fw.SelectedLevelTwo = 'All';
            ft.fw.SelectedLevelThree = val;
            
            ft.showUpdated();
            
            system.assertEquals(ft.certiTable.size(),1);                      

            test.stopTest();
        }
                            
    }
    
    static testmethod void testNavigation() {           
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
         
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        
        List<User> us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 2;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u2 = us[0];
        system.debug(' user '+u2);
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps.Id );
        
        system.runAs(u2){
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            
            insert spMgr;
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            String val = availableValues[0].getValue();
            spProf.Role__c = val;
            insert spProf;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            test.startTest();
            
            FunnelCertificationTable fc = new FunnelCertificationTable();

            fc.fw.labelOne = 'Country';
            fc.fw.labelTwo = 'Rep';
            fc.fw.labelThree = 'Role';
            fc.fw.SelectedLevelOne = 'US';
            fc.fw.SelectedLevelTwo = 'All';
            fc.fw.SelectedLevelThree = val;
            
            fc.reset();
            fc.levelOneAction();
            fc.levelTwoAction();
            PageReference p = fc.navigateToCalculator();
            system.assert(true,p.getUrl().contains('FunnelCalculator'));
            p = fc.navigateToHomePage();
            system.assert(true,p.getUrl().contains('FunnelHomePage'));
            p = fc.navigateToReportsPage();
            system.assert(true,p.getUrl().contains('FunnelReportingPage'));
            p = fc.navigateToAppSetup();
            system.assert(true,p.getUrl().contains('FunnelSalesCertification'));
            p = fc.navigateToCertificateReports();
            system.assert(true,p.getUrl().contains('FunnelCertificationReports'));
            p = fc.navigateToDashboard();
            system.assert(true,p.getUrl().contains('FunnelSalesDashoard'));
            p = fc.navigateToUpdatePage();
            system.assert(true,p.getUrl().contains('FunnelCertificationUpdate'));
            p = fc.navigateToDetailPage();
            system.assert(true,p.getUrl().contains('FunnelCertificationDetail'));
            
            p = fc.navigateToFunnelAnalytic();
            p = fc.navigateToFunnelAnalyticQualitative();
            p = fc.navigateToAnalytics();
            p = fc.navigateToUpdateStatusPage();
            p  = fc.navigateToSalesPipeline();
            p = fc.navigateToTrndngRep();
            p = fc.navigateToTrendingBySkill();
            p = fc.navigateToHelpMenu();
           
            fc.statusFilter();
            fc.getRepSat();
            test.stopTest();
            
            Map<String,String> strM = new Map<String,String>();
            strM.put('test','test');
            fc.ManagemenetReports = strM;
            
            fc.avgTenure = 10;
            fc.isPendingStatusUpdate = true;
            
            fc.isMgr = true;
            fc.crumValue = 'test';
            fc.levelValue = 'test';
            fc.breadCrumClick();
            fc.navigateToAnnualizationDashboard();
            fc.navigateToGoals();
        }
                            
    }              
}