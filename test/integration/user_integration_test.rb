require 'test_helper'

class UserIntegrationTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:default)
  end
  
  # CREATE - REGISTRATION
  test "create" do
    get new_user_registration_path
    assert_response :success
    assert_difference 'User.count', 1 do
      post user_registration_path, 
        user: {
          firstname: "user", 
          lastname: "name", 
          username: "username", 
          email: "username@example.com" ,
          password: "password", 
          password_confirmation: "password"
        }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "title", "VidEdu | Home"
  end

  test "create and verify default subject is created concurrently" do
    get new_user_registration_path
    assert_response :success
    assert_difference 'Subject.count', 1 do
      post user_registration_path, 
        user: {
          firstname: "user", 
          lastname: "name", 
          username: "username", 
          email: "username@example.com" ,
          password: "password", 
          password_confirmation: "password"
        }
    end
    assert_equal 1, User.last.subjects.count
  end

  test "create when params are blank" do
    get new_user_registration_path
    assert_response :success
    assert_no_difference 'User.count' do
      post user_registration_path, 
        user: {
          firstname: "first", 
          lastname: " ", 
          username: "username", 
          email: "  " ,
          password: "  ", 
          password_confirmation: "password"
        }
    end
    assert_template :new
  end

  test "create when username param is not unique" do
    # username is taken by a user in user.yml fixture
    get new_user_registration_path
    assert_response :success
    assert_no_difference 'User.count' do
      post user_registration_path, 
        user: {
          firstname: "user", 
          lastname: "name", 
          username: "Twinpair", 
          email: "username@example.com" ,
          password: "password", 
          password_confirmation: "password"
        }
    end
    assert_template :new
  end

  test "create when email param is not unique" do
    # email is taken by a user in user.yml fixture
    get new_user_registration_path
    assert_response :success
    assert_no_difference 'User.count' do
      post user_registration_path, 
        user: {
          firstname: "user", 
          lastname: "name", 
          username: "username", 
          email: "twinpair@example.com",
          password: "password", 
          password_confirmation: "password"
        }
    end
    assert_template :new
  end

  test "create when password params don't match" do
    get new_user_registration_path
    assert_response :success
    assert_no_difference 'User.count' do
      post user_registration_path, 
        user: {
          firstname: "user", 
          lastname: "name", 
          username: "username", 
          email: "username@example.com",
          password: "password", 
          password_confirmation: "wordpass"
        }
    end
    assert_template :new
  end

  # UPDATE
  test "update when updating name" do 
    sign_in_as @user
    get edit_user_registration_path
    assert_response :success
    assert_select "title", "VidEdu | Edit Account"
    patch "/users", 
      user: {
        firstname: "EDIT", 
        lastname: "NAME",
        current_password: "password"
      }
    @user.reload
    assert_equal "EDIT NAME", "#{@user.firstname} #{@user.lastname}"
  end

  test "update when updating email" do 
    sign_in_as @user
    get edit_user_registration_path
    assert_response :success
    assert_select "title", "VidEdu | Edit Account"
    patch "/users", 
      user: {
        email: "UpdatingEmail@example.com",
        current_password: "password"
      }
    @user.reload
    #email is always downcase
    assert_equal "updatingemail@example.com", "#{@user.email}"
  end

  test "update when updating username" do 
    sign_in_as @user
    get edit_user_registration_path
    assert_response :success
    assert_select "title", "VidEdu | Edit Account"
    patch "/users", 
      user: {
        username: "UpdatingUsername",
        current_password: "password"
      }
    @user.reload
    assert_equal "UpdatingUsername", "#{@user.username}"
  end

  test "update when there is no user" do 
    get edit_user_registration_path
    assert_response :redirect
  end

  test "update when name param is blank" do 
    sign_in_as @user
    get edit_user_registration_path
    assert_response :success
    assert_select "title", "VidEdu | Edit Account"
    patch "/users", 
      user: {
        firstname: "",
        lastname: "",
        current_password: "password"
      }
    @user.reload
    assert_not_equal "", "#{@user.username}"
  end

  test "update when username is not unique" do
    sign_in_as @user
    get edit_user_registration_path
    assert_response :success
    assert_select "title", "VidEdu | Edit Account"
    patch "/users", 
      user: {
        username: "firstlast",
        current_password: "password"
      }
    @user.reload
    assert_not_equal "firstlast", "#{@user.username}"
  end

  test "update when email is not unique" do 
    sign_in_as @user
    get edit_user_registration_path
    assert_response :success
    assert_select "title", "VidEdu | Edit Account"
    patch "/users", 
      user: {
        email: "firstlast@example.com",
        current_password: "password"
      }
    @user.reload
    #email is always downcase
    assert_not_equal "firstlast@example.com", "#{@user.email}"
  end

  test "update when password is incorrect" do 
    sign_in_as @user
    get edit_user_registration_path
    assert_response :success
    assert_select "title", "VidEdu | Edit Account"
    patch "/users", 
      user: {
        firstname: "EDIT", 
        lastname: "NAME",
        username: "UpdatingUsername",
        email: "UpdatingEmail@example.com",
        current_password: "wordpass"
      }
    @user.reload
    assert_not_equal "EDIT NAME", "#{@user.firstname} #{@user.lastname}"
    assert_not_equal "TEST_USER", "#{@user.username}"
    assert_not_equal "test_user@gmail.com", "#{@user.email}"
  end

  # DESTROY - Destroy User
  test "destroy" do 
    sign_in_as @user
    get edit_user_registration_path
    assert_response :success
    assert_select "title", "VidEdu | Edit Account"
    assert_difference "User.count", -1 do
      delete "/users"
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "title", "VidEdu | Home"
    assert_select "a[href=?]", new_user_session_path
    assert_select "a[href=?]", new_user_registration_path
  end

  test "destroy and verify users comment are also destroyed" do
    sign_in_as @user
    video = videos(:default)
    assert_difference 'Comment.count', 1 do
      post video_comments_path(video), 
        comment: {
          body: "This is a comment"
        }, xhr: true
    end
    assert_difference "Comment.count", -1 do
      delete "/users"
    end
  end

  test "destroy and verify users videos are also destroyed" do
    sign_in_as @user
    assert_difference "Video.count", -1 do
      delete "/users"
    end
  end

  test "destroy and verify users subjects are also destroyed" do
    sign_in_as @user
    assert_difference "Subject.count", -1 do
      delete "/users"
    end
  end

end
