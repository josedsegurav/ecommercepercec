class Category < ApplicationRecord
    has_many :products, dependent: :destroy
    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "name", "description", "id", "updated_at"]
    end
    def self.ransackable_associations(auth_object = nil)
        ["products"]
    end
end
