class OrdersController < ApplicationController
  before_action :require_product, only: [:add_to_cart]

  def cart
    @order = Order.find_by(id: session[:order_id])
  end

  def add_to_cart
    order = session[:order_id] ? find_order(id: session[:order_id]) : create_order
    order_item = order.order_items.find_by(product_id: @product.id) 
    puts params[:quantity]
    
    if order_item && @product.stock >= 1 
      order_item.increment_quantity(params[:quantity])
    elsif @product.stock >= 1
      order_item = OrderItem.new(order: order, product: @product, quantity: params[:quantity])
    else 
      flash[:error] = "Unable to add #{@product.name} to your cart: sold out"
      redirect_back(fallback_location: root_path)
      return 
    end 
     
    if order_item.save
      flash[:success] = "Successfully added #{@product.name} to your cart"
    else
      flash[:error] = "Unable to add #{@product.name} to your cart: #{order_item.errors.messages}"
    end
    redirect_back(fallback_location: root_path)
  end

  def set_quantity 
    order_item = OrderItem.find_by(id: params[:order_item_id])
    order_item.set_quantity(params[:quantity])
    redirect_back(fallback_location: root_path)
  end 

  def destroy
    @order = Order.find_by(id: params[:id])

    if @order.nil?
      head :not_found
      return
    end

    @order.destroy
    flash[:success] = "We removed all items from your shopping cart" 

    session[:order_id] = nil
    redirect_to root_path
  end

  private

  def require_product
    @product = Product.find_by(id: params[:id]) 
    if @product.nil?
      flash[:error] = "A problem occured. We couldn't find this product."
      redirect_back(fallback_location: root_path)
    end
  end

  def find_order(id:)
    order = Order.find_by(id: id)
    if order.nil?
      flash[:error] = "A problem occured. We couldn't find your cart."
      return redirect_back(fallback_location: root_path)
    end
    return order
  end

  def create_order
    order = Order.new
    unless order.save
      flash[:error] = "Something went wrong: #{order.errors.messages}"
    end
    order.reload
    session[:order_id] = order.id
    return order
  end
end
