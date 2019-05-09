
class ProductsController < ApplicationController
  before_action :find_product, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_login, only: [:index, :show]

  def cart
    session[:cart] = []
  end

  def self.add_to_cart
    if self.quantity >= 1
      session[:cart].each do |item|
        if item.has_key?(self.id)
          item[self.id] += 1
        else
          session[:cart] << { self.id => 1 }
        end
        self.quantity -= 1
      end
    else
      flash[:status] = :error
      flash[:message] = "This item is out of stock."
      redirect_to product_path(self)
    end
  end

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.merchant_id = @current_merchant.id

    successful = @product.save

    if successful
      flash[:status] = :success
      flash[:message] = "Product added successfully"
      redirect_to product_path(@product.id)
    else
      flash.now[:status] = :error
      flash.now[:message] = "Product could not be added. Try again."
      render :new, status: :bad_request
    end
  end

  def edit
    unless @product.merchant_id == @current_merchant.id
      # does this get handled here or should we handle it in the view instead?
      # if a product doesn't belong to the current user, then they don't see the
      # edit/delete button on their view?
      flash[:status] = :error
      flash[:message] = "You cannot edit a product that is not yours"
      redirect_to product_path(@product)
    end
  end

  def update
    @product.merchant_id = @current_merchant.id
    if @product.update(product_params)
      flash[:status] = :success
      flash[:message] = "Successfully updated #{@product.name}"
      redirect_to product_path(@product)
    else
      flash.now[:status] = :error
      flash.now[:message] = "Could not save #{@product.name}"
      render :edit, status: :bad_request
    end
  end

  def destroy
    if @product.merchant_id == @current_merchant.id
      @product.deleted = !@product.deleted
      @product.save

      flash[:status] = :success
      flash[:message] = "Successfully deleted #{@product.name}"
      # not sure about this path? vv
      redirect_to merchant_path(Merchant.find(@product.merchant_id))
    else
      # does this get handled here or should we handle it in the view instead?
      # if a product doesn't belong to the current user, then they don't see the
      # edit/delete button on their view?
      flash[:status] = :error
      flash[:message] = "You cannot delete a product that is not yours"
      redirect_to product_path(@product)
    end
  end

  def set_status 
    # render merchant_path(@current_merchant.id)
    redirect_to merchant_path(@current_merchant, :status => params[:status])
  end

  private

  def product_params
    puts "product_prams totall called"
    return params.require(:product).permit(:name, :price, :description, :status, merchant_id: [])
  end

  def find_product
    @product = Product.find_by(id: params[:id])

    unless @product
      head :not_found
      return
    end
  end
end
