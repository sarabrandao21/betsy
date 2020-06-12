class AddActiveToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :active, :boolean, :default => true
  end
end
