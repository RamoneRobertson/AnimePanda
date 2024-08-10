import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nav-sticky"
export default class extends Controller {
  connect() {
    // console.log("hello from the nav sticky controller");
    // console.log(this.element);

    const scrollWatcher = document.createElement("div");
    scrollWatcher.setAttribute("data-scroll-watcher", "");
    this.element.before(scrollWatcher);

    const navObserver = new IntersectionObserver((entries) => {this.element.classList.toggle("sticky-nav", !entries[0].isIntersecting)});

    navObserver.observe(scrollWatcher);
  }
}
