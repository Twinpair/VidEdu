require 'test_helper'

class SuggestionsControllerTest < ActionController::TestCase

  include Devise::TestHelpers
  
  # INDEX
  test "index" do
    get :index
    assert_response :success
  end

end
