class StockMovementsController < InheritedResources::Base

  private

    def stock_movement_params
      params.require(:stock_movement).permit(:product_id, :movement_type, :quantity, :cost_per_unit, :reference_id, :notes, :movement_date)
    end

end
