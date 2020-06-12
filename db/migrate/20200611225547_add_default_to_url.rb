class AddDefaultToUrl < ActiveRecord::Migration[6.0]
  def change
    change_column_default :products, :image, "https://i.imgur.com/WO2Uui9.jpg"
  end
end
