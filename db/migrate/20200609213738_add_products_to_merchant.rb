class AddProductsToMerchant < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :merchant, index: true 
  end
end
