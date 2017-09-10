class PagesController < ApplicationController

  def home
    @suggestion = Suggestion.new
    @custom_nav = true
  end

  def signup
     redirect_to '/signup' 
  end

  def login
    redirect_to '/login'
  end

  def search
    params[:filter] = params[:persist_filter] if params[:filter].nil? && params[:persist_filter].present?
    params[:filter].present? && params[:filter] == "Subjects" ? @subjects = Subject.search(params) : @videos = Video.search(params)
  end

end
