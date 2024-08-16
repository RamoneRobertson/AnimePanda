import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="show-anime-banner"
export default class extends Controller {
  static targets = [ "arrow", "trailer" ]

  connect() {
    // console.log("hello from the show anime banner controller");
  }

  toggle(){
    // console.log("toggled");
    // console.log(this.arrowTarget);
    this.arrowTarget.classList.toggle("active");
    this.trailerTarget.classList.toggle("show");
  }

  close(){
    this.element.classList.add("d-none");
  }
}
