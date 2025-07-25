require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @order = orders(:one)
  end

  test "should get index" do
    get orders_url
    assert_response :success
  end

  test "should get new" do
    get new_order_url
    assert_response :success
  end

  test "should create order" do
    assert_difference("Order.count") do
      post orders_url, params: { order: { billing_address: @order.billing_address, customer_email: @order.customer_email, customer_name: @order.customer_name, customer_phone: @order.customer_phone, notes: @order.notes, order_date: @order.order_date, order_number: @order.order_number, payment_method: @order.payment_method, payment_status: @order.payment_status, shipped_date: @order.shipped_date, shipping_address: @order.shipping_address, shipping_cost: @order.shipping_cost, status: @order.status, subtotal: @order.subtotal, tax_amount: @order.tax_amount, total_amount: @order.total_amount, user_id: @order.user_id } }
    end

    assert_redirected_to order_url(Order.last)
  end

  test "should show order" do
    get order_url(@order)
    assert_response :success
  end

  test "should get edit" do
    get edit_order_url(@order)
    assert_response :success
  end

  test "should update order" do
    patch order_url(@order), params: { order: { billing_address: @order.billing_address, customer_email: @order.customer_email, customer_name: @order.customer_name, customer_phone: @order.customer_phone, notes: @order.notes, order_date: @order.order_date, order_number: @order.order_number, payment_method: @order.payment_method, payment_status: @order.payment_status, shipped_date: @order.shipped_date, shipping_address: @order.shipping_address, shipping_cost: @order.shipping_cost, status: @order.status, subtotal: @order.subtotal, tax_amount: @order.tax_amount, total_amount: @order.total_amount, user_id: @order.user_id } }
    assert_redirected_to order_url(@order)
  end

  test "should destroy order" do
    assert_difference("Order.count", -1) do
      delete order_url(@order)
    end

    assert_redirected_to orders_url
  end
end
