require 'test_helper'

class SubjectsControllerTest < ActionController::TestCase

  include Devise::TestHelpers
  
  test "should get index" do
    get :index
    assert_not_empty(:subjects)
    assert_response :success
    assert_select "title", "VidEdu | All Subjects"
  end

  test "should get show if subject is not private" do
    subject = subjects(:one)
    assert_not_empty(:subject)
    get :show, id: subject.id
    assert_response :success
    assert_select "title", "VidEdu | #{User.find(subject.user_id).username}'s #{subject.subject} Playlist"
  end

  test "should get show for private subject if user is owner" do
    sign_in users(:two)
    subject = subjects(:private)
    assert_not_empty(:subject)
    get :show, id: subject.id
    assert_response :success
    assert_select "title", "VidEdu | Your #{subject.subject} Playlist"
  end

  test "should redirect to index if user is trying to access a private subject that they don't own" do
    sign_in users(:one)
    subject = subjects(:private)
    assert_not_empty(:subject)
    get :show, id: subject.id
    assert_redirected_to subjects_path
  end

  test "should redirect to index if guest is trying to access a private subject" do
    subject = subjects(:private)
    assert_not_empty(:subject)
    get :show, id: subject.id
    assert_redirected_to subjects_path
  end

  test "should get new for user" do
    sign_in users(:one)
    get :new
    assert_response :success
    assert_select "title", "VidEdu | Add Subject"
  end

  test "should redirect to login if guest wants to access new" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "should get edit if user is owner" do
    sign_in users(:one)
    subject = subjects(:one)
    assert_not_empty(:subject)
    get :edit, id: subject.id
    assert_response :success
    assert_select "title", "VidEdu | Edit Subject"
  end

  test "should redirect to subjects show if user tries to edit a subject he/she does not own" do
    sign_in users(:two)
    subject = subjects(:one)
    get :edit, id: subject.id
    assert_redirected_to subject_path(subject)
  end

  test "should redirect to login if guest tries to edit a subject" do
    subject = subjects(:one)
    get :edit, id: subject.id
    assert_redirected_to new_user_session_path
  end

  test "should get users subjects if logged in" do
    sign_in users(:one)
    get :your_subjects
    assert_not_empty(:subjects)
    assert_response :success
  end

  test "should redirect to login if guest tries to access 'your_subjects'" do
    get :your_subjects
    assert_redirected_to new_user_session_path
  end

end
