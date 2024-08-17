import { Controller } from "@hotwired/stimulus"
import Typed from "typed.js"

// Connects to data-controller="typing"
export default class extends Controller {
  static values = { message: Array }
  static targets = [ "panda" ]

  connect() {

    // document.querySelector(".recommend-button").addEventListener("click", (event) => {
    //   this.loading();
    // });

    // console.log("hello");
    // console.log(this.pandaTarget);

    if(this.messageValue == null) return;
    this.#updateChat(this.messageValue)
  }

  loading(){
    // console.log("working");
    if(this.element.classList.contains("d-none")){
      this.element.classList.remove("d-none");
    }
    this.#updateChat(["Just a moment..."]);
  }

  disable(){
    this.element.classList.add("d-none");
  }

  #updateChat(array){
    this.pandaTarget.classList.remove("d-none");
    new Typed(document.querySelector("#panda_message"), {
      strings: array,
      showCursor: false,
      smartBackspace: true,
      // onComplete: (self) => {this.#diableChat()},
      // onLastStringBackspaced: (self) => {this.#diableChat()},
      typeSpeed: 25
    })
  }

  #diableChat(){
    console.log("finshed typing");
    setTimeout(() => {
      this.element.classList.add("d-none");
    }, 2000);
  }
}
