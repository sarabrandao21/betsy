class OrderItemController < ApplicationController
  before_action :find_order_item, except: [:create ]
  
  def create
    new_quantity = params["quantity"]
    new_product_id = params["product_id"]
    if session [:order_id]==nil || session[:order_id] == false || !session[:order_id]
      @order = Order.create(cart_status: "pending")
      session[:order_id] = @order.id 
    else
      @order = Order.find_by(id:session[:order_id])
  end
    
      @order.order_items << OrderItem.create(
      quantity: new_quantity,
      product_id: new_product_id,
      order_id: order.id
    )
  end 

  def update 
    @order_item.quantity = params[:new_quantity]    
    @order_item.save 
    flash[:success] = "Quantity adjusted"
    redirect_to order_path(session[:order_id])
  end 

  private
  def order_item_params
    return params.require(:order_item).permit(:quantity, :product_id)
  end
end
