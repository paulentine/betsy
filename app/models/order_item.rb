class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  has_one :merchant, through: :product

  validates :order, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def self.cart_total(order_items)
    total = 0
    item_price = 0
    item_quantity = 0
    order_item_array = []
    order_item_hash = {}

    order_items.each do |order_item|
      item_price = order_item.product.price
      item_quantity = order_item.quantity

      order_item_hash[item_price] = item_quantity
    end

    order_item_hash.each do |price, quantity|
      total += quantity * price
    end
    return total
  end

  def reduce_product_stock
    current_stock = self.product.quantity - self.quantity
    return self.product.update(quantity: current_stock)
  end
end
