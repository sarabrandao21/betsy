require "test_helper"

describe Category do
  let(:new_category) { categories(:yoga) }
  let(:new_relation) { categories_products(:yoga_yogamat) }
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
    #category has many products, products can have many categories 
    it "can have many products" do 
      new_category.reload

      expect(new_category.products.size).must_equal 1
    end 
  end 

  

end
