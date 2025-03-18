class CartsController < ApplicationController
  before_action :set_cart, only: %i[ show clear update ]

  # GET /carts/1 or /carts/1.json
  def show
    reset_cart if @cart.cart_items.empty?
    @discount = params[:discount].to_d.presence || @cart.discount
  end

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
          # turbo_stream.replace("discount_slider", partial: "carts/discount_slider", locals: { cart: @cart }),
          turbo_stream.replace("total_price", partial: "carts/total_price", locals: { cart: @cart, input_discount: @discount }),
          turbo_stream.replace("discount_value", partial: "carts/discount_value", locals: { cart: @cart, input_discount: @discount }),
          turbo_stream.replace("form", partial: "orders/form", locals: { cart: @cart, input_discount: @discount })
        # turbo_stream.replace("cart", partial: "carts/cart", locals: { cart: @cart, input_discount: @discount })
        ]
      end
      format.json { render json: { total_price: @cart.calculate_total_price(@discount) } }
      format.html { redirect_to cart_path(@cart), notice: "Корзина обновлена." }
    end
  end

  private

  def reset_cart
    Rails.logger.debug "Cart is empty, resetting with default items."
    ActiveRecord::Base.transaction do
      @cart.update!(discount: 1000)

      items = [
        { name: "Беспроводная колонка Goodyear Bluetooth Speaker", price: 1600, category: "Техника", image: "items/speaker.svg", amount: 1 },
        { name: "Женский домашний костюм Sweet Dreams", price: 800, category: "Одежда", image: "items/pajamas.svg", amount: 1 },
        { name: "Плащ-дождевик SwissOak", price: 400, category: "Одежда", image: "items/coat.svg", amount: 2 }
      ]

      items.each do |item_data|
        item = Item.find_or_create_by!(name: item_data[:name], price: item_data[:price], category: item_data[:category], image: item_data[:image])
        @cart.cart_items.find_or_create_by!(item: item, amount: item_data[:amount])
      end
      Rails.logger.debug "Default items added to the cart."
      @cart.save!
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_cart
    if session[:cart_id]
      @cart = Cart.find_by(id: session[:cart_id])
    end

    unless @cart
      @cart = Cart.find_or_create_by!(subtotal_price: 0, discount: 1000)
      session[:cart_id] = @cart.id
    end
  end

  # Only allow a list of trusted parameters through.
  def cart_params
    params.permit(:discount)
  end
end
