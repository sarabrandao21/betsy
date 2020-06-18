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
      expect(flash[:success]).must_equal  "Thank you for your review on the product!"

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
      expect(flash[:error]).must_equal "No review created. Please provide all required fields to add a review!"
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
      expect(flash[:error]).must_equal "No review created. Please provide all required fields to add a review!"
    end

    it "won't let a logined merchant to review own product" do
      perform_login(merchant = merchants(:sharon))
      review_params = {
        review: {
          comment: 'Love this product!' , 
          product_id: products(:yogamat).id  , 
          rating: 4,
        }
      }

      expect{post reviews_path, params: review_params}.wont_change 'Review.count', 1
      must_respond_with :redirect
      expect(flash[:error]).must_equal "So sorry but you can't review your own product..."
    end
  end
end