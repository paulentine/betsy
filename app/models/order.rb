class Order < ApplicationRecord
  has_and_belongs_to_many :products

  validates :orders_products, presence: true
end
