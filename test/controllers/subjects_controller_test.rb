require 'test_helper'

class SubjectsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  def setup
    @user = users(:default)
    @subject = subjects(:default)
  end
  
  # INDEX
  test "index" do
    get :index
    assert_not_empty(:subjects)
    assert_response :success
    assert_select "title", "VidEdu | All Subjects"
  end

  test "index when sort is 'Most Recently Updated'" do
    new_subject = Subject.create!(subject: "Cats", user_id: @user.id)
    @subject.update_attributes(description: "Update")
    get :index, sort: "Most Recently Updated"
    assert_response :success
    assert_select "title", "VidEdu | All Subjects"
    assert_not_empty(:subjects)
    results = assigns(:subjects)
    assert_operator results.index(@subject), :<, results.index(new_subject)
  end

  test "index when sort is 'Least Recently Updated'" do
    new_subject = Subject.create!(subject: "Cats", user_id: @user.id)
    @subject.update_attributes(description: "Update")
    get :index, sort: "Least Recently Updated"
    assert_response :success
    assert_select "title", "VidEdu | All Subjects"
    assert_not_empty(:subjects)
    results = assigns(:subjects)
    assert_operator results.index(new_subject), :<, results.index(@subject)
  end

  test "index when sort is 'Most Recently Created'" do
    new_subject = Subject.create!(subject: "Cats", user_id: @user.id)
    get :index, sort: "Most Recently Created"
    assert_response :success
    assert_select "title", "VidEdu | All Subjects"
    assert_not_empty(:subjects)
    results = assigns(:subjects)
    assert_operator results.index(new_subject), :<, results.index(@subject)
  end

  test "index when sort is 'Least Recently Created'" do
    new_subject = Subject.create!(subject: "Cats", user_id: @user.id)
    get :index, sort: "Least Recently Created"
    assert_response :success
    assert_select "title", "VidEdu | All Subjects"
    assert_not_empty(:subjects)
    results = assigns(:subjects)
    assert_operator results.index(@subject), :<, results.index(new_subject)
  end

  test "index when sort is 'Title: A-Z'" do
    new_subject = Subject.create!(subject: "Cats", user_id: @user.id)
    get :index, sort: "Title: A-Z"
    assert_response :success
    assert_select "title", "VidEdu | All Subjects"
    assert_not_empty(:subjects)
    results = assigns(:subjects)
    assert_operator results.index(new_subject), :<, results.index(@subject)
  end

  test "index when sort is 'Title: Z-A'" do
    new_subject = Subject.create!(subject: "Cats", user_id: @user.id)
    get :index, sort: "Title: Z-A"
    assert_response :success
    assert_select "title", "VidEdu | All Subjects"
    assert_not_empty(:subjects)
    results = assigns(:subjects)
    assert_operator results.index(@subject), :<, results.index(new_subject)
  end

  # SHOW
  test "show when subject is not private" do
    get :show, id: @subject.id
    assert_not_empty(:subject)
    assert_not_empty(:videos)
    assert_response :success
    assert_select "title", "VidEdu | #{User.find(@subject.user_id).username}'s #{@subject.subject} Playlist"
    assert_select "h1", "#{User.find(@subject.user_id).username}'s #{@subject.subject} Playlist"
  end

  test "show when subject is private and user is owner" do
    sign_in @user
    @subject.update_attributes(private: true)
    get :show, id: @subject.id
    assert_not_empty(:subject)
    assert_not_empty(:videos)
    assert_response :success
    assert_select "title", "VidEdu | Your #{@subject.subject} Playlist"
    assert_select "h1", "Your #{@subject.subject} Playlist"
  end

  test "show when subject is private and user is not owner" do
    sign_in @user
    @subject.update_attributes(user_id: 2, private: true)
    get :show, id: @subject.id
    assert_not_empty(:subject)
    assert_redirected_to subjects_path
  end

  test "show when subject is private and there is no user" do
    @subject.update_attributes(private: true)
    get :show, id: @subject.id
    assert_not_empty(:subject)
    assert_redirected_to subjects_path
  end

  # NEW
  test "new when user is signed in" do
    sign_in @user
    get :new
    assert_response :success
    assert_select "title", "VidEdu | Add Subject"
  end

  test "new when there is no user" do
    get :new
    assert_redirected_to new_user_session_path
  end

  # EDIT
  test "edit when user is owner" do
    sign_in @user
    get :edit, id: @subject.id
    assert_not_empty(:subject)
    assert_response :success
    assert_select "title", "VidEdu | Edit Subject"
  end

  test "edit when a user is not the owner" do
    sign_in @user
    @subject.update_attributes(user_id: 2)
    get :edit, id: @subject.id
    assert_not_empty(:subject)
    assert_redirected_to subject_path(@subject)
  end

  test "edit when there is no user" do
    get :edit, id: @subject.id
    assert_not_empty(:subject)
    assert_redirected_to new_user_session_path
  end

  # YOUR_SUBJECTS
  test "your_subjects when user is logged in" do
    sign_in @user
    get :your_subjects
    assert_not_empty(:subjects)
    assert_response :success
  end

  test "your_subjects when there is no user" do
    get :your_subjects
    assert_redirected_to new_user_session_path
  end

end
