import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="back-button"
export default class extends Controller {
  static targets = ["arrow"]
  connect() {
    console.log(this.arrowTarget)
  }

  goBack() {
    window.history.back()
  }
}
