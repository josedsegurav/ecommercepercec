ActiveAdmin.register StockMovement do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :product_id, :movement_type, :quantity, :cost_per_unit, :reference_id, :notes, :movement_date
  #
  # or
  #
  permit_params do
    permitted = [:product_id, :movement_type, :quantity, :cost_per_unit, :reference_id, :notes, :movement_date]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

end
