# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'geo_ruby/version'

Gem::Specification.new do |s|
  s.name = %q{georuby}
  s.version = GeoRuby::VERSION

  s.authors = ["Guilhem Vellut", "Marcos Piccinini", "Marcus Mateus", "Doug Cole"]
  s.description = %q{GeoRuby provides geometric data types from the OGC 'Simple Features' specification.}
  s.summary = %q{Ruby data holder for OGC Simple Features}
  s.email = %q{x@nofxx.com}

  #s.extensions = ["ext/georuby/extconf.rb"]
  s.files = Dir.glob("{lib,spec}/**/*") + %w(README.rdoc Rakefile)

  s.homepage = %q{http://github.com/nofxx/georuby}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}

  s.add_runtime_dependency(%q<redis>, [">= 0"])
  s.add_runtime_dependency(%q<serialport>, [">= 0"])
  s.add_runtime_dependency(%q<eventmachine>, [">= 0"])
  s.add_development_dependency(%q<dbf>, [">= 1.2.9"])
  s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
end

