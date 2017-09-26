class SuggestionsController < ApplicationController

  def index
    @suggestions = Suggestion.all
  end

  def create
    @suggestion = Suggestion.new(suggestion_params)
    @suggestion.save
    redirect_to root_path
  end

private

  def suggestion_params
    params.require(:suggestion).permit(:name, :email, :suggestion)
  end

end