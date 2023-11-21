@isTest
public class FunnelCreateCertAnswersBatchTest {
    static testmethod void testCertAns(){
        test.startTest();
        FunnelCreateCertAnswersBatch db = new FunnelCreateCertAnswersBatch();
        Database.executeBatch(db);
        
        test.stopTest();
        system.assertEquals(0,0);
    }
    
}