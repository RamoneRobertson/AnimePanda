import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="anime-vote"
export default class extends Controller {
  static targets = ["item"]

  connect() {

  }

  like(event) {
    event.preventDefault();
    this.itemTarget.classList.add("yes");
    const animeTitle = this.itemTarget.querySelector("h3").innerText;
  }

  dislike(event){
    event.preventDefault();
    this.itemTarget.classList.add("nope");
  }

  animationDone(event){
    if(event.animationName === 'like'){
      this.itemTarget.classList.remove("yes")
    }

    if(event.animationName === 'dislike'){
      this.itemTarget.classList.remove("nope")
    }

    if(event.animationName == 'like' || event.animationName == 'dislike'){
      this.itemTarget.remove();
    }
  }
}
