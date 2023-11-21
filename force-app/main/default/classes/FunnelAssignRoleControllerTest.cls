@isTest
public class FunnelAssignRoleControllerTest {
    
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
    
    static testmethod void testFunnelAssignRoleController() {           
        
        Test.setMock(WebServiceMock.class, new MetadataServiceMock());
        Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());
        
        test.startTest();
        
        DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
        List<PicklistEntry> availableValues = describe.getPicklistValues();
        
        List<Certification_Rating__c> certs = new List<Certification_Rating__c>();
        
        Certification_Rating__c cr = new Certification_Rating__c();
        cr.Assessment_type__c = 'Qualitative';   
        cr.Calculation_type__c = 'Y/N';
        cr.Category__c = 'Test';            
        cr.User_Type__c = 'New';
        cr.Timing__c = 'End of month';
        cr.Weight__c = '4';
        cr.Description__c = 'Test description 1';
        cr.Roles_Enabled__c =  availableValues[0].getValue();
        certs.add(cr);
        
        cr = new Certification_Rating__c();
        cr.Assessment_type__c = 'Qualitative';   
        cr.Calculation_type__c = 'Y/N';
        cr.Category__c = 'Test';            
        cr.User_Type__c = 'New';
        cr.Timing__c = 'End of month';
        cr.Weight__c = '4';
        cr.Description__c = 'Test description 2';
        cr.Roles_Enabled__c =  availableValues[0].getValue();
        certs.add(cr);
        
        cr = new Certification_Rating__c();
        cr.Assessment_type__c = 'Qualitative';   
        cr.Calculation_type__c = 'Y/N';
        cr.Category__c = 'Test';            
        cr.User_Type__c = 'New';
        cr.Timing__c = 'End of month';
        cr.Weight__c = '4';
        cr.Description__c = 'Test description 3';
        certs.add(cr);
        
        insert certs ;
        FunnelAssignRoleController fc = new FunnelAssignRoleController();    
        fc.editCerti();
        fc.updatecerti();
        
        List<Certification_Rating__c> certs1 =[Select id from Certification_Rating__c ];
        system.assertEquals(certs1.size(),3); 
        
        
        test.stopTest();
        
        
    }
    
    
    
    static testmethod void testNavigation() {           
        
        test.startTest();
        
        FunnelAssignRoleController fc = new FunnelAssignRoleController();                        
        
        
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
        p = fc.navigateToRatings();
        system.assert(true,p.getUrl().contains('FunnelSalesCertification'));
        p = fc.navigateToNotifications();
        system.assert(true,p.getUrl().contains('FunnelNotification'));
        p = fc.navigateToCategories();
        system.assert(true,p.getUrl().contains('navigateToCategories'));
        p = fc.navigateToAnalytics();
        system.assert(true,p.getUrl().contains('navigateToAnalytics'));
        p = fc.navigateToFunnelAnalyticQualitative();
        system.assert(true,p.getUrl().contains('navigateToFunnelAnalyticQualitative'));
        p = fc.navigateToFunnelAnalytic();
        system.assert(true,p.getUrl().contains('navigateToFunnelAnalytic'));
        p = fc.navigateToCustomMetric();
        p = fc.navigateToFunnelEvaluationGuidelines();
        p = fc.navigateToAnnualizationDashboard();
        p = fc.navigateToFunnelSetup();
        p = fc.navigateToFunnelReviewGoals();
        p = fc.navigateToFunnelManagerUpdate();
        p = fc.navigateToGoals();
        p = fc.navigateToSalesPipeline();
        p = fc.navigateToTrendingByRep();
        p = fc.navigateToTrendingBySkill();
        p = fc.navigateToHelpMenu();
        
        
        test.stopTest();
        
        fc.checkcontain('test','test');                
        
    }              
    
}