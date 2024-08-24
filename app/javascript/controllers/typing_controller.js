import { Controller } from "@hotwired/stimulus"
import Typed from "typed.js"

let currentTyped = null;

// Connects to data-controller="typing"
export default class extends Controller {
  static values = { message: Array }
  static targets = [ "panda" ]

  connect() {
    if (this.messageValue == null) return;
    this.updateChat({ detail: { message: this.messageValue } }); // Ensure initial chat is set with an array
  }

  loading() {
    if (this.pandaTarget.classList.contains("d-none")) {
      this.pandaTarget.classList.remove("d-none");
    }
    this.updateChat({ detail: { message: ["Just a moment..."] } });
  }

  disableChat() {
    setTimeout(() => {
      this.element.classList.add("d-none");
    }, 2000);
  }

  disable(){
    this.pandaTarget.classList.add("d-none");
  }

  updateChat(event) {
    console.log("it's working")
    const array = event.detail.message; // Get the array of strings from the dispatched event

    if (!Array.isArray(array)) {
      console.error("Expected an array of strings, but got:", array);
      return;
    }

    if (currentTyped != null) {
      currentTyped.destroy(); // Stop current typed animation if there is one
    }

    this.pandaTarget.classList.remove("d-none");

    const typed = new Typed("#panda_message", {
      strings: array, // Use the array passed from the event
      showCursor: false,
      smartBackspace: true,
      typeSpeed: 25
    });

    currentTyped = typed;
}

  #diableChat(){
    console.log("finshed typing");
    setTimeout(() => {
      this.element.classList.add("d-none");
    }, 2000);
  }
}
