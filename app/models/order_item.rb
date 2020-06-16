class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  def increment_quantity(qty) #product show page 
    self.quantity += qty.to_i 
    self.save 
  end 

  def set_quantity(qty) #inside of cart 
    self.quantity = qty.to_i 
    self.save 
  end 

  def total_price_qty 
    total = self.product.price * self.quantity.to_i
    return total.round(2)
  end
  
  def change_status(status)
    self.status = status
    self.save      
  end
end
