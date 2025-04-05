class OrdersController < ApplicationController
  before_action :set_order_to_create, only: %i[ create ]

  # POST /orders or /orders.json
  def create
    if @order
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("cart", partial: "carts/cart", locals: { cart: @order.cart }) }
        format.html { redirect_to cart_path(@order.cart), notice: "Заказ оформлен, корзина очищена!" }
      end
    else
      redirect_to cart_path, alert: "Корзина пуста или не найдена!"
    end
  end


  private

  def set_order_to_create
    @order = CreateOrderService.new(
      cart: Cart.find_by(id: order_params[:cart_id]) || Cart.find_by(id: session[:cart_id]),
      applied_discount: params[:order][:applied_discount],
      total_price: params[:order][:total_price]
    ).call
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:cart_id, :applied_discount, :total_price)
  end
end
