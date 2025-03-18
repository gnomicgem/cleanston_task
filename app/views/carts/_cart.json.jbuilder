json.extract! cart, :id, :subtotal_price, :discount, :created_at, :updated_at
json.url cart_url(cart, format: :json)
