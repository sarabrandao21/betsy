class OrdersController < ApplicationController
  before_action :require_product, only: [:add_to_cart]

  def cart
    @order = Order.find_by(id: session[:order_id])
  end

  def add_to_cart
    order = session[:order_id] ? find_order(id: session[:order_id]) : create_order
    order_item = OrderItem.new(order: order, product: @product)

    if order_item.save
      flash[:success] = "Successfully added #{@product.name} to your cart"
    else
      flash[:error] = "Unable to add #{@product.name} to your cart: #{order_item.errors.messages}"
    end

    redirect_back(fallback_location: root_path)
  end

  def confirmation
    @order = find_order(id: session[:order_id])
    @order.order_items.each do |order_item|
      if order_item.status == "pending"
        flash[:error] = "You haven't completed the order yet. Please proceed to checkout."
        redirect_to cart_path
      end
    end
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
