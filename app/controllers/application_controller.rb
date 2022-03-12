# frozen_string_literal: true

# #TODO: Documentation
class ApplicationController < ActionController::Base
  # respond_to :html, :json
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    registration_params = [:name]
    devise_parameter_sanitizer.permit(:sign_up, keys: registration_params)
    devise_parameter_sanitizer.permit(:account_update, keys: registration_params)
  end
end
