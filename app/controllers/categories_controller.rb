class CategoriesController < InheritedResources::Base
 def index
    @categories = Category.includes(:products)
                         .left_joins(:products)
                         .group('categories.id')
                         .order(:name)

    # Get popular categories (categories with most products)
    @popular_categories = Category.joins(:products)
                                 .group('categories.id')
                                 .order('COUNT(products.id) DESC')
                                 .limit(4)

    @category_count = Category.count

    @product_categories_count = Category.joins(:products).count

    @vendor_categories_count = Category.joins(:products).distinct.count('products.vendor_id')
  end

  def show
    @category = Category.find(params[:id])
    redirect_to products_path(category_id: @category.id)
  end

end
