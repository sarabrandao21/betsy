class Order < ApplicationRecord
  has_many :order_items,dependent: :destroy
  
    validates_presence_of :customer_name, :address, :email, :last_four_cc, :exp_date, :cvv, :zip, on: :update
  
    validates :last_four_cc, length:{is: 4}, on: :update
    validates :cvv, length:{is: 3},on: :update
    validates :zip, length:{is: 5}, on: :update


    # def status
    # end 

end
