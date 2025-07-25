require "application_system_test_case"

class StockMovementsTest < ApplicationSystemTestCase
  setup do
    @stock_movement = stock_movements(:one)
  end

  test "visiting the index" do
    visit stock_movements_url
    assert_selector "h1", text: "Stock movements"
  end

  test "should create stock movement" do
    visit stock_movements_url
    click_on "New stock movement"

    fill_in "Cost per unit", with: @stock_movement.cost_per_unit
    fill_in "Movement date", with: @stock_movement.movement_date
    fill_in "Movement type", with: @stock_movement.movement_type
    fill_in "Notes", with: @stock_movement.notes
    fill_in "Product", with: @stock_movement.product_id
    fill_in "Quantity", with: @stock_movement.quantity
    fill_in "Reference", with: @stock_movement.reference_id
    click_on "Create Stock movement"

    assert_text "Stock movement was successfully created"
    click_on "Back"
  end

  test "should update Stock movement" do
    visit stock_movement_url(@stock_movement)
    click_on "Edit this stock movement", match: :first

    fill_in "Cost per unit", with: @stock_movement.cost_per_unit
    fill_in "Movement date", with: @stock_movement.movement_date
    fill_in "Movement type", with: @stock_movement.movement_type
    fill_in "Notes", with: @stock_movement.notes
    fill_in "Product", with: @stock_movement.product_id
    fill_in "Quantity", with: @stock_movement.quantity
    fill_in "Reference", with: @stock_movement.reference_id
    click_on "Update Stock movement"

    assert_text "Stock movement was successfully updated"
    click_on "Back"
  end

  test "should destroy Stock movement" do
    visit stock_movement_url(@stock_movement)
    click_on "Destroy this stock movement", match: :first

    assert_text "Stock movement was successfully destroyed"
  end
end
