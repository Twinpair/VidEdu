require 'test_helper'

class CommentIntegrationTest < ActionDispatch::IntegrationTest

  #NOTE: As of now, users cannot update or delete comments

  def setup
    @user = users(:integration)
  end
  
  # CREATE 
  test "successful comment on own video" do
    sign_in_as @user
    video = videos(:integration)
    get video_path(video)
    assert_response :success
    assert_equal video.user_id, @user.id
    assert_difference 'video.comments.count', 1 do
      post video_comments_path(video), 
        comment: {
          body: "This is a comment"
        }, xhr: true
    end
  end

  test "successful comment on other users video" do
    sign_in_as @user
    video = videos(:one)
    get video_path(video)
    assert_response :success
    assert_not_equal video.user_id, @user.id
    assert_difference 'video.comments.count', 1 do
      post video_comments_path(video), 
        comment: {
          body: "This is a comment"
        }, xhr: true
    end
  end

  test "unsuccessful comment with blank body" do
    sign_in_as @user
    video = videos(:one)
    get video_path(video)
    assert_response :success
    assert_no_difference 'video.comments.count' do
      post video_comments_path(video), 
        comment: {
          body: "     "
        }, xhr: true
    end
  end

  test "unsuccessful comment with no user" do
    video = videos(:one)
    get video_path(video)
    assert_response :success
    assert_no_difference 'video.comments.count' do
      post video_comments_path(video), 
        comment: {
          body: "     "
        }, xhr: true
    end
  end

end
