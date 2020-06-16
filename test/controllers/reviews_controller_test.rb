require "test_helper"

describe ReviewsController do
  describe 'create' do
    it 'can create a new review with valid params provided' do
      review_params = {
        review: {
          comment: 'Love this product!' , 
          product_id: products(:yogamat).id  , 
          reviewer: 'Sharon', 
          rating: 4,
        }
      }
      
      expect{post reviews_path, params: review_params}.must_differ 'Review.count', 1
      must_respond_with :redirect

      expect(Review.last.comment).must_equal review_params[:review][:comment]
      expect(Review.last.product_id).must_equal review_params[:review][:product_id]
      expect(Review.last.reviewer).must_equal review_params[:review][:reviewer]
      expect(Review.last.rating).must_equal review_params[:review][:rating]
    end

    it "won't create a new review if reviewer is not provided" do
      review_params = {
        review: {
          comment: 'Love this product!' , 
          product_id: products(:yogamat).id  , 
          rating: 4,
        }
      }
      
      expect{post reviews_path, params: review_params}.wont_change 'Review.count', 1
      must_respond_with :redirect
    end

    it "won't create a new review if the ratiing is not within range" do
      review_params = {
        review: {
          comment: 'Love this product!' , 
          product_id: products(:yogamat).id  , 
          rating: 10,
        }
      }
      
      expect{post reviews_path, params: review_params}.wont_change 'Review.count', 1
      must_respond_with :redirect
    end
  end
end