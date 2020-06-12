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

    def self.popular_products
        products = Product.all
        return products.order(rating: :desc)[0...10]
    end

    def toggle_active_state
        if self.active?
            return false
        else
            return true
        end
    end
end
