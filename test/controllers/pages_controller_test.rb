require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get subjects" do
    get :subjects
    assert_response :success
  end

  test "should get profile" do
    get :profile
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

  test "should get featured" do
    get :featured
    assert_response :success
  end

  test "should get faq" do
    get :faq
    assert_response :success
  end

  test "should get splash" do
    get :splash
    assert_response :success
  end

end
