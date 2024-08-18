import { Controller } from "@hotwired/stimulus"
import Typed from "typed.js"

let currentTyped = null;

// Connects to data-controller="typing"
export default class extends Controller {
  static values = { message: Array }
  static targets = [ "panda" ]

  connect() {
    if(this.messageValue == null) return;
    this.#updateChat(this.messageValue)
  }

  loading(){
    if(this.pandaTarget.classList.contains("d-none")){
      this.pandaTarget.classList.remove("d-none");
    }
    this.#updateChat(["Just a moment..."]);
  }

  disable(){
    this.pandaTarget.classList.add("d-none");
  }

  #updateChat(array){
    if(currentTyped != null){
      // stop current typed animation if there is one
      currentTyped.destroy();
    }
    this.pandaTarget.classList.remove("d-none");
    const typed = new Typed(document.querySelector("#panda_message"), {
      strings: array,
      showCursor: false,
      smartBackspace: true,
      // onComplete: (self) => {this.#diableChat()},
      // onLastStringBackspaced: (self) => {this.#diableChat()},
      typeSpeed: 25
    })
    currentTyped = typed;
  }

  #diableChat(){
    console.log("finshed typing");
    setTimeout(() => {
      this.element.classList.add("d-none");
    }, 2000);
  }
}
