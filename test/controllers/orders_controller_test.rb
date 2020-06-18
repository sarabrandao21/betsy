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
      post add_to_cart_path(product)
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
      post add_to_cart_path(product)
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


  # describe "edit" do 
  #   before do
  #     @new_order = Order.create
  #     @order = orders(:sandy)
      
  #   end

  #   it "completes order if given valid params" do 
      
  #     get edit_order_path(@order.id)
  #     must_respond_with :success
  #   end

  #  it " does not past order" do 
  #  end


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
        product = products(:yogamat)
        post add_to_cart_path(product)
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
        post add_to_cart_path(product)
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
        @new_order = Order.create
        @order = orders(:sandy)
        @product = products(:juice) 
        @new_order_item = {product_id:  @product.id, quantity: 3, order_id:@new_order}
      end
  
      it "able to retrive order checkout form" do 
        
        get edit_order_path(@order.id)

        must_respond_with :success
      end

      it " can find order when in session" do

        product = products(:yogamat)
        post add_to_cart_path(product)
        expect(session[:order_id]).wont_be_nil
  
        order = Order.find_by(id: session[:order_id])

        get edit_order_path(order.id)
        must_respond_with :success
      end 
  
      it "responds error message if param is not valid" do
        order_hash = {
          order: {
            email: "rag@rag.com",
            address: "100 Jerry Atrics Lane,  Rhoda Booke,WA 98000",
            last_four_cc: "9999",
            cvv: "123",
            zip: "9999",
            exp_date: "0125",
          }
        }
        order_id = Order.last.id
        expect { patch orders_path(order_id), params: order_hash }.wont_change "Order.count"
     

       
  
        # if @order.update(order_params)
    
        #   @order.card_status = "paid"
        #   @order.mark_paid
        #   @order.save
        #   flash[:success] = "Your order has been submitted."
        #   redirect_to confirmation_path
     

      end

       it "process order with redirect"do
       product = products(:yogamat)
   
       get cart_path      
       post add_to_cart_path({ id: product.id, quantity: 5})
      #  product = products(:yogamat)
      #  post add_to_cart_path(product)

      #  order_item = (Order.find_by(id: session[:order_id]).order_items[0])  
  
      order = Order.find_by(id: session[:order_id])
     
        order_hash = {
                order: {
                  customer_name: "Rose Gardner",
                  email: "rag@rag.com",
                  address: "100 Jerry Atrics Lane, Rhoda Booke,WA 98000",
                  last_four_cc: "9999",
                  cvv: "123",
                  zip: "99999",
                  exp_date: "01/25",
                }
              }

      expect { patch order_path(order.id), params: order_hash }.wont_change "Order.count"

      # expect(order.customer_name).must_equal "Rose Gardner"
      #  order_item.status = "Paid"
      #  order_item.save
 
      #  get confirmation_path
      #  must_respond_with :success
      #  assert_nil session[:order_id]
      #  order_hash = {
      #   order: {
      #     customer_name: "Rose Gardner",
      #     email: "rag@rag.com",
      #     address: "100 Jerry Atrics Lane, Rhoda Booke,WA 98000",
      #     last_four_cc: "9999",
      #     cvv: "123",
      #     zip: "99999",
      #     exp_date: "01/25",
      #   }
      # }
      # order = Order.last
      # order_id = Order.last.id
      # expect { patch order_path(order.id), params: order_hash }.wont_change "Order.count"
      # order.reload
      # expect(order.customer_name).must_equal "Rose Gardner"

    end
    end
  
    it "updates order status to 'paid' and can reduce stock" do 
      order_hash = {
        order: {
          customer_name: "Rose Gardner",
          email: "rag@rag.com",
          address: "100 Jerry Atrics Lane,  Rhoda Booke,WA 98000",
          last_four_cc: "9999",
          cvv: "123",
          zip: "9999",
          exp_date: "0125",
        }
      }
  
      order_id = Order.last.id 
      product_id = Product.last.id 
      expect { patch order_path(order_id), params: order_hash }.wont_change "Order.count"
  
      updated_order =  Order.find(order_id)
      updated_product =  Product.find(product_id)
  
      expect(updated_order.card_status).must_equal "paid"
      expect(updated_product.stock).must_equal 7
      # expect(session[:order_id]).must_be_nil
    
    end
     
    it " will display flash if error when completing order" do

    #   product = products(:yogamat)
   
    #   get cart_path      
    #   post add_to_cart_path({ id: product.id, quantity: 5})
    #  #  product = products(:yogamat)
    #  #  post add_to_cart_path(product)

    #  #  order_item = (Order.find_by(id: session[:order_id]).order_items[0])  
 
    #  order = Order.find_by(id: session[:order_id])
    
    #    order_hash = {
    #            order: {
    #              customer_name: "Rose Gardner",
    #              email: "rag@rag.com",
    #              address: "100 Jerry Atrics Lane, Rhoda Booke,WA 98000",
    #              last_four_cc: "9999",
    #              cvv: "123",
    #              zip: "9999",
    #              exp_date: "01/25",
    #            }
    #          }

    #  expect { patch order_path(order.id), params: order_hash }.wont_change "Order.count"

    #   # invalid_order = @new_order.update(customer_name: "Pat Pending", email: "patty@pat.com", address: "30 battle RD, Monore, WA, 99999", cvv: "13", last_four_cc: "444", zip: "254", exp_date: "01")
  
    #   expect(order.errors.full_messages.to_sentence).must_include "Zip"
    end
  
  end
end