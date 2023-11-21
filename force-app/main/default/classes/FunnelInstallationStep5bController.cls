public with sharing class FunnelInstallationStep5bController {
    
    public List<Sales_Rep_Profile__c> srpList{get;set;} 
    public list<srpwrapper> srpwrapperlist{get;set;}
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    
    public class srpwrapper{
            public string id{get;set;}
            public string name{get;set;}
            public string User_Record_Name{get;set;}
            public string Rep_Start_Date{get;set;}
            public string Role{get;set;}
            public string Sales_Manager{get;set;}
            public string Sales_Managerid{get;set;}
            public string Onboarded{get;set;}
            public string ProfileType{get;set;}
        }

    public FunnelInstallationStep5bController (){
        srpwrapperlist= new List<srpwrapper>();
        srpList =[Select id,name,Profile_Type__c,Rep_Staus__c,User_Record_Name__r.Username, Rep_Start_Date__c,Role__c,Sales_Manager__c,Sales_Manager__r.name  from Sales_Rep_Profile__c order by  name asc LIMIT 5000];
        
        for(Sales_Rep_Profile__c  s:srpList ){
             srpwrapper ac = new srpwrapper();
             ac.id= s.id;
             ac.name= s.name;
             ac.User_Record_Name= s.User_Record_Name__r.Username;
             ac.ProfileType= s.Profile_Type__c;
             ac.Role= s.Role__c;
             ac.Sales_Manager= s.Sales_Manager__r.name ;
             ac.Sales_Managerid = s.Sales_Manager__c;
             if(s.Rep_Staus__c== 'Tenured'){
                 ac.Onboarded = 'Yes';
             }else{
                 ac.Onboarded = 'No';
             }
             
             datetime d =s.Rep_Start_Date__c;
             if(d != null  ){
                  ac.Rep_Start_Date= d.formatGMT('MM/dd/yyyy');
                  ac.Rep_Start_Date=  ac.Rep_Start_Date.replace('/', '-');
              }
             srpwrapperlist.add(ac);
                     
        }
    }
    
    public PageReference uploadSrp(){
        try{
            Map<String,String> managerMap = new Map<String,String>();
            for(Sales_Rep_Profile__c s:srpList ){
                managerMap.put(s.name,s.id);
            }
            
            nameFile= contentFile.toString();
            
            //String bodySR = blobToString( contentFile,'ISO-8859-1');
            System.debug('nameFile:::'+nameFile);
            String[] filelines = new String[]{};
            filelines = nameFile.split('\r\n'); 
            System.debug('filelines :::'+filelines );
            List<Sales_Rep_Profile__c > SrList = new List<Sales_Rep_Profile__c >();
            for(Integer i=2;i<filelines.size();i=i+1){
                 
                String s = filelines[i];
                Integer startIndex;
                Integer endIndex;
                String prevLine = s;
                while(s.indexOf('"') > -1){
                    System.debug('s.indexOf'+ s.indexOf('"'));
                    if(startIndex == null){
                        startIndex = s.indexOf('"');
                        System.debug('startIndex'+startIndex);
                        s = s.substring(0, startIndex) + ':quotes:' + s.substring(startIndex+1, s.length());
                        System.debug('s'+s);
                    }else{
                        if(endIndex == null){
                            endIndex = s.indexOf('"');
                            s = s.substring(0, endIndex) + ':quotes:' + s.substring(endIndex+1, s.length());
                        }
                    }
                    
                    if(startIndex != null && endIndex != null){
                        String sub = s.substring(startIndex, endIndex);
                        sub = sub.replaceAll(',', ':comma:');
                        s = s.substring(0, startIndex) + sub + s.substring(endIndex, s.length());
                        startIndex = null;
                        endIndex = null;
                    }
                }
            
                System.debug('prevLine:::'+prevLine);
                System.debug('s:::'+s);
                
                List<String> colList = new List<String>();
                s += ',Added to incule blank values';
                for(String column : s.split(',')){
                  column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
                  colList.add(column);
                  System.debug('column::'+column);
                }
                
                if(colList != null ){
                    Sales_Rep_Profile__c sr = new Sales_Rep_Profile__c();
                    
                    sr.id = colList[0];
                    sr.name = colList[1];
                    
                    if(colList[3] != null && colList[3] != ''){
                        
                        List<String> d = new List<String>();
                        if(colList[3].contains('-')){
                            d = colList[3].split('-');
                        }else if(colList[3].contains('/')){
                            d = colList[3].split('/');
                        }    
                        
                        if(d != null && d.size() == 3){
                            sr.Rep_Start_Date__c =  Date.newInstance(Integer.valueof(d[2]), Integer.valueof(d[0]), Integer.valueof(d[1]));
                            
                        }
                    }
                    
                     if(colList[4] != null && colList[4] != ''){
                        if(colList[4] == 'Yes'){
                            sr.Rep_Staus__c= 'Tenured'; 
                        }else if(colList[4] == 'No'){
                            sr.Rep_Staus__c= 'New'; 
                        }
                        
                        
                    } 
                    sr.Role__c = colList[5]; 
                    sr.Profile_Type__c = colList[6]; 
                     
                    if(colList[7] != null && colList[7] != '' && managerMap.keyset().contains(colList[7])){
                        sr.Sales_Manager__c = managerMap.get(colList[7]); 
                    }
                    
                   
                    SrList.add(sr);
                }
            }
            
            if(SrList!= null && SrList.size()>0){
                 Database.update(SrList, true);
            }
            
             PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationStep5b'); 
 
        redirect.setRedirect(true);     
        return redirect;
        }catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        return null;
        }
       
    }
    
    public void save(){
        //Database.update(srpList , true);
        update srpList ;
        
    }
    
    public void createHistoricQuotaRecord(){
        List<Sales_Rep_Quota__c> insertList = new List<Sales_Rep_Quota__c>();
        Fiscal_Year_Setting__c fy = Fiscal_Year_Setting__c.getValues('Historic_Year');
        Integer hisYear = fy.Start_Date__c.year();
        Integer currentYear = Date.today().year();
         
        List<Sales_Rep_Profile__c>  srList = [Select id from Sales_Rep_Profile__c Limit 5000];
         
            
            while (hisYear <= currentYear) {
                for(Sales_Rep_Profile__c s : srList){
                    Sales_Rep_Quota__c q = new Sales_Rep_Quota__c();
                    q.Sales_Rep_Profile__c = s.id;
                    q.Year__c = hisYear;
                    insertList.add(q);
                }
                hisYear++;
            }
            
            if(insertList != null && insertList.size()>0){
                insert insertList;
            }
    }
    
    public PageReference navigateToStep5a(){
            save();
        return FunnelInstallationHelper.navigateToStep5a();
    
    }
    public PageReference navigateToStep6(){
        
        save();
        List<Sales_Rep_Quota__c> srpQuotaList =[Select id  from Sales_Rep_Quota__c Limit 5000];
        if(!(srpQuotaList != null && srpQuotaList.size()>0)){
            createHistoricQuotaRecord();
        }
        return FunnelInstallationHelper.navigateToStep6();
    
    }
    
    public PageReference saveAndExit(){
        save();
        return FunnelInstallationHelper.navigateToChecklist();
    }
    
}