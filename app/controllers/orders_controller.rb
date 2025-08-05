class OrdersController < InheritedResources::Base
  def index
    @orders = []

    if params[:search].present?
      search_term = params[:search].strip

      # Build the search query
      @orders = Order.includes(:order_items, :user, order_items: :product)

      # Search by order number format (PE202508041065) or database ID
      if search_term.match(/^#?PE\d{12}$/i)
        # Order number format search (case insensitive)
        order_num = search_term.gsub('#', '').upcase
        @orders = @orders.where("UPPER(order_number) = ?", order_num)

      else
        # General search across customer name and order_number
        @orders = @orders.where(
          "customer_name ILIKE ? OR order_number ILIKE ? OR users.name ILIKE ?",
          "%#{search_term}%", "%#{search_term.upcase}%", "%#{search_term}%"
        ).left_joins(:user)
      end

      # Order by most recent first
      @orders = @orders.order(created_at: :desc).limit(10)

      # Filter guest orders that don't belong to current session
      @orders = @orders.select do |order|
        if order.guest_order?
          # Allow access if it's the last order created in this session
          # or if it matches the search exactly by ID or order_number
          session[:last_order_id] == order.id ||
          (search_term.match(/^#?#{order.id}$/) || search_term.match(/^#?#{order.order_number}$/i)) && order.customer_email.present?
        else
          true
        end
      end
    end
  end

  def show
    @order = Order.find(params[:id])

    # if @order.guest_order? && session[:last_order_id] != @order.id
    #   redirect_to root_path, alert: "Order not found"
    # end
  end

  def authorized_orders
    # For now, only allow guest orders from current session
    # This can be expanded when user authentication is implemented
    guest_orders = Order.where(user_id: nil)

    if session[:accessible_order_ids].present?
      # Orders that have been verified in this session
      verified_orders = guest_orders.where(id: session[:accessible_order_ids])
    else
      verified_orders = Order.none
    end

    # Also include the last order created in this session
    if session[:last_order_id].present?
      session_order = guest_orders.where(id: session[:last_order_id])
      verified_orders = verified_orders.or(session_order)
    end

    verified_orders
  end

  # Alternative method: Email verification for guest orders
  def verify_guest_order_access
    order = Order.find_by(id: params[:id])
    return false unless order&.guest_order?

    # Check if order is already verified in session
    return true if session[:accessible_order_ids]&.include?(order.id)
    return true if session[:last_order_id] == order.id

    # If not verified, redirect to verification page
    session[:pending_order_id] = order.id
    redirect_to verify_order_path(order.id)
    false
  end

  private

  def order_params
    params.require(:order).permit(:user_id, :order_number, :customer_email, :customer_name, :customer_phone, :shipping_address, :billing_address, :subtotal, :tax_amount, :shipping_cost, :total_amount, :status, :payment_status, :payment_method, :notes, :order_date, :shipped_date)
  end
end