require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  include Devise::TestHelpers
  
  test "should get homepage" do
    get :home
    assert_response :success
    assert_select "title", "VidEdu | Home"
  end

  test "should return empty search results" do
    get :search, search: "None"
    assert_empty assigns(:videos)
    assert_response :success
    assert_select "title", "VidEdu | Search"
  end

  test "should return search results based on title" do
    get :search, search: "Test"
    assert_not_empty assigns(:videos)
    assert_response :success
    assert_select "title", "VidEdu | Search"
  end

   test "should return search results based on notes" do
    get :search, search: "Number"
    assert_not_empty assigns(:videos)
    assert_response :success
    assert_select "title", "VidEdu | Search"
  end

end
