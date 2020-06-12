class ReviewsController < ApplicationController
  def create
    @review = Review.new(review_params)
    if @review.save
      flash[:success] = "Thank you for your review on the product!"
      redirect_back fallback_location: root_path
    else
      flash[:error] = "Cannot create review...."
      redirect_back fallback_location: root_path
    end
  end

  def review_params
    params.require(:review).permit(:comment, :product_id, :reviewer, :rating)
  end
end