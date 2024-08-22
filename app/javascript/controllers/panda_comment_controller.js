import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="panda-comment"
export default class extends Controller {
  connect() {
    console.log("connected to panda comment ")
  }
}
