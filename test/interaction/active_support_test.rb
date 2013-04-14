require File.expand_path('../../start', __FILE__)

require 'open3'
require 'rbconfig'

unless defined?(RbConfig)
  RbConfig = Config
end

module InteractionSpecHelpers
  def ruby(script)
    ruby_bin = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
    stdin, stdout, stderr = Open3.popen3("#{ruby_bin} #{script}")
    stderr.read
  end
end

describe "Broach, when ActiveSupport is loaded" do
  extend InteractionSpecHelpers
  
  it "should say hi in a room" do
    ruby(File.expand_path('../scripts/say_hi.rb', __FILE__)).should == ''
  end
end