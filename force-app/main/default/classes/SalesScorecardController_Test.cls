@isTest
public class SalesScorecardController_Test {
    public class MetadataServiceMock implements WebServiceMock, HttpCalloutMock {
		public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, String requestName, String responseNS, String responseName, String responseType) {
			if (request instanceOf MetadataService.updateMetadata_element) {
				MetadataService.updateMetadataResponse_element responseUpdate = new MetadataService.updateMetadataResponse_element();
				responseUpdate.result = new MetadataService.SaveResult[] { };
				response.put('response_x', responseUpdate);
			}
			else if (request instanceOf MetadataService.deleteMetadata_element) {
				MetadataService.deleteMetadataResponse_element responseDelete = new MetadataService.deleteMetadataResponse_element();
				responseDelete.result = new MetadataService.DeleteResult[] { };
				response.put('response_x', responseDelete);
			}
			else {
				Assert.fail('Unexpected request: ' + request);
			}
		}
		
		public HTTPResponse respond(HTTPRequest req) {
			HTTPResponse res = new HTTPResponse();
			res.setBody('{}');
			res.setStatusCode(200);
			return res;
		}
	}
 
   @isTest
    public static void testData1(){
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());
        
        
        Sales_rep_profile_snapshot__c salesrep = new Sales_rep_profile_snapshot__c();
        salesrep.Name='test';
        insert salesrep;
        
        Application_Setting__c appSetting = new Application_Setting__c();
        appSetting.name='test';
        appSetting.Leads_used__c=true;
        appSetting.Meetings_used__c=true;
        insert appSetting;
        
        DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
        List<PicklistEntry> availableValues = describe.getPicklistValues();
        String val = availableValues[0].getValue();
        
        
        
        Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
        insert fiscalYr;
        
        Sales_Rep_Profile__c srp = new Sales_Rep_Profile__c();
        srp.User_Record_Name__c=userinfo.getUserId();
        srp.Name='test';
        srp.Active__c=true;
        srp.User_Record_Name__c=Userinfo.getUserId();
        srp.Profile_Type__c='Overlay';
        srp.Average_Deal_Size__c=12;
        srp.Goal_Average_Deal_Size__c=20;
        srp.Current_Pipeline__c=25;
        srp.YTD_Revenue__c=565;
        srp.Month_1_Quota_Amount__c=152;
        srp.YTD_Opportunities_won__c=15;
        srp.Average_Deal_Size__c=15;
        srp.YTD_Leads_Added__c=2;
        srp.YTD_Lead_Converted__c=2;
        srp.YTD_Average_Sales_Cycle__c=3;
        srp.X12_Month_Rolling_Opptys_Won__c=3;
        srp.X12_Month_Rolling_Revenue__c=9;
        //srp.Level_picklist_1__c='Halsted Corporation';
        
        insert srp;
        
        list<Sales_Rep_Profile__c> srp2=new list<Sales_Rep_Profile__c>();
        
        Sales_Rep_Profile__c srp1 = new Sales_Rep_Profile__c();
        srp1.Name='test';
        srp1.Active__c=true;
        srp1.User_Record_Name__c=Userinfo.getUserId();
        srp1.Average_Deal_Size__c=12;
        srp1.Goal_Average_Deal_Size__c=20;
        srp1.Current_Pipeline__c=25;
        srp1.Average_Deal_Size__c=12;
        srp1.Goal_Average_Deal_Size__c=20;
        srp1.Current_Pipeline__c=25;
        srp1.YTD_Revenue__c=565;
        srp1.Month_1_Quota_Amount__c=152;
        srp1.YTD_Opportunities_won__c=15;
        srp1.Average_Deal_Size__c=15;
        srp1.YTD_Leads_Added__c=2;
        srp1.YTD_Lead_Converted__c=2;
        srp1.YTD_Average_Sales_Cycle__c=3;
        srp1.X12_Month_Rolling_Opptys_Won__c=3;
        srp1.X12_Month_Rolling_Revenue__c=9;
        //srp1.Level_picklist_1__c='Halsted Corporation';
        srp2.add(srp1);
        insert srp2;
        
        
        Company_Level__c  compLevel= new Company_Level__c();
        compLevel.Level_Name__c='Regions';
        //compLevel.Level_Value__c='US East';
        compLevel.Sales_Rep_Profile__c=srp2[0].id;
        compLevel.Order__c = 4;
        insert compLevel;
        
        Sales_Profile_Company_Level_Junction__c salesProfile = new Sales_Profile_Company_Level_Junction__c();
        salesProfile.Sales_Rep_Profile__c=srp2[0].id;
        salesProfile.Company_Level__c=compLevel.id;
        insert salesProfile;
        
        Certification_Rating__c cr = new Certification_Rating__c();
        cr.Assessment_type__c = 'Qualitative';   
        cr.Calculation_type__c = 'Y/N';
        cr.Category__c = 'Test';            
        cr.User_Type__c = 'New';
        cr.Timing__c = 'End of month';
        cr.Weight__c = '4';
        cr.Description__c = 'Test description 1';
        cr.Roles_Enabled__c =  availableValues[0].getValue();
        cr.Important_flag__c = true;
        cr.Importance__c = 1;
        insert cr;
    
        
        ApexPages.currentPage().getparameters().put('labelOne' , 'Country');
        ApexPages.currentPage().getparameters().put('labelTwo' , 'Rep');
        ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
        ApexPages.currentPage().getparameters().put('selectOne' , 'US');
        ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
        ApexPages.currentPage().getparameters().put('selectThree' , 'All'); 
        
        //SalesScorecardController var = new SalesScorecardController();
        //var.Data('sm', srp.id);
        
         //SalesScorecardController var2 = new SalesScorecardController();
        //var2.Data('sm', srp.id);
        
        
      /*  SalesScorecardController var3= new SalesScorecardController();
        var3.Data(srp.id, srp.id);*/
        
      /*  SalesScorecardController var1 = new SalesScorecardController();
        var1.Data(srp.id, srp1.id); */
        
        PageReference pref = Page.Funnelhomepage1; 
        Test.setCurrentPage(pref);
        
        Test.startTest();
        //var.fw.selectedLevelFour = srp.id;
        //var.selectedType='test';
        //var.fw.labelone='Country 1';
        
        //var.PopulateMetricOrSkill();
        //var.ExecuteChart();
        //var.levelTwoAction();
        //var.levelOneAction();
        //var2.fw.selectedLevelFour = srp.id;
       // var3.fw.selectedLevelFour = srp.id;
        
        SalesScorecardController.filterWrappers filterWrapper = new SalesScorecardController.filterWrappers();
        filterWrapper.selectedTypeOne = 'Type1';
        filterWrapper.selectTypeList = new List<String>{'Metrics', 'Skills'};
        filterWrapper.selectPeriodList = new List<String>{'Jan', 'Feb', 'Mar'};
        filterWrapper.selectMetricOrSkillList = new List<String>{'Metric1', 'Skill1', 'Metric2'};
            
            SalesScorecardController.Data data = new SalesScorecardController.Data('Name', 1, 2, 3, 4, 5);
        data.data7=1.0;
        data.data8=1.0;
        data.data9=1.0;
        data.data10=1.0;
        data.data11=1.0;
        data.data11=1.0;
        data.data12=1.0;
        

        
        SalesScorecardController.Data data3 = new SalesScorecardController.Data('Name', 1);
        //SalesScorecardController.Data1 data1 = new SalesScorecardController.Data1('Name', 1.0, 2.0, 3,1.0);
        SalesScorecardController.Data2 data2 = new SalesScorecardController.Data2('Sales Rep', 1.0, 2.0);
        SalesScorecardController.Data2 data4 = new SalesScorecardController.Data2('Sales Rep', 1.0, 2.0,3.0);
        data2.name='test';
        Test.stopTest();
        
        
    }
    
    @isTest
    public static void testData2(){
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
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 5;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u5 = us[0];
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id );         
        
        system.runAs(u){
            
            test.startTest();
            List<Sales_Rep_Profile__c > splist= new List<Sales_Rep_Profile__c >();
            
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 4;
            fw.userId = u4.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgrMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgrMgr;
            splist.add(spMgrMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            fw.salesMgr = spMgrMgr.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgr;
            splist.add(spMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 5;
            fw.userId = u5.id;
            fw.salesMgr = spMgrMgr.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr2 = FunnelDataFactory.createSalesRep(fw);
            insert spMgr2;
            splist.add(spMgr2);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            spProf.Quarterly_Opportunities_added_to_Qualifi__c = 5;
            spProf.Quarterly_Lead_Added__c = 5;
            spProf.Quarterly_Quota_Revenue__c = 500;
            spProf.Month_1_Quota_Amount__c= 500;
            spProf.YTD_Revenue__c = 500;
            spProf.X12_Month_Rolling_Opportunity_Close_Rate__c = 50;
            insert spProf;
            
            Sales_Rep_Profile_Snapshot__c snap = new Sales_Rep_Profile_Snapshot__c();
            snap.Sales_Rep_Profile__c = spProf.id;
            snap.Name = 'Test';
            snap.Snapshot_Scheduled_Date__c = date.newInstance(date.today().year() - 1, 12, 31);
            insert snap;
            
            splist.add(spProf);
            
            Sales_Rep_Profile__c srp = new Sales_Rep_Profile__c();
            srp.Name='test';
            srp.Active__c=true;
            srp.User_Record_Name__c=Userinfo.getUserId();
            srp.Profile_Type__c='Overlay';
            srp.Average_Deal_Size__c=12;
            srp.Goal_Average_Deal_Size__c=20;
            srp.Current_Pipeline__c=25;
            srp.YTD_Revenue__c=565;
            srp.Month_1_Quota_Amount__c=152;
            srp.YTD_Opportunities_won__c=15;
            srp.Average_Deal_Size__c=15;
            srp.YTD_Leads_Added__c=2;
            srp.YTD_Lead_Converted__c=2;
            srp.YTD_Average_Sales_Cycle__c=3;
            srp.X12_Month_Rolling_Opptys_Won__c=3;
            srp.X12_Month_Rolling_Revenue__c=9;
            srp.Level_picklist_1__c='Halsted Corporation';
            splist.add(srp);
            
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf1 = FunnelDataFactory.createSalesRep(fw);
            spProf1.Quarterly_Opportunities_added_to_Qualifi__c = 5;
            spProf1.Quarterly_Lead_Added__c = 5;
            spProf1.Quarterly_Quota_Revenue__c = 500;
            spProf1.Month_1_Quota_Amount__c= 500;
            spProf1.YTD_Revenue__c = 500;
            spProf1.X12_Month_Rolling_Opportunity_Close_Rate__c = 50;
            insert spProf1;
            splist.add(spProf1);
            
            List<YTD_Quota_Revenue__c> yrq = FunnelDataFactory.createPriorYearResult(splist);   
            
            yrq[3].YTD_Revenue__c = 200;
            yrq[3].X12_Month_Rolling_Average_Sales_Cycle__c = 20;
            yrq[3].X12_Month_Average_Selling_Price__c = 200;
            yrq[3].X12_Month_Opprties_Added_to_the_funnel__c = 20;
            yrq[3].X12_Month_Leads_Added__c = 35;
            
            yrq[4].YTD_Revenue__c = 200;
            yrq[4].X12_Month_Rolling_Average_Sales_Cycle__c = 20;
            yrq[4].X12_Month_Average_Selling_Price__c = 200;
            yrq[4].X12_Month_Opprties_Added_to_the_funnel__c = 20;
            yrq[4].X12_Month_Leads_Added__c = 35;           
            
            insert yrq;
            
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
            fw.levelName = 'Country';
            fw.levelValue = 'Canada';
            fw.salesProfForCompLevel = spMgr2.id;
           
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;  
            fw.levelName = 'Company';
            fw.levelValue = 'Funnel Metrics';
            fw.salesProfForCompLevel = spMgrMgr.id;
            
           /* sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgrMgr);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;*/
            
            //SalesScorecardController  fc = new SalesScorecardController ();
            //fc.CalculateData2();
          //  system.assertEquals(fc.YTDQuotaPerformance,1000);
            test.stopTest();
        }
    }
    
    static testmethod void testRoleAggregationScenario() {
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());           
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        //fw.userRoleId = r.id;
        
        List<User> us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u = us[0];
        
        List<User> userListcomp = FunnelDataFactory.createUser(fw,10);
        insert userListcomp;
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 2;
        fw.profileId = profileId;        
        //fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u2 = us[0];
        system.debug(' user '+u2);
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 3;
        fw.profileId = profileId;        
        //fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u3 = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 4;
        fw.profileId = profileId;        
        //fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u4 = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 5;
        fw.profileId = profileId;        
        //fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u5 = us[0];
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps.Id );  
        
        system.runAs(u2){
            List<Sales_Rep_Profile__c > splist= new List<Sales_Rep_Profile__c >();
            
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 4;
            fw.userId = u4.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgrMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgrMgr;
            splist.add(spMgrMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            fw.salesMgr = spMgrMgr.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            
            insert spMgr;
            splist.add(spMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 5;
            fw.userId = u5.id;
            fw.salesMgr = spMgrMgr.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr2 = FunnelDataFactory.createSalesRep(fw);
            insert spMgr2;
            splist.add(spMgr2);
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            //String val = availableValues[0].getValue();
            //spProf.Role__c = val;
            spProf.Quarterly_Opportunities_added_to_Qualifi__c = 5;
            spProf.Quarterly_Lead_Added__c = 5;
            spProf.Quarterly_Quota_Revenue__c = 500;
            spProf.Month_1_Quota_Amount__c= 500;
            spProf.YTD_Revenue__c = 500;
            spProf.X12_Month_Rolling_Opportunity_Close_Rate__c = 50;
            insert spProf;
            splist.add(spProf);
            
            Sales_Rep_Profile_Snapshot__c snap = new Sales_Rep_Profile_Snapshot__c();
            snap.Sales_Rep_Profile__c = spProf.id;
            snap.Name = 'Test';
            snap.Snapshot_Scheduled_Date__c = date.newInstance(date.today().year() - 1, 12, 31);
            insert snap;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spMgr2.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf1 = FunnelDataFactory.createSalesRep(fw);
            //spProf1.Role__c = val;
            spProf1.Quarterly_Opportunities_added_to_Qualifi__c = 5;
            spProf1.Quarterly_Lead_Added__c = 5;
            spProf1.Quarterly_Quota_Revenue__c = 500;
            spProf1.Month_1_Quota_Amount__c= 500;
            spProf1.YTD_Revenue__c = 500;
            spProf1.X12_Month_Rolling_Opportunity_Close_Rate__c = 50;
            spProf1.Active__c=true;
            spProf1.Profile_Type__c='';
            insert spProf1;
            splist.add(spProf1);
            
            List<YTD_Quota_Revenue__c> yrq = FunnelDataFactory.createPriorYearResult(splist);   
            
            yrq[3].YTD_Revenue__c = 200;
            yrq[3].X12_Month_Rolling_Average_Sales_Cycle__c = 20;
            yrq[3].X12_Month_Average_Selling_Price__c = 200;
            yrq[3].X12_Month_Opprties_Added_to_the_funnel__c = 20;
            yrq[3].X12_Month_Leads_Added__c = 35;
            
            yrq[4].YTD_Revenue__c = 200;
            yrq[4].X12_Month_Rolling_Average_Sales_Cycle__c = 20;
            yrq[4].X12_Month_Average_Selling_Price__c = 200;
            yrq[4].X12_Month_Opprties_Added_to_the_funnel__c = 20;
            yrq[4].X12_Month_Leads_Added__c = 35;
            
            insert yrq;
            system.debug('yyyyy'+yrq);
            
            List<Certification_Rating__c> rating = new List<Certification_Rating__c>();
            
            Certification_Rating__c cr = new Certification_Rating__c();
            cr.Assessment_type__c = 'Qualitative';   
            cr.Calculation_type__c = 'Y/N';
            cr.Category__c = 'Test';            
            cr.User_Type__c = 'New';
            cr.Timing__c = 'End of month';
            cr.Weight__c = '4';
            cr.Description__c = 'Test description 1';
            //cr.Roles_Enabled__c =  availableValues[0].getValue();
            cr.Important_flag__c = true;
            cr.Importance__c = 1;
            cr.Name='YTD Quota Performance';
            rating.add(cr);
            
            cr = new Certification_Rating__c();
            cr.Assessment_type__c = 'Quantitative';   
            cr.Category__c = 'Test';            
            cr.User_Type__c = 'New';
            cr.Timing__c = 'End of month';
            cr.Weight__c = '4';
            cr.Description__c = 'Test description 1';
            //cr.Roles_Enabled__c =  availableValues[0].getValue();
            cr.Important_flag__c = true;
            cr.Importance__c = 1;
            cr.Name='YTD Quota Performance';
            rating.add(cr);
            
            insert rating ;
            
            List<Certification_Rating__c> certRatings = FunnelDataFactory.createCertificationRatings(fw,1);
            certRatings[0].Timing__c = 'End of quarter';
            certRatings[0].Description__c= 'Test';
            certRatings[0].Agg__c= 'SUM';
            certRatings[0].Goal_field_name__c= 'Goal_12m_Avg_Selling_Price__c';
            certRatings[0].SRP_Field_Name__c= 'X12_Month_Average_Selling_Price__c';
            certRatings[0].Display_Custom_Metric__c= true;
            
            insert certRatings;
            
            
            List<Sales_Rep_Profile__c> spcomp = FunnelDataFactory.createSalesReplist(userListcomp);
            //spcomp[0].Role__c='Sales Executive';
            insert spcomp;
            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,spcomp);
            insert certs;
            
            
            
            Important_rating__c i = FunnelDataFactory.createImportantRating(rating[0].id,availableValues[0].getValue());
            insert i;
            
            Important_rating__c iq = FunnelDataFactory.createImportantRating(rating[1].id,availableValues[0].getValue());
            insert iq;
            
            
            
            List<Certification__c> cerList = FunnelDataFactory.createCertification(fw,splist); 
            cerList[0].Overall_Rating__c = 0;
            cerList[0].Overall_Qualitative_Rating__c = 0;
            cerList[0].Overall_Quantitative_Rating__c = 5;
            
            
            cerList[1].Overall_Rating__c = 10;
            cerList[1].Overall_Qualitative_Rating__c = 10;
            cerList[1].Overall_Quantitative_Rating__c = 5;
            
            
            cerList[2].Overall_Rating__c = 5;
            cerList[2].Overall_Qualitative_Rating__c = 5;
            cerList[2].Overall_Quantitative_Rating__c = 5;
            
            cerList[3].Overall_Rating__c = 0;
            cerList[3].Overall_Qualitative_Rating__c = 5;
            cerList[3].Overall_Quantitative_Rating__c = 5;
            
            cerList[4].Overall_Rating__c = null;
            cerList[4].Overall_Qualitative_Rating__c = 5;
            cerList[4].Overall_Quantitative_Rating__c = 5;
            
            insert cerList ;
            
            List<Certification_Answer__c> anslist = new List<Certification_Answer__c>();
            
            Certification_Answer__c crep = new Certification_Answer__c();
            
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 0.00;
            crep.Sales_Rep_Profile__c= spMgr.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[0].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 2.00;
            crep.Sales_Rep_Profile__c= spMgr.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[1].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 5.00;
            crep.Sales_Rep_Profile__c= spMgr.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[1].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 8.00;
            crep.Sales_Rep_Profile__c= spMgr.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[1].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 5.00;
            crep.Sales_Rep_Profile__c= spProf.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[2].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 8.00;
            crep.Sales_Rep_Profile__c= spProf1.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[3].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 10.00;
            crep.Sales_Rep_Profile__c= spMgr.id;
            crep.Certifcation_Rating__c = rating[1].id;
            crep.Certifcation__c =cerList[0].id;
            anslist.add(crep);
            
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 10.00;
            crep.Sales_Rep_Profile__c= spMgr.id;
            crep.Certifcation_Rating__c = rating[1].id;
            crep.Certifcation__c =cerList[1].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 8.00;
            crep.Sales_Rep_Profile__c= spProf.id;
            crep.Certifcation_Rating__c = rating[1].id;
            crep.Certifcation__c =cerList[2].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 5.00;
            crep.Sales_Rep_Profile__c= spProf1.id;
            crep.Certifcation_Rating__c = rating[1].id;
            crep.Certifcation__c =cerList[3].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 5.00;
            crep.Sales_Rep_Profile__c= spProf1.id;
            crep.Certifcation_Rating__c = rating[1].id;
            crep.Certifcation__c =cerList[4].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 5.00;
            crep.Sales_Rep_Profile__c= spProf1.id;
            crep.Certifcation_Rating__c = rating[1].id;
            crep.Certifcation__c =cerList[4].id;
            anslist.add(crep);
            
            
            insert anslist;
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp); 
            Company_Level__c cl1 =new Company_Level__c();
                
            cl1.Level_Name__c = 'test';
            cl1.Level_Value__c = '';
            cl1.Order__c = 2;
            cl1.Sales_Rep_Profile__c = spMgr.id;
            cl.add(cl1);
            insert cl;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;  
            fw.levelName = 'Country';
            fw.levelValue = 'Canada';
            fw.salesProfForCompLevel = spMgr2.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr2);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);
            for(Company_Level__c c : cl){
                c.Order__c = 1;
            }
            //insert cl;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;  
            fw.levelName = 'Company';
            fw.levelValue = 'Funnel Metrics';
            fw.salesProfForCompLevel = spMgrMgr.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgrMgr);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            
            
            
            test.startTest();
            PageReference myVfPage = Page.FunnelSalesDashboard;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Country');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Rep');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , 'All'); 
            
            SalesScorecardController  fc = new SalesScorecardController ();                        
            
            fc.fw.labelOne = 'Country';
            fc.fw.labelTwo = 'Rep';
            fc.fw.labelThree = 'Role';
            fc.fw.SelectedLevelOne = 'US';
            fc.fw.SelectedLevelTwo = 'All';
            fc.fw.SelectedLevelThree = 'All';
            
            
            
            //fc.showUpdated();
            //fc.fw.SelectedLevelThree = 'All';
            //fc.fw.SelectedLevelFour = spcomp[0].id;
            Date d=Date.today()-1;


            fc.fw.labelTwo = '';
          	fc.showUpdated();
            spProf.Profile_Type__c='Overlay';
            spProf.Average_Deal_Size__c=20;
            spProf.Goal_Average_Deal_Size__c=40;
            spProf.Current_Pipeline__c=33;
            update spProf;
            //system.assertEquals(fc.YTDQuotaPerformance,500);
            test.stopTest();
        }
        
    } 
    static testmethod void testNavigation() {
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());           
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        
        
        List<Certification_Rating__c> rating = new List<Certification_Rating__c>();
        Certification_Rating__c cr = new Certification_Rating__c();
        cr.Assessment_type__c = 'Quantitative';   
        cr.Category__c = 'Test';            
        cr.User_Type__c = 'New';
        cr.Timing__c = 'End of month';
        cr.Weight__c = '4';
        cr.Description__c = 'Test description 1';
        //cr.Roles_Enabled__c =  availableValues[0].getValue();
        cr.Important_flag__c = true;
        cr.Importance__c = 1;
        cr.Name='YTD Quota Performance';
        rating.add(cr);
        insert rating;
        
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
        //insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps.Id );
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
            //spProf.Role__c = val;
            insert spProf;
            
            Sales_Rep_Profile_Snapshot__c snap = new Sales_Rep_Profile_Snapshot__c();
            snap.Sales_Rep_Profile__c = spProf.id;
            snap.Name = 'Test';
            snap.Snapshot_Scheduled_Date__c = date.newInstance(date.today().year() - 1, 12, 31);
            insert snap;
            
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
            
            SalesScorecardController  fc = new SalesScorecardController ();                        

            SalesScorecardController  fc1 = new SalesScorecardController ();
            
            //fc1.fw.labelOne = null;
            
            //fc1.navigateToDetailPage();

            
            /*fc1.fw.labelOne = 'Country';
            fc1.fw.labelTwo = 'Rep';
            fc1.fw.labelThree = 'Role';
            fc1.fw.SelectedLevelOne = 'US';
            fc1.fw.SelectedLevelTwo = 'All';
            fc1.fw.SelectedLevelThree = 'All';*/
            
            fc1.reset();
            fc.levelOneAction();
            
            /*fc.navigateToCertification();
            fc.navigateToCalculator();
            fc.navigateToHomePage();
            fc.navigateToReportsPage();
            fc.navigateToAppSetup();
            fc.navigateToCertificateReports();
            fc.navigateToDashboard();*/
            
            /*PageReference p = fc1.navigateToCertification();
            system.assert(true,p.getUrl().contains('FunnelCerificationTable'));
            PageReference p = fc1.navigateToCalculator();
            system.assert(true,p.getUrl().contains('FunnelScorecard '));
            p = fc1.navigateToHomePage();
            system.assert(true,p.getUrl().contains('FunnelHomePage'));
            p = fc1.navigateToDashboard();
            system.assert(true,p.getUrl().contains('FunnelSalesDashboard'));
            p = fc1.navigateToReportsPage();
            system.assert(true,p.getUrl().contains('FunnelReportingPage'));
            p = fc.navigateToAppSetup();
            system.assert(true,p.getUrl().contains('FunnelSalesCertification'));
            p = fc.navigateToCertificateReports();
            system.assert(true,p.getUrl().contains('FunnelCerificationReports'));
            system.assert(true,p.getUrl().contains('navigateToAnalytics'));
            p = fc.navigateToFunnelAnalyticQualitative();
            system.assert(true,p.getUrl().contains('navigateToFunnelAnalyticQualitative'));
            p = fc.navigateToFunnelAnalytic();
            system.assert(true,p.getUrl().contains('navigateToFunnelAnalytic'));  
            
            p = fc1.navigateToDetailPage();
            system.assert(true,p.getUrl().contains('FunnelCertificationDetail'));*/
            
            test.stopTest();
        }
        
    }
    
    
    static testmethod void testconvert() {
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());   
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
        //fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u2 = us[0];
        system.debug(' user '+u2);
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        //insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps.Id );  
        
        List<Certification_Rating__c> rating = new List<Certification_Rating__c>();
        Certification_Rating__c cr = new Certification_Rating__c();
        cr.Assessment_type__c = 'Quantitative';   
        cr.Category__c = 'Test';            
        cr.User_Type__c = 'New';
        cr.Timing__c = 'End of month';
        cr.Weight__c = '4';
        cr.Description__c = 'Test description 1';
        //cr.Roles_Enabled__c =  availableValues[0].getValue();
        cr.Important_flag__c = true;
        cr.Importance__c = 1;
        cr.Name='YTD Quota Performance';
        rating.add(cr);
        insert rating;
        
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
            
            Sales_Rep_Profile_Snapshot__c snap = new Sales_Rep_Profile_Snapshot__c();
            snap.Sales_Rep_Profile__c = spProf.id;
            snap.Name = 'Test';
            snap.Snapshot_Scheduled_Date__c = date.newInstance(date.today().year() - 1, 12, 31);
            insert snap;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            sp.add(spProf);
            List<Company_Level__c> cl1 = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl1;
            
            test.startTest();
            PageReference myVfPage = Page.FunnelSalesDashboard;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Country');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Rep');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , 'All'); 
            
            //SalesScorecardController.CalculateData2();
            
            SalesScorecardController  fc = new SalesScorecardController ();                        
            SalesScorecardController  fc1 = new SalesScorecardController (); 
            /*fc.fw.labelOne = 'Country';
            fc.fw.labelTwo = 'Rep';
            fc.fw.labelThree = 'Role';
            fc.fw.SelectedLevelOne = 'US';
            fc.fw.SelectedLevelTwo = 'All';
            fc.fw.SelectedLevelThree = 'All';*/
            
            test.stopTest();
            
            fc1.isMgr = true;
            fc1.isReset = true;
         	//fc.navigateToAnnualizationDashboard();
            fc.navigateToFunnelReviewGoals();
            fc.navigateToHelpMenu();
            //fc.navigateToTrendingByRep();
            //fc.navigateToTrendingBySkill();
            fc.navigateToFunnelSetup();
            fc.navigateToFunnelAddEditSRP();
            fc.navigateToGoals();
            //fc1.breadCrumClick();
            /*fc.navigateToCertification();
            fc.navigateToDashboard();
            fc.navigateToCalculator();
            fc.navigateToHomePage();
            fc.navigateToReportsPage();
            fc.navigateToAppSetup();
            fc.navigateToCertificateReports();*/
            fc1.levelValue='Country';     
            fc.selectedType ='';
            fc.perfPeriodValues = '';
            fc.chartTitle = '';
            fc.selectedTypevalue = '';
            fc.perfPeriodValuesvalue = '';
            fc.Rolevalue = '';
            fc.defaultBreadCrumb = '';
            fc.RoleOverlay = true;
            fc.RepOverlay = true;
            fc.vdata2Percentage10 = 0;
            fc.vdata2Percentage8 = 0;
            fc.vdata2Percentage5 = 0;
            fc.vdata2Percentage2 = 0;
            fc.vdata2Percentage0 = 0;
            fc.vdata1Percentage10 = 0;
            fc.vdata1Percentage8 = 0;
            fc.vdata1Percentage5 = 0;
            fc.vdata1Percentage2 = 0;
            fc.vdata1Percentage0 = 0;
            fc.vdata2Count10 = 0;
            fc.vdata2Count8 = 0;
            fc.vdata2Count5 = 0;
            fc.vdata2Count2 = 0;
            fc.vdata2Count0 = 0;
            fc.vdata1Count10 = 0;
            fc.vdata1Count8 = 0;
            fc.vdata1Count5 = 0;
            fc.vdata1Count2 = 0;
            fc.vdata1Count0 = 0;
            fc.averagevalue2 = 0;
            fc.averagevalue1 = 0;
            fc.isData1 = true;
        } 
    }
    static testmethod void testTeamAggregation() {           
        
        
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        //UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
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
        //fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u2 = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 3;
        fw.profileId = profileId;        
        //fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u3 = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 4;
        fw.profileId = profileId;        
        //fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u4 = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 5;
        fw.profileId = profileId;        
        //fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u5 = us[0];
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id );         
        
        system.runAs(u){
            
            test.startTest();
            List<Sales_Rep_Profile__c > splist= new List<Sales_Rep_Profile__c >();
            
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 4;
            fw.userId = u4.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgrMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgrMgr;
            splist.add(spMgrMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            fw.salesMgr = spMgrMgr.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgr;
            splist.add(spMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 5;
            fw.userId = u5.id;
            fw.salesMgr = spMgrMgr.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr2 = FunnelDataFactory.createSalesRep(fw);
            insert spMgr2;
            splist.add(spMgr2);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            spProf.Quarterly_Opportunities_added_to_Qualifi__c = 5;
            spProf.Quarterly_Lead_Added__c = 5;
            spProf.Quarterly_Quota_Revenue__c = 500;
            spProf.Month_1_Quota_Amount__c= 500;
            spProf.YTD_Revenue__c = 500;
            spProf.X12_Month_Rolling_Opportunity_Close_Rate__c = 50;
            insert spProf;
            
            Sales_Rep_Profile_Snapshot__c snap = new Sales_Rep_Profile_Snapshot__c();
            snap.Sales_Rep_Profile__c = spProf.id;
            snap.Name = 'Test';
            snap.Snapshot_Scheduled_Date__c = date.newInstance(date.today().year() - 1, 12, 31);
            insert snap;
            
            splist.add(spProf);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf1 = FunnelDataFactory.createSalesRep(fw);
            spProf1.Quarterly_Opportunities_added_to_Qualifi__c = 5;
            spProf1.Quarterly_Lead_Added__c = 5;
            spProf1.Quarterly_Quota_Revenue__c = 500;
            spProf1.Month_1_Quota_Amount__c= 500;
            spProf1.YTD_Revenue__c = 500;
            spProf1.X12_Month_Rolling_Opportunity_Close_Rate__c = 50;
            insert spProf1;
            splist.add(spProf1);
            
            List<YTD_Quota_Revenue__c> yrq = FunnelDataFactory.createPriorYearResult(splist);   
            
            yrq[3].YTD_Revenue__c = 200;
            yrq[3].X12_Month_Rolling_Average_Sales_Cycle__c = 20;
            yrq[3].X12_Month_Average_Selling_Price__c = 200;
            yrq[3].X12_Month_Opprties_Added_to_the_funnel__c = 20;
            yrq[3].X12_Month_Leads_Added__c = 35;
            
            yrq[4].YTD_Revenue__c = 200;
            yrq[4].X12_Month_Rolling_Average_Sales_Cycle__c = 20;
            yrq[4].X12_Month_Average_Selling_Price__c = 200;
            yrq[4].X12_Month_Opprties_Added_to_the_funnel__c = 20;
            yrq[4].X12_Month_Leads_Added__c = 35;           
            
            insert yrq;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);
            for(Company_Level__c c : cl){
                c.Order__c = 1;
            }
            //insert cl;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;  
            fw.levelName = 'Country';
            fw.levelValue = 'Canada';
            fw.salesProfForCompLevel = spMgr2.id;
            
         /*   sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr2);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;*/
            
           
            
            SalesScorecardController  fc = new SalesScorecardController ();
            SalesScorecardController.Data4 data = new SalesScorecardController.Data4('Name', 1.0, 2.0, 3.0);
            fc.selectedId = '';
            //fc.PopulateMetricOrSkill();
            fc.levelOneAction();
            fc.levelTwoAction();
            //fc.CalculateData4();
            fc.CalculateData2();
            fc.CalculateData1();
            fc.CalculateData();
            fc.navigateToCertification();
            fc.navigateToDashboard();
            fc.navigateToCalculator();
            fc.navigateToHomePage();
            fc.navigateToReportsPage();
            fc.navigateToAppSetup();
            fc.navigateToCertificateReports();
         	fc.navigateToAnnualizationDashboard();
            fc.navigateToTrendingByRep();
            fc.navigateToTrendingBySkill();
            fc.navigateToTrndngRep();
            fc.navigateToSalesPipeline();
            fc.navigateToDetailPage();
         //   system.assertEquals(fc.YTDQuotaPerformance,1000);
            test.stopTest();
        }
        
    }
    
}