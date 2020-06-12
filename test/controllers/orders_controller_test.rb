require "test_helper"

describe OrdersController do

  describe "cart" do
    #TODO
    it "responds with success if session[:order_id] matches the existing order" do
      product = products(:yogamat)
      id = product.id
      post add_to_cart_path(product)

      # expect(session[:order_id]).must_equal user.id

    end

    it "responds with success if session[:order_id] is nil, but shows an empty cart" do
    end
  end

  describe "create" do
    #TODO
    it "creates a new instance of OrderItem if there are enough products in stock" do
      # assert_nil session[:order_id]
      
      product = products(:yogamat)
      id = product.id
      post add_to_cart_path(product)

      
    end

    it "doesn't create a new instance of OrderItem if there are not enough products in stock" do
    end

    it "creates a new instance of Order if session[:order_id] is nil and adds OrderItem to it" do
    end

    it "add OrderItem to an existing order if its id is stored in session" do
    end

    it "increases quantity of existing OrderItem when adding more of the same product to the cart" do
    end

    it "won't increase quantity if there is not enough stock after adding more copies of product" do
    end

    it "redirects to root_path" do
    end
  end



end
