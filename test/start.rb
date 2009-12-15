require 'rubygems' rescue nil
require 'test/unit'

$:.unshift(File.expand_path('../../lib', __FILE__))

require 'broach'

module BroachTestHelpers
  def settings
    @settings ||= YAML.load_file(File.expand_path('../../settings.yml', __FILE__))
  end
end

class Test::Unit::TestCase
  include BroachTestHelpers
end