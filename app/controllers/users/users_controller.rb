class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: current_user
  end

  def update
    current_user.update user_params
    if current_user.save
      render json: current_user
    else
      render json: current_user.errors.full_messages
    end
  end

  def destroy
    User.delete current_user.id
    render json: { message: 'Deleted successfully' }
  end

  private

  def user_params
    params.require(:user).permit!
  end
end
