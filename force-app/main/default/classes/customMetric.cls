public class customMetric {
 /*
 public static  List<Certification_Rating__c> certification_rating{get;set;} 
 public static  Map<string,List<string>> objectnfield{get;set;}
 public static  List<sObject> cm{get;set;}
 public static  Map<string,string> Linktosp{get;set;}
 public static Map<id,sObject> storeMetricVal{get;set;}
 public static Map<string,string> storerelnobj{get;set;}
    
     public customMetric(){
     }
     public static void updatecustomMetric(){
        system.debug('inside--');
        
         storeMetricVal = new Map<id,sObject>();
         objectnfield = new Map<string,List<string>>();
         Linktosp = new Map<string,string>();
         storerelnobj = new  Map<string,string>();
        
         certification_rating = [select id,name,Custom_Object_Name__c,Field_Name__c,Custom_Field_Name__c,Custom_Related_by__c From Certification_Rating__c where Custom_Object_Name__c != null And Custom_Field_Name__c != null AND Custom_Related_by__c != null AND Custom_Field_Name__c!= null ];
        
         for(Certification_Rating__c c : certification_rating ){
             
             Linktosp.put(c.Field_Name__c,c.Custom_Field_Name__c);
             
             if(c.Custom_Object_Name__c != null && c.Custom_Object_Name__c != '' && !objectnfield.keySet().contains(c.Custom_Object_Name__c)){
            
                List<String> fields = new List<String>(); 
               
                fields.add(c.Custom_Related_by__c );           //Need to be first value of set
                fields.add(c.Custom_Field_Name__c);    
                
                
                objectnfield.put(c.Custom_Object_Name__c,fields);
            }    
            else if(c.Custom_Object_Name__c != null && c.Custom_Object_Name__c != '' && objectnfield.keySet().contains(c.Custom_Object_Name__c)){
                
                objectnfield.get(c.Custom_Object_Name__c).add(c.Custom_Field_Name__c);
            }
            
         }
         
         List<Sales_Rep_Profile__c> srprecord =[Select id,User_Record_Name__c,Custom_Metric_1__c From Sales_Rep_Profile__c limit 100];
         
         for(string key : objectnfield.keySet()){
             
              List<String> fields = objectnfield.get(key);
              
              
              string keyval =fields[0];
              system.debug('keyval --'+keyval );
              
              cm  = new List<sObject>();
              cm = queryObjects(key,fields);
              
             // storeMetricVal.put(String.valueOf(cm.get(keyval)),cm);
             for(sObject s :cm  ){
                  storeMetricVal.put(String.valueOf(s.get(keyval)),s);
                  storerelnobj.put(String.valueOf(s.get(keyval)),key);
              }
              
             for(Sales_Rep_Profile__c srp: srprecord ){
             
                
                if(Linktosp.containsKey('Custom_Metric_1__c') && storeMetricVal.containsKey(srp.User_Record_Name__c) && objectnfield.get(storerelnobj.get(srp.User_Record_Name__c)).contains(Linktosp.get('Custom_Metric_1__c')) ){
                           // system.debug('storeMetricValus----'+storeMetricVal.get(srp.User_Record_Name__c));
                            srp.Custom_Metric_1__c = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get(Linktosp.get('Custom_Metric_1__c'));
                            system.debug('srp-----'+srp);
                }
                 
                     
             }
         }
         
          update srprecord ;   
     }
    
     public static List<sObject> queryObjects(String theObject, List<String> theFields) {
          String theQuery = 'SELECT ' + string.join(theFields, ',');
          theQuery += ' FROM ' + theObject;
           
          String theQueryResult = string.escapeSingleQuotes(theQuery);  //escapes the string
          return database.query(theQueryResult);
     }
     
 */
}