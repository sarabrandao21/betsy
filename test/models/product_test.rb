require "test_helper"

describe Product do
  before do 
    @new_product = Product.new(name:"Air Force Ones", price:150, merchant_id: merchants(:sharon).id)
  
  end

  describe "validations" do
    before do
      @new_product = Product.first
    end

    it "is valid when all required fields are present" do
      valid_products = @new_product.valid?

      expect(valid_products).must_equal true
    end

    it "is invalid when product title is NOT present" do
      @new_product.name = nil
      expect(@new_product.valid?).must_equal false
    end

  it "recieves error if MERCHANT is not present" do
    @new_product.merchant_id = nil   
  
    expect(@new_product.valid?).must_equal false
    expect(@new_product.errors.messages).must_include :merchant
    expect(@new_product.errors.messages[:merchant]).must_equal ["must exist"]
  end

  it "recieves error if PRICE  not present" do
    @new_product.price = nil   
  
    expect(@new_product.valid?).must_equal false
    expect(@new_product.errors.messages).must_include :price
    expect(@new_product.errors.messages[:price]).must_equal ["can't be blank", "is not a number"]
  end

  it "recieves error if PRICE when is less than zero" do
    @new_product.price = -1
  
    expect(@new_product.valid?).must_equal false
    expect(@new_product.errors.messages).must_include :price
    expect(@new_product.errors.messages[:price]).must_equal ["must be greater than 0"]
  end

  it "recieves error if PRICE when is less than zero" do
    @new_product.price = "NAN"
  
    expect(@new_product.valid?).must_equal false
    expect(@new_product.errors.messages).must_include :price
    expect(@new_product.errors.messages[:price]).must_equal ["is not a number"]
  end
end
  describe "custom methods" do

    describe "top ten popular products" do
      it "return the top ten works for each media" do
        top_products = Product.popular_products
        expect(top_products.length).must_equal 10
      end

      it "return the top ten products when less than ten" do
        removed_item = products(:juice)
        removed_item.destroy
        top_products = Product.popular_products
        expect(top_products.length).must_equal 9
        expect(top_products.length).wont_be_nil
      end

      it "will return empty array if no Products" do
        Product.destroy_all
        top_products = Product.popular_products
        expect(top_products).must_equal []
      end
    end
  end

  describe "relationships" do
    before do
      @new_product= Product.first
    
    end

    it "a product has merchant" do
      expect(@new_product).must_respond_to :merchant
      expect(@new_product.merchant).must_be_kind_of Merchant
    end
  end

  # TODO: TO TEST CATERGORIES
end

 

