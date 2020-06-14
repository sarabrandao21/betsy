class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  def subtotal 
    #
    self.order_items.map 
  end 

  def taxes 
  end 

  def purchase_total 
  end 

end
