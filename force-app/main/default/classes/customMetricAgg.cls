public class customMetricAgg {
 /*
 public static  List<Certification_Rating__c> certification_rating{get;set;}  //Fetch the custom ratings From certification rating
 public static  Map<string,List<string>> objectnfield{get;set;}               //Store the map of object and field to qurey the object
 public static  List<AggregateResult> cm{get;set;}                                    //Store the value of qurey
 public static Map<id,AggregateResult> storeMetricVal{get;set;}                       //Store the map of relatedby id and the object
 public static Map<string,string> storerelnobj{get;set;}                      //Storce the map of relateby it and object name
 
 public static string timeperiod;
 public static date  triggerDate;
    
     public customMetricAgg (){
     }
     public static void updatecustomMetricAgg(){
        
         storeMetricVal = new Map<id,AggregateResult>();
         objectnfield = new Map<string,List<string>>();
         storerelnobj = new  Map<string,string>();
        
        //Fetch the sales rep profile for update
         List<Sales_Rep_Profile__c> srprecord =[Select id,User_Record_Name__c,FMCustom_Metric_1__c,FMCustom_Metric_2__c ,FMCustom_Metric_3__c ,FMCustom_Metric_4__c ,FMCustom_Metric_5__c ,FMCustom_Metric_6__c ,FMCustom_Metric_7__c ,FMCustom_Metric_8__c ,FMCustom_Metric_9__c ,FMCustom_Metric_10__c,FMCustom_Metric_11__c,FMCustom_Metric_12__c,FMCustom_Metric_13__c,FMCustom_Metric_14__c,FMCustom_Metric_15__c,FMCustom_Metric_16__c,FMCustom_Metric_17__c,FMCustom_Metric_18__c,FMCustom_Metric_19__c,FMCustom_Metric_20__c,FMCustom_Metric_21__c,FMCustom_Metric_22__c,FMCustom_Metric_23__c,FMCustom_Metric_24__c,FMCustom_Metric_25__c,FMCustom_Metric_26__c,FMCustom_Metric_27__c,FMCustom_Metric_28__c From Sales_Rep_Profile__c limit 100];
         
         //Fetch the Custom Rating
         certification_rating = [SELECT Id, Name, SRP_Field_Name__c, Field_Name__c, Custom_Object_Name__c, Custom_Field_Name__c, Custom_Related_by__c,Agg__c,Where__c,Date__c,Duration_Field__c,Duration_Period__c FROM Certification_Rating__c where Custom_Object_Name__c != null And Custom_Field_Name__c != null AND Custom_Related_by__c != null AND Custom_Field_Name__c!= null AND Deactivated__c = false  ];
        
         for(Certification_Rating__c c : certification_rating ){
             
             if(c.Duration_Field__c != null && c.Duration_Period__c != 'No time period'){
                 timeperiod = createtimeString(c.Duration_Field__c,c.Duration_Period__c,c.Date__c);
             }else{
                 timeperiod = '';
             }
             
             string f;
             if(c.Agg__c != null){
                 f = c.Custom_Related_by__c +' gb ,'+ c.Agg__c+'('+c.Custom_Field_Name__c+') '+ c.SRP_Field_Name__c;
             }else{
                 f = c.Custom_Related_by__c +' gb ,'+ 'SUM'+'('+c.Custom_Field_Name__c+') '+ c.SRP_Field_Name__c;
             }
             
              
            
            cm  = new List<AggregateResult>();
            cm = queryObjects(c.Custom_Object_Name__c,f,c.Where__c,c.Custom_Related_by__c,timeperiod);
            
             for(AggregateResult s :cm  ){
                  storeMetricVal.put((Id)s.get('gb'),s);
              }
              
              for(Sales_Rep_Profile__c srp: srprecord ){
             
                
                if(c.SRP_Field_Name__c == 'FMCustom_Metric_1__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                           // system.debug('storeMetricValus----'+storeMetricVal.get(srp.User_Record_Name__c));
                            srp.FMCustom_Metric_1__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_1__c');
                            system.debug('srp-----'+srp);
                }
                if(c.SRP_Field_Name__c == 'FMCustom_Metric_2__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                           // system.debug('storeMetricValus----'+storeMetricVal.get(srp.User_Record_Name__c));
                            srp.FMCustom_Metric_2__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_2__c');
                          //  system.debug('srp-----'+srp);
                }
                if(c.SRP_Field_Name__c == 'FMCustom_Metric_3__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                           // system.debug('storeMetricValus----'+storeMetricVal.get(srp.User_Record_Name__c));
                            srp.FMCustom_Metric_3__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_3__c');
                          //  system.debug('srp-----'+srp);
                }
                if(c.SRP_Field_Name__c == 'FMCustom_Metric_4__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                           // system.debug('storeMetricValus----'+storeMetricVal.get(srp.User_Record_Name__c));
                            srp.FMCustom_Metric_4__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_4__c');
                          //  system.debug('srp-----'+srp);
                }
                if(c.SRP_Field_Name__c == 'FMCustom_Metric_5__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                           // system.debug('storeMetricValus----'+storeMetricVal.get(srp.User_Record_Name__c));
                            srp.FMCustom_Metric_5__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_5__c');
                          //  system.debug('srp-----'+srp);
                }
                if(c.SRP_Field_Name__c == 'FMCustom_Metric_6__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                           // system.debug('storeMetricValus----'+storeMetricVal.get(srp.User_Record_Name__c));
                            srp.FMCustom_Metric_6__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_6__c');
                          //  system.debug('srp-----'+srp);
                }
                if(c.SRP_Field_Name__c == 'FMCustom_Metric_7__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                           // system.debug('storeMetricValus----'+storeMetricVal.get(srp.User_Record_Name__c));
                            srp.FMCustom_Metric_7__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_7__c');
                          //  system.debug('srp-----'+srp);
                }
                if(c.SRP_Field_Name__c == 'FMCustom_Metric_8__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                           // system.debug('storeMetricValus----'+storeMetricVal.get(srp.User_Record_Name__c));
                            srp.FMCustom_Metric_8__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_8__c');
                          //  system.debug('srp-----'+srp);
                }
                if(c.SRP_Field_Name__c == 'FMCustom_Metric_9__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                           // system.debug('storeMetricValus----'+storeMetricVal.get(srp.User_Record_Name__c));
                            srp.FMCustom_Metric_9__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_9__c');
                          //  system.debug('srp-----'+srp);
                }
                if(c.SRP_Field_Name__c == 'FMCustom_Metric_10__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                           // system.debug('storeMetricValus----'+storeMetricVal.get(srp.User_Record_Name__c));
                            srp.FMCustom_Metric_10__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_10__c');
                           // system.debug('srp-----'+srp);
                }
                if(c.SRP_Field_Name__c == 'FMCustom_Metric_11__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_11__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_11__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_12__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_12__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_12__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_13__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_13__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_13__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_14__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_14__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_14__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_15__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_15__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_15__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_16__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_16__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_16__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_17__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_17__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_17__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_18__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_18__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_18__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_19__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_19__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_19__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_20__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_20__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_20__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_21__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_21__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_21__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_22__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_22__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_22__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_23__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_23__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_23__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_24__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_24__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_24__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_25__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_25__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_25__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_26__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_26__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_26__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_27__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_27__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_27__c');
               }
               if(c.SRP_Field_Name__c == 'FMCustom_Metric_28__c' && storeMetricVal.containsKey(srp.User_Record_Name__c) ){
                    srp.FMCustom_Metric_28__c  = (Decimal)storeMetricVal.get(srp.User_Record_Name__c).get('FMCustom_Metric_28__c');
               }
                
                     
             }
         }
         
          
          update srprecord ;   
     }
    
     public static List<AggregateResult> queryObjects(String theObject, String theFields, String theWhere , String theGroupby , string theTm) {
          String theQuery = 'SELECT ' + theFields;
          theQuery += ' FROM ' + theObject;
          if(theWhere != null && theWhere != ''){
              theQuery += ' Where ' +theWhere;
          }
          
          if(theWhere != null && theWhere != '' && theTm != null && theTm != ''){
             theQuery += ' AND ' +  theTm;
          }else if( theTm != null && theTm != ''){
             theQuery += ' Where ' + theTm; 
          }
          
          theQuery += ' Group by ' + theGroupby;
          
          system.debug('ss--'+theQuery ); 
          //String theQueryResult = string.escapeSingleQuotes(theQuery);  //escapes the string
          //system.debug('ss-excape-'+theQueryResult ); 
          return database.query(theQuery );
     }
     
     public static String createtimeString(String durationfield,String durationperiod ,Boolean datetimeform){
        
        timeperiod = '';
        DateTime Fyear =  FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        String Fisyear =   Fyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        
        
        if(durationperiod == 'Current Fiscal year'){ //Current year
           
            dateTime dtf = triggerDate ;
             dtf =dtf.adddays(1);
            String endmnf = dtf.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
            
            if( !datetimeform){
                timeperiod = durationfield +' >= '+ Fisyear +' AND ' + durationfield +' < '+ endmnf ;
            
            }else if(datetimeform){
                timeperiod = durationfield +' >= '+ Fisyear.substring(0, 10) +' AND ' + durationfield +' < '+ endmnf.substring(0, 10) ;
            }
        }else if(durationperiod == 'Current Month' ){  // Current month
            
            string startmn;
            string endmn;
            
            dateTime dt = triggerDate ;
            Integer yrtm1 = dt.yearGmt();
            Integer mntm1 = dt.monthGmt();
            
            Datetime startDateMonth =  Datetime.newInstance(yrtm1 ,mntm1 ,1);
            Datetime endDateMonth =  Datetime.newInstance(yrtm1,mntm1,Date.daysInMonth(yrtm1,mntm1));
            
            Integer offset = UserInfo.getTimezone().getOffset(startDateMonth);
            
            endDateMonth = endDateMonth.addDays(1);
            startDateMonth = startDateMonth.addSeconds(offset/1000);
            endDateMonth = endDateMonth.addSeconds(offset/1000);
            
            startmn = startDateMonth.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
            endmn = endDateMonth.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
            
            if (!datetimeform){
                timeperiod = durationfield +' >= '+ startmn + ' AND '+ durationfield + ' <  '+endmn;
            
            }else if(datetimeform){
                timeperiod = durationfield +' >= '+ startmn.substring(0, 10) + ' AND '+ durationfield + ' <  '+endmn.substring(0, 10);
            }
        }else if(durationperiod == 'Current Quarter'){
            
            DateTime Q0 =  Fyear ;
            DateTime Q1 =  Fyear.addMonths(3);
            DateTime Q2 =  Q1.addMonths(3);
            DateTime Q3 =  Q2.addMonths(3);
            DateTime Q4 =  Q3.addMonths(3);
            
            DateTime startDate;
            DateTime endDate;
            
            String startDateString;
            String endDateString;
            
           // DateTime triggerDateTime = triggerDate;
            
             if( (Q0 <=  triggerDate) && (triggerDate< Q1)){
        
                startDate=  Q0;
                endDate =  Q1;
                          
            }else if((Q1 <=  triggerDate) && (triggerDate< Q2)){
            
                startDate=  Q1;
                endDate =  Q2;
                
            }else if((Q2 <=  triggerDate) && (triggerDate< Q3)){
            
                startDate=  Q2;
                endDate =  Q3;
                
            }else if((Q3 <=  triggerDate) && (triggerDate< Q4)){
            
                startDate=  Q3;
                endDate =  Q4;
                
            }  
            
            startDateString  =  startDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
            endDateString  =  endDate.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
            
            if (!datetimeform){
                timeperiod = durationfield +' >= '+ startDateString + ' AND '+ durationfield + ' <  '+endDateString;
            
            }else if(datetimeform){
                timeperiod = durationfield +' >= '+ startDateString.substring(0, 10) + ' AND '+ durationfield + ' <  '+endDateString.substring(0, 10);
            }
        }else if(durationperiod == '12 Month Rolling'){
                DateTime endDate12Month =  triggerDate.addDays(1);
                DateTime triggerdatetime = triggerDate;
                DateTime startDate12Month =   datetime.newInstance(triggerdatetime.yearGmt()-1 , triggerdatetime.monthGmt()+1, 1);
                        // startDate12Month =   startDate12Month.addSeconds(offset/1000);      
            
                String startDate12Months =  startDate12Month.formatgmt('yyyy-MM-dd\'T\'23:59:59\'Z\'');
                String endDate12Months =  endDate12Month.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
                
                
                if (!datetimeform){
                    timeperiod = durationfield +' > '+ startDate12Months + ' AND '+ durationfield + ' <  '+endDate12Months;
            
                }else if(datetimeform){
                    timeperiod = durationfield +' > '+ startDate12Months.substring(0, 10) + ' AND '+ durationfield + ' <  '+endDate12Months.substring(0, 10);
                }
            
        }
        
        return timeperiod;
        
     }*/
}