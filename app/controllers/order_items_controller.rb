# frozen_string_literal: true

class OrderItemsController < ApplicationController
  before_action :find_item, only: %i[destroy edit update]
  skip_before_action :require_login

  def create
    item = current_order.order_items.find_by(product_id: order_item_params[:product_id], order_id: session[:order_id])
    if order_item_params[:quantity].to_i < 1
      flash.now[:status] = :error
      flash.now[:message] = "Quantity must be 1 or greater"
      render :new, status: :bad_request
    end
    if item    
      item.quantity += order_item_params[:quantity].to_i
      item.save
      redirect_to cart_path
    else
      item = OrderItem.new(order_item_params)
      current_order.order_items << item
      current_order.save
      redirect_to cart_path
    end
  end

  def update
    item = current_order.order_items.find_by(product_id: order_item_params[:product_id], order_id: session[:order_id])
    item.quantity = order_item_params[:quantity].to_i
    item.save
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

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end

  def find_item
    @item = current_order.order_items.find_by(id: params[:id])
  end
end
