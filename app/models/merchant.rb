class Merchant < ApplicationRecord
  has_many :products
  has_many :order_items, through: :products

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]
    merchant.avatar = auth_hash["info"]["image"]
    
    return merchant
  end

  def own_average_rating
    total_rating = []

    self.products.each do |product|
      product_rating = product.find_average_rating
      if product_rating 
        total_rating << product_rating
      end
    end
    if total_rating.length < 1
      return "no rating yet"
    else
      return (total_rating.sum.to_f/(total_rating.length)).round()
    end   
  end

  def find_total_order
    orders = []
    order_items = self.order_items
    order_items.each do |order_item|
      orders << order_item.order_id
    end

    return orders.uniq.count      
  end
end
