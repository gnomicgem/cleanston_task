class CreateOrderService
  def initialize(cart:, applied_discount:, total_price:)
    @cart = cart
    @applied_discount = applied_discount.to_d
    @total_price = total_price.to_d
  end

  def call
    return unless valid_cart?

    Order.transaction do
      create_order!
      move_line_items!
      clear_cart!
    end

    @order
  end

  private

  def valid_cart?
    @cart.present? && @cart.line_items.any?
  end

  def create_order!
    @order = Order.create!(
      cart_id: @cart.id,
      subtotal_price: @cart.subtotal_price,
      applied_discount: @applied_discount,
      total_price: @total_price
    )
  end

  def move_line_items!
    @cart.line_items.update_all(lineable_id: @order.id, lineable_type: "Order")
  end

  def clear_cart!
    @cart.update!(subtotal_price: 0, discount: 1000)
  end
end
