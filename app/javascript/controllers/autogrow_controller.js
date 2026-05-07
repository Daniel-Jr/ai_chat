import { Controller } from "@hotwired/stimulus"

// Auto-grows a textarea to fit its content
export default class extends Controller {
  static targets = ["input"]

  connect() {
    if (this.hasInputTarget) this.resize()
  }

  resize() {
    const el = this.inputTarget
    el.style.height = "auto"
    el.style.height = `${Math.min(el.scrollHeight, 200)}px`
  }
}
