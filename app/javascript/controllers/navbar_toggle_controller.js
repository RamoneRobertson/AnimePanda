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

    if(this.innerElementsTarget.classList.contains("d-none")){
      // setTimeout(() => {
      //   this.innerElementsTargets.forEach(element => {
      //     element.classList.toggle("d-none");
      //   });
      // }, 350);
      // setTimeout(() => {
      //   let timeout = 0;
      //   this.innerElementsTargets.forEach(element => {
      //     setTimeout(() => {
      //       element.classList.toggle("d-none");
      //     }, timeout);
      //     timeout += 250;
      //   });
      // }, 250);
      setTimeout(() => {
        let timeout = 10;
        this.innerElementsTargets.forEach(element => {
          element.classList.remove("d-none");
          setTimeout(() => {
            element.classList.add("full-opacity");
            element.classList.remove("no-width");
          }, timeout);
          timeout += 275;
        });
      }, 250);

    }else{
      setTimeout(() => {
        this.innerElementsTargets.forEach(element => {
          element.classList.add("d-none");
          element.classList.remove("full-opacity");
          element.classList.add("no-width");
        });
      }, 10);
    }


  }
}
