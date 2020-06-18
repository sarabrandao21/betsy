class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true,
                    numericality: { greater_than: 0 }


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

  def check_quantity_cart(qty, stock_product) 
    new_quantity = self.quantity + qty.to_i
    return new_quantity <= stock_product ? true : false 
  end
  
  def change_status(status)
    self.status = status
    if status == 'Cancelled'
      Product.find_by(id: self.product_id).restock_inventory(self.quantity)
    end
    self.save      
  end
end
