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
    // console.log(url);

    fetch(url, {
      headers: { "Accept": "text/plain" }
    })
    .then(resposne => resposne.text())
    .then(data => {
      // console.log(data);
      this.foundAnimeTarget.innerHTML = data;
    });

    // fetch the anime's list and find the anime
    // insert html into foundAnimeTarget div
  }
}
