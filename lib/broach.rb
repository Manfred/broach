begin
  require 'rubygems'
  gem 'nap', '>= 0.3'
rescue LoadError
end

require 'rest'
require 'json'

require 'broach/exceptions'

module Broach
  autoload :AttributeInitializer, 'broach/attribute_initializer'
  
  autoload :Session,              'broach/session'
end