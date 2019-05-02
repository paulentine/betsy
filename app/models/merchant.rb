class Merchant < ApplicationRecord
  has_many :products   # plural

  validates :username, presence: true, uniqueness: true

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.name = auth_hash["info"]["name"]
    merchant.email = auth_hash["info"]["email"]

    # Note that the user has not been saved.
    # We'll choose to do the saving outside of this method
    return merchant
  end
end
