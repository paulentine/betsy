class ApplicationController < ActionController::Base
  before_action :require_login,
  before_action :list_categories, 
  before_action :current_merchant

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
end
