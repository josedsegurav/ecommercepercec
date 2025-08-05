ActiveAdmin.register Product do

  # Permit parameters including image
  permit_params :name, :description, :category_id, :vendor_id, :sku, :cost_price, :selling_price, :stock_quantity, :min_stock_level, :image

  # Customize the form to include file upload field
  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description
      f.input :category_id, as: :select, collection: Category.all
      f.input :vendor_id, as: :select, collection: Vendor.all
      f.input :sku
      f.input :cost_price
      f.input :selling_price
      f.input :stock_quantity
      f.input :min_stock_level
      f.input :image, as: :file
    end
    f.actions
  end

  # Customize the index page to show image thumbnail
  index do
    selectable_column
    id_column
    column :image do |product|
      if product.image.present?
        image_tag product.image, style: "width: 50px; height: 50px; object-fit: cover;"
      else
        "No image"
      end
    end
    column :name
    column :sku
    column :category
    column :vendor
    column :cost_price
    column :selling_price
    column :stock_quantity
    actions
  end

  # Customize the show page to display the image
  show do
    attributes_table do
      row :id
      row :image do |product|
        if product.image.present?
          image_tag product.image, style: "max-width: 300px; height: auto;"
        else
          "No image uploaded"
        end
      end
      row :name
      row :description
      row :category
      row :vendor
      row :sku
      row :cost_price
      row :selling_price
      row :stock_quantity
      row :min_stock_level
      row :created_at
      row :updated_at
    end
  end

end