import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "display"]

    increase() {
        this.updateAmount(1);
    }

    decrease() {
        this.updateAmount(-1);
    }

    updateAmount(change) {
        let value = parseInt(this.inputTarget.value) || 1;
        value = Math.max(1, value + change);

        this.inputTarget.value = value;
        this.displayTarget.textContent = value;

        this.inputTarget.closest("form").requestSubmit();
    }
}
