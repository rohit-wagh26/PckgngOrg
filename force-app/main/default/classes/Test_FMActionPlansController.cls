@isTest 
Private class Test_FMActionPlansController {
    
    @testSetup static void testData() {
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        
        User u = FunnelTestDatafactory.createUser(profileId);
        insert u;
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'FunnelReadAccessAllObjs'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id ); 
        
        system.runAs(u){
            Fiscal_Year_Setting__c fs = FunnelDataFactory.setFiscalYear(System.today());
            insert fs;
            Sales_Rep_Profile__c sp = new Sales_Rep_Profile__c();
            sp.Name = 'Test';
            sp.Active__c = true;
            sp.FunnelMetrics__User_Record_Name__c=u.Id;
            insert sp;
            
            Action_Plan__c a = new Action_Plan__c();
            a.Sales_Rep_Profile__c =sp.id;
            a.Action_Step__c ='Test';
            a.Due_Date__c=System.today();
            insert a;
        }
        
    }
    
    @isTest
    static void getActionPlansTest(){
        List<Sales_Rep_Profile__c> spList = [Select Id,Name from Sales_Rep_Profile__c Limit 1];
        
        FMActionPlansController.getActionPlans(spList);
        
        
    }
    
    
    
    
}