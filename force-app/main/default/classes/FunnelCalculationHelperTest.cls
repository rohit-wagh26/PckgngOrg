@isTest  

public class FunnelCalculationHelperTest{
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
    
    static testmethod void testConvert() {  
        
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());
        
        FunnelCalculationHelper fc = new FunnelCalculationHelper();
        
        
        FunnelCalculationHelper.convert(999999999,'$');
        FunnelCalculationHelper.convert(999999999,'');
        FunnelCalculationHelper.convert(-999999999,'$');
        FunnelCalculationHelper.convert(-999999999,'');
        FunnelCalculationHelper.convert(9999999,'$');
        FunnelCalculationHelper.convert(9999999,'');
        FunnelCalculationHelper.convert(-9999999,'$');
        FunnelCalculationHelper.convert(-9999999,'');
        FunnelCalculationHelper.convert(999999,'$');
        FunnelCalculationHelper.convert(999999,'');
        FunnelCalculationHelper.convert(-999999,'$');
        FunnelCalculationHelper.convert(-999999,'');
        FunnelCalculationHelper.convert(100,'$');
        FunnelCalculationHelper.convert(100,'');
        FunnelCalculationHelper.convert(-100,'$');
        FunnelCalculationHelper.convert(-100,'');
        
        /*  
date d = date.newinstance(2018,5,15); 
FunnelCalculationHelper.getQuarterEndDate(d);
*/
        Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
        insert fiscalYr;
        Set <id> sid = new set<id>();
        List <Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        List<User> us = FunnelDataFactory.createUser(fw1,1);
        insert us;
        User u = us[0];
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.userId = u.id;
        Sales_Rep_Profile__c spMgr1 = FunnelDataFactory.createSalesRep(fw);
        insert spMgr1;
        sp.add(spMgr1);
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;  
        fw.levelName = 'Country';
        fw.levelValue = 'US';
        fw.salesProfForCompLevel = spMgr1.id;
        List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);
        insert cl;
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 2;
        fw.userId = u.id;
        fw.salesMgr = spMgr1.id;
        Sales_Rep_Profile__c spMgr2 = FunnelDataFactory.createSalesRep(fw);
        insert spMgr2;
        sp.add(spMgr2);
        //insert sp;
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.type = 'Qualitative';
        fw.calcType = 'Y/N';
        fw.category = 'Communication';
        fw.userType = 'Tenured';
        fw.timing = 'End of month';
        fw.weight = '5';
        List<Certification_Rating__c> certRatings = FunnelDataFactory.createCertificationRatings(fw,10);
        certRatings[0].Timing__c = 'End of quarter';
        certRatings[1].Timing__c = 'Bi-annual';
        certRatings[2].Timing__c = 'Annual';
        insert certRatings;
        sid.add(spMgr1.id);
        sid.add(spMgr2.id);
        fw = new FunnelDataFactory.FunnelTestWrapper();            
        List<Certification__c> certs = FunnelDataFactory.createCertification(fw,sp);
        insert certs;
        cl[0].Certification__c=certs[0].id;
        List<Certification_Answer__c> ca = FunnelDataFactory.createCertificationAnswers(fw,certRatings);
        fw.certificationId = certs [0].id;
        fw.salesProfId = sp[0].id;
        insert ca;
        List<Certification__c> cer = FunnelDataFactory.createCertification(fw,sp);
        insert cer;
        Decimal agg = FunnelCalculationHelper.findAggregateScore(sid);
        for(Certification__c c : cer){
            c.Overall_Rating__c = 2;
        }
        update cer;
        agg = FunnelCalculationHelper.findAggregateScore(sid);
        String pref = FunnelCalculationHelper.prefix;
        system.assertEquals(pref,'FunnelMetrics__');
        string s = FunnelCalculationHelper.convert(100,'');
        date d = date.newinstance(2018,5,15); 
        FunnelCalculationHelper.getQuarterEndDate(fiscalYr.Start_Date__c+3);
        FunnelCalculationHelper.getQuarterEndDate(fiscalYr.Start_Date__c.addMonths(3));
        FunnelCalculationHelper.getQuarterEndDate(fiscalYr.Start_Date__c.addMonths(6));
        FunnelCalculationHelper.getQuarterEndDate(fiscalYr.Start_Date__c.addMonths(9));
        FunnelCalculationHelper.getQuarterEndDate(fiscalYr.Start_Date__c.addMonths(12));
        DateTime fdt = dateTime.newInstance(fiscalYr.Start_Date__c, Time.newInstance(23,59,59,59));
        Date FyearDate = Date.newInstance(fdt.yearGMT(),fdt.monthGMT(),1);
        Date d2 = FunnelCalculationHelper.getQuarterEndInDateFormat(FyearDate);
        Date d3 = FunnelCalculationHelper.getQuarterEndInDateFormat(FyearDate.addMonths(3));
        Date d4 = FunnelCalculationHelper.getQuarterEndInDateFormat(FyearDate.addMonths(6));
        Date d5 = FunnelCalculationHelper.getQuarterEndInDateFormat(FyearDate.addMonths(9));
        Date d6 = FunnelCalculationHelper.getQuarterEndInDateFormat(FyearDate.addMonths(10));
        DateTime dt=FunnelCalculationHelper.getQuarterStartDate();
        Boolean ifMgr = FunnelCalculationHelper.findIfManager(cer);
        Boolean ifMgr1 = FunnelCalculationHelper.findIfManager(certs);
        FunnelCalculationHelper.calculateAggregateScoreForManagers(cer);
        system.assertEquals(s,'100');
        
        
    }
    
}