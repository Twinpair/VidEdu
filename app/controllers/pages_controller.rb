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

end
