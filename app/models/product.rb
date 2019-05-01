class Product < ApplicationRecord
  belongs_to :merchant   # singular
  has_and_belongs_to_many :orders
end
