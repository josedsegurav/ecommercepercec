class User < ApplicationRecord
    has_many :orders, dependent: :nullify

    validates :email, presence: true, uniqueness: true

    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "email", "first_name", "id", "last_name", "phone", "updated_at"]
    end
    def self.ransackable_associations(auth_object = nil)
        ["orders"]
    end
end
