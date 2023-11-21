@isTest

public class FunnelSalesProfileTest{
    
    /*
    static testMethod void testCurrentActiveOpptys() {
        
        Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
        insert fiscalYr;
        
        Sales_Rep_Profile__c testMgr = FunnelDataFactory.createSalesRep(0);
        insert testMgr;                
        
        Sales_Rep_Profile__c testSalesRep = FunnelDataFactory.createSalesRep(1);
        testSalesRep.Sales_Manager__c = testMgr.id;
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        insert testSalesRep;
        
        Test.startTest();
        
        system.debug('before opportunity is updated ');
        
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        Opportunity opp = FunnelDataFactory.createOpportunity(0, testSalesRep, 'Qualified', System.today()+5);  
        insert opp;
        
        Test.stopTest();        
        system.debug('after opportunity is updated ');
        
        Integer count = (Integer)[SELECT Current_Active_Opportunities__c FROM Sales_Rep_Profile__c WHERE id = : testSalesRep.id].Current_Active_Opportunities__c;
        system.debug('count '+count);
                
        system.assertEquals(1,count);     
        
        count = (Integer)[SELECT Aggregated_current_active_opptys__c FROM Sales_Rep_Profile__c WHERE id = : testMgr.id].Aggregated_current_active_opptys__c;           
        system.assertEquals(1,count);
        
    }
    
    static testMethod void testSalesProfsNotAssociatedWithOpptys() {
        
        Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
        insert fiscalYr;
        
        Sales_Rep_Profile__c testMgr = FunnelDataFactory.createSalesRep(0);
        insert testMgr;                
        
        Sales_Rep_Profile__c testSalesRep = FunnelDataFactory.createSalesRep(1);
        testSalesRep.Sales_Manager__c = testMgr.id;
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        insert testSalesRep;
        
        Test.startTest();
        
        system.debug('before opportunity is updated ');
        
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        Opportunity opp = FunnelDataFactory.createOpportunity(0, testSalesRep, 'Qualified', System.today()+5);  
        insert opp;
        
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        opp.Sales_Rep_Profile__c = null;
        update opp;
        
        Test.stopTest();        
        system.debug('after opportunity is updated ');
        
        Integer count = (Integer)[SELECT Current_Active_Opportunities__c FROM Sales_Rep_Profile__c WHERE id = : testSalesRep.id].Current_Active_Opportunities__c;
        system.debug('count '+count);
                
        system.assertEquals(0,count);     
        
        count = (Integer)[SELECT Aggregated_current_active_opptys__c FROM Sales_Rep_Profile__c WHERE id = : testMgr.id].Aggregated_current_active_opptys__c;           
        system.assertEquals(0,count);
        
    }  
    
    static testMethod void testClosedOpptysFieldUpdates() {
        
        Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
        insert fiscalYr;
        
        Sales_Rep_Profile__c testMgr = FunnelDataFactory.createSalesRep(0);
        insert testMgr;                
        
        Sales_Rep_Profile__c testSalesRep = FunnelDataFactory.createSalesRep(1);
        testSalesRep.Sales_Manager__c = testMgr.id;
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        insert testSalesRep;
        
        Test.startTest();
        
        system.debug('before opportunity is updated ');
        
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        Opportunity opp = FunnelDataFactory.createOpportunity(0, testSalesRep, 'Qualified', System.today()+5);  
        insert opp;
        
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        opp = FunnelDataFactory.createOpportunity(1, testSalesRep, 'Closed Won', System.today()+5);  
        opp.Amount = 10000;
        insert opp;
        
        Test.stopTest();        
        system.debug('after opportunity is updated ');
        
        Integer count = (Integer)[SELECT YTD_Opportunities_won__c FROM Sales_Rep_Profile__c WHERE id = : testSalesRep.id].YTD_Opportunities_won__c;
                
        system.assertEquals(1,count);                     
        
    }    
    
    static testMethod void testRemovalOfSalesMgr() {
        
        Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
        insert fiscalYr;
        
        Sales_Rep_Profile__c testMgr = FunnelDataFactory.createSalesRep(0);
        insert testMgr;                                
        
        Sales_Rep_Profile__c testSalesRep = FunnelDataFactory.createSalesRep(1);
        testSalesRep.Sales_Manager__c = testMgr.id;
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        insert testSalesRep;                      
        
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        Opportunity opp = FunnelDataFactory.createOpportunity(0, testSalesRep, 'Qualified', System.today()+5);  
        insert opp;        
                        
        Sales_Rep_Profile__c testMgr2 = FunnelDataFactory.createSalesRep(3);
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        insert testMgr2; 
        
        Sales_Rep_Profile__c testSalesRep2 = FunnelDataFactory.createSalesRep(2);
        testSalesRep2.Sales_Manager__c = testMgr2.id;
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        insert testSalesRep2;  
        
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        opp = FunnelDataFactory.createOpportunity(0, testSalesRep2, 'Qualified', System.today()+5);  
        insert opp;

               
        Integer count = (Integer)[SELECT Aggregated_current_active_opptys__c FROM Sales_Rep_Profile__c WHERE id = : testMgr.id].Aggregated_current_active_opptys__c;
                
        system.assertEquals(1,count);  
        
        Test.startTest();
        
        system.debug(' before update of sales profile ');
        
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        testSalesRep.Sales_Manager__c = null;
        update testSalesRep;        
        
        count = (Integer)[SELECT Aggregated_current_active_opptys__c FROM Sales_Rep_Profile__c WHERE id = : testMgr.id].Aggregated_current_active_opptys__c;                
        system.assertEquals(0,count);  
                
        count = (Integer)[SELECT Aggregated_current_active_opptys__c FROM Sales_Rep_Profile__c WHERE id = : testMgr2.id].Aggregated_current_active_opptys__c;                
        system.assertEquals(1,count);  
        
        system.debug(' after update of sales profile ');
        
        Test.stopTest();        
        system.debug('after opportunity is updated ');                                   
        
    } 
    
    static testMethod void testErrorForFiscalYearNotSet() {
        
        Sales_Rep_Profile__c testSalesRep = FunnelDataFactory.createSalesRep(1);
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        insert testSalesRep; 
        
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        Opportunity opp = FunnelDataFactory.createOpportunity(0, testSalesRep, 'Qualified', System.today()+5);  
        
        try{        
            insert opp;
        }
        catch(Exception ex){
            system.assert(ex.getMessage().contains('The fiscal year start date is not set'));
        }            
    }
    
    static testMethod void testOnlyCloseOpptysForProfile() {
        
        Fiscal_Year_Setting__c fiscalYr = FunnelDataFactory.setFiscalYear(System.Today()-1);
        insert fiscalYr;
        
        Sales_Rep_Profile__c testSalesRep = FunnelDataFactory.createSalesRep(1);
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        insert testSalesRep; 
        
        FunnelTriggerBatchHelper.isSpTriggerCalled = false;
        Opportunity opp = FunnelDataFactory.createOpportunity(0, testSalesRep, 'Qualified', System.today()+5);  
        insert opp;
        
        Integer count = (Integer)[SELECT Current_Active_Opportunities__c FROM Sales_Rep_Profile__c WHERE id = : testSalesRep.id].Current_Active_Opportunities__c;
        system.assertEquals(count,1);
        
        FunnelTriggerBatchHelper.isSpTriggerCalled = true;
        opp.StageName = 'Closed Won';
        update opp;      
        
        count = (Integer)[SELECT Current_Active_Opportunities__c FROM Sales_Rep_Profile__c WHERE id = : testSalesRep.id].Current_Active_Opportunities__c;
        system.assertEquals(count,0);   
    }*/
}