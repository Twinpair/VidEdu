require 'test_helper'

class UserIntegrationTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:integration)
  end
  
  # CREATE - REGISTRATION
  test "successful registration" do
    get new_user_registration_path
    assert_response :success
    assert_difference 'User.count', 1 do
      post user_registration_path, 
        user: {
          firstname: "first", 
          lastname: "last", 
          username: "username", 
          email: "firstlast@example.com" ,
          password: "password", 
          password_confirmation: "password"
        }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "title", "VidEdu | Home"
  end

  test "when user registers successfully, default subject is created as well" do
    get new_user_registration_path
    assert_response :success
    assert_difference 'Subject.count', 1 do
      post user_registration_path, 
        user: {
          firstname: "first", 
          lastname: "last", 
          username: "username", 
          email: "firstlast@example.com" ,
          password: "password", 
          password_confirmation: "password"
        }
    end
    assert_equal 1, User.last.subjects.count
  end

  test "unsuccessful registration with blank params" do
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

  test "unsuccessful registration with non unique username" do
    # username is taken by a user in user.yml fixture
    get new_user_registration_path
    assert_response :success
    assert_no_difference 'User.count' do
      post user_registration_path, 
        user: {
          firstname: "first", 
          lastname: "last", 
          username: "integration", 
          email: "firstlast@example.com" ,
          password: "password", 
          password_confirmation: "password"
        }
    end
    assert_template :new
  end

  test "unsuccessful registration with non unique email" do
    # email is taken by a user in user.yml fixture
    get new_user_registration_path
    assert_response :success
    assert_no_difference 'User.count' do
      post user_registration_path, 
        user: {
          firstname: "first", 
          lastname: "last", 
          username: "username", 
          email: "integration@example.com",
          password: "password", 
          password_confirmation: "password"
        }
    end
    assert_template :new
  end

  test "unsuccessful registration with non matching passwords" do
    # email is taken by a user in user.yml fixture
    get new_user_registration_path
    assert_response :success
    assert_no_difference 'User.count' do
      post user_registration_path, 
        user: {
          firstname: "first", 
          lastname: "last", 
          username: "username", 
          email: "firstlast@example.com",
          password: "password", 
          password_confirmation: "wordpass"
        }
    end
    assert_template :new
  end

  # CREATE - LOGIN
  test "successful login" do
    # User exist in user.yml fixture
    get new_user_session_path
    assert_response :success
    assert_select "title", "VidEdu | Log In"
    post user_session_path, 
      user: {
        email: "integration@example.com", 
        password: "password"
      }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "title", "VidEdu | Home"
  end

  test "unsuccessful login with incorrect password" do
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

  # UPDATE
  test "successful edit of name" do 
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

  test "successful edit of email" do 
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

  test "successful edit of username" do 
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

  test "unsuccessful edit with no user" do 
    get edit_user_registration_path
    assert_response :redirect
  end

  test "unsuccessful edit with blank name" do 
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

  test "unsuccessful edit of non unique username" do 
    # username is taken by a user in user.yml fixture
    sign_in_as @user
    get edit_user_registration_path
    assert_response :success
    assert_select "title", "VidEdu | Edit Account"
    patch "/users", 
      user: {
        username: "TEST_USER",
        current_password: "password"
      }
    @user.reload
    assert_not_equal "TEST_USER", "#{@user.username}"
  end

  test "unsuccessful edit of non unique email" do 
    # email is taken by a user in user.yml fixture
    sign_in_as @user
    get edit_user_registration_path
    assert_response :success
    assert_select "title", "VidEdu | Edit Account"
    patch "/users", 
      user: {
        email: "test_user@gmail.com",
        current_password: "password"
      }
    @user.reload
    #email is always downcase
    assert_not_equal "test_user@gmail.com", "#{@user.email}"
  end

  test "unsuccessful edit with incorrect password" do 
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

  # DESTROY - Session/Logout
  test "successful log out" do 
    sign_in_as @user
    delete destroy_user_session_path
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select "title", "VidEdu | Home"
    assert_select "a[href=?]", new_user_session_path
    assert_select "a[href=?]", new_user_registration_path
  end

  # DESTROY - Destroy User
  test "successful user destroy" do 
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

  test "when user is destoyed, his comment are destroyed as well" do
    # Create new user so fixtures are not messed with
    assert_difference 'User.count', 1 do
      post user_registration_path, 
        user: {
          firstname: "first", 
          lastname: "last", 
          username: "username", 
          email: "firstlast@example.com" ,
          password: "password", 
          password_confirmation: "password"
        }
    end
    video = videos(:integration)
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

  test "when user is destoyed, his videos are destroyed as well" do
    # Create new user so fixtures are not messed with
    assert_difference 'User.count', 1 do
      post user_registration_path, 
        user: {
          firstname: "first", 
          lastname: "last", 
          username: "username", 
          email: "firstlast@example.com" ,
          password: "password", 
          password_confirmation: "password"
        }
    end
    assert_difference 'Video.count', 1 do
      post videos_path, 
        { 
          video: {
            link: "https://www.youtube.com/watch?v=integration",
            note: "",
            subject_id: 4000 # Default subject is always pre-selected
          } ,
          subject: {
            subject: ""
          }
        }
    end
    assert_difference "Video.count", -1 do
      delete "/users"
    end
  end

  test "when user is destoyed, his default subject is destroyed as well" do
    # Create new user so fixtures are not messed with
    assert_difference 'User.count', 1 do
      post user_registration_path, 
        user: {
          firstname: "first", 
          lastname: "last", 
          username: "username", 
          email: "firstlast@example.com" ,
          password: "password", 
          password_confirmation: "password"
        }
    end
    assert_difference "Subject.count", -1 do
      delete "/users"
    end
  end

  test "when user is destoyed, his subjects are destroyed as well" do
    # Create new user so fixtures are not messed with
    assert_difference 'User.count', 1 do
      post user_registration_path, 
        user: {
          firstname: "first", 
          lastname: "last", 
          username: "username", 
          email: "firstlast@example.com" ,
          password: "password", 
          password_confirmation: "password"
        }
    end
    assert_difference 'Subject.count', 1 do
      post subjects_path, 
        subject: {
          subject: "integration"
        } 
    end
    assert_difference "Subject.count", -2 do
      delete "/users"
    end
  end

end
