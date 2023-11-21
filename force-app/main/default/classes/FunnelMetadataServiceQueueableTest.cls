@IsTest
public with sharing class FunnelMetadataServiceQueueableTest {
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

	@IsTest
	private static void metadataServiceCallWithGlobalValueSetShouldCompleteSuccessfully() {
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());

		MetadataService.GlobalValueSet globalValueSet = new MetadataService.GlobalValueSet();
		globalValueSet.masterLabel = 'Master Label';
		globalValueSet.fullName = 'Full_Name';

		globalValueSet.customValue = new List<MetadataService.CustomValue>();

		for (Integer i = 1; i <= 100; i++) {
			MetadataService.customValue cv = new MetadataService.CustomValue();
			cv.default_x = false;
			cv.isActive = true;
			cv.fullName = 'Value ' + i;
			globalValueSet.customValue.add(cv);
		}

		Test.startTest();

		System.enqueueJob(new FunnelMetadataServiceQueueable(globalValueSet));

		Test.stopTest();
	}
}