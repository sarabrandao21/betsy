class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])
  end


  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "Successfully created #{@product.name}"
      redirect_to product_path(@product)
    else
      flash[:error] = "Couldn't create product!"
      render :new, status: :bad_request
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])
  end

  def update
    if @product.update(product_params)
      flash[:success] = "Successfully edited #{@product.name}"
      redirect_to product_path(@product)
    else
      flash[:error] = "Couldn't edit this product!"
      render :edit, status: :bad_request
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :image, :stock, :rating)
  end
end
