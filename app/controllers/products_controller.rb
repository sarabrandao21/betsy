class ProductsController < ApplicationController

  before_action :find_product, only: [:show, :edit, :update, :destroy]
  before_action :check_product, only: [:show, :edit, :update, :destroy]
  
  def index
    @products = Product.all
  end

  def show
  end


  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "Successfully created #{@product.name}"
      redirect_to products_path
    else
      flash[:error] = "Couldn't create product! #{@product.errors.messages}"
      render :new, status: :bad_request
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:success] = "Successfully updated #{@product.name}"
      redirect_to product_path(@product.id)
    else
      flash[:error] = "Couldn't update this product!"
      render :edit, status: :bad_request
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path
    flash[:success] = "Product successfully removed."
    return
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :image, :stock, :rating, :merchant_id)
  end

  def find_product
    @product = Product.find_by(id: params[:id])
  end

  #helper method to react properly to check if the product is not found
  def check_product
    if @product.nil?
      redirect_to products_path, notice: "Product not found!😢"
      return
    end
  end
end
