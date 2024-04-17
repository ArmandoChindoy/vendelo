// app/javascript/controllers/confirm_controller.js
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  confirm(event) {
    console.log("confirm")
    console.log(this.dialogTarget)
    event.preventDefault()
    this.dialogTarget.showModal()
  }

  proceed() {
    Turbo.visit(this.data.get("url"), { action: this.data.get("action") })
    this.dialogTarget.close()
  }

  cancel() {
    this.dialogTarget.close()
  }
}