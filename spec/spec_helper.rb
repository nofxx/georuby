begin
  require 'rubygems'
  require 'spec'
rescue LoadError
  require 'rspec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'geo_ruby'
require 'geo_ruby/shp'
require 'geo_ruby/gpx'

include GeoRuby
include SimpleFeatures

module GeorubyMatchers

  class BeGeometric

    def matches?(actual)
      actual.ancestors.include?(actual) || actual.kind_of?("Geometry")
    end

    def failure_message;          "expected #{@actual.inspect} to be some geom";    end
  end

  class BeAPoint
    include RSpec::Matchers

    def initialize(expect=nil)
      @expect = expect
    end

    def matches?(actual)
      if @expect
        [:x, :y, :z, :m].each_with_index do |c, i|
          next unless val = @expect[i]
          if val.kind_of? Numeric
            actual.send(c).should be_close(val, 0.1)
          else
            actual.send(c).should eql(val)
          end
        end
      end
      actual.should be_instance_of(Point)
    end

    def failure_message;          "expected #{@expect} but received #{@actual.inspect}";    end
    def negative_failure_message; "expected something else then '#{@expect}' but got '#{@actual}'";    end
  end

  def be_a_point(*args)
    args.empty? ? BeAPoint.new : BeAPoint.new(args)
  end

  def be_geometric
    BeGeometric.new
  end
end

RSpec.configure do |config|
  config.include GeorubyMatchers
end

