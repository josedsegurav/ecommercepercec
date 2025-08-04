class OrdersController < InheritedResources::Base
  def show
    @order = Order.find(params[:id])

    if @order.guest_order? && session[:last_order_id] != @order.id
      redirect_to root_path, alert: "Order not found"
    end
  end
  private

    def order_params
      params.require(:order).permit(:user_id, :order_number, :customer_email, :customer_name, :customer_phone, :shipping_address, :billing_address, :subtotal, :tax_amount, :shipping_cost, :total_amount, :status, :payment_status, :payment_method, :notes, :order_date, :shipped_date)
    end

end
