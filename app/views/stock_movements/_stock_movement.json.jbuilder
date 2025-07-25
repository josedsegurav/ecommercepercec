json.extract! stock_movement, :id, :product_id, :movement_type, :quantity, :cost_per_unit, :reference_id, :notes, :movement_date, :created_at, :updated_at
json.url stock_movement_url(stock_movement, format: :json)
