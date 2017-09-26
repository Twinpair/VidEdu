require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
 
  def setup
    @subject = Subject.new(subject: "text", description: "description", user_id: 1000)
  end
  
  test "should be valid" do
    assert @subject.valid?
  end

  test "should be valid when set to private" do
    @subject.private = true
    assert @subject.valid?
  end

  test "should be valid without a description" do
    @subject.description = ""
    assert @subject.valid?
  end

  test "name should be present" do
    @subject.subject = "     "
    assert_not @subject.valid?
  end

  test "user_id should be present" do
    @subject.user_id = nil
    assert_not @subject.valid?
  end

  test "name should be unique (scope via user)" do
    # Already exists in subjects.yml fixture
    @subject.subject = "Test Subject"
    assert_not @subject.valid?
  end

end
