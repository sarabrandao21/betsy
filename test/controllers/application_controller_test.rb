require "test_helper"

describe ApplicationController do
    # Setup Anonymous Controller for testing
  describe 'find_merchant' do
    it 'will save a login merchant id to session so it will allow merchant to access merchant restricted pages' do
      get new_product_path


      expect(session[:merchant_id]).must_equal sharon.id
      expect{find_merchant}.must_equal 
      must_respond_with :success
    end
  end
end