import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="anime-vote"
export default class extends Controller {
  static targets = ["item", "like", "dislike", "animes"]

  connect(){
    console.log("connected")
  }

  like(){
    this.itemTarget.dataset.preference = "liked"
    this.itemTarget.classList.add("yes");
    this.redirect();
  }

  dislike(){
    this.itemTarget.dataset.preference = "dislike"
    this.itemTarget.classList.add("nope");
    this.redirect();
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
    const animeId = this.itemTarget.dataset.value
    const csrfToken = document.querySelector("[name='csrf-token']").content
    fetch("/bookmarks", {
      method: "POST",
      headers: {
        "X-CSRF-Token": csrfToken,
        "Content-Type": "application/json",
        "Accept": "text/plain" },
      body: JSON.stringify({
        anime_id: `${animeId}`,
        watch_status: "like"
      })
    })
  }

  redirect(){
    if (this.animesTarget.children.length === 1){
      window.location.href = "/lists/liked";
    }
  }
}
