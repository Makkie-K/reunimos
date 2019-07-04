require 'test_helper'

class RsvpIntegrationTest < ActionDispatch::IntegrationTest

    test "01 test for a rsvp submit function " do
        # User
        post user_session_path, params:{ user: { 
            email: "test3@example.com",
            password: "secret"
        }}
        event = Event.find_by(event_name: "event_test1")
        # puts event.event_name
        # puts event.id
        # puts event.event_date
        assert_difference('Rsvp.count', 1) do
            post rsvp_create_url, params: {
               event_id: event[:id]

            }
        end
        assert_response :redirect
        assert_redirected_to events_show_path(event.id)
        get events_show_path(event.id)
        assert_select "body", /test_user/
    end

    test "02 test for a rsvp delete function" do
        post user_session_path, params:{ user: { 
            email: "test2@example.com",
            password: "secret"
        }}
        event = Event.find_by(event_name: "event_test1")
        assert_difference('Rsvp.count', 1) do
            post rsvp_create_url, params: {
               event_id: event[:id]
            }
        end
        # Confirm -1 from "RSVP" by deleting Event.
        get logout_url
        post user_session_path, params:{ user: { 
            email: "test1@example.com",
            password: "secret"
        }}
        assert_difference('Rsvp.count', -1) do
            post event_delete_url(event[:id])
        end
        assert_response :redirect
        assert_redirected_to root_url
    end    

    test "03 test for cannot rsvp submit with the same id" do
        post user_session_path, params:{ user: { 
            email: "test1@example.com",
            password: "secret"
        }} 
        event = Event.find_by(event_name: "event_test1")
        assert_difference('Rsvp.count', 0) do
            post rsvp_create_url, params: {
               event_id: event[:id]
            }
        end
        assert_response :success   
    end

end