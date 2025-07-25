require "test_helper"

class StockMovementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stock_movement = stock_movements(:one)
  end

  test "should get index" do
    get stock_movements_url
    assert_response :success
  end

  test "should get new" do
    get new_stock_movement_url
    assert_response :success
  end

  test "should create stock_movement" do
    assert_difference("StockMovement.count") do
      post stock_movements_url, params: { stock_movement: { cost_per_unit: @stock_movement.cost_per_unit, movement_date: @stock_movement.movement_date, movement_type: @stock_movement.movement_type, notes: @stock_movement.notes, product_id: @stock_movement.product_id, quantity: @stock_movement.quantity, reference_id: @stock_movement.reference_id } }
    end

    assert_redirected_to stock_movement_url(StockMovement.last)
  end

  test "should show stock_movement" do
    get stock_movement_url(@stock_movement)
    assert_response :success
  end

  test "should get edit" do
    get edit_stock_movement_url(@stock_movement)
    assert_response :success
  end

  test "should update stock_movement" do
    patch stock_movement_url(@stock_movement), params: { stock_movement: { cost_per_unit: @stock_movement.cost_per_unit, movement_date: @stock_movement.movement_date, movement_type: @stock_movement.movement_type, notes: @stock_movement.notes, product_id: @stock_movement.product_id, quantity: @stock_movement.quantity, reference_id: @stock_movement.reference_id } }
    assert_redirected_to stock_movement_url(@stock_movement)
  end

  test "should destroy stock_movement" do
    assert_difference("StockMovement.count", -1) do
      delete stock_movement_url(@stock_movement)
    end

    assert_redirected_to stock_movements_url
  end
end
