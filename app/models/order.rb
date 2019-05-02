# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :order_items # plural

  # validates :orders_products, presence: true
end
