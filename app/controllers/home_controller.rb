class HomeController < ApplicationController
    def index
      @products = Product.all
      @categories = Category.all
      @vendors = Vendor.all

      @product_count = Product.count
      @high_quantity_products = Product.where("stock_quantity > ?", 40).order(stock_quantity: :desc).first
      @low_quantity_products = Product.where("stock_quantity <= ?", 10).first
      @latest_product = Product.order(created_at: :desc).first
    end
end
