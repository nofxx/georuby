# -*- coding: utf-8 -*-
require 'geo_ruby/simple_features/geometry'

module GeoRuby
  module SimpleFeatures
    # Represents a point. It is in 3D if the Z coordinate is not +nil+.
    class Point < Geometry
      DEG2RAD = 0.0174532925199433
      HALFPI  = 1.5707963267948966
      attr_accessor :x, :y, :z, :m
      attr_reader :r, :t # radium and theta

      # If you prefer calling the coordinates lat and lon
      # (or lng, for GeoKit compatibility)
      alias_method :lon, :x
      alias_method :lng, :x
      alias_method :lat, :y
      alias_method :rad, :r
      alias_method :tet, :t
      alias_method :tetha, :t

      def initialize(srid = DEFAULT_SRID, with_z = false, with_m = false)
        super(srid, with_z, with_m)
        @x = @y = 0.0
        @z = 0.0 # default value : meaningful if with_z
        @m = 0.0 # default value : meaningful if with_m
      end

      # Sets all coordinates in one call.
      # Use the +m+ accessor to set the m.
      def set_x_y_z(x, y, z)
        @x = x && !x.is_a?(Numeric) ? x.to_f : x
        @y = y && !y.is_a?(Numeric) ? y.to_f : y
        @z = z && !z.is_a?(Numeric) ? z.to_f : z
        self
      end
      alias_method :set_lon_lat_z, :set_x_y_z

      # Sets all coordinates of a 2D point in one call
      def set_x_y(x, y)
        @x = x && !x.is_a?(Numeric) ? x.to_f : x
        @y = y && !y.is_a?(Numeric) ? y.to_f : y
        self
      end
      alias_method :set_lon_lat, :set_x_y

      # Return the distance between the 2D points (ie taking care only
      # of the x and y coordinates), assuming the points are in
      # projected coordinates.
      #
      # Euclidian distance in whatever unit the x and y ordinates are.
      def euclidian_distance(point)
        Math.sqrt((point.x - x)**2 + (point.y - y)**2)
      end

      # Spherical distance in meters, using 'Haversine' formula.
      # with a radius of 6471000m
      # Assumes x is the lon and y the lat, in degrees.
      # The user has to make sure using this distance makes sense
      # (ie she should be in latlon coordinates)
      def spherical_distance(point, r = 6_370_997.0)
        dlat = (point.lat - lat) * DEG2RAD / 2
        dlon = (point.lon - lon) * DEG2RAD / 2

        a = Math.sin(dlat)**2 + Math.cos(lat * DEG2RAD) *
            Math.cos(point.lat * DEG2RAD) * Math.sin(dlon)**2
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
        r * c
      end

      #
      # Ellipsoidal distance in m using Vincenty's formula.
      # Lifted entirely from Chris Veness's code at
      # http://www.movable-type.co.uk/scripts/LatLongVincenty.html
      # and adapted for Ruby.
      #
      # Assumes the x and y are the lon and lat in degrees.
      # a is the semi-major axis (equatorial radius) of the ellipsoid
      # b is the semi-minor axis (polar radius) of the ellipsoid
      # Their values by default are set to the WGS84 ellipsoid.
      #
      def ellipsoidal_distance(point, a = 6_378_137.0, b = 6_356_752.3142)
        f = (a - b) / a
        l = (point.lon - lon) * DEG2RAD

        u1 = Math.atan((1 - f) * Math.tan(lat * DEG2RAD))
        u2 = Math.atan((1 - f) * Math.tan(point.lat * DEG2RAD))
        sin_u1 = Math.sin(u1)
        cos_u1 = Math.cos(u1)
        sin_u2 = Math.sin(u2)
        cos_u2 = Math.cos(u2)

        lambda = l
        lambda_p = 2 * Math::PI
        iter_limit = 20

        while (lambda - lambda_p).abs > 1e-12 && --iter_limit > 0
          sin_lambda = Math.sin(lambda)
          cos_lambda = Math.cos(lambda)
          sin_sigma = \
          Math.sqrt((cos_u2 * sin_lambda) * (cos_u2 * sin_lambda) +
                    (cos_u1 * sin_u2 - sin_u1 * cos_u2 * cos_lambda) *
                    (cos_u1 * sin_u2 - sin_u1 * cos_u2 * cos_lambda))

          return 0 if sin_sigma == 0 # coincident points

          cos_sigma   = sin_u1 * sin_u2 + cos_u1 * cos_u2 * cos_lambda
          sigma      = Math.atan2(sin_sigma, cos_sigma)
          sin_alpha   = cos_u1 * cos_u2 * sin_lambda / sin_sigma
          cos_sq_alpha = 1 - sin_alpha * sin_alpha
          cos2_sigma_m = cos_sigma - 2 * sin_u1 * sin_u2 / cos_sq_alpha

          # equatorial line: cos_sq_alpha=0
          cos2_sigma_m = 0 if cos2_sigma_m.nan?

          c = f / 16 * cos_sq_alpha * (4 + f * (4 - 3 * cos_sq_alpha))
          lambda_p = lambda
          lambda = l + (1 - c) * f * sin_alpha * (sigma + c * sin_sigma *
            (cos2_sigma_m + c * cos_sigma * (-1 + 2 * cos2_sigma_m *
                cos2_sigma_m)))
        end

        return NaN if iter_limit == 0 # formula failed to converge

        usq = cos_sq_alpha * (a * a - b * b) / (b * b)
        a_bis = 1 + usq / 16_384 * (4096 + usq * (-768 + usq * (320 - 175 * usq)))
        b_bis = usq / 1024 * (256 + usq * (-128 + usq * (74 - 47 * usq)))
        delta_sigma = b_bis * sin_sigma * (cos2_sigma_m + b_bis / 4 *
          (cos_sigma * (-1 + 2 * cos2_sigma_m * cos2_sigma_m) - b_bis / 6 *
            cos2_sigma_m * (-3 + 4 * sin_sigma * sin_sigma) * (-3 + 4 *
              cos2_sigma_m * cos2_sigma_m)))

        b * a_bis * (sigma - delta_sigma)
      end

      # Orthogonal Distance
      # Based http://www.allegro.cc/forums/thread/589720
      def orthogonal_distance(line, tail = nil)
        head, tail  = tail ?  [line, tail] : [line[0], line[-1]]
        a, b = @x - head.x, @y - head.y
        c, d = tail.x - head.x, tail.y - head.y

        dot = a * c + b * d
        len = c * c + d * d
        return 0.0 if len.zero?
        res = dot / len

        xx, yy = \
        if res < 0
          [head.x, head.y]
        elsif res > 1
          [tail.x, tail.y]
        else
          [head.x + res * c, head.y + res * d]
        end
        # TODO: benchmark if worth creating an instance
        # euclidian_distance(Point.from_x_y(xx, yy))
        Math.sqrt((@x - xx)**2 + (@y - yy)**2)
      end

      # Bearing from a point to another, in degrees.
      def bearing_to(other)
        return 0 if self == other
        a, b =  other.x - x, other.y - y
        res =  Math.acos(b / Math.sqrt(a * a + b * b)) / Math::PI * 180
        a < 0 ? 360 - res : res
      end

      # Bearing from a point to another as symbols. (:n, :s, :sw, :ne...)
      def bearing_text(other)
        case bearing_to(other)
        when 1..22    then :n
        when 23..66   then :ne
        when 67..112  then :e
        when 113..146 then :se
        when 147..202 then :s
        when 203..246 then :sw
        when 247..292 then :w
        when 293..336 then :nw
        when 337..360 then :n
        else nil
        end
      end

      # Bounding box in 2D/3D. Returns an array of 2 points
      def bounding_box
        if with_z
          [Point.from_x_y_z(@x, @y, @z), Point.from_x_y_z(@x, @y, @z)]
        else
          [Point.from_x_y(@x, @y), Point.from_x_y(@x, @y)]
        end
      end

      def m_range
        [@m, @m]
      end

      # Tests the equality of the position of points + m
      def ==(other)
        return false unless other.is_a?(Point)
        @x == other.x && @y == other.y && @z == other.z && @m == other.m
      end

      # Binary representation of a point.
      # It lacks some headers to be a valid EWKB representation.
      def binary_representation(allow_z = true, allow_m = true) #:nodoc:
        bin_rep = [@x.to_f, @y.to_f].pack('EE')
        bin_rep += [@z.to_f].pack('E') if @with_z && allow_z # Default value so no crash
        bin_rep += [@m.to_f].pack('E') if @with_m && allow_m # idem
        bin_rep
      end

      # WKB geometry type of a point
      def binary_geometry_type #:nodoc:
        1
      end

      # Text representation of a point
      def text_representation(allow_z = true, allow_m = true) #:nodoc:
        tex_rep = "#{@x} #{@y}"
        tex_rep += " #{@z}" if @with_z && allow_z
        tex_rep += " #{@m}" if @with_m && allow_m
        tex_rep
      end

      # WKT geometry type of a point
      def text_geometry_type #:nodoc:
        'POINT'
      end

      # georss simple representation
      def georss_simple_representation(options) #:nodoc:
        georss_ns = options[:georss_ns] || 'georss'
        geom_attr = options[:geom_attr]
        "<#{georss_ns}:point#{geom_attr}>#{y} #{x}</#{georss_ns}:point>\n"
      end

      # georss w3c representation
      def georss_w3cgeo_representation(options) #:nodoc:
        w3cgeo_ns = options[:w3cgeo_ns] || 'geo'
        "<#{w3cgeo_ns}:lat>#{y}</#{w3cgeo_ns}:lat>\n<#{w3cgeo_ns}:long>#{x}</#{w3cgeo_ns}:long>\n"
      end

      # georss gml representation
      def georss_gml_representation(options) #:nodoc:
        georss_ns = options[:georss_ns] || 'georss'
        gml_ns = options[:gml_ns] || 'gml'
        "<#{georss_ns}:where>\n<#{gml_ns}:Point>\n<#{gml_ns}:pos>#{y} #{x}" \
        "</#{gml_ns}:pos>\n</#{gml_ns}:Point>\n</#{georss_ns}:where>\n"
      end

      # outputs the geometry in kml format : options are
      # <tt>:id</tt>, <tt>:tesselate</tt>, <tt>:extrude</tt>,
      # <tt>:altitude_mode</tt>.
      # If the altitude_mode option is not present, the Z (if present)
      # will not be output (since it won't be used by GE anyway:
      # clampToGround is the default)
      def kml_representation(options = {}) #:nodoc:
        out = "<Point#{options[:id_attr]}>\n"
        out += options[:geom_data] if options[:geom_data]
        out += "<coordinates>#{x},#{y}"
        out += ",#{options[:fixed_z] || z || 0}" if options[:allow_z]
        out += "</coordinates>\n"
        out + "</Point>\n"
      end

      def html_representation(options = {})
        options[:coord] = true if options[:coord].nil?
        out =  '<span class=\'geo\'>'
        out += "<abbr class='latitude' title='#{x}'>#{as_lat(options)}</abbr>"
        out += "<abbr class='longitude' title='#{y}'>#{as_long(options)}</abbr>"
        out + '</span>'
      end

      # Human representation of the geom, don't use directly, use:
      # #as_lat, #as_long, #as_latlong
      def human_representation(options = {}, g = { x: x, y: y })
        g.map do |k, v|
          deg = v.to_i.abs
          min = (60 * (v.abs - deg)).to_i
          labs = (v * 1_000_000).abs / 1_000_000
          sec = ((((labs - labs.to_i) * 60) -
              ((labs - labs.to_i) * 60).to_i) * 100_000) * 60 / 100_000
          str = options[:full] ? '%.i°%.2i′%05.2f″' :  '%.i°%.2i′%02.0f″'
          if options[:coord]
            out = format(str, deg, min, sec)
            # Add cardinal
            out + (k == :x ? v > 0 ? 'N' : 'S' : v > 0 ? 'E' : 'W')
          else
            format(str, v.to_i, min, sec)
          end
        end
      end

      # Outputs the geometry coordinate in human format:
      # 47°52′48″N
      def as_lat(options = {})
        human_representation(options, x: x).join
      end

      # Outputs the geometry coordinate in human format:
      # -20°06′00W″
      def as_long(options = {})
        human_representation(options, y: y).join
      end
      alias_method :as_lng, :as_long

      # Outputs the geometry in coordinates format:
      # 47°52′48″, -20°06′00″
      def as_latlong(options = {})
        human_representation(options).join(', ')
      end
      alias_method :as_ll, :as_latlong

      # Polar stuff
      #
      # http://www.engineeringtoolbox.com/converting-cartesian-polar-coordinates-d_1347.html
      # http://rcoordinate.rubyforge.org/svn/point.rb
      # outputs radium
      def r
        Math.sqrt(@x**2 + @y**2)
      end

      # Outputs theta
      def theta_rad
        if @x.zero?
          @y < 0 ? 3 * HALFPI : HALFPI
        else
          th = Math.atan(@y / @x)
          r > 0 ? th + 2 * Math::PI : th
        end
      end

      # Outputs theta in degrees
      def theta_deg
        theta_rad / DEG2RAD
      end

      # Outputs an array containing polar distance and theta
      def as_polar
        [r, t]
      end

      # Outputs the point in json format
      def as_json(_options = {})
        { type: 'Point', coordinates: to_coordinates }
      end

      # Invert signal of all coordinates
      def -@
        set_x_y_z(-@x, -@y, -@z)
      end

      # Helper to get all coordinates as array.
      def to_coordinates
        coord = [x, y]
        coord << z if with_z
        coord << m if with_m
        coord
      end

      # Simple helper for 2D maps
      def to_xy
        [x, y]
      end

      # Simple helper for 3D maps
      def to_xyz
        [x, y, z]
      end

      # Creates a point from an array of coordinates
      def self.from_coordinates(coords, srid = DEFAULT_SRID, z = false, m = false)
        if !(z || m)
          from_x_y(coords[0], coords[1], srid)
        elsif z && m
          from_x_y_z_m(coords[0], coords[1], coords[2], coords[3], srid)
        elsif z
          from_x_y_z(coords[0], coords[1], coords[2], srid)
        else
          from_x_y_m(coords[0], coords[1], coords[2], srid)
        end
      end

      # Creates a point from the X and Y coordinates
      def self.from_x_y(x, y, srid = DEFAULT_SRID)
        point = new(srid)
        point.set_x_y(x, y)
      end

      # Creates a point from the X, Y and Z coordinates
      def self.from_x_y_z(x, y, z, srid = DEFAULT_SRID)
        point = new(srid, true)
        point.set_x_y_z(x, y, z)
      end

      # Creates a point from the X, Y and M coordinates
      def self.from_x_y_m(x, y, m, srid = DEFAULT_SRID)
        point = new(srid, false, true)
        point.m = m
        point.set_x_y(x, y)
      end

      # Creates a point from the X, Y, Z and M coordinates
      def self.from_x_y_z_m(x, y, z, m, srid = DEFAULT_SRID)
        point = new(srid, true, true)
        point.m = m
        point.set_x_y_z(x, y, z)
      end

      # Creates a point using polar coordinates
      # r and theta(degrees)
      def self.from_r_t(r, t, srid = DEFAULT_SRID)
        t *= DEG2RAD
        x = r * Math.cos(t)
        y = r * Math.sin(t)
        point = new(srid)
        point.set_x_y(x, y)
      end

      # Creates a point using coordinates like 22`34 23.45N
      def self.from_latlong(lat, lon, srid = DEFAULT_SRID)
        p = [lat, lon].map do |l|
          sig, deg, min, sec, cen = \
          l.scan(/(-)?(\d{1,2})\D*(\d{2})\D*(\d{2})(\D*(\d{1,3}))?/).flatten
          sig = true if l =~ /W|S/
          dec = deg.to_i + (min.to_i * 60 + "#{sec}#{cen}".to_f) / 3600
          sig ? dec * -1 : dec
        end
        point = new(srid)
        point.set_x_y(p[0], p[1])
      end

      # Aliasing the constructors in case you like lat/lon over y/x
      class << self
        alias_method :xy,               :from_x_y
        alias_method :from_xy,          :from_x_y
        alias_method :xyz,              :from_x_y_z
        alias_method :from_xyz,         :from_x_y_z
        alias_method :from_lon_lat_z,   :from_x_y_z
        alias_method :from_lon_lat,     :from_x_y
        alias_method :from_lon_lat_z,   :from_x_y_z
        alias_method :from_lon_lat_m,   :from_x_y_m
        alias_method :from_lon_lat_z_m, :from_x_y_z_m
        alias_method :from_rad_tet,     :from_r_t
      end
    end # Point
  end # SimpleFeatures
end # GeoRuby
