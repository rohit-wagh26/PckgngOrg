public with sharing class FunnelInstallationStep1Controller {

    public String selectedMonth{get;set;}
    public String selectedObj{get;set;}
    public Date FiscalYearDate{get;set;}
    public boolean leadUsed{get;set;}
    public boolean meetingUsed{get;set;}
    public String meetingvalue{get;set;}
    public Decimal qualifiedPercentage{get;set;}
    public Decimal historicPercentage{get;set;}
    public Decimal stretchPercentage{get;set;}
    public List<Application_Setting__c> appSetting  = new List<Application_Setting__c>();
    public String instanceName {get;set;}
    public Application_Setting__c fsdate{get;set;}
    public String tps{get;set;}
    
    public FunnelInstallationStep1Controller(){
        tps ='tps';
        instanceName = [select InstanceName from Organization limit 1].InstanceName.toLowercase();


        fsdate = new Application_Setting__c ();
        
        
        appSetting = [Select id,Object_for_Meeting__c,Leads_used__c,Meetings_used__c,Meetings_Values__c,Probability__c,Qualified_Percentage__c,Stretch_percentage__c,Implementation_Date__c From Application_Setting__c Limit 1 ];
        Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues('Historic_Year');
        
        if(fy != null){
            FiscalYearDate = fy.Start_Date__c;
            fsdate.Implementation_Date__c  = fy.Start_Date__c;
        }
        
        if(appSetting != null && appSetting.size()>0){
            leadUsed= appSetting[0].Leads_used__c;
            meetingUsed= appSetting[0].Meetings_used__c;
            meetingvalue= appSetting[0].Meetings_Values__c;
            qualifiedPercentage= appSetting[0].Probability__c;
            historicPercentage= appSetting[0].Qualified_Percentage__c;
            stretchPercentage= appSetting[0].Stretch_percentage__c ;
            selectedObj= appSetting[0].Object_for_Meeting__c;
            
            if(appSetting[0].Implementation_Date__c != null){ 
                selectedMonth = String.valueOf(appSetting[0].Implementation_Date__c.month());
            }
        }
         
    }
    
     
    public List<SelectOption>  getMonths() {
           
           List<SelectOption> Options = new List<SelectOption>();
           Options.add(new SelectOption('1','January')); 
           Options.add(new SelectOption('2','February')); 
           Options.add(new SelectOption('3','March')); 
           Options.add(new SelectOption('4','April')); 
           Options.add(new SelectOption('5','May')); 
           Options.add(new SelectOption('6','June')); 
           Options.add(new SelectOption('7','July')); 
           Options.add(new SelectOption('8','August')); 
           Options.add(new SelectOption('9','September')); 
           Options.add(new SelectOption('10','October')); 
           Options.add(new SelectOption('11','November')); 
           Options.add(new SelectOption('12','December')); 
           
           return Options ;
     }
     
    public List<SelectOption>  getObjForMeetings() {
           
           List<SelectOption> Options = new List<SelectOption>();
           Options.add(new SelectOption('Event','Event')); 
           Options.add(new SelectOption('Task','Task')); 
           Options.add(new SelectOption('Event & Task','Event & Task')); 
            
           return Options ;
     }
     
    public void ChangeDate(){
        //FiscalYearDate = Date.newInstance(FiscalYearDate.year(), FiscalYearDate.month(), 1);
        fsdate.Implementation_Date__c =  Date.newInstance(fsdate.Implementation_Date__c.year(), fsdate.Implementation_Date__c.month(), 1);
        FiscalYearDate  = fsdate.Implementation_Date__c ;
    }
    
    public void save(){
        FunnelInstallationHelper.saveStep('1');
        if(appSetting != null && appSetting.size()>0){
            appSetting[0].Leads_used__c =  leadUsed;
            appSetting[0].Meetings_used__c =  meetingUsed;
            appSetting[0].Meetings_Values__c = meetingvalue;
            appSetting[0].Probability__c = qualifiedPercentage ;
            appSetting[0].Qualified_Percentage__c = historicPercentage;
            appSetting[0].Stretch_percentage__c = stretchPercentage;
            appSetting[0].Object_for_Meeting__c = selectedObj;
            
            if(selectedMonth != null)
            appSetting[0].Implementation_Date__c = Date.newInstance(System.Today().year(), Integer.valueOf(selectedMonth), 1);
             
            update appSetting;
        
        }else{
            Application_Setting__c aps = new Application_Setting__c();
            aps.Name =  'Application Setting';
            aps.Leads_used__c =  leadUsed;
            aps.Meetings_used__c =  meetingUsed;
            aps.Meetings_Values__c = meetingvalue;
            aps.Probability__c = qualifiedPercentage ;
            aps.Qualified_Percentage__c = historicPercentage;
            aps.Stretch_percentage__c = stretchPercentage;
            aps.Object_for_Meeting__c = selectedObj;
            
            if(selectedMonth != null)
            aps.Implementation_Date__c = Date.newInstance(System.Today().year(), Integer.valueOf(selectedMonth), 1);
             
            insert aps;
        
        }
        
        Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues('Historic_Year');
        
        if(fy != null){
            fy.Start_Date__c = FiscalYearDate;
            update fy;
        }else if(FiscalYearDate != null){
            Fiscal_Year_Setting__c  fs= new Fiscal_Year_Setting__c ();
            fs.Start_Date__c = FiscalYearDate ;
            fs.name = 'Historic_Year';
            insert fs;
        }
        
        Fiscal_Year_Setting__c fyc = Fiscal_Year_Setting__c.getValues('Current_Year');
        
        if(fyc != null && FiscalYearDate != null){
            fyc.Start_Date__c = Date.newInstance(date.today().year(), FiscalYearDate.month(), 1);  
            update fyc;
        }else if(FiscalYearDate != null){
            Fiscal_Year_Setting__c  fs= new Fiscal_Year_Setting__c ();
            fs.Start_Date__c = Date.newInstance(date.today().year(), FiscalYearDate.month(), 1);  
            fs.name = 'Current_Year';
            insert fs;
        }
    
    }
    
     public PageReference navigateToIntro(){
        save();
         
        return FunnelInstallationHelper.navigateToIntro();
    
    }
    
     public PageReference navigateToStep2(){
        save();
        return FunnelInstallationHelper.navigateToStep2();
    
    }
    
    public PageReference saveAndExit(){
        save();
        return FunnelInstallationHelper.navigateToChecklist();
    }
}