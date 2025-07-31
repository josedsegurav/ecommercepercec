class Product < ApplicationRecord
    belongs_to :category
    belongs_to :vendor
    has_many :order_items, dependent: :destroy
    has_many :stock_movements, dependent: :destroy
    has_many_attached :images
    def self.ransackable_attributes(auth_object = nil)
        ["category_id", "cost_price", "created_at", "description", "id", "min_stock_level", "name", "selling_price", "sku", "images_attachments_id_eq", "images_blobs_id_eq", "stock_quantity", "updated_at", "vendor_id"]
    end
    def self.ransackable_associations(auth_object = nil)
        ["category", "order_items", "stock_movements", "vendor"]
    end
end
