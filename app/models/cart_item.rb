class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :item

  def calculate_total_price
    item.price * amount
  end
end
