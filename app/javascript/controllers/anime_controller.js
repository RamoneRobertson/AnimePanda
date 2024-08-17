// app/javascript/controllers/anime_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["synopsis", "content", "toggleButton"];

  toggle() {
    const content = this.contentTarget;
    const button = this.toggleButtonTarget;

    if (content.classList.contains("expanded")) {
      content.classList.remove("expanded");
      button.textContent = "Read More";
    } else {
      content.classList.add("expanded");
      button.textContent = "Read Less";
    }
  }
}
