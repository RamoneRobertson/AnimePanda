import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reco-refresh"
export default class extends Controller {
  static targets = ['refresh']
  connect() {
  }

  render(){
    console.log('Hello from reco-refresh');
  }
}
