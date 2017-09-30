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
  test "search when search param matches no videos" do
    get :search, search: "None"
    assert_empty assigns(:videos)
    assert_response :success
    assert_select "title", "VidEdu | Search"
  end

  test "search when search params matches videos based on title" do
    get :search, search: "Test"
    assert_not_empty assigns(:videos)
    assert_response :success
    assert_select "title", "VidEdu | Search"
  end

   test "search when search params mathces videos based on notes" do
    get :search, search: "This"
    assert_not_empty(:videos)
    assert_response :success
    assert_select "title", "VidEdu | Search"
  end

end
