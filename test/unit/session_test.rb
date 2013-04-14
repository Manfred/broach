require File.expand_path('../../start', __FILE__)

module SessionSpecHelpers
  def session(attributes)
    Broach::Session.new(attributes)
  end
  
  def example_session
    @session ||= session('account' => 'example', 'token' => 'xxx', 'use_ssl' => true)
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

describe "A Session, concerning HTTP" do
  extend SessionSpecHelpers
  
  it "should use a JSON accept header" do
    [:get, :post].each do |method|
      example_session.headers_for(method)['Accept'].should == 'application/json'
    end
  end
  
  it "should pass the authentication token as username" do
    example_session.credentials[:username].should == 'xxx'
  end
  
  it "should use a dummy password" do
    example_session.credentials[:password].should == 'x'
  end
end

describe "A Session, when fetching resources" do
  extend SessionSpecHelpers
  
  it "should use the URL, headers, and credentials when fetching a resource" do
    REST.should.receive(:get).with(
      example_session.url_for('rooms'),
      example_session.headers_for(:get),
      example_session.credentials
    ).and_return(
      mock('Response', :ok? => true, :body => '{}')
    )
    example_session.get('rooms')
  end
  
  it "should return the parsed body when the response was OK" do
    payload = { 'room' => { 'id' => 12 } }
    REST.stub!(:get).and_return(mock('Response', :ok? => true, :body => MultiJson.dump(payload)))
    example_session.get('room/12').should == payload
  end
  
  it "should raise an authentication error when the response was a 401" do
    response = mock('Response', :ok? => false, :unauthorized? => true)
    REST.stub!(:get).and_return(response)
    begin
      example_session.get('room/12')
    rescue Broach::AuthenticationError => error
      error.response.should == response
      error.message.should == "Couldn't authenticate with the supplied credentials for the account `example'"
    end
  end
  
  it "should raise an authorization error when the response was a 403" do
    response = mock('Response', :ok? => false, :unauthorized? => false, :forbidden? => true)
    REST.stub!(:get).and_return(response)
    begin
      example_session.get('room/12')
    rescue Broach::AuthorizationError => error
      error.response.should == response
      error.message.should == "Couldn't GET the resource `room/12' on the account `example'"
    end
  end
  
  it "should raise a configuration error when the response was a 302" do
    response = mock('Response', :ok? => false, :unauthorized? => false, :forbidden? => false, :found? => true)
    REST.stub!(:get).and_return(response)
    begin
      example_session.get('room/12')
    rescue Broach::ConfigurationError => error
      error.response.should == response
      error.message.should == "Got redirected when trying to GET the resource `room/12' on the account `example'"
    end
  end
  
  it "should raise a general API error when the response was not expected" do
    response = mock('Response', :ok? => false, :unauthorized? => false, :forbidden? => false, :found? => false, :status_code => 422)
    REST.stub!(:get).and_return(response)
    begin
      example_session.get('room/12')
    rescue Broach::APIError => error
      error.response.should == response
      error.message.should == "Response from the server was unexpected (422)"
    end
  end
end

describe "A Session, when posting a resource" do
  extend SessionSpecHelpers
  
  it "should send a JSON content-type header" do
    example_session.headers_for(:post)['Content-type'].should == 'application/json'
  end
  
  it "should use the URL, headers, and credentials when fetching a resource" do
    payload = { 'message' => { 'body' => 'Heya', 'type' => 'TextMessage' } }
    REST.should.receive(:post).with(
      example_session.url_for('room/12/speak'),
      MultiJson.dump(payload),
      example_session.headers_for(:post),
      example_session.credentials
    ).and_return(
      mock('Response', :created? => true, :body => '{}')
    )
    example_session.post('room/12/speak', payload)
  end
  
  it "should return the parsed body when the response was OK" do
    payload = { 'message' => { 'id' => 12 } }
    REST.stub!(:post).and_return(mock('Response', :created? => true, :body => MultiJson.dump(payload)))
    example_session.post('room/12/speak', {}).should == payload
  end
  
  it "should raise an authentication error when the response was a 401" do
    response = mock('Response', :created? => false, :unauthorized? => true)
    REST.stub!(:post).and_return(response)
    begin
      example_session.post('room/12/speak', {})
    rescue Broach::AuthenticationError => error
      error.response.should == response
      error.message.should == "Couldn't authenticate with the supplied credentials for the account `example'"
    end
  end
  
  it "should raise an authorization error when the response was a 403" do
    response = mock('Response', :created? => false, :unauthorized? => false, :forbidden? => true)
    REST.stub!(:post).and_return(response)
    begin
      example_session.post('room/12/speak', {})
    rescue Broach::AuthorizationError => error
      error.response.should == response
      error.message.should == "Couldn't POST the resource `room/12/speak' on the account `example'"
    end
  end
  
  it "should raise a configuration error when the response was a 302" do
    response = mock('Response', :created? => false, :unauthorized? => false, :forbidden? => false, :found? => true)
    REST.stub!(:post).and_return(response)
    begin
      example_session.post('room/12/speak', {})
    rescue Broach::ConfigurationError => error
      error.response.should == response
      error.message.should == "Got redirected when trying to POST the resource `room/12/speak' on the account `example'"
    end
  end
  
  it "should raise a general API error when the response was not expected" do
    response = mock('Response', :created? => false, :unauthorized? => false, :forbidden? => false, :found? => false, :status_code => 422)
    REST.stub!(:post).and_return(response)
    begin
      example_session.post('room/12/speak', {})
    rescue Broach::APIError => error
      error.response.should == response
      error.message.should == "Response from the server was unexpected (422)"
    end
  end
end