class ReviewsController < ApplicationController
  def create
    review = Review.new
    review.product_id = params[:product_id]
    review.save

    redirect_to product_path(params[:product_id])
    return
  end
end
