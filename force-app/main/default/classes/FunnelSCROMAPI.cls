/*--++---------------------+++----------------++++-------------------
Author:    Carine Priya D Mello                     
Date:      3rd, Feb 2020
Desc:      
Copyright: Funnel Metrics, LLC
++-------------------+++++-----------++++--------------------------*/
public class FunnelSCROMAPI{

    public FunnelSCROMAPI(FunnelHistController controller) {

    }

 /*   
    public PageReference redirectToCourseLink(){
         
         JSONGenerator gen = JSON.createGenerator(true);
         clsJSON2 cjObj = new clsJSON2();
         gen.writeStartObject();
             cjObj.wsf(gen,'redirectOnExitUrl','');
             cjObj.wbf(gen,'tracking',true);
         gen.writeEndObject();
         
         String jbody = gen.getAsString(); 
         String jsonData = httpHandler('POST', 'YCMJMVKBTD', 'CnWNt3AnZMz5ccHSml6mXcM7Cqpg1h8zytA72bBr', 'registrations/test1234/launchLink', jbody,'' );
         system.debug(' jsonData '+jsonData);
         
         Map<String, Object> mapStats= (Map<String, Object>)JSON.deserializeUntyped(jsonData);
         system.debug(mapStats);

         PageReference p = new PageReference((String)mapStats.get('launchLink'));
         p.setRedirect(true);
         return p;
         
    }
    
    // Checks for the null values in the list and replaces it with just a key.
  public class clsJSON2 {
          
         // Writes Number Fields and replaces null values
         public void wnf(JSONGenerator gen, String fieldName, Decimal fieldValue) {
                if(fieldValue == null) {
                    gen.writeNullField(fieldName); // Could be replaced with writeStringField(...,'') if you prefer an empty string over a null field
                } else {
                    gen.writeNumberField(fieldName, fieldValue);
                }
            }
        
        //Writes String Fields and replaces null values
        public void wsf(JSONGenerator gen, String fieldName, String fieldValue) {
            if(fieldValue == null) {
                gen.writeNullField(fieldName); // Could be replaced with writeStringField(...,'') if you prefer an empty string over a null field
            } else {
                gen.writeStringField(fieldName, fieldValue);
            }
        }
        
        //Writes Date Fields and replaces null values
        public void wdf(JSONGenerator gen, String fieldName, Date fieldValue) {
            if(fieldValue == null) {
                gen.writeNullField(fieldName); // Could be replaced with writeStringField(...,'') if you prefer an empty string over a null field
            } else {
                gen.writeDateField(fieldName, fieldValue);
            }
        }
        
        //Writes Boolean Fields and replaces null values
        public void wbf(JSONGenerator gen, String fieldName, Boolean fieldValue) {
            if(fieldValue == null) {
                gen.writeNullField(fieldName); // Could be replaced with writeStringField(...,'') if you prefer an empty string over a null field
            } else {
                gen.writeBooleanField(fieldName, fieldValue);
            }
        }        
        
   }
   
    public String httpHandler(string method, string username, string password, string endpoint, string jbody, string atoken){
   
         Http http = new Http();
         HttpRequest request = new HttpRequest();
         
         request.setMethod(method);
        
         request.setEndpoint('https://cloud.scorm.com/api/v2/'+endpoint);
                  
         // Set HEADER based on the token vs other urls
         if(atoken == ''){
             
             String strBase64Encode  = EncodingUtil.base64Encode(Blob.valueof(username+':'+password));
             request.setHeader('Content-Type', 'application/json');
             request.setHeader('Authorization', 'Basic '+ strBase64Encode);
         }
          else{
              
             
       //       request.setHeader('Content-Type', 'application/json;charset=UTF-8');
       //       request.setHeader('Authorization', 'bearer '+token); 
              
              request.setHeader('Content-Type', 'application/json');
              request.setHeader('Authorization', atoken);
          }
         
         if(jbody != ''){
           request.setBody(jbody);
         }
                 
         HttpResponse response = http.send(request);
         
         system.debug(' response '+response);
                           
         String jsonData = response.getBody();
         
         Return jsonData;
     }
    */ 
}