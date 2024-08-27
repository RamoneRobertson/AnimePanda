import { Controller } from "@hotwired/stimulus"

let queryArray = "";
let recommendationsLink = "";

// Connects to data-controller="genre-toggle"
export default class extends Controller {
  static targets = [ "genre" ]

  connect() {
    // console.log("hello from the genre toggle controller");
    recommendationsLink = document.querySelector(".lucky-button > a").href;
  }

  toggle(event){
    // Find the outer div and toggle styling to show if it is checked
    this.genreTargets.forEach(target => {
      if(target.contains(event.currentTarget)){
        target.classList.toggle("active");
      }
    });

    // create url params
    this.#makeLink();

    // adjust the link_to path to have params
    let link = "";
    if(queryArray === ""){
      link = document.querySelector(".lucky-button > a").href = recommendationsLink;
    }else{
      link = document.querySelector(".lucky-button > a").href = `${recommendationsLink}?genre=${queryArray}`;
    }
    // console.log(link);
  }

  #makeLink(){
    // console.log("gathering genres...")
    queryArray = "";
    this.genreTargets.forEach(genre => {
      if(!genre.querySelector("input").checked) return;

      if(queryArray === ""){
        queryArray += `${genre.querySelector("span").innerText}`;
      }else{
        queryArray += `,${genre.querySelector("span").innerText}`;
      }
    });
    // console.log(queryArray); // full created array
  }
}
