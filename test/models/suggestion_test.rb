require 'test_helper'

class SuggestionTest < ActiveSupport::TestCase
  
  def setup
    @suggestion = Suggestion.new(name: "guy", email: "guy@example.com", suggestion: "Nice")
  end

  test "should be valid" do
    assert @suggestion.valid?
  end

  test "name should be present" do
    @suggestion.name = "     "
    assert_not @suggestion.valid?
  end

  test "email should be present" do
    @suggestion.email = "     "
    assert_not @suggestion.valid?
  end

  test " name should be present" do
    @suggestion.suggestion = "     "
    assert_not @suggestion.valid?
  end

end
