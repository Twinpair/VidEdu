require 'test_helper'

class SuggestionIntegrationTest < ActionDispatch::IntegrationTest

  # CREATE
  test "create when there is no user" do
    assert_difference 'Suggestion.count', 1 do
      post suggestions_path, 
        suggestion: {
          name: "User",
          email: "user@example.com",
          suggestion: "Nice Site",
        }
    end
  end

  test "create when user is logged in" do
    user = users(:default)
    sign_in_as user
    assert_difference 'Suggestion.count', 1 do
      post suggestions_path, 
        suggestion: {
          name: "User",
          email: "user@example.com",
          suggestion: "Nice Site",
        }
    end
  end

  test "create when name param is blanks" do
    assert_no_difference 'Suggestion.count' do
      post suggestions_path, 
        suggestion: {
          name: " ",
          email: "user@example.com",
          suggestion: "Nice Site",
        }
    end
  end

  test "create when email param is blank" do
    assert_no_difference 'Suggestion.count' do
      post suggestions_path, 
        suggestion: {
          name: "User",
          email: " ",
          suggestion: "Nice Site",
        }
    end
  end

  test "create when suggestion param is blank" do
    assert_no_difference 'Suggestion.count' do
      post suggestions_path, 
        suggestion: {
          name: "User",
          email: "user@example.com",
          suggestion: "    ",
        }
    end
  end

  test "create when all params are blank" do
    assert_no_difference 'Suggestion.count' do
      post suggestions_path, 
        suggestion: {
          name: "      ",
          email: "  ",
          suggestion: "    ",
        }
    end
  end

end
