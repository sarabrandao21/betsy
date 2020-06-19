require "test_helper"

describe Order do
  let(:yoga_product) { products(:yogamat) }
  let(:drink_product) { products(:juice) }
  let(:y_order_item) { order_items(:yogamat_orderitem) }
  let(:j_order_item) { order_items(:juice_orderitem) }
  let(:g_order_item) { order_items(:gear_orderitem) }
  let(:order) { orders(:nataliyas_order) }

  describe "relations" do 
    it "can have many order_items" do 
    #all orders belongs to Merchant Nataliya
    test_order = order
      test_order.order_items.each do |order_item|
        order_item.quantity = 1
        order_item.reload 
      end 
      test_order.reload
      expect(test_order.order_items.length).must_equal 3
    end 
  end 
  describe "subtotal" do 
    it "calculates the subtotal of an order" do 
      yogamat_total = yoga_product.price *  y_order_item.quantity
      gear_total = yoga_product.price *  g_order_item.quantity
      drink_total = drink_product.price * j_order_item.quantity
    
      total = yogamat_total + gear_total + drink_total
      
      expect(order.subtotal).must_equal total
    end 
  end 
  describe "taxes" do 
    it "calculates taxes of the subtotal" do 
      yogamat_total = yoga_product.price *  y_order_item.quantity
      gear_total = yoga_product.price *  g_order_item.quantity
      drink_total = drink_product.price * j_order_item.quantity
    
      total = (yogamat_total + gear_total + drink_total) * 0.10
      expect(order.taxes).must_equal total
    end 
  end 
  describe "purchase_total" do 
    it "calculates the sum of subtoal with taxes" do 
      yogamat_total = yoga_product.price *  y_order_item.quantity
      gear_total = yoga_product.price *  g_order_item.quantity
      drink_total = drink_product.price * j_order_item.quantity

      subtotal = yogamat_total + gear_total + drink_total
      tax = (yogamat_total + gear_total + drink_total) * 0.10
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

        order = orders(:nataliyas_order)

        expect(order.all_cart_items).must_equal 9
      end

      # it 'will return 0 if the cart order is empty' do
      #   order = Order.create!

      #   expect(order.all_cart_items).must_equal 0
      # end
    end


    describe 'verify_merchant' do
      it 'will return true if the login merchant is include in the order items merchants' do
        order = orders(:sharon_order)
        merchant = merchants(:sharon)
        
        expect(order.verify_merchant(merchant)).must_equal true

      end

      it 'will return false if the login merchant is include in the order items merchants' do
        order = orders(:sharon_order)
        merchant = merchants(:sara)
        
        expect(order.verify_merchant(merchant)).must_equal false

      end
    end

    describe "validations" do
      before do 
        @new_order = Order.new
        @update_params ={
        customer_name: "Sandy Beech",
        email: "sbeech@beech.com",
        address: "123 Jerry Atrics, Al Kaholic,CT,00000",
        exp_date: "0125",
        last_four_cc: "4444",
        cvv: "123",
        zip: "00000"}
      end
    it "when updated all fields are valid" do
      @new_order.update(@update_params)
      expect(@new_order.valid?).must_equal true
    end 

    it "params invalid if order have no customer name present" do 
     @update_params[:customer_name] = nil
     @new_order.update(@update_params)
     expect(@new_order.valid?).must_equal false
     expect(@new_order.errors.messages).must_include :customer_name
    end
    it "params invalid if order have no address present" do 
      @update_params[:address] = nil
      @new_order.update(@update_params)
      expect(@new_order.valid?).must_equal false
      expect(@new_order.errors.messages).must_include :address
     end


    it "params invalid if order have no email address name" do 
      @update_params[:email] = nil
      @new_order.update(@update_params)
      expect(@new_order.valid?).must_equal false
      expect(@new_order.errors.messages).must_include :email
     end

     it "params invalid if order has no zip present" do 
      @update_params[:zip] = nil
      @new_order.update(@update_params)
      expect(@new_order.valid?).must_equal false
      expect(@new_order.errors.messages).must_include :zip
     end

    it "params invalid if order has zip less than 5 digits customer name present" do 
      @update_params[:zip] = "1234"
      @new_order.update(@update_params)
      expect(@new_order.valid?).must_equal false
      expect(@new_order.errors.messages).must_include :zip
     end
     it "params invalid if order no expiry date present" do 
      @update_params[:exp_date] = nil
      @new_order.update(@update_params)
      expect(@new_order.valid?).must_equal false
      expect(@new_order.errors.messages).must_include :exp_date
     end
     it "params invalid if order does not have at least three digits in field for cvv" do 
      @update_params[:cvv] = "12"
      @new_order.update(@update_params)
      expect(@new_order.valid?).must_equal false
      expect(@new_order.errors.messages).must_include :cvv
     end
     it "params invalid if order does not have cvv" do 
      @update_params[:cvv] = nil
      @new_order.update(@update_params)
      expect(@new_order.valid?).must_equal false
      expect(@new_order.errors.messages).must_include :cvv
     end
     it "params invalid if order does not have at least four digits in field last four of cc number field" do 
      @update_params[:last_four_cc] = "123"
      @new_order.update(@update_params)
      expect(@new_order.valid?).must_equal false
      expect(@new_order.errors.messages).must_include :last_four_cc
     end
     it "params invalid if order has no last four of cc number present" do 
      @update_params[:last_four_cc] = nil
      @new_order.update(@update_params)
      expect(@new_order.valid?).must_equal false
      expect(@new_order.errors.messages).must_include :last_four_cc
     end
  end

  end
end
