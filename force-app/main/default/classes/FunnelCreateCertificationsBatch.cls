global class FunnelCreateCertificationsBatch implements Database.Batchable<sobject>, Database.Stateful{
    
    public Boolean createAccess = true;
    
    public FunnelCreateCertificationsBatch(){

    }
    
    public static String prefix{ get{return '';} set; }

    public Database.QueryLocator start(Database.BatchableContext con){                
        
        return Database.getQueryLocator('SELECT Id, name FROM Sales_Rep_Profile__c WHERE User_Record_Name__c != null');
    }
    
    public void execute(Database.BatchableContext con, List<Sales_Rep_Profile__c> srp){
        
        List<Certification__c> certs = new List<Certification__c>();   
        
        if(createAccess){
                             
            for(Sales_Rep_Profile__c sp : srp){            
                Certification__c c = new Certification__c();
                c.name = sp.name+'Cert';
                c.Sales_Rep_Profile__c = sp.id;                                                                                    
                certs.add(c);                                            
            }
        
        }
        
        if(Schema.getGlobalDescribe().get(prefix+'Certification__c').getDescribe().isCreateable())
            insert certs;
        
    }
    
    public void finish(Database.BatchableContext con){
                                                  
    }
}