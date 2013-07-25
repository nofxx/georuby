# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'geo_ruby/version'

Gem::Specification.new do |s|
  s.name    = "georuby"
  s.version = GeoRuby::VERSION

  s.authors = ["Guilhem Vellut", "Marcos Piccinini", "Marcus Mateus", "Doug Cole"]
  s.description = %q{GeoRuby provides geometric data types from the OGC 'Simple Features' specification.}
  s.summary = %q{Ruby data holder for OGC Simple Features}
  s.email = %q{x@nofxx.com}
  s.license = 'MIT'

  #s.extensions = ["ext/georuby/extconf.rb"]
  s.files = Dir.glob("{lib,spec}/**/*") + %w(README.md Rakefile)

  s.homepage = %q{http://github.com/nofxx/georuby}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
end
