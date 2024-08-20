import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="recommendations-loading"
export default class extends Controller {
  static target = [ "loadbar" ]

  connect() {
    // console.log("hello from loading bar controller");
  }

  loading(){
    // const overlay = document.querySelector("#full-overlay");
    // if(overlay.classList.contains("d-none")){
    //   overlay.classList.remove("d-none");
    // }

    // this.#performLoad();
  }

  #performLoad(){
    const overlay = document.querySelector("#full-overlay");
    if(overlay === null) return;
    this.#loadBar();
    setTimeout(() => {
      this.#performLoad();
    }, 100);
  }

  #loadBar(){
    const loadingprogress = document.querySelector(".turbo-progress-bar");

    // const loadingText = document.querySelector(".load-text");
    const loadingDiv = document.querySelector(".load-bar");

    // if(loadingDiv != null){
    //   // console.log(loadingDiv.style.width);
    //   console.log(`Turbo amount: ${parseFloat(loadingprogress.style.width)}`);
    //   const loadWidth = parseFloat(loadingprogress.style.width) - 10;
    //   const loadedPercentage = loadWidth / 10;
    //   console.log(`Calc Perc: ${loadedPercentage*100}%`);
    // }
    if(loadingprogress != null){
      const percentage = parseFloat(loadingprogress.style.width);
      console.log(`${percentage} %`)

      if(percentage >= 100) return;

      // loadingText.innerText = `${parseInt(percentage)}%`;
      loadingDiv.style.width = `${percentage}%`;
    }else{

    }
  }
}
