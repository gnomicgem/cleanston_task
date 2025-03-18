import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    submitForm(event) {
        clearTimeout(this.timeout);
        this.timeout = setTimeout(() => {
            this.element.closest("form").requestSubmit();
        }, 300);
    }
}
