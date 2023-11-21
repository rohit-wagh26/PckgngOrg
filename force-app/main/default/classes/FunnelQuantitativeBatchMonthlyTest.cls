@isTest

public class FunnelQuantitativeBatchMonthlyTest{
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

    static testmethod void testMonthly(){
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
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        System.runAs ( userList1[0] ) {
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ; 
            
            Yearly_goals_by_Role__c yg= new Yearly_goals_by_Role__c(Name = 'Test');
            insert yg; 
            /*insert manager record*/
            FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;   
            fw.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                        
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole'+fw.index , Name = 'My Role'+fw.index);
            insert r;            
            fw.userRoleId = r.id;
            
            /*List<User> userList = FunnelDataFactory.createUser(fw,1);
            insert userList;
            system.debug(userList);
            UserRecMgr = userList[0];*/
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
            
            List<User> userList = FunnelDataFactory.createUser(fw,5);
            insert userList;
            system.debug(userList);
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            String val = availableValues[0].getValue();
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            sp[0].Sales_Manager__c = spMgr[0].id;
            sp[0].Rep_Staus__c = 'Tenured';
            sp[0].Role__c = val;
            sp[0].X12_Month_Rolling_Opportunity_Close_Rate__c = 0;
            sp[0].YTD_Average_Sales_Cycle__c = 0;
            sp[0].Rep_Start_Date__c = Date.Today() - 1;
            
            sp[1].Sales_Manager__c = spMgr[0].id;
            sp[1].Rep_Staus__c = 'Tenured';
            sp[1].Role__c = val;
            sp[1].X12_Month_Rolling_Opportunity_Close_Rate__c = 1;
            sp[1].YTD_Average_Sales_Cycle__c = 0;
            sp[1].Rep_Start_Date__c = Date.Today() - 1;
            
            sp[2].Sales_Manager__c = spMgr[0].id;
            sp[2].Rep_Staus__c = 'Tenured';
            sp[2].Role__c = val;
            sp[2].X12_Month_Rolling_Opportunity_Close_Rate__c = 2;
            sp[2].YTD_Average_Sales_Cycle__c = 0;
            sp[2].Rep_Start_Date__c = Date.Today() - 1;
            
            sp[3].Sales_Manager__c = spMgr[0].id;
            sp[3].Rep_Staus__c = 'Tenured';
            sp[3].Role__c = val;
            sp[3].X12_Month_Rolling_Opportunity_Close_Rate__c = 3;
            sp[3].YTD_Average_Sales_Cycle__c = 0;
            sp[3].Rep_Start_Date__c = Date.Today() - 1;
            
            sp[4].Sales_Manager__c = spMgr[0].id;
            sp[4].Rep_Staus__c = 'Tenured';
            sp[4].Role__c = val;
            sp[4].X12_Month_Rolling_Opportunity_Close_Rate__c = 4;
            sp[4].YTD_Average_Sales_Cycle__c = 0;
            sp[4].Rep_Start_Date__c = Date.Today() - 1;
            insert sp;            
            
            Id profId = sp[0].id;
            
            List<Certification__c> c = FunnelDataFactory.createCertification(fw,sp);
            insert c;
            
            fw.certificationId = c[0].id; 
            fw.type = 'Quantitative';   
            fw.calcType = 'Bucketed';
            fw.category = 'Test category';            
            fw.userType = 'Tenured';
            fw.timing = 'End of month';
            fw.weight = '4';      
                              
            fw.rolesEnabled = val;          
            List<Certification_Rating__c> ratings = FunnelDataFactory.createCertificationRatings(fw,4);
            ratings[0].Field_Name__c = 'X12_Month_Rolling_Opportunity_Close_Rate__c';
            ratings[0].X0LevelLow__c = 0;
            ratings[0].X0LevelHigh__c = 1;
            ratings[0].X1LevelLow__c = 1;
            ratings[0].X1LevelHigh__c = 2;
            ratings[0].X2LevelLow__c = 2;
            ratings[0].X2LevelHigh__c = 3;
            ratings[0].X3LevelLow__c = 3;
            ratings[0].X3LevelHigh__c = 4;
            ratings[0].X4LevelLow__c = 4;
            ratings[0].X4LevelHigh__c = 5;
            ratings[0].Deactivated__c = false; 
            
            
            ratings[1].Field_Name__c = 'YTD_Avg_Length_of_Sales_Cycle_percentage__c';
            ratings[1].X0LevelLow__c = 4;
            ratings[1].X0LevelHigh__c = 0;
            ratings[1].X1LevelLow__c = 4;
            ratings[1].X1LevelHigh__c = 3;
            ratings[1].X2LevelLow__c = 3;
            ratings[1].X2LevelHigh__c = 2;
            ratings[1].X3LevelLow__c = 2;
            ratings[1].X3LevelHigh__c = 1;
            ratings[1].X4LevelLow__c = 1;
            ratings[1].X4LevelHigh__c = 0; 
            ratings[1].Deactivated__c = false; 
            
            ratings[2].Field_Name__c = 'X12_Month_Rolling_Opportunity_Close_Rate__c';
            ratings[2].Timing__c = 'End of quarter';
            ratings[2].X0LevelLow__c = 0;
            ratings[2].X0LevelHigh__c = 1;
            ratings[2].X1LevelLow__c = 1;
            ratings[2].X1LevelHigh__c = 2;
            ratings[2].X2LevelLow__c = 2;
            ratings[2].X2LevelHigh__c = 3;
            ratings[2].X3LevelLow__c = 3;
            ratings[2].X3LevelHigh__c = 4;
            ratings[2].X4LevelHigh__c = 4;
            ratings[2].X4LevelLow__c = 5;
            ratings[2].Deactivated__c = false;          
                                    
            insert ratings;
            
            fw.certificationId = c[0].id;
            List<Certification_Answer__c> ans = FunnelDataFactory.createCertificationAnswers(fw,ratings);
            
            
            ans[2].Rating_Score__c = 4;
            insert ans;
            
            
                        
            /*stop insert profile record*/                          
            
            Test.startTest();
           
                 FunnelQuantitativeBatchMonthly mq = new FunnelQuantitativeBatchMonthly (Date.today(),false,false);
                 Database.executeBatch(mq);
                                   
            Test.stopTest();   
            
            List<Certification_Answer__c> ca = [select Rating_Score__c from Certification_Answer__c where Certifcation__c = :c[1].id] ; 
            System.debug('ca --tc'+ca );
            system.assertEquals(ca[0].Rating_Score__c ,2);
            //system.assertEquals(ca[1].Rating_Score__c ,10);
               
       }              
      
    }


}