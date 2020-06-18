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


  describe 'custom methods' do
    describe 'mark_paid' do
      it 'will change all order items from the order to paid' do
        order = orders(:sharon_order)
        order.mark_paid
        
        order.order_items.each do |order_item|
          expect(order_item.status).must_equal "Paid"
        end
      end

      it 'will go into each order_item products to deduct inventory' do
        # yoga mat - original stock 50, order item qty 5
        # chip - original stock 20 , order item qty 1
        order = orders(:sharon_order)
        order.mark_paid
        
        order.order_items.each do |order_item|
          order_item.reload
        end
        
        expect(products(:yogamat).stock).must_equal 45
        expect(products(:chips).stock).must_equal 19      
      end
    end

    describe 'all_cart_items' do
      it 'will calculate the total amount of items in an order' do
        # 5 yoga mat + 1 chip
        order = orders(:sharon_order)

        expect(order.all_cart_items).must_equal 6
      end

      it 'will calculate the total amount of items in an order' do
        # 5 yoga mat + 1 chip
        order = orders(:sharon_order)

        expect(order.all_cart_items).must_equal 6
      end

      it 'will return 0 if the cart order is empty' do
        order = Order.create!

        expect(order.all_cart_items).must_equal 0
      end
    end
  end
end
