class CreateMerchants < ActiveRecord::Migration[6.0]
  def change
    create_table :merchants do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.integer :uid
      t.string :email
      t.string :avatar
      t.string :provider

      t.timestamps
    end
  end
end
