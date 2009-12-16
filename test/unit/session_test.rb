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
end