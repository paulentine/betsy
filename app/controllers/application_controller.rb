class ApplicationController < ActionController::Base
  before_action :require_login, :list_categories, :current_merchant

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
    @current_order ||= Order.find(session[:order_id]) if session[:order_id]
  end
end
