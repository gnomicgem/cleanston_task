class Item < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_many :carts, -> { where(line_items: { lineable_type: "Cart" }) }, through: :line_items, source: :lineable
  has_many :orders, -> { where(line_items: { lineable_type: "Order" }) }, through: :line_items, source: :lineable

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :description, length: { maximum: 500 }
end
