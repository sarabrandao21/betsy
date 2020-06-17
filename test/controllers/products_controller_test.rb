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
      new_product = { product: { name: "Yoga socks",  price: 20, stock: 20 } }

      expect {
        post products_path, params: new_product
      }.must_change "Product.count", 1

      must_respond_with :redirect

      must_redirect_to product_path(Product.find_by(name: "Yoga socks"))

    end

    it "renders bad_request and does not update the DB for bogus data" do
      perform_login(merchants(:sara))
      bad_product = { product: { name: "Yoga block" } }

      expect {
        post products_path, params: bad_product
      }.wont_change "Product.count"

      expect(flash[:error]).must_equal "Couldn't create product!"
      must_respond_with :bad_request
    end

    it "won't create new product is no merchant is log in" do

      new_product = { product: { name: "Yoga socks",  price: 20, stock: 20 } }

      expect {
        post products_path, params: new_product
      }.wont_change "Product.count"

      expect(flash[:error]).must_equal "You must log in to add product!"
      must_redirect_to products_path
    end
  end

  describe "show" do
    it "succeeds for an extant product ID" do
      get product_path(existing_product.id)

      must_respond_with :success
    end

    it "redirect for a bogus product ID" do
      destroyed_id = -1

      get product_path(destroyed_id)
      expect(flash[:notice]).must_equal"Product not found!😢"
      must_redirect_to products_path
    end


    it "redirect for a bogus product ID" do
      product = products(:chips)
      product.update(active: false)

      get product_path(product.id)
      expect(flash[:error]).must_equal "#{product.name} is not active!"
      must_redirect_to products_path
    end
  end

  describe "edit" do
    it "succeeds for an extant product ID" do
      perform_login(merchants(:sharon))
      get edit_product_path(existing_product.id)

      must_respond_with :success
    end

    it "won't let merchant to edit products that are not belong to that merchant" do
      perform_login(merchants(:sara))
      get edit_product_path(existing_product.id)

      expect(flash[:error]).must_equal "You are not authorized to edit this product #{existing_product.name}'!"
      must_redirect_to products_path
    end


    it "cannot edit a product if not login " do
      get edit_product_path(existing_product.id)

      expect(flash[:error]).must_equal "You are not authorized to edit this product #{existing_product.name}'!"
      must_redirect_to products_path
    end

    it "redirect for a bogus product ID" do
      bogus_id = -1
    
      get edit_product_path(bogus_id)

      must_redirect_to products_path
    end
  end

  describe "update" do
    it "succeeds for valid data and an extant product ID" do
      # product = Product.create!(name: 'Carrot Juice', merchant: merchants(:sharon))
      product = products(:healthysnack)
  
      # binding.pry
      update_hash = {
        product: {
          name: 'Watermelon Juice',
        }
      }
      
      expect(product.name).must_equal "healthy snack"

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
      bogus_id = -1
      put product_path(bogus_id), params: { product: { name: "yoga mat" } }

      must_redirect_to products_path
    end
  end

  describe "toggle_active" do
      it "will toggle active/inactive status for a product that has more than 1 stock" do
        product = products(:yogamat)
        
        # default true for active status for each prodcuts
        expect(product.active).must_equal true
        expect{patch toggle_active_path(product.id)}.wont_change 'Product.count'
        product.reload
        # toggle from active to inactive
        expect(product.active).must_equal false

        expect{patch toggle_active_path(product.id)}.wont_change 'Product.count'
        product.reload
        # toggle back to active
        expect(product.active).must_equal true
      end
      
      it "won't toggle inactive to active if the stock is less than 1" do
        product = products(:healthybeans)

        patch product_path(product.id), params: {product: {stock: 0}}
        product.reload
        expect(product.active).must_equal false # 0 inventory will turn active status to false
        expect{patch toggle_active_path(product.id)}.wont_change 'Product.count'
        product.reload
        expect(product.active).must_equal false 
        # it won't allow 0 inventory product to change to active until being restocked
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