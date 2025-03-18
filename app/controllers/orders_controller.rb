class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    Rails.logger.info "RAW PARAMS: #{params.inspect}"
    Rails.logger.info "ORDER PARAMS: #{order_params.inspect}"
    cart = Cart.find(order_params[:cart_id]) || Cart.find_by(id: session[:cart_id])
    total_price = params[:order][:total_price].to_d
    Rails.logger.info "TOTAL PRICE: #{total_price}"

    return redirect_to cart_path, alert: "Корзина пуста или не найдена!" unless cart&.items&.any?

    @order = Order.create!(
      cart_id: cart.id,
      subtotal_price: cart.subtotal_price,
      applied_discount: params[:order][:applied_discount].to_d,
      total_price: params[:order][:total_price].to_d
    )

    cart.cart_items.each do |cart_item|
      OrderItem.create!(
        order_id: @order.id,
        item_id: cart_item.item_id,
        amount: cart_item.amount
      )
    end

    cart.cart_items.destroy_all
    cart.update!(subtotal_price: 0, discount: 1000)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("cart", partial: "carts/cart", locals: { cart: cart })
      end
      format.html { redirect_to cart_path(cart), notice: "Заказ оформлен, корзина очищена!" }
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy!

    respond_to do |format|
      format.html { redirect_to orders_path, status: :see_other, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:cart_id, :applied_discount, :total_price)
  end
end
