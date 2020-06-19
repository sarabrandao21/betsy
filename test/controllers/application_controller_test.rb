require "test_helper"

describe ApplicationController do
  describe 'find_merchant' do
    it 'will save a login merchant id to session so it will allow merchant to access merchant restricted pages' do
      sharon = merchants(:sharon)
      perform_login(sharon)
      get new_product_path


      expect(session[:merchant_id]).must_equal sharon.id
      must_respond_with :success
    end
  end
end