require 'rexml/parsers/pullparser'
module GeoRuby
  class KmlParser
    ELEMENT_MAP = {
      # "Point" => SimpleFeatures::Point, # we don't need to map points.  they are done automatically by the coordinate parsing
      "LineString" => SimpleFeatures::LineString,
      "LinearRing" => SimpleFeatures::LinearRing,
      "Polygon" => SimpleFeatures::Polygon,
      "MultiGeometry" => SimpleFeatures::GeometryCollection
    }
    def initialize(factory)
      @factory = factory
      @buffer = ""
      @with_z = false
    end
    # argument should be a valid kml geometry fragment ie. <Point> .... </Point>
    # returns the GeoRuby geometry object back
    def parse(kml)
      @factory.reset
      @with_z = false
      @parser = REXML::Parsers::PullParser.new(kml)
      while @parser.has_next?
        e = @parser.pull
        if e.start_element?
          if(type = ELEMENT_MAP[e[0]])
            @factory.begin_geometry(type)
          else
            @buffer = "" if(e[0] == "coordinates") # clear the buffer
            accumulate_start(e)
          end
        elsif e.end_element?
          if(ELEMENT_MAP[e[0]])
            @factory.end_geometry(@with_z)
            @buffer = "" # clear the buffer
          else
            accumulate_end(e)
            if(e[0] == "coordinates")
              parse_coordinates(@buffer)
              @buffer = "" # clear the buffer
            end
          end
        elsif e.text? 
          accumulate_text(e)
        elsif e.cdata?
          accumulate_cdata(e)
        end
      end
      @factory.geometry.dup
    end
    
    private      
    def accumulate_text(e); @buffer << e[0]; end
    def accumulate_cdata(e); @buffer << "<![CDATA[#{e[0]}]]>"; end
    def accumulate_start(e)
      @buffer << "<#{e[0]}"
      if(e[1].class == Hash)
        e[1].each_pair {|k,v| @buffer << " #{k}='#{v}'" }
      end
      @buffer << ">"
    end
    def accumulate_end(e); @buffer << "</#{e[0]}>"; end
    
    def parse_coordinates(buffer)
      if(buffer =~ /<coordinates>(.+)<\/coordinates>/)
        $1.gsub(/\n/, " ").strip.split(/\s+/).each do |coord|
          x,y,z = coord.split(',')
          if(x.nil? || y.nil?) 
            raise StandardError, "coordinates must have at least x and y elements"
          end
          @factory.begin_geometry(SimpleFeatures::Point)
          if(z.nil?)
            @factory.add_point_x_y(x,y)
          else
            @factory.add_point_x_y_z(x,y,z)
            @with_z = true unless @with_z # is the conditional even necessary
          end
          @factory.end_geometry(@with_z)
        end
      end
    rescue
      raise StandardError, "error parsing coordinates: check your kml for errors"
    end
  end
end