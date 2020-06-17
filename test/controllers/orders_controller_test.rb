require "test_helper"

describe OrdersController do
  # before do 
  #   new_order_item = {product_id: products(:juice).id, quantity:3}
  #   post order_items_path, new_order_item
  #   @new_order_item = Order.last
  # end
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
      product = products(:dumbells)
      
      expect{post add_to_cart_path(product)}.wont_change "OrderItem.count"
    end

    it "increases quantity of existing OrderItem when adding more of the same product to the cart" do
      product = products(:yogamat)
      get cart_path      
      post add_to_cart_path({ id: product.id, quantity: 5})
      order_item = Order.find_by(id: session[:order_id]).order_items.find_by(product_id: product.id)
      expect(order_item.quantity).must_equal 5
      must_redirect_to root_path
    end

    it "won't increase quantity if there is not enough stock after adding more copies of product" do
      product = products(:dumbells)
      get cart_path      
      post add_to_cart_path({ id: product.id, quantity: 5})
      order_item = Order.find_by(id: session[:order_id]).order_items.find_by(product_id: product.id)
      expect(order_item).must_equal nil 
      must_redirect_to root_path
    end

    it "redirects to root_path" do
      product = products(:yogamat)
      post add_to_cart_path(product)
      must_redirect_to root_path
    end
  end

  describe "confirmation" do
    it "responds with success if session[:order_id] matches the existing order and sets it to nil" do

    end

    it "redirects to root if session[:order_id] is nil" do
      get confirmation_path
      must_redirect_to root_path 
    end

    it "redirects to cart if the order status is pending" do
    end
  end

  describe "set_quantity" do 
    it "reassings the value of the order_item when quantity is less than stock value " do 
      product = products(:yogamat)
 
      get cart_path      
      post add_to_cart_path({ id: product.id, quantity: 5})
      
      order = Order.find_by(id: session[:order_id])
      order_item = order.order_items.find_by(product_id: product.id)

      post set_quantity_path({id: order.id, order_item_id: order_item.id, quantity: 3})
      order_item = order.order_items.find_by(product_id: product.id)

      expect(order_item.quantity).must_equal 3
      must_redirect_to root_path

    end 

    it "does not reassign the quantity value if user request higher quantity than available in stock" do 
      product = products(:juice)
 
      get cart_path      
      post add_to_cart_path({ id: product.id, quantity: 1})
      
      order = Order.find_by(id: session[:order_id])
      order_item = order.order_items.find_by(product_id: product.id)

      post set_quantity_path({id: order.id, order_item_id: order_item.id, quantity: 3})
      order_item = order.order_items.find_by(product_id: product.id)

      expect(order_item.quantity).must_equal 1
      must_redirect_to root_path
    end 
    
  end 

  describe "destroy" do
    it "destroys the Order instance and redirects to root" do
      order = orders(:nataliyas_order)
      expect{delete order_path(order)}.must_differ "Order.count", -1
      must_redirect_to root_path
    end

    it "destroys all OrderItems in the Order instance" do
      order = orders(:nataliyas_order)
      expect{delete order_path(order)}.must_differ "OrderItem.count", -2
    end

    it "sets session[:order_id] to nil" do
      product = products(:yogamat)
      post add_to_cart_path(product)
      expect(session[:order_id]).wont_be_nil

      order = Order.find_by(id: session[:order_id])
      delete order_path(order)
      assert_nil session[:order_id]
    end

    it "does not do anything if Order id is invalid" do
      order_id = -1
      order = Order.find_by(id: order_id)
      expect{delete order_path(order_id)}.wont_change "Order.count"
      must_respond_with :not_found
    end
  end


  describe "edit" do
    before do 
      @order = orders(:sandy)
    end
    
    it "completes order if given valid params" do
      get edit_order_path(@order.id)
      must_respond_with :success
    end

    it "responds with a bad request when order ID is NOT valid" do
      get edit_order_path(-1)

      must_respond_with :redirect
    end

    it "completes order when given a valid order params" do
      
    end
  end
end
