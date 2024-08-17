import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="recommendations-loading"
export default class extends Controller {
  connect() {
    // console.log("hello from loading bar controller");
  }

  loading(){
    this.#loadBar();
    setTimeout(() => {
      this.loading();
    }, 100);
  }

  #loadBar(){
    // console.log("Started loading");
    const loadingDiv = document.querySelector(".turbo-progress-bar");
    // if(loadingDiv != null){
    //   // console.log(loadingDiv.style.width);
    //   console.log(`Turbo amount: ${parseFloat(loadingDiv.style.width)}`);
    //   const loadWidth = parseFloat(loadingDiv.style.width) - 10;
    //   const loadedPercentage = loadWidth / 10;
    //   console.log(`Calc Perc: ${loadedPercentage*100}%`);
    // }
    if(loadingDiv != null){
      const percentage = parseFloat(loadingDiv.style.width);
      console.log(`${percentage} %`)
    }
  }
}
