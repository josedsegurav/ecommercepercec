class Product < ApplicationRecord
    belongs_to :category
    belongs_to :vendor
    has_many :order_items, dependent: :destroy
    has_many :stock_movements, dependent: :destroy
    has_one_attached :image

    validates :name, presence: true
    validates :description, presence: true
    validates :sku, presence: true, uniqueness: true
    validates :cost_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :selling_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :min_stock_level, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :category_id, presence: true
    validates :vendor_id, presence: true

    def self.ransackable_attributes(auth_object = nil)
        ["category_id", "cost_price", "created_at", "description", "id", "min_stock_level", "name", "selling_price", "sku", "image_attachment_id_eq", "image_blob_id_eq", "stock_quantity", "updated_at", "vendor_id"]
    end
    def self.ransackable_associations(auth_object = nil)
        ["category", "order_items", "stock_movements", "vendor"]
    end
end
