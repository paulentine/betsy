class Product < ApplicationRecord
  belongs_to :merchant   # singular
  has_many :order_items   # plural
  has_many :reviews   # plural
  has_and_belongs_to_many :categories

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { only_float: true, greater_than: 0 }

  scope :status, ->(status) { where :status => status }
end
