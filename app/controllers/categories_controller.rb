class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:status] = :success
      flash[:message] = "Category was successfully created."
      redirect_to categories_path
    else
      flash.now[:status] = :error
      flash.now[:message] = "Category not created"
      render :new, status: :bad_request
    end
  end

  private

  def category_params
    params.require(:category).permit(:category)
  end
end
