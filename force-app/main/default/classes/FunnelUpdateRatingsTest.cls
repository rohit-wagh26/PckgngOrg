@isTest

public class FunnelUpdateRatingsTest{
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

    static testmethod void testDisplayRatingsQuarterlyAnswered(){
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
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_Certification_Updates'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        System.runAs ( userList1[0] ) {
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            Application_Setting__c appSet = new Application_Setting__c(Implementation_Date__c=Date.today()-1);
            insert appSet;
            
            /*insert manager record*/
            FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            //insert r;            
            //fw.userRoleId = r.id;
            
            List<Sales_Rep_Profile__c> spMgr = FunnelDataFactory.createSalesReplist(userList1);
            insert spMgr;
            
            List<Certification__c> cMgr = FunnelDataFactory.createCertification(fw,spMgr);
            insert cMgr;
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
            fw.timing = 'End of month';
            fw.weight = '4';      
            fw.salesProfId = c[0].Sales_rep_profile__c;
                              
            fw.rolesEnabled = val;          
            List<Certification_Rating__c> ratings = FunnelDataFactory.createCertificationRatings(fw,4);
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
            
            FunnelUpdateRatings_Controller ft = new FunnelUpdateRatings_Controller();
                                   
            Test.stopTest();   
            
            for(Certification_Answer__c a: ans){
                a.Rating_Score__c = 10;
            } 
            
            Notification_Setting__c ns = new Notification_Setting__c ();
            ns.Advance_Reminders__c = '3 days prior';
            ns.Enable_Notifications__c = true;
            ns.Escalation__c = '5 days Prior';
            ns.Notification_Frequency__c = 'Daily';
            insert ns;   
            
            ft.saveForLater();  
            //system.assertEquals(ft.updateListValue[0].Rating_Score__c,null);   
            Decimal i = [SELECT Overall_Rating__c FROM Certification__c WHERE id = :ft.c.id].Overall_Rating__c;
            system.assertEquals(i,null);                                                      
            
            ft.submit(); 
            system.assertEquals(ft.updateListValue[0].Rating_Score__c,0);        
       }              
      
    }


    static testmethod void testDisplayRatingsMonthlyAnswered(){
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
                
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_Certification_Updates'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        System.runAs ( userList1[0] ) {
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            Application_Setting__c appSet = new Application_Setting__c(Implementation_Date__c = Date.today() -1);
            insert appSet;
                
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
            
            List<Certification__c> cMgr = FunnelDataFactory.createCertification(fw,spMgr);
            insert cMgr;
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
            fw.timing = 'End of month';
            fw.weight = '4';      
            fw.salesProfId = c[0].Sales_rep_profile__c;
                              
            fw.rolesEnabled = val;          
            List<Certification_Rating__c> ratings = FunnelDataFactory.createCertificationRatings(fw,4);
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
            
            ans[0].Rating_Score__c = 10;
            ans[1].Rating_Score__c = 10;
            ans[2].Rating_Score__c = 10;
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
            
            FunnelUpdateRatings_Controller ft = new FunnelUpdateRatings_Controller();
                                   
            Test.stopTest();   
            
            for(Certification_Answer__c a: ans){
                a.Rating_Score__c = 10;
            } 
            
            Notification_Setting__c ns = new Notification_Setting__c ();
            ns.Advance_Reminders__c = '3 days prior';
            ns.Enable_Notifications__c = true;
            ns.Escalation__c = '5 days Prior';
            ns.Notification_Frequency__c = 'Daily';
            insert ns;   
            ft.saveForLater();                                                            
            ft.submit();  
            
            Date newDueDate = [SELECT Due_Date__c FROM Certification_Answer__c WHERE Certifcation_Rating__r.Timing__c = 'End of month' AND Rating_Score__c = null LIMIT 1].Due_Date__c;
            
            Integer daysInMonth = Date.daysInMonth(Date.today().year(),Date.today().month()+1);
            Date expDt = Date.newInstance(Date.today().year(), Date.today().month()+1,daysInMonth);
            system.assertEquals(newDueDate, expDt);
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
        
        insert userList1;
        
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
            
            List<Certification__c> cMgr = FunnelDataFactory.createCertification(fw,spMgr);
            insert cMgr;
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
            fw.timing = 'End of month';
            fw.weight = '4';      
            fw.salesProfId = c[0].Sales_rep_profile__c;
                              
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
            
            FunnelUpdateRatings_Controller fc = new FunnelUpdateRatings_Controller();
                                   
            Test.stopTest(); 
            fc.getsurveyVal();
            PageReference p = fc.navigateToCertification();
            system.assert(true,p.getUrl().contains('FunnelCerificationTable'));
            p = fc.navigateToCalculator();
            system.assert(true,p.getUrl().contains('FunnelCalculator'));
            p = fc.navigateToHomePage();
            system.assert(true,p.getUrl().contains('FunnelHomePage'));
            p = fc.navigateToReportsPage();
            system.assert(true,p.getUrl().contains('FunnelReportingPage'));
            p = fc.navigateToAppSetup();
            system.assert(true,p.getUrl().contains('FunnelSalesCerification'));
            p = fc.navigateToDashboard();
            system.assert(true,p.getUrl().contains('FunnelSalesDashboard'));
            p = fc.navigateToCertificateReports();
            system.assert(true,p.getUrl().contains('navigateToCertificateReports'));
            p = fc.navigateToAnalytics();
            system.assert(true,p.getUrl().contains('navigateToAnalytics'));
            p = fc.navigateToFunnelAnalyticQualitative();
            system.assert(true,p.getUrl().contains('navigateToFunnelAnalyticQualitative'));
            p = fc.navigateToFunnelAnalytic();
            system.assert(true,p.getUrl().contains('navigateToFunnelAnalytic'));
            p = fc.navigateToTrendingByRep();
            p = fc.navigateToTrendingBySkill();
            
        }
            
    }
    
    static testmethod void testImplementationUpdate(){
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
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_Certification_Updates'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        System.runAs ( userList1[0] ) {
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            Application_Setting__c appSet = new Application_Setting__c(Implementation_Date__c=Date.today()-4);
            insert appSet;
            
            
            /*insert manager record*/
            FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            //insert r;            
            //fw.userRoleId = r.id;
            
            List<Sales_Rep_Profile__c> spMgr = FunnelDataFactory.createSalesReplist(userList1);
            insert spMgr;
            
            List<Certification__c> cMgr = FunnelDataFactory.createCertification(fw,spMgr);
            insert cMgr;
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
            fw.timing = 'End of month';
            fw.weight = '4';      
            fw.salesProfId = c[0].Sales_rep_profile__c;
                              
            fw.rolesEnabled = val;          
            List<Certification_Rating__c> ratings = FunnelDataFactory.createCertificationRatings(fw,4);
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
            
            FunnelUpdateRatings_Controller ft = new FunnelUpdateRatings_Controller();
                                   
            Test.stopTest();   
            
            for(Certification_Answer__c a: ans){
                a.Rating_Score__c = 10;
            } 
            
            Notification_Setting__c ns = new Notification_Setting__c ();
            ns.Advance_Reminders__c = '3 days prior';
            ns.Enable_Notifications__c = true;
            ns.Escalation__c = '5 days Prior';
            ns.Notification_Frequency__c = 'Daily';
            insert ns;   
            
            ft.saveForLater();  
            //system.assertEquals(ft.updateListValue[0].Rating_Score__c,null);   
            Decimal i = [SELECT Overall_Rating__c FROM Certification__c WHERE id = :ft.c.id].Overall_Rating__c;
            system.assertEquals(i,null);                                                      
            
            ft.submit(); 
            system.assertEquals(ft.updateListValue[0].Rating_Score__c,0);  
            
            ft.popclose = 'test';
            Map<String,String> mS = new Map<String,String>();
            mS.put('test','test');
            ft.managemenetReports = mS;
            ft.staticListValue = ans;
            ft.popup();
            ft.navigateToAnnualizationDashboard();
            ft.navigateToFunnelAddEditSRP();
            ft.navigateToFunnelReviewGoals();
            ft.navigateToFunnelSetup();
            ft.navigateToGoals();
                  
       }              
      
    }
                      
}