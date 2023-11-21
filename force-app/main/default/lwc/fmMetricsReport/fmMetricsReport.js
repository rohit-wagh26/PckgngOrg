import { LightningElement,api } from 'lwc';
export default class FmMetricsReport extends LightningElement {
    @api filteredSalesRepProfiles;

    dataToPass = 'labelOne=Test';
    vfUrl="https://d1h000000na6fuas-dev-ed--funnelmetrics.vf.force.com/apex/FunnelAddEditSrp";
    vfUrl2 ="https://d1h000000na6fuas-dev-ed--funnelmetrics.vf.force.com/apex/FMCerificationTable?labelTwo=Regions";


    get vfPageUrl() {
        // Replace 'YourVisualforcePage' with the actual name of your Visualforce page
        return `/apex/FMCerificationTable`;
    }
}