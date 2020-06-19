class OrderItemsController < ApplicationController

  before_action :find_order_item, except: [:create]
  before_action :require_product, only: :create
  
  def destroy
    order = Order.find_by(id: session[:order_id])
    @order_item.destroy
    flash[:success] = "Item deleted from your cart."
    redirect_to cart_path
    order.reload
    if order && order.order_items.empty?  
      order.destroy
      session[:order_id] = nil 
    end 
    return 
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
    if @order_item.nil? 
      head :not_found
      return
    end
  end

  def order_item_params
    return params.require(:order_item).permit(:quantity, :product_id)
  end
end
