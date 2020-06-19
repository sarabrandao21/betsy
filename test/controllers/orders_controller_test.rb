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

      expect{post add_to_cart_path({ id: product.id, quantity: 5})}.must_differ "Order.count", 1

      order = Order.find_by(id: session[:order_id])
      order_item = OrderItem.find_by(product: product, order: order)
      
      expect(order).must_be_kind_of Order
      expect(order_item).must_be_kind_of OrderItem
      expect _(order.order_items).must_include order_item
    end

    it "add OrderItem to an existing order if its id is stored in session" do
      product = products(:yogamat)
      post add_to_cart_path({ id: product.id, quantity: 5})

      session_id = session[:order_id]
      order = Order.find_by(id: session_id)
      order_items_count = order.order_items.length

      second_product = products(:juice)
      expect {post add_to_cart_path({ id: second_product.id, quantity: 1})}.wont_change "Order.count"

      expect(session[:order_id]).must_equal session_id

      order = Order.find_by(id: session_id)
      expect(order.order_items.count).must_equal order_items_count + 1
    end

    it "creates a new instance of OrderItem if there are enough products in stock" do
      product = products(:yogamat)
      expect{post add_to_cart_path({ id: product.id, quantity: 1})}.must_differ "OrderItem.count", 1
    end

    it "doesn't create a new instance of OrderItem if there are not enough products in stock" do
      product = products(:dumbells)
      expect{post add_to_cart_path({ id: product.id, quantity: 1})}.wont_change "OrderItem.count"
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
      product = products(:yogamat)
      post add_to_cart_path({id: product.id, quantity: 5})
      order_item = Order.find_by(id: session[:order_id]).order_items[0]
      order_item.status = "Paid"
      order_item.save

      get confirmation_path
      must_respond_with :success
      assert_nil session[:order_id]
    end

    it "redirects to root if session[:order_id] is nil" do
      get confirmation_path
      must_redirect_to root_path 
    end

    it "redirects to cart if the order status is pending" do
      product = products(:yogamat)
      post add_to_cart_path({ id: product.id, quantity: 5})
      order_item = Order.find_by(id: session[:order_id]).order_items[0]

      expect(order_item.status).must_equal "Pending"
      get confirmation_path
      must_redirect_to cart_path
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

      post set_quantity_path({id: order.id, order_item_id: order_item.id, quantity: 13})
      order_item = order.order_items.find_by(product_id: product.id)

      expect(order_item.quantity).must_equal 1
      expect(flash[:error]).must_equal "Unable to add #{order_item.product.name} to your cart: we just have #{order_item.product.stock}"

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
      expect{delete order_path(order)}.must_differ "OrderItem.count", -3
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
      @product = products(:juice) 
    end

    it "able to retrive order checkout form for existing cart" do
      product = products(:yogamat)
      post add_to_cart_path(product)
      expect(session[:order_id]).wont_be_nil

      order = Order.find_by(id: session[:order_id])

      get edit_order_path(order.id)
      must_respond_with :success
    end
    
    it "redirects to root_path if there is no existing cart" do
      id = Order.first.id
      get edit_order_path(id)
      expect(flash[:error]).must_equal "A problem occured. We couldn't find your order."
      must_redirect_to root_path
    end

    it "responds with an error message if param is not valid" do
      product = products(:yogamat)
      post add_to_cart_path({ id: product.id, quantity: 5})

      order = Order.find_by(id: session[:order_id])
      assert_nil order.customer_name
      assert_nil order.email
      assert_nil order.last_four_cc
      assert_nil order.cvv
      assert_nil order.zip
      assert_nil order.exp_date

      order_hash = {
        order: {
          customer_name: "Rag Ragson",
          email: "rag@rag.com",
          address: "100 Jerry Atrics Lane, Rhoda Booke,WA 98000",
          last_four_cc: "9999",
          cvv: "123",
          zip: "9999",
          exp_date: "0125",
        }
      }

      patch order_path(session[:order_id]), params: order_hash

      order = Order.find_by(id: session[:order_id])
      assert_nil order.customer_name
      assert_nil order.email
      assert_nil order.last_four_cc
      assert_nil order.cvv
      assert_nil order.zip
      assert_nil order.exp_date
    end
  end

  describe "update" do
    it "updates order info, sets status to 'paid' and reduces stock" do 
      product = products(:yogamat)
      post add_to_cart_path({id: product.id, quantity: 5})

      order = Order.find_by(id: session[:order_id])
      assert_nil order.customer_name
      assert_nil order.email
      assert_nil order.last_four_cc
      assert_nil order.cvv
      assert_nil order.address
      assert_nil order.zip
      assert_nil order.exp_date

      order_hash = {
        order: {
          customer_name: "Rose Gardner",
          email: "rag@rag.com",
          address: "100 Jerry Atrics Lane, Rhoda Booke,WA 98000",
          last_four_cc: "9999",
          cvv: "123",
          zip: "99999",
          exp_date: "0125"
        }
      }
  
      expect { patch order_path(session[:order_id]), params: order_hash }.wont_change "Order.count"
  
      order = Order.find_by(id: session[:order_id])

      expect(order.customer_name).must_equal "Rose Gardner"
      expect(order.email).must_equal "rag@rag.com"
      expect(order.last_four_cc).must_equal "9999"
      expect(order.cvv).must_equal "123"
      expect(order.address).must_equal "100 Jerry Atrics Lane, Rhoda Booke,WA 98000"
      expect(order.zip).must_equal "99999"
      expect(order.exp_date).must_equal "0125"
  
      expect(order.order_items[0].status).must_equal "Paid"
      expect(order.order_items[0].product.stock).must_equal 45

      expect(flash[:success]).must_equal "Your order has been submitted."
    end
  end


  describe 'show' do
    it 'will show the order page if that is sold from a login in merchant.' do

      perform_login(merchants(:sharon))

      get order_path(orders(:sharon_order).id)
      must_respond_with :success
    end

    it 'will not show the login merchant an order page if it is not sold by merchant and redirect.' do
      perform_login(merchants(:sara))

      get order_path(orders(:sharon_order).id)
      expect(flash[:error]).must_equal "You are not authorized to view this page."
      must_redirect_to dashboard_path
    end

    it 'will not show the order pages to someone that is not log in' do

      get order_path(orders(:sharon_order).id)
      expect(flash[:error]).must_equal "You are not authorized to view this page."
      must_redirect_to dashboard_path
    end

    it 'will not redirect to root path if the order is not valid' do
      invalid_order_id = -1
      get order_path(invalid_order_id)

      expect(flash[:error]).must_equal "A problem occured. We couldn't find your order."
      must_respond_with :redirect
    end
  end
end