# frozen_string_literal: true

class OrderItemsController < ApplicationController
  def create
    item = OrderItem.new(order_item_params)
    current_order.order_items << item
    current_order.save # Is this nec?
    redirect_to products_path
  end

  def destroy
    @item = current_order.order_items.find(params[:id])
    @item.destroy
    current_order.save

    redirect_to cart_path
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end
end
