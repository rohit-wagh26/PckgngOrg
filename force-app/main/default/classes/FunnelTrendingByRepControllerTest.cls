@isTest

public class FunnelTrendingByRepControllerTest {
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
            
            List<Certification__c> cer = FunnelDataFactory.createCertification(fw,sp);
            insert cer;
            
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Country');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Region');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , 'All');
            
            FunnelTrendingByRepController fr = new FunnelTrendingByRepController();
            
            system.assertEquals(fr.leftOptions.size(),0);
            fr.cdisplay = new List<Certification__c>();
			system.assertEquals(fr.leftOptions.size(),0);            
        }        
    }
    static testmethod void testAddEditRating(){
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;        
        
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        insert r1;
        
        fw1.userRoleId = r1.id;
        List<User> us = FunnelDataFactory.createUser(fw1,1);
        insert us;
        User u3 = us[0];
         
        fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;
        fw1.profileId = profileId;        
        fw1.userRoleId = r1.id;
        
        us = FunnelDataFactory.createUser(fw1,1);
        insert us;
        User u = us[0];
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);               
        insert userList1;
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
           
        System.runAs ( userList1[0] ) {
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;   
            List<Sales_Rep_Profile__c> srplist = new List<Sales_Rep_Profile__c>();                        
            /*insert manager record*/
            FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            insert r;            
            fw.userRoleId = r.id;
            fw.userId = u.id;
            Sales_Rep_Profile__c spMgrMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgrMgr;
            srplist.add(spMgrMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            fw.salesMgr = spMgrMgr.id;
            List<Sales_Rep_Profile__c> spMgr = FunnelDataFactory.createSalesReplist(userList1);
            insert spMgr;
            /*stop insert manager record*/
            
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
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            
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
            List<Certification_Rating__c> certRatings = FunnelDataFactory.createCertificationRatings(fw,10);
            //certRatings[0].Timing__c = 'End of quarter';
            //certRatings[1].Timing__c = 'Bi-annual';
            //certRatings[2].Timing__c = 'Annual';
            //insert certRatings;
            for(Certification_Rating__c c:certRatings){
                c.Timing__c = 'End of quarter';
                c.name='Monthly Number of Wins';
                c.Category__c='Quantitative';
                c.Metric_Field_Name__c='FMCustom_Metric_1__c';
                c.Goal_field_name__c='FMCustom_Metric_1Goal__c';
            }
            insert certRatings;
            
            
            
            String val = availableValues[0].getValue();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgrMgr.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgrMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);
            
            insert cl;
            
            List<Company_Level_Junction_snapshot__c> cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
            insert cs;
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            fw.salesMgr = spMgrMgr.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr1 = FunnelDataFactory.createSalesRep(fw);
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 5;  
            fw.levelName = 'Region';
            fw.levelValue = 'US West';
            fw.salesProfForCompLevel = spMgr1.id;
            
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr1);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
            insert cs;
            
            List<Certification_Rating__c> cr = FunnelDataFactory.createCertificationRatings(fw,1);
            insert cr;
            for(Certification_Rating__c c:cr){
                c.name='Monthly Number of Wins';
                
            }
            update cr;
            List<Certification_Answer__c> ca = FunnelDataFactory.createCertificationAnswers(fw,certRatings);
            fw.certificationId = certs [0].id;
            fw.salesProfId = sp[0].id;
            //fw.Due_Date__c = System.today();
            insert ca;
                       
          	List<Certification_Answer__c> ca2 = FunnelDataFactory.createCertificationAnswers(fw,cr);
            insert ca2;
            
            List<Certification__c> cer = FunnelDataFactory.createCertification(fw,sp);
            insert cer;
            List<Sales_Rep_Profile__c> spList = new List<Sales_Rep_Profile__c>();
            Sales_Rep_Profile__c sr1 = new Sales_Rep_Profile__c();
            sr1.name = sp[0].name;
            sr1.FunnelMetrics__User_Record_Name__c = u.id;
            insert sr1;
            spList.add(sr1);
                
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(spList);
            for(Sales_Rep_Profile_Snapshot__c s:spsnap){
                s.Snapshot_Scheduled_Date__c=system.today().adddays(-30);
            }
            
            insert spsnap ;
            
            List<String> levelFive = new List<String>();
            levelFive.add('Monthly Number of Wins');
            FunnelTrendingByRepController fc = new FunnelTrendingByRepController();
            fc.fw.labelOne = 'Country';
            fc.fw.labelTwo = 'Rep';
            fc.fw.labelThree = 'Role';
            fc.fw.SelectedLevelOne = 'US';
            fc.fw.SelectedLevelTwo = 'All';
            fc.fw.SelectedLevelThree = val;
            fc.fw.SelectedLevelFour = sr1.id;
            fc.rightOptions =new List<SelectOption>();
            fc.rightOptions.add(new SelectOption('Monthly Number of Wins','Monthly Number of Wins'));
           
            integer count1 = 0;
            for(Certification_Answer__c c:ca){
                c.Due_Date__c = system.today().adddays(-count1);
            	c.Sales_Rep_Profile__c = sr1.id;
                c.Rating_Score__c=1;
                count1= count1+ 30;
            }
            update ca;
            fc.repName = sp[0].name;
            fc.levelFiveAction();
            for(Certification_Rating__c c:certRatings){
                c.Timing__c = 'Bi-annual';
            }
            update certRatings;
            fc.levelFiveAction();
            for(Certification_Rating__c c:certRatings){
                c.Timing__c = 'End of month';
            }
            update certRatings;
            fc.levelFiveAction();
            Fiscal_Year_Setting__c fs = new Fiscal_Year_Setting__c();
            fs = FunnelDataFactory.setFiscalYear(Date.newInstance(2022, 10, 10));
            fc.levelFiveAction();
            FunnelTrendingByRepController.tableWrapper tw = new FunnelTrendingByRepController.tableWrapper();
            tw.metricId=ca[0].id;
            tw.rankingScore = 10;
            tw.metricName=ca[0].name;
            tw.timing='monthly';
            tw.Percentage=80;
            tw.dueDate=system.today();
            fc.levelOneAction();
            boolean mrg = fc.isMgr;
            //fc.fw.selectedLevelTwo=sr1.id;
            fc.showUpdated();
            fc.fw.selectedLevelThree='All';
            fc.showUpdated();
            fc.fw.selectedLevelThree='Rep';
            fc.showUpdated();
            fc.fw.selectedLevelTwo='Rep';
            fc.showUpdated();
            fc.breadCrumClick();
            fc.fw.SelectedLevelTwo='US';
            fc.fw.levelTwo = new List<SelectOption>();
            fc.fw.levelTwo.add(new SelectOption('US','US'));
            for(Company_Level__c clevel :cl){
                
                clevel.Level_Value__c= String.escapeSingleQuotes(fc.fw.SelectedLevelTwo);
            }
            update cl;
            fc.levelTwoAction();
            integer count = 1;
            for(integer i=0;i<12;i++){
                String mnt = fc.fetchMonthString(count);
                count++;
            }
            
            fc.getMonthss();
            
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
            p = fc.navigateToFunnelAnalyticQualitative();
            system.assert(true,p.getUrl().contains('navigateToFunnelAnalyticQualitative'));
            p = fc.navigateToTrendingBySkill();
            system.assert(true,p.getUrl().contains('navigateToTrendingBySkill'));
            //p = fc.navigateToGoals();
            //system.assert(true,p.getUrl().contains('navigateToGoals'));
            p = fc.navigateToHelpMenu();
            system.assert(true,p.getUrl().contains('navigateToHelpMenu'));
            p = fc.reset();
            p = fc.navigateToSalesPipeline();
            system.assert(true,p.getUrl().contains('navigateToFunnelHomePage1'));
            
            
            
            p = fc.navigateToFunnelAnalytic();
            system.assert(true,p.getUrl().contains('navigateToFunnelAnalytic'));
            
            
            p = fc.navigateToAnnualizationDashboard(); 
        }        
    }
}