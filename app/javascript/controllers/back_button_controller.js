import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="back-button"
export default class extends Controller {
  static targets = ["arrow"]
  connect() {

  }

  goBack() {
    console.log(window.history)
    // window.history.back()
  }
}
