public with Sharing class FunnelCustomMetricHelper{
    
    public static Date triggerDate;
    
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
          
          system.debug('ss--'+String.escapeSingleQuotes(theQuery) ); 
          //String theQueryResult = string.escapeSingleQuotes(theQuery);  //escapes the string
          //system.debug('ss-excape-'+theQueryResult ); 
          return database.query(theQuery );
     }
     
     public static String createtimeString(String durationfield,String durationperiod ,Boolean datetimeform){
        
        String timeperiod = '';
        DateTime Fyear =  FunnelTriggerBatchHelper.getFiscalYearDate('Current_Year');
        String Fisyear =   Fyear.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');        
        
        if(durationperiod == 'Current Fiscal year'){ //Current year
           
            dateTime dtf = triggerDate ;
            dtf =dtf.adddays(1);
            
            system.debug(' the day is '+dtf.dayGMT());
            
            ///if(dtf.dayGMT() != 1 &&  FunnelTriggerBatchHelper.isLastDay(triggerDate))
            if(dtf.dayGMT() != 1){
                dtf = dtf.adddays(1);
            }
            system.debug(' final day '+dtf);
            
            String endmnf = dtf.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
            
            if( !datetimeform){
                timeperiod = durationfield +' >= '+ Fisyear +' AND ' + durationfield +' <= '+ endmnf ;
            
            }else if(datetimeform){
                timeperiod = durationfield +' >= '+ Fisyear.substring(0, 10) +' AND ' + durationfield +' <= '+ endmnf.substring(0, 10) ;
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
            
            system.debug(' the day is '+endDateMonth.dayGMT());

            if(endDateMonth.dayGMT() != 1)
                endDateMonth = endDateMonth.adddays(1);

            startDateMonth = startDateMonth.addSeconds(offset/1000);
            endDateMonth = endDateMonth.addSeconds(offset/1000);
            
            
            system.debug(' final day '+endDateMonth);
               
            startmn = startDateMonth.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
            endmn = endDateMonth.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
            
            if (!datetimeform){
                timeperiod = durationfield +' >= '+ startmn + ' AND '+ durationfield + ' <=  '+endmn;
            
            }else if(datetimeform){
                timeperiod = durationfield +' >= '+ startmn.substring(0, 10) + ' AND '+ durationfield + ' <=  '+endmn.substring(0, 10);
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
                timeperiod = durationfield +' >= '+ startDateString + ' AND '+ durationfield + ' <=  '+endDateString;
            
            }else if(datetimeform){
                timeperiod = durationfield +' >= '+ startDateString.substring(0, 10) + ' AND '+ durationfield + ' <=  '+endDateString.substring(0, 10);
            }
        }else if(durationperiod == '12 Month Rolling'){
                DateTime endDate12Month =  triggerDate.addDays(1);
                
                system.debug(' the day is '+endDate12Month.dayGMT());
                
                if(endDate12Month.dayGMT() != 1)
                    endDate12Month = endDate12Month.adddays(1);
                
                system.debug(' final day '+endDate12Month);

                DateTime triggerdatetime = triggerDate;
                DateTime startDate12Month =   datetime.newInstance(triggerdatetime.yearGmt()-1 , triggerdatetime.monthGmt()+1, 1);
                        // startDate12Month =   startDate12Month.addSeconds(offset/1000);      
            
                String startDate12Months =  startDate12Month.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\'');
                String endDate12Months =  endDate12Month.formatgmt('yyyy-MM-dd\'T\'00:00:00\'Z\''); 
                
                
                if (!datetimeform){
                    timeperiod = durationfield +' >= '+ startDate12Months + ' AND '+ durationfield + ' <=  '+endDate12Months;
            
                }else if(datetimeform){
                    timeperiod = durationfield +' >= '+ startDate12Months.substring(0, 10) + ' AND '+ durationfield + ' <=  '+endDate12Months.substring(0, 10);
                }
            
        }
         
        return timeperiod;
        
     }

}