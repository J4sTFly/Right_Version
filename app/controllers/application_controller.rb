class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  def restrict
    render json: { message: "Access restricted" }
  end

  protected

  def admin?
    restrict unless current_user.admin?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email,:role])
  end
end
