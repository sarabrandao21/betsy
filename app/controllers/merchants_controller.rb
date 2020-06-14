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
    if !(@login_merchant == Merchant.find_by(id: params[:id]))
      flash[:error] = "Sorry you are not authorized to this page"
      return redirect_to merchants_path 
    else
      @merchant = @login_merchant
    end
  end
end
