class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :is_admin?
  # before_action :find_user, only: %i[show destroy]

  def index
    render json: User.all
  end

  def create
    admin = User.new(**admin_params, role: 2)
    if admin.save
      render json: admin
    else
      render json: admin.errors.full_messages
    end
  end

  def create_instance
    instance = get_model.new(instance_params)
    if instance.save
      render json: instance
    else
      render json: instance.errors.full_messages
    end
  end

  def show
    render json: get_instance
  end

  def update
    instance = get_instance
    if instance.present?
      instance.update(instance_params)
      return render json: instance if instance.save
    end
    render json: instance.errors.full_messages
  end

  def destroy
    render json: { message: "Destroyed" } unless get_model.destroy
  end

  private

  def admin_params
    params.require(:user).permit!
  end

  def get_model
    params[:instance].camelize.safe_constantize
  end

  def get_instance
    get_model.find_by id: params[:id]
  end

  def instance_params
    model = params[:instance]
    params.require(model).permit!
  end

  def is_admin?
    current_user.admin?
  end
end
