class OrdersController < ApplicationController
  before_action :require_product, only: [:add_to_cart]
  before_action :find_merchant, only: [:show]

  def cart
    @order = Order.find_by(id: session[:order_id])

  end

  def edit
    if session[:order_id]
      @order = Order.find_by(id: session[:order_id])
    else
      flash[:error] = "A problem occured. We couldn't find your order." 
      redirect_to root_path
    end 
  end

  def update  

    @order = Order.find_by(id: session[:order_id])
  
    if @order.update(order_params)
      @order.mark_paid
      @order.save
      flash[:success] = "Your order has been submitted."
      redirect_to confirmation_path

      return
    else
      # flash[:error] = @order.errors.full_messages
      render :edit
    end
  end

  def add_to_cart
    order = session[:order_id] ? find_order(id: session[:order_id]) : create_order
    order_item = order.order_items.find_by(product_id: @product.id) 

    if order_item && order_item.check_quantity_cart(params[:quantity], @product.stock)
      order_item.increment_quantity(params[:quantity])
    elsif order_item.nil? && @product.stock >= params[:quantity].to_i 
      order_item = OrderItem.new(order: order, product: @product, quantity: params[:quantity])
    else 
      flash[:error] = "Unable to add #{@product.name} to your cart: Not enough in stock"
      redirect_back(fallback_location: root_path)
      return 
    end 

    order_item.status = "Pending"
    
    if order_item.save
      flash[:success] = "Successfully added #{@product.name} to your cart"
    else
      flash[:error] = "Unable to add #{@product.name} to your cart: #{order_item.errors.messages}"
    end
    redirect_back(fallback_location: root_path)
  end

  def confirmation
    @order = find_order(id: session[:order_id])
    if @order
      @order.order_items.each do |order_item|
        if order_item.status == "Pending"
          flash[:error] = "You haven't completed the order yet. Please proceed to checkout."
          redirect_to cart_path
          return
        end
      end
    end
    session[:order_id] = nil
  end

  def show
    @order = find_order(id: params[:id])
    if @order
      if @order.verify_merchant(@login_merchant) == false
        flash[:error] = "You are not authorized to view this page."
        redirect_to dashboard_path
        return
      end
    end
  end

  def set_quantity 
    order_item = OrderItem.find_by(id: params[:order_item_id])
    if order_item.product.stock >= params[:quantity].to_i
      order_item.set_quantity(params[:quantity])
    else 
      flash[:error] = "Unable to add #{order_item.product.name} to your cart: we just have #{order_item.product.stock}"
      redirect_back(fallback_location: root_path)
      return 
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
    return params.require(:order).permit(:customer_name, :email, :address, :last_four_cc, :exp_date, :cvv, :zip)
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
      flash[:error] = "A problem occured. We couldn't find your order."
      redirect_back(fallback_location: root_path)
    end
    return order
  end

  def create_order
    order = Order.new
    unless order.save
      flash[:error] = "Something went wrong: #{order.errors.messages}"
    end
    session[:order_id] = order.id
    order.reload
    return order
  end  
end


