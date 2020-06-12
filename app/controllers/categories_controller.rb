class CategoriesController < ApplicationController

    before_action :find_category, only: [:show]
    before_action :find_merchant, only: [:create]

    def index 
        @categories = Category.all
    end 

    def show
        redirect_to categories_path unless @category
    end 

    def new 
        @category = Category.new
    end 

    def create 
        @category = Category.new(category_params)
        if @category.save
            flash[:success] = "Successfully created #{@category.name} #{@category.id}"
            redirect_to categories_path
        else
            flash[:status] = :failure
            flash[:result_text] = "Could not create #{@category.name}"
            flash[:messages] = @category.errors.messages
            render :new, status: :bad_request
        end
    end 

    private 

    def category_params
        params.require(:category).permit(:name)
    end

    def find_category
        @category = Category.find_by(id: params[:id])
    end
end
