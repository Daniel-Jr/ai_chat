import { Controller } from "@hotwired/stimulus"

// Auto-dismisses flash messages after 4 seconds
export default class extends Controller {
  connect() {
    this.timeout = setTimeout(() => this.dismiss(), 4000)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  dismiss() {
    this.element.style.opacity = "0"
    this.element.style.transition = "opacity 0.3s ease"
    setTimeout(() => this.element.remove(), 300)
  }
}
