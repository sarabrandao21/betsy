class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.float :price
      t.string :image
      t.integer :stock
      t.integer :rating

      t.timestamps
    end
  end
end
