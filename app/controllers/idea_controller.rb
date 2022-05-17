class IdeaController < ApplicationController
  before_action :authenticate_user!
  before_action :find_idea, only: %i[update show destroy update_status add_investor_to_idea]
  before_action :test_role_to_entrepreneur, only: %i[create]
  before_action :test_role_to_investor, only: %i[add_investor_to_idea]

  def create
    @idea = current_user.ideas.create idea_params
    if @idea.errors.any?

      render json: {
        status: { code: 400 },
        data: @idea.errors.full_messages
      }
    else
      send_to_email
      respond_create_idea
    end
  end

  def add_investor_to_idea
    if @idea.present?
      @idea.users.append current_user
      render json: {
        status: { code: 200, message: 'You invested this idea!' }
      }
    else
      not_idea
    end
  end

  def update
    if @idea.present?
      if test_to_update_destroy_idea && @idea.update(idea_params)
        render json: {
          status: { code: 200, message: 'Idea updated successfully' }
        }
      else
        render json: {
          status: { code: 400 },
          data: @idea.errors.messages
        }
      end
    else
      not_idea
    end
  end

  def destroy
    if @idea.present? && test_to_update_destroy_idea
      @idea.destroy
      render json: {
        status: { code: 200, message: 'Idea deleted successfully' }
      }
    else
      not_idea
    end
  end

  def index
    ideas = current_user.ideas
    if ideas.present?
      render json: {
        status: { code: 200 },
        data: ideas
      }
    else
      render json: {
        status: { code: 400, message: "You haven't ideas, you need to create them" }
      }
    end
  end

  def show
    if @idea.present?
      render json: {
        status: { code: 200 },
        data: @idea
      }
    else
      not_idea
    end
  end

  def show_all_ideas
    ideas = Idea.all
    if ideas.present?
      respond_find_ideas(ideas)
    else
      render json: {
        status: { code: 404, message: "No one idea hasn't been found" }
      }
    end
  end

  def update_status
    if @idea.present? && test_to_update_destroy_idea
      @idea.access = params[:access]
      send_to_email
      @idea.save
      render json: {
        status: { code: 200, message: 'Status successfully update' }
      }
    else
      render json: {
        status: { code: 404, message: "This idea doesn't exist" }
      }
    end
  end

  private

  def not_idea
    render json: {
      status: { code: 400, message: "This idea doesn't exist" }
    }
  end

  def test_role_to_entrepreneur
    return if current_user.entrepreneur?

    render json: {
      status: { code: 403, message: 'You are forbidden' }
    }
  end

  def test_role_to_investor
    return if current_user.investor?

    render json: {
      status: { code: 403, message: 'You are forbidden' }
    }

  end

  def test_to_update_destroy_idea
    if (current_user.entrepreneur? && current_user.ideas.find_by(id: @idea.id)) ||
      current_user.admin?
      return true
    end
    false
  end

  def idea_params
    params.require(:idea).permit(:description, :name, :access, :sphere,
                                 :location, :plans, :problem, :necessary, :team)
  end

  def respond_find_ideas(ideas)
    render json: {
      status: { code: 200 },
      data: ideas
    }
  end

  def respond_create_idea
    render json: {
      status: { code: 200 },
      data: @idea
    }
  end

  def find_idea
    @idea = Idea.find_by(id: params[:id])
  end

  def send_to_email
    if @idea.access == 'common'
      users = User.where role: 'investor'
      users.each do |user|
        UserMailer.with(user: user, idea: @idea).appeared_idea.deliver_now
      end
    end
  end
end
