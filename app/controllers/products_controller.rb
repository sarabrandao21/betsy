class ProductsController < ApplicationController

  before_action :find_product, only: [:show, :edit, :update, :destroy]
  before_action :check_product, only: [:show, :edit, :update, :destroy]
  before_action :find_merchant, only: [:new, :create, :edit, :update]
  
  def index
    @products = Product.all
  end

  def show
    @review = Review.new
  end


  def new
    if @login_merchant
      @product = Product.new
    else
      flash[:error] = "You must login to add new product!"
      redirect_to products_path
      return
    end
  end

  def create
    if @login_merchant
      @product = Product.new(product_params)
      @product.merchant = @login_merchant
      if @product.save
        flash[:success] = "Successfully created #{@product.name}"
        redirect_to products_path
        return
      else
        flash[:error] = "Couldn't create product! #{@product.errors.messages}"
        render :new, status: :bad_request
      end
    else
      flash[:error] = @product.errors.messages
      redirect_to products_path
      return
    end
  end

  def edit
    if !(@login_merchant == @product.merchant)
      flash[:error] = "You are not authorized to edit this product!"
      redirect_to products_path
      return
    end
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
    params.require(:product).permit(:name, :description, :price, :image, :stock, :rating)
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
