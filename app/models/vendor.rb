class Vendor < ApplicationRecord
    has_many :products, dependent: :destroy
    def self.ransackable_attributes(auth_object = nil)
        ["address", "contact_person", "created_at", "email", "id", "name", "phone", "updated_at"]
    end
    def self.ransackable_associations(auth_object = nil)
        ["products"]
    end
end
