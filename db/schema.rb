# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_18_065200) do
  create_table "carts", force: :cascade do |t|
    t.decimal "subtotal_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "discount", precision: 10, scale: 2, default: "1000.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.string "category"
    t.text "description"
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "stock_quantity"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "item_id", null: false
    t.string "lineable_type", null: false
    t.integer "lineable_id", null: false
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_line_items_on_item_id"
    t.index ["lineable_type", "lineable_id"], name: "index_line_items_on_lineable"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "cart_id", null: false
    t.decimal "subtotal_price", precision: 10, scale: 2, null: false
    t.decimal "applied_discount", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.string "status", default: "оформлен"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_orders_on_cart_id"
  end

  add_foreign_key "line_items", "items"
  add_foreign_key "orders", "carts"
end
