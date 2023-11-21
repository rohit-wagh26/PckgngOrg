@isTest

public class FunnelInstallationTest{
    
    static testmethod void testUpdation(){
    
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
         
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        
        List<User> us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u = us[0];
         
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_App_Setup'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id );
        
        List<User> userListcomp = FunnelDataFactory.createUser(fw,10);
        insert userListcomp;

        system.runAs(u){
            
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;

            Test.startTest();                                                                               
            
            PageReference myVfPage = Page.FunnelInstallationChecklist;
            Test.setCurrentPage(myVfPage);
            
            FunnelInstallation ft = new FunnelInstallation();
            
            system.assertEquals(ft.admin,true); 
            Test.stopTest();   
            
            ft.updateLabel = 'Complete installation wizard';
            ft.updateVal = false;
            ft.updateMetadata(); 
            
            ft.updateVal = true;
            ft.updateMetadata(); 
            
            ft.hideChecklist();                                                                           
                  
       }              
      
    }
    
    static testmethod void testExtension(){
    
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
         
        FunnelDataFactory.FunnelTestWrapper fw = new FunnelDataFactory.FunnelTestWrapper();
        fw.index = 1;
        fw.profileId = profileId;        
        fw.userRoleId = r.id;
        
        List<User> us = FunnelDataFactory.createUser(fw,1);
        insert us;
        User u = us[0];
         
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'Funnel_App_Setup'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id );
        
        List<User> userListcomp = FunnelDataFactory.createUser(fw,10);
        insert userListcomp;

