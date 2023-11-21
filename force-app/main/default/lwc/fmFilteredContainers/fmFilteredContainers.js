import { LightningElement, wire } from "lwc";
import getSalesRepProfiles from "@salesforce/apex/FMFilteredContainersController.getSalesRepProfiles";

export default class FmFilteredContainers extends LightningElement {

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

    this.filteredSalesRepProfiles = data.map((record, index) => ({ Rank: index + 1, ...record }));
  }

  handleFilterChangeEvent(event) {
    this.companyLevel = event.detail.filterSelections.companyLevel;
    this.role = event.detail.filterSelections.role;
  }
}