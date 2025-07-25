json.extract! product, :id, :name, :description, :category_id, :vendor_id, :sku, :cost_price, :selling_price, :stock_quantity, :min_stock_level, :created_at, :updated_at
json.url product_url(product, format: :json)