        system.runAs(u){
            
            Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
            insert fiscalYr;
            Notification_Setting__c  noti = new Notification_Setting__c (Enable_Notifications__c = true,Advance_Reminders__c = '7 days prior',Notification_Frequency__c = 'Daily', Escalation__c ='Never');
            insert noti ;

                                                                                           
            
            FunnelUpdateRatings_Controller fr = new FunnelUpdateRatings_Controller();           
            FunnelInstallation ft = new FunnelInstallation(fr);
                                 
            FunnelRepStatusUpdateController fr1 = new FunnelRepStatusUpdateController();            
            FunnelInstallation ft1 = new FunnelInstallation(fr1);
                       
            FunnelScorecard fr2 = new FunnelScorecard();           
            FunnelInstallation ft2 = new FunnelInstallation(fr2);
                      
            FunnelCertificationDetail fr3 = new FunnelCertificationDetail();           
            FunnelInstallation ft3 = new FunnelInstallation(fr3);
                      
            FunnelCertificationUpdate fr4 = new FunnelCertificationUpdate();          
            FunnelInstallation ft4 = new FunnelInstallation(fr4);
            
            FunnelRoleGroupingController fr5 = new FunnelRoleGroupingController();          
            FunnelInstallation ft5 = new FunnelInstallation(fr5);
            fr5.SelectedValue = '';
            List<SelectOption> Options = new List<SelectOption>(); 
            Options = fr5.getRole();
            fr5.displayAddEditRoleGroup();
            fr5.hideAddEditGroup();
            fr5.deleteGroup();
            fr5.updateGroupUpdate();
            fr5.save();
            PageReference p = fr5.navigateToCertification();
            p = fr5.navigateToDashboard();
            p = fr5.navigateToCalculator();
            p = fr5.navigateToHomePage();
            p = fr5.navigateToReportsPage();
            p = fr5.navigateToCertificateReports();
            p = fr5.navigateToAppSetup();
            p = fr5.navigateToRatings();
            p = fr5.navigateToAssignRole();
            p = fr5.navigateToCustomMetric();
            p = fr5.navigateToCategories();
            p = fr5.navigateToAnalytics();
           	p = fr5.navigateToFunnelAnalyticQualitative();
            p = fr5.navigateToFunnelAnalytic();
            p = fr5.navigateToNotifications();
            p = fr5.navigateToAnnualizationDashboard();
            p = fr5.navigateToFunnelSetup();
            p = fr5.navigateToFunnelReviewGoals();
            p = fr5.navigateToFunnelEvaluationGuidelines();
            p = fr5.navigateToGoals();
            p = fr5.navigateToFunnelManagerUpdate();
            boolean bl = fr5.checkcontain('abc','xyz');
            
            fr5.dfRoles();
            
            FunnelNotificationController fr6 = new FunnelNotificationController();          
            FunnelInstallation ft6 = new FunnelInstallation(fr6);
            
            FunnelSetupController fr7 = new FunnelSetupController();          
            FunnelInstallation ft7 = new FunnelInstallation(fr7);
            
            //FunnelManagerUpdate_Controller fr8 = new FunnelManagerUpdate_Controller();          
            //FunnelInstallation ft8 = new FunnelInstallation(fr8);
            
            //FunnelReviewGoals_Controller fr9 = new FunnelReviewGoals_Controller();          
            //FunnelInstallation ft9 = new FunnelInstallation(fr9);
            
            FunnelEvaluationGuidelinesController fr10 = new FunnelEvaluationGuidelinesController();          
            FunnelInstallation ft10 = new FunnelInstallation(fr10);
            
            Test.startTest();
            
            FunnelAssignRoleController fra = new FunnelAssignRoleController();          
            FunnelInstallation fta = new FunnelInstallation(fra);
            
            FunnelCertificationRatingCustom frb = new FunnelCertificationRatingCustom();          
            FunnelInstallation ftb = new FunnelInstallation(frb);
            
            FunnelAnalyticQualitativeController frc = new FunnelAnalyticQualitativeController();          
            FunnelInstallation ftc = new FunnelInstallation(frc);
            
            FunnelAnalyticController frd = new FunnelAnalyticController();          
            FunnelInstallation ftd = new FunnelInstallation(frd);
            
            FunnelAnnualizationDashboardController fre = new FunnelAnnualizationDashboardController();          
            FunnelInstallation fte = new FunnelInstallation(fre);
            
            FunnelReporting_Controller frf = new FunnelReporting_Controller();          
            FunnelInstallation ftf = new FunnelInstallation(frf);
            
            FunnelCertificationReportsController frg = new FunnelCertificationReportsController();          
            FunnelInstallation ftg = new FunnelInstallation(frg);
            
            FunnelCertificationTable frh = new FunnelCertificationTable();          
            FunnelInstallation fth = new FunnelInstallation(frh);
            
            FunnelSalesDashboard_Controller fri = new FunnelSalesDashboard_Controller();          
            FunnelInstallation fti = new FunnelInstallation(fri);
            
            FunnelAnalyticScreenController fsc = new FunnelAnalyticScreenController();          
            FunnelInstallation ftas = new FunnelInstallation(fsc);
            
            FunnelCertificationRating_Controller frj = new FunnelCertificationRating_Controller();          
            FunnelInstallation ftj = new FunnelInstallation(frj);
            
            FunnelTrendingByRepController frep = new FunnelTrendingByRepController();          
            FunnelInstallation ftr = new FunnelInstallation(frep);
            
            //FunnelTrendingBySkillController fs = new FunnelTrendingBySkillController();          
            //FunnelInstallation fts = new FunnelInstallation(fs);
            
            ftj.navigateToAppSetupTab();
            ftj.navigateToFunnelAnalyticQualitativeTab();
            ftj.navigateToFunnelAnalyticTab();
            ftj.navigateToAnnualizationDashboardTab();
            ftj.navigateToReportsPageTab();
            ftj.navigateToCertificateReportsTab();
            ftj.navigateToDashboardTab();
            ftj.navigateToCertificationTab();
            ftj.navigateToHomePageTab();
            ftj.navigateToChecklistPage();
            ftj.navigateToIntro();
            ftj.checkAndNavigate();
            ftj.navigateToTrendingByRep();
            ftj.navigateToTrendingBySkill();
            ftj.navigateToAppSetup();
            ftj.navigateToGoals();
            ftj.navigateToHelpMenu();
            
            system.assertEquals(ft.admin,true); 
            Test.stopTest();   
            
            ftj.popClose = 'test';   
            
            FunnelCalculator fc = new FunnelCalculator();          
             ftj = new FunnelInstallation(fc);
            
            FunnelAddEditRole f1 = new FunnelAddEditRole();          
             ftj = new FunnelInstallation(f1);
            
            FunnelAddEditCompanyLevel f2 = new FunnelAddEditCompanyLevel();          
             ftj = new FunnelInstallation(f2);
            
            Application_Setting__c ase = new Application_Setting__c();
            insert ase;
            //FunnelManagerUpdate_Controller f3 = new FunnelManagerUpdate_Controller();          
             //ftj = new FunnelInstallation(f3);
            
            /*FunnelReviewGoals_Controller f4 = new FunnelReviewGoals_Controller();          
             ftj = new FunnelInstallation(f4);*/
                           
            ftj.getUpdateMetadata();
            ftj.navigateToFunnelReviewGoals();
            ftj.navigateToFunnelSetup();
            ftj.navigateToFunnelAddEditSRP();
            //ftj.navigateToAppSetup();
            ftj.checkListComp = true;
                                          
          //  ftj.navigateToGoals();
            ftj.popup();                              
       }              
      
    }
    
}