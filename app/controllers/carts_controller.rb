# frozen_string_literal: true

class CartsController < ApplicationController
  skip_before_action :require_login
  def show
    @order_items = current_order.order_items
  end

  def checkout
    @order = current_order
  end
end
