public class OpportunityHistoryTrackingBL {
    //Added by Today
  
        public static List<Client_custom_field_mapping__mdt> lstCustMd ;
        public static List<RecordType> recTypes;
        public static Map<String,List<String>>  recTypeFldMap;
        public static Map<String,String> recTypeNameIdMap;
        public static Map<String,String> recTypeIdNameMap ;
        public static Map<id,String> recTypeIdActionMap;
        public static Map<String,String> recTypeActionMap = new Map<String,String>();
    // Upto this
public static void trackChanges(List<Opportunity> OppList,Map<Id,Opportunity> OppOldMap){
        final List<Schema.FieldSetMember> trackedFields = SObjectType.Opportunity.FieldSets.History_Tracking.getFields();
   
        if(trackedFields.isEmpty())
            return;
        
        final List<OpportunityTrackingHistory__c> fieldChanges = new List<OpportunityTrackingHistory__c>();

        for (Opportunity newOpp : OppList) {
            final Opportunity oldOpp = null;
            if(OppOldMap != null)
            oldOpp = OppOldMap.get(newOpp.Id);
            
            for (Schema.FieldSetMember fsm : trackedFields) {
                
                
                String fieldName  = fsm.getFieldPath();
                String fieldLabel = fsm.getLabel();
                System.debug('ccccccccccccccccccc'+fieldName); 
                System.debug('ccccccccccccccccccc'+fieldLabel);   
                
                if (oldOpp != null  && newOpp.get(fieldName) == oldOpp.get(fieldName))
                    continue;
                String oldValue = null;
                System.debug('ssssssss'+oldValue);
                if(oldOpp != null){
                oldValue = String.valueOf(oldOpp.get(fieldName));
                }
                String newValue = String.valueOf(newOpp.get(fieldName));
                
                if (oldValue != null && oldValue.length()>255) 
                    oldValue = oldValue.substring(0,255);
                
                if (newValue != null && newValue.length()>255) 
                    newValue = newValue.substring(0,255); 
                
                final OpportunityTrackingHistory__c OppHistory = new OpportunityTrackingHistory__c();
                
                OppHistory.Name        = fieldLabel;
                OppHistory.apiName__c   = fieldName;
                OppHistory.Opportunity__c  = newOpp.Id;
                OppHistory.ChangedBy__c = UserInfo.getName();
                OppHistory.OldValue__c  = oldValue;
                OppHistory.NewValue__c  = newValue;  
                //commented because the age of opportunity should be calculated from created date and not from last modified date
                /*if(OppOldMap != null){
                OppHistory.Last_Date__c = OppOldMap.get(newOpp.Id).lastmodifieddate;
                }else{
                  OppHistory.Last_Date__c = newOpp.lastmodifieddate;  
                }*/
                OppHistory.Last_Date__c = newOpp.createddate;
                fieldChanges.add(OppHistory);
                
            }
        }
        
        if (!fieldChanges.isEmpty()) {
            insert fieldChanges;
        }  
    }
    // Added by Today
    public static void createRecordTypeMap(){
            
            lstCustMd = new List<Client_custom_field_mapping__mdt>();
            lstCustMd = [SELECT Action__c, Custom_field_name__c, Standard_field_name__c, Record_type_name__c FROM Client_custom_field_mapping__mdt WHERE Standard_field_name__c = 'Amount'];
            
            //recTypes = new List<RecordType>();
            //recTypes = [SELECT id, Name FROM RecordType WHERE SobjectType='Opportunity'];
            
            recTypeFldMap = new Map<String,List<String>>();                                                                
            
            recTypeNameIdMap = new Map<String,String>();
             
            recTypeIdNameMap = new Map<String,String>();
            
            recTypeIdActionMap = new Map<id,String>();
          
            List<String> rectypeNames = new List<String>();                
            
            for(Client_custom_field_mapping__mdt cm: lstCustMd){
                rectypeNames.add(cm.Record_type_name__c);
            }
            
            List<RecordType> lstRT = [SELECT id, name FROM RecordType WHERE name IN :rectypeNames];
            for(RecordType r:lstRT ){
                recTypeNameIdMap.put(r.name,r.id);
                recTypeIdNameMap.put(r.id,r.name);
            }
            
            if(lstCustMd != null && lstCustMd.size() > 0){
                for(Client_custom_field_mapping__mdt cm: lstCustMd){
                    if(recTypeFldMap.containsKey(cm.Record_type_name__c)){
                        recTypeFldMap.get(cm.Record_type_name__c).add(cm.Custom_field_name__c);
                    }
                    else{
                        List<String> flds = new List<String>();
                        flds.add(cm.Custom_field_name__c);
                        recTypeFldMap.put(cm.Record_type_name__c,flds);
                        recTypeIdActionMap.put(recTypeNameIdMap.get(cm.Record_type_name__c),cm.Action__c);
                        recTypeActionMap.put(cm.Record_type_name__c,cm.Action__c);
                
                    }
                    
                    
                }
            }    
            
        }
    // Upto this
    
}