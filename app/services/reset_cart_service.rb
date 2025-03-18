class ResetCartService
  DEFAULT_DISCOUNT = 1000
  DEFAULT_ITEMS = [
    { name: "Беспроводная колонка Goodyear Bluetooth Speaker", price: 1600, category: "Техника", image: "items/speaker.svg", amount: 1 },
    { name: "Женский домашний костюм Sweet Dreams", price: 800, category: "Одежда", image: "items/pajamas.svg", amount: 1 },
    { name: "Плащ-дождевик SwissOak", price: 400, category: "Одежда", image: "items/coat.svg", amount: 2 }
  ].freeze

  def initialize(cart)
    @cart = cart
  end

  def call
    ActiveRecord::Base.transaction do
      @cart.update!(discount: DEFAULT_DISCOUNT)
      add_default_items
      @cart.save!
    end
  end

  private

  def add_default_items
    DEFAULT_ITEMS.each do |item_data|
      item = Item.find_or_create_by!(
        name: item_data[:name],
        price: item_data[:price],
        category: item_data[:category],
        image: item_data[:image]
      )
      @cart.line_items.find_or_create_by!(item: item, amount: item_data[:amount])
    end
  end
end
