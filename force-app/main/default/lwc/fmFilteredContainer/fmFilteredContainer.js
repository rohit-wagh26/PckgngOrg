import { LightningElement, wire } from "lwc";
import getSalesRepProfiles from "@salesforce/apex/FMFilteredContainerController.getSalesRepProfiles";

export default class FmFilteredContainer extends LightningElement {
  filteredSalesRepProfiles;
  companyLevel;
  role;
  salesRep;

  @wire(getSalesRepProfiles, {
    companyLevel: "$companyLevel",
    role: "$role"
  })
  wiredSalesRepProfiles({ data }) {
    if (!data) {
      return;
    }

    this.filteredSalesRepProfiles = data;
  }

  handleFilterChangeEvent(event) {
    this.companyLevel = event.detail.filterSelections.companyLevel;
    this.role = event.detail.filterSelections.role;
  }
}