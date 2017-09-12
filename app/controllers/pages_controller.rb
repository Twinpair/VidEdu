class PagesController < ApplicationController
  def home
    @suggestion = Suggestion.new

    # Shared nav won't be rendered for home page
    @custom_nav = true
  end

  def search
    params[:filter] = params[:persist_filter] if params[:filter].nil? && params[:persist_filter].present?
    params[:filter].present? && params[:filter] == "Subjects" ? @subjects = Subject.search(params).paginate(:page => params[:page]) : @videos = Video.search(params).paginate(:page => params[:page])
  end
end
