# frozen_string_literal: true

class MerchantsController < ApplicationController
  before_action :find_merchant, only: [:show, :new]
  skip_before_action :require_login, only: [:create, :show]

  def index
    @merchants = Merchant.all
  end


  def show
    @current_merchant
    @status = params[:status] || "all"
  end

  def create
    auth_hash = request.env['omniauth.auth']
    puts "auth_hash not initialized :'(" if auth_hash.nil?

    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: 'github')
    if merchant
      # Merchant was found in the database
      flash[:status] = :success
      flash[:message] = "Logged in as returning merchant #{merchant.username}"
    else
      # Merchant doesn't match anything in the DB
      # Attempt to create a new merchant
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:status] = :success
        flash[:message] = "Logged in as new merchant #{merchant.username}"
      else
        # Couldn't save the merchant for some reason. If we
        # hit this it probably means there's a bug with the
        # way we've configured GitHub. Our strategy will
        # be to display error messages to make future
        # debugging easier.
        flash[:status] = :error
        flash[:message] = "Could not create new merchant account: #{merchant.errors.messages}"
        return redirect_to root_path
      end
    end

    # If we get here, we have a valid merchant instance
    session[:merchant_id] = merchant.id
    redirect_to root_path
  end

  def current
    @current_merchant = Merchant.find_by(id: session[:merchant_id])

    unless @current_merchant
      flash[:status] = :error
      flash[:message] = 'You must be logged in to see this page'
      redirect_to login_path
      return
    end
  end

  def destroy # Destroy action = logout
    session[:merchant_id] = nil
    session[:status] = nil
    flash[:status] = :success
    flash[:message] = 'Successfully logged out!'

    redirect_to root_path
  end

  # Show is entirely handled by find_merchant helper method

  

  private

  def merchant_params
    return params.require(:merchant).permit(:username, :email, :status)
  end

  def find_merchant
    @merchant = Merchant.find_by(id: params[:id])
    ## MADE MERCHANT.FIRST IN ORDER TO NAVIGATE SITE
    # @merchant = Merchant.first
    unless @merchant
      head :not_found
      return
    end
  end
end
