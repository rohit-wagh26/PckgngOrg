@isTest

public class FunnelTrendingBySkillControllerTest {
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
    static testmethod void testRatingsDisplay(){
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());
    
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;        
        
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        //insert r1;
        
        //fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);               
        
        insert userList1;
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
            
        System.runAs ( userList1[0] ) {
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;   
                                    
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
           // insert r;            
           // fw.userRoleId = r.id;
            
            List<User> userList = FunnelDataFactory.createUser(fw,1);
            insert userList;
            system.debug(userList);
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            sp[0].Sales_Manager__c = spMgr[0].id;
            insert sp;                                                                                                                                                                           
            
            fw = new FunnelDataFactory.FunnelTestWrapper();            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,sp);
            insert certs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.type = 'Qualitative';
            fw.calcType = 'Y/N';
            fw.category = 'Qualitative';
            fw.userType = 'Tenured';
            fw.timing = 'End of month';
            fw.weight = '5';
            List<Certification_Rating__c> certRatings = FunnelDataFactory.createCertificationRatings(fw,10);
            certRatings[0].Timing__c = 'End of quarter';
            certRatings[1].Timing__c = 'Bi-annual';
            certRatings[2].Timing__c = 'Annual';
            insert certRatings;
            
            FunnelTrendingBySkillController fr = new FunnelTrendingBySkillController();
            
            system.assertEquals(fr.leftOptions.size(),0);
        }        
    }
    static testmethod void testAddEditRating(){
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());
    
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;        
        
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        //insert r1;
        
        //fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);               
        insert userList1;
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
           
        System.runAs ( userList1[0] ) {
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;   
                                    
            /*insert manager record*/
            FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
          //  insert r;            
          //  fw.userRoleId = r.id;
            
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
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            sp[0].Sales_Manager__c = spMgr[0].id;
            insert sp;                                                                                                                                                                           
            
            fw = new FunnelDataFactory.FunnelTestWrapper();            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,sp);
            insert certs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.type = 'Qualitative';
            fw.calcType = 'Y/N';
            fw.category = 'Communication';
            fw.userType = 'Tenured';
            fw.timing = 'End of month';
            fw.weight = '5';
            
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(sp);
            for(Sales_Rep_Profile_Snapshot__c s:spsnap){
                s.Snapshot_Scheduled_Date__c=System.today() - 1;
                s.FMCustom_Metric_1__c=123;
               	s.FMCustom_Metric_1Goal__c=123;
            }
            
            insert spsnap ;
           
            List<Certification_Rating__c> certRatings = FunnelDataFactory.createCertificationRatings(fw,10);
            certRatings[0].Timing__c = 'End of quarter';
            certRatings[1].Timing__c = 'Bi-annual';
            certRatings[2].Timing__c = 'Annual';
            insert certRatings;
            
            List<Certification_Rating__c> cr = FunnelDataFactory.createCertificationRatings(fw,1);
            cr[0].name = 'test rating';
            cr[0].Category__c = 'Quantitative';
            cr[0].Metric_Field_Name__c='FMCustom_Metric_1__c';
            cr[0].Goal_field_name__c='FMCustom_Metric_1Goal__c';
            insert cr;
            
            List<Certification_Answer__c> ca = FunnelDataFactory.createCertificationAnswers(fw,cr);
             fw.certificationId = certs [0].id;
             fw.salesProfId = sp[0].id;
             ca[0].Due_date__c = System.today() - 1;
             ca[0].Rating_score__c = 1;
             ca[0].Sales_rep_profile__c = sp[0].id;
            insert ca;
            
            List<String> str = new List<String>();
            str.add(sp[0].id);
            String idStr = sp[0].id;
            FunnelTrendingBySkillController fc = new FunnelTrendingBySkillController();
            fc.fw.labelOne = 'Country';
            fc.fw.labelTwo = 'Rep';
            fc.fw.labelThree = 'Role';
            fc.fw.labelFour = 'Filter By Metric/Skill';
            fc.fw.labelFive = 'Filter By Representative';
            fc.fw.SelectedLevelOne = 'US';
            fc.fw.SelectedLevelTwo = 'All';
            fc.fw.selectedLevelFour = 'test rating';
            fc.fw.selectedLevelFive = str;
            fc.rightOptions =new List<SelectOption>();
            fc.rightOptions.add(new SelectOption(sp[0].id ,spMgr[0].Id));
            
            system.debug(' str '+str);
            fc.levelFiveAction();
            fc.reset();
            fc.showUpdated();
            fc.breadCrumClick();
            fc.defaultBreadCrumb = '';
            fc.levelValue = '';
            fc.isMgr = true;
            String mon = fc.getMonthss();
            integer count = 1;
            for(integer i=0;i<12;i++){
                String mnt = fc.fetchMonthString(count);
                count++;
            }
            
            //fc.idToDeactivate =certRatings[0].id ;
            
            
            //fc.updateAndDeactivate();
            //fc.updateAndActivate();
            PageReference p = fc.navigateToCertification();
            system.assert(true,p.getUrl().contains('FunnelCerificationTable'));
            p = fc.navigateToDashboard();
            system.assert(true,p.getUrl().contains('FunnelSalesDashboard'));
            p = fc.navigateToCalculator();
            system.assert(true,p.getUrl().contains('FunnelCalculator'));
            //p = fc.navigateToHomePage();
            //system.assert(true,p.getUrl().contains('FunnelHomePage'));
            p = fc.navigateToReportsPage();
            system.assert(true,p.getUrl().contains('FunnelReportingPage'));
            p = fc.navigateToAppSetup();
            system.assert(true,p.getUrl().contains('FunnelSalesCertification'));
            p = fc.navigateToCertificateReports();
            system.assert(true,p.getUrl().contains('FunnelCerificationReports'));
            p = fc.navigateToSalesPipeline();
            system.assert(true,p.getUrl().contains('navigateToFunnelHomePage1'));
            
            
            
            p = fc.navigateToFunnelAnalytic();
            system.assert(true,p.getUrl().contains('navigateToFunnelAnalytic'));
            
            
            p = fc.navigateToAnnualizationDashboard(); 
            
            p = fc.navigateToGoals();
            p = fc.navigateToHelpMenu();
            p = fc.navigateToFunnelAnalyticQualitative();
            p = fc.navigateToTrendingByRep();
            system.assert(true,p.getUrl().contains('FunnelTrendingByRepDashboard'));
            
        }        
    }
}