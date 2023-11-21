@isTest

public class FunnelCreateCertAnswers_Controllerv1Test {
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

    static testmethod void testDisplayAnswers1(){
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());
    
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        //insert r1;        
        //fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
        insert userList1[0];
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        System.runAs ( userList1[0] ) {
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;   
            
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='4 days Prior');
            insert noti ;                       
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
            //insert r;            
            //fw.userRoleId = r.id;
            
            //insert certification
            List<Certification__c> cmgr = FunnelDataFactory.createCertification(fw,spMgr);
            insert cmgr ;
            
            List<User> userList = FunnelDataFactory.createUser(fw,1);
            insert userList;
            system.debug(userList);
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            sp[0].Sales_Manager__c = spMgr[0].id;
            sp[0].Rep_Staus__c = 'Tenured';
            sp[0].Role__c = availableValues[0].getValue(); 
            insert sp;                                                                                                                                                                           
            
            fw = new FunnelDataFactory.FunnelTestWrapper();            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,sp);
            insert certs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.type = 'Qualitative';
            fw.calcType = 'Y/N';
            fw.category = 'Communication';
            fw.userType = 'Both';
            fw.rolesEnabled = availableValues[0].getValue(); 
            //fw.userType = 'Both';
            fw.timing = 'End of month';
            fw.weight = '5';
            List<Certification_Rating__c> certRatings = FunnelDataFactory.createCertificationRatings(fw,10);
            certRatings[0].Timing__c = 'End of quarter';
            certRatings[1].Timing__c = 'Bi-annual';
            certRatings[2].Timing__c = 'Annual';
            
            insert certRatings;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.certificationId = certs[0].id;
            List<Certification_Answer__c> ans = FunnelDataFactory.createCertificationAnswers(fw,certRatings);
            for(Certification_Answer__c a: ans){
                a.Rating_start_date__c = Date.today() - 4;
                a.Due_Date__c = Date.today();
                a.Rating_Score__c = 10;
            }
            
            
            insert ans;
            system.debug('ans--'+ans);
            test.startTest();
            Set<Id> profsForAnsCreation = new Set<Id> ();
            profsForAnsCreation.add(sp[0].id)    ;
            
            
            FunnelCreateCertAnswers_Controllerv1.deleteAndCreateCertAnswers(profsForAnsCreation,profsForAnsCreation,'trigger');
            
            
            List<Sales_Rep_Profile__c> srp= [SELECT id FROM Sales_Rep_Profile__c ];
            List<Certification_Answer__c> ansList = [SELECT Id, Certifcation__c, Rating_Score__c FROM Certification_Answer__c WHERE Rating_Score__c = null AND Certifcation_Rating__r.Assessment_type__c='Qualitative' AND Sales_Rep_Profile__c IN :srp];        
            system.assertEquals(ansList.size(),20);
            
            //
            Set<ID> crId = new Set<ID>();
            for(Certification_Rating__c c :certRatings){
                crId.add(c.id);
            } 
            FunnelCreateCertAnswers_Controllerv1.deleteAndCreateCertAnswersAppSetup(crId,true,false,'All');  
            FunnelCreateCertAnswers_Controllerv1.deleteAndCreateCertAnswersAppSetup(crId,true,true,'All');
               
            test.stopTest();                                                                    
                  
       }    
    }
    static testmethod void testDisplayAnswers2(){
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());
    
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        //insert r1;        
        //fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
        insert userList1[0];
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        System.runAs ( userList1[0] ) {
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;   
            
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='3 days Prior');
            insert noti ;                       
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
            //insert r;            
            //fw.userRoleId = r.id;
            
            //insert certification
            List<Certification__c> cmgr = FunnelDataFactory.createCertification(fw,spMgr);
            insert cmgr ;
            
            List<User> userList = FunnelDataFactory.createUser(fw,1);
            insert userList;
            system.debug(userList);
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            sp[0].Sales_Manager__c = spMgr[0].id;
            sp[0].Rep_Staus__c = 'Tenured';
            sp[0].Role__c = availableValues[0].getValue(); 
            insert sp;                                                                                                                                                                           
            
            fw = new FunnelDataFactory.FunnelTestWrapper();            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,sp);
            insert certs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.type = 'Qualitative';
            fw.calcType = 'Y/N';
            fw.category = 'Communication';
            fw.userType = 'Both';
            fw.rolesEnabled = availableValues[0].getValue(); 
            //fw.userType = 'Both';
            fw.timing = 'End of month';
            fw.weight = '5';
            List<Certification_Rating__c> certRatings = FunnelDataFactory.createCertificationRatings(fw,10);
            certRatings[0].Timing__c = 'End of quarter';
            certRatings[1].Timing__c = 'Bi-annual';
            certRatings[2].Timing__c = 'Annual';
            
            insert certRatings;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.certificationId = certs[0].id;
            List<Certification_Answer__c> ans = FunnelDataFactory.createCertificationAnswers(fw,certRatings);
            for(Certification_Answer__c a: ans){
                a.Rating_start_date__c = Date.today() - 4;
                a.Due_Date__c = Date.today();
                a.Rating_Score__c = 10;
            }
            
            
            insert ans;
            system.debug('ans--'+ans);
            test.startTest();
            Set<Id> profsForAnsCreation = new Set<Id> ();
            profsForAnsCreation.add(sp[0].id)    ;   
            FunnelCreateCertAnswers_Controllerv1.deleteAndCreateCertAnswers(profsForAnsCreation,profsForAnsCreation,'trigger');  
            
            List<Sales_Rep_Profile__c> srp= [SELECT id FROM Sales_Rep_Profile__c ];
            List<Certification_Answer__c> ansList = [SELECT Id, Certifcation__c, Rating_Score__c FROM Certification_Answer__c WHERE Rating_Score__c = null AND Certifcation_Rating__r.Assessment_type__c='Qualitative' AND Sales_Rep_Profile__c IN :srp];        
            system.assertEquals(ansList.size(),20);
                
            test.stopTest();                                                                    
             //
            Set<ID> crId = new Set<ID>();
            for(Certification_Rating__c c :certRatings){
                crId.add(c.id);
            }   
            FunnelCreateCertAnswers_Controllerv1.deleteAndCreateCertAnswersAppSetup(crId,true,false,'All');
            FunnelCreateCertAnswers_Controllerv1.deleteAndCreateCertAnswersAppSetup(crId,true,true,'All');      
       }    
    }
    
    static testmethod void testDisplayAnswers3(){
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());
    
        FunnelDataFactory.FunnelTestWrapper fw1 = new FunnelDataFactory.FunnelTestWrapper();
        fw1.index = 1;   
        fw1.ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;                
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole0A'+fw1.index , Name = 'My Role'+fw1.index);
        //insert r1;        
        //fw1.userRoleId = r1.id;
        
        List<User> userList1 = FunnelDataFactory.createUser(fw1,1);
        insert userList1[0];
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = userList1[0].id, PermissionSetId = ps.Id );
        
        System.runAs ( userList1[0] ) {
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;   
            
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '3 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='5 days Prior');
            insert noti ;                       
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
            //insert r;            
            //fw.userRoleId = r.id;
            
            //insert certification
            List<Certification__c> cmgr = FunnelDataFactory.createCertification(fw,spMgr);
            insert cmgr ;
            
            List<User> userList = FunnelDataFactory.createUser(fw,1);
            insert userList;
            system.debug(userList);
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            
            List<Sales_Rep_Profile__c> sp = FunnelDataFactory.createSalesReplist(userList);
            sp[0].Sales_Manager__c = spMgr[0].id;
            sp[0].Rep_Staus__c = 'Tenured';
            sp[0].Role__c = availableValues[0].getValue(); 
            insert sp;                                                                                                                                                                           
            
            fw = new FunnelDataFactory.FunnelTestWrapper();            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,sp);
            insert certs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.type = 'Qualitative';
            fw.calcType = 'Y/N';
            fw.category = 'Communication';
            fw.userType = 'Both';
            fw.rolesEnabled = availableValues[0].getValue(); 
            //fw.userType = 'Both';
            fw.timing = 'End of month';
            fw.weight = '5';
            List<Certification_Rating__c> certRatings = FunnelDataFactory.createCertificationRatings(fw,10);
            certRatings[0].Timing__c = 'End of quarter';
            certRatings[1].Timing__c = 'Bi-annual';
            certRatings[2].Timing__c = 'Annual';
            
            insert certRatings;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.certificationId = certs[0].id;
            List<Certification_Answer__c> ans = FunnelDataFactory.createCertificationAnswers(fw,certRatings);
            for(Certification_Answer__c a: ans){
                a.Rating_start_date__c = Date.today() - 4;
                a.Due_Date__c = Date.today();
                a.Rating_Score__c = 10;
            }
            
            
            insert ans;
            system.debug('ans--'+ans);
            test.startTest();
            Set<Id> profsForAnsCreation = new Set<Id> ();
            profsForAnsCreation.add(sp[0].id)    ;   
            FunnelCreateCertAnswers_Controllerv1.deleteAndCreateCertAnswers(profsForAnsCreation,profsForAnsCreation,'trigger');   
            
            List<Sales_Rep_Profile__c> srp= [SELECT id FROM Sales_Rep_Profile__c ];
            List<Certification_Answer__c> ansList = [SELECT Id, Certifcation__c, Rating_Score__c FROM Certification_Answer__c WHERE Rating_Score__c = null AND Certifcation_Rating__r.Assessment_type__c='Qualitative' AND Sales_Rep_Profile__c IN :srp];        
            system.assertEquals(ansList.size(),20);
               
            test.stopTest();                                                                    
             //
            Set<ID> crId = new Set<ID>();
            for(Certification_Rating__c c :certRatings){
                crId.add(c.id);
            } 
            FunnelCreateCertAnswers_Controllerv1.deleteAndCreateCertAnswersAppSetup(crId,true,false,'All');        
            FunnelCreateCertAnswers_Controllerv1.deleteAndCreateCertAnswersAppSetup(crId,true,true,'All');      
       }    
    }
    
 }