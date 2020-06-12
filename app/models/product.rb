class Product < ApplicationRecord
    has_many :order_items
    has_and_belongs_to_many :categories
    belongs_to :merchant
    has_many :reviews

    validates :name, presence: true
                    # uniqueness: {scope: :category}
    validates_uniqueness_of :name, scope: :merchant
    validates :price, presence: true,
                    numericality: { greater_than: 0 }
    validates :stock, presence: true,
                    numericality: { greater_than_or_equal_to: 0 }

    def self.active_products
        products = Product.where(active: true)
    end

    def self.popular_products        
        products = Product.active_products
        favorite_products = []

        products.each do |product|
            if product.find_average_rating
                product.rating = product.find_average_rating
                favorite_products << product
            end
        end

        top_ten = favorite_products.sort_by {|product| -product.rating}[0..10]

        if top_ten.nil?
            return Product.all.sample(10)
        else 
            return top_ten
        end
    end

    def toggle_active_state
        if self.active?
            return false
        else
            return true
        end
    end

    def find_average_rating
        total_rating = []
        if self.reviews.length < 1
            return nil
        else 
            self.reviews.each do |reviews|
                total_rating << reviews.rating
            end
        end
        # to get the digits not to round up?
        return (total_rating.sum.to_f/(total_rating.length)).round()
    end

    # model method to use when product is added to cart
    def deduct_inventory(num)
        self.stock -= num
        self.save
    end 

    # model method to use when a cart is removed
    def restock_inventory(num)
        self.stock += num
        self.save
    end
    
end
