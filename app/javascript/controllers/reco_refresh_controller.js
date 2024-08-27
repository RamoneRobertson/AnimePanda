import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reco-refresh"
export default class extends Controller {
  static targets = ['animes']
  connect() {
    // const otherController = this.application.getControllerForElementAndIdentifier(this.loadTarget, 'load')
    // window.addEventListener("load", (event) => {
    //   otherController.load();
    //   // document.documentElement.classList.remove("loader");
    // });

    // window.addEventListener("beforeunload", (event) => {
    //   otherController.load();
    // })
  }
}
