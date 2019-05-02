class Category < ApplicationRecord
  validates :category, presence: true
  has_and_belongs_to_many :products
end
