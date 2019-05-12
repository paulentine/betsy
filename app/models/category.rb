class Category < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  has_and_belongs_to_many :products

  def self.filter_by_category(params)
    category = Category.find_by(id: params[:id])
    @products = category.products.select { |p| p.active }
  end
end
