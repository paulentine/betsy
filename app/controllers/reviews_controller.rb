class ReviewsController < ApplicationController
  skip_before_action :require_login, only: [:create, :new]

  def new
    @review = Review.new
    @product = Product.find(params[:product_id])
  end

  def create
    @review = Review.new(review_params)
    @product = Product.find(params[:product_id])
    @review.product_id = @product.id

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

  private

  def review_params
    return params.require(:review).permit(:rating, :review, product_id: [])
  end
end
