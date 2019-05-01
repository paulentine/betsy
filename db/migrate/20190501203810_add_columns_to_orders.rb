class AddColumnsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :email, :string
    add_column :orders, :name, :string
    add_column :orders, :address, :string
    add_column :orders, :zipcode, :string
    add_column :orders, :cc_num, :string
    add_column :orders, :cc_cvv, :string
    add_column :orders, :cc_expiration, :string
  end
end
