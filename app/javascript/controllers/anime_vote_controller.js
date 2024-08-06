import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="anime-vote"
export default class extends Controller {
  static targets = ["like", "dislike"]

  connect() {
    console.log("Hello from anime vote!")
  }
}
