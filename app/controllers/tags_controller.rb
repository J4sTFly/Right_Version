class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_tag, only: %i[show update destroy]
  before_action :admin?, only: %i[show update destroy]

  def index
    render json: Tag.order(:name)
  end

  def create
    @tag = Tag.new tag_params
    save_tag
  end

  def show
    render json: @tag
  end

  def update
    @tag.update tag_params
    save_tag
  end

  def destroy
    Tag.delete @tag.id
    render json: { message: "Deleted successfully." }
  end

  def get_tags
    @tags = Tag.order(:name).where('tags.name LIKE ?', "%#{params[:q]}%")
    if @tags.present?
      render json: {
        status: { code: 200 },
        data: @tags
      }
    else
      render json: {
        status: { code: 400, message: "Cant' find matches" }
      }
    end
  end

  private

  def save_tag
    if @tag.save
      render json: @tag
    else
      render json: @tag.errors.full_messages
    end
  end

  def tag_params
    params.require(:comment).permit!
  end

  def find_tag
    if params[:id].present?
      begin
        @tag = Tag.find params[:id]
      rescue ActiveRecord::RecordNotFound
        render json: { message: "Tag not found" }
      end
    else
      render json: { message: "No id provided" }
    end
  end

  def admin?
    restrict unless current_user.admin?
  end
end
