require 'rubygems' rescue nil
require 'rest'
require 'json'

require 'broach/exceptions'

# === Settings
#
# Before you can do anything else you will need to provide credentials first, this includes the account name and
# authentication token. The +use_ssl+ parameter is optional and defaults to false.
#
#   Broach.settings = { 'account' => 'example', 'token' => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'use_ssl' => true }
#
# You can find the token for any Campfire account by logging into the web interface and clicking 'My Info' in the top-right
# corner.
#
# === Say someting in a room real quick
#
# If you just need to say something real quick in a room, you can use the speak class method.
#
#  Broach.speak("Office", "Manfred just deployed a new version of the weblog (http://www.fngtps.com)")
#
# Note that this fetches a list of all rooms so it can figure out the ID for the room you specified.
#
# === Post a lot of stuff to a room
#
# If you want to post multiple lines to one room, it's a good idea to create a Room instance.
#
#   room = Broach::Room.find_by_name('Office')
#   room.speak('Manfred just commited to the `weblog' repository')
#   room.speak("commit 4578530113cb87e1e7dbd696c376181e97d429d7\n" +
#     "Author: Manfred Stienstra <manfred@fngtps.com>\n" +
#     "Date:   Wed Dec 16 14:03:33 2009 +0100\n\n" +
#     "  Add a speak method to Broach to quickly say something in a room.", :type => :paste)
module Broach
  autoload :Attributes, 'broach/attributes'
  autoload :Session,    'broach/session'
  autoload :User,       'broach/user'
  autoload :Room,       'broach/room'
  
  # Returns the current Broach settings
  def self.settings
    @settings
  end
  
  # Sets the broach settings
  def self.settings=(settings)
    @settings = settings
    @session  = nil
  end
  
  # Returns a session object with the current settings
  def self.session
    @session ||= Broach::Session.new(settings)
  end
  
  # Returns a User instance for the currently authenticated user
  def self.me
    Broach::User.me
  end
  
  # Returns a Room instance for all rooms accesible to the currently authenticated user
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