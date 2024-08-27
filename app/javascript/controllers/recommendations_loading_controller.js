import { Controller } from "@hotwired/stimulus"

const bigPawSize = "80px";
let pawArrayIndex = 0;
let paws = [];

// Connects to data-controller="recommendations-loading"
export default class extends Controller {
  static targets = [ "screen", "paw" ]

  connect() {
    this.pawTargets.forEach(element => {
      paws.push(element.querySelector("img"));
    });
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
      }else{
        paws[i].style.width = "60px";
      }
    }
    pawArrayIndex += 1;
    if(pawArrayIndex >= paws.length){
      pawArrayIndex = 0;
    }
  }
}
