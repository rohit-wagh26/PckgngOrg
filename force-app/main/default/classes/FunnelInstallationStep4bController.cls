public with sharing class FunnelInstallationStep4bController {

    public string noratingsAssigned{get;set;}
    
    public void checkratings(){
        Set<String> rolesSet = new Set<String>();

        List<Certification_Rating__c> crList = [Select Roles_enabled__c from Certification_Rating__c where Roles_enabled__c !=  null];
        
        for(Certification_Rating__c c : crList){
            
            List<String> rolesList = c.Roles_enabled__c.split(';');
            for(String r:rolesList){
                rolesSet.add(r);
            }
        }
        
        Map<String,String> roleMap = new Map<String,String>();
        Schema.DescribeFieldResult statusFieldDescription = Certification_Rating__c.Roles_enabled__c.getDescribe();
                   
        for(Schema.Picklistentry picklistEntry : statusFieldDescription.getPicklistValues()){
            RoleMap.put(pickListEntry.getValue(),pickListEntry.getLabel());
        }
         
        for(String s : rolesSet){
            if(roleMap.containsKey(s)){
                roleMap.remove(s);
            }
        }
        
        noratingsAssigned = '';
        for(String s :roleMap.keyset()){
            if(noratingsAssigned == ''){
                noratingsAssigned = ' '+s;
            }else{
                noratingsAssigned += '; '+s;
            } 
        }
        system.debug('noratingsAssigned '+noratingsAssigned );
         
        
    }
    public PageReference navigateToStep4a(){
        
        
        return FunnelInstallationHelper.navigateToStep4a();
    
    }
    
    public PageReference navigateToStep5(){
        //save();
        
        return FunnelInstallationHelper.navigateToStep5a();
     
    }
    
    public PageReference saveAndExit(){
        //save();
        return FunnelInstallationHelper.navigateToChecklist();
    }

}