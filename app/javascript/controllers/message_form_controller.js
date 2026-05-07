import { Controller } from "@hotwired/stimulus"

// Handles message form UX:
// - Disables the send button while Turbo is submitting
// - Clears and re-focuses the textarea after a successful submit
// - Submits on Enter (Shift+Enter inserts a newline)
export default class extends Controller {
  static targets = ["submit"]

  // Turbo fires this when the form submission begins
  onSubmitStart() {
    if (this.hasSubmitTarget) this.submitTarget.disabled = true
  }

  // Turbo fires this when the response has been processed
  onSubmitEnd(event) {
    if (this.hasSubmitTarget) this.submitTarget.disabled = false

    // Only clear on success (2xx)
    if (event.detail.success) {
      const textarea = this.element.querySelector("textarea")
      if (textarea) {
        textarea.value = ""
        textarea.style.height = "auto"
        textarea.dispatchEvent(new Event("input"))
        textarea.focus()
      }
    }
  }

  submitOnEnter(event) {
    // Enter submits; Shift+Enter inserts a newline
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.element.requestSubmit()
    }
  }
}
