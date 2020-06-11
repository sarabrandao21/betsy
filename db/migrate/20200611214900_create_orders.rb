class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.string :address
      t.string :email
      t.string :last_four_cc

      t.timestamps
    end
  end
end
