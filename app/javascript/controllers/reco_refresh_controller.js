import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reco-refresh"
export default class extends Controller {
  static targets = ['animes']
  connect() {
    window.addEventListener("load", (event) => {
      document.documentElement.classList.remove("loader");
    });

    window.addEventListener("beforeunload", (event) => {
      localStorage.clear();
      document.documentElement.classList.add("loader");
    })
  }
}
