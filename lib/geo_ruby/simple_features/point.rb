# -*- coding: utf-8 -*-
require "geo_ruby/simple_features/geometry"

module GeoRuby
  module SimpleFeatures
    #Represents a point. It is in 3D if the Z coordinate is not +nil+.
    class Point < Geometry
      DEG2RAD = 0.0174532925199433
      HALFPI  = 1.5707963267948966
      attr_accessor :x,:y,:z,:m
      attr_reader :r, :t # radium and theta

      #if you prefer calling the coordinates lat and lon (or lng, for GeoKit compatibility)
      alias :lon :x
      alias :lng :x
      alias :lat :y
      alias :rad :r
      alias :tet :t
      alias :tetha :t

      def initialize(srid=DEFAULT_SRID,with_z=false,with_m=false)
        super(srid,with_z,with_m)
        @x = @y = 0.0
        @z=0.0 #default value : meaningful if with_z
        @m=0.0 #default value : meaningful if with_m
      end
      #sets all coordinates in one call. Use the +m+ accessor to set the m.
      def set_x_y_z(x,y,z)
        @x=x
        @y=y
        @z=z
        self
      end
      alias :set_lon_lat_z :set_x_y_z

      #sets all coordinates of a 2D point in one call
      def set_x_y(x,y)
        @x=x
        @y=y
        self
      end
      alias :set_lon_lat :set_x_y

      #Return the distance between the 2D points (ie taking care only of the x and y coordinates), assuming
      #the points are in projected coordinates. Euclidian distance in whatever unit the x and y ordinates are.
      def euclidian_distance(point)
        Math.sqrt((point.x - x)**2 + (point.y - y)**2)
      end

      # Spherical distance in meters, using 'Haversine' formula.
      # with a radius of 6471000m
      # Assumes x is the lon and y the lat, in degrees (Changed in version 1.1).
      # The user has to make sure using this distance makes sense (ie she should be in latlon coordinates)
      def spherical_distance(point,r=6370997.0)
        dlat = (point.lat - lat) * DEG2RAD / 2
        dlon = (point.lon - lon) * DEG2RAD / 2

        a = Math.sin(dlat)**2 + Math.cos(lat * DEG2RAD) * Math.cos(point.lat * DEG2RAD) * Math.sin(dlon)**2
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
        r * c
      end

      #Ellipsoidal distance in m using Vincenty's formula. Lifted entirely from Chris Veness's code at http://www.movable-type.co.uk/scripts/LatLongVincenty.html and adapted for Ruby. Assumes the x and y are the lon and lat in degrees.
      #a is the semi-major axis (equatorial radius) of the ellipsoid
      #b is the semi-minor axis (polar radius) of the ellipsoid
      #Their values by default are set to the ones of the WGS84 ellipsoid
      def ellipsoidal_distance(point, a = 6378137.0, b = 6356752.3142)
        f = (a-b) / a
        l = (point.lon - lon) * DEG2RAD

        u1 = Math.atan((1-f) * Math.tan(lat * DEG2RAD ))
        u2 = Math.atan((1-f) * Math.tan(point.lat * DEG2RAD))
        sinU1 = Math.sin(u1)
        cosU1 = Math.cos(u1)
        sinU2 = Math.sin(u2)
        cosU2 = Math.cos(u2)

        lambda = l
        lambdaP = 2 * Math::PI
        iterLimit = 20

        while (lambda-lambdaP).abs > 1e-12 && --iterLimit>0
          sinLambda = Math.sin(lambda)
          cosLambda = Math.cos(lambda)
          sinSigma = Math.sqrt((cosU2*sinLambda) * (cosU2*sinLambda) + (cosU1*sinU2-sinU1*cosU2*cosLambda) * (cosU1*sinU2-sinU1*cosU2*cosLambda))

          return 0 if sinSigma == 0 #coincident points

          cosSigma = sinU1*sinU2 + cosU1*cosU2*cosLambda
          sigma = Math.atan2(sinSigma, cosSigma)
          sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma
          cosSqAlpha = 1 - sinAlpha*sinAlpha
          cos2SigmaM = cosSigma - 2*sinU1*sinU2/cosSqAlpha

          cos2SigmaM = 0 if (cos2SigmaM.nan?) #equatorial line: cosSqAlpha=0

          c = f/16*cosSqAlpha*(4+f*(4-3*cosSqAlpha))
          lambdaP = lambda
          lambda = l + (1-c) * f * sinAlpha * (sigma + c * sinSigma * (cos2SigmaM + c * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)))
        end
        return NaN if iterLimit==0 #formula failed to converge

        uSq = cosSqAlpha * (a*a - b*b) / (b*b)
        a_bis = 1 + uSq/16384*(4096+uSq*(-768+uSq*(320-175*uSq)))
        b_bis = uSq/1024 * (256+uSq*(-128+uSq*(74-47*uSq)))
        deltaSigma = b_bis * sinSigma*(cos2SigmaM + b_bis/4*(cosSigma*(-1+2*cos2SigmaM*cos2SigmaM)- b_bis/6*cos2SigmaM*(-3+4*sinSigma*sinSigma)*(-3+4*cos2SigmaM*cos2SigmaM)))

        b*a_bis*(sigma-deltaSigma)
      end

      # Orthogonal Distance
      # Based http://www.allegro.cc/forums/thread/589720
      def orthogonal_distance(line, tail = nil)
        head, tail  = tail ?  [line, tail] : [line[0], line[-1]]
        a, b = @x - head.x, @y - head.y
        c, d = tail.x - head.x, tail.y - head.y

        dot = a * c + b * d
        len = c * c + d * d
        res = dot / len

        xx, yy = if res < 0
                   [head.x, head.y]
                 elsif res > 1
                   [tail.x, tail.y]
                 else
                   [head.x + res * c, head.y + res * d]
                 end
        # todo benchmark if worth creating an instance
        # euclidian_distance(Point.from_x_y(xx, yy))
        Math.sqrt((@x - xx) ** 2 + (@y - yy) ** 2)
      end

      #Bearing from a point to another, in degrees.
      def bearing_to(other)
        return 0 if self == other
        a,b =  other.x - self.x, other.y - self.y
        res =  Math.acos(b / Math.sqrt(a*a+b*b)) / Math::PI * 180;
        a < 0 ? 360 - res : res
      end

      #Bearing from a point to another as symbols. (:n, :s, :sw, :ne...)
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

      #Bounding box in 2D/3D. Returns an array of 2 points
      def bounding_box
        unless with_z
          [Point.from_x_y(@x,@y),Point.from_x_y(@x,@y)]
        else
          [Point.from_x_y_z(@x,@y,@z),Point.from_x_y_z(@x,@y,@z)]
        end
      end

      def m_range
        [@m,@m]
      end

      #tests the equality of the position of points + m
      def ==(other)
        return false unless other.kind_of?(Point)
        @x == other.x and @y == other.y and @z == other.z and @m == other.m
      end

      #binary representation of a point. It lacks some headers to be a valid EWKB representation.
      def binary_representation(allow_z=true,allow_m=true) #:nodoc:
        bin_rep = [@x.to_f,@y.to_f].pack("EE")
        bin_rep += [@z.to_f].pack("E") if @with_z and allow_z #Default value so no crash
        bin_rep += [@m.to_f].pack("E") if @with_m and allow_m #idem
        bin_rep
      end

      #WKB geometry type of a point
      def binary_geometry_type#:nodoc:
        1
      end

      #text representation of a point
      def text_representation(allow_z=true,allow_m=true) #:nodoc:
        tex_rep = "#{@x} #{@y}"
        tex_rep += " #{@z}" if @with_z and allow_z
        tex_rep += " #{@m}" if @with_m and allow_m
        tex_rep
      end

      #WKT geometry type of a point
      def text_geometry_type #:nodoc:
        "POINT"
      end

      #georss simple representation
      def georss_simple_representation(options) #:nodoc:
        georss_ns = options[:georss_ns] || "georss"
        geom_attr = options[:geom_attr]
        "<#{georss_ns}:point#{geom_attr}>#{y} #{x}</#{georss_ns}:point>\n"
      end

      #georss w3c representation
      def georss_w3cgeo_representation(options) #:nodoc:
        w3cgeo_ns = options[:w3cgeo_ns] || "geo"
        "<#{w3cgeo_ns}:lat>#{y}</#{w3cgeo_ns}:lat>\n<#{w3cgeo_ns}:long>#{x}</#{w3cgeo_ns}:long>\n"
      end

      #georss gml representation
      def georss_gml_representation(options) #:nodoc:
        georss_ns = options[:georss_ns] || "georss"
        gml_ns = options[:gml_ns] || "gml"
        result = "<#{georss_ns}:where>\n<#{gml_ns}:Point>\n<#{gml_ns}:pos>"
        result += "#{y} #{x}"
        result += "</#{gml_ns}:pos>\n</#{gml_ns}:Point>\n</#{georss_ns}:where>\n"
      end

      #outputs the geometry in kml format : options are <tt>:id</tt>, <tt>:tesselate</tt>, <tt>:extrude</tt>,
      #<tt>:altitude_mode</tt>. If the altitude_mode option is not present, the Z (if present) will not be output (since
      #it won't be used by GE anyway: clampToGround is the default)
      def kml_representation(options = {}) #:nodoc:
        result = "<Point#{options[:id_attr]}>\n"
        result += options[:geom_data] if options[:geom_data]
        result += "<coordinates>#{x},#{y}"
        result += ",#{options[:fixed_z] || z ||0}" if options[:allow_z]
        result += "</coordinates>\n"
        result += "</Point>\n"
      end

      # Outputs the geometry in coordinates format:
      # 47°52′48″, -20°06′00″
      def as_latlong(opts = { })
        val = []
        [x,y].each_with_index do |l,i|
          deg = l.to_i.abs
          min = (60 * (l.abs - deg)).to_i
          labs = (l * 1000000).abs / 1000000
          sec = ((((labs - labs.to_i) * 60) - ((labs - labs.to_i) * 60).to_i) * 100000) * 60 / 100000
          str = opts[:full] ? "%.i°%.2i′%05.2f″" :  "%.i°%.2i′%02.0f″"
          if opts[:coord]
            out = str % [deg,min,sec]
            if i == 0
              out += l > 0 ? "N" : "S"
            else
              out += l > 0 ? "E" : "W"
            end
            val << out
          else
            val << str % [l.to_i, min, sec]
          end
        end
        val.join(", ")
      end

      # Polar stuff
      #
      # http://www.engineeringtoolbox.com/converting-cartesian-polar-coordinates-d_1347.html
      # http://rcoordinate.rubyforge.org/svn/point.rb
      # outputs radium
      def r;      Math.sqrt(@x**2 + @y**2);      end

      # outputs theta
      def theta_rad
        if @x.zero?
          @y < 0 ? 3 * HALFPI : HALFPI
        else
          th = Math.atan(@y/@x)
          th += 2 * Math::PI if r > 0
        end
      end

      # outputs theta in degrees
      def theta_deg;        theta_rad / DEG2RAD;      end

      # outputs an array containing polar distance and theta
      def as_polar;        [r,t];      end

      # invert signal of all coordinates
      def -@
        set_x_y_z(-@x, -@y, -@z)
      end

      #creates a point from an array of coordinates
      def self.from_coordinates(coords,srid=DEFAULT_SRID,with_z=false,with_m=false)
        if ! (with_z or with_m)
          from_x_y(coords[0],coords[1],srid)
        elsif with_z and with_m
          from_x_y_z_m(coords[0],coords[1],coords[2],coords[3],srid)
        elsif with_z
          from_x_y_z(coords[0],coords[1],coords[2],srid)
        else
          from_x_y_m(coords[0],coords[1],coords[2],srid)
        end
      end

      #creates a point from the X and Y coordinates
      def self.from_x_y(x,y,srid=DEFAULT_SRID)
        point= new(srid)
        point.set_x_y(x,y)
      end

      #creates a point from the X, Y and Z coordinates
      def self.from_x_y_z(x,y,z,srid=DEFAULT_SRID)
        point= new(srid,true)
        point.set_x_y_z(x,y,z)
      end

      #creates a point from the X, Y and M coordinates
      def self.from_x_y_m(x,y,m,srid=DEFAULT_SRID)
        point= new(srid,false,true)
        point.m=m
        point.set_x_y(x,y)
      end

      #creates a point from the X, Y, Z and M coordinates
      def self.from_x_y_z_m(x,y,z,m,srid=DEFAULT_SRID)
        point= new(srid,true,true)
        point.m=m
        point.set_x_y_z(x,y,z)
      end

      #creates a point using polar coordinates
      #r and theta(degrees)
      def self.from_r_t(r,t,srid=DEFAULT_SRID)
        t *= DEG2RAD
        x = r * Math.cos(t)
        y = r * Math.sin(t)
        point= new(srid)
        point.set_x_y(x,y)
      end

      #creates a point using coordinates like 22`34 23.45N
      def self.from_latlong(lat,lon,srid=DEFAULT_SRID)
        p = [lat,lon].map do |l|
          sig, deg, min, sec, cen = l.scan(/(-)?(\d{1,2})\D*(\d{2})\D*(\d{2})(\D*(\d{1,3}))?/).flatten
          sig = true if l =~ /W|S/
          dec = deg.to_i + (min.to_i * 60 + "#{sec}#{cen}".to_f) / 3600
          sig ? dec * -1 : dec
        end
        point= new(srid)
        point.set_x_y(p[0],p[1])
      end

      #aliasing the constructors in case you want to use lat/lon instead of y/x
      class << self
        alias :xy               :from_x_y
        alias :xyz              :from_x_y_z
        alias :from_lon_lat_z   :from_x_y_z
        alias :from_lon_lat     :from_x_y
        alias :from_lon_lat_z   :from_x_y_z
        alias :from_lon_lat_m   :from_x_y_m
        alias :from_lon_lat_z_m :from_x_y_z_m
        alias :from_rad_tet     :from_r_t
      end
    end
  end
end
