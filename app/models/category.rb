class Category < ApplicationRecord
    has_and_belongs_to_many :products
    validates :name, uniqueness: true, presence: true
    #Product categories
    #As a signed-in user, I can:
    #Create new categories (categories are shared between all merchants)
    #Assign my products to any number of categories

    #find all products with that category
    #call that method in the view 
    #validation to category 
end
