import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.toggleClass = this.data.get("toggle-class")
  }

  toggle() {
    this.inputTarget.classList.toggle(this.toggleClass)
  }
}
