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

  # Verifies the user is the owner of the resource given
  def is_resource_owner?(resource)
    current_user && current_user.id == resource.user_id
  end

  # Verifies user is authorized to peform certain actions
  def authorized_user?
    if params[:controller].eql?("subjects")
      subject = Subject.find(params[:id])
      if params[:action].eql?("show")
        # If a user is trying to access another user's private subject playlist, they will be redirected to /subjects
        redirect_to subjects_path if subject.private? && !is_resource_owner?(subject)
      elsif params[:action].eql?("edit") || params[:action].eql?("update") || params[:action].eql?("destroy")
        # If a user tries to alter their default (non-editable) subject or a subject they do not own, they are redirected back to the subject show page
        redirect_to subject_path(subject) if subject.default_subject || !is_resource_owner?(subject)
      end
    elsif params[:controller].eql?("videos")
      video = Video.find(params[:id])
      if params[:action].eql?("show")
        # If a user tries to view another user's private video, they are redirected back to /videos
        redirect_to videos_path if video.private? && !is_resource_owner?(video)
      elsif params[:action].eql?("edit") || params[:action].eql?("update") || params[:action].eql?("destroy")
        # If a user tries to alter a video they do not own, they are redirected back to the videos show page
        redirect_to video_path(video) unless is_resource_owner?(video)
      end
    end
  end

end