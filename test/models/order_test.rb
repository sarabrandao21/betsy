require "test_helper"

describe Order do
  let(:yoga_product) { products(:yogamat) }
  let(:drink_product) { products(:juice) }
  let(:y_order_item) { order_items(:yogamat_orderitem) }
  let(:j_order_item) { order_items(:juice_orderitem) }
  let(:order) { orders(:nataliyas_order) }
  describe "subtotal" do 
    it "calculates the subtotal of an order" do 
      yogamat_total = yoga_product.price *  y_order_item.quantity
      drink_total = drink_product.price * j_order_item.quantity
    
      total = yogamat_total + drink_total
      
      expect(order.subtotal).must_equal total
    end 
  end 
  describe "taxes" do 
    it "calculates taxes of the subtotal" do 
      yogamat_total = yoga_product.price *  y_order_item.quantity
      drink_total = drink_product.price * j_order_item.quantity
    
      total = (yogamat_total + drink_total) * 0.10
      expect(order.taxes).must_equal total
    end 
  end 
  describe "purchase_total" do 
    it "calculates the sum of subtoal with taxes" do 
      yogamat_total = yoga_product.price *  y_order_item.quantity
      drink_total = drink_product.price * j_order_item.quantity
      subtotal = yogamat_total + drink_total
      tax = (yogamat_total + drink_total) * 0.10
      total = subtotal + tax
      
      expect(order.purchase_total).must_equal total
    end 
  end 
end
