public class FunnelSalesProfileCreation {
  /*
  @InvocableMethod(label='Create sales profiles' description='Creates sales profiles for all users in the org')
  public static void createProfiles() {
    
    //List of all active users
    List<User> userRecs = [SELECT id, name, managerid FROM User WHERE IsActive = true];
    
    //Map to store the user and the manager on the user record
    Map<Id,Id> userMgrMap = new Map<Id,Id>();
    
    for(User u: userRecs){        
        userMgrMap.put(u.id,u.managerid);
    }
    
    //List to store the sales rep profiles created from the user records
    List<Sales_Rep_Profile__c> srp = new List<Sales_Rep_Profile__c>();
    
    for(User u: userRecs){        
        Sales_Rep_Profile__c s = new Sales_Rep_Profile__c();
        s.User_Record_Name__c = u.id;
        s.Name = u.Name;
        srp.add(s);
    }
    
    insert srp;
    
    //Map to store the user id and the corresponding sales rep
    Map<id,id> usrSrepMap = new Map<id,id>();
    
    for(Sales_Rep_Profile__c s: srp){
        usrSrepMap.put(s.User_Record_Name__c,s.id);
    }
    
    //Iterating through the sales profiles and fetching/updating the manager
    for(Sales_Rep_Profile__c s: srp){
        if(userMgrMap.get(s.User_Record_Name__c) != null){
            s.Sales_Manager__c = usrSrepMap.get(userMgrMap.get(s.User_Record_Name__c));
        }
    }
    
    update srp;
    
  }*/
  
}