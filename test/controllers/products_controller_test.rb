require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference("Product.count") do
      post products_url, params: { product: { category_id: @product.category_id, cost_price: @product.cost_price, description: @product.description, min_stock_level: @product.min_stock_level, name: @product.name, selling_price: @product.selling_price, sku: @product.sku, stock_quantity: @product.stock_quantity, vendor_id: @product.vendor_id } }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: { category_id: @product.category_id, cost_price: @product.cost_price, description: @product.description, min_stock_level: @product.min_stock_level, name: @product.name, selling_price: @product.selling_price, sku: @product.sku, stock_quantity: @product.stock_quantity, vendor_id: @product.vendor_id } }
    assert_redirected_to product_url(@product)
  end

  test "should destroy product" do
    assert_difference("Product.count", -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end
end
