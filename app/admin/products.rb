ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :category_id, :vendor_id, :sku, :cost_price, :selling_price, :stock_quantity, :min_stock_level
  #
  # or
  #
  permit_params do
    permitted = [:name, :description, :category_id, :vendor_id, :sku, :cost_price, :selling_price, :stock_quantity, :min_stock_level]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

end
