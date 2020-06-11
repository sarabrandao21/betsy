class ReviewsController < ApplicationController
  def create
    @review = Review.new(review_params)

    respond_to do |format|
      # rendering js partials
      format.js {
        if @review.save
          flash.now[:sucess] = "Review added!"
          @reviews = Review.where(product_id: @review.product_id)
          render 'reviews/create'
        else
          # unable to save
          flash[:error] = @review.error.messages
          redirect_to product_path(@review.product_id)
        end
      }
    end
  end

  def review_params
    params.require(:review).permit(:comment, :product_id, :reviewer, :rating)
  end
end