import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-bar"
export default class extends Controller {
  static targets = [ "form", "input", "foundAnime" ]

  connect() {
    // console.log("hello from the search bar controller");
    // console.log(this.formTarget);
    // console.log(this.formTarget.action);
    // console.log(this.inputTarget);
    // console.log(this.foundAnimeTarget);
  }

  action(event){
    event.preventDefault();

    this.foundAnimeTarget.innerHTML = "";

    const url = `${this.formTarget.action}?query=${this.inputTarget.value}`;

    fetch(url, {
      headers: { "Accept": "text/plain" }
    })
    .then(resposne => resposne.text())
    .then(data => {
      this.foundAnimeTarget.innerHTML = data;
    });

    // show some text to say it's loading while it tries to fetch..
    this.foundAnimeTarget.insertAdjacentHTML("beforeend", '<div class="container p-3"><p>Loading...</p></div>');
  }
}
