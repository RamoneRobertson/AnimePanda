import { Controller } from "@hotwired/stimulus"
// View: app/views/animes/recommendations.html.erb
// route: /animes/recommendations

// Connects to data-controller="anime-vote"
export default class extends Controller {
  // animes -> reco-container div in
  // anime -> reco-anime div
  // dislike -> dislike btn
  //  like -> like btn
  static targets = ["animes", "anime", "dislike", "like"]

  connect(){

  }
  // Add the yes class from _recommendation.scss, runs the like animation
  like(event){
    this.animeTarget.classList.add("yes");
    this.#updatePreference();
    this.#removeBookmark();
    this.#redirect();
  }

  // Add the nope class from _recommendation.scss, runs the dislike animation
  dislike(event){
    this.animeTarget.classList.add("nope");
    this.#removeBookmark();
    this.#redirect();
  }

  // run after the animation is complete
  animationDone(event){
    if(event.animationName === 'like'){
      //  remove the yes class found in _recommendation.scss, to prepare for the next anime in the stack
      this.animeTarget.classList.remove("yes")
      // this.#updatePreference();
    }

    //  remove the nope class found in _recommendation.scss, to prepare for the next anime in the stack
    if(event.animationName === 'dislike'){
      this.animeTarget.classList.remove("nope")
      console.log("Dislike animation done!")
    }

    // On a like or dislike remove the item from the HTML
    if(event.animationName == 'like' || event.animationName == 'dislike'){
      this.animeTarget.remove();
    }
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

  // function to remove bookmark from the recommend_list in animes controller
  // Sends a HTTP DELETE request to /bookmarks/params[:id]
  #removeBookmark(){
    // the data-bk value set on the reco-anime container
    const bookmarkId = this.animeTarget.dataset.bk
    const csrfToken = document.querySelector("[name='csrf-token']").content
    fetch(`/bookmarks/${bookmarkId}`, {
      method: "DELETE",
      headers: {
        "X-CSRF-Token": csrfToken,
        "Content-Type": "application/json",
        "Accept": "text/plain" }
    })
  }

  // Function redirects to the /lists/liked view by tracking animesTarget.children
  // What should happen after the swiping is done
  #redirect(){
    if (this.animesTarget.children.length === 1){
      window.location.href = "/lists/liked";
    }
  }
}
