class CategoriesController < ApplicationController
    def index 
        @categories = Category.all
    end 

    def show

    end 

    private 
    def find_product
        @category = Category.find_by(id: params[:id])
    end
end
