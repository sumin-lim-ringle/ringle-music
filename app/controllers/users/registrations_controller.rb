# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery
  wrap_parameters :user, format: [:url_encoded_form, :multipart_form, :json]
  respond_to :json

  before_action :configure_sign_up_params
  
  private

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def respond_with(resource, _opts = {})
    register_success && return if resource.persisted?

    register_failed resource
  end

  def register_success
    render json: { message: "회원가입에 성공했습니다." }, status: :created
  end

  def register_failed(resource)
    render json: { message: resource.errors.full_messages.join(", ") }, status: :bad_request
  end

end
