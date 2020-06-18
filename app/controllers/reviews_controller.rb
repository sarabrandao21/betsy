class ReviewsController < ApplicationController
  before_action :find_merchant

  def create
    @review = Review.new(review_params)
    if (@login_merchant == @review.product.merchant)
      flash[:error] = "So sorry but you can't review your own product..."
      redirect_back fallback_location: root_path
    else
      if @review.save
        flash[:success] = "Thank you for your review on the product!"
        redirect_back fallback_location: root_path
      else
        flash[:error] = "No review created. Please provide all required fields to add a review!"
        redirect_back fallback_location: root_path
      end
    end
  end

  def review_params
    params.require(:review).permit(:comment, :product_id, :reviewer, :rating)
  end
end