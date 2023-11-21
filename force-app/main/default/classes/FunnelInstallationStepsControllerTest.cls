@isTest
public class FunnelInstallationStepsControllerTest {
    Static testmethod void stepstest(){
        FM_Installation__mdt inst = new FM_Installation__mdt();
        inst.label = 'Metadata';
        inst.Saved_Page__c = '6';
        ApexPages.currentPage().getUrl();
        PageReference p = new PageReference('/one/one.app#/alohaRedirect/apex/FunnelMetrics__FunnelInstallationStep9');
        Test.setCurrentPage(p);
        FunnelInstallationStepsController fi = new FunnelInstallationStepsController();
        Decimal agg = fi.Controllerstage;
        PageReference stepone = fi.navigateToStepOne();
        system.assertEquals(agg, 9);
    }

}