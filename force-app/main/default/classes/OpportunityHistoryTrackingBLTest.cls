/*
 @isTest
public class OpportunityHistoryTrackingBLTest {

    @isTest
    static void testTrackChanges() {
        
        Opportunity opp = new Opportunity(Name = 'Test Opp', CloseDate = Date.today().addDays(10), StageName = 'Prospecting');
        insert opp;
        Map<Id, Opportunity> oppOldMap = new Map<Id, Opportunity>{opp.Id => opp};
        opp.StageName = 'Qualification';
        update opp;
        List<Opportunity> oppList = new List<Opportunity>{opp};
        
        
        Test.startTest();
        OpportunityHistoryTrackingBL.trackChanges(oppList, oppOldMap);
        Test.stopTest();

        
}
*/

@isTest
private class OpportunityHistoryTrackingBLTest {

    @isTest
    static void testTrackChanges() {
      List<Opportunity> opps = new List<Opportunity>();
      for (Integer i = 0; i < 2; i++) {
            Opportunity opp = new Opportunity(Name='Test Opportunity ' + i, StageName='Prospecting', CloseDate=Date.today());
            opps.add(opp);
        }
        insert opps;
        
        
        Opportunity oppToModify = opps[0];
        oppToModify.StageName = 'Qualification';
        update oppToModify;
        
       
        Test.startTest();
        OpportunityHistoryTrackingBL.trackChanges(opps, null);
         Test.stopTest();
    }
}