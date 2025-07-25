class CreateStockMovements < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_movements do |t|
      t.integer :product_id
      t.string :movement_type
      t.integer :quantity
      t.decimal :cost_per_unit
      t.integer :reference_id
      t.string :notes
      t.date :movement_date

      t.timestamps
    end
  end
end
