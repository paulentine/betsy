# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :find_order, only: %i[destroy order_items_order confirmation]
  skip_before_action :require_login, only: [:new, :create, :confirmation, :order_items_order, :checkout]

  def index
    merchant = @current_merchant
    if merchant
        @orders = merchant.orders
    else
        head :not_found
        return
    end
  end

  def checkout
    current_order.update(order_params)

    current_order.order_items.each do |order_item|
      unless (order_item.check_quantity)
        flash[:status] = :error
        flash[:message] = "#{order_item} only has #{@item.product.quantity} left in stock"
        redirect_to checkout_cart_path
      end
    end

    complete = current_order.valid?
    if complete
      # Update quantity in db
      current_order.order_items.each do |order_item|
        order_item.product.quantity -= order_item.quantity
      end
      # Mark as paid
      current_order.status = "paid"
      current_order.save
      redirect_to confirmation_path(current_order)
      # Clears shopping cart
      session[:order_id] = nil
    else
      flash[:status] = :error
      flash[:message] = "Could not complete order, please fill all fields"
      redirect_to checkout_cart_path
      # render :checkout, status: :bad_request
    end
  end

  def confirmation; end

  def order_items_order; end

  def merchant_orders_list; end

  def show
    @order = Order.find_by(id: params[:id])

    unless @order
      head :not_found
      return
    end
  end

  def new
    @order = Order.new
  end

  private

  def order_params
    params.require(:order).permit(:email, :name, :address, :zipcode, :cc_num, :cc_cvv, :cc_expiration, :status)
  end

  def find_order
    @order = Order.find_by(id: params[:order_id])

    unless @order
      head :not_found
      return
    end
  end
end
