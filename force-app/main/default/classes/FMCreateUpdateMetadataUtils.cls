public class FMCreateUpdateMetadataUtils implements Metadata.DeployCallback {
    
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            System.debug(' success : '+ result);
        } else {
            System.debug(' fail : '+ result);
        }
    }
    
    public static void createUpdateMetadata(String fullName, String label, Map<String, Object> fieldWithValuesMap){
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        customMetadata.fullName = fullName;
        customMetadata.label = label;
        
        for(String key : fieldWithValuesMap.keySet()){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = key;
            customField.value = fieldWithValuesMap.get(key); 
            customMetadata.values.add(customField);
        }
        
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(customMetadata);
        FMCreateUpdateMetadataUtils callback = new FMCreateUpdateMetadataUtils();
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
    }
    public static void createUpdateMetadataList(List<String> fullName, List<String> label, List<Map<String, Object>> fieldWithValuesMap){
        
         Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        
        for(Integer i= 0 ; i < fullName.size(); i++ ){
            Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
            customMetadata.fullName = fullName[i];
            customMetadata.label = label[i];
            
            for(String key : fieldWithValuesMap[i].keySet()){
                Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
                customField.field = key;
                customField.value = fieldWithValuesMap[i].get(key); 
                customMetadata.values.add(customField);
            }
            mdContainer.addMetadata(customMetadata);
        }
        
        FMCreateUpdateMetadataUtils callback = new FMCreateUpdateMetadataUtils();
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
    }
}