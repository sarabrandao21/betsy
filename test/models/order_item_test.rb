require "test_helper"

describe OrderItem do
  let(:new_order_item) { order_items(:yogamat_orderitem) }
  let(:new_product) { products(:yogamat) }

  describe "validation" do 
    it "recieves error if quantity is not present" do
      new_order_item.quantity = nil   
    
      expect(new_order_item.valid?).must_equal false
      expect(new_order_item.errors.messages).must_include :quantity
      expect(new_order_item.errors.messages[:quantity]).must_equal ["can't be blank", "is not a number"]
    end
    it "recieves error if PRICE when is less than zero" do
      new_order_item.quantity = -1
    
      expect(new_order_item.valid?).must_equal false
      expect(new_order_item.errors.messages).must_include :quantity
      expect(new_order_item.errors.messages[:quantity]).must_equal ["must be greater than 0"]
    end
    
    it "recieves error if PRICE when is less than zero" do
      new_order_item.quantity = "STRING"
    
      expect(new_order_item.valid?).must_equal false
      expect(new_order_item.errors.messages).must_include :quantity
      expect(new_order_item.errors.messages[:quantity]).must_equal ["is not a number"]
    end
  end 

  describe "relations" do 
    it "an order_item has order" do
      expect(new_order_item).must_respond_to :order
      expect(new_order_item.order).must_be_kind_of Order
    end

    it "an order_item has product" do 
      expect(new_order_item).must_respond_to :product
      expect(new_order_item.product).must_be_kind_of Product
    end 
  end 
  describe "increament_quantity" do 
    it "increment quantity when user add quantity outside of cart" do 
      before_order_item = new_order_item.quantity
      new_order_item.increment_quantity(1)
      
      expect(new_order_item.quantity).must_equal before_order_item + 1
    end 
  end 
  describe "set_quantity" do 
    it "reassign quantity when user is in the cart" do 
      new_order_item.set_quantity(5)
      expect(new_order_item.quantity).must_equal 5
    end 
  end 
  describe "total_price_qty" do 
    it "can calculate the price for the total of the item" do 
      new_order_item.set_quantity(3)
      total_price = new_product.price * 3 
      
      expect(new_order_item.total_price_qty).must_equal total_price 
    end 
  end 

  describe "check_quantity_cart" do 
    it "can check if quantity to add to order_item is in stock" do 
      order_item = order_items(:gear_orderitem)
      params_user_qty = 1
      stock_product = 5 

      order_item.quantity = 4
      order_item.reload

      expect(order_item.check_quantity_cart(params_user_qty, stock_product)).must_equal true 
   
    end 
    it "wont add product if there is no stock" do 
      order_item = order_items(:gear_orderitem)
      params_user_qty = 3
      stock_product = 5 

      order_item.quantity = 4
      order_item.reload
      expect(order_item.check_quantity_cart(params_user_qty, stock_product)).must_equal false  
    end 
  end 

  describe 'change status' do
    it 'will change status to complete' do
      order_item = order_items(:chips_orderitem)
      order_item.change_status("Completed")

      expect(order_item.status).must_equal "Completed"
    end

    it 'will change status to cancelled and restock items back to inventory' do
      order_item = order_items(:chips_orderitem)
      product = Product.find_by(id: order_item.product_id)
      original_stock = product.stock
      
      order_item.change_status("Cancelled")

      product.reload
      expect(order_item.status).must_equal "Cancelled"
      expect(product.stock).must_equal original_stock + order_item.quantity
    end
  end

end
