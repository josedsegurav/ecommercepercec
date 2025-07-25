class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :order_number
      t.string :customer_email
      t.string :customer_name
      t.string :customer_phone
      t.string :shipping_address
      t.string :billing_address
      t.decimal :subtotal
      t.decimal :tax_amount
      t.decimal :shipping_cost
      t.decimal :total_amount
      t.string :status
      t.string :payment_status
      t.string :payment_method
      t.string :notes
      t.datetime :order_date
      t.datetime :shipped_date

      t.timestamps
    end
  end
end
