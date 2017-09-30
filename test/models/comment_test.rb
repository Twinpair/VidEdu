require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    @comment = Comment.new(body: "text", user_id: 1000, video_id: 1)
  end
  
  test "should be valid" do
    assert @comment.valid?
  end

  test "body should be present" do
    @comment.body = "     "
    assert_not @comment.valid?
  end

  test "user_id should be present" do
    @comment.user_id = nil
    assert_not @comment.valid?
  end

  test "video_id should be present" do
    @comment.video_id = nil
    assert_not @comment.valid?
  end

  test "body should be less than 2000 characters" do
    @comment.body = "a" * 2001
    assert_not @comment.valid?
  end

end
