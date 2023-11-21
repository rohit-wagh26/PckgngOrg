@isTest
public class FunnelAnnualizationDashboardTest {
    
    static testmethod void testRole() {  
    
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        //insert r;
         
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        //fw.userRoleId = r.id;
        
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
        
         
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id ); 
         
          system.runAs(u){
            
            //Date d = Date.newinstance(2020,01,01);
            date d = date.newinstance(date.today().year(), 1, 1);
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(d);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            list<Sales_Rep_Profile__c> ss = new List<Sales_Rep_Profile__c >();
            List<Company_Level__c> csnap = new List<Company_Level__c>();
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            String val = availableValues[0].getValue();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            spMgr.YTD_Revenue__c = 100;
            spMgr.Month_1_Quota_Amount__c= 200;
            spMgr.X12_Month_Rolling_Revenue__c = 1000;
            spMgr.Current_Fiscal_Months__c = 2 ;
            spMgr.Tenure__c  = 12 ;
            spMgr.Role__c = val;
            spMgr.Active__c = true;
            
            insert spMgr;
            ss.add(spMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            spProf.YTD_Revenue__c = 100;
            spProf.Month_1_Quota_Amount__c= 200;
            spProf.X12_Month_Rolling_Revenue__c = 1000;
            spProf.Current_Fiscal_Months__c = 2 ;
            spProf.Tenure__c  = 12 ;
            spProf.Role__c = val;
            spProf.Active__c = true;
            
            insert spProf;
            ss.add(spProf);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spProf.id;
            system.debug(' fw.userId '+fw.userId);       
            
            Sales_Rep_Profile__c spProf1 = FunnelDataFactory.createSalesRep(fw);
            spProf1.YTD_Revenue__c = 100;
            spProf1.Month_1_Quota_Amount__c= 200;
            spProf1.X12_Month_Rolling_Revenue__c = 1000;
            spProf1.Current_Fiscal_Months__c = 2 ;
            spProf1.Tenure__c  = 12 ;
            spProf1.Role__c = val;
            spProf1.Active__c = true;
            insert spProf1;
            
            ss.add(spProf1);
            
             Sales_Rep_Profile__c spProf2 = FunnelDataFactory.createSalesRep(fw);
            spProf2 .YTD_Revenue__c = 100;
            spProf2 .Month_1_Quota_Amount__c= 200;
            spProf2 .X12_Month_Rolling_Revenue__c = 1000;
            spProf2 .Current_Fiscal_Months__c = 2 ;
            spProf2 .Tenure__c  = 1 ;
           	spProf2 .Role__c = val;
            spProf2.Active__c = true;
            insert spProf2 ;
            
            ss.add(spProf2 );
            
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(ss);
            for(Sales_Rep_Profile_Snapshot__c sps : spsnap){
                sps.Snapshot_Scheduled_Date__c =  Date.newInstance(2019, 12, 31);
                sps.Monthly_Quota_Revenue__c = 100;
                sps.Tenure__c =  12;
                sps.Active__c = true;
            }
             
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
            for(Company_Level_Junction_snapshot__c css :cs){
                css.Snapshot_Scheduled_Date__c =  Date.newInstance(2019, 12, 31);
            }
            insert cs;
            
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;  
            fw.levelName = 'Region';
            fw.levelValue = 'US West';
            fw.salesProfForCompLevel = spProf.id;
             
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spProf);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            List<Company_Level_Junction_snapshot__c> cs1 = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
             for(Company_Level_Junction_snapshot__c css :cs1 ){
                css.Snapshot_Scheduled_Date__c =  Date.newInstance(2019, 12, 31);
            }
            insert cs1;
            test.startTest();   
            PageReference myVfPage = Page.FunnelReportingPage;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Country');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Region');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , 'Sales Executive');  
                                 
            FunnelAnnualizationDashboardController fc = new FunnelAnnualizationDashboardController();
            
            system.assertEquals(fc.chart1YaxisMax,1000); 
            
            test.stopTest();
        }
    
    }
    
        static testmethod void testRepScenario() {           
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        //insert r;
         
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        //fw.userRoleId = r.id;
        
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
            //Date d = Date.newinstance(2020,01,01);
            date d = date.newinstance(date.today().year(), 1, 1);
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(d);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            list<Sales_Rep_Profile__c> ss = new List<Sales_Rep_Profile__c >();
            
             DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            String val = availableValues[0].getValue();
            
             fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            spMgr.YTD_Revenue__c = 100;
            spMgr.Month_1_Quota_Amount__c= 200;
            spMgr.X12_Month_Rolling_Revenue__c = 1000;
            spMgr.Current_Fiscal_Months__c = 2 ;
            spMgr.Tenure__c  = 12 ;
            spMgr.Role__c = val;
            
            insert spMgr;
            ss.add(spMgr);
            
             fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            spProf.YTD_Revenue__c = 100;
            spProf.Month_1_Quota_Amount__c= 200;
            spProf.X12_Month_Rolling_Revenue__c = 1000;
            spProf.Current_Fiscal_Months__c = 2 ;
            spProf.Tenure__c  = 12 ;
            spProf.Role__c = val;
            
            insert spProf;
            ss.add(spProf);
            
            
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(ss);
            for(Sales_Rep_Profile_Snapshot__c sps : spsnap){
                sps.Snapshot_Scheduled_Date__c =  Date.newInstance(2019, 12, 31);
                sps.Tenure__c =  12;
            }
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
             for(Company_Level_Junction_snapshot__c css :cs){
                css.Snapshot_Scheduled_Date__c =  Date.newInstance(2019, 12, 31);
            }
            insert cs;
                       
            FunnelAnnualizationDashboardController  fc = new FunnelAnnualizationDashboardController ();
            system.assertEquals(fc.chart1YaxisMax,1000);
            test.stopTest();
        }
                            
    }
    
    
        static testmethod void testNavigation() {           
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        //insert r;
         
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        //fw.userRoleId = r.id;
        
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
            
            List<Decimal> ld = new List<Decimal>();
            ld.add(0);
            ld.add(1);
            
            test.startTest();
            
            FunnelAnnualizationDashboardController  fc = new FunnelAnnualizationDashboardController();                        

            fc.fw.labelOne = 'Country';
            fc.fw.labelTwo = 'Rep';
            fc.fw.labelThree = 'Role';
            fc.fw.SelectedLevelOne = 'US';
            fc.fw.SelectedLevelTwo = 'All';
            fc.fw.SelectedLevelThree = val;
            
            fc.sname = '';
            fc.isMgr = true;
            fc.isReset=true;
            fc.crumValue='';
            fc.levelValue='';
            fc.breadCrumClick();
            fc.aggregate(spMgr.id);
            fc.getChartNewRep(ld);
            fc.reset();
            //fc.levelOneAction();
            //fc.levelTwoAction();
            //fc.breadCrumClick();
            
            fc.getChart12DataChart();
            fc.getChart12MonthsChart();
            fc.getChart24DataChart();
            fc.getChart24MonthsChart();
            fc.getChartDataChart();
            fc.getCharLabelsChart();
             
            
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
            p = fc.navigateToTrendingByRep();
            system.assert(true,p.getUrl().contains('FunnelTrendingByRepDashboard'));
            p = fc.navigateToTrndngRep();
            system.assert(true,p.getUrl().contains('FunnelTrendingByRepDashboard'));
            p = fc.navigateToTrendingBySkill();
            system.assert(true,p.getUrl().contains('FunnelTrendingBySkillDashboard'));
            p = fc.navigateToSalesPipeline();
            system.assert(true,p.getUrl().contains('navigateToFunnelHomePage1'));
            
            p = fc.navigateToGoals();
            p = fc.navigateToHelpMenu();
            p = fc.navigateToFunnelAnalyticQualitative();
            p = fc.navigateToFunnelAnalytic();
            
            
            test.stopTest();
        }
    }

}