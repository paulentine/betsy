# frozen_string_literal: true

class OrderItemsController < ApplicationController
  before_action :find_item, only: %i[destroy edit]

  def create
    item = current_order.order_items.find_by(product_id: order_item_params[:product_id], order_id: session[:order_id])
    if item    
      item.quantity += order_item_params[:quantity].to_i
      item.save
      redirect_to cart_path
    else
      item = OrderItem.new(order_item_params)
      current_order.order_items << item
      current_order.save # Is this nec?
      redirect_to cart_path
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

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end

  def find_item
    @item = current_order.order_items.find_by(id: params[:id])
  end
end
