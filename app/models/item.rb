class Item < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :carts, through: :cart_items

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :description, length: { maximum: 500 }
end
