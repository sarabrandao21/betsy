class AddcardstatusToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :card_status, :string
  end
end
