class SuggestionsController < ApplicationController
    include SuggestionsHelper

    def index
        @suggestions = Suggestion.all
    end

    def create
      @suggestion = Suggestion.new(suggestion_params)
      @suggestion.save

      redirect_to root_path
    end
end