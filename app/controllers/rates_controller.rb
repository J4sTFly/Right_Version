class RatesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_rate, only: %i[update destroy]
  before_action :author?, only: %i[update destroy]

  def index
    render json: Rate.all
  end

  def new
  end

  def create
    @rate = Rate.new(rate_params)
    save_rate
  end

  def show
  end

  def edit
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

  def save_rate
    if @rate.save
      render json: @rate
    else
      render json: @rate.errors.full_messages
    end
  end
end
