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
  
  it "should fetch a room with a specific ID" do
    if room_to_fetch = Broach::Room.all.first
      room = Broach::Room.find(room_to_fetch.id)
      room.id.should == room_to_fetch.id
      room.name.should.not == ''
    end
  end
  
  it "should fetch a room with a specific name" do
    name = Broach.session.room
    room = Broach::Room.find_by_name(name)
    room.name.should == name
  end
end

describe "A Room" do
  before do
    Broach.settings = settings
    @room = Broach::Room.all.find do |room|
      room.name == Broach.session.room
    end
  end
  
  it "should speak text" do
    body = 'Should speak text'
    message = @room.speak(body)
    message['body'].should == body
  end

  it "should speak paste" do
    body = 'Should speak paste'
    message = @room.speak(body, :type => :paste)
    message['body'].should == body
  end
  
  it "should speak sound" do
    body = 'crickets'
    message = @room.speak(body, :type => :sound)
    message['body'].should == body
  end
end