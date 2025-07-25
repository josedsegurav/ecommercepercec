class ProductsController < InheritedResources::Base

  private

    def product_params
      params.require(:product).permit(:name, :description, :category_id, :vendor_id, :sku, :cost_price, :selling_price, :stock_quantity, :min_stock_level)
    end

end
