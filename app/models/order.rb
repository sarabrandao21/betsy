class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  def subtotal 
    total = 0 
    self.order_items.map { |order_item| total += order_item.total_price_qty  }
    return total.round(2)
  end 

  def taxes 
    subtotal = self.subtotal()
    taxes = subtotal * 0.10
    return taxes.round(2) 
  end 

  def purchase_total 
    return total = (self.subtotal() + self.taxes()).round(2)
  end 

end
