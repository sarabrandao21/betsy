class RemoveFirstLastNameColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :merchants, :first_name
    remove_column :merchants, :last_name
  end
end
