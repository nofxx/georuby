require "geo_ruby/simple_features/geometry"

module GeoRuby
  module SimpleFeatures
    #Represents a line string as an array of points (see Point).
    class LineString < Geometry
      #the list of points forming the line string
      attr_reader :points

      def initialize(srid= DEFAULT_SRID,with_z=false,with_m=false)
        super(srid,with_z,with_m)
        @points=[]
      end

      #Delegate the unknown methods to the points array
      def method_missing(method_name,*args,&b)
        @points.send(method_name,*args,&b)
      end

      #tests if the line string is closed
      def is_closed
        #a bit naive...
        @points.first == @points.last
      end
      alias :closed? :is_closed

      def clockwise?
        tuples = @points.zip(
          @points[1..-1] + [@points[0]],
          @points[2..-1] + [@points[0], @points[1]])
        tuples.map!{ |a,b,c| b.x * (c.y - a.y)  }
        sum = tuples.inject(0.0){ |sum, elem| sum+elem }

        sum < 0.0
      end

      #Bounding box in 2D/3D. Returns an array of 2 points
      def bounding_box
        max_x, min_x, max_y, min_y = -Float::MAX, Float::MAX, -Float::MAX, Float::MAX
        if(with_z)
          max_z, min_z = -Float::MAX,Float::MAX
          each do |point|
            max_y = point.y if point.y > max_y
            min_y = point.y if point.y < min_y
            max_x = point.x if point.x > max_x
            min_x = point.x if point.x < min_x
            max_z = point.z if point.z > max_z
            min_z = point.z if point.z < min_z
          end
          [Point.from_x_y_z(min_x,min_y,min_z),Point.from_x_y_z(max_x,max_y,max_z)]
        else
          each do |point|
            max_y = point.y if point.y > max_y
            min_y = point.y if point.y < min_y
            max_x = point.x if point.x > max_x
            min_x = point.x if point.x < min_x
          end
          [Point.from_x_y(min_x,min_y),Point.from_x_y(max_x,max_y)]
        end
      end

      def m_range
        if with_m
          max_m, min_m = -Float::MAX, Float::MAX
          each do |point|
            max_m = point.m if point.m > max_m
            min_m = point.m if point.m < min_m
          end
          [min_m,max_m]
        else
          [0,0]
        end
      end

     #call to native Geo intersect, return true or false
      def intersects?(other_line_string)

      end

      def spherical_distance
        total = 0
        @points.each_with_index do |p,i|
          total += p.spherical_distance(@points[i+1]) if @points[i+1]
        end
        total
      end

      def euclidian_distance
        total = 0
        @points.each_with_index do |p,i|
          total += p.euclidian_distance(@points[i+1]) if @points[i+1]
        end
        total
      end

      #Tests the equality of line strings
      def ==(other_line_string)
        if(other_line_string.class != self.class or
             other_line_string.length != self.length)
          false
        else
          index=0
          while index<length
            return false if self[index] != other_line_string[index]
            index+=1
          end
          true
        end
      end

      #Binary representation of a line string
      def binary_representation(allow_z=true,allow_m=true) #:nodoc:
        rep = [length].pack("V")
        each {|point| rep << point.binary_representation(allow_z,allow_m) }
        rep
      end

      #WKB geometry type
      def binary_geometry_type #:nodoc:
        2
      end

      #Text representation of a line string
      def text_representation(allow_z=true,allow_m=true) #:nodoc:
        @points.collect{|point| point.text_representation(allow_z,allow_m) }.join(",")
      end
      #WKT geometry type
      def text_geometry_type #:nodoc:
        "LINESTRING"
      end

      #georss simple representation
      def georss_simple_representation(options) #:nodoc:
        georss_ns = options[:georss_ns] || "georss"
        geom_attr = options[:geom_attr]
        "<#{georss_ns}:line#{geom_attr}>" + georss_poslist + "</#{georss_ns}:line>\n"
      end
      #georss w3c representation : outputs the first point of the line
      def georss_w3cgeo_representation(options) #:nodoc:
        w3cgeo_ns = options[:w3cgeo_ns] || "geo"
        "<#{w3cgeo_ns}:lat>#{self[0].y}</#{w3cgeo_ns}:lat>\n<#{w3cgeo_ns}:long>#{self[0].x}</#{w3cgeo_ns}:long>\n"
      end
      #georss gml representation
      def georss_gml_representation(options) #:nodoc:
        georss_ns = options[:georss_ns] || "georss"
        gml_ns = options[:gml_ns] || "gml"

        result = "<#{georss_ns}:where>\n<#{gml_ns}:LineString>\n<#{gml_ns}:posList>\n"
        result += georss_poslist
        result += "\n</#{gml_ns}:posList>\n</#{gml_ns}:LineString>\n</#{georss_ns}:where>\n"
      end

      def georss_poslist #:nodoc:
        map {|point| "#{point.y} #{point.x}"}.join(" ")
      end

      #outputs the geometry in kml format : options are <tt>:id</tt>, <tt>:tesselate</tt>, <tt>:extrude</tt>,
      #<tt>:altitude_mode</tt>. If the altitude_mode option is not present, the Z (if present) will not be output (since
      #it won't be used by GE anyway: clampToGround is the default)
      def kml_representation(options = {}) #:nodoc:
        result = "<LineString#{options[:id_attr]}>\n"
        result += options[:geom_data] if options[:geom_data]
        result += "<coordinates>"
        result += kml_poslist(options)
        result += "</coordinates>\n"
        result += "</LineString>\n"
      end

      def kml_poslist(options) #:nodoc:
        pos_list = if options[:allow_z]
           map {|point| "#{point.x},#{point.y},#{options[:fixed_z] || point.z || 0}" }
        else
          map {|point| "#{point.x},#{point.y}" }
        end
        pos_list.reverse! if(options[:reverse])
        pos_list.join(" ")
      end

      # Simplify linestring (Douglas Peucker Algorithm)
      # http://en.wikipedia.org/wiki/Ramer-Douglas-Peucker_algorithm
      def simplify(epsilon=1)
        LineString.from_points(do_simplify(@points, epsilon))
      end

      def do_simplify(list, epsilon)
        index = dmax = 0
        2.upto(list.length - 1) do |i|
          d = list[i].orthogonal_distance(list[0], list[-1])
          index, dmax = i, d if d > dmax
        end

        if dmax >= epsilon
          res1 = do_simplify(list[0..index], epsilon)
          res2 = do_simplify(list[index..-1], epsilon)
          res1[0..-2] + res2[0..-1]
        else
          [list[0], list[-1]]
        end
      end

      def to_coordinates
        points.map{|p| p.to_coordinates }
      end

      def as_json(options = {})
        {:type => 'LineString',
         :coordinates => self.to_coordinates}
      end

      # simple geojson representation
      # TODO add CRS / SRID support?
      def to_json(options = {})
        as_json(options).to_json(options)
      end
      alias :as_geojson :to_json

      #Creates a new line string. Accept an array of points as argument
      def self.from_points(points,srid=DEFAULT_SRID,with_z=false,with_m=false)
        line_string = new(srid,with_z,with_m)
        line_string.concat(points)
        line_string
      end

      #Creates a new line string. Accept a sequence of points as argument : ((x,y)...(x,y))
      def self.from_coordinates(points,srid=DEFAULT_SRID,with_z=false,with_m=false)
        line_string = new(srid,with_z,with_m)
        line_string.concat( points.map {|p| Point.from_coordinates(p,srid,with_z,with_m) } )
        line_string
      end
    end
  end
end
