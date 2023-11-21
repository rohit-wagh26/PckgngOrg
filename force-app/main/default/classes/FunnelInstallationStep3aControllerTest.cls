@isTest
public class FunnelInstallationStep3aControllerTest {
    
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
     
    static testmethod void test3a() { 
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());   
        
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        insert r1;        
        fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
        insert userList1 ;
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        System.runAs (userList1[0]) { 
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;   
            List<PicklistValueSet__c> pl= new List<PicklistValueSet__c>{
                new PicklistValueSet__c(Name ='role',Level_Name__c='Role',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist1',Level_Name__c='picklist1',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist2',Level_Name__c='picklist2',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist3',Level_Name__c='picklist3',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist4',Level_Name__c='picklist4',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist5',Level_Name__c='picklist5',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist6',Level_Name__c='picklist6',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist7',Level_Name__c='picklist7',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist8',Level_Name__c='picklist8',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist9',Level_Name__c='picklist9',Values__c = 'Test'),
                new PicklistValueSet__c(Name ='picklist10',Level_Name__c='picklist10',Values__c = 'Test')
                };
                
            insert pl;
            
            test.startTest();
            
            
            FunnelInstallationStep3aController c = new FunnelInstallationStep3aController ();                   
            c.save(); 
            List<CreatePicklistValue__c> upsertCreatePickList = new List<CreatePicklistValue__c>();
            upsertCreatePickList = [select id, Value__c, PicklistValueSet__c from CreatePicklistValue__c Limit 5000];
            if(upsertCreatePickList!= null && upsertCreatePickList.size()>0){
                delete upsertCreatePickList;
            }
            c.navigateToStep2();
            upsertCreatePickList = [select id, Value__c, PicklistValueSet__c from CreatePicklistValue__c Limit 5000];
            if(upsertCreatePickList!= null && upsertCreatePickList.size()>0){
                delete upsertCreatePickList;
            }
            c.saveAndExit();
            upsertCreatePickList = [select id, Value__c, PicklistValueSet__c from CreatePicklistValue__c Limit 5000];
            if(upsertCreatePickList!= null && upsertCreatePickList.size()>0){
                delete upsertCreatePickList;
            } 
            PageReference p = c.navigateToStep3b();
            system.assert(true,p.getUrl().contains('FunnelInstallationStep3b'));              
            test.stopTest();
        }           
    }
}