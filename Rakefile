require 'rake/rdoctask'

TEST_CATEGORIES = [:remote, :interaction, :unit]

desc "Run all unit specs by default"
task :default => 'test:unit'

namespace :test do
  TEST_CATEGORIES.each do |category|
    desc "Run all #{category} tests"
    task category do
      Dir[File.dirname(__FILE__) + "/test/#{category}/*_test.rb"].each do |file|
        load file
      end
    end
  end
end

desc "Run all specs"
task :test => TEST_CATEGORIES.map { |category| "test:#{category}" }

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