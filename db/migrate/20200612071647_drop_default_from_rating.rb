class DropDefaultFromRating < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:products, :rating, nil)
  end
end
