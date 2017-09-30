require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(firstname: "user", lastname: "name", 
                      username: "username", email: "username@example.com" ,
                      password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "first name should be present" do
    @user.firstname = "     "
    assert_not @user.valid?
  end

  test "last name should be present" do
    @user.lastname = "     "
    assert_not @user.valid?
  end

  test "username should be present" do
    @user.username = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "email should be email format" do
    @user.email = "not email"
    assert_not @user.valid?
  end

  test "password should be present" do
    @user.password = "     "
    assert_not @user.valid?
  end

  test "password confirmation should match password" do
    @user.password_confirmation = "wordpass"
    assert_not @user.valid?
  end

end
