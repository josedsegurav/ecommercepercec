class Vendor < ApplicationRecord
    has_many :products, dependent: :destroy

    validates :name, presence: true, uniqueness: true
    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
    validates :phone, presence: true, format: { with: /\A\+?[0-9\s\-]+\z/, message: "only allows numbers, spaces, and dashes" }
    validates :contact_person, presence: true

    def self.ransackable_attributes(auth_object = nil)
        ["address", "contact_person", "created_at", "email", "id", "name", "phone", "updated_at"]
    end
    def self.ransackable_associations(auth_object = nil)
        ["products"]
    end
end
