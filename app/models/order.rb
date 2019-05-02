# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :order_items # plural

  def self.last4_ccnum(cc_num)
    return cc_num[cc_num.length - 4,4]
  end
  # validates :orders_products, presence: true
end
