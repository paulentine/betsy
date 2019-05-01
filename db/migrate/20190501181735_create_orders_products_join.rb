class CreateOrdersProductsJoin < ActiveRecord::Migration[5.2]
  def change
    create_table :orders_products do |t|
      t.belongs_to :order, index: :true
      t.belongs_to :product, index: :true
    end
  end
end
