import { LightningElement, api, wire } from 'lwc';
import getActionPlans from '@salesforce/apex/FMActionPlanController.getActionPlans';


export default class FmActionPlan extends LightningElement {
    @api filteredSalesRepProfiles;
    hasActionPlans = true;
    actionPlans;

    @wire(getActionPlans, {salesRepProfiles: '$filteredSalesRepProfiles'})
	wiredActionPlans({ data }) {
		if (!data) {
			return;
		}

		this.actionPlans = data;
	}
}