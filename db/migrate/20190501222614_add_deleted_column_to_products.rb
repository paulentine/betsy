class AddDeletedColumnToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :deleted, :boolean, default: false
  end
end
