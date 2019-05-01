class Merchant < ApplicationRecord
  has_many :products   # plural

  validates :username, presence: true, uniqueness: true
end
