import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import fmIcons from '@salesforce/resourceUrl/FMIcons';

export default class Navigation extends NavigationMixin(LightningElement) {
  @api currentPageId;
  @api menuItems;
  @api currentPageReference;
  fmlogo = fmIcons + '/icons/fmlogo.png';

  connectedCallback() {
	this.setSelectedMenuItem();
  }


  

  setSelectedMenuItem() {
	this.menuItems = this.menuItems.map(obj => ({...obj, selected: obj.pageId == this.currentPageId}));
  }
}