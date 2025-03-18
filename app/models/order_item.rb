class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  validates :amount, presence: true
end
