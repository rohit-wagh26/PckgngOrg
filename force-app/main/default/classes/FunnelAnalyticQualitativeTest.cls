@isTest

public class FunnelAnalyticQualitativeTest{
    /*public class MetadataServiceMock implements WebServiceMock, HttpCalloutMock {
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
    static testmethod void testAggregation(){
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());
    
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
         
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        
        List<User> us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 2;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u2 = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 3;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u3 = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 4;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u4 = us[0];
         
         PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
         insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id );
        
        List<User> userListcomp = FunnelDataFactory.createUser(fw,10);
        insert userListcomp;

        system.runAs(u){
            
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            List<Sales_Rep_Profile__c> spcomp = FunnelDataFactory.createSalesReplist(userListcomp);
            insert spcomp;
            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,spcomp);
            insert certs;
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
           
            List<Certification_Rating__c> rating = new List<Certification_Rating__c>();
          
            Certification_Rating__c cr = new Certification_Rating__c();
            cr.Assessment_type__c = 'Qualitative';   
            cr.Calculation_type__c = 'Y/N';
            cr.Category__c = 'Test';            
            cr.User_Type__c = 'New';
            cr.Timing__c = 'End of month';
            cr.Weight__c = '4';
            cr.Description__c = 'Test description 1';
            cr.Roles_Enabled__c =  availableValues[0].getValue();
            cr.Important_flag__c = true;
            cr.Importance__c = 1;
            rating.add(cr);
            
            insert rating ;
            
            List<Sales_Rep_Profile__c> srplist = new List<Sales_Rep_Profile__c>();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgr;
            srplist.add(spMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            insert spProf;
            srplist.add(spProf);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spProf.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf1 = FunnelDataFactory.createSalesRep(fw);
            insert spProf1;
            srplist.add(spProf1);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spProf.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf2 = FunnelDataFactory.createSalesRep(fw);
            insert spProf2;
           
            srplist.add(spProf2);
           
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spProf.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf3 = FunnelDataFactory.createSalesRep(fw);
            insert spProf3;
           
            srplist.add(spProf3);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spProf.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf4 = FunnelDataFactory.createSalesRep(fw);
            insert spProf4;
            srplist.add(spProf4);
            
            
           
            
            
            List<Certification__c> cerList = FunnelDataFactory.createCertification(fw,srplist); 
            cerList[0].Overall_Rating__c = 10;
            cerList[0].Overall_Qualitative_Rating__c = 10;
            cerList[0].Overall_Quantitative_Rating__c = 5;
            
            cerList[1].Overall_Rating__c = 5;
            cerList[1].Overall_Qualitative_Rating__c = 5;
            cerList[1].Overall_Quantitative_Rating__c = 5;
            
            cerList[2].Overall_Rating__c = 0;
            cerList[2].Overall_Qualitative_Rating__c = 0;
            cerList[2].Overall_Quantitative_Rating__c = 5;
            
            cerList[3].Overall_Rating__c = null;
            cerList[3].Overall_Qualitative_Rating__c = null;
            cerList[3].Overall_Quantitative_Rating__c = 5;
            
            cerList[4].Overall_Rating__c = 10;
            cerList[4].Overall_Qualitative_Rating__c = 10;
            cerList[4].Overall_Quantitative_Rating__c = 5;
            
            cerList[5].Overall_Rating__c = 5;
            cerList[5].Overall_Qualitative_Rating__c = 5;
            cerList[5].Overall_Quantitative_Rating__c = 5;
            
            insert cerList;
           
            List<Certification_Answer__c> anslist = new List<Certification_Answer__c>();
            fw.certificationId = cerList[0].id;
          
            
            Certification_Answer__c crep = new Certification_Answer__c();
            
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 10;
            crep.Sales_Rep_Profile__c= spMgr.id;
            crep.Certifcation_Rating__c = rating[0].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 8;
            crep.Sales_Rep_Profile__c= spProf.id;
            crep.Certifcation_Rating__c = rating[0].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 5;
            crep.Sales_Rep_Profile__c= spProf1.id;
            crep.Certifcation_Rating__c = rating[0].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 2;
            crep.Sales_Rep_Profile__c= spProf2.id;
            crep.Certifcation_Rating__c = rating[0].id;
             anslist.add(crep);
             
             crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 0;
            crep.Sales_Rep_Profile__c= spProf3.id;
            crep.Certifcation_Rating__c = rating[0].id;
             anslist.add(crep);
             
             crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = null;
            crep.Sales_Rep_Profile__c= spProf4.id;
            crep.Certifcation_Rating__c = rating[0].id;
             anslist.add(crep);
            
            insert anslist;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
           
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;  
            fw.levelName = 'Region';
            fw.levelValue = 'US West';
            fw.salesProfForCompLevel = spProf.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spProf);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            test.startTest();   
            PageReference myVfPage = Page.FunnelAnalyticQualitative;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Country');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Region');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , 'All'); 
                                   
            
            
            FunnelAnalyticQualitativeController ft = new FunnelAnalyticQualitativeController();
            
            ft.mid  = rating[0].id;
            ft.metric();
            
            system.assertEquals(ft.mdisplay,null); 
            Test.stopTest();
            
                                                                                
                  
       }              
      
    }
    
     static testmethod void testRepScenario() {
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());           
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
         
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 3;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        
        List<User> us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u3 = us[0];
         
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u = us[0];
        
        List<User> userListcomp = FunnelDataFactory.createUser(fw,10);
        insert userListcomp;
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 2;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u2 = us[0];
        system.debug(' user '+u2);
        
         PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
         insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps.Id );
        
        system.runAs(u2){
            
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;

            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
           
            List<Certification_Rating__c> rating = new List<Certification_Rating__c>();
          
            Certification_Rating__c cr = new Certification_Rating__c();
            cr.Assessment_type__c = 'Qualitative';   
            cr.Calculation_type__c = 'Y/N';
            cr.Category__c = 'Test';            
            cr.User_Type__c = 'New';
            cr.Timing__c = 'End of month';
            cr.Weight__c = '4';
            cr.Description__c = 'Test description 1';
            cr.Roles_Enabled__c =  availableValues[0].getValue();
            cr.Important_flag__c = true;
            cr.Importance__c = 1;
            rating.add(cr);
            
             
            
            insert rating ;
            
            List<Sales_Rep_Profile__c> spcomp = FunnelDataFactory.createSalesReplist(userListcomp);
            insert spcomp;
            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,spcomp);
            insert certs;


            List<Sales_Rep_Profile__c> srplist = new List<Sales_Rep_Profile__c>();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;
            fw.userId = u3.id;
             
            Sales_Rep_Profile__c spMgrMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgrMgr;
            srplist.add(spMgrMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            fw.salesMgr = spMgrMgr.id;
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgr;
            srplist.add(spMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            spProf.role__c = availableValues[0].getValue();
            insert spProf;
            srplist.add(spProf);
            
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(srplist);
            insert spsnap ;
            
            Important_rating__c i = FunnelDataFactory.createImportantRating(rating[0].id,availableValues[0].getValue());
            insert i;
            
            List<Certification__c> cerList = FunnelDataFactory.createCertification(fw,srplist); 
            cerList[0].Overall_Rating__c = 5;
            cerList[0].Overall_Qualitative_Rating__c = 5;
            cerList[0].Overall_Quantitative_Rating__c = 5;
            
            cerList[1].Overall_Rating__c = 5;
            cerList[1].Overall_Qualitative_Rating__c = 5;
            cerList[1].Overall_Quantitative_Rating__c = 5;
            
            cerList[2].Overall_Rating__c = 5;
            cerList[2].Overall_Qualitative_Rating__c = 5;
            cerList[2].Overall_Quantitative_Rating__c = 5;
            
            insert cerList;
            
            
            List<Certification_Answer__c> anslist = new List<Certification_Answer__c>();
            fw.certificationId = cerList[0].id;
            List<Certification_Answer__c> ans = FunnelDataFactory.createCertificationAnswers(fw,rating );
            Certification_Answer__c crep = new Certification_Answer__c();
            
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 10;
            crep.Sales_Rep_Profile__c= spProf.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[0].id;
            insert crep;
            
            anslist.add(crep);
            
            
            
            List<Certification_Snapshot__c> certsnap= FunnelDataFactory.createCertificationSnapshot(cerList);  
            insert certsnap;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgrMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgrMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            List<Company_Level_Junction_snapshot__c> cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
            insert cs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Region';
            fw.levelValue = 'US West';
            fw.salesProfForCompLevel = spMgr.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
            insert cs;
            
            test.startTest();
                         
            FunnelAnalyticQualitativeController ft = new FunnelAnalyticQualitativeController ();
            system.assertEquals(ft.mdisplay.size(),1);                      
            test.stopTest();
            
            
        }
                            
    }
    
     static testmethod void testRoleAggregationScenario() {
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());           
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
         
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        
        List<User> us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u = us[0];
        
        List<User> userListcomp = FunnelDataFactory.createUser(fw,10);
        insert userListcomp;
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 2;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u2 = us[0];
        system.debug(' user '+u2);
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 3;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u3 = us[0];
        
         PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
         insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps.Id );
        
        system.runAs(u2){
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
           
            List<Certification_Rating__c> rating = new List<Certification_Rating__c>();
          
            Certification_Rating__c cr = new Certification_Rating__c();
            cr.Assessment_type__c = 'Qualitative';   
            cr.Calculation_type__c = 'Y/N';
            cr.Category__c = 'Test';            
            cr.User_Type__c = 'New';
            cr.Timing__c = 'End of month';
            cr.Weight__c = '4';
            cr.Description__c = 'Test description 1';
            cr.Roles_Enabled__c =  availableValues[0].getValue();
            cr.Important_flag__c = true;
            cr.Importance__c = 1;
            rating.add(cr);
            
            insert rating ;
            
            List<Sales_Rep_Profile__c> spcomp = FunnelDataFactory.createSalesReplist(userListcomp);
            insert spcomp;
            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,spcomp);
            insert certs;
            List<Sales_Rep_Profile__c> srplist = new List<Sales_Rep_Profile__c>();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;
            fw.userId = u3.id;
            Sales_Rep_Profile__c spMgrMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgrMgr ;
            srplist.add(spMgrMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            fw.salesMgr = spMgrMgr.id;
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgr;
            srplist.add(spMgr);
            
           // DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
           // List<PicklistEntry> availableValues = describe.getPicklistValues();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            String val = availableValues[0].getValue();
            spProf.Role__c = val;
            insert spProf;
            
            Important_rating__c i = FunnelDataFactory.createImportantRating(rating[0].id,availableValues[0].getValue());
            insert i;
            
            srplist.add(spProf);
            
             Sales_Rep_Profile__c spProf1 = FunnelDataFactory.createSalesRep(fw);
              spProf1.Role__c = val;
            insert spProf1;
            srplist.add(spProf1);
            
           
            
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(srplist);
            insert spsnap ;
            
            
            
            List<Certification__c> cerList = FunnelDataFactory.createCertification(fw,srplist); 
            cerList[0].Overall_Rating__c = 0;
            cerList[0].Overall_Qualitative_Rating__c = 0;
            cerList[0].Overall_Quantitative_Rating__c = 5;
            
            cerList[1].Overall_Rating__c = 10;
            cerList[1].Overall_Qualitative_Rating__c = 10;
            cerList[1].Overall_Quantitative_Rating__c = 5;
            
            cerList[2].Overall_Rating__c = 5;
            cerList[2].Overall_Qualitative_Rating__c = 5;
            cerList[2].Overall_Quantitative_Rating__c = 5;
            
            cerList[3].Overall_Rating__c = 0;
            cerList[3].Overall_Qualitative_Rating__c = 5;
            cerList[3].Overall_Quantitative_Rating__c = 5;
            
            
            
            
            insert cerList ;
            
            List<Certification_Answer__c> anslist = new List<Certification_Answer__c>();
            
            Certification_Answer__c crep = new Certification_Answer__c();
            
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 10;
            crep.Sales_Rep_Profile__c= spMgr.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[0].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 10;
            crep.Sales_Rep_Profile__c= spMgr.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[1].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 8;
            crep.Sales_Rep_Profile__c= spProf.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[2].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 5;
            crep.Sales_Rep_Profile__c= spProf1.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[3].id;
            anslist.add(crep);
            
           
            
            insert anslist;
            
            List<Certification_Snapshot__c> certsnap= FunnelDataFactory.createCertificationSnapshot(cerList);  
            insert certsnap;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgrMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgrMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            List<Company_Level_Junction_snapshot__c> cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
            insert cs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Region';
            fw.levelValue = 'US West';
            fw.salesProfForCompLevel = spMgr.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
            insert cs;
            
            test.startTest();
            
            FunnelAnalyticQualitativeController ft = new FunnelAnalyticQualitativeController();

            ft.fw.labelOne = 'Region';
            ft.fw.labelTwo = 'Rep';
            ft.fw.labelThree = 'Role';
            ft.fw.SelectedLevelOne = 'US West';
            ft.fw.SelectedLevelTwo = 'All';
            ft.fw.SelectedLevelThree = val;
            
            ft.showUpdated();
            ft.mid  = rating[0].id;
            //ft.metric();
            system.assertEquals(ft.mdisplay.size(),1);                      

            test.stopTest();
             
        }
                            
    } 
    
    
    
    static testmethod void testNavigation() {           
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
         
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        
        List<User> us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u = us[0];
        
        List<User> userListcomp = FunnelDataFactory.createUser(fw,10);
        insert userListcomp;
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 2;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u2 = us[0];
        system.debug(' user '+u2);
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 3;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u3 = us[0];
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps.Id );
        
        system.runAs(u2){
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            List<Sales_Rep_Profile__c> spcomp = FunnelDataFactory.createSalesReplist(userListcomp);
            insert spcomp;
            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,spcomp);
            insert certs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;
            fw.userId = u3.id;
            Sales_Rep_Profile__c spMgrMgr = FunnelDataFactory.createSalesRep(fw);
            
            insert spMgrMgr;
             
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            fw.salesMgr = spMgrMgr.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            
            insert spMgr;
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            String val = availableValues[0].getValue();
            spProf.Role__c = val;
            insert spProf;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgrMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgrMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            system.debug('cl --mgmg'+cl);
           
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Region';
            fw.levelValue = 'US West';
            fw.salesProfForCompLevel = spMgr.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            system.debug('cl --mg'+cl);
            
            List<Company_Level_Junction_snapshot__c> cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
            insert cs;
            
            test.startTest();
            
            FunnelAnalyticQualitativeController  fc = new FunnelAnalyticQualitativeController ();

            fc.fw.labelOne = 'Region';
            fc.fw.labelTwo = 'Rep';
            fc.fw.labelThree = 'Role';
            fc.fw.SelectedLevelOne = 'US West';
            fc.fw.SelectedLevelTwo = 'All';
            fc.fw.SelectedLevelThree = val;
            fc.Fs = true;
            fc.Ms = true;
            fc.displayPopup = true;
            fc.popClose = '';
            fc.isMgr = true;
            fc.isReset = true;
            fc.crumValue = '';
            fc.levelValue = '';
            fc.secondImp = '';
            
            fc.reset();
            //fc.levelOneAction();
            fc.levelTwoAction();
            String ab = fc.getMps();
            String ac = fc.getSps();
            fc.assignFs();
            fc.breadCrumClick();
            fc.popup();
            PageReference p = fc.navigateToCalculator();
            system.assert(true,p.getUrl().contains('FunnelCalculator'));
            p = fc.navigateToHomePage();
            system.assert(true,p.getUrl().contains('FunnelHomePage'));
            p = fc.navigateToReportsPage();
            system.assert(true,p.getUrl().contains('FunnelReportingPage'));
            p = fc.navigateToAppSetup();
            system.assert(true,p.getUrl().contains('FunnelSalesCertification'));
            p = fc.navigateToCertificateReports();
            system.assert(true,p.getUrl().contains('FunnelCertificationReports'));
            p = fc.navigateToDashboard();
            system.assert(true,p.getUrl().contains('FunnelSalesDashoard'));
            
            p = fc.navigateToCertification();
            system.assert(true,p.getUrl().contains('FunnelCerificationTable'));
            p = fc.navigateToFunnelAnalyticQualitative();
            system.assert(true,p.getUrl().contains('FunnelAnalyticQualitative'));
            p = fc.navigateToFunnelAnalytic();
            system.assert(true,p.getUrl().contains('FunnelAnalytic'));
            p= fc.navigateToDetailPage();
            p= fc.navigateToTrendingByRep();
            p= fc.navigateToTrendingBySkill();
            p= fc.navigateToAnnualizationDashboard();
            p= fc.navigateToGoals();
            p= fc.navigateToHelpMenu();
            
            fc.updateRec();
             
            
            fc.getCharLabels();
            fc.getCharLabelsM();
            fc.getFScores();
            fc.getLps();
            fc.getHps();
            fc.getAps();
            fc.getExs();
            fc.getGos();
            fc.getSas();
            fc.getPos();
            fc.getFas();
            
            //fc.levelOneAction();
            //fc.levelTwoAction();
            fc.reset();
            fc.getCharLabelsMR();
           fc.getExsR();
           fc.getGosR();
           fc.getSasR();
           fc.getPosR();
           fc.getFasR();
           fc.getfssr();
           fc.getMnames();
           // fc.statusFilter();
           // fc.getRepSat();
            test.stopTest();
        }
                            
    }  
     static testmethod void testTeamAggregationRep() {
		Test.setMock(WebServiceMock.class, new MetadataServiceMock());
		Test.setMock(HttpCalloutMock.class, new MetadataServiceMock());           
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
         
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        
        List<User> us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 2;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u2 = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 3;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u3 = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 4;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u4 = us[0];
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 5;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u5 = us[0];
        
        List<User> userListcomp = FunnelDataFactory.createUser(fw,10);
        insert userListcomp;
         
         PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
         insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id ); 
        
        system.runAs(u){
            
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            List<Sales_Rep_Profile__c> spcomp = FunnelDataFactory.createSalesReplist(userListcomp);
            insert spcomp;
            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,spcomp);
            insert certs;
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
           
            List<Certification_Rating__c> rating = new List<Certification_Rating__c>();
          
            Certification_Rating__c cr = new Certification_Rating__c();
            cr.Assessment_type__c = 'Qualitative';   
            cr.Calculation_type__c = 'Y/N';
            cr.Category__c = 'Test';            
            cr.User_Type__c = 'New';
            cr.Timing__c = 'End of month';
            cr.Weight__c = '4';
            cr.Description__c = 'Test description 1';
            cr.Roles_Enabled__c =  availableValues[0].getValue();
            cr.Important_flag__c = true;
            cr.Importance__c = 1;
            rating.add(cr);
            
            
            insert rating ;

            List<Sales_Rep_Profile__c> srplist = new List<Sales_Rep_Profile__c>();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u5.id;
            Sales_Rep_Profile__c spMgrMgr = FunnelDataFactory.createSalesRep(fw);
            fw.salesMgr = spMgrMgr.id;
            insert spMgrMgr;
            srplist.add(spMgrMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            fw.salesMgr = spMgrMgr.id;
            system.debug(' fw.userId '+fw.userId);
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            
            insert spMgr;
            srplist.add(spMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            insert spProf;
            srplist.add(spProf);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf1 = FunnelDataFactory.createSalesRep(fw);
            insert spProf1;
            srplist.add(spProf1);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf2 = FunnelDataFactory.createSalesRep(fw);
            insert spProf2;
            srplist.add(spProf2);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf3 = FunnelDataFactory.createSalesRep(fw);
            insert spProf3;
            srplist.add(spProf3);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;        
            fw.userId = u3.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf4 = FunnelDataFactory.createSalesRep(fw);
            insert spProf4;
            srplist.add(spProf4);
            
            
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(srplist);
            insert spsnap ;
            
            List<Certification__c> cerList = FunnelDataFactory.createCertification(fw,srplist); 
            cerList[0].Overall_Rating__c = 1;
            cerList[0].Overall_Qualitative_Rating__c =1;
            cerList[0].Overall_Quantitative_Rating__c = 5;
            
            cerList[1].Overall_Rating__c = 5;
            cerList[1].Overall_Qualitative_Rating__c = 5;
            cerList[1].Overall_Quantitative_Rating__c = 5;
            
            cerList[2].Overall_Rating__c = 10;
            cerList[2].Overall_Qualitative_Rating__c = 10;
            cerList[2].Overall_Quantitative_Rating__c = 5;
            
            cerList[3].Overall_Rating__c = 5;
            cerList[3].Overall_Qualitative_Rating__c = 10;
            cerList[3].Overall_Quantitative_Rating__c = 5;
            
            cerList[4].Overall_Rating__c = 5;
            cerList[4].Overall_Qualitative_Rating__c = 10;
            cerList[4].Overall_Quantitative_Rating__c = 5;
            
            cerList[5].Overall_Rating__c = 5;
            cerList[5].Overall_Qualitative_Rating__c = 10;
            cerList[5].Overall_Quantitative_Rating__c = 5;
            
            insert cerList;
            
             List<Certification_Answer__c> anslist = new List<Certification_Answer__c>();
            
            Certification_Answer__c crep = new Certification_Answer__c();
            
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 10;
            crep.Sales_Rep_Profile__c= spMgr.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[1].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 8;
            crep.Sales_Rep_Profile__c= spProf.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[2].id;
             anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 5;
            crep.Sales_Rep_Profile__c= spProf1.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[3].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 2;
            crep.Sales_Rep_Profile__c= spProf2.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[4].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 0;
            crep.Sales_Rep_Profile__c= spProf3.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[5].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = null;
            crep.Sales_Rep_Profile__c= spProf4.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[6].id;
            anslist.add(crep);
            
            insert anslist;
            
            List<Certification_Snapshot__c> certsnap= FunnelDataFactory.createCertificationSnapshot(cerList);  
            insert certsnap;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgrMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgrMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            List<Company_Level_Junction_snapshot__c> cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
            insert cs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;  
            fw.levelName = 'Region';
            fw.levelValue = 'US West';
            fw.salesProfForCompLevel = spMgr.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
            insert cs;
            
               
            PageReference myVfPage = Page.FunnelAnalyticQualitative;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getparameters().put('labelOne' , 'Region');
            ApexPages.currentPage().getparameters().put('labelTwo' , 'Rep');
            ApexPages.currentPage().getparameters().put('labelThree' , 'Role');
            ApexPages.currentPage().getparameters().put('selectOne' , 'US West');
            ApexPages.currentPage().getparameters().put('selectTwo' , 'All');
            ApexPages.currentPage().getparameters().put('selectThree' , 'All'); 
            
            test.startTest();
                                 
            FunnelAnalyticQualitativeController fc = new FunnelAnalyticQualitativeController();
            fc.mid  = rating[0].id;
            fc.metric();
            system.assertEquals(fc.mdisplay,null); 
            
            test.stopTest();
        }
                            
    }         
    
     static testmethod void testRoleAggregationScenarioNoRep() {           
        
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
         
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        
        List<User> us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u = us[0];
        
        List<User> userListcomp = FunnelDataFactory.createUser(fw,10);
        insert userListcomp;
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 2;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u2 = us[0];
        system.debug(' user '+u2);
        
        fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 3;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u3 = us[0];
        
         PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
         insert new PermissionSetAssignment(AssigneeId = u2.id, PermissionSetId = ps.Id );
        
        system.runAs(u2){
        
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            system.debug(' fw.userId '+fw.userId);
            
            DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
            List<PicklistEntry> availableValues = describe.getPicklistValues();
           
            List<Certification_Rating__c> rating = new List<Certification_Rating__c>();
          
            Certification_Rating__c cr = new Certification_Rating__c();
            cr.Assessment_type__c = 'Qualitative';   
            cr.Calculation_type__c = 'Y/N';
            cr.Category__c = 'Test';            
            cr.User_Type__c = 'New';
            cr.Timing__c = 'End of month';
            cr.Weight__c = '4';
            cr.Description__c = 'Test description 1';
            cr.Roles_Enabled__c =  availableValues[0].getValue();
            cr.Important_flag__c = true;
            cr.Importance__c = 1;
            rating.add(cr);
            
            insert rating ;
            
            List<Sales_Rep_Profile__c> spcomp = FunnelDataFactory.createSalesReplist(userListcomp);
            insert spcomp;
            
            List<Certification__c> certs = FunnelDataFactory.createCertification(fw,spcomp);
            insert certs;
            List<Sales_Rep_Profile__c> srplist = new List<Sales_Rep_Profile__c>();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 3;
            fw.userId = u3.id;
            Sales_Rep_Profile__c spMgrMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgrMgr ;
            srplist.add(spMgrMgr);
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;
            fw.userId = u.id;
            fw.salesMgr = spMgrMgr.id;
            Sales_Rep_Profile__c spMgr = FunnelDataFactory.createSalesRep(fw);
            insert spMgr;
            srplist.add(spMgr);
            
           // DescribeFieldResult describe = Sales_Rep_Profile__c.Role__c.getDescribe();
           // List<PicklistEntry> availableValues = describe.getPicklistValues();
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 2;        
            fw.userId = u2.id;
            fw.salesMgr = spMgr.id;
            system.debug(' fw.userId '+fw.userId);        
            Sales_Rep_Profile__c spProf = FunnelDataFactory.createSalesRep(fw);
            String val = availableValues[0].getValue();
            spProf.Role__c = val;
            insert spProf;
            
            Important_rating__c i = FunnelDataFactory.createImportantRating(rating[0].id,availableValues[0].getValue());
            insert i;
            
            srplist.add(spProf);
            
             Sales_Rep_Profile__c spProf1 = FunnelDataFactory.createSalesRep(fw);
              spProf1.Role__c = val;
            insert spProf1;
            srplist.add(spProf1);
            
            
           
            
            List<Sales_Rep_Profile_Snapshot__c> spsnap = FunnelDataFactory.createSalesReplistSnapshot(srplist);
            insert spsnap ;
            
            
            
            List<Certification__c> cerList = FunnelDataFactory.createCertification(fw,srplist); 
            cerList[0].Overall_Rating__c = 0;
            cerList[0].Overall_Qualitative_Rating__c = 0;
            cerList[0].Overall_Quantitative_Rating__c = 5;
            
            cerList[1].Overall_Rating__c = 10;
            cerList[1].Overall_Qualitative_Rating__c = 10;
            cerList[1].Overall_Quantitative_Rating__c = 5;
            
            cerList[2].Overall_Rating__c = 5;
            cerList[2].Overall_Qualitative_Rating__c = 5;
            cerList[2].Overall_Quantitative_Rating__c = 5;
            
            cerList[3].Overall_Rating__c = 0;
            cerList[3].Overall_Qualitative_Rating__c = 5;
            cerList[3].Overall_Quantitative_Rating__c = 5;
            
            
            
            
            insert cerList ;
            
            List<Certification_Answer__c> anslist = new List<Certification_Answer__c>();
            
            Certification_Answer__c crep = new Certification_Answer__c();
            
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 10;
            crep.Sales_Rep_Profile__c= spMgr.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[0].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 10;
            crep.Sales_Rep_Profile__c= spMgr.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[1].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 8;
            crep.Sales_Rep_Profile__c= spProf.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[2].id;
            anslist.add(crep);
            
            crep = new Certification_Answer__c();
            crep.Rating_start_date__c = Date.today() - 4;
            crep.Due_Date__c = Date.today()-1;
            crep.Rating_Score__c = 5;
            crep.Sales_Rep_Profile__c= spProf1.id;
            crep.Certifcation_Rating__c = rating[0].id;
            crep.Certifcation__c =cerList[3].id;
            anslist.add(crep);
            
            
           
            
            insert anslist;
            
            List<Certification_Snapshot__c> certsnap= FunnelDataFactory.createCertificationSnapshot(cerList);  
            insert certsnap;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Country';
            fw.levelValue = 'US';
            fw.salesProfForCompLevel = spMgrMgr.id;
            
            List<Sales_Rep_Profile__c> sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgrMgr);
            List<Company_Level__c> cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            List<Company_Level_Junction_snapshot__c> cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
            insert cs;
            
            fw = new FunnelDataFactory.FunnelTestWrapper();
            fw.index = 1;  
            fw.levelName = 'Region';
            fw.levelValue = 'US West';
            fw.salesProfForCompLevel = spMgr.id;
            
            sp = new List<Sales_Rep_Profile__c>();
            sp.add(spMgr);
            cl = FunnelDataFactory.createCompanyLevel(fw,sp);                        
            insert cl;
            
            cs = FunnelDataFactory.createCompanyLevelJunctionSnapshots(cl);  
            insert cs;
            
            test.startTest();
            system.debug(' start SOQL LIMIT'+limits.getQueries());
            FunnelAnalyticQualitativeController ft = new FunnelAnalyticQualitativeController();
            
            
            ft.fw.labelOne = 'Country';
            ft.fw.labelTwo = 'Region';
            ft.fw.labelThree = 'Role';
            ft.fw.SelectedLevelOne = 'US';
            ft.fw.SelectedLevelTwo = 'All';
            ft.fw.SelectedLevelThree = val;
            system.debug('SOQL LIMIT'+limits.getQueries());
            ft.showUpdated();
            system.debug(' After showupdate SOQL LIMIT'+limits.getQueries());
                                

            test.stopTest();
            
            ft.mid  = rating[0].id;
            ft.metric();
            system.assertEquals(ft.mdisplay.size(),1);  
             
        }
                            
    } */
}