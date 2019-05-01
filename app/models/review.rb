class Review < ApplicationRecord
  belongs_to :product   # singular

  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
end
