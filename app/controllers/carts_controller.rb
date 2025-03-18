class CartsController < ApplicationController
  before_action :set_cart, only: %i[show clear update]

  # GET /carts/1 or /carts/1.json
  def show
    ResetCartService.new(@cart).call if @cart.line_items.empty?
    @discount = params[:discount].to_d.presence || @cart.discount
  end

  # Очистка корзины
  def clear
    @cart.clear!
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("cart", partial: "carts/cart", locals: { cart: @cart }) }
      format.html { redirect_to cart_path(@cart), notice: "Корзина очищена!" }
    end
  end

  # PATCH/PUT /carts/1 or /carts/1.json
  def update
    @discount = params[:discount].to_i

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("total_price", partial: "carts/total_price", locals: { cart: @cart, input_discount: @discount }),
          turbo_stream.replace("discount_value", partial: "carts/discount_value", locals: { cart: @cart, input_discount: @discount }),
          turbo_stream.replace("form", partial: "orders/form", locals: { cart: @cart, input_discount: @discount }),
          turbo_stream.replace("subtotal_price", partial: "carts/subtotal_price", locals: { cart: @cart })
        ]
      end
      format.json { render json: { total_price: @cart.calculate_total_price(@discount) } }
      format.html { redirect_to cart_path(@cart), notice: "Корзина обновлена." }
    end
  end

  private

  def set_cart
    if session[:cart_id]
      @cart = Cart.find_by(id: session[:cart_id])
    end

    unless @cart
      @cart = Cart.find_or_create_by!(subtotal_price: 0, discount: 1000)
      session[:cart_id] = @cart.id
    end
  end

  def cart_params
    params.permit(:discount)
  end
end
