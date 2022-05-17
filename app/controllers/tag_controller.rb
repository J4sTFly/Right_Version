class TagController < ApplicationController

  before_action :authenticate_user!
  before_action :find_tag, only: %i[update destroy show]
  before_action :test_user_entrepreneur_admin, only: %i[create update destroy]

  def create
    @idea = Idea.find_by id: params[:idea_id]
    if @idea && test_idea_belong_user
      if Tag.exists? name: tag_params[:name]
        tag = Tag.find_by name: tag_params[:name]
        return respond_belong_to_idea if tag.ideas.find_by id: @idea.id

        tag.ideas.append @idea
      else
        tag = Tag.new(tag_params)
        tag.ideas.append @idea
        return respond_to_create_tag if tag.save

        respond_not_create_tag(tag)
      end
    else
      render json: {
        status: { code: 400, message: "This idea doesn't exist or it's action forbidden" }
      }
    end
  end

  def update
    if @tag.present?
      if test_tag_to_update_destroy && @tag.update(tag_params)
        render json: {
          status: { code: 200, message: "Tag successfully updated" }
        }
      else
        render json: {
          status: { code: 400 },
          data: @tag.errors.full_messages
        }
      end
    else
      render json: {
        status: { code: 400, message: "This tag doesn't exist" }
      }
    end
  end

  def destroy
    if @tag.present? && test_tag_to_update_destroy
      @tag.destroy
      render json: {
        status: { code: 200, message: "Tag successfully deleted" }
      }
    else
      render json: {
        status: { code: 400, message: "This tag doesn't exist or it's action forbidden" }
      }
    end
  end

  def index
    @idea = Idea.find_by id: params[:idea_id]
    if @idea.present? && @idea.tags.present?
      render json: {
        status: { code: 200 },
        data: @idea.tags
      }
    else
      render json: {
        status: { code: 400, message: "This idea doesn't exist or tags absent" }
      }
    end
  end

  def show
    if @tag.present?
      render json: {
        status: { code: 200 },
        data: @tag
      }
    else
      render json: {
        status: { code: 400, message: "This tag doesn't exist" }
      }
    end
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

  def test_tag_to_update_destroy
    return true if @tag.ideas.map { |idea| idea.users.exists? id: current_user.id } || current_user.admin?

    false
  end

  def respond_not_create_tag(tag)
    render json: {
      status: { code: 400 },
      data: tag.errors.full_messages
    }
  end

  def respond_to_create_tag
    render json: {
      code: 200, message: "Tag successfully added"
    }
  end

  def respond_belong_to_idea
    render json: {
      status: { code: 400, message: "This tag has already belonged to idea" }
    }
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

  def find_tag
    @tag = Tag.find_by id: params[:id]
  end

  def test_idea_belong_user
    return true if current_user.ideas.where id: @idea.id || current_user.admin?

    false
  end

  def test_user_entrepreneur_admin
    return if current_user.entrepreneur? || current_user.admin?

    render json: {
      status: { code: 403, message: 'You are forbidden' }
    }

  end
end
