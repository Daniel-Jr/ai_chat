import { Controller } from "@hotwired/stimulus"

// Sidebar toggle for mobile
export default class extends Controller {
  static targets = ["panel", "overlay", "toggle"]

  toggle() {
    const isOpen = !this.panelTarget.classList.contains("-translate-x-full")
    if (isOpen) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.panelTarget.classList.remove("-translate-x-full")
    if (this.hasOverlayTarget) this.overlayTarget.classList.remove("hidden")
  }

  close() {
    this.panelTarget.classList.add("-translate-x-full")
    if (this.hasOverlayTarget) this.overlayTarget.classList.add("hidden")
  }
}
