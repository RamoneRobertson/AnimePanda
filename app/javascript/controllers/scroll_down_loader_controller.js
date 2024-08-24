import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-down-loader"
export default class extends Controller {
  connect() {
    console.log("Hello from the scroll down loader controller");
  }
}
