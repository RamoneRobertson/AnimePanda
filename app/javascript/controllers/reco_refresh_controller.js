import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reco-refresh"
export default class extends Controller {
  static targets = ['animes', 'buttons']
  connect() {
    this.checkRecoList();
  }

  checkRecoList(){
    if (performance.navigation.type == PerformanceNavigation.TYPE_RELOAD){
      //Reload
      console.log("reloading page")
     }

     if (performance.navigation.type == PerformanceNavigation.TYPE_BACK_FORWARD){
      //Back Button
      console.log("back button detected")
     }
  }
}
