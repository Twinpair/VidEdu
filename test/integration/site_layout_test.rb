require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:integration)
  end

  
  test "custom navbar links with no user" do
    get root_path
    assert_response :success
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", '#tf-home'
    assert_select "a[href=?]", '#tf-about'
    assert_select "a[href=?]", '#tf-team'
    assert_select "a[href=?]", '#tf-services'
    assert_select "a[href=?]", '#tf-clients'
    assert_select "a[href=?]", '#tf-contact'
    assert_select "a[href=?]", videos_path
    assert_select "a[href=?]", subjects_path
    assert_select "a[href=?]", new_video_path
    assert_select "a[href=?]", new_user_session_path
    assert_select "a[href=?]", new_user_registration_path
  end

  test "custom navbar links with user" do
    sign_in_as(@user)
    get root_path
    assert_response :success
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", '#tf-home'
    assert_select "a[href=?]", videos_path
    assert_select "a[href=?]", subjects_path
    assert_select "a[href=?]", new_video_path
    assert_select "a[href=?]", new_subject_path
    assert_select "a[href=?]", your_videos_path
    assert_select "a[href=?]", your_subjects_path
    assert_select "a[href=?]", edit_user_registration_path
    assert_select "a[href=?]", destroy_user_session_path
  end

  test "site-wide navbar links with no user" do
    get videos_path
    assert_response :success
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", root_path + '#tf-about'
    assert_select "a[href=?]", root_path + '#tf-team'
    assert_select "a[href=?]", root_path + '#tf-services'
    assert_select "a[href=?]", root_path + '#tf-clients'
    assert_select "a[href=?]", root_path + '#tf-contact'
    assert_select "a[href=?]", videos_path
    assert_select "a[href=?]", subjects_path
    assert_select "a[href=?]", new_video_path
    assert_select "a[href=?]", new_user_session_path
    assert_select "a[href=?]", new_user_registration_path
  end

  test "site-wide navbar links with user" do
    sign_in_as(@user)
    get videos_path
    assert_response :success
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", videos_path
    assert_select "a[href=?]", subjects_path
    assert_select "a[href=?]", new_video_path
    assert_select "a[href=?]", new_subject_path
    assert_select "a[href=?]", your_videos_path
    assert_select "a[href=?]", your_subjects_path
    assert_select "a[href=?]", edit_user_registration_path
    assert_select "a[href=?]", destroy_user_session_path
  end

end
