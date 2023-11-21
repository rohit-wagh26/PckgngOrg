public with sharing class FunnelInstallationIntroController {

    public void FunnelInstallationIntroController (){
        
    }
    
    public void insertEG(){
        StaticResource FMEvaluationGuidlines  = [SELECT Id, Body FROM StaticResource WHERE Name = 'FMEvaluationGuidlines' LIMIT 1];
        String bodyEG = FMEvaluationGuidlines.Body.toString();
        System.debug('bodyEG :::'+bodyEG );
        String[] filelines = new String[]{};
        filelines = bodyEG.split('\r\n'); 
        System.debug('filelines :::'+filelines );
        List<EvaluationGuidelines__c> EGList = new List<EvaluationGuidelines__c>();
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
            
            for(String column : s.split(',')){
              column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
              colList.add(column);
              System.debug('column::'+column);
            }
            
            if(colList != null ){
                
                EGList.add(new EvaluationGuidelines__c(Description__c=colList[0], order__c=Decimal.valueof(colList[1]), Name=colList[2]));
            }
        }
        
        if(EGList!= null && EGList.size()>0){
            insert EGList;
        }
    
        
    }
    
    public PageReference navigateToStep1() {
        FunnelInstallationHelper.saveStep('0');
        List<EvaluationGuidelines__c> EGList = [Select id from EvaluationGuidelines__c LIMIT 5000];
        if(EGList == null || !(EGList != null && EGList.size() > 0)){
            insertEG();
        }
        
        return FunnelInstallationHelper.navigateToStep1();
    }
    
    public PageReference naveToSavedPage() {
        if(apexpages.currentpage().getparameters().get('Wiz') == 'true'){
            return FunnelInstallationHelper.naveToSavedPage();
        }else{
            return null;
        }
    }

}