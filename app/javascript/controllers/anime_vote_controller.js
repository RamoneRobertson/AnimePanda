import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="anime-vote"
export default class extends Controller {
  static targets = ["item", "like", "dislike"]

  connect(){

  }

  like(){
    this.itemTarget.dataset.preference = "liked"
    this.itemTarget.classList.add("yes");
  }

  dislike(){
    this.itemTarget.dataset.preference = "dislike"
    this.itemTarget.classList.add("nope");
  }

  animationDone(event){
    if(event.animationName === 'like'){
      this.itemTarget.classList.remove("yes")
      this.#updatePreference();
    }

    if(event.animationName === 'dislike'){
      this.itemTarget.classList.remove("nope")
      this.#updatePreference();
    }

    if(event.animationName == 'like' || event.animationName == 'dislike'){
      this.itemTarget.remove();
    }
  }

  #updatePreference(){
    const bookmarkId = this.itemTarget.dataset.value
    const preference = this.itemTarget.dataset.preference
    const csrfToken = document.querySelector("[name='csrf-token']").content
    fetch(`/bookmarks/${bookmarkId}`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": csrfToken,
        "Content-Type": "application/json",
        "Accept": "text/plain" },
      body: JSON.stringify({preference: `${preference}`})
    })
  }
}
