require 'geo_ruby/simple_features/line_string'

module GeoRuby
  module SimpleFeatures
    #Represents a linear ring, which is a closed line string (see LineString). Currently, no check is performed to verify if the linear ring is really closed.
    class LinearRing < LineString
      def initialize(srid= DEFAULT_SRID,with_z=false,with_m=false)
        super(srid,with_z,with_m)
      end
    end

    # Does this linear string contain the given point?  We use the
    # algorithm described here:
    #
    # http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
    def contains_point?(point)
      x, y = point.x, point.y
      tuples = @points.zip(@points[1..-1] + [@points[0]])
      crossings =
        tuples.select do |a, b|
          (b.y > y != a.y > y) && (x < (a.x - b.x) * (y - b.y) / (a.y - b.y) + b.x)
        end

      crossings.size % 2 == 1
    end
  end
end
