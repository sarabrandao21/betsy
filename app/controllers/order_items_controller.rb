class OrderItemsController < ApplicationController
  before_action :find_order_item, except: [:create]
  before_action :require_product, only: :create
  
  def create
    new_quantity = params["quantity"]
    new_product_id = params["product_id"]
    if session [:order_id] == nil || session[:order_id] == false || !session[:order_id]
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
  def destroy
    @order_item.destroy
    flash.now[:success] = "Item deleted from your cart."
    if session[:order_id]
      redirect_to cart_path
    else 
      redirect_to root_path
    end 
  end

  def mark_complete
    @order_item.change_status('Completed')
    flash[:success] = "Item successfully marked shipped"
    redirect_to dashboard_path
    return
  end

  def mark_cancel
    @order_item.change_status('Cancelled')
    flash[:success] = "Item successfully marked Cancelled"
    redirect_to dashboard_path
    return
  end


  private

  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id])
  end

  def order_item_params
    return params.require(:order_item).permit(:quantity, :product_id)
  end
end
