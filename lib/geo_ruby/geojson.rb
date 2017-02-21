# GeoJSON parser based on the v1.0 spec at http://geojson.org/geojson-spec.html
require 'rubygems'
begin
  require 'json'
rescue LoadError
  puts "You've loaded GeoRuby GeoJSON Support."
  puts "Please install any 'json' provider gem. `gem install json`"
end

module GeoRuby
  # Raised when an error in the GeoJSON string is detected
  class GeoJSONFormatError < StandardError
  end

  # Class added to support geojson 'Feature' objects
  class GeoJSONFeature
    attr_accessor :geometry, :properties, :id

    def initialize(geometry, properties = {}, id = nil)
      @geometry = geometry
      @properties = properties
      @id = id
    end

    def ==(other)
      if (self.class != other.class)
        false
      else
        (id == other.id) &&
          (geometry == other.geometry) &&
          (properties == other.properties)
      end
    end

    def to_json(options = {})
      output = {}
      output[:type] = 'Feature'
      output[:geometry] = geometry
      output[:properties] = properties
      output[:id] = id unless id.nil?
      output.to_json(options)
    end
    alias_method :as_geojson, :to_json
  end

  # Class added to support geojson 'Feature Collection' objects
  class GeoJSONFeatureCollection
    attr_accessor :features

    def initialize(features)
      @features = features
    end

    def ==(other)
      if (self.class != other.class) || (features.size != other.features.size)
        return false
      else
        features.each_index do |index|
          return false if features[index] != other.features[index]
        end
      end
      true
    end

    def to_json(options = {})
      ({ type: 'FeatureCollection', features: features }).to_json(options)
    end
    alias_method :as_geojson, :to_json
  end

  # GeoJSON main parser
  class GeoJSONParser
    include GeoRuby::SimpleFeatures
    attr_reader :geometry

    def parse(geojson, srid = DEFAULT_SRID)
      @geometry = nil
      geohash = JSON.parse(geojson)
      parse_geohash(geohash, srid)
    end

    private

    def parse_geohash(geohash, srid)
      srid = srid_from_crs(geohash['crs']) || srid
      case geohash['type']
      when 'Point', 'MultiPoint', 'LineString', 'MultiLineString', 'Polygon',
           'MultiPolygon', 'GeometryCollection'
        @geometry = parse_geometry(geohash, srid)
      when 'Feature'
        @geometry = parse_geojson_feature(geohash, srid)
      when 'FeatureCollection'
        @geometry = parse_geojson_feature_collection(geohash, srid)
      else
        fail GeoJSONFormatError, 'Unknown GeoJSON type'
      end
    end

    def parse_geometry(geohash, srid)
      srid = srid_from_crs(geohash['crs']) || srid
      if geohash['type'] == 'GeometryCollection'
        parse_geometry_collection(geohash, srid)
      else
        klass = GeoRuby::SimpleFeatures.const_get(geohash['type'])
        klass.from_coordinates(geohash['coordinates'], srid, false, false)
      end
    end

    def parse_geometry_collection(geohash, srid)
      srid = srid_from_crs(geohash['crs']) || srid
      geometries = geohash['geometries'].map { |g| parse_geometry(g, srid) }
      GeometryCollection.from_geometries(geometries, srid)
    end

    def parse_geojson_feature(geohash, srid)
      srid = srid_from_crs(geohash['crs']) || srid
      geometry = parse_geometry(geohash['geometry'], srid)
      GeoJSONFeature.new(geometry, geohash['properties'], geohash['id'])
    end

    def parse_geojson_feature_collection(geohash, srid)
      srid = srid_from_crs(geohash['crs']) || srid
      features = []
      geohash['features'].each do |feature|
        features << parse_geojson_feature(feature, srid)
      end
      GeoJSONFeatureCollection.new(features)
    end

    def srid_from_crs(crs)
      # We somehow need to map crs to srid, currently only support for EPSG
      if crs && crs['type'] == 'OGC'
        urn = crs['properties']['urn'].split(':')
        return urn.last if urn[4] == 'EPSG'
      end
      nil
    end
  end # GeoJSONParser
end # GeoRuby
