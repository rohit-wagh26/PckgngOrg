@isTest

public class FunnelCertificationReportsControllerTest{

    static testmethod void testAggregation(){
    
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
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 3;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u3 = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 4;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u4 = us[0];
         
          PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
         insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id );
        
        system.runAs(u){
            test.startTest();
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            List<Sales_Rep_Profile__c> srplist = new List<Sales_Rep_Profile__c>();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgr;
            srplist.add(spMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            insert spProf;
            srplist.add(spProf);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spProf.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf1 = FunnelDataFactory.createSalesRep(fw);
            insert spProf1;
            srplist.add(spProf1);
            
           // List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(srplist);
           // insert spsnap ;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
          //  List<Company_Level_Junction_snapshot__c> cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
          //  insert cs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;  
            fw.levelName = 'Region';
            fw.levelValue = 'US West';
            fw.salesProfForCompLevel = spProf.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spProf);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
         //   List<Company_Level_Junction_snapshot__c> cs1 = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
         //   insert cs1;
            
            
            List<Certification__c> cerList = FunnelDataFactory.createCertification(fw,srplist); 
            cerList[0].Overall_Rating__c = 5;
            cerList[0].Overall_Qualitative_Rating__c = 5;
            cerList[0].Overall_Quantitative_Rating__c = 5;
            
            cerList[1].Overall_Rating__c = 5;
            cerList[1].Overall_Qualitative_Rating__c = 5;
            cerList[1].Overall_Quantitative_Rating__c = 5;
            
            cerList[2].Overall_Rating__c = 5;
            cerList[2].Overall_Qualitative_Rating__c = 5;
            cerList[2].Overall_Quantitative_Rating__c = 5;
            
            insert cerList;
            
          //  List<Certification_Snapshot__c> certsnap= FunnelDataFactory.createCertificationSnapshot(cerList);  
          //  insert certsnap;
               
            PageReference myVfPage = Page.FunnelCertificationReports;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Country');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Region');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , 'All'); 
                                   
            
            
            FunnelCertificationReportsController ft = new FunnelCertificationReportsController();
            
            system.assertEquals(ft.chartData.size(),1); 
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
            
            List<Sales_Rep_Profile__c> srplist = new List<Sales_Rep_Profile__c>();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgr;
            srplist.add(spMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            insert spProf;
            srplist.add(spProf);
            
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(srplist);
            insert spsnap ;
            
            List<Certification__c> cerList = FunnelDataFactory.createCertification(fw,srplist); 
            cerList[0].Overall_Rating__c = 5;
            cerList[0].Overall_Qualitative_Rating__c = 5;
            cerList[0].Overall_Quantitative_Rating__c = 5;
            
            cerList[1].Overall_Rating__c = 5;
            cerList[1].Overall_Qualitative_Rating__c = 5;
            cerList[1].Overall_Quantitative_Rating__c = 5;
            
            insert cerList;
            
            List<Certification_Snapshot__c> certsnap= FunnelDataFactory.createCertificationSnapshot(cerList);  
            insert certsnap;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            List<Company_Level_Junction_snapshot__c> cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
            insert cs;
                        
            FunnelCertificationReportsController ft = new FunnelCertificationReportsController();
            system.assertEquals(ft.chartData.size(),1); 
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
            
            List<Sales_Rep_Profile__c> srplist = new List<Sales_Rep_Profile__c>();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgr;
            srplist.add(spMgr);
            
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
            srplist.add(spProf);
            
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(srplist);
            insert spsnap ;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            List<Company_Level_Junction_snapshot__c> cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
            insert cs;
            
            List<Certification__c> cerList = FunnelDataFactory.createCertification(fw,srplist); 
            cerList[0].Overall_Rating__c = 5;
            cerList[0].Overall_Qualitative_Rating__c = 5;
            cerList[0].Overall_Quantitative_Rating__c = 5;
            
            cerList[1].Overall_Rating__c = 5;
            cerList[1].Overall_Qualitative_Rating__c = 5;
            cerList[1].Overall_Quantitative_Rating__c = 5;
            insert cerList ;
            
            List<Certification_Snapshot__c> certsnap= FunnelDataFactory.createCertificationSnapshot(cerList);  
            insert certsnap;
            
            test.startTest();
            
            FunnelCertificationReportsController ft = new FunnelCertificationReportsController();

            ft.fw.labelOne = 'Country';
            ft.fw.labelTwo = 'Rep';
            ft.fw.labelThree = 'Role';
            ft.fw.SelectedLevelOne = 'US';
            ft.fw.SelectedLevelTwo = 'All';
            ft.fw.SelectedLevelThree = val;
            
            ft.certiTable = cerList;
            
            ft.showUpdated();
            
            system.assertEquals(ft.chartData.size(),1); 
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
            
            list<Sales_Rep_Profile__c> ss = new List<Sales_Rep_Profile__c >();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            
            insert spMgr;
            ss.add(spMgr);
            
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
            ss.add(spProf);
            
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(ss);
            insert spsnap ;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            List<Company_Level_Junction_snapshot__c> cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
            insert cs;
            
            test.startTest();
            
            FunnelCertificationReportsController fc = new FunnelCertificationReportsController();

            fc.fw.labelOne = 'Country';
            fc.fw.labelTwo = 'Rep';
            fc.fw.labelThree = 'Role';
            fc.fw.SelectedLevelOne = 'US';
            fc.fw.SelectedLevelTwo = 'All';
            fc.fw.SelectedLevelThree = 'All';
            
            fc.isMgr = true;
            fc.isReset = true;
            fc.levelValue ='';
            
            fc.reset();
            fc.levelOneAction();
            fc.levelTwoAction();
            fc.getCharLabels();
            fc.getFScores();
            fc.getQualitativeScores();
            fc.getQuantitativeScores();
            fc.getmonthsValuesqualitatives();
            fc.getCharLabelsbelow();
            fc.getFScoresbelow();
            fc.getQualitativeScoresbelow();
            fc.getQuantitativeScoresbelow();
            fc.getrevenue();
            fc.getQuotas();
            fc.getrevenuebelow();
            fc.getQuotasbelow();
            fc.getmonthrevenue();
            fc.getMonthss();
            fc.getMonthsValuess();
           
            test.stopTest();
        
        PageReference p = fc.navigateToCertification();
            system.assert(true,p.getUrl().contains('FunnelCerificationTable'));
            p = fc.navigateToCalculator();
            system.assert(true,p.getUrl().contains('FunnelCalculator'));
            p = fc.navigateToHomePage();
            system.assert(true,p.getUrl().contains('FunnelHomePage'));
            p = fc.navigateToDashboard();
            system.assert(true,p.getUrl().contains('FunnelSalesDashboard'));
            p = fc.navigateToReportsPage();
            system.assert(true,p.getUrl().contains('FunnelReportingPage'));
            p = fc.navigateToAppSetup();
            system.assert(true,p.getUrl().contains('FunnelSalesCertification'));
            p = fc.navigateToCertificateReports();
            system.assert(true,p.getUrl().contains('FunnelCerificationReports'));
            p = fc.navigateToAnalytics();
            system.assert(true,p.getUrl().contains('navigateToAnalytics'));
            p = fc.navigateToFunnelAnalyticQualitative();
            system.assert(true,p.getUrl().contains('navigateToFunnelAnalyticQualitative'));
            p = fc.navigateToFunnelAnalytic();
            system.assert(true,p.getUrl().contains('navigateToFunnelAnalytic'));
            p = fc.navigateToHelpMenu();
            p = fc.navigateToAnnualizationDashboard();
            p = fc.navigateToGoals();
            fc.breadCrumClick();
        }
                            
    }  
    static testmethod void testTeamAggregationRep() {           
        
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
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 3;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u3 = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 4;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u4 = us[0];
         
         PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
         insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id ); 
        
        system.runAs(u){
            test.startTest();
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            List<Sales_Rep_Profile__c> srplist = new List<Sales_Rep_Profile__c>();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgr;
            srplist.add(spMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            insert spProf;
            srplist.add(spProf);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf1 = FunnelDataFactory.createSalesRep(fw);
            insert spProf1;
            srplist.add(spProf1);
            
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(srplist);
            insert spsnap ;
            
            List<Certification__c> cerList = FunnelDataFactory.createCertification(fw,srplist); 
            insert cerList;
            
            List<Certification_Snapshot__c> certsnap= FunnelDataFactory.createCertificationSnapshot(cerList);  
            insert certsnap;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Region';
            fw.levelValue = 'US West';
            fw.salesProfForCompLevel = spMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            List<Company_Level_Junction_snapshot__c> cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
            insert cs;
            
               
            PageReference myVfPage = Page.FunnelReportingPage;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Region');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Rep');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US West');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , 'All'); 
                                 
            FunnelCertificationReportsController  fc = new FunnelCertificationReportsController ();
            
            system.assertEquals(fc.chartData.size(),1); 
            
            test.stopTest();
        }
                            
    }            
}