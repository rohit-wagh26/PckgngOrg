import { LightningElement, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// import getNotifications from '@salesforce/apex/FMBannerController.getNotifications';

export default class FmBanner extends LightningElement {
    //     @wire(getNotifications)
//     wiredNotifications({ data }) {
//         if (!data) {
//             return;
//         }
//	Loop over list of returned notifications, call showToast();
	connectedCallback() {
		// change this to a wire method that gets back a list of "Notification" objects
		// that have title, message, variant (Info, Success, Warning, Error), and mode (Dismissable, Pester, Sticky) from the Server-side controller.
		this.showToast('Complete Evaluations by 04/30/23', 'Evaluations can be completed directly from the Sales Rep\'s page', 'info', 'sticky');
	}
//     }

	showToast(title, message, variant, mode) {
		const event = new ShowToastEvent( {
			title: title,
			message: message,
			variant: variant,
			mode: mode
		});

		this.dispatchEvent(event);
	}
}