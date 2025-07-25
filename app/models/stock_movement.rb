class StockMovement < ApplicationRecord
    belongs_to :product
    def self.ransackable_attributes(auth_object = nil)
        ["cost_per_unit", "created_at", "id", "movement_date", "movement_type", "notes", "product_id", "quantity", "reference_id", "updated_at"]
    end
    def self.ransackable_associations(auth_object = nil)
        ["product"]
    end
end
