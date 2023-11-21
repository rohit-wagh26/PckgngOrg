@isTest

public class FunnelUpdateBlankAnswersTest{
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

    static testmethod void testBlankAnswers(){
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());
        
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        
        
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        insert r1;
        
        fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
        insert userList1;
        
        //PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_Sales_Profile_Company_Level_access'];
        //insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        System.runAs ( userList1[0] ) {
        
            date d = date.newinstance(date.today().year(), 1, 1);
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(d);
            insert fiscalYr;
            
            Notification_Setting__c insertnoti = new Notification_Setting__c();
            insertnoti.name ='Notification';
            insertnoti.Enable_Notifications__c = true;
            insertnoti.Advance_Reminders__c = '7 days prior';
            insertnoti.Notification_Frequency__c = 'Daily';
            insertnoti.Escalation__c= '5 days prior';   
            insert insertnoti;
            
            FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
                    
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            insert r;
            
            fw.userRoleId = r.id;
            
            List<User> userList = FunnelDataFactory.createUser(fw,100);
            insert userList;
            system.debug(userList);
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            insert sp;
            Id profId = sp[0].id;
            
            Set<id> profIds = new Set<id>();
            for(Sales_Rep_Profile__c s: sp){
                profIds.add(s.id);
            }
            List<Certification__c> c = FunnelDataFactory.createCertification(fw,sp);
            insert c;
            
            fw.certificationId = c[0].id; 
            fw.type = 'Qualitative';   
            fw.calcType = 'Y/N';
            fw.category = 'Test category';            
            fw.userType = 'Tenured';
            fw.timing = 'End of month';
            fw.weight = '4';      
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            String val = availableValues[0].getValue();
                              
            fw.rolesEnabled = val;          
            List<Certification_Rating__c> ratings = FunnelDataFactory.createCertificationRatings(fw,4);
            ratings[0].Timing__c = 'End of quarter';
            ratings[1].Timing__c = 'Bi-annual';
            ratings[2].Timing__c = 'Annual';
                                    
            insert ratings;
            
            fw.certificationId = c[0].id;
            List<Certification_Answer__c> ans = FunnelDataFactory.createCertificationAnswers(fw,ratings);
            for(Certification_Answer__c a: ans){
                a.Sales_rep_profile__c = profId;
                a.Rating_start_date__c = Date.today() - 4;
                a.Due_Date__c = Date.today() - 1;
            }
            
            ans[3].Certifcation_rating__c = ratings[0].id;
            insert ans;
            
            List<Opportunity > op= FunnelDataFactory.createopplist(userList);
            op[0].StageName = 'Prospecting';
            op[0].CloseDate = Date.today()+1;
            insert op;           
            
            List<Lead> l= FunnelDataFactory.createLeadlist(userList);
            insert l;
            system.debug('L0'+l[0]);
            
            List<Task> e = FunnelDataFactory.createTasklist(userList);
            insert e ;
            system.debug('E0'+e[0]);
            system.debug('E'+e);
            Test.startTest();
                
            FunnelUpdateBlankAnswers ba = new FunnelUpdateBlankAnswers(profIds);
            Database.executeBatch(ba);
            
            //system.assertNotEquals(ans[3].rating_score__c,null);            
            Test.stopTest();
            
            id i = ans[3].id;
            
            Decimal score = [SELECT rating_score__c FROM Certification_Answer__c WHERE id = :i].rating_score__c;
            system.assertNotEquals(score,null); 
            /*
            system.debug('OP0'+op[0]);
            Sales_rep_profile__c sr = [SELECT Current_active_opportunities__c FROM Sales_rep_profile__c WHERE id = :sp[0].id];
            system.debug(' sales prof '+sr);
            system.debug('SP0'+sp[0].user_record_name__c);
            System.assertEquals(1 , sr.Current_active_opportunities__c);*/
        }
    
    }
          
}