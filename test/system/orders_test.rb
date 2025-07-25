require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  test "should create order" do
    visit orders_url
    click_on "New order"

    fill_in "Billing address", with: @order.billing_address
    fill_in "Customer email", with: @order.customer_email
    fill_in "Customer name", with: @order.customer_name
    fill_in "Customer phone", with: @order.customer_phone
    fill_in "Notes", with: @order.notes
    fill_in "Order date", with: @order.order_date
    fill_in "Order number", with: @order.order_number
    fill_in "Payment method", with: @order.payment_method
    fill_in "Payment status", with: @order.payment_status
    fill_in "Shipped date", with: @order.shipped_date
    fill_in "Shipping address", with: @order.shipping_address
    fill_in "Shipping cost", with: @order.shipping_cost
    fill_in "Status", with: @order.status
    fill_in "Subtotal", with: @order.subtotal
    fill_in "Tax amount", with: @order.tax_amount
    fill_in "Total amount", with: @order.total_amount
    fill_in "User", with: @order.user_id
    click_on "Create Order"

    assert_text "Order was successfully created"
    click_on "Back"
  end

  test "should update Order" do
    visit order_url(@order)
    click_on "Edit this order", match: :first

    fill_in "Billing address", with: @order.billing_address
    fill_in "Customer email", with: @order.customer_email
    fill_in "Customer name", with: @order.customer_name
    fill_in "Customer phone", with: @order.customer_phone
    fill_in "Notes", with: @order.notes
    fill_in "Order date", with: @order.order_date.to_s
    fill_in "Order number", with: @order.order_number
    fill_in "Payment method", with: @order.payment_method
    fill_in "Payment status", with: @order.payment_status
    fill_in "Shipped date", with: @order.shipped_date.to_s
    fill_in "Shipping address", with: @order.shipping_address
    fill_in "Shipping cost", with: @order.shipping_cost
    fill_in "Status", with: @order.status
    fill_in "Subtotal", with: @order.subtotal
    fill_in "Tax amount", with: @order.tax_amount
    fill_in "Total amount", with: @order.total_amount
    fill_in "User", with: @order.user_id
    click_on "Update Order"

    assert_text "Order was successfully updated"
    click_on "Back"
  end

  test "should destroy Order" do
    visit order_url(@order)
    click_on "Destroy this order", match: :first

    assert_text "Order was successfully destroyed"
  end
end
