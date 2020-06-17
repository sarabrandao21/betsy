class AddfieldstoOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :zip, :string
    add_column :orders, :cvv, :string
    add_column :orders, :exp_date, :string
  end
end
