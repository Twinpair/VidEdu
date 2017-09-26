require 'test_helper'

class VideosControllerTest < ActionController::TestCase

  include Devise::TestHelpers
 
  test "should get index" do
    get :index
    assert_not_empty(:videos)
    assert_response :success
    assert_select "title", "VidEdu | All Videos"
  end

  test "should get show if videos is not private" do
    video = videos(:one)
    assert_not_empty(:video)
    get :show, id: video.id
    assert_response :success
    assert_select "title", "VidEdu | #{video.title}"
  end

  test "should get show for private video if user is owner" do
    sign_in users(:two)
    video = videos(:private)
    assert_not_empty(:video)
    get :show, id: video.id
    assert_response :success
    assert_select "title", "VidEdu | #{video.title}"
  end

  test "should redirect to index if user is trying to access a private video that they don't own" do
    sign_in users(:one)
    video = videos(:private)
    assert_not_empty(:video)
    get :show, id: video.id
    assert_redirected_to videos_path
  end

  test "should redirect to index if guest is trying to access a private video" do
    video = videos(:private)
    assert_not_empty(:video)
    get :show, id: video.id
    assert_redirected_to videos_path
  end

  test "should get new for user" do
    sign_in users(:one)
    get :new
    assert_response :success
    assert_select "title", "VidEdu | Add Video"
  end

  test "should get new for guest" do
    get :new
    assert_response :success
    assert_select "title", "VidEdu | Add Video"
  end

  test "should get edit if user is owner" do
    sign_in users(:one)
    video = videos(:one)
    assert_not_empty(:video)
    get :edit, id: video.id
    assert_response :success
    assert_select "title", "VidEdu | Edit Video"
  end

  test "should redirect to videos show if user tries to edit a video he/she does not own" do
    sign_in users(:two)
    video = videos(:one)
    get :edit, id: video.id
    assert_redirected_to video_path(video)
  end

  test "should redirect to login if guest tries to edit a subject" do
    video = videos(:one)
    get :edit, id: video.id
    assert_redirected_to new_user_session_path
  end

  test "should get users videos if logged in" do
    sign_in users(:one)
    get :your_videos
    assert_not_empty(:videos)
    assert_response :success
  end

  test "should redirect to login if guest tries to access 'your_videos'" do
    get :your_videos
    assert_redirected_to new_user_session_path
  end

end
