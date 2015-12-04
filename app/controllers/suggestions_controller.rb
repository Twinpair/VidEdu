class SuggestionsController < ApplicationController
    include SuggestionsHelper

    def index
        @suggestions = Suggestion.all
    end

    def create
      @suggestion = Suggestion.new(suggestion_params)
      @suggestion.save

      redirect_to pages_home_path
    end
end