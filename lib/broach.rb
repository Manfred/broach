begin
  require 'rubygems'
  gem 'nap', '>= 0.3'
rescue LoadError
end

require 'rest'
require 'json'

require 'broach/exceptions'

module Broach
  autoload :Attributes, 'broach/attributes'
  autoload :Session,    'broach/session'
  autoload :User,       'broach/user'
  autoload :Room,       'broach/room'
  
  def self.settings
    @settings
  end
  
  def self.settings=(settings)
    @settings = settings
    @session  = nil
  end
  
  def self.session
    @session ||= Broach::Session.new(settings)
  end
  
  def self.me
    Broach::User.me
  end
  
  def self.rooms
    Broach::Room.all
  end
end