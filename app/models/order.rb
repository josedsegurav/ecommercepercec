class Order < ApplicationRecord
    belongs_to :user, optional: true
    has_many :order_items, dependent: :destroy
    has_many :products, through: :order_items

    # Validations
    validates :customer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :customer_name, presence: true
    validates :customer_phone, presence: true
    validates :shipping_address, presence: true
    validates :order_number, presence: true, uniqueness: true
    validates :total_amount, presence: true, numericality: { greater_than: 0 }
    validates :status, presence: true
    validates :payment_status, presence: true

    def guest_order?
      user.nil?
    end

    def self.ransackable_attributes(auth_object = nil)
        ["billing_address", "created_at", "customer_email", "customer_name", "customer_phone", "id", "notes", "order_date", "order_number", "payment_method", "payment_status", "shipped_date", "shipping_address", "shipping_cost", "status", "subtotal", "tax_amount", "total_amount", "updated_at", "user_id", "products_id_eq"]
    end
    def self.ransackable_associations(auth_object = nil)
        ["order_items", "user"]
    end
end
