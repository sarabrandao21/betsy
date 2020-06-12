class AddDefaultToRating < ActiveRecord::Migration[6.0]
  def change
    change_column_default :products, :rating, 0
  end
end
