# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_login, :list_categories, :current_merchant, :current_order

  def list_categories
    @categories = Category.all
  end

  def current_merchant
    @current_merchant ||= Merchant.find(session[:merchant_id]) if session[:merchant_id]
  end

  def require_login
    if current_merchant.nil?
      flash[:error] = "You must be logged in to view this section"
      redirect_to login_path
    end
  end

  def current_order
    unless @current_order
      if session[:order_id]
        @current_order = Order.find(session[:order_id])
      else
        @current_order = Order.create
        session[:order_id] = @current_order.id
      end
    end
    @current_order
  end
end
