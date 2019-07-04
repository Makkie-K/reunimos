require "application_system_test_case"
    
class EventMapTest < ApplicationSystemTestCase
  test '01 test for display a map on the event page' do
    #visit root_url
    event = Event.find_by(event_name: "event_test1")
    visit events_show_path(event[:id])
    # first, assert that the map element is on the page
    assert_selector "#map"

    # test that at least one map marker was created
    assert_selector('.leaflet-map-pane')

    # click on one of the map markers, and assert that the mini-post markup is displayed 
    # first('.leaflet-marker-icon').click
    # page.assert_selector('.mini-post')
  end

end