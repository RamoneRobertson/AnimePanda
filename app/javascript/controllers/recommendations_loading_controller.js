import { Controller } from "@hotwired/stimulus"

const bigPawSize = "80px";
let pawArrayIndex = 0;
let paws = [];
let whitePawSrc = "";

// Connects to data-controller="recommendations-loading"
export default class extends Controller {
  static targets = [ "screen", "paw", "blackPaw" ]

  connect() {
    this.pawTargets.forEach(element => {
      paws.push(element.querySelector("img"));
    });
    whitePawSrc = this.pawTargets[0].querySelector("img").src;
  }

  loading(){
    console.log("loading started");
    this.screenTarget.classList.remove("d-none");
    this.#movePaws();
    this.#performLoad();
  }

  #performLoad(){
    setTimeout(() => {
      this.#movePaws();
      this.#performLoad();
    }, 300);
  }

  #movePaws(){
    for(let i = 0; i < paws.length; i++){
      if(i === pawArrayIndex){
        paws[i].style.width = "70px";
        paws[i].src = this.blackPawTarget.querySelector("img").src;
      }else{
        paws[i].style.width = "60px";
        paws[i].src = whitePawSrc;
      }
    }
    pawArrayIndex += 1;
    if(pawArrayIndex >= paws.length){
      pawArrayIndex = 0;
    }
  }
}
