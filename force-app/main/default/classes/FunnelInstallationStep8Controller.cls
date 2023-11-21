public with sharing class FunnelInstallationStep8Controller {

    public Boolean nextpoller{get;set;}
    public Boolean displayNext{get;set;}
    public Boolean hybridPresent{get;set;}
    public Boolean quotaEmpty{get;set;}
    
    public List<Sales_Rep_Quota__c>srpQuotaList{get;set;}
    
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    
    public FunnelInstallationStep8Controller(){
        srpQuotaList =[Select id,Sales_Rep_Profile__r.name,Sales_Rep_Profile__r.User_Record_Name__r.Username,Year__c,Annual_Quota_Amount__c from Sales_Rep_Quota__c order by  Year__c asc, Sales_Rep_Profile__r.name asc Limit 5000];
        
        nextpoller = true;
        displayNext = false;
        hybridPresent = false;
        quotaEmpty = true;
        
        List<Sales_Rep_Profile__c> srpHybrid = [Select id from Sales_Rep_Profile__c where Profile_Type__c = 'Hybrid'];
        if(srpHybrid != null && srpHybrid.size()>0){
            hybridPresent = true;
        }
        
         List<Sales_Rep_Quota__c>srpQuota = [Select id from  Sales_Rep_Quota__c where Annual_Quota_Amount__c > 0 ];
         if(srpQuota != null && srpQuota.size()>0){
             quotaEmpty = false;
             //quotaEmpty = true;
         }
        chechNext();
    }
    
    public void chechNext(){
    
       New_Data_load_setting__mdt[] mtDt = [SELECT Bypass__c FROM New_Data_load_setting__mdt LIMIT 1]; 
       if( mtDt != null && mtDt.size() > 0 &&  !mtDt[0].Bypass__c ){
           nextpoller = false;
           displayNext = true;
       
       }else{
           nextpoller = true;
       }
    
    }
    
    public PageReference uploadSrp(){
        try{
            
            
            nameFile= contentFile.toString();
            
            //String bodySR = blobToString( contentFile,'ISO-8859-1');
            System.debug('nameFile:::'+nameFile);
            String[] filelines = new String[]{};
            filelines = nameFile.split('\r\n'); 
            System.debug('filelines :::'+filelines );
            List<Sales_Rep_Quota__c> SrList = new List<Sales_Rep_Quota__c>();
            for(Integer i=1;i<filelines.size();i=i+1){
                 
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
                    Sales_Rep_Quota__c sr = new Sales_Rep_Quota__c();
                    
                    sr.id = colList[0];
                    if(colList[4] != null && colList[4] != ''){
                        sr.Annual_Quota_Amount__c =  Decimal.valueof(colList[4]);
                    }
                    
                   
                    SrList.add(sr);
                }
            }
            
            if(SrList!= null && SrList.size()>0){
                 Database.update(SrList, true);
            }
            
            FunnelInstallationHelper.saveStep('8');
            
             PageReference redirect;
        redirect = new PageReference('/apex/FunnelInstallationStep8'); 
 
        redirect.setRedirect(true);     
        return redirect;
        }catch(Exception ex){
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
             ApexPages.addMessage(myMsg);
        return null;
        }
    }
    
    public PageReference saveAndExit(){
        //save();
        FunnelInstallationHelper.saveStep('8');
        return FunnelInstallationHelper.navigateToChecklist();
    }
     public PageReference navigateToStep9(){
         
        return FunnelInstallationHelper.navigateToStep9();
     
    }
}