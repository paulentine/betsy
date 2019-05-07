# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :order_items # plural

  def self.last4_ccnum(cc_num)
    if cc_num.length < 4
      return cc_num
    end
    return cc_num[cc_num.length - 4,4]
  end
  # validates :order_item, presence: true

  def self.total_revenue
    order_item_hash = {}
    item_quantity = 0
    item_price = 0
    total_revenue = 0
    all_order_items = OrderItem.where(product_id: product_id.find_by(merchant_id: session[:merchant_id]))
    all_order_items.each do |order_item|
      item_price = order_item.product_id.price
      item_quantity = order_item.quantity
      order_item_hash[:item_price] = quantity
    end
    order_item_hash.each do |price, quantity|
      total_revenue += quantity * price
    end
    return total_revenue
  end

  def self.total_revenue_by_status(status)
    order_item_hash = {}
    item_quantity = 0
    item_price = 0
    total_revenue = 0
    all_order_items_for_merchant = OrderItem.where(product_id: product_id.where(merchant_id: session[:merchant_id]))
    order_items_with_status = []
    all_order_items_for_merchant.each do |order_item|
      if order_item.order.pending == status
        order_items_with_status << order_item
      end
    end
    all_order_items_with_status.each do |order_item|
      item_price = order_item.product_id.price
      item_quantity = order_item.quantity
      order_item_hash[:item_price] = quantity
    end
    order_item_hash.each do |price, quantity|
      total_revenue += quantity * price
    end
    return total_revenue
  end

  
  def self.total_number_of_orders_by_status(status)
    order_item_hash = {}
    item_quantity = 0
    item_price = 0
    total_orders = 0
    all_order_items_for_merchant = OrderItem.where(product_id: product_id.where(merchant_id: session[:merchant_id]))
    all_order_items_for_merchant.each do |order_item|
      if order_item.order.pending == status
        order_items_with_status << order_item
      end
    end
    all_unique_orders = []
    order_items_with_status.each do |order_item|
      if all_unique_orders.exclude(order_item.order_id)
        all_unique_orders << order_item.order_id
      end
    end
    return all_unique_orders.length
  end
end
