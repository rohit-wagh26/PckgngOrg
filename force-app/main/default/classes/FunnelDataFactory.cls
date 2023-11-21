/*
Copyright: Funnel Metrics, LLC
*/
public with Sharing class FunnelDataFactory{
    
    public class FunnelTestWrapper{    
        public String name {get; set;}        
        public Id salesMgr {get; set;}        
        public String role {get; set;}
        public Integer index {get; set;}
        public id userid {get; set;}
        public String levelName {get; set;}
        public String levelValue {get; set;}
        public Id salesProfForCompLevel {get; set;}  
        public Integer oppAmt {get; set;} 
        public String oppStage {get; set;}    
        public Date closeDate {get; set;}
        public id userRoleId{get;set;}
        public id profileId {get;set;}
        public String type {get; set;}
        public String calcType {get; set;}
        public String category {get; set;}
        public String userType {get; set;}
        public String timing {get; set;}
        public String weight {get; set;}
        public Id certificationId {get; set;}
        public String rolesEnabled {get; set;}
        public integer fsscore{get; set;}
        public integer qsscore{get; set;}
        public id salesProfId{get; set;}
        
        public string customobj{get;set;}
        public string customfield{get;set;}
        public string relby{get;set;}
        public string agg{get;set;}
        public string datefield{get;set;}
        public string dateperiod{get;set;}
        //public string srpname{get;set;}
        
    }
    
    public static List<User> createUser(FunnelTestWrapper f , integer size){    
       
        List<User> ulist = new List<User>();
        
        for(integer i= 1; i<= size; i++){
                User u = new User(
                ProfileId = f.ProfileId,
                LastName = i+'last',
                Email = 'TestUser'+f.index+'@test.com',
                Username = 'TestUser'+i+f.index+System.currentTimeMillis()+'@test.com',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'GMT',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                UserRoleId = f.userRoleId
            );
            f.index += 1;
            ulist.add(u);
        }
        
        //system.assertEquals(ulist.size(),size);
        return ulist;
        
    }
    
    public static List<Company_Level__c> createCompanyLevel(FunnelTestWrapper f, List<Sales_Rep_Profile__c> sp){
        
        List<Company_Level__c> cl = new List<Company_Level__c>();
        
        for(Sales_Rep_Profile__c s: sp){
            Company_Level__c c = new Company_Level__c(Level_Name__c = f.levelName,
                                                   Level_Value__c = f.levelValue,
                                                   Sales_Rep_Profile__c = s.id);
            cl.add(c);
        }
        //system.assertEquals(cl.size(),sp.size());                                           
        return cl;
    }
    
    public static Important_rating__c createImportantRating(Id ratingId, String role){
        
        Important_Rating__c ir = new Important_Rating__c();
        ir.Certification_Rating__c = ratingId;
        ir.Role__c = role;
        ir.Importance_coefficient__c = 5;
        return ir;
    }
    
    //create Company_Level_Junction_snapshot__c
    
    public static List<Company_Level_Junction_snapshot__c> createCompanyLevelJunctionSnapshots(List<Company_Level__c> sp){
        
        List<Company_Level_Junction_snapshot__c> cl = new List<Company_Level_Junction_snapshot__c>();
        
        
        for(Company_Level__c s: sp){
            date sdate = Date.newInstance(2019, 2, 28);
            integer lastDay ;
            for(integer i = 0; i < 12 ; i ++){
                Company_Level_Junction_snapshot__c c = new Company_Level_Junction_snapshot__c (Company_Level__c = s.id,
                                                       Sales_Rep_Profile__c = s.Sales_Rep_Profile__c,Snapshot_Scheduled_Date__c =sdate  );
                cl.add(c);
                sdate = sdate .addMonths(-1);
                lastDay = Date.daysInMonth(sdate.year(), sdate.month());
                sdate = Date.newInstance(sdate.year(), sdate.month(), lastDay); 
            }
        }
        //system.assertEquals(cl.size(),sp.size());                                           
        return cl;
    }
    
    public static Sales_Rep_Profile__c createSalesRep(FunnelTestWrapper f){
                        
        Sales_Rep_Profile__c testsrp = new Sales_Rep_Profile__c();                
        testsrp.Name ='Test SRP '+f.index;
        testsrp.User_Record_Name__c = f.userid;
        testsrp.Sales_Manager__c = f.salesMgr;
        testsrp.Month_1_Quota_Amount__c = 100;
        //testsrp.Active__c = true;
       // insert testsrp;
       //system.assert(testsrp.Name.contains('Test SRP')); 
        return testsrp;
    }
    
    /*
    public static Opportunity createOpp(FunnelTestWrapper f){
        
        account ac = new account();
                
        List<String> fldList1 = new List<String>{'name'};
            
        Boolean updateAccess = true;
                    
        Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap();
        
        for(String fldName: fldList1){
            if(!fieldMap1.get(fldName).getDescribe().isCreateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              updateAccess = false;
            }                
        }
        
        if(updateAccess)
            ac.Name='test ac '+f.index;
                             
        if(Schema.sObjectType.Account.isCreateable()){
            insert ac;
        }
                                        
        Opportunity o = new Opportunity();    
        
        List<String> fldList2 = new List<String>{'name','ownerid','Amount','StageName','CloseDate','AccountId'};
            
        updateAccess = true;
                    
        Map <String, Schema.SObjectField> fieldMap2 = Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap();
        
        for(String fldName: fldList2){
            if(!fieldMap2.get(fldName).getDescribe().isCreateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              updateAccess = false;
            }                
        }
        
        if(updateAccess){
            o.Name ='Test SRP Opportunity'+f.index;
            o.ownerid = f.userid;
            o.Amount = f.oppAmt;
            o.StageName = f.oppStage;
            o.CloseDate = f.closeDate;
            o.AccountId = ac.id;
        }
        
        if(Schema.sObjectType.Opportunity.isCreateable()){
            insert o;
        }

        //system.assertEquals(o.AccountId,ac.id); 
        return o;
    }
    
    public static Opportunity createOpportunity(Integer i, String stage, Date closeDate){
        
        account ac = new account();
        
        List<String> fldList1 = new List<String>{'name'};
            
        Boolean updateAccess = true;
                    
        Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap();
        
        for(String fldName: fldList1){
            if(!fieldMap1.get(fldName).getDescribe().isCreateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              updateAccess = false;
            }                
        }
        
        if(updateAccess)
            ac.Name='test ac '+i;
                             
        if(Schema.sObjectType.Account.isCreateable()){
            insert ac;
        }
        
                
        Opportunity op = new Opportunity();
        
        List<String> fldList2 = new List<String>{'name','Amount','StageName','CloseDate','AccountId'};
            
        updateAccess = true;
                    
        Map <String, Schema.SObjectField> fieldMap2 = Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap();
        
        for(String fldName: fldList2){
            if(!fieldMap2.get(fldName).getDescribe().isCreateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              updateAccess = false;
            }                
        }
        
        if(updateAccess){
            op.Name = 'test op '+i;
            op.AccountId = ac.id;
            op.StageName = stage;        
            op.CloseDate = closeDate;                
            op.amount = 50;
        }
        
        if(Schema.sObjectType.Opportunity.isCreateable()){
            insert op;
        }                        
        //system.assertEquals(op.amount,50); 
        return op;    
    }*/

    public static Fiscal_Year_Setting__c setFiscalYear(Date dateVal){
        
        Fiscal_Year_Setting__c   fs = new Fiscal_Year_Setting__c();
        fs.Start_Date__c = dateVal;
        fs.Name = 'Current_Year';
        //system.assertEquals(fs.Name,'Current_Year'); 
        return fs;        
    }
    
    public static List<Sales_Rep_Profile__c> createSalesReplist(List<user> u){
        
        list<Sales_Rep_Profile__c >  splist = new  list<Sales_Rep_Profile__c >();
        integer a = 1;
        for(user us : u){
            Sales_Rep_Profile__c testsrp = new Sales_Rep_Profile__c();                
            testsrp.Name ='Test SRP '+a;
            testsrp.User_Record_Name__c = us.id;
            //testsrp.Active__c = true;
           if(a == 1){
               testsrp.Goal_of_monthly_meetings__c = 10;
                testsrp.Goal_12m_Avg_Selling_Price__c = 100;
                testsrp.Goal_12m_rolling_close_rate__c= 20;
                testsrp.Month_1_Quota_Amount__c = 100;
                testsrp.Close_rate_monthly_opp_amount__c = 50;
                testsrp.Close_rate_monthly_opp_count__c = 2;
                testsrp.Close_rate_Quarterly_opp_amount__c = 100;
                testsrp.Close_rate_Quarterly_opp_count__c = 3;
                testsrp.Close_rate_YTD_opp_amount__c = 100;
                testsrp.Close_rate_YTD_opp_count__c = 3;
           }else if(a == 2){
                testsrp.Month_2_Quota_Amount__c = 100;
           }else if(a == 3){
                testsrp.Month_3_Quota_Amount__c = 100;
           }else if(a == 4){
                testsrp.Month_4_Quota_Amount__c = 100;
           }else if(a == 5){
               testsrp.Month_5_Quota_Amount__c = 100;
           }else if(a == 6){
                testsrp.Month_6_Quota_Amount__c = 100;
           }else if(a == 7){
                testsrp.Month_7_Quota_Amount__c = 100;
           }else if(a == 8){
                testsrp.Month_8_Quota_Amount__c = 100;
           }else if(a == 9){
                testsrp.Month_9_Quota_Amount__c = 100;
           }else if(a == 10){
                testsrp.Month_10_Quota_Amount__c = 100;
           }else if(a == 11){
                testsrp.Month_11_Quota_Amount__c = 100;
           }else if(a == 12){
                testsrp.Month_12_Quota_Amount__c = 100;
           }
            
            a++;
            splist .add(testsrp );
        }            
        //system.assertEquals(splist.size(),u.size());
        return splist ;
    }
    
    //create srp snapshots 
    public static List<Sales_Rep_Profile_Snapshot__c> createSalesReplistSnapshot(List<Sales_Rep_Profile__c> u){
        
        list<Sales_Rep_Profile_Snapshot__c>  splist = new  list<Sales_Rep_Profile_Snapshot__c>();
        Sales_Rep_Profile_Snapshot__c testsrp = new Sales_Rep_Profile_Snapshot__c();  
        for(Sales_Rep_Profile__c sp : u){
            
            date sdate = Date.newInstance(2019, 2, 28);
            integer lastDay ;
            for(integer i = 0; i < 12 ; i ++){
                testsrp = new Sales_Rep_Profile_Snapshot__c();                
                testsrp.Name ='Test jan';
                testsrp.Sales_Rep_Profile__c = sp.id;
                testsrp.Snapshot_Scheduled_Date__c = sdate ;
                testsrp.Monthly_opp_won__c = 10;
                testsrp.Monthly_opp_lost__c= 10;
                testsrp.Monthly_Lead_Added__c= 10;
                testsrp.Monthly_Opportunities_added_to_Qualifie__c= 10;
                testsrp.X12_Month_Opprties_Added_to_the_funnel__c= 10;
                testsrp.X12_Month_Rolling_Average_Sales_Cycle__c= 10;
                testsrp.X12_Month_Average_Selling_Price__c = 10;
                testsrp.Active__c = true;
                testsrp.Annual_quota_amount__c = 10000;
                splist.add(testsrp );
                
                sdate = sdate .addMonths(-1);
                lastDay = Date.daysInMonth(sdate.year(), sdate.month());
                sdate = Date.newInstance(sdate.year(), sdate.month(), lastDay); 
            }   
        }            
        //system.assertEquals(splist.size(),u.size());
        return splist ;
    }
    
    
    public static List<Opportunity > createopplist(List<user> u){
        
        account ac = new account();
        
        List<String> fldList1 = new List<String>{'name'};
            
        Boolean updateAccess = true;
                    
        Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap();
        
        for(String fldName: fldList1){
            if(!fieldMap1.get(fldName).getDescribe().isCreateable()){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
              updateAccess = false;
            }                
        }
        
        if(updateAccess)
            ac.Name='test ac ';
                             
        if(Schema.sObjectType.Account.isCreateable()){
            insert ac;
        }
                        
        list<Opportunity >  opplist = new  list<Opportunity >();
        integer a = 1;
        for(user us : u){
         
                        
        Opportunity o = new Opportunity();                
        o.Name ='Test SRP Opportunity'+a;
        o.ownerid = us.id;
        o.Amount = 1000;
        o.StageName = 'Closed Won';
        o.CloseDate = System.today();
        o.AccountId = ac.id;
            
        a++;
        
            if(a == 80){
                opplist.add(o);
                break;
            }
        opplist.add(o);
        }            
        //system.assert(opplist!= null);
        return opplist;
    }
    
     public static List<Lead> createLeadlist(List<user> u){
         
        list<Lead>  leadlist = new  list<Lead>();
        integer a = 1;
        
        for(user us : u){
                                         
            Lead l = new Lead(); 
            
            List<String> fldList1 = new List<String>{'ownerId','Company','LastName','Status'};
                
            Boolean updateAccess = true;
                        
            Map <String, Schema.SObjectField> fieldMap1 = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap();
            
            for(String fldName: fldList1){
                if(!fieldMap1.get(fldName).getDescribe().isCreateable()){
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Insufficient access'));
                  updateAccess = false;
                }                
            }
            
            if(updateAccess){
                l.ownerid = us.id;
                l.Company = 'Test SRP Lead'+a;
                l.LastName = 'Mike';
                l.Status = 'New'; 
            }
                                                                                  
            a++;
            
            if(a == 80){
               // l.isconverted= true;
               // l.ConvertedDate = date.today();
                if(Schema.sObjectType.Lead.isCreateable()){
                    insert l;
                }
                Database.LeadConvert lc = new database.LeadConvert();
                lc.setLeadId(l.Id);

                break;
            }
            leadlist.add(l);
        }            
        //system.assert(leadlist!= null);
        return leadlist;
    }
    public static List<Event> createEventlist(List<user> u){
         
        list<Event>  Tasklist = new  list<Event>();
        integer a = 1;
        for(user us : u){
         
                        
        Event e = new Event();                
        e.ownerid = us.id;
        e.Subject = 'Meeting'; 
        e.Type= 'Meeting';
        e.StartDateTime=datetime.now();
        e.EndDateTime=datetime.now();  
         
        a++;
        if(a == 80){
            break;
        }
        Tasklist.add(e);
        }            
        //system.assert(Tasklist!= null);
        return Tasklist ;
    }
    
    public static List<Task> createTasklist(List<user> u){
         
        list<Task>  Tasklist = new  list<Task>();
        integer a = 1;
        for(user us : u){
         
                        
        Task e = new Task ();                
        e.ownerid = us.id;
        e.Subject = 'Meeting';  
        e.Status='New';
        e.Priority='Normal';
        e.CallType='Outbound';
        a++;
        if(a == 80){
            break;
        }
        Tasklist.add(e);
        }            
        //system.assert(Tasklist!= null);
        return Tasklist ;
    }
    
    public static List<Certification__c> createCertification(FunnelTestWrapper fw,List<Sales_Rep_Profile__c> spList){
        
        List<Certification__c> certs = new List<Certification__c>();
        
        if(spList != null &&spList.size()>9){
            integer a = 0;
            for(Sales_Rep_Profile__c s:spList){
                Certification__c c = new Certification__c();
                c.Sales_Rep_Profile__c = s.id;
                c.Overall_Rating__c = a ;
                c.Overall_Qualitative_Rating__c = a ;
                a++;
                certs.add(c);
            }
        }else{
            for(Sales_Rep_Profile__c s:spList){
                Certification__c c = new Certification__c();
                c.Sales_Rep_Profile__c = s.id;
                c.Overall_Rating__c = fw.fsscore;
                c.Overall_Qualitative_Rating__c = fw.qsscore;
                certs.add(c);
            }
        }
        //system.assertEquals(splist.size(),certs.size());
        return certs;
    }
    
     // create certification snapshot
     public static List<Certification_Snapshot__c> createCertificationSnapshot( List<Certification__c> spList){
        
        List<Certification_Snapshot__c> certs = new List<Certification_Snapshot__c>();
        
            
        for(Certification__c s:spList){
            date sdate = Date.newInstance(2019, 2, 28);
            integer lastDay ;
            for(integer i = 0; i < 12 ; i ++){
                Certification_Snapshot__c c = new Certification_Snapshot__c();
                c.Certification__c = s.id;
                c.Overall_Rating__c = 1;
                c.Overall_Qualitative_Rating__c = 2;
                c.Snapshot_Scheduled_Date__c =sdate ;
                certs.add(c);
                
                sdate = sdate .addMonths(-1);
                lastDay = Date.daysInMonth(sdate.year(), sdate.month());
                sdate = Date.newInstance(sdate.year(), sdate.month(), lastDay); 
            }
        }
        //system.assertEquals(splist.size(),certs.size());
        return certs;
    }
     
    public static List<Certification_Rating__c> createCertificationRatings(FunnelTestWrapper fw, Integer count){
        
        List<Certification_Rating__c> certs = new List<Certification_Rating__c>();
        
        for(Integer i = 0; i < count; i++){
            Certification_Rating__c cr = new Certification_Rating__c();
            cr.Assessment_type__c = fw.type;   
            cr.Calculation_type__c = fw.calcType;
            cr.Category__c = fw.category;            
            cr.User_Type__c = fw.userType;
            cr.Timing__c = fw.timing;
            cr.Weight__c = fw.weight;
            cr.Description__c = 'Test description '+i;
            cr.Roles_Enabled__c = fw.rolesEnabled;
            cr.Important_flag__c = true;
            cr.Importance__c = 1;
            
            cr.Custom_Object_Name__c= fw.customobj;
            cr.Custom_Field_Name__c = fw.customfield;
            cr.Custom_Related_by__c = fw.relby;
            cr.Agg__c = fw.agg ;
            cr.Duration_Field__c = fw.datefield;
            cr.Duration_Period__c= fw.dateperiod;
            
            certs.add(cr);
        }
        //system.assertEquals(certs.size(),count);
        return certs;
    }
    
    public static List<Certification_Answer__c> createCertificationAnswers(FunnelTestWrapper fw,List<Certification_Rating__c> certList){
        
        List<Certification_Answer__c> certs = new List<Certification_Answer__c>();
        
        for(Certification_Rating__c c: certList){
            
            Certification_Answer__c a = new Certification_Answer__c();
            a.Certifcation__c = fw.certificationId;
            a.Certifcation_Rating__c = c.id;
            a.Sales_rep_profile__c = fw.salesProfId;
            
            certs.add(a);   
           
        }
        //system.assertEquals(certList.size(),certs.size());
        return certs;
    }
    
    /*
    public static List<Sales_Profile_Company_Level_Junction__c> createLevelJunction(List<Sales_Rep_Profile__c> sr,List<Company_Level__c> cl){
        
        List<Sales_Profile_Company_Level_Junction__c> juncts = new List<Sales_Profile_Company_Level_Junction__c>();
        
        for(Integer i = 0; i < sr.size(); i++){
            Sales_Profile_Company_Level_Junction__c j = new Sales_Profile_Company_Level_Junction__c();
            j.Sales_Rep_Profile__c = sr[i].id;
            j.Company_Level__c = cl[i].id;
            juncts.add(j);        
        }
        //system.assertEquals(sr.size(),juncts.size());
        return juncts;
    }*/
    
    
    public static List<YTD_Quota_Revenue__c> createPriorYearResult(List<Sales_Rep_Profile__c> srplist){
        List<YTD_Quota_Revenue__c> ytdQutoRevenueList = new List<YTD_Quota_Revenue__c>();
        
        for(Sales_Rep_Profile__c s: srplist){
            YTD_Quota_Revenue__c ytdQutoRevenue = new YTD_Quota_Revenue__c ();
            ytdQutoRevenue.Start_date__c = date.newinstance( System.Today().year() - 1, System.Today().month(),System.Today().Day()-1);
            ytdQutoRevenue.Sales_Rep_Profile__c = s.id;
            
            ytdQutoRevenueList.add(ytdQutoRevenue);
        }
        //system.assertEquals(srplist.size(),ytdQutoRevenueList.size());
        return ytdQutoRevenueList;
        
    }
    
    public static List<Funnelocity_Revenue_data__c> createRevenueData(List<Sales_Rep_Profile__c> sp){
        List<Funnelocity_Revenue_data__c> returnList= new List<Funnelocity_Revenue_data__c>();
        for(Sales_Rep_Profile__c s :sp){
            Funnelocity_Revenue_data__c rd = new Funnelocity_Revenue_data__c();
            rd.Sales_Rep_Profile__c =s.id;
            rd.Direct_Revenue__c = 7000;
            rd.Month__c = date.today().month();
            rd.Year__c = date.today().year();
            returnList.add(rd);
        } 
    
        return returnList;
    }
    
     
}