class DropOrdersProductsJoinTable < ActiveRecord::Migration[5.2]
  def change
    drop_join_table :orders, :products 
  end
end
