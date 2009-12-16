require File.expand_path('../../start', __FILE__)

describe "Room" do
  before do
    Broach.settings = settings
  end
  
  it "should fetch a list of all rooms" do
    rooms = Broach::Room.all
    rooms.each do |room|
      room.name.should.not == ''
    end
  end
  
  it "should fetch a specific room" do
    if room_to_fetch = Broach::Room.all.first
      room = Broach::Room.find(room_to_fetch.id)
      room.id.should == room_to_fetch.id
      room.name.should.not == ''
    end
  end
end