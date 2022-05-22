module Mixin
  extend ActiveSupport::Concern

  def restrict
    render json: { message: "Access restricted"}
  end
end
