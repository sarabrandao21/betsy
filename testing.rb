require "test_helper"

describe ProductsController do
  let(:existing_product) { products(:yogamat) }

  describe "index" do
    it "succeeds when there are products" do
      get products_path

      must_respond_with :success
    end

    it "succeeds when there are no products" do
      Product.all do |product|
        product.destroy
      end

      get products_path

      must_respond_with :success
    end
  end

  describe "new" do
    it "succeeds if there is a valid merchant logged in" do
      perform_login(merchants(:sara))
      get new_product_path

      must_respond_with :success
    end

    it "will redirect if there is no merchant log in" do
      get new_product_path

      must_redirect_to products_path
    end
  end

  describe "create" do
    it "creates a product with valid data for a real category" do
      perform_login(merchants(:sara))
      new_product = { product: { name: "Yoga socks", merchant_id: merchants(:sharon).id, price: 20, stock: 20 } }

      expect {
        post products_path, params: new_product
      }.must_change "Product.count", 1

      new_product_id = Product.find_by(name: "Yoga socks").id

      must_respond_with :redirect
      must_redirect_to products_path
    end

    it "renders bad_request and does not update the DB for bogus data" do
      perform_login(merchants(:sara))
      bad_product = { product: { name: "Yoga block" } }

      expect {
        post products_path, params: bad_product
      }.wont_change "Product.count"

      must_respond_with :bad_request
    end

    # TODO : update once we have categories!!!!!!!!!
    # it "renders 400 bad_request for bogus categories" do
    #   INVALID_CATEGORIES.each do |category|
    #     invalid_product = { product: { name: "Invalid product", category: category } }

    #     expect { post products_path, params: invalid_product }.wont_change "product.count"

    #     expect(product.find_by(name: "Invalid product", category: category)).must_be_nil
    #     must_respond_with :bad_request
    #   end
    # end
  end

  describe "show" do
    it "succeeds for an extant product ID" do
      get product_path(existing_product.id)

      must_respond_with :success
    end

    it "redirect for a bogus product ID" do
      destroyed_id = -1

      get product_path(destroyed_id)

      must_redirect_to products_path
    end
  end

  describe "edit" do
    it "succeeds for an extant product ID" do
      perform_login(merchants(:sharon))
      get edit_product_path(existing_product.id)

      must_respond_with :success
    end

    it "redirect for a bogus product ID" do
      bogus_id = existing_product.id
      existing_product.destroy

      get edit_product_path(bogus_id)

      must_redirect_to products_path
    end
  end

  describe "update" do
    it "succeeds for valid data and an extant product ID" do
      # product = Product.create!(name: 'Carrot Juice', merchant: merchants(:sharon))
      product = products(:juice)
  
      # binding.pry
      update_hash = {
        product: {
          name: 'Watermelon Juice',
        }
      }
      
      expect(product.name).must_equal "Fresh Juice"

      expect { 
          patch product_path(product.id), params: update_hash
        }.wont_change "Product.count"

      product.reload
      # updated_product = Product.find_by(id: product.id)
      expect(product.name).must_equal update_hash[:product][:name]
    end

    it "renders bad_request for bogus data" do
      updates = { product: { name: nil } }

      expect {
        put product_path(existing_product), params: updates
      }.wont_change "Product.count"

      product = Product.find_by(id: existing_product.id)

      must_respond_with :bad_request
    end

    it "must redirect for a bogus product ID" do
      bogus_id = existing_product.id
      existing_product.destroy

      put product_path(bogus_id), params: { product: { name: "yoga mat" } }

      must_redirect_to products_path
    end
  end

  # TODO: to add toggle_active test!!!!!
  # describe "destroy" do
  #   it "succeeds for an extant product ID" do
  #     expect {
  #       delete product_path(existing_product.id)
  #     }.must_change "Product.count", -1

  #     must_respond_with :redirect
  #     must_redirect_to products_path
  #   end

  #   it "redirect back to products_path and does not update the DB for a bogus product ID" do
  #     bogus_id = existing_product.id
  #     existing_product.destroy

  #     expect {
  #       delete product_path(bogus_id)
  #     }.wont_change "Product.count"

  #     must_redirect_to products_path
  #   end
  # end

end