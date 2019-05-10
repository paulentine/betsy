# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :find_order, only: %i[destroy order_items_order confirmation]
  skip_before_action :require_login, only: %i[new create confirmation order_items_order show]

  def index
    if params[:merchant_id]

      merchant = Merchant.find_by(id: params[:merchant_id])
      if merchant
        @orders = merchant.orders
      else
        head :not_found
        return
        end
    end
  end

  def checkout
    current_order.update(order_params)
    redirect_to confirmation_path(current_order)
  end

  def confirmation; end

  def order_items_order; end

  def merchant_orders_list; end

  # Show is entirely the find_order helper
  def show
    @order = Order.find(params[:id])

    unless @order
      head :not_found
      return
    end
  end

  private

  def order_params
    params.require(:order).permit(:email, :name, :address, :zipcode, :cc_num, :cc_cvv, :cc_expiration, :status)
  end

  def find_order
    @order = Order.find(params[:order_id])

    unless @order
      head :not_found
      return
    end
  end
end
