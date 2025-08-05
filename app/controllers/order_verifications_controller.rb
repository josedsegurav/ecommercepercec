class OrderVerificationsController < ApplicationController
  def show
    @order = Order.find_by(id: params[:id])

    unless @order&.guest_order?
      redirect_to orders_path, alert: "Order not found"
      return
    end

    # If already verified, redirect to order
    if session[:accessible_order_ids]&.include?(@order.id) || session[:last_order_id] == @order.id
      redirect_to order_path(@order)
    end
  end

  def verify
    @order = Order.find_by(id: params[:id])
    email = params[:email]&.strip&.downcase

    unless @order&.guest_order?
      redirect_to orders_path, alert: "Order not found"
      return
    end

    if @order.customer_email&.downcase == email
      # Grant access to this order
      session[:accessible_order_ids] ||= []
      session[:accessible_order_ids] << @order.id
      session[:accessible_order_ids].uniq!

      redirect_to order_path(@order), notice: "Order verified successfully!"
    else
      redirect_to verify_order_path(@order), alert: "Email doesn't match our records."
    end
  end
end