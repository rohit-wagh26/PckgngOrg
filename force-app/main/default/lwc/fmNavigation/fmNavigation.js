import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import fmIcons from '@salesforce/resourceUrl/FMIcons';

export default class FmNavigation extends NavigationMixin(LightningElement) {
  @api currentPageId;
  @api menuItems;
  @api currentPageReference;
  fmlogo = fmIcons + '/icons/fmlogo.png';

  connectedCallback() {
	this.setSelectedMenuItem();
  }

  navigate(event) {
	this.currentPageId = event.target.name;

    this[NavigationMixin.Navigate](
      Object.assign({}, this.currentPageReference, {
        state: Object.assign({}, this.currentPageReference.state, {
          c__page: event.target.name,
        }),
      })
      //false // Push to browser history stack
    );

	this.setSelectedMenuItem();
  }

  setSelectedMenuItem() {
	this.menuItems = this.menuItems.map(obj => ({...obj, selected: obj.pageId == this.currentPageId}));
  }
}