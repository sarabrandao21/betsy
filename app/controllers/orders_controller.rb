class OrdersController < ApplicationController
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
end
