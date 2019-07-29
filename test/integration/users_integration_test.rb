require 'test_helper'

class UsersIntegrationTest < ActionDispatch::IntegrationTest
  test "04 test for admin page" do # 管理者画面のテスト
    #非ログイン状態
    get  users_index_url
    assert_response :redirect
    assert_redirected_to root_url

    #ログイン状態
    # Admin
    post user_session_path, params:{ user: { 
      email: "test1@example.com",
      password: "secret"
    } }
    get  users_index_url
    assert_response :success
    assert_select "header", /Admission Page/
    assert_select "header", /Event Create/
    assert_select "header", /Log out/
    assert_select "header a", 5
    assert_select "h2", /Admission Page/

    # Creator
    get logout_url
    post user_session_path, params:{ user: { 
      email: "test2@example.com",
      password: "secret"
    }}
    get users_index_url
    assert_response :redirect
    assert_redirected_to root_url
    get root_url
    assert_select "header", /Event Create/
    assert_select "header", /Log out/
    assert_select "header a", 4 
    # get  users_index_url
    # assert_response :success
    # assert_select "h3", /Administration Page/

    # User
    get logout_url
    post user_session_path, params:{ user: { 
      email: "test3@example.com",
      password: "secret"
    }}
    get users_index_url
    assert_response :redirect
    assert_redirected_to root_url
    get root_url
    assert_select "header", /Log out/
    assert_select "header a", 3
  end

  test "05 test for signup logout login" do
    assert_difference('User.count',1) do
      post user_registration_url, params:{ user:{
        name: "tane5",
        email: "tane5@tane.com",
        password: "12345678",
        password_confirmation: "12345678"        
    }}
    end
    assert_redirected_to root_url  
    # ログアウト
    get logout_url
    assert_response :redirect
    assert_redirected_to root_url
    get root_url
    assert_select "body", /Signed out successfully./

    #login failed

    post user_session_path, params:{ user: { 
      email: "tane5@tane.com",
      password: "11111111"
    } }
    assert_response :success
    assert_select "body", /Invalid Email or password./
    assert_select "body", /Log in/
  

    #ログイン
    post user_session_path, params:{ user: { 
      email: "tane5@tane.com",
      password: "12345678"
    } }
    assert_response :redirect
    assert_redirected_to root_url
    get root_url
    assert_select "body", /Signed in successfully./
    assert_select "body", /Log out/
  end

  test "06 test for a devise function" do
    post user_session_path, params:{ user: { 
      email: "test1@example.com",
      password: "secret"
    } }
    assert_response :redirect
    assert_redirected_to root_url
    get root_url
    assert_select "body", /Signed in successfully./
    assert_select "body", /Log out/
  end

  test "07 test for permission modification " do
    post user_session_path, params:{ user: { 
      email: "test1@example.com",
      password: "secret"
    }}
    get  users_index_url
    assert_response :success
    post users_update_path, params: {
      permission: "admin",
      name: "test3",
      email: "test3@example.com"
    }
    assert_response :redirect
    assert_redirected_to users_index_url
    get logout_url
    post user_session_path, params:{ user: { 
      email: "test3@example.com",
      password: "secret"
    }}
    get root_url
    assert_select "header", /Log out/
    assert_select "header a", 5
    assert_select "header", /Admission Page/
    assert_select "header", /Event Create/
  end
end
