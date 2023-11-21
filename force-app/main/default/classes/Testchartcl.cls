public class Testchartcl {
public Boolean RoleOverlay{get;set;}
public String perfPeriodValues{get;set;}
public String selectedType{get;set;}
public List<SelectOption> lstMetricOrSkill {get; set;}
    public List<SelectOption> performancePeriod {get; set;}
    public string sMetricOrSkill {get; set;}
    public Testchartcl() {
        selectedType = 'Metrix';
        perfPeriodValues = 'YTD';
        sMetricOrSkill = 'Quota Performance';
        PopulateMetricOrSkill();
    }
    public void PopulateMetricOrSkill() {
        lstMetricOrSkill = new List<SelectOption>();
        performancePeriod = new List<SelectOption>();
        if(selectedType == 'Metrix') {
          lstMetricOrSkill.add(new SelectOption('Numbers Of Meetings','Numbers Of Meetings'));
          lstMetricOrSkill.add(new SelectOption('Lead Added','Lead Added'));
          lstMetricOrSkill.add(new SelectOption('Opportunities added to Qualified Funnel','Opportunities added to Qualified Funnel'));
            lstMetricOrSkill.add(new SelectOption('Average Win Size($)','Average Win Size($)'));
            lstMetricOrSkill.add(new SelectOption('Close Rate Based on $','Close Rate Based on $'));
            lstMetricOrSkill.add(new SelectOption('Close Rate Based on Opportunity','Close Rate Based on Opportunity'));
            lstMetricOrSkill.add(new SelectOption('Number of Wins','Number of Wins'));
          lstMetricOrSkill.add(new SelectOption('Quota Performance','Quota Performance'));
          
            performancePeriod.add(new SelectOption('Monthly','Monthly'));
          performancePeriod.add(new SelectOption('Quarterly','Quarterly'));
          performancePeriod.add(new SelectOption('YTD','YTD'));
          performancePeriod.add(new SelectOption('Rolling 12 Month','Rolling 12 Month'));
        }
        else {
          lstMetricOrSkill.add(new SelectOption('Discovery','Discovery'));
          lstMetricOrSkill.add(new SelectOption('Presenting','Presenting'));
          lstMetricOrSkill.add(new SelectOption('Negotiation','Negotiation'));
            lstMetricOrSkill.add(new SelectOption('Salesforce CRM Updating','Salesforce CRM Updating'));
          lstMetricOrSkill.add(new SelectOption('Need Analysis','Need Analysis'));
          lstMetricOrSkill.add(new SelectOption('Communication Skills','Communication Skills'));
            lstMetricOrSkill.add(new SelectOption('Team Player','Team Player'));
          lstMetricOrSkill.add(new SelectOption('Qualification','Qualification'));
          lstMetricOrSkill.add(new SelectOption('RFP/RFI Requests','RFP/RFI Requests'));
            lstMetricOrSkill.add(new SelectOption('Competitive Positioning','Competitive Positioning'));
          lstMetricOrSkill.add(new SelectOption('Working Realtionships','Working Realtionships'));
          lstMetricOrSkill.add(new SelectOption('Forcasting','Forcasting'));
            lstMetricOrSkill.add(new SelectOption('Sales Support Resources','Sales Support Resources'));
          lstMetricOrSkill.add(new SelectOption('Accountability','Accountability'));
          lstMetricOrSkill.add(new SelectOption('Expense Reports','Expense Reports'));
            lstMetricOrSkill.add(new SelectOption('Trusted Advisor','Trusted Advisor'));
          lstMetricOrSkill.add(new SelectOption('Professionalism','Professionalism'));
          lstMetricOrSkill.add(new SelectOption('Product Knowledge','Product Knowledge'));
            lstMetricOrSkill.add(new SelectOption('Territory/Account Plan','Territory/Account Plan'));
          lstMetricOrSkill.add(new SelectOption('Timely Response','Timely Response'));

          performancePeriod.add(new SelectOption('Monthly','Monthly'));
          performancePeriod.add(new SelectOption('Quarterly','Quarterly'));
          performancePeriod.add(new SelectOption('Bi-Annual','Bi-Annual'));
          performancePeriod.add(new SelectOption('Annual','Annual'));
        }
        //return null;
    }
}