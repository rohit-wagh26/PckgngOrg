@isTest
public class Batch_CreateOpprtunityTracking_Test {
    
    @isTest
    public static void testData(){
        Opportunity opp = new Opportunity();
        opp.Name='test';
        opp.StageName='Prospecting';
        opp.CloseDate=Date.valueOf('2023-04-01');
        insert opp;
        
        Test.startTest();
        Batch_CreateOpprtunityTracking obj1=new Batch_CreateOpprtunityTracking();
        Database.executeBatch(obj1);
        Test.stopTest();
    }

}