# frozen_string_literal: true

class Users::CurrentController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user
  end
end
