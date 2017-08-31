class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  Time.zone.now

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:firstname, :lastname, :username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:firstname, :lastname, :username, :email, :password, :password_confirmation, :current_password) }
  end



def search
    if params[:search]
        @videos = Video.search(params[:search])
        @subjects = Subject.search(params[:search])
      else
        @videos = Video.order('created_at DESC')
      end
  end

# after_filter :set_header_for_iframe

# private
#  def set_header_for_iframe 
#   response.headers.delete "X-Frame-Options" 
# end 

# Added from tutorial: 
  # private

  # def current_user
  #   @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  # end

  # helper_method :current_user

end


class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
 

# after_filter :set_header_for_iframe

# private
#  def set_header_for_iframe 
#   response.headers.delete "X-Frame-Options" 
# end 




end