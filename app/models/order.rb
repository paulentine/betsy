class Order < ApplicationRecord
  has_many :order_items, inverse_of: :order
  has_many :products, :through => :order_items

  # TODO: DON'T FORGET TO REAPPLY THESE WHEN ORDER STATUS IS NO LONGER PENDING
  # ALSO: DRY UP WITH BEFORE_ACTION: FIND_MERCHANT
  validates :status, presence: true, inclusion: { in: %w(pending paid) }
  validates :name, presence: true, if: :is_not_pending,
                   format: { with: /[a-zA-Z]{2,}/, message: "name must be at least 2 characters long" }
  validates :email, presence: true, if: :is_not_pending,
                    format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "email must contain no white spaces" }
  validates :address, presence: true, if: :is_not_pending
  validates :cc_num, presence: true, if: :is_not_pending,
                     format: { with: /(\d{4}[- ]){4}\d{4}|\d{16}/, message: "card information must present 16 digits" }
  validates :cc_expiration, presence: true, if: :is_not_pending,
                            format: { with: /\A(0[1-9]|1[0-2])\/?([0-9]{4}|[0-9]{2})\z/, message: "must be in format MMYYYY" }
  validates :cc_cvv, presence: true, if: :is_not_pending,
                     format: { with: /\A[0-9]{3}\z/, message: "must be 3 digits" }
  validates :zip_code, presence: true, if: :is_not_pending,
                       format: { with: /\A[0-9]{5}(?:-[0-9]{4})?\z/, message: "please input a valid postal code" }

  def self.validate
    return
  end

  def self.last4_ccnum(cc_num)
    if cc_num.nil?
      return nil
    elsif cc_num.length < 4
      return cc_num
    else
      return cc_num[cc_num.length - 4, 4]
    end
  end

  # I MOVED THIS METHOD TO MERCHANT MODEL FOR NOW -GRACE

  # def self.total_revenue(merchant)
  #   order_item_hash = {}
  #   item_quantity = 0
  #   item_price = 0
  #   total_revenue = 0

  #   array_of_arrays_oi = []

  #   all_merchants_order_items = merchant.order_items

  #   all_merchants_order_items.each do |order_item|
  #     product = Product.find(order_item.product_id)
  #     item_price = product.price
  #     item_quantity = order_item.quantity
  #     order_item_hash[item_price] = item_quantity
  #   end

  #   order_item_hash.each do |price, quantity|
  #     total_revenue += price * quantity
  #   end
  #   return total_revenue
  # end

  def self.total_revenue_by_status(merchant: merchant, status: status)
    order_item_hash = {}
    item_quantity = 0
    item_price = 0
    total_revenue = 0
    array_of_arrays_oi = []

    if status == "all"
      return Order.total_revenue(merchant)
    end

    all_merchants_order_items = merchant.order_items

    order_items_with_status = []
    all_merchants_order_items.each do |order_item|
      if order_item.order.status == status
        order_items_with_status << order_item
      end
    end
    order_items_with_status.each do |order_item|
      item_price = order_item.product.price
      item_quantity = order_item.quantity
      order_item_hash[item_price] = item_quantity
    end

    order_item_hash.each do |price, quantity|
      total_revenue += quantity * price
    end
    return total_revenue
  end

  def self.total_number_of_orders_by_status(merchant: merchant, status: status)
    order_item_hash = {}
    item_quantity = 0
    total_orders = 0
    array_of_arrays_oi = []

    if status == "all"
      return Order.total_number_of_orders(merchant)
    end

    all_merchants_order_items = merchant.order_items
    order_items_with_status = []
    all_merchants_order_items.each do |order_item|
      if order_item.order.status == status
        order_items_with_status << order_item
      end
    end
    all_unique_orders = []
    order_items_with_status.each do |order_item|
      if all_unique_orders.exclude?(order_item.order_id)
        all_unique_orders << order_item.order_id
      end
    end
    return all_unique_orders.length
  end

  def self.total_number_of_orders(merchant)
    return merchant.orders.length
  end

  def self.cart_total(cart)
    total = 0
    item_price = 0
    item_quantity = 0
    order_item_array = []
    order_item_hash = {}

    cart.order_items.each do |order_item|
      item_price = order_item.product.price
      item_quantity = order_item.quantity

      order_item_hash[item_price] = item_quantity
    end

    order_item_hash.each do |price, quantity|
      total += quantity * price
    end
    return total
  end
end
