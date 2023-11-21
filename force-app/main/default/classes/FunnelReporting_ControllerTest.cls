@isTest
public class FunnelReporting_ControllerTest {
    
    static testmethod void testTeamAggregation() {           
        
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
            test.startTest();
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            list<Sales_Rep_Profile__c> ss = new List<Sales_Rep_Profile__c >();
            List<Company_Level__c> csnap = new List<Company_Level__c>();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            spMgr.YTD_Revenue__c = 100;
            spMgr.Month_1_Quota_Amount__c= 200;
            spMgr.YTD_Opportunity_Close_Rate__c = 10 ;
            spMgr.Goal_12m_rolling_close_rate__c = 20 ;
            spMgr.YTD_Opportunities_won__c = 10 ;
            spMgr.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spMgr.Current_Fiscal_Months__c = 2 ;
            
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
            spProf.YTD_Opportunity_Close_Rate__c = 10 ;
            spProf.Goal_12m_rolling_close_rate__c = 20 ;
            spProf.YTD_Opportunities_won__c = 10 ;
            spProf.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spProf.Current_Fiscal_Months__c = 2 ;
            
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
            spProf1.YTD_Opportunity_Close_Rate__c = 10 ;
            spProf1.Goal_12m_rolling_close_rate__c = 20 ;
            spProf1.YTD_Opportunities_won__c = 10 ;
            spProf1.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spProf1.Current_Fiscal_Months__c = 2 ;
            insert spProf1;
            
            ss.add(spProf1);
            
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
            insert cs1;
               
            PageReference myVfPage = Page.FunnelReportingPage;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Country');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Region');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , 'All'); 
            ApexPages.currentPage().getparameters().put('selectFour' , 'Abc'); 
                                 
            FunnelReporting_Controller fc = new FunnelReporting_Controller();
            system.assertEquals(fc.chartData.size(),0); 
            
            test.stopTest();
        }
                            
    }
    
    static testmethod void testTeamAggregationAggre() {           
        
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
            
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            list<Sales_Rep_Profile__c> ss = new List<Sales_Rep_Profile__c >();
            List<Company_Level__c> csnap = new List<Company_Level__c>();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            spMgr.YTD_Revenue__c = 100;
            spMgr.Month_1_Quota_Amount__c= 200;
            spMgr.YTD_Opportunity_Close_Rate__c = 10 ;
            spMgr.Goal_12m_rolling_close_rate__c = 20 ;
            spMgr.YTD_Opportunities_won__c = 10 ;
            spMgr.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spMgr.Current_Fiscal_Months__c = 2 ;
            
            insert spMgr;
            ss.add(spMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            String val = availableValues[0].getValue();
            
            spProf.YTD_Revenue__c = 100;
            spProf.Month_1_Quota_Amount__c= 200;
            spProf.YTD_Opportunity_Close_Rate__c = 10 ;
            spProf.Goal_12m_rolling_close_rate__c = 20 ;
            spProf.YTD_Opportunities_won__c = 10 ;
            spProf.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spProf.Current_Fiscal_Months__c = 2 ;
            spProf.Role__c = val;
            
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
            spProf1.YTD_Opportunity_Close_Rate__c = 10 ;
            spProf1.Goal_12m_rolling_close_rate__c = 20 ;
            spProf1.YTD_Opportunities_won__c = 10 ;
            spProf1.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spProf1.Current_Fiscal_Months__c = 2 ;
            spProf1.Role__c = val;
            
            insert spProf1;
            
            system.debug(' spProf1 '+spProf1);
            
            ss.add(spProf1);
            
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(ss);
            insert spsnap ;
            system.debug(' spsnap '+spsnap); 
                      
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            system.debug(' cl '+cl);
            
            //List<Company_Level_Junction_snapshot__c> cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);
            
            List<Company_Level_Junction_snapshot__c> cs = createCompanyLevelJunctionSnapshots(cl,spsnap);              
            insert cs;
            system.debug(' cs '+cs);
                        
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
            insert cs1;
            
            system.debug(' cs1 '+cs1);
            
            test.startTest();
               
            PageReference myVfPage = Page.FunnelReportingPage;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Country');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Region');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , 'All'); 
                                 
            FunnelReporting_Controller fc = new FunnelReporting_Controller();
            system.assertEquals(fc.chartData.size(),1); 
            
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
            spMgr.YTD_Revenue__c = 100;
            spMgr.Month_1_Quota_Amount__c= 200;
            spMgr.YTD_Opportunity_Close_Rate__c = 10 ;
            spMgr.Goal_12m_rolling_close_rate__c = 20 ;
            spMgr.YTD_Opportunities_won__c = 10 ;
            spMgr.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spMgr.Current_Fiscal_Months__c = 2 ;
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
            spProf.YTD_Opportunity_Close_Rate__c = 10 ;
            spProf.Goal_12m_rolling_close_rate__c = 20 ;
            spProf.YTD_Opportunities_won__c = 10 ;
            spProf.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spProf.Current_Fiscal_Months__c = 2 ;
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
                       
            FunnelReporting_Controller fc = new FunnelReporting_Controller();
            system.assertEquals(fc.chartData.size(),1); 
            test.stopTest();
        }
                            
    }
    
    static testmethod void testRoleAggregationScenario() {           
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        //insert r;
         
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
        insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps.Id );
        
        system.runAs(u2){
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            list<Sales_Rep_Profile__c> ss = new List<Sales_Rep_Profile__c >();
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            spMgr.YTD_Revenue__c = 100;
            spMgr.Month_1_Quota_Amount__c= 200;
            spMgr.YTD_Opportunity_Close_Rate__c = 10 ;
            spMgr.Goal_12m_rolling_close_rate__c = 20 ;
            spMgr.YTD_Opportunities_won__c = 10 ;
            spMgr.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spMgr.Current_Fiscal_Months__c = 2 ;
            String val = availableValues[0].getValue();
            spMgr.Role__c = val;
            
            insert spMgr;
            ss.add(spMgr);
            
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            //String val = availableValues[0].getValue();
            spProf.Role__c = val;
            spProf.YTD_Revenue__c = 100;
            spProf.Month_1_Quota_Amount__c= 200;
            spProf.YTD_Opportunity_Close_Rate__c = 10 ;
            spProf.Goal_12m_rolling_close_rate__c = 20 ;
            spProf.YTD_Opportunities_won__c = 10 ;
            spProf.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spProf.Current_Fiscal_Months__c = 2 ;
            insert spProf;
            ss.add(spProf);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spProf.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf1 = FunnelDataFactory.createSalesRep(fw);
            val = availableValues[0].getValue();
            spProf1 .Role__c = val;
            spProf1 .YTD_Revenue__c = 100;
            spProf1 .Month_1_Quota_Amount__c= 200;
            spProf1 .YTD_Opportunity_Close_Rate__c = 10 ;
            spProf1 .Goal_12m_rolling_close_rate__c = 20 ;
            spProf1 .YTD_Opportunities_won__c = 10 ;
            spProf1 .Goal_12m_Avg_Selling_Price__c  = 20 ;
            spProf1 .Current_Fiscal_Months__c = 2 ;
            insert spProf1 ;
             
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
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;  
            fw.levelName = 'Region';
            fw.levelValue = 'US West';
            fw.salesProfForCompLevel = spProf.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spProf);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            List<Company_Level_Junction_snapshot__c> cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl); 
             
            insert cs;
            
            test.startTest();
            PageReference myVfPage = Page.FunnelSalesDashboard;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Country');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Region');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , val); 
            
            FunnelReporting_Controller fc = new FunnelReporting_Controller();                        

            fc.fw.labelOne = 'Country';
            fc.fw.labelTwo = 'Region';
            fc.fw.labelThree = 'Role';
            fc.fw.SelectedLevelOne = 'US';
            fc.fw.SelectedLevelTwo = 'All';
            fc.fw.SelectedLevelThree = val;
            
            fc.showUpdated();
            system.assertEquals(fc.chartData.size(),1); 
            test.stopTest();
            
            
        }
                            
    } 
    
    
    static testmethod void testRoleAggregationWithSnapshot() {           
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        //insert r;
         
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
        insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps.Id );
        
        system.runAs(u2){
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            list<Sales_Rep_Profile__c> ss = new List<Sales_Rep_Profile__c >();
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            spMgr.YTD_Revenue__c = 100;
            spMgr.Month_1_Quota_Amount__c= 200;
            spMgr.YTD_Opportunity_Close_Rate__c = 10 ;
            spMgr.Goal_12m_rolling_close_rate__c = 20 ;
            spMgr.YTD_Opportunities_won__c = 10 ;
            spMgr.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spMgr.Current_Fiscal_Months__c = 2 ;
            String val = availableValues[0].getValue();
            spMgr.Role__c = val;
            
            insert spMgr;
            ss.add(spMgr);
            
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            //String val = availableValues[0].getValue();
            spProf.Role__c = val;
            spProf.YTD_Revenue__c = 100;
            spProf.Month_1_Quota_Amount__c= 200;
            spProf.YTD_Opportunity_Close_Rate__c = 10 ;
            spProf.Goal_12m_rolling_close_rate__c = 20 ;
            spProf.YTD_Opportunities_won__c = 10 ;
            spProf.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spProf.Current_Fiscal_Months__c = 2 ;
            insert spProf;
            ss.add(spProf);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spProf.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf1 = FunnelDataFactory.createSalesRep(fw);
            val = availableValues[0].getValue();
            spProf1 .Role__c = val;
            spProf1 .YTD_Revenue__c = 100;
            spProf1 .Month_1_Quota_Amount__c= 200;
            spProf1 .YTD_Opportunity_Close_Rate__c = 10 ;
            spProf1 .Goal_12m_rolling_close_rate__c = 20 ;
            spProf1 .YTD_Opportunities_won__c = 10 ;
            spProf1 .Goal_12m_Avg_Selling_Price__c  = 20 ;
            spProf1 .Current_Fiscal_Months__c = 2 ;
            insert spProf1 ;
             
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
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;  
            fw.levelName = 'Region';
            fw.levelValue = 'US West';
            fw.salesProfForCompLevel = spProf.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spProf);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            
            List<Company_Level_Junction_snapshot__c> cs = FunnelReporting_ControllerTest.createCompanyLevelJunctionSnapshots(cl,spsnap);  
            insert cs;
            
            test.startTest();
            PageReference myVfPage = Page.FunnelSalesDashboard;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Country');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Region');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , val); 
            
            FunnelReporting_Controller fc = new FunnelReporting_Controller();                        

            fc.fw.labelOne = 'Country';
            fc.fw.labelTwo = 'Region';
            fc.fw.labelThree = 'Role';
            fc.fw.SelectedLevelOne = 'US';
            fc.fw.SelectedLevelTwo = 'All';
            fc.fw.SelectedLevelThree = val;
            
            fc.showUpdated();
            system.assertEquals(fc.chartData.size(),1); 
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
            
            test.startTest();
            
            FunnelReporting_Controller fc = new FunnelReporting_Controller();                        

            fc.fw.labelOne = 'Country';
            fc.fw.labelTwo = 'Rep';
            fc.fw.labelThree = 'Role';
            fc.fw.SelectedLevelOne = 'US';
            fc.fw.SelectedLevelTwo = 'All';
            fc.fw.SelectedLevelThree = val;
            
            fc.reset();
            fc.levelOneAction();
            fc.levelTwoAction();
            fc.getData();
            fc.getQuotas();
            fc.getQuotaPercentage();
            fc.getRevenues();
            fc.getYtdCloseRates();
            fc.getYtdCloseRatesGoals();
            fc.getYtdOppWins();
            fc.getYtdOppWinsGoals();
            fc.getOppPercentage();
            fc.getDatabelow();
            fc.getQuotasbelow();
            fc.getQuotaPercentagebelow();
            
            fc.getRevenuesbelow();
            fc.getYtdCloseRatesbelow();
            fc.getYtdCloseRatesGoalsbelow();
            fc.getYtdOppWinsbelow();
            fc.getYtdOppWinsGoalsbelow();
            fc.getOppPercentagebelow();
            
            PageReference p = fc.navigateToCertification();
            system.assert(true,p.getUrl().contains('FunnelCerificationTable'));
            p = fc.navigateToCalculator();
            system.assert(true,p.getUrl().contains('FunnelCalculator'));
            p = fc.navigateToHomePage();
            system.assert(true,p.getUrl().contains('FunnelHomePage'));
            FunnelNavigationHelper fn = new FunnelNavigationHelper();
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
            p = fc.navigateToTrendingBySkill();
            p = fc.navigateToAnnualizationDashboard();
            p = fc.navigateToGoals();
            p = fc.navigateToHelpMenu();
            system.assert(true,p.getUrl().contains('supportandhelp'));
            p = fc.navigateToAnalytics();
            p = fc.navigateToFunnelAnalyticQualitative();
            p = fc.navigateToFunnelAnalytic();
            
            fc.breadCrumClick();
            test.stopTest();
        }
    }
      
    static testmethod void testTeamAggregationRep() {           
        
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
            test.startTest();
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            list<Sales_Rep_Profile__c> ss = new List<Sales_Rep_Profile__c >();
            List<Company_Level__c> csnap = new List<Company_Level__c>();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            spMgr.YTD_Revenue__c = 100;
            spMgr.Month_1_Quota_Amount__c= 200;
            spMgr.YTD_Opportunity_Close_Rate__c = 10 ;
            spMgr.Goal_12m_rolling_close_rate__c = 20 ;
            spMgr.YTD_Opportunities_won__c = 10 ;
            spMgr.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spMgr.Current_Fiscal_Months__c = 2 ;
            
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
            spProf.YTD_Opportunity_Close_Rate__c = 10 ;
            spProf.Goal_12m_rolling_close_rate__c = 20 ;
            spProf.YTD_Opportunities_won__c = 10 ;
            spProf.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spProf.Current_Fiscal_Months__c = 2 ;
            
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
            spProf1.YTD_Opportunity_Close_Rate__c = 10 ;
            spProf1.Goal_12m_rolling_close_rate__c = 20 ;
            spProf1.YTD_Opportunities_won__c = 10 ;
            spProf1.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spProf1.Current_Fiscal_Months__c = 2 ;
            insert spProf1;
            
            ss.add(spProf1);
            
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
            insert cs1;
               
            PageReference myVfPage = Page.FunnelReportingPage;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Region');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Rep');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US West');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , 'All'); 
                                 
            FunnelReporting_Controller fc = new FunnelReporting_Controller();
            system.assertEquals(fc.chartData.size(),1); 
            
            test.stopTest();
        }
      } 
      
      
      static testmethod void testTeamAggregationnull() {           
        
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
            test.startTest();
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            list<Sales_Rep_Profile__c> ss = new List<Sales_Rep_Profile__c >();
            List<Company_Level__c> csnap = new List<Company_Level__c>();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            spMgr.YTD_Revenue__c = null;
            spMgr.Month_1_Quota_Amount__c= null;
            spMgr.YTD_Opportunity_Close_Rate__c = null ;
            spMgr.Goal_12m_rolling_close_rate__c = null ;
            spMgr.YTD_Opportunities_won__c = null ;
            spMgr.Goal_12m_Avg_Selling_Price__c  = null ;
            spMgr.Current_Fiscal_Months__c = null ;
            
            insert spMgr;
            ss.add(spMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            spProf.YTD_Revenue__c = null;
            spProf.Month_1_Quota_Amount__c= null;
            spProf.YTD_Opportunity_Close_Rate__c = null ;
            spProf.Goal_12m_rolling_close_rate__c = null ;
            spProf.YTD_Opportunities_won__c = null ;
            spProf.Goal_12m_Avg_Selling_Price__c  = null ;
            spProf.Current_Fiscal_Months__c = null ;
            
            insert spProf;
            ss.add(spProf);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spProf.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf1 = FunnelDataFactory.createSalesRep(fw);
            spProf1.YTD_Revenue__c = null;
            spProf1.Month_1_Quota_Amount__c= null;
            spProf1.YTD_Opportunity_Close_Rate__c = null ;
            spProf1.Goal_12m_rolling_close_rate__c = null ;
            spProf1.YTD_Opportunities_won__c = null ;
            spProf1.Goal_12m_Avg_Selling_Price__c  = null ;
            spProf1.Current_Fiscal_Months__c = null ; 
            insert spProf1;
            
            ss.add(spProf1);
            
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(ss);
            integer i = spsnap.size();
            
            spsnap[i-1].Monthly_opp_won__c = 20;
            spsnap[i-1].Monthly_opp_lost__c= 20;
            spsnap[i-1].Monthly_Lead_Added__c= 20;
            spsnap[i-1].Monthly_Opportunities_added_to_Qualifie__c= 20;
            spsnap[i-1].X12_Month_Opprties_Added_to_the_funnel__c= 20;
            spsnap[i-1].X12_Month_Rolling_Average_Sales_Cycle__c= 20;
            spsnap[i-1].X12_Month_Average_Selling_Price__c = 20;
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
            insert cs1;
               
            PageReference myVfPage = Page.FunnelReportingPage;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Country');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Region');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , 'All'); 
                                 
            FunnelReporting_Controller fc = new FunnelReporting_Controller();
            system.assertEquals(fc.chartData.size(),1); 
            
            test.stopTest();
        }
                            
    }
    
    static testmethod void testRepScenarionull() {           
        
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
            spMgr.YTD_Revenue__c = null;
            spMgr.Month_1_Quota_Amount__c= null;
            spMgr.YTD_Opportunity_Close_Rate__c = null ;
            spMgr.Goal_12m_rolling_close_rate__c = null ;
            spMgr.YTD_Opportunities_won__c = null ;
            spMgr.Goal_12m_Avg_Selling_Price__c  = null ;
            spMgr.Current_Fiscal_Months__c =null ;
            insert spMgr;
            ss.add(spMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            spProf.YTD_Revenue__c = null;
            spProf.Month_1_Quota_Amount__c= null;
            spProf.YTD_Opportunity_Close_Rate__c = null ;
            spProf.Goal_12m_rolling_close_rate__c = null ;
            spProf.YTD_Opportunities_won__c = null ;
            spProf.Goal_12m_Avg_Selling_Price__c  = null ;
            spProf.Current_Fiscal_Months__c = null; 
            insert spProf;
            ss.add(spProf);
            
            
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(ss);
            
            integer i = spsnap.size();
            
            spsnap[i-1].Monthly_opp_won__c = 0;
            spsnap[i-1].Monthly_opp_lost__c= 0;
            spsnap[i-1].Monthly_Lead_Added__c= 0;
            spsnap[i-1].Monthly_Opportunities_added_to_Qualifie__c= 0;
            spsnap[i-1].X12_Month_Opprties_Added_to_the_funnel__c= 0;
            spsnap[i-1].X12_Month_Rolling_Average_Sales_Cycle__c= 0;
            spsnap[i-1].X12_Month_Average_Selling_Price__c = 0;
            
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
                       
            FunnelReporting_Controller fc = new FunnelReporting_Controller();
            system.assertEquals(fc.chartData.size(),1); 
            test.stopTest();
        }
                            
    }
    
    static testmethod void testRoleAggregationScenarionull() {           
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        //insert r;
         
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
        insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps.Id );
        
        system.runAs(u2){
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            list<Sales_Rep_Profile__c> ss = new List<Sales_Rep_Profile__c >();
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            spMgr.YTD_Revenue__c = null;
            spMgr.Month_1_Quota_Amount__c= null;
            spMgr.YTD_Opportunity_Close_Rate__c = null ;
            spMgr.Goal_12m_rolling_close_rate__c = null ;
            spMgr.YTD_Opportunities_won__c = null ;
            spMgr.Goal_12m_Avg_Selling_Price__c  = null ;
            spMgr.Current_Fiscal_Months__c = null ; 
            String val = availableValues[0].getValue();
            spMgr.Role__c = val;
            
            insert spMgr;
            ss.add(spMgr);
            
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            //String val = availableValues[0].getValue();
            spProf.Role__c = val;
            spProf.YTD_Revenue__c = null;
            spProf.Month_1_Quota_Amount__c= null;
            spProf.YTD_Opportunity_Close_Rate__c = null ;
            spProf.Goal_12m_rolling_close_rate__c = null ;
            spProf.YTD_Opportunities_won__c = null ;
            spProf.Goal_12m_Avg_Selling_Price__c  = null ;
            spProf.Current_Fiscal_Months__c = null ; 
            insert spProf;
            ss.add(spProf);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spProf.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf1 = FunnelDataFactory.createSalesRep(fw);
            val = availableValues[0].getValue();
            spProf1 .Role__c = val;
            spProf1 .YTD_Revenue__c = null;
            spProf1 .Month_1_Quota_Amount__c= null;
            spProf1 .YTD_Opportunity_Close_Rate__c = null ;
            spProf1 .Goal_12m_rolling_close_rate__c = null ;
            spProf1 .YTD_Opportunities_won__c = null ;
            spProf1 .Goal_12m_Avg_Selling_Price__c  = null ;
            spProf1 .Current_Fiscal_Months__c =null ; 
            insert spProf1 ;
             
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(ss);
            
            integer i = spsnap.size();
            
            spsnap[i-1].Monthly_opp_won__c = 30;
            spsnap[i-1].Monthly_opp_lost__c= 30;
            spsnap[i-1].Monthly_Lead_Added__c= 30;
            spsnap[i-1].Monthly_Opportunities_added_to_Qualifie__c= 30;
            spsnap[i-1].X12_Month_Opprties_Added_to_the_funnel__c= 30;
            spsnap[i-1].X12_Month_Rolling_Average_Sales_Cycle__c= 30;
            spsnap[i-1].X12_Month_Average_Selling_Price__c = 30;
            
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
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;  
            fw.levelName = 'Region';
            fw.levelValue = 'US West';
            fw.salesProfForCompLevel = spProf.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spProf);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            List<Company_Level_Junction_snapshot__c> cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
            insert cs;
            
            test.startTest();
            PageReference myVfPage = Page.FunnelSalesDashboard;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Country');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Region');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , val); 
            
            FunnelReporting_Controller fc = new FunnelReporting_Controller();                        

            fc.fw.labelOne = 'Country';
            fc.fw.labelTwo = 'Region';
            fc.fw.labelThree = 'Role';
            fc.fw.SelectedLevelOne = 'US';
            fc.fw.SelectedLevelTwo = 'All';
            fc.fw.SelectedLevelThree = val;
            
            fc.showUpdated();
            system.assertEquals(fc.chartData.size(),1); 
            test.stopTest();
        }
                            
    } 
    
           
        
        
    static testmethod void testTeamAggregationRepnull() {           
        
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
            test.startTest();
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            list<Sales_Rep_Profile__c> ss = new List<Sales_Rep_Profile__c >();
            List<Company_Level__c> csnap = new List<Company_Level__c>();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            spMgr.YTD_Revenue__c = null;
            spMgr.Month_1_Quota_Amount__c= null;
            spMgr.YTD_Opportunity_Close_Rate__c = null ;
            spMgr.Goal_12m_rolling_close_rate__c = null ;
            spMgr.YTD_Opportunities_won__c = null ;
            spMgr.Goal_12m_Avg_Selling_Price__c  = null ;
            spMgr.Current_Fiscal_Months__c = null ; 
            
            insert spMgr;
            ss.add(spMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            spProf.YTD_Revenue__c = null;
            spProf.Month_1_Quota_Amount__c= null;
            spProf.YTD_Opportunity_Close_Rate__c = null ;
            spProf.Goal_12m_rolling_close_rate__c = null ;
            spProf.YTD_Opportunities_won__c = null ;
            spProf.Goal_12m_Avg_Selling_Price__c  = null ;
            spProf.Current_Fiscal_Months__c = null ; 
            
            insert spProf;
            ss.add(spProf);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spProf.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf1 = FunnelDataFactory.createSalesRep(fw);
            spProf1.YTD_Revenue__c = null;
            spProf1.Month_1_Quota_Amount__c= null;
            spProf1.YTD_Opportunity_Close_Rate__c = null ;
            spProf1.Goal_12m_rolling_close_rate__c = null ;
            spProf1.YTD_Opportunities_won__c = null ;
            spProf1.Goal_12m_Avg_Selling_Price__c  = null ;
            spProf1.Current_Fiscal_Months__c = null ; 
            insert spProf1;
            
            ss.add(spProf1);
            
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(ss);
            
            integer i = spsnap.size();
            
            spsnap[i-1].Monthly_opp_won__c = null;
            spsnap[i-1].Monthly_opp_lost__c= null;
            spsnap[i-1].Monthly_Lead_Added__c= null;
            spsnap[i-1].Monthly_Opportunities_added_to_Qualifie__c= null;
            spsnap[i-1].X12_Month_Opprties_Added_to_the_funnel__c= null;
            spsnap[i-1].X12_Month_Rolling_Average_Sales_Cycle__c= null;
            spsnap[i-1].X12_Month_Average_Selling_Price__c = null;
            
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
            insert cs1;
               
            PageReference myVfPage = Page.FunnelReportingPage;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Region');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Rep');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US West');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , 'All'); 
                                 
            FunnelReporting_Controller fc = new FunnelReporting_Controller();
            system.assertEquals(fc.chartData.size(),1); 
            
            test.stopTest();
        }
      } 
      
      //create Company_Level_Junction_snapshot__c
    
        private static List<Company_Level_Junction_snapshot__c> createCompanyLevelJunctionSnapshots(List<Company_Level__c> sp, List<Sales_rep_profile_snapshot__c> srp){
            
            List<Company_Level_Junction_snapshot__c> cl = new List<Company_Level_Junction_snapshot__c>();
            
            
            for(Company_Level__c s: sp){
                date sdate = Date.newInstance(2019, 2, 28);
                integer lastDay ;
                for(integer i = 0; i < 12 ; i ++){
                    Company_Level_Junction_snapshot__c c = new Company_Level_Junction_snapshot__c (Company_Level__c = s.id,
                                                           Sales_Rep_Profile__c = s.Sales_Rep_Profile__c,Snapshot_Scheduled_Date__c =sdate,
                                                           Sales_rep_profile_snapshot__c = srp[i].id);
                    cl.add(c);
                    sdate = sdate .addMonths(-1);
                    lastDay = Date.daysInMonth(sdate.year(), sdate.month());
                    sdate = Date.newInstance(sdate.year(), sdate.month(), lastDay); 
                }
            }
            //system.assertEquals(cl.size(),sp.size());                                           
            return cl;
        }
        
        
    static testmethod void testRoleAggregationScenarioForSnapshot() {           
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        //insert r;
         
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
        insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps.Id );
        
        system.runAs(u2){
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            list<Sales_Rep_Profile__c> ss = new List<Sales_Rep_Profile__c >();
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            spMgr.YTD_Revenue__c = 100;
            spMgr.Month_1_Quota_Amount__c= 200;
            spMgr.YTD_Opportunity_Close_Rate__c = 10 ;
            spMgr.Goal_12m_rolling_close_rate__c = 20 ;
            spMgr.YTD_Opportunities_won__c = 10 ;
            spMgr.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spMgr.Current_Fiscal_Months__c = 2 ;
            String val = availableValues[0].getValue();
            spMgr.Role__c = val;
            
            insert spMgr;
            ss.add(spMgr);
            
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            //String val = availableValues[0].getValue();
            spProf.Role__c = val;
            spProf.YTD_Revenue__c = 100;
            spProf.Month_1_Quota_Amount__c= 200;
            spProf.YTD_Opportunity_Close_Rate__c = 10 ;
            spProf.Goal_12m_rolling_close_rate__c = 20 ;
            spProf.YTD_Opportunities_won__c = 10 ;
            spProf.Goal_12m_Avg_Selling_Price__c  = 20 ;
            spProf.Current_Fiscal_Months__c = 2 ;
            spProf.Active__c = true;
            
            insert spProf;
            ss.add(spProf);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spProf.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf1 = FunnelDataFactory.createSalesRep(fw);
            val = availableValues[0].getValue();
            spProf1 .Role__c = val;
            spProf1 .YTD_Revenue__c = 100;
            spProf1 .Month_1_Quota_Amount__c= 200;
            spProf1 .YTD_Opportunity_Close_Rate__c = 10 ;
            spProf1 .Goal_12m_rolling_close_rate__c = 20 ;
            spProf1 .YTD_Opportunities_won__c = 10 ;
            spProf1 .Goal_12m_Avg_Selling_Price__c  = 20 ;
            spProf1 .Current_Fiscal_Months__c = 2 ;
            insert spProf1 ;
             
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(ss);
            insert spsnap ;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgr.id;
            
            
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            sp.add(spProf);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);
                                   
            insert cl;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;  
            fw.levelName = 'Region';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spProf.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spProf);
            
            cl = FunnelDataFactory.createCompanyLevel(fw,sp); 
            cl[0].Level_value__c = 'US';                        
            insert cl;
            
            Sales_rep_profile_snapshot__c sn = new Sales_rep_profile_snapshot__c(Active__c = true);
            insert sn;
            
            List<Company_Level_Junction_snapshot__c> cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl); 
            cs[0].Sales_rep_profile_snapshot__c = sn.id; 
            insert cs;
            
            test.startTest();
            PageReference myVfPage = Page.FunnelSalesDashboard;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Country');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Region');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , val); 
            
            FunnelReporting_Controller fc = new FunnelReporting_Controller();                        

            fc.fw.labelOne = 'Country';
            fc.fw.labelTwo = 'Region';
            fc.fw.labelThree = 'Role';
            fc.fw.SelectedLevelOne = 'US';
            fc.fw.SelectedLevelTwo = 'All';
            fc.fw.SelectedLevelThree = val;
            system.debug(' meth snap ');
            fc.showUpdated();
            system.assertEquals(cl.size(),sp.size()); 
            test.stopTest();

        }
                            
    } 
}