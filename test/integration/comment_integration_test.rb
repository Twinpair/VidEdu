require 'test_helper'

class CommentIntegrationTest < ActionDispatch::IntegrationTest

  #NOTE: As of now, users cannot update or delete comments

  def setup
    @user = users(:default)
    @video = videos(:default)
  end
  
  # CREATE 
  test "create when user is logged in" do
    sign_in_as @user
    get video_path(@video)
    assert_not_empty(:video)
    assert_response :success
    assert_difference '@video.comments.count', 1 do
      post video_comments_path(@video), 
        comment: {
          body: "This is a comment"
        }, xhr: true
    end
  end

  test "create when comment has blank body" do
    sign_in_as @user
    get video_path(@video)
    assert_not_empty(:video)
    assert_response :success
    assert_no_difference '@video.comments.count' do
      post video_comments_path(@video), 
        comment: {
          body: "     "
        }, xhr: true
    end
  end

  test "create when there is no user" do
    get video_path(@video)
    assert_not_empty(:video)
    assert_response :success
    assert_no_difference '@video.comments.count' do
      post video_comments_path(@video), 
        comment: {
          body: "     "
        }, xhr: true
    end
  end

end
