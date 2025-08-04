class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :load_categories
  before_action :set_cart


  private

  def load_categories
    @categories = Category.all
  end
  def set_cart
    @cart_count = session[:cart]&.sum { |item| item["quantity"] } || 0
  end

end
