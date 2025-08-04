class Category < ApplicationRecord
    has_many :products, dependent: :destroy

    validates :name, presence: true, uniqueness: true
    validates :description, presence: true

    scope :root_categories, -> { where(parent_id: nil) }
    scope :with_products, -> { joins(:products).distinct }

    def product_count
      products.count
    end

    def price_range
      return nil unless products.any?

      min_price = products.minimum(:selling_price)
      max_price = products.maximum(:selling_price)

      { min: min_price, max: max_price }
    end

    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "name", "description", "id", "updated_at"]
    end
    def self.ransackable_associations(auth_object = nil)
        ["products"]
    end
end
