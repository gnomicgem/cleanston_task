class CartItemsController < ApplicationController
  before_action :set_cart_item, only: %i[ show edit update destroy ]
  before_action :set_cart, only: %i[ update destroy ]

  # POST /cart_items or /cart_items.json
  def create
    @cart_item = CartItem.new

    respond_to do |format|
      if @cart_item.save
        @cart.save
        format.html { redirect_to @cart_item, notice: "Cart item was successfully created." }
        format.json { render :show, status: :created, location: @cart_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cart_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cart_items/1 or /cart_items/1.json
  def update
    respond_to do |format|
      if @cart_item.update(cart_item_params) && @cart.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("cart-item-#{@cart_item.id}", partial: "cart_items/cart_item", locals: { cart_item: @cart_item }),
            turbo_stream.replace("total_price", partial: "carts/total_price", locals: { cart: @cart, input_discount: @cart.discount })
          ]
        end
        format.html { redirect_to cart_path, notice: "Количество обновлено." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("cart-item-#{@cart_item.id}",
                                                    partial: "cart_items/form", locals: { cart_item: @cart_item })
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cart_items/1 or /cart_items/1.json
  def destroy
    @cart_item.destroy!
    @cart.save
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove("cart-item-#{@cart_item.id}"),
          turbo_stream.replace("cart", partial: "carts/cart", locals: { cart: @cart })
        ]
      end
      format.html { redirect_to cart_path, notice: "Товар удалён из корзины." }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart_item
    @cart_item = CartItem.find(params.expect(:id))
  end

  def set_cart
    @cart = @cart_item.cart
  end

  # Only allow a list of trusted parameters through.
  def cart_item_params
    params.expect(cart_item: [ :cart_id, :item_id, :amount ])
  end
end
