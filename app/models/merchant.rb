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
      return 0
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

  def find_order_items
    items = []
    order_items = self.order_items
    order_items.each do |order_item|
      items << order_item.quantity
    end
    return items.sum
  end

  def find_all_order_items(status)
    items = []
    order_items = self.order_items
    order_items.each do |order_item|
      if order_item.status == status 
        items << order_item
      end
    end
    return items
  end

  def total_revenue_by(status)
    items_revenue = []
    items = self.order_items.where(status: status)
    if items.length > 0
      items.each do |item|
        if item.status == status
          items_revenue << item.total_price_qty 
        end
      end
      return items_revenue.sum
    else
      return 0
    end
  end
  
  def total_revenue
    items_revenue = []
    items = self.order_items
    if items.length > 0
      items.each do |item|
        if item.status != "Cancelled"
          items_revenue << item.total_price_qty
        end
      end
      return items_revenue.sum
    else
      return 0
    end
  end
end
