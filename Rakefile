require 'bundler'
Bundler.setup

require "rspec"
require "rspec/core/rake_task"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "geo_ruby/version"

desc "Builds the gem"
task :gem => :build
task :build do
  system "gem build georuby.gemspec"
  Dir.mkdir("pkg") unless Dir.exists?("pkg")
  system "mv georuby-#{GeoRuby::VERSION}.gem pkg/"
end

task :install => :build do
  system "sudo gem install pkg/georuby-#{GeoRuby::VERSION}.gem"
end

task :release => :build do
  system "git tag -a v#{GeoRuby::VERSION} -m 'Tagging #{GeoRuby::VERSION}'"
  system "git push --tags"
  system "gem push pkg/georuby-#{GeoRuby::VERSION}.gem"
end

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

task :default => [:spec]

