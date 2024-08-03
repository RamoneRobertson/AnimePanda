import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="panda-chat-toggle"
export default class extends Controller {
  static targets = [ "chat" ]
  static values = { height: String }

  connect() {
    // console.log("Hello from panda chat toggle");
  }

  toggle(){
    // this.chatTarget.classList.toggle("d-none");

    if(this.chatTarget.offsetHeight > 0){
      this.chatTarget.style.height = `0`;
    }else{
      this.chatTarget.style.height = this.heightValue;
    }
  }
}
