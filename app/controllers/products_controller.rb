class ProductsController < InheritedResources::Base

  def index
    @products = Product.includes(:category, :vendor)
    @categories = Category.all
    @vendors = Vendor.all

    @product_count = Product.count
    @high_quantity_products = Product.where("stock_quantity > ?", 40).order(stock_quantity: :desc).first
    @low_quantity_products = Product.where("stock_quantity <= ?", 10).first
    @latest_product = Product.order(created_at: :desc).first

    # Apply search filter
    if params[:search].present?
      @products = apply_search_filter(@products, params[:search])
    end

    # Apply sorting
    @products = apply_sorting(@products, params[:sort_by])

    # Store total count before pagination
    @total_products = @products.count

    # Apply pagination with dynamic per_page
    per_page = params[:per_page]&.to_i || 12
    per_page = 12 unless [12, 24, 48].include?(per_page) # Security: only allow specific values
    @products = @products.page(params[:page]).per(per_page)

    # Store current filters for maintaining state
    @current_filters = {
      search: params[:search],
      category_id: params[:category_id],
      sort_by: params[:sort_by]
    }


  end

  def show
    @product = Product.find(params[:id])
    @categories = Category.all
    @category = @product.category
    @vendor = @product.vendor

    @related_products = Product.where(category: @product.category)
                              .where.not(id: @product.id)
                              .includes(:category, :vendor)
                              .limit(4)
  end

  private

    def product_params
      params.require(:product).permit(:name, :description, :category_id, :vendor_id, :sku, :cost_price, :selling_price, :stock_quantity, :min_stock_level)
    end

     def set_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: "Producto no encontrado"
  end

  def apply_search_filter(products, search_term)
    # Clean and prepare search term
    search_term = search_term.strip.downcase

    # Search in multiple fields: name, description, and vendor name
    products.left_joins(:vendor)
           .where(
             "LOWER(products.name) LIKE :search OR
              LOWER(products.description) LIKE :search OR
              LOWER(vendors.name) LIKE :search",
             search: "%#{search_term}%"
           )
  end

  def apply_sorting(products, sort_option)
    case sort_option
    when 'price_asc'
      products.order(:selling_price)
    when 'price_desc'
      products.order(selling_price: :desc)
    when 'name_asc'
      products.order(:name)
    when 'name_desc'
      products.order(name: :desc)
    when 'newest'
      products.order(created_at: :desc)
    when 'oldest'
      products.order(created_at: :asc)
    when 'stock_high'
      products.order(quantity: :desc)
    when 'stock_low'
      products.order(:quantity)
    else
      # Default sorting: newest first
      products.order(created_at: :desc)
    end
  end

end
