import { LightningElement, api, wire } from "lwc";
import getFilterConfig from "@salesforce/apex/FMFilterController.getFilterConfig";

export default class FmFilter extends LightningElement {
    showCompanyLevels = false;
  companyLevels = [];

  selectedLevel;
  selectedRole;

  levelPath = [];
  roles = [];

  breadCrumb = true;

  @api filterSelections = {
    companyLevel: null,
	manager: null,
    role: null,
    salesRep: null,
  };

  @wire(getFilterConfig)
  wiredFilterConfig({ data }) {
    if (!data) {
      return;
    }

    this.companyLevels = data.companyLevels;
	this.roles = data.roles;
	this.setCompanyLevels(this.companyLevels[0].name);
	this.selectedRole = 'All';
  }

  showCompanyLevelsEvent(event) {
	this.showCompanyLevels = true;
  }

  hideCompanyLevelsEvent(event) {
	this.showCompanyLevels = false;
  }

  handleCompanyLevelBreadcrumbSelection(event) {
	event.preventDefault();
	this.setCompanyLevels(event.target.name);
  }

  handleCompanyLevelSelection(event) {
	this.setCompanyLevels(event.detail.name);
  }

  setCompanyLevels(level) {
	this.selectedLevel = level;
	this.filterSelections.companyLevel = level;

    this.levelPath = this.findLevel(level);
	this.filterSelections.manager = this.levelPath[this.levelPath.length - 1].managerName;
    this.dispatch();
  }

  findLevel(levelName) {
    let found = false;
    const path = [];
    const searchKey = (li) => {
      li.some((x) => {
        path.push({ ...x, items: [] });

        if (x.name == levelName) {
          found = true;
          return found;
        }

        if (searchKey(x.items)) {
          return true;
        } else {
          path.pop();
        }
      });
      return found;
    };
    searchKey(this.companyLevels);
    return path;
  }

  handleRoleSelection(event) {
    this.selectedRole = event.target.value;
    this.filterSelections.role = this.selectedRole;

    this.dispatch();
  }

  dispatch() {
	//Create Event
    const filterChangeEvent = new CustomEvent("filterchange", {
      detail: { filterSelections: this.filterSelections },
    });

    //Dispatch Event
    this.dispatchEvent(filterChangeEvent);
  }
}