import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["amount"]

    connect() {
        this.update({ target: this.element });
    }

    update(event) {
        const discount = event.target.value
        this.amountTarget.textContent = `${discount}₽`
        console.log("update: discount =", discount, "amountTarget.textContent =", this.amountTarget.textContent)
    }
}








// import { Controller } from "@hotwired/stimulus"
// import { patch } from "@rails/request.js"
//
// export default class extends Controller {
//     static targets = ["amount", "slider", "total"]
//
//     update(event) {
//         const discount = event.target.value
//         this.amountTarget.textContent = `${discount} ₽`
//         console.log("update: discount =", discount, "amountTarget.textContent =", this.amountTarget.textContent);
//         this.sliderTarget.value = discount;
//
//         this.updateDiscount(discount);
//     }
//
//     updateDiscount(discount) {
//         if (this.element.dataset.cartId) {
//             patch(`/carts/${this.element.dataset.cartId}`, {
//                 body: { discount: discount },
//                 responseKind: "json"
//             }).then(response => {
//                 response.json.then(data => {
//                     this.totalTarget.textContent = `${data.total_price} ₽`
//                     this.sliderTarget.value = discount;
//                     console.log("updateDiscount: discount =", discount, "totalTarget.textContent =", this.totalTarget.textContent);
//                 })
//             })
//         } else {
//             console.error("cartId is not defined");
//         }
//     }
// }