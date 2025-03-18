class Order < ApplicationRecord
  belongs_to :cart
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items
  validates :total_price, :subtotal_price, numericality: { greater_than_or_equal_to: 0 }
  validates :applied_discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1000 }
end
