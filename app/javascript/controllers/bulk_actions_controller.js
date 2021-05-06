import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "selectAll", "building",
    "sendLetter", "markOnDelta",
    "sendLetterForm", "markOnDeltaForm"
  ]

  markOnDelta(e) {
    this.submitForm(this.markOnDeltaFormTarget)
  }

  sendLetter(e) {
    this.submitForm(this.sendLetterFormTarget)
  }

  selectAll(e) {
    this.toggleBuildings(this.selectAllTarget.checked)
    this.toggleButtons()
  }

  selectBuilding(e) {
    this.toggleButtons()
  }

  toggleBuildings(checked) {
    this.buildings.forEach(building => { building.checked = checked })
  }

  toggleButtons() {
    this.sendLetterTarget.disabled = !this.isChecked
    this.markOnDeltaTarget.disabled = !this.isChecked
  }

  submitForm(form) {
    this.checkedIds.forEach(building => this.hiddenField(form, building))
    form.submit()
  }

  hiddenField(form, building) {
    const field = document.createElement("input")

    field.type = "hidden"
    field.name = "ids[]"
    field.value = building

    form.appendChild(field)
  }

  get buildings() {
    return this.buildingTargets
  }

  get isChecked() {
    return this.buildings.some(building => building.checked)
  }

  get checkedBuildings() {
    return this.buildings.filter(building => building.checked)
  }

  get checkedIds() {
    return this.checkedBuildings.map(building => building.value)
  }
}
