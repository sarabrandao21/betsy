require "test_helper"

describe Product do
  let(:product_with_category) { products(:yogamat) }
  before do 
    @new_product = Product.new(name:"Air Force Ones", price:150, merchant_id: merchants(:sharon).id, stock: 25)
    
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

  it "recieves error if Stock is missing" do
    @new_product.stock = nil
  
    expect(@new_product.valid?).must_equal false
    expect(@new_product.errors.messages).must_include :stock
    expect(@new_product.errors.messages[:stock]).must_equal ["can't be blank", "is not a number"]
  end
end
  describe "custom methods" do

    describe "self.popular_products " do
      it  "return the top ten products when less than 12"do
        top_products = Product.popular_products
        expect(top_products.length).must_equal 11
        expect(top_products.length).wont_be_nil
      end

      it "return the top 12 popular products" do
        Product.create!(name: "WaterSport Gear", price: 150, merchant: merchants(:sharon), stock: 20)
        expect(Product.last.name).must_equal "WaterSport Gear"
        top_products = Product.popular_products
        expect(top_products.length).must_equal 12
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

  it "can have none or many categories" do 
    expect(product_with_category.categories.size).must_equal 1 
    expect(@new_product.categories.size).must_equal 0 
  end 
end



