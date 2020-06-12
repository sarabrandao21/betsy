class OrdersController < ApplicationController

  def show
    @order = Order.find_by(id: session[:order_id])
  end

  def create
    if session[:order_id]
      product = Product.find_by(id: params[:id])

      order = Order.find_by(id: session[:order_id])
      
      order_item = OrderItem.create(
        order: order,
        product: product)
    else 
      product = Product.find_by(id: params[:id])

      order = Order.create
      id = order.id
      order = Order.find_by(id: id)

      order_item = OrderItem.create(
        order: order,
        product: product)
      
      session[:order_id] = order.id
    end
  end

  def destroy
    @order = Order.find_by(id: params[:id])

    if @order.nil?
      head :not_found
      return
    end

    @order.order_items.each do |order_item|
      order_item.destroy
    end

    @order.destroy
    flash[:success] = "We removed all items from your shopping cart" 

    session[:order_id] = nil
    redirect_to root_path
  end
end
