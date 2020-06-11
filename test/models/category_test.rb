require "test_helper"

describe Category do
  let(:new_category) { categories(:yoga) }
  let(:new_product) { products(:yogamat) }
  describe "validations" do 
    it "is valid when all required fields are present" do

      expect(new_category.valid?).must_equal true
    end

    it "is invalid when category name is NOT present" do
      new_category.name = nil
      expect(new_category.valid?).must_equal false
      expect(new_category.errors.messages).must_include :name
      expect(new_category.errors.messages[:name]).must_equal ["can't be blank"]
    end
  end 
  describe "relations" do 
    it "can have many products" do 
      expect(new_category.products.size).must_equal 1
    end 
    it "can have many categories" do 
      expect(new_product.categories.size).must_equal 1
    end 
  end 

  

end
