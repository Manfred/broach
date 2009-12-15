begin
  require 'rubygems'
  gem 'nap', '>= 0.3'
rescue LoadError
end

require 'rest'
require 'json'

module Broach
  autoload :Session, 'broach/session'
end