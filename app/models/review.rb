class Review < ApplicationRecord
  belongs_to :product
  validates :name, presence: true
  validates :comment, presence: true
  validates :rating, numericality: { only_integer: true }, inclusion: 1..5
end
