class LineItemsController < ApplicationController
  before_action :set_line_item, only: %i[update destroy]
  before_action :set_cart, only: %i[update destroy]

  # PATCH/PUT /line_items/1
  def update
    respond_to do |format|
      if @line_item.update(line_item_params) && @cart.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("line-item-#{@line_item.id}",
                                 partial: "line_items/line_item", locals: { line_item: @line_item }),
            turbo_stream.replace("total_price",
                                 partial: "carts/total_price", locals: { cart: @cart, input_discount: @cart.discount }),
            turbo_stream.replace("subtotal_price",
                                 partial: "carts/subtotal_price", locals: { cart: @cart })
          ]
        end
        format.html { redirect_to cart_path, notice: "Количество обновлено." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("line-item-#{@line_item.id}",
                                                    partial: "line_items/form", locals: { cart_item: @line_item })
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  def destroy
    @line_item.destroy!
    @cart.save
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove("line-item-#{@line_item.id}"),
          turbo_stream.replace("cart", partial: "carts/cart", locals: { cart: @cart })
        ]
      end
      format.html { redirect_to cart_path, notice: "Товар удалён из корзины." }
    end
  end

  private

  def set_line_item
    @line_item = LineItem.find(params[:id])
  end

  def set_cart
    @cart = @line_item.lineable if @line_item.lineable.is_a?(Cart)
  end

  # Only allow a list of trusted parameters through.
  def line_item_params
    params.require(:line_item).permit(:lineable_id, :lineable_type, :item_id, :amount)
  end
end
