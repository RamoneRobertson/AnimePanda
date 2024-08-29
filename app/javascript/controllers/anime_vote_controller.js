import { Controller } from "@hotwired/stimulus"
// View: app/views/animes/recommendations.html.erb
// route: /animes/recommendations

// Connects to data-controller="anime-vote"
export default class extends Controller {
  static values = {
    recos: Array
  }

  static targets = ["animes", "anime", "dislike", "like", "comment"]

  connect(){
    this.comments = [...this.recosValue]
  }

  vote(event){
    if(event.currentTarget === this.likeTarget){
      this.#animateBtn(event);
      this.#updatePreference();
      this.#incrementLike();
      this.animeTarget.classList.add("yes");
      this.#pandaComment();
      this.#redirect();
    }
    else if(event.currentTarget === this.dislikeTarget){
      this.#animateBtn(event)
      this.animeTarget.classList.add('nope');
      this.#pandaComment();
      this.#redirect();
    }
  }

  #pandaComment(){
    if(this.comments.length !== 1){
      const comment = this.comments.splice(1, 1)[0]
      const regex = /recommended\s([^.!?]*?[\w\s'!-.]*?)(?=\sbecause|\sas|\sdue\s|\sfor\s|[.?])/i;
      const match = comment.match(regex);
      const title = match ? match[1] : null;
      if(title){
        const highlightedTitle = comment.replace(title, `<span class="highlight">${title}</span>`);
        this.dispatch('vote', { detail: { message: [highlightedTitle] } })
      }
    }
  }

  #animateBtn(event){
    if(event.currentTarget === this.likeTarget){
      this.likeTarget.classList.remove('animate');
      this.likeTarget.classList.add('animate');
      setTimeout(() => {
        this.likeTarget.classList.remove('animate');
      },700);
    }
    else if(event.currentTarget === this.dislikeTarget){
      this.dislikeTarget.classList.remove('animate');
      this.dislikeTarget.classList.add('animate');
      setTimeout(() => {
        this.dislikeTarget.classList.remove('animate');
      },700);
    }

  }

  // run after the animation is complete
  animationDone(event){
    if(event.animationName === 'like'){
      //  remove the yes class found in _recommendation.scss, to prepare for the next anime in the stack
      this.animeTarget.classList.remove("yes")
    }

    //  remove the nope class found in _recommendation.scss, to prepare for the next anime in the stack
    if(event.animationName === 'dislike'){
      this.animeTarget.classList.remove("nope")
    }

    // On a like or dislike remove the item from the HTML
    if(event.animationName == 'like' || event.animationName == 'dislike'){
      this.animeTarget.remove();
    }
  }

  #incrementLike() {
    this.animesTarget.dataset.likes = Number(this.animesTarget.dataset.likes) + 1
  }

  // function to create a new bookmark with the watch_status set to like
  // Sends a HTTP POST request to /bookmarks
  #updatePreference(){
    // The data-anime value set on the reco-anime container
    const animeId = this.animeTarget.dataset.anime
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

  #disableButtons(){
    this.likeTarget.classList.toggle('d-none');
    this.dislikeTarget.classList.toggle('d-none');
  }

  // Function redirects to the /lists/liked view by tracking animesTarget.children
  #redirect(){
    if (this.animesTarget.children.length == 1 && this.animesTarget.dataset.likes == 0){
      this.#disableButtons();
      window.location.reload(true);
    }
    else if (this.animesTarget.children.length == 1){
      this.#disableButtons();
      window.location.href = "/lists/liked";
    }
  }
}
