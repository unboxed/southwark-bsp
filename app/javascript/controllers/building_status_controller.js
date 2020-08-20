import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['details']

  connect () {
    this.toggleClass = this.data.get('class') || 'hidden'
    this.inputValuesThatAllowDetails = ['duplicate', 'not_recognized']
  }

  toggle (event) {
    const inputValue = event.target.value

    if (
      this.inputValuesThatAllowDetails.includes(inputValue) &&
      this.detailsTarget.classList.contains(this.toggleClass)
    ) {
      this.detailsTarget.classList.toggle(this.toggleClass)
    } else if (
      !this.inputValuesThatAllowDetails.includes(inputValue) &&
      !this.detailsTarget.classList.contains(this.toggleClass)
    ) {
      this.detailsTarget.classList.toggle(this.toggleClass)
    }
  }
}
