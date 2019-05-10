class OrdersController < ApplicationController
    before_action :find_order, only: [:destroy, :order_items_order, :confirmation]
    skip_before_action :require_login, only: [:new, :create, :confirmation, :order_items_order, :show]
    
    def index
        merchant = @current_merchant
        if merchant
            @orders = merchant.orders
        else
            head :not_found
            return
        end
    end

    def confirmation 
    end

    def order_items_order
    end

    def merchant_orders_list

    end
    
     def show
        @order = Order.find(params[:id])
    
        unless @order
        head :not_found
        return
        end
     end
    
    private
    
    def order_params
        return params.require(:order).permit(:email, :name, :address, :zipcode, :cc_num, :cc_cvv, :cc_expiration, :status)
    end
    
    def find_order
        @order = Order.find(params[:order_id])
    
        unless @order
        head :not_found
        return
        end
    end  
end
