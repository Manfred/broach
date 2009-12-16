require File.expand_path('../../start', __FILE__)

describe "Broach" do
  before do
    Broach.settings = settings
  end
  
  it "should speak to a named room" do
    body = 'Should speak to a named room'
    message = Broach.speak(Broach.session.room, body)
    message['body'].should == body
  end
end