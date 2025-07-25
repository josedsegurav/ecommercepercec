json.extract! order, :id, :user_id, :order_number, :customer_email, :customer_name, :customer_phone, :shipping_address, :billing_address, :subtotal, :tax_amount, :shipping_cost, :total_amount, :status, :payment_status, :payment_method, :notes, :order_date, :shipped_date, :created_at, :updated_at
json.url order_url(order, format: :json)
