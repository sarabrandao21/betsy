require "test_helper"

describe OrderItem do
  let(:new_order_item) { order_items(:yogamat_orderitem) }
  let(:new_product) { products(:yogamat) }
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
end
