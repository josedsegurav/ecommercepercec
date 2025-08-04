class User < ApplicationRecord
    has_many :orders, dependent: :nullify

    validates :email, presence: true, uniqueness: true
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :phone, presence: true, format: { with: /\A\+?[0-9\s\-]+\z/, message: "only allows numbers, spaces, and dashes" }


    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "email", "first_name", "id", "last_name", "phone", "updated_at"]
    end
    def self.ransackable_associations(auth_object = nil)
        ["orders"]
    end
end
