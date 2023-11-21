import { LightningElement, api} from 'lwc';

const actions = [
    { label: 'View', name: 'view' },
    { label: 'Evaluate', name: 'evaluate' },
    { label: 'Create Action Plan', name: 'actionplan' }
];

const columns = [
     { label: 'Rank', fieldName: 'Rank', type: 'text',typeAttributes: { width: '10px' } },
    { label: 'Name', fieldName: 'Name' , type: 'Url'},
    { label: 'Role', fieldName: 'FunnelMetrics__Role__c' , type: 'Text'},
    { type: 'action', typeAttributes: { rowActions: actions } }
];

export default class FmSalesRepresentative extends LightningElement {
    columns = columns;
    @api filteredSalesRepProfiles;
    
   
}