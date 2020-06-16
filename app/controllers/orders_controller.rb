class OrdersController < ApplicationController
  before_action :require_product, only: [:add_to_cart]
  

  def cart
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
     @order.card_status = "paid"
      @order.save
      session.delete(:order_id)
      flash[:success] = "Your order has been submitted."
      redirect_to order_path(@order.id)
      return
    else
      flash[:error] = "Try again."
      render :edit
      return
    end
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

  def order_params
    return params.require(:order).permit(:customer_name, :email, :address, :last_four_cc, :exp_date, :cvv, :zip, :card_status )
  end

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


