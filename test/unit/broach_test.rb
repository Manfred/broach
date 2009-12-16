require File.expand_path('../../start', __FILE__)

module BroachSpecHelpers
  def attributes
    { "account" => "example", "token" => "xxx", "use_ssl" => true }
  end
end

describe "Broach" do
  extend BroachSpecHelpers
  
  it "should set and return settings" do
    Broach.settings = attributes
    Broach.settings.should == attributes
  end
  
  it "should use the settings to create a new session" do
    Broach.settings = attributes
    session = Broach.session
    
    attributes.each do |key, value|
      session.send(key).should == value
    end
  end
  
  it "should make sure the session has new settings when the settings change" do
    Broach.settings = attributes
    Broach.session
    
    other_attributes = attributes
    other_attributes['account'] = 'other_example'
    Broach.settings = other_attributes
    session = Broach.session
    
    other_attributes.each do |key, value|
      session.send(key).should == value
    end
  end
end

describe "Broach, concerning the API" do
  it "should return the user associated with the authentication token" do
    Broach::User.should.receive(:me)
    Broach.me
  end
  
  it "should return all rooms for the account" do
    Broach::Room.should.receive(:all)
    Broach.rooms
  end
  
  it "should speak to a named room" do
    office_room   = mock('Room', :name => 'Office')
    business_room = mock('Room', :name => 'Business')
    Broach.stub!(:rooms).and_return([office_room, business_room])
    
    office_room.should.receive(:speak).with('Codes!', :type => :paste)
    
    Broach.speak('Office', 'Codes!', :type => :paste)
  end
end