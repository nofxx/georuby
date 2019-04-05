require 'geo_ruby/simple_features/line_string'

module GeoRuby
  module SimpleFeatures
    # Represents a linear ring, which is a closed line string (see LineString).
    # Currently, no check is performed to verify if the linear ring is really closed.
    class LinearRing < LineString
      def initialize(srid = DEFAULT_SRID, with_z = false, with_m = false)
        super(srid, with_z, with_m)
      end

      # fix kml export
      alias_method :orig_kml_representation, :kml_representation
      def kml_representation(options = {})
        orig_kml_representation(options).gsub('LineString', 'LinearRing')
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
            valid_point?(a, b) &&
            (b.y > y != a.y > y) && (x < (a.x - b.x) * (y - b.y) / (a.y - b.y) + b.x)
          end

        crossings.size % 2 == 1
      end

      private

      def valid_point?(x_coodinate, y_coordinate)
        x_coodinate.x.present? && x_coodinate.y.present? &&
        y_coordinate.x.present? && y_coordinate.y.present?
      end
    end
  end
end
