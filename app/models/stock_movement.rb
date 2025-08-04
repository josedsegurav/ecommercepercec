class StockMovement < ApplicationRecord
    belongs_to :product

    validates :movement_type, presence: true, inclusion: { in: %w[incoming outgoing adjustment] }
    validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :movement_date, presence: true
    validates :cost_per_unit, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
    validates :reference_id, presence: true, uniqueness: true

    def self.ransackable_attributes(auth_object = nil)
        ["cost_per_unit", "created_at", "id", "movement_date", "movement_type", "notes", "product_id", "quantity", "reference_id", "updated_at"]
    end

    def self.ransackable_associations(auth_object = nil)
        ["product"]
    end
end
