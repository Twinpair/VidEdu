require 'test_helper'

class SuggestionIntegrationTest < ActionDispatch::IntegrationTest

  # CREATE
  test "successful create as guest" do
    assert_difference 'Suggestion.count', 1 do
      post suggestions_path, 
        suggestion: {
          name: "User",
          email: "user@example.com",
          suggestion: "Nice Site",
        }
    end
  end

  test "successful create as user" do
    user = users(:integration)
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

  test "unsuccessful create with blank name" do
    assert_no_difference 'Suggestion.count' do
      post suggestions_path, 
        suggestion: {
          name: " ",
          email: "user@example.com",
          suggestion: "Nice Site",
        }
    end
  end

  test "unsuccessful create with blank email" do
    assert_no_difference 'Suggestion.count' do
      post suggestions_path, 
        suggestion: {
          name: "User",
          email: " ",
          suggestion: "Nice Site",
        }
    end
  end

  test "unsuccessful create with blank suggestion" do
    assert_no_difference 'Suggestion.count' do
      post suggestions_path, 
        suggestion: {
          name: "User",
          email: "user@example.com",
          suggestion: "    ",
        }
    end
  end

  test "unsuccessful create with all params blank" do
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
