# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

require 'csv'

products_csv_file_path = Rails.root.join('db', 'products.csv')
categories_csv_file_path = Rails.root.join('db', 'categories.csv')

products = CSV.read(products_csv_file_path, headers: true)
categories = CSV.read(categories_csv_file_path, headers: true)

puts "Seeding Categories..."
categories.each do |row|
  category = Category.find_or_create_by!(
    name: row['category'],
    description: row['description']
  )
  if category.persisted?
    puts "Created Category: #{category.name} with ID: #{category.id}"
  else
    puts "Failed to create Category: #{row['category']}"
  end

end

puts "Seeding Vendors..."

products.each do |row|
    vendor = Vendor.find_or_create_by!(
        name: row['Proveedor'],
        contact_person: row['Nombre'],
        email: row['email']
    )
    if vendor.persisted?
        puts "Created Vendor: #{vendor.name} with ID: #{vendor.id}"
    else
        puts "Failed to create Vendor: #{row['Proveedor']}"
    end
end

puts "Seeding Products..."

products.each do |row|

    product = Product.find_or_create_by!(
        name: row['Item'],
        description: row['Descripcion'],
        category_id: Category.find_or_create_by!(name: row['Categoria']).id,
        vendor_id: Vendor.find_or_create_by!(name: row['Proveedor']).id,
        cost_price: row['Costo'],
        selling_price: row['PVP'],
        stock_quantity: row['ctd']
    )

    if product.persisted?
        puts "Created Product: #{product.name} with ID: #{product.id}"
    else
        puts "Failed to create Product: #{row['Item']}"
    end
end