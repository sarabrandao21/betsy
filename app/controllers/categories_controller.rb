class CategoriesController < ApplicationController


    def index 
        @categories = Category.all
    end 

    def show
    end 

    def new 
    end 

    def create 
    end 



    private 

    def category_params
        params.require(:category).permit(:name)
    end

    def find_product
        @category = Category.find_by(id: params[:id])
    end
end
