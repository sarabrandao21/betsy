class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.text :comment
      t.string :reviewer
      t.integer :rating
      t.references :product , index: true

      t.timestamps
    end
  end
end
