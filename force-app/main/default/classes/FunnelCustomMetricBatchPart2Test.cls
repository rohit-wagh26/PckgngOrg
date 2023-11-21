@isTest
public class FunnelCustomMetricBatchPart2Test{
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

    static testmethod void FunnelCustomMetricBatchTest(){
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());
    
          FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
          fw1.index = 1;   
          fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
          
         
          UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
          //insert r1;
          
          fw1.userRoleId = r1.id;
           
          List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
          insert userList1;
          
          PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_Sales_Profile_Company_Level_access'];
          insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
          
          System.runAs ( userList1[0] ) {
          
              date d = date.newinstance(date.today().year(), 1, 1);
              Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(d);
              insert fiscalYr;
             
              FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
              fw.index = 1;   
              fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;          
             
              UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
              insert r;
              
              fw.userRoleId = r.id;
               
              List<User> userList = FunnelDataFactory.createUser(fw,1);
              insert userList;
              system.debug(userList);
             
              List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
              insert sp;
              system.debug('SP0'+sp[0]);
              
              List<Opportunity > op= FunnelDataFactory.createopplist(userList);
              insert op;
              system.debug('OP0'+op[0]);
              
               fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.type = 'Quantitative';
            fw.calcType = 'Bucketed';
            fw.category = 'Quantitative';
            fw.userType = 'Tenured';
            fw.timing = 'End of month';
            fw.weight = '5';
          
            fw.customobj = 'opportunity';
            fw.customfield = 'id';
            fw.relby = 'ownerId';
            fw.agg = 'count';
            fw.datefield = 'Createddate';
            fw.dateperiod = 'Current Month';
             
           
            List<Certification_Rating__c> certRatings = FunnelDataFactory.createCertificationRatings(fw,28);
            certRatings[0].Timing__c = 'End of quarter';
            
            certRatings[0].SRP_Field_Name__c= 'FMCustom_Metric_1__c';
            certRatings[1].SRP_Field_Name__c= 'FMCustom_Metric_2__c';
            certRatings[1].Custom_Object_Name__c= 'FunnelMetrics__Sales_Rep_Profile__c';
            certRatings[1].Custom_Field_Name__c = 'funnelmetrics__fmcustom_metric_1__c';
            certRatings[1].Custom_Related_by__c = 'funnelmetrics__user_record_name__c';
            certRatings[1].Agg__c = 'count';
            certRatings[1].Duration_Field__c = 'Createddate';
            certRatings[1].Duration_Period__c= 'No time period';
            
            certRatings[2].SRP_Field_Name__c= 'FMCustom_Metric_3__c';
            certRatings[3].SRP_Field_Name__c= 'FMCustom_Metric_4__c';
            certRatings[4].SRP_Field_Name__c= 'FMCustom_Metric_5__c';
            certRatings[5].SRP_Field_Name__c= 'FMCustom_Metric_6__c';
            certRatings[6].SRP_Field_Name__c= 'FMCustom_Metric_7__c';
            certRatings[7].SRP_Field_Name__c= 'FMCustom_Metric_8__c';
            certRatings[8].SRP_Field_Name__c= 'FMCustom_Metric_9__c';
            certRatings[9].SRP_Field_Name__c= 'FMCustom_Metric_10__c';
            certRatings[10].SRP_Field_Name__c= 'FMCustom_Metric_11__c';
            certRatings[11].SRP_Field_Name__c= 'FMCustom_Metric_12__c';
            certRatings[12].SRP_Field_Name__c= 'FMCustom_Metric_13__c';
            certRatings[13].SRP_Field_Name__c= 'FMCustom_Metric_14__c';
            certRatings[14].SRP_Field_Name__c= 'FMCustom_Metric_15__c';
            certRatings[15].SRP_Field_Name__c= 'FMCustom_Metric_16__c';
            certRatings[16].SRP_Field_Name__c= 'FMCustom_Metric_17__c';
            certRatings[17].SRP_Field_Name__c= 'FMCustom_Metric_18__c';
            certRatings[18].SRP_Field_Name__c= 'FMCustom_Metric_19__c';
            certRatings[19].SRP_Field_Name__c= 'FMCustom_Metric_20__c';
            certRatings[20].SRP_Field_Name__c= 'FMCustom_Metric_21__c';
            certRatings[21].SRP_Field_Name__c= 'FMCustom_Metric_22__c';
            certRatings[22].SRP_Field_Name__c= 'FMCustom_Metric_23__c';
            certRatings[23].SRP_Field_Name__c= 'FMCustom_Metric_24__c';
            certRatings[24].SRP_Field_Name__c= 'FMCustom_Metric_25__c';
            certRatings[25].SRP_Field_Name__c= 'FMCustom_Metric_26__c';
            certRatings[26].SRP_Field_Name__c= 'FMCustom_Metric_27__c';
            certRatings[27].SRP_Field_Name__c= 'FMCustom_Metric_28__c';
             
            insert certRatings;
               
              Test.startTest();
            
              FunnelCustomMetricBatch  c = new FunnelCustomMetricBatch (Date.today(),false,false);
              Database.executeBatch(c);
              FunnelCustomMetricBatchPart2  c2 = new FunnelCustomMetricBatchPart2 (Date.today(),false,false);
              Database.executeBatch(c2);
            
              Test.stopTest();
              
              Sales_Rep_Profile__c sp1 = [select id,name,FMCustom_Metric_1__c,FMCustom_Metric_2__c ,FMCustom_Metric_3__c ,FMCustom_Metric_4__c ,FMCustom_Metric_5__c ,FMCustom_Metric_6__c ,FMCustom_Metric_7__c ,FMCustom_Metric_8__c ,FMCustom_Metric_9__c ,FMCustom_Metric_10__c,FMCustom_Metric_11__c,FMCustom_Metric_12__c,FMCustom_Metric_13__c,FMCustom_Metric_14__c,FMCustom_Metric_15__c,FMCustom_Metric_16__c,FMCustom_Metric_17__c,FMCustom_Metric_18__c,FMCustom_Metric_19__c,FMCustom_Metric_20__c,FMCustom_Metric_21__c,FMCustom_Metric_22__c,FMCustom_Metric_23__c,FMCustom_Metric_24__c,FMCustom_Metric_25__c,FMCustom_Metric_26__c,FMCustom_Metric_27__c,FMCustom_Metric_28__c from Sales_Rep_Profile__c where id =:sp[0].id limit 1];
              system.debug('sp1'+sp1);
            
            
              System.assertEquals(1 , sp1.FMCustom_Metric_1__c);
            
             
          
        }
      
    }
}