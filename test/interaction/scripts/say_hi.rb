require 'rubygems'
require 'active_support'
require 'yaml'
require 'rest'

$:.unshift File.expand_path('../../../../lib', __FILE__)
require 'broach'

Broach.settings = YAML.load_file(File.expand_path('../../../../settings.yml', __FILE__))
Broach.speak(Broach.session.room, "Hi!")