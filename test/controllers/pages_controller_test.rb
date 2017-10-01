require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  # HOME
  test "home" do
    get :home
    assert_response :success
    assert_select "title", "VidEdu | Home"
  end

  # SEARCH
  test "search when search param is empty and filter for video" do
    get :search, search: ""
    assert_not_empty assigns(:videos)
    assert_response :success
    assert_select "title", "VidEdu | Search"
  end

  test "search when search param matches no videos" do
    get :search, search: "None"
    assert_empty assigns(:videos)
    assert_response :success
    assert_select "title", "VidEdu | Search"
  end

  test "search when search param matches videos based on title" do
    get :search, search: "Test"
    assert_not_empty assigns(:videos)
    assert_response :success
    assert_select "title", "VidEdu | Search"
  end

  test "search when search param matches videos based on notes" do
    get :search, search: "This"
    assert_not_empty(:videos)
    assert_response :success
    assert_select "title", "VidEdu | Search"
  end

  test "search when search param is empty and filter for subjects" do
    get :search, search: "", filter: "Subjects"
    assert_not_empty assigns(:subjects)
    assert_response :success
    assert_select "title", "VidEdu | Search"
  end

  test "search when search param matches no subjects" do
    get :search, search: "None", filter: "Subjects"
    assert_empty assigns(:subjects)
    assert_response :success
    assert_select "title", "VidEdu | Search"
  end

  test "search when search param matches subjects based on title" do
    get :search, search: "Test", filter: "Subjects"
    assert_not_empty assigns(:subjects)
    assert_response :success
    assert_select "title", "VidEdu | Search"
  end

  test "search when search param matches subjects based on description" do
    get :search, search: "This", filter: "Subjects"
    assert_not_empty(:subjects)
    assert_response :success
    assert_select "title", "VidEdu | Search"
  end

end
