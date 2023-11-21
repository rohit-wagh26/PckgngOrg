global class FunnelPostInstallScript implements System.InstallHandler{
    
    global void onInstall(System.InstallContext context) {
        if(context.previousVersion() == null) {
            List<Installation_status__mdt > mdtLst = [SELECT MasterLabel, DeveloperName, Completed__c, Updated_date_time__c, Updated_by__c FROM Installation_status__mdt];
            
            
            List<string> fList = new List<String>();
            List<string> lList = new List<String>();
            List<Map<String, Object>> maptestList= new List<Map<String, Object>>();
            
            if(mdtLst != null && mdtLst.size()>0){
                for(Installation_status__mdt m : mdtLst ){
                    m.Updated_by__c = UserInfo.getName();
                    m.Updated_date_time__c = System.now();
                    Map<String, Object> maptest = new Map<String, Object>();
                    String fN = 'FunnelMetrics__Installation_status.FunnelMetrics__'+m.DeveloperName;
                    fList.add(fN);
                    lList.add(m.MasterLabel);
                    if(m.Completed__c){
                        maptest.put('FunnelMetrics__Updated_by__c',UserInfo.getName());
                        maptest.put('FunnelMetrics__Updated_date_time__c',System.now());
                        maptest.put('FunnelMetrics__Completed__c',false);
                    }
                    maptestList.add(maptest);
                }
            }
            if (!test.isRunningTest()){
                FMCreateUpdateMetadataUtils.createUpdateMetadataList(fList,lList,maptestList);
            }
        }
    }
}