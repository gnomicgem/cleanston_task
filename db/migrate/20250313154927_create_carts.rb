class CreateCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :carts do |t|
      t.decimal :subtotal_price, precision: 10, scale: 2, default: 0.0
      t.decimal :discount, precision: 10, scale: 2, default: 1000.0

      t.timestamps
    end
  end
end
