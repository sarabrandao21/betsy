class Product < ApplicationRecord
    has_and_belongs_to_many :categories
    belongs_to :merchant

    validates :name, presence: true
                    # uniqueness: {scope: :category}
    validates_uniqueness_of :name, scope: :merchant
    validates :price, presence: true,
                    numericality: { greater_than: 0 }

    def self.popular_products
        products = Product.all
        return products.order(rating: :desc)[0...10]
    end

    def add_categories(category_ids) #category_ids is an array 
        category_ids.uniq!
        category_ids.each do |id|
            if id != ""
                category = Category.find_by(id: id.to_i)
                self.categories << category 
            end 
        end 
    end 
    
end
