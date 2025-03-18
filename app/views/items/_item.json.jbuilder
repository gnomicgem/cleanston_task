json.extract! item, :id, :name, :category, :description, :price, :stock_quantity, :image, :created_at, :updated_at
json.url item_url(item, format: :json)
