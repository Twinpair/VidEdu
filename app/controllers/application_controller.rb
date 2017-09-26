class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  Time.zone.now
  before_action :configure_permitted_parameters, if: :devise_controller?

protected
  
  # Devise permit parameters
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:firstname, :lastname, :username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:firstname, :lastname, :username, :email, :password, :password_confirmation, :current_password) }
  end

private

  # Verifies user is logged in
  def must_be_logged_in
    unless current_user
      redirect_to new_user_session_path
    end
  end

  # Verifies if user is the owner of the resource given
  def is_resource_owner?(resource)
    current_user && current_user.id == resource.user_id
  end

end