class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :items, through: :cart_items
  has_many :orders, dependent: :destroy
  accepts_nested_attributes_for :cart_items
  validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1000 }
  before_save :calculate_subtotal_price

  def calculate_total_price(input_discount)
    begin
    Rails.logger.debug "Total before discount: #{subtotal_price}, discount: #{input_discount}"
    return subtotal_price if input_discount > discount
    @applied_discount = [input_discount, subtotal_price].min.to_i
    Rails.logger.debug "Total after discount: #{subtotal_price - @applied_discount}, discount: #{input_discount}"
    subtotal_price - @applied_discount
    rescue => e
      Rails.logger.error "Error in calculate_total_price: #{e.message}"
      subtotal_price
    end
  end

  def clear!
    ActiveRecord::Base.transaction do
      cart_items.destroy_all
      save
    end
  end

  private

  def calculate_subtotal_price
    self.subtotal_price = cart_items.sum(&:calculate_total_price)
  end

  def set_discount
    self.discount -= @applied_discount
  end
end
