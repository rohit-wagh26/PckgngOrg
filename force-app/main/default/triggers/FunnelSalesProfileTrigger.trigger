/*
    Author:  Carine DMello
    Created On: 11/19/2017
    This trigger updates fields on the Sales rep profile object
    It is triggered every time a Sales profile is inserted/updated
*/

trigger FunnelSalesProfileTrigger on Sales_Rep_Profile__c (before insert, after insert, before update, after update) {    

    if(!FunnelTriggerBatchHelper.doNotCallSPTrigger){
       
        // Added to check is historic batches are completed for role change date
        Date todayDate = Date.today();
        Date snapDate = Date.newinstance(todayDate.year(), todayDate.month(), 1);
        snapDate =  snapDate.addDays(-3);
        
        List<Sales_rep_profile_snapshot__c> snap = [Select id from Sales_rep_profile_snapshot__c where Snapshot_Scheduled_Date__c > :snapDate]; 
        Boolean hisPresnt = false;
        if(snap != null && snap.size()>0 ){
            hisPresnt = true;
        }
        
        List<Notification_Setting__c> noti = [select id, On_boarding_period__c from  Notification_Setting__c ORDER BY createddate DESC limit 1];
        integer numberOfDay = 0;
        
        if(noti.size() > 0 && noti[0].On_boarding_period__c != null){
            numberOfDay = (integer)noti[0].On_boarding_period__c;
        }
    
        Set<id> salesProfYtdUpdated = new Set<Id>();
        
        system.debug(' CPU Limit Consumption: '+Limits.getCPUtime());
        
        /*
        List<User> usrs = [SELECT id, CreatedDate FROM User LIMIT 5000];
        Map<Id,Date> usrDateMap = new Map<Id,Date>();
        
        for(User u:usrs){
            usrDateMap.put(u.id,Date.newInstance(u.CreatedDate.year(), u.CreatedDate.month(), u.CreatedDate.day()));  
        }*/
        
        //Create a map of sales profile and corresponding manager
        Map<Id,Id> profMgrMap = new Map<Id,Id>();
        
        List<Sales_Rep_Profile__c> allProfs = [SELECT id, Sales_Manager__c FROM Sales_Rep_Profile__c LIMIT 2000];            
        
        Map<Id,List<Id>> mgrVsRepsMap = new Map<Id,List<Id>>();
        
        Map<Id,List<Id>> mgrList = new Map<Id,List<Id>>();
                
        for(Sales_Rep_Profile__c s:allProfs){
            if(s.Sales_Manager__c != null){
                if(mgrVsRepsMap == null || (!mgrVsRepsMap.keySet().contains(s.Sales_Manager__c))){
                    List<Id> suborList = new List<Id>();
                    suborList.add(s.Id);
                    mgrVsRepsMap.put(s.Sales_Manager__c,suborList);
                }
                else if(mgrVsRepsMap.containsKey(s.Sales_Manager__c)){
                    mgrVsRepsMap.get(s.Sales_Manager__c).add(s.id);
                }
            }
        }
        system.debug(' mgrVsRepsMap'+mgrVsRepsMap);
        system.debug(' C1');
        system.debug(' CPU Limit Consumption: '+Limits.getCPUtime());
        
        Boolean managerChanged = false;
        Boolean managerNullified = false;
        Map<Id,Id> profRemMgrMap = new Map<Id,Id>();

        Set<Id> profsForCertCreation = new Set<Id> ();       
        Set<Id> profsForAnsDeletion = new Set<Id> ();
        Set<Id> profsForAnsCreation = new Set<Id> ();
       
        system.debug(' C2');
        
        //If the sales profile has been deactivated, the monthly quota for the remaining months should be updated to zero
        
        //Find the first month of the fiscal year
        Date fy = FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        Integer mon = fy.month();
        
        //Create a list of the 12 months in the fiscal year
        List<Integer> monLst = new List<Integer> ();
        
        for(Integer i = 0; i <12; i++){
            if(mon >12){
                mon = 13 - mon;
            }
            monLst.add(mon);
            mon++;
        }
        
        //Find the current month
        Integer currMonth = System.today().month();
        
        //Find the index of the current month in the list, update the quota values of the rest of the months to zero
        Integer currInd;
        
        for(Integer i = 0; i <12; i++){
            
            if(monLst[i] == currMonth){
                currInd = i;
                break;
            }
            
        }
        system.debug(' CPU Limit Consumption: '+Limits.getCPUtime());
        
        //End of creation of map of profile versus manager    
        for(Sales_Rep_Profile__c s : Trigger.new){    
        
            if(trigger.isInsert && trigger.isBefore){
                system.debug(' CB');
                if(s.Role__c != null && s.Role__c != ''){
                    s.Role_change_date__c = System.today();
                }
                
                if(s.Rep_Staus__c == 'New' && numberOfDay > 0 && s.Rep_start_date__c != null){
                    //s.On_boarding_Date__c = Date.newInstance(system.today().year(), system.today().month(), system.today().day()+numberOfDay);
                    s.On_boarding_Date__c = s.Rep_start_date__c + numberOfDay;
                }
                
                if(s.User_record_name__c != null && s.User_Record_name__r.isActive){
                    s.Active__c = true;
                }
                
            } 
            
            /*if((trigger.isInsert && trigger.isBefore && s.User_Record_Name__c != null) || (trigger.isUpdate && trigger.isBefore && s.User_Record_Name__c != null && (Trigger.oldMap.get(s.id).User_Record_Name__c != s.User_Record_Name__c))){
                s.Rep_Start_Date__c = usrDateMap.get(s.User_Record_Name__c);
            }*/
            
            if(trigger.isUpdate && trigger.isBefore && Trigger.oldMap.get(s.id).Role__c != s.Role__c && hisPresnt ){                            
                s.Role_change_date__c = System.today();                        
            }
            
            if(trigger.isUpdate && trigger.isBefore && ((Trigger.oldMap.get(s.id).Rep_Staus__c != s.Rep_Staus__c) || (Trigger.oldMap.get(s.id).Rep_Start_date__c != s.Rep_Start_date__c)) && s.Rep_Staus__c == 'New' && numberOfDay > 0 && s.Rep_start_date__c != null){                            
                //s.On_boarding_Date__c = Date.newInstance(s.CreatedDate.year(), s.CreatedDate.month(), s.CreatedDate.day()+numberOfDay);                     
                s.On_boarding_Date__c = s.Rep_start_date__c + numberOfDay;
            }
            
            if(trigger.isUpdate && trigger.isAfter && Trigger.oldMap.get(s.id).YTD_Quota_Percentage__c != s.YTD_Quota_Percentage__c){
                system.debug(' id added '+s.id);
                salesProfYtdUpdated.add(s.id);            
            }
            
            //Create a map of the sales profiles that have updated managers
            if(trigger.IsAfter && (trigger.isInsert || (trigger.isUpdate && (Trigger.oldMap.get(s.id).Sales_Manager__c != s.Sales_Manager__c))) && s.Sales_Manager__c != null){
                system.debug(' manager changed ');
                managerChanged = true;
                //create a map of the updated sales profile and the manager
                profMgrMap.put(s.id,s.Sales_Manager__c);
            }
            else if(trigger.IsAfter && trigger.isUpdate && (Trigger.oldMap.get(s.id).Sales_Manager__c != s.Sales_Manager__c) && s.Sales_Manager__c == null){
                managerNullified = true;
                profRemMgrMap.put(s.id,Trigger.oldMap.get(s.id).Sales_Manager__c); 
                system.debug(' manager removed');
                system.debug(' profRemMgrMap '+profRemMgrMap);
            }
            
            if(trigger.isAfter && trigger.isInsert && s.Role__c != null){
                profsForCertCreation.add(s.id);
                profsForAnsCreation.add(s.id);    
            }
            else if(trigger.isAfter && trigger.isUpdate && (Trigger.oldMap.get(s.id).Role__c != s.Role__c) && s.Role__c != null){
                profsForCertCreation.add(s.id);
                profsForAnsDeletion.add(s.id); 
                profsForAnsCreation.add(s.id);
            }
            
            if(trigger.isUpdate && trigger.isBefore && Trigger.oldMap.get(s.id).Active__c == true && s.Active__c == false){
                for(integer i = currInd + 2; i < 13; i++){
                    s.put('Month_'+i+'_Quota_Amount__c',0);
                }
            }
            
            if((trigger.isUpdate && trigger.isBefore && ((Trigger.oldMap.get(s.id).Annual_quota_amount__c != s.Annual_quota_amount__c) || (Trigger.oldMap.get(s.id).Current_fiscal_months__c != s.Current_fiscal_months__c))) || (trigger.isInsert && trigger.isBefore && s.Annual_quota_amount__c > 0)){
                FunnelTriggerBatchHelper.updateYTDQuota(s);
            }                      
        }
        system.debug(' C3');
        system.debug(' CPU Limit Consumption: '+Limits.getCPUtime());
        
        if(managerNullified && profRemMgrMap.values() != null && profRemMgrMap.size() > 0){
            
            /*
            //Find the company levels associated with the old manager records
            List<Company_level__c> cls = [SELECT id,Sales_Rep_Profile__c FROM Company_level__c WHERE Sales_rep_profile__c IN :profRemMgrMap.values()];
            
            //Map of old managers and company levels
            Map<Id,id> mgrCompLevMap = new Map<id,id>();
            
            for(Company_level__c c:cls){
                mgrCompLevMap.put(c.Sales_Rep_Profile__c,c.id);
            }    
            */
            
            //Find the company levels associated with the old manager records
            List<Sales_Profile_Company_Level_Junction__c> cls = [SELECT id,Sales_Rep_Profile__c,Company_level__c FROM Sales_Profile_Company_Level_Junction__c WHERE Sales_rep_profile__c IN :profRemMgrMap.values()];
             system.debug('cls '+cls );
            //Map of old managers and company levels
            Map<Id,Set<id>> mgrCompLevMap = new Map<id,Set<id>>();
            
            for(Sales_Profile_Company_Level_Junction__c j:cls){
            
                if(mgrCompLevMap.containsKey(j.Sales_rep_profile__c)){
                    mgrCompLevMap.get(j.Sales_rep_profile__c).add(j.Company_level__c);
                }
                else{
                    Set<id> ids = new Set<id>();
                    ids.add(j.Company_level__c);
                    mgrCompLevMap.put(j.Sales_rep_profile__c,ids);
                }
            }
            system.debug('mgrCompLevMap'+mgrCompLevMap);
            
            //Fetch the sales profiles under the mgr whose manager is nullified
            List<Id> profsForJun = new List<Id>();
            
            for(Id i:profRemMgrMap.keySet()){
                if(mgrVsRepsMap.get(i) != null){
                    profsForJun.addAll(mgrVsRepsMap.get(i));
                }
            }
            system.debug('profsForJun'+profsForJun);
            
            profsForJun.addAll(profRemMgrMap.keySet());
            system.debug('profsForJun'+profsForJun);
            List<id> compLevs = new list<id>();
            
            for(id i: mgrCompLevMap.keySet()){
                compLevs.addAll(mgrCompLevMap.get(i));
            }
            system.debug('compLevs'+compLevs);
            //List of all junction records associated with the manager and people under
            List<Sales_Profile_Company_Level_Junction__c> juncs = [SELECT id, Sales_Rep_profile__c, Company_level__c FROM Sales_Profile_Company_Level_Junction__c WHERE Company_level__c IN :compLevs AND Sales_Rep_profile__c IN :profsForJun];
            
            Map <id, Sales_Profile_Company_Level_Junction__c> juncsToDeleteMap = new Map <id, Sales_Profile_Company_Level_Junction__c> ();
           
            //Iterate through the reps whose  manager is nullified
            system.debug(' mgrVsRepsMap'+mgrVsRepsMap);
            for(Id sp: profRemMgrMap.keySet()){
                //Iterate through every person under the manager 
                system.debug(' sp='+sp);  
                if(mgrVsRepsMap.get(sp) != null){
                    for(Id spId: mgrVsRepsMap.get(sp)){
                        //Iterate through all the junction records
                        for(Sales_Profile_Company_Level_Junction__c j : juncs){ 
                            //Check if the junction record matches the sales profile and corresponding company levle
                            if(j.Sales_Rep_Profile__c == spId &&  mgrCompLevMap.get(profRemMgrMap.get(sp)) != null &&  mgrCompLevMap.get(profRemMgrMap.get(sp)).contains(j.Company_level__c)){
                                juncsToDeleteMap.put(j.id,j);
                            }                        
                        }   
                    }
                }
                
            }
            system.debug('juncsToDeleteMap'+juncsToDeleteMap);
            //Iterate through the profiles updated 
            for(Id sp: profRemMgrMap.keySet()){
                //Iterate through the junction records
                for(Sales_Profile_Company_Level_Junction__c j : juncs){
                    //Check if the sales profile on the junction record matches the company level of the old manager 
                    if(j.Sales_Rep_Profile__c == sp &&  mgrCompLevMap.get(profRemMgrMap.get(sp)) != null &&  mgrCompLevMap.get(profRemMgrMap.get(sp)).contains(j.Company_level__c)){
                        juncsToDeleteMap.put(j.id,j);
                    }
                }
            }  
            system.debug('juncsToDeleteMap'+juncsToDeleteMap);
            if(juncsToDeleteMap.size() > 0)
                FunnelTriggerBatchHelper.deleteJunctionRecords(juncsToDeleteMap.keySet());
                //DELETE juncsToDeleteMap.values();
            
        }                

        system.debug(' CPU Limit Consumption: '+Limits.getCPUtime());
        
        if(managerChanged && profMgrMap.values() != null && profMgrMap.size() > 0){
            
            system.debug(' prof Manager map '+profMgrMap);
            
            //Create a map of the sales profile and corresponding certification record
            Map<Id,Id> profCertMap = new Map<id,id>();
            
            List<Certification__c > certList = [SELECT Sales_Rep_Profile__c, ID FROM Certification__c WHERE Sales_Rep_Profile__c IN :profMgrMap.keySet()];
            
            for(Certification__c c:certList){
                profCertMap.put(c.Sales_Rep_Profile__c,c.id);    
            }
            //End of creation of sales profile and corresponding certification record map
            
            //Fetch all the junction records associated with the updated managers, store them as a map of manager versus junction records
            Map<Id,List<Sales_Profile_Company_Level_Junction__c>> mgrJuncMap = new Map<Id,List<Sales_Profile_Company_Level_Junction__c>>();
            
            //Fetch the junction records under the manager
            List<Sales_Profile_Company_Level_Junction__c> junc = [SELECT Id, Company_Level__c, Sales_Rep_Profile__c, Certification__c FROM Sales_Profile_Company_Level_Junction__c WHERE Sales_Rep_Profile__c IN :profMgrMap.values()];
            
            for(Sales_Profile_Company_Level_Junction__c s: junc){
                //Check if the map contains a line item for the sales manager id
                if(!mgrJuncMap.keySet().contains(s.Sales_Rep_Profile__c)){            
                    List<Sales_Profile_Company_Level_Junction__c> juncs = new List<Sales_Profile_Company_Level_Junction__c>();
                    juncs.add(s);
                    
                    mgrJuncMap.put(s.Sales_Rep_Profile__c,juncs);
                }
                else{
                    mgrJuncMap.get(s.Sales_Rep_Profile__c).add(s);
                }
            }
            //End of creation of map of mgr versus junction records
            
            system.debug(' manager junction map '+mgrJuncMap);
            
            //Fetching the list of all updated sales profiles and the people under them in the below list
            List<id> profListForJuncDeletion = new List<id>();
            
            //Creating a map of the updated sales profile and everyone under
            Map<id,List<id>> profWithRepsUnderThem = new Map<id,List<id>>();
            
            system.debug(' prof mgr map before addition of junction records '+profMgrMap);

            //For every sales profile for which the manager is updated, fetch the reps under that profile
            //These are needed because the junction records under all these need to be updated
            system.debug('CPU Limit Consumption Start: '+Limits.getCPUtime());

            for(Id i : profMgrMap.keySet()){
                
                List<Id> mgrIds = new List<Id>();
                mgrIds.add(i);
                
                List<Id> junctsToBeCreated = new List<Id>();
                junctsToBeCreated.add(i);
                                        
                while(mgrIds != null && mgrIds.size()>0){
                    List<Id> newMgrIds = new List<Id>();
                    for(Id mgrId:mgrIds){
                        if(mgrVsRepsMap.get(mgrId) != null){
                            junctsToBeCreated.addAll(mgrVsRepsMap.get(mgrId)); 
                            newMgrIds.addAll(mgrVsRepsMap.get(mgrId));
                        }          
                    }
                    mgrIds = new List<Id>();
                    mgrIds.addAll(newMgrIds);
                }
                
                //Map of managers and all the reps under them
                profWithRepsUnderThem.put(i,junctsToBeCreated);
                
                //List to fetch the sales profiles for which the junction records should be updated
                profListForJuncDeletion.addAll(junctsToBeCreated);
                                
            }
            
            system.debug(' CPU Limit Consumption End: '+Limits.getCPUtime());
            
            //system.debug(' manager junction map '+mgrJuncMap);
            
            //system.debug(' sales profiles for which juncs need to be updated '+profListForJuncDeletion);
            
            //Find out the levels that the updated sales profile and the reps under them are associated with
            //Delete all junction records except those associated with these levels
            List<String> doNotDeleteList = new List<String>();
            List<Company_Level__c> levs = [SELECT Level_Value__c FROM Company_Level__c WHERE Sales_Rep_Profile__c IN :profListForJuncDeletion];
            for(Company_Level__c c: levs){
                doNotDeleteList.add(c.Level_Value__c);
            }

            system.debug(' CPU Limit Consumption: '+Limits.getCPUtime());
            
            //system.debug(' do not delete these levels '+doNotDeleteList);
            
            //Fetch all the junction records the sales profiles were previously associated with and delete them
            List<Sales_Profile_Company_Level_Junction__c> juncsToDelete = [SELECT id FROM Sales_Profile_Company_Level_Junction__c WHERE Sales_Rep_Profile__c IN : profListForJuncDeletion AND Company_Level__r.Level_Value__c NOT IN :doNotDeleteList];
            
            //system.debug(' juncsToDelete '+juncsToDelete);

            system.debug(' CPU Limit Consumption: '+Limits.getCPUtime());
            
            if(juncsToDelete != null && juncsToDelete.size() > 0){
                DELETE juncsToDelete;
            }
            //End of deletion of records                
            
            //List of new junction records that need to be created
            List<Sales_Profile_Company_Level_Junction__c> juncsToBeAdded = new List<Sales_Profile_Company_Level_Junction__c>();
            
            //system.debug(' profMgrMap.keySet() '+profMgrMap.keySet());
            system.debug(' CPU Limit Consumption: '+Limits.getCPUtime());

            //Iterate through the map of sales profiles and new managers
            //Create the same junction records on the profiles as the new manager
            for (Id key : profMgrMap.keySet()){
                
                system.debug(' key value '+mgrJuncMap.get(profMgrMap.get(key)));
                
                List<Sales_Profile_Company_Level_Junction__c> newJuncs = new List<Sales_Profile_Company_Level_Junction__c>();                        
                   
                if(mgrJuncMap.get(profMgrMap.get(key)) != null){      
                    
                    newJuncs = mgrJuncMap.get(profMgrMap.get(key));                     
                                               
                    system.debug(' the profile '+key+' has the following reps under them '+profWithRepsUnderThem.get(key));
                    //For the sales profile and everyone under the sales porofile create the same junction records as the manager
                    for(Id val: profWithRepsUnderThem.get(key)){                          
                        for(Sales_Profile_Company_Level_Junction__c j : newJuncs){
                            Sales_Profile_Company_Level_Junction__c s = new Sales_Profile_Company_Level_Junction__c ();
                            s.Sales_Rep_Profile__c = val;
                            s.Company_Level__c = j.Company_Level__c;
                            //s.Company_Level_Picklist__c = j.Company_Level_Picklist__c;
                            s.Certification__c = profCertMap.get(key);
                            juncsToBeAdded.add(s);
                        }
                        system.debug(' juncsToBeAdded '+juncsToBeAdded); 
                    }    
                }
            }

            system.debug(' CPU Limit Consumption: '+Limits.getCPUtime());
                    
            if(juncsToBeAdded.size() > 0){
                insert juncsToBeAdded;
            }
            
            system.debug(' juncsToBeAdded '+juncsToBeAdded);
        }
        system.debug(' CPU Limit Consumption: '+Limits.getCPUtime());

        if(salesProfYtdUpdated.size() > 0){    
            FunnelTriggerBatchHelper.updateYTDQuotaOnCert(salesProfYtdUpdated);
            FunnelTriggerBatchHelper.calculateAggregateScoreForManagers(salesProfYtdUpdated);        
        } 
        
        if(profsForCertCreation.size() > 0){
            FunnelCreateCertAnswers_Controller.createCerts(profsForCertCreation);                    
        }
        
        if(profsForAnsDeletion.size() > 0 || profsForAnsCreation.size() > 0){
            FunnelCreateCertAnswers_Controller.deleteAndCreateCertAnswers(profsForAnsDeletion,profsForAnsCreation,'trigger');            
        }
        
        system.debug(' CPU Limit Consumption: '+Limits.getCPUtime());       
        
    }  
}