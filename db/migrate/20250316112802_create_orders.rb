class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :cart, null: false, foreign_key: true
      t.decimal :subtotal_price, precision: 10, scale: 2, null: false
      t.decimal :applied_discount, precision: 10, scale: 2, default: 0.0
      t.decimal :total_price, precision: 10, scale: 2, null: false
      t.string :status, default: "оформлен"
      t.timestamps
    end
  end
end
