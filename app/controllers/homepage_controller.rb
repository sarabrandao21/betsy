class HomepageController < ApplicationController
  def index
    @top_ten = Product.popular_products
  end
end
