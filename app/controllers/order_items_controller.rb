# frozen_string_literal: true

class OrderItemsController < ApplicationController
  before_action :find_item, only: %i[destroy edit update]
  before_action :find_item_in_order, only: [:create, :update, :enough_stock?]
  skip_before_action :require_login

  def create
    if @item
      if is_positive? && enough_stock?
        @item.quantity = order_item_params[:quantity].to_i
        @item.product.quantity -= order_item_params[:quantity].to_i
        @item.product.save
        @item.save
        redirect_to cart_path
        raise
      else
        flash[:status] = :error
        flash[:message] = "This experience only has #{@item.product.quantity} left in stock"
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
    if is_positive? && enough_stock?
      @item.quantity = order_item_params[:quantity].to_i
      @item.product.quantity -= order_item_params[:quantity].to_i
      @item.save
      redirect_to cart_path
    else
      flash[:status] = :error
      flash[:message] = "This experience only has #{@item.product.quantity} left in stock"
      redirect_to request.referrer
    end
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
    order_item_params[:quantity].to_i > 1 ? true : false
  end

  def enough_stock?
    (@item.product.quantity) >= (order_item_params[:quantity].to_i) ? true : false
  end

  def flash_not_positive
    flash[:status] = :error
    flash[:message] = "Quantity must be 1 or greater"
  end

  def flash_not_enough_stock
    flash[:status] = :error
    flash[:message] = "Not enough stock"
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