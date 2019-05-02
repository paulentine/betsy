class Order < ApplicationRecord
  has_and_belongs_to_many :products

  validates :orders_products, presence: true

  def self.last4_ccnum(cc_num)
    return cc_num[cc_num.length - 4,4]
  end
end
