@isTest
public class FunnelScorecardTest {
    
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
    
    static testmethod void testTeamAggregation() {           
        
        
        
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
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr2);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;  
            fw.levelName = 'Company';
            fw.levelValue = 'Funnel Metrics';
            fw.salesProfForCompLevel = spMgrMgr.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgrMgr);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
                                    
            FunnelScorecard  fc = new FunnelScorecard ();
            system.assertEquals(fc.YTDQuotaPerformance,1000);
            test.stopTest();
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
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 3;   
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u3 = us[0];
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps.Id );  
        
        system.runAs(u2){
            test.startTest();
            List<Sales_Rep_Profile__c > splist= new List<Sales_Rep_Profile__c >();
            
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
            splist.add(spMgr);
            
            
            
            
            Sales_Rep_Profile_Snapshot__c snap = new Sales_Rep_Profile_Snapshot__c();
            snap.Sales_Rep_Profile__c = spMgr.id;
            snap.Name = 'Test';
            snap.Snapshot_Scheduled_Date__c = date.newInstance(date.today().year() - 1, 12, 31);
            insert snap;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            spProf.Quarterly_Opportunities_added_to_Qualifi__c = 5;
            spProf.Quarterly_Lead_Added__c = 5;
            spProf.Quarterly_Quota_Revenue__c = 500;
            spProf.YTD_Revenue__c = 500;
            spProf.X12_Month_Rolling_Opportunity_Close_Rate__c = 50;
             
            spProf.Goal_12m_Avg_Selling_Price__c = 250;
            spProf.Goal_12m_Lead_To_Opp_Conv_Rate__c = 25;
            spProf.Goal_12m_length_of_sales_cycle__c = 25;
            spProf.Goal_12m_rolling_close_rate__c = 25;
            
            insert spProf;
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
            spProf1.YTD_Revenue__c = 500;
            spProf1.X12_Month_Rolling_Opportunity_Close_Rate__c = 50;
             
            spProf1.Goal_12m_Avg_Selling_Price__c = 250;
            spProf1.Goal_12m_Lead_To_Opp_Conv_Rate__c = 25;
            spProf1.Goal_12m_length_of_sales_cycle__c = 25;
            spProf1.Goal_12m_rolling_close_rate__c = 25;
            
            insert spProf1;
            
            List<YTD_Quota_Revenue__c> yrq = FunnelDataFactory.createPriorYearResult(splist);  
                
            yrq[0].YTD_Revenue__c = 200;
            yrq[0].X12_Month_Rolling_Average_Sales_Cycle__c = 20;
            yrq[0].X12_Month_Average_Selling_Price__c = 200;
            yrq[0].X12_Month_Opprties_Added_to_the_funnel__c = 20;
            yrq[0].X12_Month_Leads_Added__c = 35;
            
            yrq[1].YTD_Revenue__c = 200;
            yrq[1].X12_Month_Rolling_Average_Sales_Cycle__c = 20;
            yrq[1].X12_Month_Average_Selling_Price__c = 200;
            yrq[1].X12_Month_Opprties_Added_to_the_funnel__c = 20;
            yrq[1].X12_Month_Leads_Added__c = 35;
            insert yrq;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            //sp[0].Sales_Manager__c=spProf.Id;
            sp.add(spMgr);
            
           
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
                       
            FunnelScorecard  fc = new FunnelScorecard ();
            
        system.assertEquals(fc.YTDQuotaPerformance,500);
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
        fw.userRoleId = r.id;
        
        List<User> us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u = us[0];
        
        List<User> userListcomp = FunnelDataFactory.createUser(fw,10);
        insert userListcomp;
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 2;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u2 = us[0];
        system.debug(' user '+u2);
        
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
            String val = availableValues[0].getValue();
            spProf.Role__c = val;
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
            spProf1.Role__c = val;
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
            cr.Roles_Enabled__c =  availableValues[0].getValue();
            cr.Important_flag__c = true;
            cr.Importance__c = 1;
            rating.add(cr);
            
            cr = new Certification_Rating__c();
            cr.Assessment_type__c = 'Quantitative';   
            cr.Category__c = 'Test';            
            cr.User_Type__c = 'New';
            cr.Timing__c = 'End of month';
            cr.Weight__c = '4';
            cr.Description__c = 'Test description 1';
            cr.Roles_Enabled__c =  availableValues[0].getValue();
            cr.Important_flag__c = true;
            cr.Importance__c = 1;
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
            
            insert cerList ;
            
            List<Certification_Answer__c> anslist = new List<Certification_Answer__c>();
            
            Certification_Answer__c crep = new Certification_Answer__c();
            
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 10;
            crep.Sales_Rep_Profile__c= spMgr.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[0].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 10;
            crep.Sales_Rep_Profile__c= spMgr.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[1].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 8;
            crep.Sales_Rep_Profile__c= spProf.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[2].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 5;
            crep.Sales_Rep_Profile__c= spProf1.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[3].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 10;
            crep.Sales_Rep_Profile__c= spMgr.id;
            crep.Certifcation_Rating__c = rating[1].id;
            crep.Certifcation__c =cerList[0].id;
            anslist.add(crep);
            
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 10;
            crep.Sales_Rep_Profile__c= spMgr.id;
            crep.Certifcation_Rating__c = rating[1].id;
            crep.Certifcation__c =cerList[1].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 8;
            crep.Sales_Rep_Profile__c= spProf.id;
            crep.Certifcation_Rating__c = rating[1].id;
            crep.Certifcation__c =cerList[2].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 5;
            crep.Sales_Rep_Profile__c= spProf1.id;
            crep.Certifcation_Rating__c = rating[1].id;
            crep.Certifcation__c =cerList[3].id;
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
            insert cl;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;  
            fw.levelName = 'Country';
            fw.levelValue = 'Canada';
            fw.salesProfForCompLevel = spMgr2.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr2);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
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
            ApexPages.currentPage().getparameters().put('selectThree' , val); 
            
            FunnelScorecard  fc = new FunnelScorecard ();                        

            fc.fw.labelOne = 'Country';
            fc.fw.labelTwo = 'Rep';
            fc.fw.labelThree = 'Role';
            fc.fw.SelectedLevelOne = 'US';
            fc.fw.SelectedLevelTwo = 'All';
            fc.fw.SelectedLevelThree = val;
            
            
            
            fc.showUpdated();
            fc.fw.SelectedLevelThree = 'All';
            fc.fw.SelectedLevelFour = 'All';
            fc.showUpdated();
            spProf.Profile_Type__c='Overlay';
            spProf.Average_Deal_Size__c=20;
            spProf.Goal_Average_Deal_Size__c=40;
            spProf.Current_Pipeline__c=33;
            update spProf;
            //fc.Data(spMgr.id,spProf.id);
          system.assertEquals(fc.YTDQuotaPerformance,500);
            
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
            
            FunnelScorecard  fc = new FunnelScorecard ();                        

            fc.fw.labelOne = 'Country';
            fc.fw.labelTwo = 'Rep';
            fc.fw.labelThree = 'Role';
            fc.fw.SelectedLevelOne = 'US';
            fc.fw.SelectedLevelTwo = 'All';
            fc.fw.SelectedLevelThree = val;
            
            fc.reset();
            fc.levelOneAction();
            fc.levelTwoAction();
            
            fc.navigateToCertification();
            fc.navigateToCalculator();
            fc.navigateToHomePage();
            fc.navigateToReportsPage();
            fc.navigateToAppSetup();
            fc.navigateToCertificateReports();
            fc.navigateToDashboard();
            
            PageReference p = fc.navigateToCertification();
            system.assert(true,p.getUrl().contains('FunnelCerificationTable'));
            p = fc.navigateToCalculator();
            system.assert(true,p.getUrl().contains('FunnelScorecard '));
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
            
            p = fc.navigateToDetailPage();
            system.assert(true,p.getUrl().contains('FunnelCertificationDetail'));
            p = fc.navigateToSalesPipeline();
            system.assert(true,p.getUrl().contains('navigateToFunnelHomePage1')); 
           
            test.stopTest();
        }
                            
    }        
    
    static testmethod void testconvert() {   
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
            
            FunnelScorecard  fc = new FunnelScorecard ();                        

            fc.fw.labelOne = 'Country';
            fc.fw.labelTwo = 'Rep';
            fc.fw.labelThree = 'Role';
            fc.fw.SelectedLevelOne = 'US';
            fc.fw.SelectedLevelTwo = 'All';
            fc.fw.SelectedLevelThree = val;
            
            fc.convertsub(1000000000,'');
            fc.convertsub(1000000,'');
            fc.convertsub(10000,'');
            Decimal s = fc.convertsub(100,'%');
            system.assertEquals(s,100);
            
            fc.convert(1000000000,'$');
            fc.convert(1000000000,'');
            fc.convert(-1000000000,'$');
            fc.convert(-1000000000,'');
            fc.convert(100000000,'$');
            fc.convert(100000000,'');
            fc.convert(-100000000,'$');
            fc.convert(-100000000,'');
            fc.convert(1000000,'$');
            fc.convert(1000000,'');
            fc.convert(-1000000,'$');
            fc.convert(-1000000,'');
            fc.convert(100000,'$');
            fc.convert(100000,'');
            fc.convert(-100000,'$');
            fc.convert(-100000,'');
            fc.convert(100,'$');
            fc.convert(100,'');
            fc.convert(-100,'$');
            fc.convert(-100,'');
            
           
            fc.convert(999999999,'$');
            fc.convert(999999999,'');
            fc.convert(-999999999,'$');
            fc.convert(-999999999,'');
            fc.convert(9999999,'$');
            fc.convert(9999999,'');
            fc.convert(-9999999,'$');
            fc.convert(-9999999,'');
            fc.convert(999999,'$');
            fc.convert(999999,'');
            fc.convert(-999999,'$');
            fc.convert(-999999,'');
            fc.convert(100,'$');
            fc.convert(100,'');
            fc.convert(-100,'$');
            fc.convert(-100,'');
            
            
           
            test.stopTest();
            
            fc.LeadUsed = true;
            fc.MeetingUsed = true;
            fc.isMgr = true;
            fc.isReset = true;
            fc.navigateToAnnualizationDashboard();
            fc.navigateToFunnelReviewGoals();
            fc.navigateToHelpMenu();
            fc.navigateToTrendingByRep();
            fc.navigateToTrndngRep();
            fc.navigateToTrendingBySkill();
            fc.navigateToFunnelSetup();
            fc.navigateToFunnelAddEditSRP();
            fc.navigateToGoals();
            fc.breadCrumClick();
            fc.checkAndNavigateHome();
            fc.srp=spProf;
            fc.srpid=spProf.id;
            fc.salesRepName=spProf.name;
            fc.levelValue='Country';
            fc.sname='ABC';
            
        } 
    }      
    
}