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

end
