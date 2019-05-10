# frozen_string_literal: true

class OrderItemsController < ApplicationController
  before_action :find_item, only: %i[destroy edit update]
  before_action :find_item_in_order, only: [:create, :update, :enough_stock?]
  skip_before_action :require_login

  def create
    if @item
      if is_positive? && enough_stock?
        @item.quantity += order_item_params[:quantity].to_i
        @item.save
        redirect_to cart_path
      else
        redirect_to request.referrer
      end
    else
      @item = OrderItem.new(order_item_params)
      current_order.order_items << @item
      current_order.save
      redirect_to cart_path
    end
  end

  def update 
    @item.quantity = order_item_params[:quantity].to_i
    @item.save
    redirect_to cart_path
  end

  def destroy # Remove from cart
    unless @item
      head :not_found
      return
    end

    @item.destroy

    redirect_to cart_path
  end

  def is_positive?
    if order_item_params[:quantity].to_i < 1
      flash[:status] = :error
      flash[:message] = "Quantity must be 1 or greater"
      return false
    else
      return true
    end
  end

  def enough_stock?
    if @item.product.quantity < order_item_params[:quantity].to_i
      flash[:status] = :error
      flash[:message] = "Not enough stock"
      return false
    else
      return true
    end
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end

  def find_item
    return @item = current_order.order_items.find_by(id: params[:id])
  end

  def find_item_in_order
    return @item = current_order.order_items.find_by(product_id: order_item_params[:product_id], order_id: session[:order_id])
  end
end