class ApplicationController < ActionController::Base
<<<<<<< HEAD
=======

  def find_merchant
    if session[:merchant_id]
      return @login_merchant = Merchant.find_by(id: session[:merchant_id])
    end
  end
>>>>>>> 9ca2291e934a76c02f436966d731b2ad296bc24c
  
end
