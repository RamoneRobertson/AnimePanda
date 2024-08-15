import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar-toggle"
export default class extends Controller {
  static targets = [ "navToggle", "innerElements" ]
  static values = { user: Boolean }

  connect() {
    // console.log("hello from navbar toggle controller");
    // console.log(this.userValue);
  }

  fire(){
    // console.log(this.navToggleTarget);
    if(this.userValue){
      this.navToggleTarget.classList.toggle("nav-toggle-user-active");
    }else{
      this.navToggleTarget.classList.toggle("nav-toggle-active");
    }

    setTimeout(() => {
      this.innerElementsTargets.forEach(element => {
        element.classList.toggle("d-none");
      });
    }, 200);
  }
}
