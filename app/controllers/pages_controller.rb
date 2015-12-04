class PagesController < ApplicationController
  def index
  end

  def home
    @suggestion = Suggestion.new
  end

  def about
  end

  def subjects
  end

  def profile
  end

  def contact
  end

  def featured
    @videos = Video.order('created_at DESC')
  
  end

  def faq
  end

  def splash
  end

  def signup
     redirect_to '/signup' 
  end

  def login
    redirect_to '/login'
  end

end
