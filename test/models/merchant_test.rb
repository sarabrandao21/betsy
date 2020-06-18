require "test_helper"

describe Merchant do

  describe "validations" do
    it "is valid with unique username and email" do
      new_merchant = Merchant.new(username: "Chris", email: "chris@chris.com")
      expect(new_merchant.valid?).must_equal true
      expect(new_merchant.save).must_equal true
    end

    it "requires a username" do
      new_merchant = Merchant.new(email: "gmail@gmail.com")
      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :username
    end

    it "requires a unique username" do
      username = Merchant.first.username
      new_merchant = Merchant.new(username: username, email: "gmail@gmail.com")

      result = new_merchant.save
      expect(result).must_equal false
      expect(new_merchant.errors.messages).must_include :username
    end

    it "requires an email" do
      new_merchant = Merchant.new(username: "Chris")
      expect(new_merchant.valid?).must_equal false
      expect(new_merchant.errors.messages).must_include :email
    end

    it "requires a unique email" do
      email = Merchant.first.email
      new_merchant = Merchant.new(username: "Chris", email: email)

      result = new_merchant.save
      expect(result).must_equal false
      expect(new_merchant.errors.messages).must_include :email
    end
  end

  describe "relations" do
    it "has a list of products" do
      merchant = merchants(:nataliya)
      expect(merchant).must_respond_to :products
      merchant.products.each do |product|
        expect(product).must_be_kind_of Product
      end
    end
  end

  describe 'custom methods' do
    describe 'own_average_rating' do
      it 'will find the average rating of the product average rating from a merchant' do
        merchant = merchants(:sharon)
        # her two products have review from yml - one average of 1 and one average of 5
        
        expect(merchant.own_average_rating).must_equal 3
      end

      it 'will return 0 if the merchant does not have any product average rating' do
        merchant = merchants(:sara)
        # her two products have review from yml - one average of 1 and one average of 5
        
        expect(merchant.own_average_rating).must_equal 0
      end
    end

    describe 'find_total_order' do
      it 'will return the total order of a merchant' do
        merchant = merchants(:sharon)

        expect(merchant.find_total_order).must_equal 2
      end

      it 'will return 0 if there is no order from a merchant' do
        merchant = merchants(:sara)

        expect(merchant.find_total_order).must_equal 0
      end
    end

    describe 'find_all_order_items(status)' do
      it 'will return the sum of order items of a merchant by completed status' do
        merchant = merchants(:sharon)
        
        merchant.order_items.each do |order_item|
          order_item.change_status("Completed")
        end
      
        expect(merchant.find_all_order_items("Completed").length).must_equal 5
      end

      it 'will return the sum of order items of a merchant by paid status' do
        merchant = merchants(:sharon)
        
        merchant.order_items.each do |order_item|
          order_item.change_status("Paid")
        end
      
        expect(merchant.find_all_order_items("Paid").length).must_equal 5
      end
    end

    describe 'total_revenue_by(status)' do
      it 'will calculate the total revenue of a merchant by order items by completed status' do
        merchant = merchants(:sharon)
        order_item = order_items(:yogamat_orderitem)

        order_item.change_status('Completed')
        # $ 50 x 3 yoga mat
        expect(merchant.total_revenue_by('Completed')).must_equal 150
      end

      it 'will return 0 if a merchant doesnt have any order item' do
        merchant = merchants(:sara)

        merchant.order_items.must_equal []
        expect(merchant.total_revenue_by('Completed')).must_equal 0
      end

      it 'will calculate the total revenue of a merchant by order items by completed status' do
        merchant = merchants(:sharon)
        order_item = order_items(:yogamat_orderitem)

        order_item.change_status('Paid')
        # $ 50 x 3 yoga mat
        expect(merchant.total_revenue_by('Paid')).must_equal 150
      end
    end

      describe 'total revenue' do
        it 'will caculate the total sum of revenue without the cancelled status' do
          merchant = merchants(:sharon)
        
          merchant.order_items.each do |order_item|
            order_item.change_status("Completed")
          end
        
          expect(merchant.total_revenue).must_equal 624
        end

        it 'will caculate the total sum of revenue without the cancelled status' do
          merchant = merchants(:sharon)
        
          merchant.order_items.each do |order_item|
            order_item.change_status("Paid")
          end
        
          expect(merchant.total_revenue).must_equal 624
        end

        it 'will return 0 if there is no order item from this merchant' do
          merchant = merchants(:sara)
        
          merchant.order_items.must_equal []
        
          expect(merchant.total_revenue).must_equal 0
        end

        it 'will return 0 if all order item is cancelled from this merchant' do
          merchant = merchants(:sharon)
        
          merchant.order_items.each do |order_item|
            order_item.change_status("Cancelled")
          end
        
          expect(merchant.total_revenue).must_equal 0
        end
      end
  end
end
