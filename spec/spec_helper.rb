require 'rubygems'

# Must require active_spport/core_ext/object and then json/pure
# or the json module gets clobbered and geojson output
# becomes invalid... ie. it never calls class specific to_json
#require 'active_support/core_ext/object'
#require 'json/pure'

require 'rspec'

require 'geo_ruby'
require 'geo_ruby/shp'
require 'geo_ruby/gpx'
require 'geo_ruby/geojson'
require 'geo_ruby/georss'
require 'geo_ruby/kml'

if ENV["CI"]
  require 'coveralls'
  Coveralls.wear!
end

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
            expect(actual.send(c)).to be_within(0.1).of(val)
          else
            expect(actual.send(c)).to eql(val)
          end
        end
      end
      expect(actual).to be_instance_of(GeoRuby::SimpleFeatures::Point)
    end

    def failure_message;          "expected #{@expect} but received #{@actual.inspect}";    end
    def failure_message_when_negated; "expected something else then '#{@expect}' but got '#{@actual}'";    end
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
