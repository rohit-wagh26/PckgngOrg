@isTest

public class FunnelCertificationRatingContrCustomTest{
    
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
            fw.type = 'Quantitative';
            fw.calcType = 'Bucketed';
            fw.category = 'Quantitative';
            fw.userType = 'Tenured';
            fw.timing = 'End of month';
            fw.weight = '5';
          
            fw.customobj = 'opportunity';
            fw.customfield = 'amount';
            fw.relby = 'ownerId';
            fw.agg = 'SUM';
            fw.datefield = 'Createddate';
            fw.dateperiod = 'Current Month';
             
           
            List<Certification_Rating__c> certRatings = FunnelDataFactory.createCertificationRatings(fw,10);
            certRatings[0].Timing__c = 'End of quarter';
            
            certRatings[0].SRP_Field_Name__c= 'FMCustom_Metric_1__c';
            certRatings[1].SRP_Field_Name__c= 'FMCustom_Metric_2__c';
            certRatings[2].SRP_Field_Name__c= 'FMCustom_Metric_3__c';
            certRatings[3].SRP_Field_Name__c= 'FMCustom_Metric_4__c';
            certRatings[4].SRP_Field_Name__c= 'FMCustom_Metric_5__c';
            certRatings[5].SRP_Field_Name__c= 'FMCustom_Metric_6__c';
            certRatings[6].SRP_Field_Name__c= 'FMCustom_Metric_7__c';
            certRatings[7].SRP_Field_Name__c= 'FMCustom_Metric_8__c';
            certRatings[8].SRP_Field_Name__c= 'FMCustom_Metric_9__c';
            certRatings[9].SRP_Field_Name__c= 'FMCustom_Metric_10__c';
             
            insert certRatings;
            
            FunnelCertificationRatingCustom fc = new FunnelCertificationRatingCustom();
            
            system.assertEquals(fc.ratingList.size(),10);
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
            
            fw.customobj = 'opportunity';
            fw.customfield = 'amount';
            fw.relby = 'ownerId';
            fw.agg = 'SUM';
            fw.datefield = 'Createddate';
            fw.dateperiod = 'Current Month';
             
           
            List<Certification_Rating__c> certRatings = FunnelDataFactory.createCertificationRatings(fw,10);
            certRatings[0].Timing__c = 'End of quarter';
            
            certRatings[0].SRP_Field_Name__c= 'FMCustom_Metric_1__c';
            certRatings[1].SRP_Field_Name__c= 'FMCustom_Metric_2__c';
            certRatings[2].SRP_Field_Name__c= 'FMCustom_Metric_3__c';
            certRatings[3].SRP_Field_Name__c= 'FMCustom_Metric_4__c';
            certRatings[4].SRP_Field_Name__c= 'FMCustom_Metric_5__c';
            certRatings[5].SRP_Field_Name__c= 'FMCustom_Metric_6__c';
            certRatings[6].SRP_Field_Name__c= 'FMCustom_Metric_7__c';
            certRatings[7].SRP_Field_Name__c= 'FMCustom_Metric_8__c';
            certRatings[8].SRP_Field_Name__c= 'FMCustom_Metric_9__c';
            certRatings[9].SRP_Field_Name__c= 'FMCustom_Metric_10__c';
            
             insert certRatings;
             
            FunnelCertificationRatingCustom fc = new FunnelCertificationRatingCustom();
            fc.displayAddEditRating();
            fc.hideAddEditRating();
           // fc.ratingSelected.SRP_Field_Name__c= 'FMCustom_Metric_1__c';
            fc.ratingId = certRatings[0].id;
            fc.displayAddEditRating();
            fc.saveRating();
            fc.showText();
            fc.hideText();
            fc.idToDeactivate =certRatings[0].id ;
            fc.updateAndDeactivate();
            fc.idToActivate = certRatings[0].id ;
            fc.updateAndActivate();
            fc.getSobjectnames();
            fc.getrname();
            fc.getfetchgoal();
            fc.createmetricgoal(certRatings[0].id,certRatings[0].name,20);
            
            fc.applyGoal();
            //fc.applydefaultgoal(20,'test');
            
            
            
            
            //fc.updateAndDeactivate();
            //fc.updateAndActivate();
            fc.updateOrder();
            PageReference p = fc.navigateToCertification();
            system.assert(true,p.getUrl().contains('FunnelCerificationTable'));
            p = fc.navigateToDashboard();
            system.assert(true,p.getUrl().contains('FunnelSalesDashboard'));
            p = fc.navigateToCalculator();
            system.assert(true,p.getUrl().contains('FunnelCalculator'));
            p = fc.navigateToHomePage();
            system.assert(true,p.getUrl().contains('FunnelHomePage'));
            p = fc.navigateToReportsPage();
            system.assert(true,p.getUrl().contains('FunnelReportingPage'));
            p = fc.navigateToAppSetup();
            system.assert(true,p.getUrl().contains('FunnelSalesCertification'));
            p = fc.navigateToCertificateReports();
            system.assert(true,p.getUrl().contains('FunnelCerificationReports'));
            p = fc.navigateToAssignRole();
            system.assert(true,p.getUrl().contains('FunnelAssignRole'));
            p = fc.navigateToNotifications();
            system.assert(true,p.getUrl().contains('FunnelNotifications'));
            
            p = fc.navigateToAnalytics();
            system.assert(true,p.getUrl().contains('navigateToAnalytics'));
            p = fc.navigateToFunnelAnalyticQualitative();
            system.assert(true,p.getUrl().contains('navigateToFunnelAnalyticQualitative'));
            p = fc.navigateToFunnelAnalytic();
            system.assert(true,p.getUrl().contains('navigateToFunnelAnalytic'));
            
            fc.selectedValue = 'test';
            Map<String,String> stMap = new Map<String,String>();
            stMap.put('test','test');
            
            fc.questList = certRatings;
            fc.isRep = true;
            fc.isMgr = true;
            fc.isReset = true;
            
            fc.cRatingId = certRatings[0].id;
            fc.applyDefaultgoal(10,'Tenure__c');
            fc.fetchGoal();
            fc.deleteMetric();
            
            fc.cloneRating();
            p = fc.navigateToRatings();
            p = fc.navigateToFunnelEvaluationGuidelines();
            p = fc.navigateToAnnualizationDashboard();
            p = fc.navigateToFunnelSetup();
            p = fc.navigateToFunnelReviewGoals();
            p = fc.navigateToFunnelManagerUpdate();
            p = fc.navigateToGoals();
            fc.getSy();
            
        }        
    }   
}