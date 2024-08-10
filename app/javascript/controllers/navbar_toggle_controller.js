import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar-toggle"
export default class extends Controller {
  static targets = [ "navToggle", "innerElements" ]

  connect() {
    // console.log("hello from navbar toggle controller");
  }

  fire(){
    // console.log(this.navToggleTarget);
    this.navToggleTarget.classList.toggle("nav-toggle-active");
    this.innerElementsTargets.forEach(element => {
      element.classList.toggle("d-none");
    });
  }
}
