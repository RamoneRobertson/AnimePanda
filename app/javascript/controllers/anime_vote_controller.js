import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="anime-vote"
export default class extends Controller {
  static targets = ["item"]

  connect() {

  }

  like(event) {
    event.preventDefault();
    const bookmarkId = this.itemTarget.dataset.value
    this.itemTarget.dataset.preference = "liked"
    this.itemTarget.classList.add("yes");
    const animeTitle = this.itemTarget.querySelector("h3").innerText;
    // When liked remove the bookmark from the @recommend_list

    // Make an AJAX request to the animes/recommendations page
    const csrfToken = document.querySelector("[name='csrf-token']").content
    const preference = this.itemTarget.dataset.preference
    fetch(`/bookmarks/${bookmarkId}`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": csrfToken,
        "Content-Type": "application/json",
        "Accept": "text/plain" },
      body: JSON.stringify({preference: "liked"})
    })
    .then(response => response.text())
    .then((data) => {
      console.log(data);
    })
  }

  dislike(event){
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

  updateBookmark(){

  }
}
