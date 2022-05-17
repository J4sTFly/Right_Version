class DislikeController < ApplicationController
  before_action :authenticate_user!
  before_action :get_idea

  def create
    if @idea.present?
      return not_prepared_action if exist?

      @idea.dislikes.append Dislike.new(user: current_user)
      not_problem
    else
      idea_not_exist
    end
  end

  def destroy
    if @idea.present?
      if exist?
        Dislike.find_by(user: current_user).destroy
        return not_problem
      end
      not_prepared_action
    else
      idea_not_exist
    end
  end

  def get_amount_dislikes
    if @idea.present?
      return respond_to_amount_dislikes if @idea.dislikes.present?

      render json: {
        status: { code: 200, message: "None" }
      }
    else
      idea_not_exist
    end
  end

  private

  def not_problem
    render json: {
      status: { code: 200 }
    }
  end

  def respond_to_amount_dislikes
    render json: {
      status: { code: 200 },
      data: @idea.dislikes.count
    }
  end

  def idea_not_exist
    render json: {
      status: { code: 400, message: "This idea doesn't exist" }
    }
  end

  def exist?
    @idea.dislikes.exists? user: current_user
  end

  def get_idea
    @idea = Idea.find_by id: params[:idea_id]
  end

  def not_prepared_action
    render json: {
      status: { code: 400 }
    }
  end

end
