class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.integer :category_id
      t.integer :vendor_id
      t.string :sku
      t.decimal :cost_price
      t.decimal :selling_price
      t.integer :stock_quantity
      t.integer :min_stock_level

      t.timestamps
    end
  end
end
