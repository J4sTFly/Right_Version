# frozen_string_literal: true

module RequiredParameters
  extend ActiveSupport::Concern

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation, :role,
                                                       address_attributes: [:country, :skype, :telephone]])
  end

end
