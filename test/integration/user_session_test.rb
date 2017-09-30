require 'test_helper'

class UserSessionIntegrationTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:default)
  end

  # CREATE
  test "login" do
    get new_user_session_path
    assert_response :success
    assert_select "title", "VidEdu | Log In"
    post user_session_path, 
      user: {
        email: "twinpair@example.com", 
        password: "password"
      }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "title", "VidEdu | Home"
  end

  test "login when credentials are incorrect" do
    get new_user_session_path
    assert_response :success
    assert_select "title", "VidEdu | Log In"
    post user_session_path, 
      user: {
        email: "integration@example.com", 
        password: "wordpass"
      }
    assert_template :new
  end

  # DESTROY
  test "log out" do 
    sign_in_as @user
    delete destroy_user_session_path
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "title", "VidEdu | Home"
    assert_select "a[href=?]", new_user_session_path
    assert_select "a[href=?]", new_user_registration_path
  end

end