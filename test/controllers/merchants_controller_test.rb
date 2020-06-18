require "test_helper"

describe MerchantsController do

  describe "index" do
    it "responds with success" do
      get merchants_path
      must_respond_with :success
    end

    it "responds with success even when there are no merchants" do
      merchants = Merchant.all 
      merchants.each do |merchant|
        merchant.destroy
      end
      expect(Merchant.all).must_equal [] 

      get merchants_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid merchant" do
      merchant = merchants(:nataliya)
      get merchants_path(merchant.id)
      must_respond_with :success
    end

    it "responds with 404 for an invalid merchant id" do
      merchant_id = -1
      merchant = Merchant.find_by(id: merchant_id)
      assert_nil merchant

      get merchant_path(merchant_id)
      must_respond_with :missing
    end
  end

  describe "auth_callback" do
    it "logs in an existing merchant and redirects to the root route" do
      start_count = Merchant.count
      merchant = merchants(:nataliya)

      perform_login(merchant)
      
      must_redirect_to root_path
      _(session[:merchant_id]).must_equal merchant.id
      _(Merchant.count).must_equal start_count
    end

    it "creates an account for a new merchant and redirects to the root route" do
      start_count = Merchant.count
      merchant = Merchant.new(provider: "github", uid: 99999, username: "test_merchant", email: "test@merchant.com")
    
      perform_login(merchant)

      must_redirect_to root_path
      _(Merchant.count).must_equal start_count + 1
      _(session[:merchant_id]).must_equal Merchant.last.id
    end

    it "redirects to the login route if given invalid merchant data" do
      start_count = Merchant.count
      merchant = Merchant.new(provider: "", uid: "", username: "", email: "")

      perform_login(merchant)

      must_redirect_to root_path
      assert_nil session[:merchant_id]
      _(Merchant.count).must_equal start_count
    end
  end

  describe "logout" do
    it "logs out the merchant and redirects to root path" do
      start_count = Merchant.count
      merchant = merchants(:nataliya)
      perform_login(merchant)

      post logout_path

      must_redirect_to root_path
      assert_nil session[:merchant_id]
      _(Merchant.count).must_equal start_count
    end
  end

  
  describe 'dashboard' do
    it 'will let log in merchant to see their own merchant dashboard page' do
      perform_login(merchants(:sharon))

      get dashboard_path

      must_respond_with :success

    end

    it 'will let log in merchant to see their own merchant dashboard page' do
      get dashboard_path

      must_redirect_to merchants_path 
      expect(flash[:error]).must_equal "Sorry you are not authorized to this page"
    end

    it 'will let log in merchant to filter their items by status - Active' do
      sharon = merchants(:sharon)
      filter_params = {status: 'Active'}
      perform_login(sharon)
      
      get dashboard_path, params: filter_params     

      must_respond_with :success
    end

    it 'will let log in merchant to filter their items by status - Inactive ' do
      sharon = merchants(:sharon)
      filter_params = {status: 'Inactive'}
      perform_login(sharon)
      get dashboard_path, params: filter_params     
      
      must_respond_with :success
    end

    it 'will let log in merchant to filter their items by status - All' do
      sharon = merchants(:sharon)
      filter_params = {status: 'All'}
      perform_login(sharon)
      get dashboard_path, params: filter_params     
      
      must_respond_with :success
    end
  end

end
