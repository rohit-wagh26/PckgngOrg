@isTest
public class FunnelHistControllerTest {
        
     
    static testmethod void testFunnelHistController() {    
        
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
            
            test.startTest();
            
            FunnelHistController c= new FunnelHistController();
            c.checkSchjob();
            system.assertEquals(c.schMonBatch,true); 
            c.deleteHistoricalData();
            c.clearMessage();
            c.timerOn();
            c.timerOff();
            //PageReference p2 = c.createHistData();
            //c.scheduleMonthlyBatch();
            c.scheduleDailyBatch();
            c.updateQualAnswers();
            //c.createCustomer();
            //c.pushDefinitions();
            PageReference p = FunnelHistController.navigateToUserReport();
            PageReference p1 = FunnelHistController.navigateToGoalInput();
            PageReference p2 = c.createHistData();
            //c.scheduleMonthlyBatch();
            //c.executeMonthlyBatch();
            //c.syncData();
            
            
            FunnelInstallationHelper.saveStep('8');
            FunnelInstallationHelper.navigateToIntro();
            FunnelInstallationHelper.navigateToIntroFromWiz();
            FunnelInstallationHelper.navigateToStep3a();
            FunnelInstallationHelper.navigateToStep3b();
            FunnelInstallationHelper.navigateToStep1();
            FunnelInstallationHelper.navigateToStep2();
            FunnelInstallationHelper.navigateToStep4a();
            FunnelInstallationHelper.navigateToStep4b();
            FunnelInstallationHelper.navigateToStep5a();
            FunnelInstallationHelper.navigateToStep5b();
            FunnelInstallationHelper.navigateToStep6();
            FunnelInstallationHelper.navigateToStep7();
            FunnelInstallationHelper.navigateToStep8();
            FunnelInstallationHelper.navigateToStep9();
            FunnelInstallationHelper.navigateToChecklist();
            FunnelInstallationHelper.naveToSavedPage();
            FunnelInstallationHelper.createPermsissions();
            
            c.scheduleDataPull();
            //c.syncData();
            c.sendRolesToS3();
            c.deleteS3Folder();
            c.deactiveTrigger();
            c.createMT();
            c.changeCSDt();
            Date d = c.csDt;
            date d1 = c.mbDt;
            date d2 = c.leadDt;
            c.executeLeadsBatch();
            c.executeCustomMetricBatch();
            c.executeEmailBatch();
            c.scheduleUpdatePickBatch();
            date d3 = c.histDateValue;
            date d4 = c.quantDateValue;
            date d5 = c.qualDateValue;
            date d6 = c.emailDateValue;
            date d7 = c.custMetDateValue;
            //c.pullScores();
            //c.pullQualRatings();
            //c.pullQuantRatings();
            c.scheduleDataPush();
            //c.pushQualData();
            //c.pushQuantData();
            test.stopTest();
        }           
    }
}