class ProductsController < InheritedResources::Base

  def index
    @products = Product.all
    @categories = Category.all
    @vendors = Vendor.all

    @product_count = Product.count
    @high_quantity_products = Product.where("stock_quantity > ?", 40).order(stock_quantity: :desc).first
    @low_quantity_products = Product.where("stock_quantity <= ?", 10).first
    @latest_product = Product.order(created_at: :desc).first
  end

  def show
    @product = Product.find(params[:id])
    @categories = Category.all
    @category = @product.category
    @vendor = @product.vendor

    @related_products = Product.where(category: @product.category)
                              .where.not(id: @product.id)
                              .includes(:category, :vendor, images_attachments: :blob)
                              .limit(4)
  end

  private

    def product_params
      params.require(:product).permit(:name, :description, :category_id, :vendor_id, :sku, :cost_price, :selling_price, :stock_quantity, :min_stock_level)
    end

end
