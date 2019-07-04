require 'test_helper'

class RsvpTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "01 RSVP create OK" do
    rsvp = Rsvp.new(event_id: 123, user_id: 456)
    assert rsvp.valid?
  end

end
