class MerchantsController < ApplicationController
  before_action :find_merchant, only: [:dashboard]
  
  def index
    @merchants = Merchant.all.sort_by {|merchant| -merchant.own_average_rating}
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    head :not_found unless @merchant
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
    if merchant
      flash[:success] = "Successfully logged in as #{merchant.username}"
    else
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:success] = "Logged in as new merchant #{merchant.username}"
      else
        flash[:error] = "Could not create new merchant account: #{merchant.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:merchant_id] = merchant.id
    return redirect_to root_path
  end

  def logout
    session[:merchant_id] = nil
    flash[:success] = "Successfully logged out"
    redirect_to root_path
  end

  def dashboard
    @order_status = ['select status',"All", "Active", "Inactive"]

    if @login_merchant
      @dashboard_merchant = @login_merchant
    else
      flash[:error] = "Sorry you are not authorized to this page"
      return redirect_to merchants_path 
    end
    
    @merchant_products = @dashboard_merchant.products 

      # adding filter options
      if params[:status]
        if params[:status] == 'Active'
          @selected_status = true
          @merchant_products = @dashboard_merchant.products.where(active: @selected_status)
        elsif params[:status] == 'Inactive'
          @selected_status = false
          @merchant_products = @dashboard_merchant.products.where(active: @selected_status)
        elsif params[:status] == "All"
          @merchant_products = @dashboard_merchant.products 
        end
      end
  end
end
