class CreateVendors < ActiveRecord::Migration[8.0]
  def change
    create_table :vendors do |t|
      t.string :name
      t.string :contact_person
      t.string :email
      t.string :phone
      t.string :address

      t.timestamps
    end
  end
end
