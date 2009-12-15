require File.expand_path('../../start', __FILE__)

class RoomTest < Test::Unit::TestCase
  def test_session_returns_all_rooms
    session = Broach::Session.new(settings)
    p session.rooms
  end
end