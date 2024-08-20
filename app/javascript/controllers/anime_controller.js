import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["synopsis", "content", "toggleButton", "iframeContainer", "playButton", "playText"];

  toggle() {
    const content = this.contentTarget;
    const button = this.toggleButtonTarget;

    // Toggle the "expanded" class on the content
    if (content.classList.contains("expanded")) {
      content.classList.remove("expanded");
      button.textContent = "Read More";
    } else {
      content.classList.add("expanded");
      button.textContent = "Read Less";
    }
  }

  play() {
    const iframeContainer = this.iframeContainerTarget;
    const iframe = this.iframeContainerTarget.querySelector('iframe');
    const playButton = this.playButtonTarget;
    const playText = this.playTextTarget;

    // Toggle display of the iframe container
    if (iframeContainer.style.display === "none" || iframeContainer.style.display === "") {
      iframeContainer.style.display = "block";

      // Scroll to iframe container
      iframeContainer.scrollIntoView({ behavior: "smooth", block: "start" });

      // Set iframe src to start playing video
      const src = iframe.src;
      iframe.src = '';
      iframe.src = src;

      // Change play button icon and text to pause
      playButton.classList.remove("fa-play");
      playButton.classList.add("fa-pause");
      playText.textContent = "Hide Trailer";
    } else {
      iframeContainer.style.display = "none";

      // Change pause button icon and text back to play
      playButton.classList.remove("fa-pause");
      playButton.classList.add("fa-play");
      playText.textContent = "Play Trailer";
    }
  }
}
