ActiveAdmin.register Order do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :order_number, :customer_email, :customer_name, :customer_phone, :shipping_address, :billing_address, :subtotal, :tax_amount, :shipping_cost, :total_amount, :status, :payment_status, :payment_method, :notes, :order_date, :shipped_date
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :order_number, :customer_email, :customer_name, :customer_phone, :shipping_address, :billing_address, :subtotal, :tax_amount, :shipping_cost, :total_amount, :status, :payment_status, :payment_method, :notes, :order_date, :shipped_date]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
