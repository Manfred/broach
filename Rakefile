require 'rake/rdoctask'

desc "Run all specs by default"
task :default => 'test:unit'

namespace :test do
  desc "Run all remote tests"
  task :remote do
    Dir[File.dirname(__FILE__) + '/test/remote/*_test.rb'].each do |file|
      load file
    end
  end
  
  desc "Run all unit tests"
  task :unit do
    Dir[File.dirname(__FILE__) + '/test/unit/*_test.rb'].each do |file|
      load file
    end
  end
end

desc "Run all specs"
task :test => ['test:unit', 'test:remote']

namespace :gem do
  desc "Build the gem"
  task :build do
    sh 'gem build broach.gemspec'
  end
  
  task :install => :build do
    sh 'sudo gem install broach-*.gem'
  end
end

namespace :documentation do
  Rake::RDocTask.new(:generate) do |rd|
    rd.main = "lib/broach.rb"
    rd.rdoc_files.include("lib/**/*.rb")
    rd.options << "--all" << "--charset" << "utf-8"
  end
end