class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_category, except: %i[index create]
  before_action :admin?, except: %i[index]

  def index
    render json: Category.all
  end

  def new
  end

  def create
    @category = Category.new category_params
    save_category
  end

  def edit
  end

  def update
    @category.update category_params
    save_category
  end

  def destroy
    Category.delete @category.id
  end

  private

  def save_category
    if @category.save
      render json: @category
    else
      render json: @category.errors.full_messages
    end
  end

  def category_params
    params.require(:category).permit!
  end

  def find_category
    if params[:id].present?
      begin
        @category = Category.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render json: { message: "Category not found" }
      end
    else
      render json: { message: "No id provided" }
    end
  end

  def admin?
    current_user.admin?
  end
end
