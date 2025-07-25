class OrderItemsController < InheritedResources::Base

  private

    def order_item_params
      params.require(:order_item).permit(:order_id, :product_id, :quantity, :unit_price, :total_price)
    end

end
