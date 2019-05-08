# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :order_items # plural
  # validates :order_items, presence: true
  validates :email, presence: true
  validates :name, presence: true
  validates :address, presence: true
  validates :zipcode, presence: true
  validates :cc_num, presence: true
  validates :cc_cvv, presence: true
  validates :cc_expiration, presence: true

  def self.last4_ccnum(cc_num)
    if cc_num.nil?
      return nil
    elsif cc_num.length < 4
      return cc_num
    else
      return cc_num[cc_num.length - 4,4]
    end
  end

  def self.total_revenue(merchant)
    order_item_hash = {}
    item_quantity = 0
    item_price = 0
    total_revenue = 0

    array_of_arrays_oi = []

    # merchant = Merchant.find(session[:merchant_id])
    # merchant = Merchant.find(1)
    # merchant = @current_merchant
    all_merchant_products = merchant.products
    all_merchant_products.each do |product|
      array_of_arrays_oi << OrderItem.where(product_id: product.id)
    end
    all_merchants_order_items = array_of_arrays_oi.flatten
    
    all_merchants_order_items.each do |order_item|
      product = Product.find(order_item.product_id)
      item_price = product.price
      item_quantity = order_item.quantity
      order_item_hash[item_price] = item_quantity
    end
    order_item_hash.each do |price, quantity|
      total_revenue += price * quantity
    end
    return total_revenue
  end

  def self.total_revenue_by_status(status)
    order_item_hash = {}
    item_quantity = 0
    item_price = 0
    total_revenue = 0
    array_of_arrays_oi = []

    # merchant = Merchant.find(session[:merchant_id])
    merchant = Merchant.find(1)
    all_merchant_products = merchant.products
    all_merchant_products.each do |product|
      array_of_arrays_oi << OrderItem.where(product_id: product.id)
    end
    all_merchants_order_items = array_of_arrays_oi.flatten
    order_items_with_status = []
    all_merchants_order_items.each do |order_item|
      if order_item.order.pending == status
        order_items_with_status << order_item
      end
    end
    all_order_items_with_status.each do |order_item|
      item_price = order_item.product_id.price
      item_quantity = order_item.quantity
      order_item_hash[item_price] = quantity
    end
    order_item_hash.each do |price, quantity|
      total_revenue += quantity * price
    end
    return total_revenue
  end

  
  def self.total_number_of_orders_by_status(status)
    order_item_hash = {}
    item_quantity = 0
    total_orders = 0
    array_of_arrays_oi = []

    # merchant = Merchant.find(session[:merchant_id])
    merchant = Merchant.find(1)
    all_merchant_products = merchant.products
    all_merchant_products.each do |product|
      array_of_arrays_oi << OrderItem.where(product_id: product.id)
    end
    all_merchants_order_items = array_of_arrays_oi.flatten
    order_items_with_status = []
    all_merchants_order_items.each do |order_item|
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

  def self.total_number_of_orders
    order_item_hash = {}
    item_quantity = 0
    total_orders = 0
    array_of_arrays_oi = []

    # merchant = Merchant.find(session[:merchant_id])
    merchant = Merchant.find(1)
    all_merchant_products = merchant.products
    all_merchant_products.each do |product|
      array_of_arrays_oi << OrderItem.where(product_id: product.id)
    end
    all_merchants_order_items = array_of_arrays_oi.flatten
    all_unique_orders = []
    all_merchants_order_items.each do |order_item|
      if all_unique_orders.exclude?(order_item.order_id)
        all_unique_orders << order_item.order_id
      end
    end
    return all_unique_orders.length
  end
end
