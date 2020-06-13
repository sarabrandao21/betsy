class OrdersController < ApplicationController

  def show
    @order = Order.find_by(id: session[:order_id])

  end

  def edit
    if params[:order_id]
      @order = Order.find_by(id: params[:order_id])
    elsif params[:id]
      @order = Order.find_by(id: params[:id])
    elsif session[:order_id] && session[:order_id] != nil
      @order = Order.find_by(id: session[:order_id])
    end 
  end

  def update
    @order = Order.find_by(id: session[:order_id])
    if @order.update(order_params)
     # @order.card_status = "paid"
      @order.save
      session.delete(:order_id)
      flash[:success] = "Your order has been submitted."
      redirect_to order_path(@order)
      return

    else
      flash[:error] = "Try again."
      render :edit
      return
    end
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

  private
  def order_params
    return params.require(:order).permit(:customer_name, :email, :address, :last_four_cc, :exp_date, :cvv, :zip, :card_status )
  end
end


