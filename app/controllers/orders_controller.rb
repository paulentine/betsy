class OrdersController < ApplicationController
    before_action :find_order, only: [:show, :destroy, :order_items_order, :confirmation]
    skip_before_action :require_login, only: [:new, :create, :confirmation]
    
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
    
    def new
        @order = Order.new
    end
    
    def create
        @order = Order.new(order_params)

        successful = @order.save
        if successful
            flash[:status] = :success
            flash[:message] = "Successfully created order with ID ##{@order.id}"
            redirect_to order_confirmation_path
        else
            flash.now[:status] = :error
            flash.now[:message] = "Could not create order"
            render :new, status: :bad_request
        end
    end

    def confirmation 
    end

    def order_items_order
    end

    def merchant_orders_list

    end
    
    # Show is entirely the find_order helper
     def show; end
    
    private
    
    def order_params
        return params.require(:order).permit(:id, :email, :name, :address, :zipcode, :cc_num, :cc_cvv, :cc_expiration, :status)
    end
    
    def find_order
        @order = Order.find(params[:order_id])
    
        unless @order
        head :not_found
        return
        end
    end  
end
