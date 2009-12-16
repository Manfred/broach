require File.expand_path('../../start', __FILE__)

describe "User" do
  before do
    Broach.settings = settings
  end
  
  it "should fetch herself" do
    me = Broach::User.me
    me.name.should.not == ''
  end
  
  it "should fetch a specific user" do
    if user_to_fetch = Broach::User.me
      user = Broach::User.find(user_to_fetch.id)
      user.id.should == user_to_fetch.id
      user.name.should.not == ''
    end
  end
end