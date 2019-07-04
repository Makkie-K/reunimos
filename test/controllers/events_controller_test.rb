require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
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

  test "01 root confirmation page" do
    get root_url
    assert_response :success
  end

  test "02 event description page" do
    # get '/events/show/298486374'
    get events_show_path(@event2.id)
    assert_response :success
  end
end
