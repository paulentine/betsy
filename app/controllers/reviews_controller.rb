class ReviewsController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new
    @review.product_id = params[:product_id]

    successful = @review.save

    if successful
      flash[:status] = :success
      flash[:message] = "Review added successfully"
      redirect_to product_path(params[:product_id])
    else
      flash.now[:status] = :error
      flash.now[:message] = "Product could not be added. Try again."
      render :new, status: :bad_request
    end
  end
end
