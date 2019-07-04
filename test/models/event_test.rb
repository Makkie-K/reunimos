require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "01 event create success" do
    # date: "2019-06-15",
    # time: "09:00",
    event = Event.new(
        event_date: "2019-06-15 09:00",
        event_name: "event_unit_test1",
        description: "event_unit_test_description1",
        location: "Akihabara, Taito-ku, Tokyo"
    )
    assert event.valid? 
  end

  test "02 an invalid_event without event_date" do
    # date: "2019-06-15",
    # time: "09:00",
    event = Event.new(
        event_date: "",
        event_name: "event_unit_test1",
        description: "event_unit_test_description1",
        location: "Akihabara, Taito-ku, Tokyo"
    )
    refute event.valid?
    assert_not_nil event.errors[:event_date] 
  end

  test "03 an invalid_event without event_name" do
    # date: "2019-06-15",
    # time: "09:00",
    event = Event.new(
        event_date: "2019-06-15 09:00",
        event_name: "",
        description: "event_unit_test_description1",
        location: "Akihabara, Taito-ku, Tokyo"
    )
    refute event.valid?
    assert_not_nil event.errors[:event_name] 
  end

  test "04 an invalid_event without the description" do
    # date: "2019-06-15",
    # time: "09:00",
    event = Event.new(
        event_date: "2019-06-15 09:00",
        event_name: "event_unit_test1",
        description: "",
        location: "Akihabara, Taito-ku, Tokyo"
    )
    refute event.valid?
    assert_not_nil event.errors[:description] 
  end

  test "05 an invalid_event without the location" do
    # date: "2019-06-15",
    # time: "09:00",
    event = Event.new(
        event_date: "2019-06-15 09:00",
        event_name: "event_unit_test1",
        description: "event_unit_test_description1",
        location: ""
    )
    refute event.valid?
    assert_not_nil event.errors[:location] 
  end


  test "06 event name less than 51" do
    # date: "2019-06-15",
    # time: "09:00",
    event = Event.new(
        event_date: "2019-06-15 09:00",
        event_name: "123456789012345678901234567890123456789012345678901",
        description: "event_test_description1",
        location: "Akihabara, Taito-ku, Tokyo"
    )
    refute event.valid?
    assert_not_nil event.errors[:event_name] 
  end

  test "07 event description less than 501" do
    # date: "2019-06-15",
    # time: "09:00",
    event = Event.new(
        event_date: "2019-06-15 09:00",
        event_name: "event_unit_test",
        description: "12345678901234567890123456789012345678901234567890" +
        "12345678901234567890123456789012345678901234567890" +
        "12345678901234567890123456789012345678901234567890" +
        "12345678901234567890123456789012345678901234567890" +
        "12345678901234567890123456789012345678901234567890" +
        "12345678901234567890123456789012345678901234567890" +
        "12345678901234567890123456789012345678901234567890" +
        "12345678901234567890123456789012345678901234567890" +
        "12345678901234567890123456789012345678901234567890" +
        "123456789012345678901234567890123456789012345678901",
        location: "Akihabara, Taito-ku, Tokyo"
    )
    refute event.valid?
    assert_not_nil event.errors[:description] 
  end

  test "08 event invalid locaton more than 256" do
    # date: "2019-06-15",
    # time: "09:00",
    event = Event.new(
        event_date: "2019-06-15 09:00",
        event_name: "event_unit_test1",
        description: "event_unit_test_description1",
        location: "12345678901234567890123456789012345678901234567890" +
        "12345678901234567890123456789012345678901234567890" +
        "12345678901234567890123456789012345678901234567890" +
        "12345678901234567890123456789012345678901234567890" +
        "12345678901234567890123456789012345678901234567890" +
        "123456"
    )
    refute event.valid?
    assert_not_nil event.errors[:location] 
  end

end
