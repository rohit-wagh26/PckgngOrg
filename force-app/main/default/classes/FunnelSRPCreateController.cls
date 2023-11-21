/*
Copyright: Funnel Metrics, LLC
*/
public with sharing class FunnelSRPCreateController{
    
    //List that displays on the page    
    public List<srpWrapper> usrLst { get;set; }
    public List<Sales_Rep_Profile__c> srpPlaceholder{get;set;}
    public Sales_Rep_Profile__c srpPlaceholderEdit{get;set;}
    public String editId{get;set;} 
    public String deleteId {get;set;}
    //List to store the original list    
    public List<srpWrapper> oriUsrLst = new List<srpWrapper> ();
    
    public boolean licenseAvailable ;
    
    //Wrapper definition
    public class srpWrapper{    
        public String name{get;set;}
        public Boolean selectBox{get; set;} 
        public Id userId {get; set;} 
        public string profilename {get; set;}
        public string userRole {get; set;}      
        public string userName {get; set;}      
    }

    //Map to store user id versus sales profile record
    Map<id,Sales_rep_profile__c> srMap = new Map<id,Sales_rep_profile__c>();

    public string strKey {get;set;}
    
    public string placeholderName {get;set;}
    
    /*Lists to store more than 1000 records
    User list1 stores the modified list oriUsrLst1 stores the unmodified list (1000 to 2000)
    User list2 stores the modified list oriUsrLst2 stores the unmodified list (1000 to 2000)    
    */
    public List<srpWrapper> usrLst1 { get;set; }
    
    public List<srpWrapper> oriUsrLst1 = new List<srpWrapper> ();
    
    public List<srpWrapper> usrLst2 { get;set; }
    
    public List<srpWrapper> oriUsrLst2 = new List<srpWrapper> ();
    
    public List<srpWrapper> usrLst3 { get;set; }
    
    public List<srpWrapper> oriUsrLst3 = new List<srpWrapper> ();
    
    public List<srpWrapper> usrLst4 { get;set; }
    
    public List<srpWrapper> oriUsrLst4 = new List<srpWrapper> ();
    
     
    public FunnelSRPCreateController(){                
               
        usrLst = new List<srpWrapper>();
        usrLst1 = new List<srpWrapper>();
        usrLst2 = new List<srpWrapper>();
        usrLst3 = new List<srpWrapper>();
        usrLst4 = new List<srpWrapper>();
         
        usrLst = wraplist('constructor');
        
        system.debug (' user wrapper usrLst '+usrLst );
        srpPlaceholder = new List<Sales_Rep_Profile__c>();
        srpPlaceholder =[Select id,name from Sales_Rep_Profile__c where Placeholder__c = true];
        
        licenseAvailable = true;        
    }
    
    public List<srpWrapper> wraplist(String rePop){
        
        
        List<srpWrapper> retwraplist = new List<srpWrapper>();
        
        String str = 'a%';  
        
        //Fetch all active users
        Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce')]);
         
        List<User> allList = [SELECT id, name, username, profile.name, userrole.name FROM User WHERE  profileId in:profileIds.Keyset() AND isActive = TRUE    ORDER BY name ASC Limit 4000];
        //List<User> allList = [SELECT id, name, username, profile.name, userrole.name FROM User WHERE isActive = TRUE AND Profile.Name IN ('System Administrator','7ticks SAM User','ICE SFTI','eSignal Sales','RTS Europe Sales') ORDER BY name ASC];
        
        //Fetch all existing sales profiles
        List<Sales_rep_profile__c> srpList = [SELECT user_record_name__c, id, Role__c FROM Sales_Rep_Profile__c where Active__c = TRUE];
        
        //List to store user ids that have sales profiles already created
        Set<id> srpUsers = new Set<id>();
        
        
        
        for(Sales_rep_profile__c s: srpList){
        
            srpUsers.add(s.User_record_name__c);
            srMap.put(s.user_record_name__c,s);
        
        }
        
         
        //Variables to store the max limit of a  list and count
        Integer limitMax = 1000;
        Integer limitMax1 = 2000;
        Integer limitMax2 = 3000;
        Integer limitMax3 = 4000;
        Integer count = 0;
        
        //Iterating through the users and creating two wrapper lists for original and list to update
        for(User u: allList ){
            
            count++;
            
            srpWrapper sr = new srpWrapper();
            
            //Select box should appear checked if SRP has already been created for the user
            if(srpUsers.contains(u.id)){
                sr.selectBox = true;  
                sr.userRole = u.userrole.name;           
            }
            else{
                sr.selectBox = false;
            }            
            
            sr.name = u.name;
            sr.userId = u.id;
            sr.profileName = u.profile.name;
            sr.userName = u.username;
            
            if (count >= limitMax && count < limitMax1){
                if (rePop == 'constructor')
                    usrLst1.add(sr);
                else if (rePop == 'save')
                    oriUsrLst1.add(sr);
            }
            else if (count >= limitMax1 && count < limitMax2){
                if (rePop == 'constructor')
                    usrLst2.add(sr);
                else if (rePop == 'save')
                    oriUsrLst2.add(sr);
            }
            else if (count >= limitMax2 && count < limitMax3){
                if (rePop == 'constructor')
                    usrLst3.add(sr);
                else if (rePop == 'save')
                    oriUsrLst3.add(sr);
            }
            else if (count >= limitMax3){
                if (rePop == 'constructor')
                    usrLst4.add(sr);
                else if (rePop == 'save')
                    oriUsrLst4.add(sr);
            }
            
            else
                retwraplist.add(sr);         
        
        }
        return retwraplist ;
    }
    
    public void save(){
         licenseAvailable = true; 
         oriUsrLst= new List<srpWrapper>();
         oriUsrLst = wraplist ('save');
         
        //List to store the sales rep profiles to be inserted
        List<Sales_rep_profile__c> sreps = new List<Sales_rep_profile__c>();
        
        //List to store the sales rep profiles to be deleted
        List<Sales_rep_profile__c> srepsD = new List<Sales_rep_profile__c>();
        
        try{
            FunnelInstallationHelper.saveStep('5');
            //Creating a list of the sales rep profiles to be created
            for(integer i=0; i < usrLst.size(); i++){                        
                if(usrLst[i].selectBox == true && oriUsrLst[i].selectBox == false){
                    Sales_rep_profile__c s = new Sales_rep_profile__c();
                    s.User_record_name__c = usrLst[i].userId;
                    s.name = usrLst[i].name;
                    sreps.add(s);
                }
                
                if(usrLst[i].selectBox == false && oriUsrLst[i].selectBox == true && srMap.get(usrLst[i].userId) != null){
                    
                    srepsD.add(srMap.get(usrLst[i].userId));
                }
            }
            for(integer i=0; i < usrLst1.size(); i++){  
                                  
                if(usrLst1[i].selectBox == true && oriUsrLst1[i].selectBox == false){
                    Sales_rep_profile__c s = new Sales_rep_profile__c();
                    s.User_record_name__c = usrLst1[i].userId;
                    s.name = usrLst1[i].name;
                    sreps.add(s);
                }
                if(usrLst1[i].selectBox == false && oriUsrLst1[i].selectBox == true && srMap.get(usrLst1[i].userId) != null){                    
                    srepsD.add(srMap.get(usrLst1[i].userId));
                }
                
            }
            
            for(integer i=0; i < usrLst2.size(); i++){  
                                  
                if(usrLst2[i].selectBox == true && oriUsrLst2[i].selectBox == false){
                    Sales_rep_profile__c s = new Sales_rep_profile__c();
                    s.User_record_name__c = usrLst2[i].userId;
                    s.name = usrLst2[i].name;
                    sreps.add(s);
                }
                if(usrLst2[i].selectBox == false && oriUsrLst2[i].selectBox == true && srMap.get(usrLst2[i].userId) != null){                    
                    srepsD.add(srMap.get(usrLst2[i].userId));
                }
                
            }
            
            for(integer i=0; i < usrLst3.size(); i++){  
                                  
                if(usrLst3[i].selectBox == true && oriUsrLst3[i].selectBox == false){
                    Sales_rep_profile__c s = new Sales_rep_profile__c();
                    s.User_record_name__c = usrLst3[i].userId;
                    s.name = usrLst3[i].name;
                    sreps.add(s);
                }
                if(usrLst3[i].selectBox == false && oriUsrLst3[i].selectBox == true && srMap.get(usrLst3[i].userId) != null){                    
                    srepsD.add(srMap.get(usrLst3[i].userId));
                }
                
            }
            
            for(integer i=0; i < usrLst4.size(); i++){  
                                  
                if(usrLst4[i].selectBox == true && oriUsrLst4[i].selectBox == false){
                    Sales_rep_profile__c s = new Sales_rep_profile__c();
                    s.User_record_name__c = usrLst4[i].userId;
                    s.name = usrLst4[i].name;
                    sreps.add(s);
                }
                if(usrLst4[i].selectBox == false && oriUsrLst4[i].selectBox == true && srMap.get(usrLst4[i].userId) != null){                    
                    srepsD.add(srMap.get(usrLst4[i].userId));
                }
                
            }
            
            system.debug(' sreps '+sreps);
            
            system.debug(' srepsD '+srepsD);
                 
            List<Organization> org = [SELECT IsSandbox FROM Organization LIMIT 1];
            
            //Checking if the number of new sales profiles to be created are more than the available licenses and adding an error message
            if (sreps != null && sreps.size() > 0){
            
                
                if(!org[0].isSandbox){
                
                    Integer availLicen = 0;
                    
                    //Querying the available licenses
                    List<PackageLicense> usersAv = [SELECT AllowedLicenses, UsedLicenses, ExpirationDate, CreatedDate, IsProvisioned, Status FROM PackageLicense WHERE NamespacePrefix = 'FunnelMetrics' LIMIT 1];
                                       
                    if (usersAv != null && usersAv.size() > 0 && usersAv[0].AllowedLicenses >= usersAv[0].UsedLicenses){            
                        availLicen = usersAv[0].AllowedLicenses - usersAv[0].UsedLicenses;
                    }
                    System.debug('availLicen'+availLicen);
                    //Add error messages if licenses are not available
                    if (sreps.size() > availLicen){
                        licenseAvailable = false;
                        String m = 'You have '+availLicen+' licenses available but have selected '+sreps.size()+'.';                      
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,m);
                        ApexPages.addMessage(myMsg);
                    }
                    //Create the sales profiles if licenses are available
                    else if(sreps.size() <= availLicen){
                        
                        insert sreps;
                        
                        
                        //Assign licenses to the users for which sales profiles have been created
                        List<String> existingUsers = new  List<String>(); 
                        List<UserPackageLicense> existingLicenseAssigned =[SELECT Id ,UserId  FROM UserPackageLicense  WHERE PackageLicense.NamespacePrefix = 'FunnelMetrics'];
                        for(UserPackageLicense up : existingLicenseAssigned ){
                            existingUsers.add(up.UserId);
                        }
                        
                        //PackageLicense pl = [SELECT Id FROM PackageLicense WHERE NamespacePrefix = 'FunnelMetrics'];
    
                        //List<UserPackageLicense> ulist = new List<UserPackageLicense>();
                       
                        /*for(Sales_rep_profile__c s:sreps){
                            if(!existingUsers.contains(s.User_record_name__c)){ 
                                UserPackageLicense up = new UserPackageLicense(UserId = s.User_record_name__c, PackageLicenseId = pl.id);
                                ulist.add(up);
                             }   
                        }*/
                        
                        List<id> userids = new List<id>();
                        
                        for(Sales_rep_profile__c s:sreps){
                            if(!existingUsers.contains(s.User_record_name__c)){ 
                                userids.add(s.User_record_name__c);
                             }   
                        }
                                            
                        FunnelInstallationHelper.addDelUserLicenses('insert',userids);                        
                    }
                }
                else{
                    
                    insert sreps;
                
                }
            
            }
            
            //Deleting sales profiles
            if (srepsD != null && srepsD.size() > 0){
            
                if(!org[0].isSandbox){
                                       
                    List<id> userIds = new List<id>();
                    
                    for(Sales_rep_profile__c s:srepsD){
                        if(s.User_record_name__c != null)
                            userIds.add(s.User_record_name__c);                   
                    }
                    
                    /*List<UserPackageLicense> ulist = new List<UserPackageLicense>();
                    PackageLicense pl = [SELECT Id FROM PackageLicense WHERE NamespacePrefix = 'FunnelMetrics'];
                    if(userIds.size() > 0)
                        ulist = [SELECT id FROM UserPackageLicense WHERE UserId IN :userIds AND PackageLicenseId = :pl.id];
                        
                    if(ulist != null && ulist.size() > 0)
                        DELETE ulist;*/
                    
                    FunnelInstallationHelper.addDelUserLicenses('delete',userIds);                        
                        
                }
                    
                DELETE srepsD;
                        
            } 
        }
        catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(myMsg);
        }       
        
    }
    
    public void savePlaceholder(){
        /*Sales_rep_profile__c s = new Sales_rep_profile__c();
        System.debug('placeholderName'+placeholderName);
        s.name = placeholderName;
        s.Placeholder__c = true;
        insert s;
        */
        srpPlaceholderEdit.Placeholder__c = true; 
        if(srpPlaceholderEdit.name != null)
        upsert srpPlaceholderEdit ;
        srpPlaceholder =[Select id,name from Sales_Rep_Profile__c where Placeholder__c = true];
    }
    
    public PageReference navigateToStep4b(){
     
        save();
        
        if(licenseAvailable){
            return FunnelInstallationHelper.navigateToStep4b();
        }else{
            return  null;
        }
    
    }
    
    
    public PageReference navigateToStep5b(){
        save();
        if(licenseAvailable){
            return  FunnelInstallationHelper.navigateToStep5b();
        }else{
            return  null;
        }
    }
    
    public void search(){
        usrLst = new List<srpWrapper>();
        usrLst1 = new List<srpWrapper>();
        usrLst2 = new List<srpWrapper>();
        usrLst = wraplist('constructor');
    }
    
     public void hideAddEditPlaceholder(){
          editId = null;
          srpPlaceholderEdit = new Sales_Rep_Profile__c();
     
     }
     public void displayAddEditPlaceholder(){
         System.debug('editId'+editId);
         if(editId != null){ 
                srpPlaceholderEdit = [Select id,name from Sales_Rep_Profile__c where id = :editId];
        } else{
                srpPlaceholderEdit = new Sales_Rep_Profile__c();
         }
          
          
     
     }
     
     public void deletePlaceholder(){
         System.debug('editId'+editId);
         if(deleteId != null){ 
             List<Sales_Rep_Profile__c > delsrp = [Select id,name from Sales_Rep_Profile__c where id = :deleteId ];
             if(delsrp != null && delsrp.size()>0){
                 delete delsrp ;
             }
          srpPlaceholder =[Select id,name from Sales_Rep_Profile__c where Placeholder__c = true];       
         } 
          
          
     
     }
     
     public PageReference saveAndExit(){
        save();
        if(licenseAvailable){
           return FunnelInstallationHelper.navigateToChecklist();
        }else{
            return  null;
        }
         
    }
}