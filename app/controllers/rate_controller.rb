class RateController < ApplicationController
  before_action :authenticate_user!
  before_action :get_idea
  before_action :test_user_or_admin, only: %i[destroy]

  def create
    if @idea.present?
      if @idea.rate.present?
        @rate = @idea.rate
        return ban_rate if @rate.users.exists? id: current_user

        @rate.mark += params_rate[:mark]
      else
        @rate = Rate.new(**params_rate, idea: @idea)
      end

      @rate.users.append current_user
      return respond_to_save if @rate.save

      not_save_rate
    else
      not_idea
    end
  end

  def destroy
    if @idea.present?
      if @idea.rate.present?
        @idea.rate.destroy
        return render json: {
          status: { code: 200, message: 'Rate deleted successfully' }
        }
      end
      render json: {
        status: { code: 400, message: "Rate doesn't exist" }
      }
    else
      not_idea
    end

  end

  def update
    if @idea.present?
      if @idea.rate.present? && @idea.rate.users.exists?(id: current_user)
        @idea.rate.mark += params_rate[:mark]
        return respond_to_update if @idea.rate.save

        return not_save_rate
      end
      render json: {
        status: { code: 400, message: "Rate doesn't exist or you need to rate before updating him" }
      }
    else
      not_idea
    end
  end

  def get_rate_idea
    if @idea.present?
      return respond_get_rate if @idea.rate.present?

      render json: {
        status: { code: 400, message: "Rate doesn't exist" }
      }
    else
      not_idea
    end
  end

  private

  def respond_get_rate
    render json: {
      status: { code: 200 },
      data: @idea.rate.mark / @idea.rate.users.count
    }
  end

  def test_user_or_admin
    return if (current_user.entrepreneur? && current_user.ideas.exists?(id: params[:idea_id])) ||
      current_user.admin?

    render json: {
      status: { code: 403, message: 'You are forbidden' }
    }
  end

  def get_idea
    @idea = Idea.find_by id: params[:idea_id]
  end

  def not_idea
    render json: {
      status: { code: 400, message: "This idea doesn't exist" }
    }
  end

  def ban_rate
    render json: {
      status: { code: 400, message: "You have already rated it's idea!" }
    }
  end

  def params_rate
    params.require(:rate).permit(:mark)
  end

  def not_save_rate
    render json: {
      status: { status: 400 },
      data: @idea.rate.errors.full_messages
    }
  end

  def respond_to_save
    render json: {
      status: { status: 200, message: "Rate added successfully" }
    }
  end

  def respond_to_update
    render json: {
      status: { code: 200, message: "Rate successfully updated" }
    }
  end
end
