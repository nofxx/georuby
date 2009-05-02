$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'geo_ruby/base/helper'
require 'geo_ruby/base/ewkt_parser'
require 'geo_ruby/base/ewkb_parser'
require 'geo_ruby/base/geometry'
require 'geo_ruby/base/point'
require 'geo_ruby/base/line_string'
require 'geo_ruby/base/linear_ring'
require 'geo_ruby/base/polygon'
require 'geo_ruby/base/multi_point'
require 'geo_ruby/base/multi_line_string'
require 'geo_ruby/base/multi_polygon'
require 'geo_ruby/base/geometry_collection'
require 'geo_ruby/base/envelope'
require 'geo_ruby/base/geometry_factory'
require 'geo_ruby/base/georss_parser'
require 'geo_ruby/shp4r/shp'

GeoRuby::SimpleFeatures = GeoRuby::Base
