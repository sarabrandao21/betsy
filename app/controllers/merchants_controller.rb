class MerchantsController < ApplicationController
  
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    render_404 unless @user
  end
end
