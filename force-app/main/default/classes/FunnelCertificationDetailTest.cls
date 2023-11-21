@isTest

public class FunnelCertificationDetailTest {
    
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

    static testmethod void testDisplayAnswers(){
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());
    
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        //insert r1;        
        //fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
        insert userList1[0];
        
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
            //fw.userRoleId = r.id;
            
            List<Sales_Rep_Profile__c> spMgr = FunnelDataFactory.createSalesReplist(userList1);
            insert spMgr;
            /*stop insert manager record*/
            
           
            /*insert profile record*/
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            //insert r;            
            //fw.userRoleId = r.id;
            
            //insert certification
            List<Certification__c> cmgr = FunnelDataFactory.createCertification(fw,spMgr);
            insert cmgr ;
            
            List<User> userList = FunnelDataFactory.createUser(fw,1);
            insert userList;
            system.debug(userList);
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            sp[0].Sales_Manager__c = spMgr[0].id;
            sp[0].Rep_Staus__c = 'Tenured';
            insert sp;                                                                                                                                                                           
            
            fw = new FunnelDataFactory.FunnelTestWrapper();            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,sp);
            insert certs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.type = 'Qualitative';
            fw.calcType = 'Y/N';
            fw.category = 'Communication';
            fw.userType = 'Tenured';
            //fw.userType = 'Both';
            fw.timing = 'End of month';
            fw.weight = '5';
            List<Certification_Rating__c> certRatings = FunnelDataFactory.createCertificationRatings(fw,10);
            certRatings[0].Timing__c = 'End of quarter';
            certRatings[1].Timing__c = 'Bi-annual';
            certRatings[2].Timing__c = 'Annual';
            insert certRatings;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.certificationId = certs[0].id;
            List<Certification_Answer__c> ans = FunnelDataFactory.createCertificationAnswers(fw,certRatings);
            for(Certification_Answer__c a: ans){
                a.Rating_start_date__c = Date.today() - 4;
                a.Due_Date__c = Date.today();
                a.Rating_Score__c = 10;
            }
            
            
            insert ans;
            system.debug('ans--'+ans);
            test.startTest();
            
            Apexpages.currentPage().getParameters().put('id',sp[0].id);
            system.debug('sp[0].id--'+sp[0].id);           
            FunnelCertificationDetail c = new FunnelCertificationDetail();
            system.assertEquals(c.cerificateAnswer.size(),10);
            test.stopTest();                                                                    
                  
       }    
    }
    
    static testmethod void testNavigation() {
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());    
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        //insert r1;        
        //fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
         insert userList1 ;
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
            //fw.userRoleId = r.id;
            
            /*List<User> userList = FunnelDataFactory.createUser(fw,1);
            insert userList;
            system.debug(userList);
            UserRecMgr = userList[0];*/
            List<Sales_Rep_Profile__c> spMgr = FunnelDataFactory.createSalesReplist(userList1);
            insert spMgr;
            /*stop insert manager record*/
            
            /*insert profile record*/
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            //insert r;            
            //fw.userRoleId = r.id;
            
            List<User> userList = FunnelDataFactory.createUser(fw,1);
            insert userList;
            system.debug(userList);
            
            //insert certification
            List<Certification__c> cmgr = FunnelDataFactory.createCertification(fw,spMgr);
            insert cmgr ;
 
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            String val = availableValues[0].getValue();
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            sp[0].Sales_Manager__c = spMgr[0].id;
            sp[0].Rep_Staus__c = 'Tenured';
            sp[0].Role__c = val;
            insert sp;            
            
            Id profId = sp[0].id;
            
            List<Certification__c> c = FunnelDataFactory.createCertification(fw,sp);
            insert c;
            
            fw.certificationId = c[0].id; 
            fw.type = 'Qualitative';   
            fw.calcType = 'Y/N';
            fw.category = 'Test category';            
            fw.userType = 'Tenured';
            //fw.userType = 'Both';
            fw.timing = 'End of month';
            fw.weight = '4';      
                              
            fw.rolesEnabled = val;          
            List<Certification_Rating__c> ratings = FunnelDataFactory.createCertificationRatings(fw,10);
            ratings[0].Timing__c = 'End of quarter';
            ratings[1].Timing__c = 'Bi-annual';
            ratings[2].Timing__c = 'Annual';
                                    
            insert ratings;
            
            fw.certificationId = c[0].id;
            List<Certification_Answer__c> ans = FunnelDataFactory.createCertificationAnswers(fw,ratings);
            for(Certification_Answer__c a: ans){
                a.Rating_start_date__c = Date.today() - 4;
                a.Due_Date__c = Date.today();
            }
            
            ans[3].Rating_Score__c = 4;
            insert ans;
            
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
            Apexpages.currentpage().getParameters().put('id',profId);
            
            FunnelCertificationDetail  fc = new FunnelCertificationDetail();
                                   
            Test.stopTest();   
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
            p = fc.navigateToUpdateRatings();
            system.assert(true,p.getUrl().contains('FunnelCerificationUpdateRatings'));
            
            p = fc.navigateToIndividualDashboard();
            system.assert(true,p.getUrl().contains('navigateToIndividualDashboard'));
            p = fc.navigateToStatusUpdatePage();
            system.assert(true,p.getUrl().contains('navigateToStatusUpdatePage'));
            p = fc.navigateToAnalytics();
            system.assert(true,p.getUrl().contains('navigateToAnalytics'));
            p = fc.navigateToFunnelAnalyticQualitative();
            system.assert(true,p.getUrl().contains('navigateToFunnelAnalyticQualitative'));
            p = fc.navigateToFunnelAnalytic();
            system.assert(true,p.getUrl().contains('navigateToFunnelAnalytic'));
            p = fc.navigateToAnnualizationDashboard();
            system.assert(true,p.getUrl().contains('navigateToAnnualizationDashboard'));
            p = fc.navigateToGoals();
            p = fc.navigateToTrendingBySkill();
            p = fc.navigateToTrendingByRep();
            p = fc.navigateToSalesPipeline();
            
        }
            
    }
    
    static testmethod void testDisplayAnswersQualitative(){
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());
    
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        //insert r1;        
        //fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
        insert userList1[0];
        
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
            //fw.userRoleId = r.id;
            
            List<Sales_Rep_Profile__c> spMgr = FunnelDataFactory.createSalesReplist(userList1);
            insert spMgr;
            /*stop insert manager record*/
            
           
            /*insert profile record*/
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            //insert r;            
            //fw.userRoleId = r.id;
            
            //insert certification
            List<Certification__c> cmgr = FunnelDataFactory.createCertification(fw,spMgr);
            insert cmgr ;
            
            List<User> userList = FunnelDataFactory.createUser(fw,1);
            insert userList;
            system.debug(userList);
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            sp[0].Sales_Manager__c = spMgr[0].id;
            sp[0].Rep_Staus__c = 'Tenured';
            sp[0].Goal_12m_rolling_close_rate__c= 50;
            sp[0].X12_Month_Rolling_Opportunity_Close_Rate__c= 30;
            insert sp;  
            
            Sales_Rep_Profile_Snapshot__c ssnap = new Sales_Rep_Profile_Snapshot__c();
            ssnap.Sales_Rep_Profile__c= sp[0].id;         
            ssnap.Rep_Staus__c = 'Tenured';
            ssnap.Goal_12m_rolling_close_rate__c= 50;
            ssnap.X12_Month_Rolling_Opportunity_Close_Rate__c= 30;
            ssnap.Snapshot_Scheduled_Date__c =   Date.today();                                                                                                                                                             
            insert ssnap;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,sp);
            insert certs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.type = 'Quantitative';
            //fw.calcType = 'Y/N';
            fw.category = 'Quantitative';
            fw.userType = 'Tenured';
            //fw.userType = 'Both';
            fw.timing = 'End of month';
            
            fw.weight = '5';
            List<Certification_Rating__c> certRatings = FunnelDataFactory.createCertificationRatings(fw,10);
            certRatings[0].Timing__c = 'End of quarter';
            certRatings[0].Goal_field_name__c= 'Goal_12m_rolling_close_rate__c';
            certRatings[0].Metric_field_name__c= 'X12_Month_Rolling_Opportunity_Close_Rate__c';
            
            certRatings[1].Timing__c = 'End of month';
            certRatings[1].Goal_field_name__c= 'Goal_12m_Avg_Selling_Price__c';
            certRatings[1].Metric_field_name__c= 'X12_Month_Average_Selling_Price__c';
             
            insert certRatings;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.certificationId = certs[0].id;
            List<Certification_Answer__c> ans = FunnelDataFactory.createCertificationAnswers(fw,certRatings);
            for(Certification_Answer__c a: ans){
                a.Rating_start_date__c = Date.today() - 4;
                a.Due_Date__c = Date.today();
                a.Rating_Score__c = 10;
            }
            
            
            insert ans;
            system.debug('ans--'+ans);
            test.startTest();
            
            Apexpages.currentPage().getParameters().put('id',sp[0].id);
            system.debug('sp[0].id--'+sp[0].id);           
            FunnelCertificationDetail c = new FunnelCertificationDetail();
            system.assertEquals(c.cerificateAnswerQuantitative.size(),10);
            test.stopTest();                                                                    
                  
       }    
    }
    
    static testmethod void testActionPlan(){
    
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        //insert r1;        
        //fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
        insert userList1[0];
        
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
            //fw.userRoleId = r.id;
            
            List<Sales_Rep_Profile__c> spMgr = FunnelDataFactory.createSalesReplist(userList1);
            insert spMgr;
            /*stop insert manager record*/
            
           
            /*insert profile record*/
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            //insert r;            
            //fw.userRoleId = r.id;
            
            //insert certification
            List<Certification__c> cmgr = FunnelDataFactory.createCertification(fw,spMgr);
            insert cmgr ;
            
            List<User> userList = FunnelDataFactory.createUser(fw,1);
            insert userList;
            system.debug(userList);
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            sp[0].Sales_Manager__c = spMgr[0].id;
            sp[0].Rep_Staus__c = 'Tenured';
            sp[0].Goal_12m_rolling_close_rate__c= 50;
            sp[0].X12_Month_Rolling_Opportunity_Close_Rate__c= 30;
            insert sp;  
            
            Action_Plan__c a = new Action_Plan__c(Sales_Rep_Profile__c =sp[0].id,Action_Step__c ='Test');
            insert a;
            
            test.startTest();            
            FunnelCertificationDetail c = new FunnelCertificationDetail();
            c.srid = sp[0].id;
            c.hideAddEditActionPlan();
            c.displayAddEditActionPlan();
            c.actionPlanId = a.id;
            c.displayAddEditActionPlan();
            c.actionPlanSelected.Action_Step__c = 'Test1';
            c.saveRating();
            c.desUpdate();
            c.popClose = 'pop';
            c.popup();
            c.popClose = 'close';
            c.popup();
            c.spDate = '';
            c.ytdScore = 0;
            c.isPendingStatusUpdate = true;
            c.renderInfoMessage = true;
            c.lastMonthScore = '';
            c.lastQuarterScore ='';
            c.priorYearScore = '';
            c.Quantitative = 0;
            c.Qualitative = 0;
            c.displayPopup = true;
            
            
            system.assertEquals(c.apList.size(),1);
            test.stopTest();                                                                    
                  
       }    
    }

}