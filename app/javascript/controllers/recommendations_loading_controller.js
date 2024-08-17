import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="recommendations-loading"
export default class extends Controller {
  connect() {
    // console.log("hello from loading bar controller");
  }

  loading(){
    // this.#loadBar();
    // setTimeout(() => {
    //   this.loading();
    // }, 100);

    const thePanda = document.querySelector("#the-panda");
    if(thePanda.classList.contains("d-none")){
      thePanda.classList.remove("d-none");
    }

    // const chatBox = document.querySelector("#panda_message");
    // chatBox.innerText = "Loading...";
  }

  #loadBar(){
    // console.log("Started loading");
    const loadingDiv = document.querySelector(".turbo-progress-bar");
    const chatBox = document.querySelector("#panda_message");

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

      if(percentage >= 100) return;

      chatBox.innerText = `Loading...${percentage}%`;
    }else{
      // const chatBox = document.querySelector("#panda_message");
      // chatBox.innerText = "Loading...";
    }
  }
}
