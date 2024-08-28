import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="show-more"
export default class extends Controller {
  static targets = ['synopsis', 'expander']
  connect() {

  }

  toggleSynopsis(){
    this.synopsisTarget.classList.toggle('reco-synopsis');
    this.synopsisTarget.classList.toggle('reco-synopsis-expanded');
    this.synopsisTarget.classList.toggle('fade-img')
    if(this.expanderTarget.innerText === "Read More"){
      this.expanderTarget.innerText = "Read Less"
    }
    else{
      this.expanderTarget.innerText = "Read More"
    }

  }
}
