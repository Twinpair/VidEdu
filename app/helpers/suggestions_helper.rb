module SuggestionsHelper
    def suggestion_params
        params.require(:suggestion).permit(:name, :email, :suggestion)
    end
end
