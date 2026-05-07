import { Controller } from "@hotwired/stimulus"

// Auto-scrolls the chat container to the bottom whenever content is added
export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.scrollToBottom()
    this.observeMutations()
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }

  scrollToBottom() {
    const el = this.hasContainerTarget ? this.containerTarget : this.element
    el.scrollTop = el.scrollHeight
  }

  observeMutations() {
    const el = this.hasContainerTarget ? this.containerTarget : this.element
    this.observer = new MutationObserver(() => this.scrollToBottom())
    this.observer.observe(el, { childList: true, subtree: true, characterData: true })
  }
}
