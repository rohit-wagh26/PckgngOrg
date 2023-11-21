@isTest

public class FunnelCertificationsDailyBatchTest{
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

    static testmethod void testEmailTriggering(){
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
        
        System.runAs ( userList1[0] ) {
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            
            Notification_Setting__c insertnoti = new Notification_Setting__c();
            insertnoti.name ='Notification';
            insertnoti.Enable_Notifications__c = true;
            insertnoti.Advance_Reminders__c = '7 days prior';
            insertnoti.Notification_Frequency__c = 'Daily';
            insertnoti.Escalation__c= '5 days prior';   
            insert insertnoti;
            
            /*start creation of user record for escalation*/
            FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            //insert r;            
            //fw.userRoleId = r.id;
            
            List<User> userList2 = FunnelDataFactory.createUser(fw,1);
            insert userList2;
            
            List<Sales_Rep_Profile__c> spEscalation = FunnelDataFactory.createSalesReplist(userList2);
            insert spEscalation;
            /*end creation of user record for escalation*/
            
            /*insert manager record*/
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            UserRole r2 = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            //insert r2;            
            //fw.userRoleId = r2.id;
            
            List<Sales_Rep_Profile__c> spMgr = FunnelDataFactory.createSalesReplist(userList1);
            spMgr[0].Sales_Manager__c = spEscalation[0].id;
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
            fw.salesProfId = profId;      
                              
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
                a.Manager_Email_Date__c = Date.today();
                a.Escalation_Email_Date__c = Date.today();
            }
            
            insert ans;
            
            test.startTest();
            String pref = FunnelCertificationsDailyBatch.prefix;
            FunnelCertificationsDailyBatch db = new FunnelCertificationsDailyBatch();
            Database.executeBatch(db);
            
            test.stopTest();
            
            List<Certification_Answer__c> ansList = [SELECT id, Manager_Email_Date__c FROM Certification_Answer__c];
            
            system.assertNotEquals(ansList[0].Manager_Email_Date__c,Date.today());
        }      
    }
    
    static testmethod void testEmailTriggeringOnStartDay(){
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
        
        System.runAs ( userList1[0] ) {
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            
            Notification_Setting__c insertnoti = new Notification_Setting__c();
            insertnoti.name ='Notification';
            insertnoti.Enable_Notifications__c = true;
            insertnoti.Advance_Reminders__c = '7 days prior';
            insertnoti.Notification_Frequency__c = 'Daily';
            insertnoti.Escalation__c= '5 days prior';   
            insert insertnoti;
            
            /*start creation of user record for escalation*/
            FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            //insert r;            
            //fw.userRoleId = r.id;
            
            List<User> userList2 = FunnelDataFactory.createUser(fw,1);
            insert userList2;
            
            List<Sales_Rep_Profile__c> spEscalation = FunnelDataFactory.createSalesReplist(userList2);
            insert spEscalation;
            /*end creation of user record for escalation*/
            
            /*insert manager record*/
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            UserRole r2 = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            //insert r2;            
            //fw.userRoleId = r2.id;
            
            List<Sales_Rep_Profile__c> spMgr = FunnelDataFactory.createSalesReplist(userList1);
            spMgr[0].Sales_Manager__c = spEscalation[0].id;
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
            fw.salesProfId = profId;      
                              
            fw.rolesEnabled = val;          
            List<Certification_Rating__c> ratings = FunnelDataFactory.createCertificationRatings(fw,4);
            ratings[0].Timing__c = 'End of quarter';
            ratings[1].Timing__c = 'Bi-annual';
            ratings[2].Timing__c = 'Annual';
                                    
            insert ratings;
            
            fw.certificationId = c[0].id;
            List<Certification_Answer__c> ans = FunnelDataFactory.createCertificationAnswers(fw,ratings);
            for(Certification_Answer__c a: ans){
                a.Rating_start_date__c = Date.today();
                a.Due_Date__c = Date.today();
                a.Manager_Email_Date__c = Date.today();
                a.Escalation_Email_Date__c = Date.today();
            }
            
            insert ans;
            
            test.startTest();
            
            FunnelCertificationsDailyBatch db = new FunnelCertificationsDailyBatch();
            Database.executeBatch(db);
            
            test.stopTest();
            
            List<Certification_Answer__c> ansList = [SELECT id, Manager_Email_Date__c FROM Certification_Answer__c];
            
            system.assertNotEquals(ansList[0].Manager_Email_Date__c,Date.today());
        }      
    }
        
}