class CreateLineItems < ActiveRecord::Migration[8.0]
  def change
    create_table :line_items do |t|
      t.references :item, null: false, foreign_key: true
      t.references :lineable, polymorphic: true, null: false
      t.integer :amount, null: false

      t.timestamps
    end
  end
end
