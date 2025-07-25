class Order < ApplicationRecord
    belongs_to :user
    has_many :order_items, dependent: :destroy
    def self.ransackable_attributes(auth_object = nil)
        ["billing_address", "created_at", "customer_email", "customer_name", "customer_phone", "id", "notes", "order_date", "order_number", "payment_method", "payment_status", "shipped_date", "shipping_address", "shipping_cost", "status", "subtotal", "tax_amount", "total_amount", "updated_at", "user_id"]
    end
    def self.ransackable_associations(auth_object = nil)
        ["order_items", "user"]
    end
end
