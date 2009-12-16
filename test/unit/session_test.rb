require File.expand_path('../../start', __FILE__)

module SessionSpecHelpers
  def session(attributes)
    Broach::Session.new(attributes)
  end
end

describe "Session" do
  it "should initialize with settings" do
    attributes = { "account" => "example", "token" => "xxx", "use_ssl" => true }
    session = Broach::Session.new(attributes)
    
    attributes.each do |key, value|
      session.send(key).should == value
    end
  end
end

describe "A Session" do
  extend SessionSpecHelpers
  
  it "should have a boolean accessor whether to use SSL" do
    session('use_ssl' => true).use_ssl?.should == true
    session('use_ssl' => false).use_ssl?.should == false
  end
  
  it "should know which HTTP scheme to use based on the SSL setting" do
    session('use_ssl' => true).scheme.should == 'https'
    session('use_ssl' => false).scheme.should == 'http'
  end
  
  it "should know the URL for a certain resource" do
    session = session('account' => 'example', 'token' => 'xxx', 'use_ssl' => true)
    session.url_for('rooms').should == 'https://example.campfirenow.com/rooms'
    session.url_for('room/12').should == 'https://example.campfirenow.com/room/12'
  end
end

describe "A Session, when fetching resources" do
  extend SessionSpecHelpers
  
  before do
    @session = session('account' => 'example', 'token' => 'xxx', 'use_ssl' => true)
  end
  
  it "should use a JSON accept header" do
    @session.headers['Accept'].should == 'application/json'
  end
  
  it "should pass the authentication token as username" do
    @session.credentials[:username].should == 'xxx'
  end
  
  it "should use a dummy password" do
    @session.credentials[:password].should == 'x'
  end
  
  it "should use the URL, headers, and credentials when fetching a resource" do
    REST.should.receive(:get).with(
      @session.url_for('rooms'),
      @session.headers,
      @session.credentials
    ).and_return(
      mock('Response', :ok? => true, :body => '{}')
    )
    @session.fetch('rooms')
  end
  
  it "should return the parsed body when the response was OK" do
    payload = { 'room' => { 'id' => 12 } }
    REST.stub!(:get).and_return(mock('Response', :ok? => true, :body => JSON.dump(payload)))
    @session.fetch('room/12').should == payload
  end
  
  it "should raise an authentication error when the response was a 401" do
    response = mock('Response', :ok? => false, :unauthorized? => true)
    REST.stub!(:get).and_return(response)
    begin
      @session.fetch('room/12')
    rescue Broach::AuthenticationError => error
      error.response.should == response
      error.message.should == "Couldn't authenticate with the supplied credentials for the account `example'"
    end
  end
  
  it "should raise an authorization error when the response was a 403" do
    response = mock('Response', :ok? => false, :unauthorized? => false, :forbidden? => true)
    REST.stub!(:get).and_return(response)
    begin
      @session.fetch('room/12')
    rescue Broach::AuthorizationError => error
      error.response.should == response
      error.message.should == "Couldn't fetch the resource `room/12' on the account `example'"
    end
  end
  
  it "should raise a general API error when the response was not expected" do
    response = mock('Response', :ok? => false, :unauthorized? => false, :forbidden? => false, :status_code => 422)
    REST.stub!(:get).and_return(response)
    begin
      @session.fetch('room/12')
    rescue Broach::APIError => error
      error.response.should == response
      error.message.should == "Response from the server was unexpected (422)"
    end
  end
end