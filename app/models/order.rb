# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :order_items # plural

  def self.last4_ccnum(cc_num)
    return cc_num[cc_num.length - 4,4]
  end
  # validates :order_item, presence: true

  def self.total_revenue
    order_item_hash = {}
    item_quantity = 0
    item_price = 0
    total_revenue = 0
    all_order_items = OrderItem.where(product_id.where(merchant_id: session[:merchant_id]))
    all_order_items.each do |order_item|
      item_price = order_item.product_id.price
      item_quantity = order_item.quantity
      order_item_hash[:item_price] = quantity
    end
    order_item_hash.each do |price, quantity|
      total_revenue += quantity * price
    end
  end

  def self.total_revenue_by_status(status)
    order_item_hash = {}
    item_quantity = 0
    item_price = 0
    total_revenue = 0
    # orders_with_status = Order.where(status: status)
    OrderItem.where(product_id.where(merchant_id: session[:merchant_id])
    (Order.where(status: status))
  end
I need all orderitems from orders with the status

  def self.total_number_of_orders_by_status(status)
    return "TO DO"
  end
end
