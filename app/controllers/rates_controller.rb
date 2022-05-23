class RatesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_rate, only: %i[update destroy]
  before_action :author?, only: %i[update destroy]
  before_action :admin?, only: %i[index]

  def index
    render json: Rate.all
  end

  def create
    @rate = Rate.new(rate_params)
    save_rate
  end

  def update
    @rate.update(rate_params)
    save_rate
  end

  def destroy
    Rate.delete @rate.id
    render json: { message: "Deleted successfully" }
  end


  private

  def rate_params
    params.require(:rate).permit!
  end

  def find_rate
    if params[:id].present?
      begin
        @rate = News.published.find(params[:id])
      rescue RecordNotFound
        render json: {message: "Rate not found."}
      end
    else
      render json: { message: "No id provided" }
    end
  end

  def save_rate
    if @rate.save
      render json: @rate
    else
      render json: @rate.errors.full_messages
    end
  end

  def author?
    restrict unless @rate.author.id == current_user.id
  end
end
