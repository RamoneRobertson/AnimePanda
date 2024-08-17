import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["synopsis", "content", "toggleButton", "iframeContainer", "playButton"];

  toggle() {
    const content = this.contentTarget;
    const button = this.toggleButtonTarget;

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

    // Toggle display to push down content
    if (iframeContainer.style.display === "none" || iframeContainer.style.display === "") {
      iframeContainer.style.display = "block";

      // Add a short delay before reloading the iframe to ensure it's visible when reloaded
      setTimeout(() => {
        // Reload the iframe to enforce autoplay
        const src = iframe.src;
        iframe.src = ''; // Temporarily clear the src
        iframe.src = src; // Reset the src to force reload with autoplay
      }, 100);

      // Change play icon to pause icon
      playButton.classList.remove("fa-play");
      playButton.classList.add("fa-pause");
    } else {
      iframeContainer.style.display = "none";

      // Change pause icon back to play icon
      playButton.classList.remove("fa-pause");
      playButton.classList.add("fa-play");
    }
  }
}
