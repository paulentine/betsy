class Product < ApplicationRecord
  belongs_to :merchant   # singular
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :orders
  has_many :reviews   # plural

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
