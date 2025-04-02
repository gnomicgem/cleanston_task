import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["discountAmount"]

    connect() {
        this.debouncedSubmit = this.debounce(this.submitForm.bind(this), 200);
    }

    update(event) {
        const discount = event.target.value;

        const amountElement = document.querySelector("#discount-amount");
        if (!amountElement) return;

        // Анимация исчезновения
        amountElement.classList.add("fade-out");

        setTimeout(() => {
            amountElement.textContent = `${discount} ₽`;
            amountElement.classList.remove("fade-out");
            amountElement.classList.add("fade-in");

            setTimeout(() => {
                amountElement.classList.remove("fade-in");

                this.debouncedSubmit();

            }, 100);
        }, 100);
    }

    debouncedSubmit() {
        const form = this.element.closest("form");
        if (form) {
            clearTimeout(this.timeout);
            this.timeout = setTimeout(() => {
                form.requestSubmit();
            }, 100);
        }
    }

    debounce(func, wait) {
        let timeout;
        return function (...args) {
            clearTimeout(timeout);
            timeout = setTimeout(() => func.apply(this, args), wait);
        };
    }
}
