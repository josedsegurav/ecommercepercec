class CartController < ApplicationController
  def index
    @cart_items = (session[:cart] || []).map do |item|
      product = Product.find(item["product_id"])
      { product: product, quantity: item["quantity"], total: product.selling_price * item["quantity"], image_url: product.image.attached? ? url_for(product.image) : nil }
    end
  end

  def add
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i
    quantity = 1 if quantity < 1 # fallback
    session[:cart] ||= []
    existing_item = session[:cart].find { |i| i["product_id"] == product.id }

    if existing_item
      existing_item["quantity"] += quantity
    else
      session[:cart] << { "product_id" => product.id, "quantity" => quantity }
    end

    redirect_to cart_index_path, notice: "#{product.name} added to cart."
  end

  def update_item
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_i

    session[:cart] ||= []
    item = session[:cart].find { |i| i["product_id"] == product_id }

    if item
      item["quantity"] = quantity if quantity > 0
    end

    render json: { success: true, cart: session[:cart] }
  end

  def remove_item
    product_id = params[:product_id].to_i
    session[:cart] ||= []
    session[:cart].reject! { |i| i["product_id"] == product_id }

    render json: { success: true, cart: session[:cart] }

  end

  def clear
    session[:cart] = []
    render json: { success: true, cart: [] }
  end

  # FIXED: Enhanced checkout method with better error handling and JSON responses
  def checkout
      Rails.logger.info "Checkout request received with params: #{params.inspect}"
      Rails.logger.info "Request format: #{request.format}"
      Rails.logger.info "Content type: #{request.content_type}"

      begin
        # Find user if logged in
        user = User.find_by(id: session[:user_id]) if session[:user_id]

        # Validate cart is not empty
        cart_items = session[:cart] || []
        if cart_items.empty?
          raise StandardError, "Cart is empty"
        end

        # Generate unique order number
        order_number = generate_order_number

        # Calculate totals from cart
        subtotal = calculate_subtotal(cart_items)
        shipping_cost = calculate_shipping_cost(params[:shipping_option])
        tax_amount = calculate_tax_amount(subtotal)
        total_amount = subtotal + shipping_cost + tax_amount

        # Log calculated values
        Rails.logger.info "Calculated values - Subtotal: #{subtotal}, Tax: #{tax_amount}, Shipping: #{shipping_cost}, Total: #{total_amount}"

        # Create the order with all fields (user can be nil for guest checkout)
        order = Order.create!(
          user: user, # This will be nil for guest customers
          order_number: order_number,
          customer_email: params[:customer_email],
          customer_name: params[:customer_name],
          customer_phone: params[:customer_phone],
          shipping_address: params[:shipping_address],
          billing_address: params[:billing_address] || params[:shipping_address],
          subtotal: subtotal,
          tax_amount: tax_amount,
          shipping_cost: shipping_cost,
          total_amount: total_amount,
          status: 'pending',
          payment_status: 'pending',
          payment_method: params[:payment_method],
          notes: params[:notes],
          order_date: Time.current
        )

        Rails.logger.info "Order created with ID: #{order.id}"

        # Create order items
        cart_items.each do |item|
          product = Product.find(item["product_id"])
          order_item = order.order_items.create!(
            product: product,
            quantity: item["quantity"],
            unit_price: product.selling_price,
            total_price: product.selling_price * item["quantity"]
          )
          Rails.logger.info "Created order item: #{order_item.id} for product: #{product.name}"
        end

        # Clear the cart
        session[:cart] = []
        session[:last_order_id] = order.id
        Rails.logger.info "Cart cleared and order ID stored in session"

        # Always return JSON response
        response_data = {
          success: true,
          order_id: order.id,
          order_number: order.order_number,
          redirect_url: order_path(order),
          message: "Order placed successfully! Order ##{order.order_number}"
        }

        Rails.logger.info "Sending success response: #{response_data.inspect}"

        respond_to do |format|
          format.json { render json: response_data }
          format.html { redirect_to order_path(order), notice: "Order placed successfully! Order ##{order.order_number}" }
        end

      rescue ActiveRecord::RecordInvalid => e
        error_message = "Validation error: #{e.record.errors.full_messages.join(', ')}"
        Rails.logger.error "Checkout validation error: #{error_message}"

        respond_to do |format|
          format.json { render json: { success: false, error: error_message }, status: :unprocessable_entity }
          format.html { redirect_to cart_index_path, alert: error_message }
        end

      rescue ActiveRecord::RecordNotFound => e
        error_message = "Product not found: #{e.message}"
        Rails.logger.error "Checkout error: #{error_message}"

        respond_to do |format|
          format.json { render json: { success: false, error: error_message }, status: :not_found }
          format.html { redirect_to cart_index_path, alert: error_message }
        end

      rescue => e
        error_message = "There was an error processing your order: #{e.message}"
        Rails.logger.error "Checkout error: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")

        respond_to do |format|
          format.json { render json: { success: false, error: error_message }, status: :internal_server_error }
          format.html { redirect_to cart_index_path, alert: error_message }
        end
      end
    end

    private

    def generate_order_number
      timestamp = Time.current.strftime("%Y%m%d")
      random_digits = rand(1000..9999)
      "PE#{timestamp}#{random_digits}"
    end

    def calculate_subtotal(cart_items)
      cart_items.sum do |item|
        product = Product.find(item["product_id"])
        product.selling_price * item["quantity"]
      end
    end

    def calculate_shipping_cost(shipping_option)
      case shipping_option&.to_s
      when 'express'
        5.00
      when 'standard', 'pickup'
        0.00
      else
        0.00
      end
    end

    def calculate_tax_amount(subtotal)
      # Ecuador IVA is 12%
      tax_rate = 0.12
      subtotal * tax_rate
    end

    def checkout_params
      params.permit(
        :customer_name, :customer_email, :customer_phone,
        :shipping_address, :billing_address, :payment_method,
        :notes, :shipping_option, :subtotal, :tax_amount,
        :shipping_cost, :total_amount
      )
  end
end
