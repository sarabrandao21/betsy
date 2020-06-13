require "test_helper"

describe OrdersController do

  describe "cart" do
    it "responds with success if session[:order_id] matches the existing order" do
      product = products(:yogamat)
      post add_to_cart_path(product)

      get cart_path
      expect(session[:order_id]).wont_be_nil
      must_respond_with :success
    end

    it "responds with success if session[:order_id] is nil, but shows an empty cart" do
      get cart_path 
      assert_nil session[:order_id]
      must_respond_with :success
    end
  end

  describe "add_to_cart" do
    it "creates a new instance of Order if session[:order_id] is nil and adds OrderItem to it" do
      product = products(:yogamat)
      get product_path(product)
      assert_nil session[:order_id] 

      expect{post add_to_cart_path(product)}.must_differ "Order.count", 1

      order = Order.find_by(id: session[:order_id])
      order_item = OrderItem.find_by(product: product, order: order)
      
      expect(order).must_be_kind_of Order
      expect(order_item).must_be_kind_of OrderItem
      expect _(order.order_items).must_include order_item
    end

    it "add OrderItem to an existing order if its id is stored in session" do
      product = products(:yogamat)
      post add_to_cart_path(product)

      session_id = session[:order_id]
      order = Order.find_by(id: session_id)
      order_items_count = order.order_items.length

      second_product = products(:juice)
      expect{post add_to_cart_path(second_product)}.wont_change "Order.count"
      expect(session[:order_id]).must_equal session_id
      expect(order.order_items.count).must_equal order_items_count + 1
    end

    it "creates a new instance of OrderItem if there are enough products in stock" do
      product = products(:yogamat)
      expect{post add_to_cart_path(product)}.must_differ "OrderItem.count", 1
    end

    it "doesn't create a new instance of OrderItem if there are not enough products in stock" do
      #TODO
    end

    it "increases quantity of existing OrderItem when adding more of the same product to the cart" do
      #TODO
    end

    it "won't increase quantity if there is not enough stock after adding more copies of product" do
      #TODO
    end

    it "redirects to root_path" do
      product = products(:yogamat)
      post add_to_cart_path(product)
      must_redirect_to root_path
    end
  end

  describe "destroy" do
    it "destroys the Order instance and redirects to root" do
      order = orders(:nataliyas_order)
      expect{delete order_path(order)}.must_differ "Order.count", -1
    end

    it "destroys all OrderItems in the Order instance" do
    end

    it "does not do anything if Order id is invalid" do

    end
  end
end
