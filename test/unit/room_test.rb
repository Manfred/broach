require File.expand_path('../../start', __FILE__)

describe "Room" do
  it "should initialize with attributes fetched from the server" do
    attributes = {"name" => "Office", "created_at" => "2007/01/03 08:59:11 +0000", "updated_at" => "2009/12/13 19:53:03 +0000", "topic" => "Maybe IRB bug!!", "id" => 65667, "membership_limit" => 25 }
    room       = Broach::Room.new(attributes)
    
    attributes.each do |key, value|
      room.send(key).should == value
    end
  end
  
  it "should find a room with a certain ID from the server" do
    mock_response('room/65667', { "room" =>  {
      "id" => 65667, "name" => "Office"
    }})
    room = Broach::Room.find(65667)
    room.id.should == 65667
  end
end