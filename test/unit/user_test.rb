require File.expand_path('../../start', __FILE__)

describe "User" do
  it "should initialize with attributes fetched from the server" do
    attributes = { "name" => "Manfred Stienstra", "created_at" => "2006/03/12 17:16:22 +0000", "admin" => true, "id" => 31210, "email_address"=>"manfred@fngtps.com" }
    user       = Broach::User.new(attributes)
    
    attributes.each do |key, value|
      user.send(key).should == value
    end
  end
  
  it "should find a user with a certain ID from the server" do
    mock_response('users/65667', { "user" =>  {
      "id" => 65667, "name" => "Office"
    }})
    user = Broach::User.find(65667)
    user.id.should == 65667
  end
end