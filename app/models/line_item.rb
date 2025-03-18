class LineItem < ApplicationRecord
  belongs_to :item
  belongs_to :lineable, polymorphic: true

  validates :amount, presence: true

  def calculate_total_price
    item.price * amount
  end
end
