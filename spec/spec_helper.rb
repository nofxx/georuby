begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'geo_ruby'
require 'geo_ruby/shp'
require 'geo_ruby/gpx'

include GeoRuby
include SimpleFeatures
