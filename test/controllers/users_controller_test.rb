require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # setup do
  #   @user1 = User.new(
  #     name: "tane5",
  #     email: "tane5@tane.com"
  #   )


  test "01 should get login" do
    get login_url
    assert_response :success
    assert_select "body", /Log in/
  end

  test "02 should get signup" do
    get signup_url
    assert_response :success
    assert_select "body", /Sign up/
  end

  test "03 should get logout" do
    #非ログイン状態
    get logout_url
    assert_response :redirect
    assert_redirected_to root_url
    #ログイン状態
    post user_session_path, params:{ user: { 
      email: "test1@example.com",
      password: "secret"
    } }
    get root_url
    assert_select "body", /Signed in successfully./
    get logout_url
    assert_response :redirect
    assert_redirected_to root_url
    get root_url
    assert_select "body", /Signed out successfully./
  end
end
