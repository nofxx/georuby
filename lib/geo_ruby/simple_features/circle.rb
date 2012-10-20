module GeoRuby
  module SimpleFeatures
    #Represents a point. It is in 3D if the Z coordinate is not +nil+.
    class Circle < Geometry
      attr_accessor :radius, :center
      alias :r :radius

      def initialize(srid = DEFAULT_SRID, with_z = false, with_m = false)
        super(srid, with_z, with_m)
      end

      def bounding_box
        [Point.from_x_y(@center.x - @r, @center.y - @r),
         Point.from_x_y(@center.x + @r, @center.y + @r)]
      end

      def m_range
        raise NotImplementedError
      end

      def ==(other)
        return false unless other.is_a?(Circle)
        @center == other.center and @radius == other.radius
      end

      def to_json(options = {})
        {:type => 'Circle',
         :coordinates => @center.to_coordinates,
         :radius => @radius}.to_json(options)
      end
      alias :as_geojson :to_json

      def contains_point?(point)
        dist = Mongoid::Spacial.distance(@center.to_coordinates,
                  point.to_coordinates, :spherical => true, :unit => :m)
        dist <= @radius
      end

      class << self
        def from_x_y_r(x, y, r, srid = DEFAULT_SRID)
          circle = new(srid)
          circle.center = Point.from_x_y(x, y, srid)
          circle.radius = r
          circle
        end

        def from_coordinates(center, r, srid = DEFAULT_SRID)
          circle = new(srid)
          circle.center = Point.from_coordinates(center)
          circle.radius = r
          circle
        end
      end

    end
  end
end
