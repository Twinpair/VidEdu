class PagesController < ApplicationController
  def home
    @suggestion = Suggestion.new

    # Shared nav won't be rendered for home page
    @custom_nav = true
  end

  def search
     # Persistes the video/subject filter for when a user wants to sort the results
    params[:filter] = params[:persist_filter] if params[:filter].nil? && params[:persist_filter].present?
    
    # Decides whether it searches for videos or subjects 
    if params[:filter].present? && params[:filter] == "Subjects"
      @subjects = Subject.search(params).paginate(:page => params[:page])
    else 
      @videos = Video.search(params).paginate(:page => params[:page])
    end
  end
end
