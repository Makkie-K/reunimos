require 'test_helper'

class EventsIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    user1 = User.find_by(name: "test_admin")
    @event1 = Event.find_by(creator_id: user1.id)
    user2 = User.find_by(name: "test_creator")
    @event2 = Event.find_by(creator_id: user2.id)
    # puts user1.id
    # puts @event1.event_name
    # puts user2.id
    # puts @event2.event_name
  end
  
  test "03 test for accessing to the event page" do
    # NOT logged in
    get events_create_url
    assert_response :redirect
    assert_redirected_to root_url
    # Logged in
    # Admin
    post user_session_url, params:{ user: { 
      email: "test1@example.com",
      password: "secret"
    }}
    get events_create_url
    assert_response :success
    assert_select "body", /Event Create/

    #Creator
    get logout_url
    post user_session_url, params:{ user: { 
      email: "test2@example.com",
      password: "secret"
    }}
    get events_create_url
    assert_response :success
    assert_select "body", /Event Create/
    # User
    get logout_url
    post user_session_url, params:{ user: { 
      email: "test3@example.com",
      password: "secret"
    }}
    get events_create_url
    assert_response :redirect
    assert_redirected_to root_url
  end

  # Create a new event
  test "04 test for event submitting function" do
    # NOT logged in
    assert_difference('Event.count', 0) do
      post events_new_url, params:{
        date: "2019-06-11",
        time: "09:00",
        event_name: "event_test_name1",
        description: "event_test_description1",
        location: "Akihabara, Taito-ku, Tokyo"
      }
    end
    assert_response :redirect
    assert_redirected_to root_url
    # Logged in
    # Admin
    post user_session_url, params:{ user: { 
      email: "test1@example.com",
      password: "secret"
    }}
    assert_difference('Event.count', 1) do
      post events_new_url, params:{
        date: "2019-06-11",
        time: "09:00",
        event_name: "event_test_name1",
        description: "event_test_description1",
        location: "Akihabara, Taito-ku, Tokyo"
      }
    end
    assert_response :redirect
    e = Event.find_by(event_name: "event_test_name1")
    #puts e.event_name
    assert_equal e[:description], "event_test_description1"
    assert_redirected_to events_show_path(e.id)
    get events_show_url(e.id)
    assert_select "body", /event_test_name1/

    # Creator
    get logout_url
    post user_session_url, params:{ user: { 
      email: "test2@example.com",
      password: "secret"
    }}
    assert_difference('Event.count', 1) do
      post events_new_url, params:{
        date: "2019-06-11",
        time: "09:00",
        event_name: "event_test_name2",
        description: "event_test_description2",
        location: "Akihabara, Taito-ku, Tokyo"
      }
    end
    assert_response :redirect
    e = Event.find_by(event_name: "event_test_name2")
    
    #puts e.event_name
    assert_equal e[:description], "event_test_description2"
    assert_redirected_to events_show_path(e.id)
    get events_show_url(e.id)
    assert_select "body", /event_test_name2/

    # User
    get logout_url
    post user_session_url, params:{ user: { 
      email: "test3@example.com",
      password: "secret"
    }}
    assert_difference('Event.count', 0) do
      post events_new_url, params:{
        date: "2019-06-11",
        time: "09:00",
        event_name: "event_test_name3",
        description: "event_test_description",
        location: "Akihabara, Taito-ku, Tokyo"
      }
    end
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "05 test for a rsvp function" do
    # NOT logged in
    assert_difference('Rsvp.count', 0) do
      post rsvp_create_url(@event2.id)
    end
    assert_response :redirect
    assert_redirected_to root_url
    # Logged in
    post user_session_url, params:{ user: { 
      email: "test3@example.com",
      password: "secret"
    }}
    assert_difference('Rsvp.count', 1) do
      post rsvp_create_url, params:{
        event_id: @event2.id
      }
    end
    assert_response :redirect
    assert_redirected_to events_show_path(@event2.id)
    get events_show_path(@event2.id)
    assert_select "body", /Event Description Page/
    assert_select "body", /test_user/
  end

  test "06_1 test for an event function for Admin" do
    #非ログイン状態
    assert_difference('Event.count', 0) do
      post event_delete_url(@event2.id)
    end
    assert_response :redirect
    assert_redirected_to root_url
    #ログイン状態
    post user_session_url, params:{ user: { 
      email: "test1@example.com",
      password: "secret"
    }}
    assert_difference('Event.count', -1) do
      post event_delete_url(@event2.id)
    end
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "06_2 test for an event function for Creator" do
    #Creatorによって、他人が作ったイベントは削除できないことの確認
    # post user_session_url, params:{ user: { 
    #   email: "test1@example.com",
    #   password: "secret"
    # }}
    # assert_difference('Event.count', 1) do
    #   post events_new_url, params:{
    #     date: "2019-06-11",
    #     time: "09:00",
    #     event_name: "event_test_name06_2_1",
    #     description: "event_test_description06_2_1",
    #     location: "Akihabara, Taito-ku, Tokyo"
    #   }
    # end
    #Creatorがログイン
    # get logout_url
    #event = Event.find_by(event_name: "event_test_name06_2_1")
    post user_session_url, params:{ user: { 
      email: "test2@example.com",
      password: "secret"
    }}
    assert_difference('Event.count', 0) do
      post event_delete_url(@event1.id)
    end
    assert_response :redirect
    assert_redirected_to root_url
    #Creatorによって、自分が作ったイベントを削除できることの確認
    # assert_difference('Event.count', 1) do
    #   post events_new_url, params:{
    #     date: "2019-06-11",
    #     time: "09:00",
    #     event_name: "event_test_name06_2_2",
    #     description: "event_test_description06_2_2",
    #     location: "Akihabara, Taito-ku, Tokyo"
    #   }
    # end
    # event = Event.find_by(event_name: "event_test_name06_2_2")
    assert_difference('Event.count', -1) do
      post event_delete_url(@event2.id)
    end
    assert_response :redirect
    assert_redirected_to root_url
      

  end

  test "06_3 test for an event function for User" do
    #ログイン状態
    post user_session_url, params:{ user: { 
      email: "test3@example.com",
      password: "secret"
    }}
    assert_difference('Event.count', 0) do
      post event_delete_url(@event2.id)
    end
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "07_1 test for accessing to the event edit page for Admin " do
    #非ログイン状態
    post event_edit_url(@event2.id)
    assert_response :redirect
    assert_redirected_to root_url
    #Adminがログイン後、イベント編集画面に
    post user_session_path, params:{ user: { 
      email: "test1@example.com",
      password: "secret"
    }}
    post event_edit_url(@event2.id)
    assert_response :success
    assert_select "body", /Event Edit/
  end

  test "07_2 test for accessing to the event edit page for Creator " do
    #ログイン状態
    post user_session_path, params:{ user: { 
      email: "test2@example.com",
      password: "secret"
    }}
    post event_edit_url(@event2.id)
    # user = User.find_by(email: "test2@example.com")
    # puts user.id
    # puts @event2.creator_id
    assert_response :success
    assert_select "body", /Event Edit/

    post event_edit_url(@event1.id)
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "07_3 test for accessing to the event edit page for User" do
    #ログイン状態
    post user_session_path, params:{ user: { 
      email: "test3@example.com",
      password: "secret"
    }}
    post event_edit_url(@event2.id)
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "08_1 test for an event update function for Admin" do
    #非ログイン状態
    put event_update_url(@event2.id)
    assert_response :redirect
    assert_redirected_to root_url
    #ログイン状態
    post user_session_path, params:{ user: { 
      email: "test1@example.com",
      password: "secret"
    }}
    put event_update_url(@event2.id), params:{
      event_name: "event_test_name_modified1",
      description: "event_test_description_modified1",
      date: "2019-06-10",
      time: "18:31",
      location: "Asakusa, Taito-ku, Tokyo"
    }

    assert_response :redirect
    assert_redirected_to events_show_url(@event2.id)
    get events_show_url(@event2.id)
    assert_select "body", /event_test_name_modified1/
    assert_select "body", /The event has been successfully updated./
  end

  test "08_2 test for an event update function for Creator" do
    #ログイン状態
    post user_session_path, params:{ user: { 
      email: "test2@example.com",
      password: "secret"
    }}
    put event_update_url(@event2.id), params:{
      event_name: "event_test_name_modified1",
      description: "event_test_description_modified1",
      date: "2019-06-10",
      time: "18:31",
      location: "Asakusa, Taito-ku, Tokyo"
    }

    assert_response :redirect
    assert_redirected_to events_show_url(@event2.id)
    get events_show_url(@event2.id)
    assert_select "body", /event_test_name_modified1/
    assert_select "body", /The event has been successfully updated./

    put event_update_url(@event1.id), params:{
      event_name: "event_test_name_modified1",
      description: "event_test_description_modified1",
      date: "2019-06-10",
      time: "18:31",
      location: "Asakusa, Taito-ku, Tokyo"
    }

    assert_response :redirect
    assert_redirected_to root_url
  end

  test "08_3 test for an event update function for User" do
    #ログイン状態
    post user_session_path, params:{ user: { 
      email: "test3@example.com",
      password: "secret"
    }}
    put event_update_url(@event2.id), params:{
      event_name: "event_test_name_modified1",
      description: "event_test_description_modified1",
      date: "2019-06-10",
      time: "18:31",
      location: "Asakusa, Taito-ku, Tokyo"
    }
    assert_response :redirect
    assert_redirected_to root_url  
  end
end
