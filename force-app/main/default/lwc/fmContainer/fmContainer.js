import { LightningElement, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";

export default class FmContainer extends LightningElement {
    currentPageReference;

  pagesConfig = [
    {
      name: "Home",
      isActive: "true", //<-- This property can be configured by persona
      isLandingPage: true,
      menuOrder: 1,
      pageId: "home",
    },
    {
      name: "Settings",
      isActive: "true",
      isLandingPage: false,
      menuOrder: 2,
      pageId: "settings",
    },
    {
      name: "Administrator",
      isActive: "true",
      isLandingPage: false,
      menuOrder: 3,
      pageId: "administration",
    },
  ];

  menuItems = [];

  currentPageId;

  isCurrentPageReferenceLoaded = false;

  connectedCallback() {
    this.setNavigationMenu();
    this.setLandingPage();

    this.setCurrentPage();
  }

  @wire(CurrentPageReference)
  wiredCurrentPageReference(currentPageReference) {
    if (!currentPageReference) {
      return;
    }

    this.currentPageReference = currentPageReference;

    this.isCurrentPageReferenceLoaded = true;

    this.setCurrentPage();
  }

  get isLoaded() {
    return this.isCurrentPageReferenceLoaded;
  }

  setNavigationMenu() {
    this.menuItems = [...this.pagesConfig]
      .sort((a, b) => (a.menuOrder > b.menuOrder ? 1 : -1))
      .map((page) => ({
        label: page.name,
        pageId: page.pageId,
      }));
  }

  setLandingPage() {
    this.landingPage = this.pagesConfig.find((page) => page.isLandingPage);
  }

  setCurrentPage() {
    if (!this.isLoaded) {
      return;
    }

    this.currentPageId =
      this.currentPageReference?.state?.c__page || this.landingPage?.pageId;
    // this.currentPageId = 'home';
  }
}