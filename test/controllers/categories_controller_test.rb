require "test_helper"

describe CategoriesController do
  let(:new_category) { categories(:yoga) }
  
  describe "index" do
    it "succeeds when there are categories" do
      get categories_path

      must_respond_with :success
    end

    it "succeeds when there are no categories" do
      Category.all do |category|
        category.destroy
      end

      get categories_path

      must_respond_with :success
    end
  end
  describe "new" do
    it "succeeds" do
      get new_category_path

      must_respond_with :success
    end
  end
  describe "create" do
    it "creates a category with valid data" do
      my_category = { category: { name: "socks" } }

      expect {
        post categories_path, params: my_category
      }.must_change "Category.count", 1

      category_id = Category.find_by(name: "socks").id

      must_respond_with :redirect
      must_redirect_to categories_path
    end

    it "renders bad_request and does not update the DB for bogus data" do
      bad_category = { category: { name: nil } }

      expect {
        post categories_path, params: bad_category
      }.wont_change "Category.count"

      must_respond_with :bad_request
    end
  end 

  describe "show" do
    it "succeeds for an extant category ID" do
      get category_path(new_category.id)

      must_respond_with :success
    end

    it "redirect for a bogus category ID" do
      invalid_id = -1

      get category_path(invalid_id)

      must_redirect_to categories_path
    end
  end

end
