class Order < ApplicationRecord

  has_many :order_items, dependent: :destroy

    validates_presence_of :customer_name, :address, :email, :last_four_cc, :exp_date, :cvv, :zip, on: :update

    validates :last_four_cc, length:{is: 4}, on: :update
    validates :cvv, length:{is: 3},on: :update
    validates :zip, length:{is: 5}, on: :update


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

  def mark_paid
    self.order_items.each do |order_item|
      order_item.status = "Paid"
      Product.find_by(id: order_item.product_id).deduct_inventory(order_item.quantity)
      order_item.save
    end
  end

  def all_cart_items
    cart_qty = []
    self.order_items.each do |order_item|
      cart_qty << order_item.quantity
    end
    return cart_qty.sum
  end

  def verify_merchant(login_merchant)
    order_merchants = []
    self.order_items.each do |order_item|
      merchant = order_item.product.merchant
      order_merchants << merchant
    end

    if order_merchants.include? (login_merchant)
      return true
    else 
      return false
    end
  end
end
