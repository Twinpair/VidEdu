require 'test_helper'

class VideosControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def setup
    @user = users(:default)
    @video = videos(:default)
  end
 
  # INDEX
  test "index" do
    get :index
    assert_not_empty(:videos)
    assert_response :success
    assert_select "title", "VidEdu | All Videos"
  end

  # SHOW  
  test "show when video is not private" do
    get :show, id: @video.id
    assert_not_empty(:video)
    assert_response :success
    assert_select "title", "VidEdu | #{@video.title}"
    assert_select "h1", "#{@video.title}"
    assert_select "p", "Created By: #{User.find(@video.user_id).username}"
  end

  test "show when video is private and user is owner" do
    sign_in @user
    get :show, id: @video.id
    assert_not_empty(:video)
    assert_response :success
    assert_select "title", "VidEdu | #{@video.title}"
    assert_select "h1", "#{@video.title}"
    assert_select "p", "Created By: You"
  end

  test "show when video is private and user is not the owner" do
    @video.update_attributes(user_id: 2, private: true)
    sign_in @user
    get :show, id: @video.id
    assert_not_empty(:video)
    assert_redirected_to videos_path
  end

  test "show when video is private and there is no user" do
    @video.update_attributes(private: true)
    get :show, id: @video.id
    assert_not_empty(:video)
    assert_redirected_to videos_path
  end

  # NEW
  test "new when user is logged in" do
    sign_in @user
    get :new
    assert_response :success
    assert_select "title", "VidEdu | Add Video"
  end

  test "new when there is no user" do
    get :new
    assert_response :success
    assert_select "title", "VidEdu | Add Video"
  end

  # EDIT
  test "edit when user is owner" do
    sign_in @user
    get :edit, id: @video.id
    assert_not_empty(:video)
    assert_response :success
    assert_select "title", "VidEdu | Edit Video"
  end

  test "edit when user is not owner" do
    @video.update_attributes(user_id: 2)
    sign_in @user
    get :edit, id: @video.id
    assert_not_empty(:video)
    assert_redirected_to video_path(@video)
  end

  test "edit when there is no user" do
    get :edit, id: @video.id
    assert_not_empty(:video)
    assert_redirected_to new_user_session_path
  end

  # YOUR_VIDEOS
  test "your_videos when user is logged in" do
    sign_in @user
    get :your_videos
    assert_not_empty(:videos)
    assert_response :success
  end

  test "your_videos when there is no user" do
    get :your_videos
    assert_redirected_to new_user_session_path
  end

end
