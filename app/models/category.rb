class Category < ApplicationRecord
    has_and_belongs_to_many :products, dependent: :destroy
    validates :name, uniqueness: true, presence: true
    
    def self.get_categories 
        list_categories = Category.all
        names = list_categories.map { |category| category.name }
        return names
    end 
end
