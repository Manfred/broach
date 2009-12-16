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
  
  # Send a message to a room with a certain name.
  #
  # Note that you should only use this method if you're sending just one message. It fetches
  # all rooms before sending the message to find the room with the name you're specifying.
  #
  # If you need to send multiple messages to the same room you should instantiate a room first.
  # 
  # ==== Options
  #
  # +room+
  #   The name of the room, ie. 'Office'
  # +content+
  #   The content of the message, see Broach::Room#speak for more information.
  # +options+
  #   Options for the message, see Broach::Room#speak for more information.
  #
  # ==== Examples
  #
  #   Broach.speak('Office', 'Manfred just deployed a new version of the weblog (http://www.fngtps.com)')
  #   Broach.speak('Office', 'crickets', :type => :sound)
  def self.speak(room_name, content, options={})
    if room = rooms.find { |room| room.name == room_name }
      room.speak(content, options)
    end
  end
end