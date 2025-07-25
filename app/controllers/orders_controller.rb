class OrdersController < InheritedResources::Base

  private

    def order_params
      params.require(:order).permit(:user_id, :order_number, :customer_email, :customer_name, :customer_phone, :shipping_address, :billing_address, :subtotal, :tax_amount, :shipping_cost, :total_amount, :status, :payment_status, :payment_method, :notes, :order_date, :shipped_date)
    end

end
